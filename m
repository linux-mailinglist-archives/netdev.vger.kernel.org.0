Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524514E771B
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 16:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376467AbiCYP1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 11:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378137AbiCYPY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 11:24:56 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62302ECB04
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 08:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648221591; x=1679757591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EQjLhGdwM/AVQt8pAHlMRp95YM5KLVS8gUm1lb44lUs=;
  b=sa6+p6UQl2+ulxIQJRlEZZ2odmoFaZm/mLc1mvz6b4Sf5KWocsmPsRn3
   jkhFmVwep9/j56VPuV3eEvASbXTy9vocfpuqO2s9cRnSGVJ++GK+3dWFl
   t1ZIRehj49uRhYj70OULNu7/qjqKUh2n5quCPrtGaeftm7av16TZJjwZJ
   smWhzo51n5bp/e7RjG3Oe2zZy5TZuEk0dfi/2D3IrqFDXTjsCQUi3IOl/
   cs6QFjad73U8bpMAy2pTLuZrlTkjY2SMn0N5wLtezZuBr0534Mf7Ozzqq
   QzcX4JnTX4ouedYkrWoDOHYtPjvwpWCLolWa6ID+bL1DeB/pmJumsvgxL
   A==;
X-IronPort-AV: E=Sophos;i="5.90,209,1643698800"; 
   d="scan'208";a="158169562"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2022 08:19:39 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 25 Mar 2022 08:19:39 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 25 Mar 2022 08:19:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpPjX1JXa8x4dGljHnDOvH98KnN8CZZ+egFnjX9QIsrC2pAPux8KXFKPcY7+puWWQfZl2y28Ch6MwHUQikt1O/SuRiOukrfMOnRhu8hyTkAZrxK1FXreImvwUZ0WQyUhHhr+O0TXvU44mHGks/ZUMNc8iDP2s+AxpO5HROdqdnxxGB2ZiV/wmXnkvp7zDgjVDOlSMS2Mxz+WmVCSAdz6X/nWPu4+qEN9Pb+G7pgumMwTBL9yqGu/if719K341BdQehN/o1VLjyAESIwX2pZQGvtGEBfRdYutjtjpWy/yBuOoaWb5wN9sm1K3Q+0450O9odmvGW1rGvXH8ekbJZv+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQjLhGdwM/AVQt8pAHlMRp95YM5KLVS8gUm1lb44lUs=;
 b=F4+ZHZ+mOd/JgbVFCpf6LE2WULTHFTR3hoplg2LO+L7u86KP0EStTFCrexxZiaxabx47W3GgYK+TcM5cmnKMDZdbjY+fg3RNsKQuno3ob+eJoOvzJdGW5MDCT32v4iYcqpl+HZ9Vk+KVVxRUry/paF5v6xsfwcxQezBMdhT/W8oJwk0L6Zo8FMGDkkEWM3HEEYy+8E0166ZN06mokjVn1BYn/mqkeTnwwyQPck2nh5KE11JqG1fP7KHFJ5iKhe8Eh31Q3JQHLHKxZMIjWRaQsdCa4TRr7GGlyUlf1Kkl6qeIqCz39V2uXjGGE3bO8vAPydA2VmEhOuQpu7ENAVWObw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQjLhGdwM/AVQt8pAHlMRp95YM5KLVS8gUm1lb44lUs=;
 b=axd47ZjH4CdfCUvbtmuRZ+E5otsyw7b+9jWjNlpww5X3VugoJgbD+T9uncx6jN0MIHyFZ7DCbGQNTbqXrO5NB15dm5wff2GCNMcf7eG4kmTIQMCuUNor/AnA/P+Ir8io1dwy9kP4JFrlP9cu1zo2QDMoaZci2pnGG9Z/yeVSH9A=
Received: from CO1PR11MB4769.namprd11.prod.outlook.com (2603:10b6:303:91::21)
 by MN2PR11MB4096.namprd11.prod.outlook.com (2603:10b6:208:138::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Fri, 25 Mar
 2022 15:19:31 +0000
Received: from CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b]) by CO1PR11MB4769.namprd11.prod.outlook.com
 ([fe80::6d66:3f1d:7b05:660b%6]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 15:19:31 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <tomas.melin@vaisala.com>, <netdev@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Thread-Topic: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Thread-Index: AQHYQCZQfBYaRO5M1UGfluJdpjZcjQ==
Date:   Fri, 25 Mar 2022 15:19:31 +0000
Message-ID: <82276bf7-72a5-6a2e-ff33-f8fe0c5e4a90@microchip.com>
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
 <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
 <7310fea8-8f55-a198-5317-a7ad95980beb@vaisala.com>
 <b643b825-e68a-875e-f4ac-edddae613705@microchip.com>
 <9aa5766c-c94d-e468-d790-51712c6697df@vaisala.com>
In-Reply-To: <9aa5766c-c94d-e468-d790-51712c6697df@vaisala.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b7fbee1-dd40-411a-776f-08da0e72dcc0
x-ms-traffictypediagnostic: MN2PR11MB4096:EE_
x-microsoft-antispam-prvs: <MN2PR11MB40961537F9B4CF9BB101C07D871A9@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qgVosvJJM+0FpMWxQr8vKktGzHCH4pRftEruAc9eTk9mjf7xfyFx2zPp90eb36SEiQjh0l4jx4q8lgmKI6AyWD8i7ODbgGXYo1L1qLta/YTqCobs8LNTn1WDd0x5PxypzmbceaQ9bYSiq8x4tTXqly5GTQM+6TXeeVrkGJ93pClPOsME1bA6kNdy8n+PKcck/NdBq0y3bC2sqjHMwuOH7TWE5F6D3MQUhJZ6MeP65p9w3pgSgI8duZD757lX6y+yCUf5gU2NWX1sD74/DQudw35KKCxjMMLB7fmaXw+ToOWMq6Lszuy/JsVZJFE2iB4KFlQR6KNvWodyZbbHIWl2LUZcmMuPD+pvBsT/2E/HoR2yXdu/OEKM0BnIBIjeivPcSkmEKFiMocyR4UyYOa41JDZVWsR3KQBZaHH3xCk40Utj8VJjxvd66k0oza5amild+MPx/R3ewESdTaMSZSqq3yQHVK9I5ZfNT66dqptAgCUBRJJKFTEHTV/gbjY1FRDdLmfuYiyP05erajdjna3LxiqL8k0clh5prdZEiNCeO4TSdfX4eNnmq5CImQoGawmRN/WIrHOeAspAQiPrkXUPS7f1B+SMx8SFdI8hD/RC07t/t8e2dZ8TJxhctgxfOhuDiLAyX7O/l1X44sNVIlWT5yePmiiMSrZ7+G68d5vT9RhtBYitV8Z2uu5DZjSES/pVs/zSsWIAIhKyxhW3/2BtCWrOTt7Kgayn8Ld6bLi6f4xqCOq3eous1Fex0DspZm+/oyKb3esfMznV4bktbgBLOunjVgHTCLrJcvIeZWVQulyoh2OSD2Ig+9tWHcH+lTkl6CSadf1SUdnMsT3seBlEpHVf3PHQ7HJX6+cGP37YR3ixAr4z+RSRRjPaPTPbOuwM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4769.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(26005)(38100700002)(66446008)(316002)(8676002)(76116006)(64756008)(66946007)(66476007)(6512007)(4326008)(6486002)(966005)(86362001)(2616005)(91956017)(6506007)(38070700005)(186003)(71200400001)(110136005)(83380400001)(31696002)(54906003)(66556008)(45080400002)(508600001)(122000001)(2906002)(8936002)(5660300002)(31686004)(36756003)(45980500001)(43740500002)(10090945011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ek9SVkJxY0N2UFlybnJoa3NBYkJ2bjg0MU1PSlp5VXlTaWdPN2kybnlSUy9G?=
 =?utf-8?B?aHBQTjR5M0RDZGIvdG55M1RsUjgyMWVzVGp4MkRTRVo3cGVQTlBpem5wWFJ0?=
 =?utf-8?B?c1kwc09oYjdMVkI4bXJWLzZ1VjRLVHhycXBRZnVHNUd4bDNEMzRJMUVZK1dh?=
 =?utf-8?B?aGpNQ3o4TkcvNWlCMTRkLzJqR0FXaDR2dnk5TnhVMFhQWTlGZStCUG1KeGY1?=
 =?utf-8?B?Slh5Nm9KSnpCWUpiVnVkMi95c1FJRHcyeEhBOCs3bCtDYW5BbytMdkZPc2NF?=
 =?utf-8?B?Nm1uQTdoeVE2OExwb0ppQ0NIRlhWVGFOU1N1eHllam4rS0xrNnJaWTViUDNo?=
 =?utf-8?B?S09VNVo4bDdISzY1aW9WVUVxdkplQ01ubFJRRk12K0dLM0NMYk5ON2lVdVNq?=
 =?utf-8?B?N2ZoVVgwY0pONkV0eVZzUjZJSTY0ejNuRWcrakVDMU9xNlhwemxMQzY1NXMx?=
 =?utf-8?B?Q1lVMStacU16dzE3RmEyZnBGaisrR3RwSGppNmxpcXZ6VWg1dGlQL3hZbmpR?=
 =?utf-8?B?clVkeVdOMTJpYSsxOWN4RDhGWEZ4UlQwaThSWHlhc3NwSjdoeWpUYTNsa0Zk?=
 =?utf-8?B?OVZVV1daTEs3L0pmZjVNM005WDlYOEpxeUpLRWZGNUNRUVhudlIyWFFkMi9L?=
 =?utf-8?B?OXc5Tk90L3YvRVNDK3E3L2VPd2FrbFpWeWZJVCs4RFd6OEw4UDJGSnFGOFlw?=
 =?utf-8?B?L0lBOUV2NmdMV3k4Q0p2Z3huOEh4a0JuS3BWNHZ4dlJ5S0pUbGJLcVVHRFh0?=
 =?utf-8?B?aDQ1YTRFc000bUt4L1R4M21HWGFObmJwL2Nibmc2TkE2R2lCeVdZZ3JocnZ5?=
 =?utf-8?B?aGZ0azBDYXhWTkNsemdnclo4Z0NPNU1rWitOVmlHRERNb3VidG81cGZ3NGhM?=
 =?utf-8?B?dmFHdW14NzhSdkFnVFh3QkM5aGhkS1ZCQkhoTkxxT2RYOXNsSDIyaktpS2w3?=
 =?utf-8?B?T2RnT2tiMEdTU0F1WHkzU2w5UEQ5cnJjK0FFazAwakhCTmlKWHQybzUrU2ZS?=
 =?utf-8?B?SFJuQ1FMU2gvR0h0UEdnZElySDVQcnRXbzY1TVNFd0twWWlNUFFKbkVJckJO?=
 =?utf-8?B?V3ZxeG54bFc2Q2VSeUNJbUpTalZZS0VYeHpVUHlFeWFvTk1EU3FYRHZYRitz?=
 =?utf-8?B?NXlKbGhodzIvbzB1TVZIZzFGN1JhVXcwcVlnT1grOVBiV09GR1hzUjRMd2xY?=
 =?utf-8?B?S09sbjJYY2VWU0k5aXVCQVU1N1RvN25ZT3lPeWxVaUcvZFlVWThJOVpyR2Rk?=
 =?utf-8?B?YTdZVWdtSHE3bldxZlpDYTBWTXcxaXVnMnpWcmh0TTJpRExjRXFOM1JVaUpl?=
 =?utf-8?B?SlZ3L3ZtTm1LdXJyaS95RGxhL3VKdTMyZ0Y3UkFEZUlCNGticUpRakw3aHZD?=
 =?utf-8?B?RW4vY3NVbm93UHV2VktZQ1hqd3E0WU0yTGRJaXYwblVBRDdaRER3NVJCVkdQ?=
 =?utf-8?B?RC9zbHpjd0t1QzJiM2FhS2g3WkNYTWUwUEFmL0JyVnQ5alFHVkFsV2tMcEpz?=
 =?utf-8?B?OGlsNUhFNTlLSG9yUHpFRWE1MXJucXRyTktYZmhLM0t6TWQzZE9MUytsWGhH?=
 =?utf-8?B?VElPaEdKbHRLcUtzOWZ0OThVekhGbjFnb1lPeWFwZmFvL2JFZnBZL1A3Q2li?=
 =?utf-8?B?U0VtOTM1bDVZNXk4UHA3aHB0UVM0R0pEWFBsdkdTUUE2Q1dKelpMOHhOSGxq?=
 =?utf-8?B?VDE4RWdTb3lmTjMzdTVYdE5nZkVvTEJjNjBjcjR6WEx2eENWV0lVTmhSMk5l?=
 =?utf-8?B?N2VkT1BmdTZNTmhJK0lva2dsTmtLWFJKQnB0bkdKcFBlOVp0ZkJuUVV6SkZ6?=
 =?utf-8?B?Mm9IYmhZaUhsRHloOG9YTkloc0lyOUFXREtua0lmQzJlZmNwaWRsM1UrWGFD?=
 =?utf-8?B?MXZWV080WTVUUUdtSXN4WGE2RWliREpTZmxJdmpvN0tpL1hSVGNYcFl4MUlj?=
 =?utf-8?B?UXJnd2N1S3ZvanVKeGVGN1FrRERXVUhUc1ZtckpDc1FoeXRLRzBlTmMxUUwx?=
 =?utf-8?B?Sit0S2RmWEx2aHZmcFh3Nzc3VEpnMUZqNDdMdWlmOVZGdzQxRWVVcThGZDZy?=
 =?utf-8?B?cyswSnZmeWdoU1ZzenU4QjhzSVZKV1A0MEpnSzZkQ1VEeGxYRmR3cUdrRUx2?=
 =?utf-8?B?aUI1T1ZHaFZzTUE4V1k3UHhGT28ycUtVTi9KeWNTNDhKTEQvYVZDc1k3eEV6?=
 =?utf-8?B?SForSUFsbjdsd29MT0d3N2lkSGpUMUp6UDhQV0s2aTZKWDg5OXhFKzBWUUsz?=
 =?utf-8?B?enN4NkJuSWR3ZjlFRnBwSnZHcmV3TG5CMXZPaWp4QXNxZmJIeWh5QUkzSG1s?=
 =?utf-8?B?TVNheGRKQ05NS1NmR3JqSHdVWWR4alpFUFN6a3l1dzlScEZsejZlbEl0VHVB?=
 =?utf-8?Q?F8dOiOnI4sdHAiXg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DAC086DEA71BD40B9335292B2CBF60F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4769.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b7fbee1-dd40-411a-776f-08da0e72dcc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2022 15:19:31.7914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ONDlnbQlKmwR0HEDoY9+aL2r+4/+EbHGUnK7rz7V/qQFWtuUYFuHbWDJdSBHPwWyGqUGLU1y+CHFCE/wzMyGbivZgNQBN1dAUSPhd6ln0SA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCk9uIDI1LjAzLjIwMjIgMTY6NDEsIFRvbWFzIE1lbGluIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZQ0KPiBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpLA0KPiANCj4gT24gMjUvMDMv
MjAyMiAxNTo0MSwgQ2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IE9uIDI1
LjAzLjIwMjIgMTE6MzUsIFRvbWFzIE1lbGluIHdyb3RlOg0KPj4+IEVYVEVSTkFMIEVNQUlMOiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhl
DQo+Pj4gY29udGVudCBpcyBzYWZlDQo+Pj4NCj4+PiBIaSwNCj4+Pg0KPj4+IE9uIDI1LzAzLzIw
MjIgMTA6NTcsIENsYXVkaXUuQmV6bmVhQG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+Pj4+IE9uIDI1
LjAzLjIwMjIgMDg6NTAsIFRvbWFzIE1lbGluIHdyb3RlOg0KPj4+Pj4gW1NvbWUgcGVvcGxlIHdo
byByZWNlaXZlZCB0aGlzIG1lc3NhZ2UgZG9uJ3Qgb2Z0ZW4gZ2V0IGVtYWlsIGZyb20NCj4+Pj4+
IHRvbWFzLm1lbGluQHZhaXNhbGEuY29tLiBMZWFybiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQN
Cj4+Pj4+IGh0dHA6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9uLl0NCj4+
Pj4+DQo+Pj4+PiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0
YWNobWVudHMgdW5sZXNzIHlvdSBrbm93DQo+Pj4+PiB0aGUgY29udGVudCBpcyBzYWZlDQo+Pj4+
Pg0KPj4+Pj4gY29tbWl0IDVlYTljMDhhODY5MiAoIm5ldDogbWFjYjogcmVzdGFydCB0eCBhZnRl
ciB0eCB1c2VkIGJpdCByZWFkIikNCj4+Pj4+IGFkZGVkIHN1cHBvcnQgZm9yIHJlc3RhcnRpbmcg
dHJhbnNtaXNzaW9uLiBSZXN0YXJ0aW5nIHR4IGRvZXMgbm90IHdvcmsNCj4+Pj4+IGluIGNhc2Ug
Y29udHJvbGxlciBhc3NlcnRzIFRYVUJSIGludGVycnVwdCBhbmQgVFFCUCBpcyBhbHJlYWR5IGF0
IHRoZSBlbmQNCj4+Pj4+IG9mIHRoZSB0eCBxdWV1ZS4gSW4gdGhhdCBzaXR1YXRpb24sIHJlc3Rh
cnRpbmcgdHggd2lsbCBpbW1lZGlhdGVseSBjYXVzZQ0KPj4+Pj4gYXNzZXJ0aW9uIG9mIGFub3Ro
ZXIgVFhVQlIgaW50ZXJydXB0LiBUaGUgZHJpdmVyIHdpbGwgZW5kIHVwIGluIGFuDQo+Pj4+PiBp
bmZpbml0ZQ0KPj4+Pj4gaW50ZXJydXB0IGxvb3Agd2hpY2ggaXQgY2Fubm90IGJyZWFrIG91dCBv
Zi4NCj4+Pj4+DQo+Pj4+PiBGb3IgY2FzZXMgd2hlcmUgVFFCUCBpcyBhdCB0aGUgZW5kIG9mIHRo
ZSB0eCBxdWV1ZSwgaW5zdGVhZA0KPj4+Pj4gb25seSBjbGVhciBUWFVCUiBpbnRlcnJ1cHQuIEFz
IG1vcmUgZGF0YSBnZXRzIHB1c2hlZCB0byB0aGUgcXVldWUsDQo+Pj4+PiB0cmFuc21pc3Npb24g
d2lsbCByZXN1bWUuDQo+Pj4+Pg0KPj4+Pj4gVGhpcyBpc3N1ZSB3YXMgb2JzZXJ2ZWQgb24gYSBY
aWxpbnggWnlucSBiYXNlZCBib2FyZC4gRHVyaW5nIHN0cmVzcw0KPj4+Pj4gdGVzdCBvZg0KPj4+
Pj4gdGhlIG5ldHdvcmsgaW50ZXJmYWNlLCBkcml2ZXIgd291bGQgZ2V0IHN0dWNrIG9uIGludGVy
cnVwdCBsb29wDQo+Pj4+PiB3aXRoaW4gc2Vjb25kcyBvciBtaW51dGVzIGNhdXNpbmcgQ1BVIHRv
IHN0YWxsLg0KPj4+Pj4NCj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFRvbWFzIE1lbGluIDx0b21hcy5t
ZWxpbkB2YWlzYWxhLmNvbT4NCj4+Pj4+IC0tLQ0KPj4+Pj4gwqDCoCBkcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jIHwgOCArKysrKysrKw0KPj4+Pj4gwqDCoCAxIGZpbGUg
Y2hhbmdlZCwgOCBpbnNlcnRpb25zKCspDQo+Pj4+Pg0KPj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4+Pj4+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4+Pj4gaW5kZXggODAwZDVjZWQ1ODAwLi5l
NDc1YmUyOTg0NWMgMTAwNjQ0DQo+Pj4+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRl
bmNlL21hY2JfbWFpbi5jDQo+Pj4+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jDQo+Pj4+PiBAQCAtMTY1OCw2ICsxNjU4LDcgQEAgc3RhdGljIHZvaWQgbWFj
Yl90eF9yZXN0YXJ0KHN0cnVjdCBtYWNiX3F1ZXVlDQo+Pj4+PiAqcXVldWUpDQo+Pj4+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IGhlYWQgPSBxdWV1ZS0+dHhfaGVhZDsNCj4+Pj4+
IMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBpbnQgdGFpbCA9IHF1ZXVlLT50eF90YWlsOw0K
Pj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBtYWNiICpicCA9IHF1ZXVlLT5icDsNCj4+
Pj4+ICvCoMKgwqDCoMKgwqAgdW5zaWduZWQgaW50IGhlYWRfaWR4LCB0YnFwOw0KPj4+Pj4NCj4+
Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBpZiAoYnAtPmNhcHMgJiBNQUNCX0NBUFNfSVNSX0NMRUFS
X09OX1dSSVRFKQ0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBxdWV1
ZV93cml0ZWwocXVldWUsIElTUiwgTUFDQl9CSVQoVFhVQlIpKTsNCj4+Pj4+IEBAIC0xNjY1LDYg
KzE2NjYsMTMgQEAgc3RhdGljIHZvaWQgbWFjYl90eF9yZXN0YXJ0KHN0cnVjdCBtYWNiX3F1ZXVl
DQo+Pj4+PiAqcXVldWUpDQo+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKGhlYWQgPT0gdGFp
bCkNCj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuOw0KPj4+
Pj4NCj4+Pj4+ICvCoMKgwqDCoMKgwqAgdGJxcCA9IHF1ZXVlX3JlYWRsKHF1ZXVlLCBUQlFQKSAv
IG1hY2JfZG1hX2Rlc2NfZ2V0X3NpemUoYnApOw0KPj4+Pj4gK8KgwqDCoMKgwqDCoCB0YnFwID0g
bWFjYl9hZGpfZG1hX2Rlc2NfaWR4KGJwLCBtYWNiX3R4X3Jpbmdfd3JhcChicCwgdGJxcCkpOw0K
Pj4+Pj4gK8KgwqDCoMKgwqDCoCBoZWFkX2lkeCA9IG1hY2JfYWRqX2RtYV9kZXNjX2lkeChicCwg
bWFjYl90eF9yaW5nX3dyYXAoYnAsDQo+Pj4+PiBoZWFkKSk7DQo+Pj4+PiArDQo+Pj4+PiArwqDC
oMKgwqDCoMKgIGlmICh0YnFwID09IGhlYWRfaWR4KQ0KPj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuOw0KPj4+Pj4gKw0KPj4+Pg0KPj4+PiBUaGlzIGxvb2tzIGxpa2Ug
VEJRUCBpcyBub3QgYWR2YW5jaW5nIHRob3VnaCB0aGVyZSBhcmUgcGFja2V0cyBpbiB0aGUNCj4+
Pj4gc29mdHdhcmUgcXVldWVzIChoZWFkICE9IHRhaWwpLiBQYWNrZXRzIGFyZSBhZGRlZCBpbiB0
aGUgc29mdHdhcmUNCj4+Pj4gcXVldWVzIG9uDQo+Pj4+IFRYIHBhdGggYW5kIHJlbW92ZWQgd2hl
biBUWCB3YXMgZG9uZSBmb3IgdGhlbS4NCj4+Pg0KPj4+IFRCUVAgaXMgYXQgdGhlIGVuZCBvZiB0
aGUgcXVldWUsIGFuZCB0aGF0IG1hdGNoZXMgd2l0aCB0eF9oZWFkDQo+Pj4gbWFpbnRhaW5lZCBi
eSBkcml2ZXIuIFNvIHNlZW1zIGNvbnRyb2xsZXIgaXMgaGFwcGlseSBhdCBlbmQgbWFya2VyLA0K
Pj4+IGFuZCB3aGVuIHJlc3RhcnRlZCBpbW1lZGlhdGVseSBzZWVzIHRoYXQgZW5kIG1hcmtlciB1
c2VkIHRhZyBhbmQNCj4+PiB0cmlnZ2VycyBhbiBpbnRlcnJ1cHQgYWdhaW4uDQo+Pj4NCj4+PiBB
bHNvIHdoZW4gbG9va2luZyBhdCB0aGUgYnVmZmVyIGRlc2NyaXB0b3IgbWVtb3J5IGl0IHNob3dz
IHRoYXQgYWxsDQo+Pj4gZnJhbWVzIGJldHdlZW4gdHhfdGFpbCBhbmQgdHhfaGVhZCBoYXZlIGJl
ZW4gbWFya2VkIGFzIHVzZWQuDQo+Pg0KPj4gSSBzZWUuIENvbnRyb2xsZXIgc2V0cyBUWF9VU0VE
IG9uIHRoZSAxc3QgZGVzY3JpcHRvciBvZiB0aGUgdHJhbnNtaXR0ZWQNCj4+IGZyYW1lLiBJZiB0
aGVyZSB3ZXJlIHBhY2tldHMgd2l0aCBvbmUgZGVzY3JpcHRvciBlbnF1ZXVlZCB0aGF0IHNob3Vs
ZCBtZWFuDQo+PiBjb250cm9sbGVyIGRpZCBpdHMgam9iID4NCj4+IGhlYWQgIT0gdGFpbCBvbiBz
b2Z0d2FyZSBkYXRhIHN0cnVjdHVyZXMgd2hlbiByZWNlaXZpbmcgVFhVQlIgaW50ZXJydXB0IGFu
ZA0KPj4gYWxsIGRlc2NyaXB0b3JzIGluIHF1ZXVlIGhhdmUgVFhfVVNFRCBiaXQgc2V0IG1pZ2h0
IHNpZ25hbCB0aGF0wqAgYQ0KPj4gZGVzY3JpcHRvciBpcyBub3QgdXBkYXRlZCB0byBDUFUgb24g
VENPTVAgaW50ZXJydXB0IHdoZW4gQ1BVIHVzZXMgaXQgYW5kDQo+PiB0aHVzIGRyaXZlciBkb2Vz
bid0IHRyZWF0IGEgVENPTVAgaW50ZXJydXB0LiBTZWUgdGhlIGFib3ZlIGNvZGUgb24NCj4gDQo+
IEJvdGggVFhfVVNFRCBhbmQgbGFzdCBidWZmZXIgKGJpdCAxNSkgaW5kaWNhdG9yIGxvb2tzIG9r
IGZyb20NCj4gbWVtb3J5LCBzbyBjb250cm9sbGVyIHNlZW1zIHRvIGJlIHVwIHRvIGRhdGUuIElm
IHdlIHdlcmUgdG8gZ2V0IGEgVENPTVANCj4gaW50ZXJydXB0IHRoaW5ncyB3b3VsZCBiZSByb2xs
aW5nIGFnYWluLg0KDQpNeSBjdXJyZW50IHN1cHBvc2l0aW9uIGlzIHRoYXQgY29udHJvbGxlciBm
aXJlcyBUQ09NUCBidXQgdGhlIGRlc2NyaXB0b3IgaXMNCm5vdCB1cGRhdGVkIHRvIENQVSB3aGVu
IGl0IHVzZXMuIE9mIGNvdXJzZSBpcyBqdXN0IHN1cHBvc2l0aW9uLiBNYXliZSBjaGVjaw0KdGhh
dCBybWIoKSBleHBhbmQgdG8geW91ciBzeXN0ZW0gbmVlZHMsIG1heWJlIHVzZSBkbWFfcm1iKCks
IG9yIGNoZWNrIHRoZQ0KY3RybCBwYXJ0IG9mIHRoZSBkZXNjcmlwdG9yIHdoZW4gaGVhZCBhbmQg
dGFpbCBwb2ludHMgdG8gdGhlIHZhbHVlcyB0aGF0DQptYWtlcyB0aGUgZHJpdmVyIGZhaWwuIEp1
c3Qgd2FudGVkIHRvIGJlIHN1cmUgdGhlIGNvbmN1cnJlbmN5IGlzIG5vdCBmcm9tIGhlcmUuDQoN
Cj4gT2Zjb3Vyc2UgdGhpcyBpcyBzcGVjdWxhdGlvbiwgYnV0IHBlcmhhcHMgdGhlcmUgY291bGQg
YWxzbyBiZSBzb21lDQo+IGNvcm5lciBjYXNlcyB3aGVyZSB0aGUgY29udHJvbGxlciBmYWlscyB0
byBnZW5lcmF0ZSBUQ09NUCBhcyBleHBlY3RlZD8NCg0KSSBzdXBwb3NlIHRoaXMgaGFzIHRvIGJl
IGNoZWNrZWQgd2l0aCBDYWRlbmNlLg0KDQpUaGFuayB5b3UsDQpDbGF1ZGl1IEJlem5lYQ0KDQo+
IA0KPj4gbWFjYl90eF9pbnRlcnJ1cHQoKToNCj4+DQo+PiBkZXNjID0gbWFjYl90eF9kZXNjKHF1
ZXVlLCB0YWlsKTsNCj4+DQo+PiAvKiBNYWtlIGh3IGRlc2NyaXB0b3IgdXBkYXRlcyB2aXNpYmxl
IHRvIENQVSAqLw0KPj4gcm1iKCk7DQo+Pg0KPj4gY3RybCA9IGRlc2MtPmN0cmw7DQo+Pg0KPj4g
LyogVFhfVVNFRCBiaXQgaXMgb25seSBzZXQgYnkgaGFyZHdhcmUgb24gdGhlIHZlcnkgZmlyc3Qg
YnVmZmVyDQo+PiAqIGRlc2NyaXB0b3Igb2YgdGhlIHRyYW5zbWl0dGVkIGZyYW1lLg0KPj4gKi8N
Cj4+DQo+PiBpZiAoIShjdHJsICYgTUFDQl9CSVQoVFhfVVNFRCkpKQ0KPj4gwqDCoMKgwqDCoCBi
cmVhazsNCj4+DQo+Pg0KPj4+DQo+Pj4gR0VNIGRvY3VtZW50YXRpb24gc2F5cyAidHJhbnNtaXNz
aW9uIGlzIHJlc3RhcnRlZCBmcm9tDQo+Pj4gdGhlIGZpcnN0IGJ1ZmZlciBkZXNjcmlwdG9yIG9m
IHRoZSBmcmFtZSBiZWluZyB0cmFuc21pdHRlZCB3aGVuIHRoZQ0KPj4+IHRyYW5zbWl0IHN0YXJ0
IGJpdCBpcyByZXdyaXR0ZW4iIGJ1dCBzaW5jZSBhbGwgZnJhbWVzIGFyZSBhbHJlYWR5IG1hcmtl
ZA0KPj4+IGFzIHRyYW5zbWl0dGVkLCByZXN0YXJ0aW5nIHdvbnQgaGVscC4gQWRkaW5nIHRoaXMg
YWRkaXRpb25hbCBjaGVjayB3aWxsDQo+Pj4gaGVscCBmb3IgdGhlIGlzc3VlIHdlIGhhdmUuDQo+
Pj4NCj4+DQo+PiBJIHNlZSBidXQgYWNjb3JkaW5nIHRvIHlvdXIgZGVzY3JpcHRpb24gKGFsbCBk
ZXNjcmlwdG9ycyB0cmVhdGVkIGJ5DQo+PiBjb250cm9sbGVyKSBpZiBubyBwYWNrZXRzIGFyZSBl
bnF1ZXVlZCBmb3IgVFggYWZ0ZXI6DQo+Pg0KPj4gK8KgwqDCoMKgwqDCoCBpZiAodGJxcCA9PSBo
ZWFkX2lkeCkNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybjsNCj4+ICsN
Cj4+DQo+PiB0aGVyZSBhcmUgc29tZSBTS0JzIHRoYXQgd2VyZSBjb3JyZWN0bHkgdHJlYXRlZCBi
eSBjb250cm9sbGVyIGJ1dCBub3QgZnJlZWQNCj4+IGJ5IHNvZnR3YXJlICh0aGV5IGFyZSBmcmVl
ZCBvbiBtYWNiX3R4X3VubWFwKCkgY2FsbGVkIGZyb20NCj4+IG1hY2JfdHhfaW50ZXJydXB0KCkp
LiBUaGV5IHdpbGwgYmUgZnJlZWQgb24gbmV4dCBUQ09NUCBpbnRlcnJ1cHQgZm9yIG90aGVyDQo+
PiBwYWNrZXRzIGJlaW5nIHRyYW5zbWl0dGVkLg0KPiBZZXMsIHRoYXQgaXMgaWRlYS4gV2UgY2Fu
bm90IHJlc3RhcnQgc2luY2UgaXQgdHJpZ2dlcnMgbmV3IGlycSwNCj4gYnV0IGluc3RlYWQgbmVl
ZCB0byBicmVhayBvdXQuIFdoZW4gbW9yZSBkYXRhIGFycml2ZXMsIHRoZSBjb250cm9sbGVyDQo+
IGNvbnRpbnVlcyBvcGVyYXRpb24gYWdhaW4uDQo+IA0KPiANCj4+DQo+Pj4NCj4+Pj4NCj4+Pj4g
TWF5YmUgVFhfV1JBUCBpcyBtaXNzaW5nIG9uIG9uZSBUWCBkZXNjcmlwdG9yPyBGZXcgbW9udGhz
IGFnbyB3aGlsZQ0KPj4+PiBpbnZlc3RpZ2F0aW5nIHNvbWUgb3RoZXIgaXNzdWVzIG9uIHRoaXMg
SSBmb3VuZCB0aGF0IHRoaXMgbWlnaHQgYmUgbWlzc2VkDQo+Pj4+IG9uIG9uZSBkZXNjcmlwdG9y
IFsxXSBidXQgaGF2ZW4ndCBtYW5hZ2VkIHRvIG1ha2UgaXQgYnJlYWsgYXQgdGhhdCBwb2ludA0K
Pj4+PiBhbnlob3cuDQo+Pj4+DQo+Pj4+IENvdWxkIHlvdSBjaGVjayBvbiB5b3VyIHNpZGUgaWYg
dGhpcyBpcyBzb2x2aW5nIHlvdXIgaXNzdWU/DQo+Pj4NCj4+PiBJIGhhdmUgc2VlbiB0aGF0IHdl
IGNhbiBnZXQgc3R1Y2sgYXQgYW55IGxvY2F0aW9uIGluIHRoZSByaW5nIGJ1ZmZlciwgc28NCj4+
PiB0aGlzIGRvZXMgbm90IHNlZW0gdG8gYmUgdGhlIGNhc2UgaGVyZS4gSSBjYW4gdHJ5IHRob3Vn
aCBpZiBpdCB3b3VsZA0KPj4+IGhhdmUgYW55IGVmZmVjdC4NCj4+DQo+PiBJIHdhcyB0aGlua2lu
ZyB0aGF0IGhhdmluZyBzbWFsbCBwYWNrZXRzIHRoZXJlIGlzIGhpZ2ggY2hhbmNlIHRoYXQgVEJR
UCB0bw0KPj4gbm90IHJlYWNoIGEgZGVzY3JpcHRvciB3aXRoIHdyYXAgYml0IHNldCBkdWUgdG8g
dGhlIGNvZGUgcG9pbnRlZCBpbiBteQ0KPj4gcHJldmlvdXMgZW1haWwuDQo+IA0KPiBJIHRlc3Rl
ZCB3aXRoIHRoZSBhZGRpdGlvbnMgc3VnZ2VzdGVkIGJlbG93LCBidXQgd2l0aCBubyBjaGFuZ2Uu
DQo+IA0KPiBUaGFua3MsDQo+IFRvbWFzDQo+IA0KPiANCj4+DQo+PiBUaGFuayB5b3UsDQo+PiBD
bGF1ZGl1IEJlem5lYQ0KPj4NCj4+Pg0KPj4+IHRoYW5rcywNCj4+PiBUb21hcw0KPj4+DQo+Pj4N
Cj4+Pj4NCj4+Pj4gwqDCoMKgwqDCoMKgIC8qIFNldCAnVFhfVVNFRCcgYml0IGluIGJ1ZmZlciBk
ZXNjcmlwdG9yIGF0IHR4X2hlYWQgcG9zaXRpb24NCj4+Pj4gwqDCoMKgwqDCoMKgwqAgKiB0byBz
ZXQgdGhlIGVuZCBvZiBUWCBxdWV1ZQ0KPj4+PiDCoMKgwqDCoMKgwqDCoCAqLw0KPj4+PiDCoMKg
wqDCoMKgwqAgaSA9IHR4X2hlYWQ7DQo+Pj4+IMKgwqDCoMKgwqDCoCBlbnRyeSA9IG1hY2JfdHhf
cmluZ193cmFwKGJwLCBpKTsNCj4+Pj4gwqDCoMKgwqDCoMKgIGN0cmwgPSBNQUNCX0JJVChUWF9V
U0VEKTsNCj4+Pj4gK8KgwqDCoMKgIGlmIChlbnRyeSA9PSBicC0+dHhfcmluZ19zaXplIC0gMSkN
Cj4+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjdHJsIHw9IE1BQ0JfQklUKFRYX1dSQVAp
Ow0KPj4+PiDCoMKgwqDCoMKgwqAgZGVzYyA9IG1hY2JfdHhfZGVzYyhxdWV1ZSwgZW50cnkpOw0K
Pj4+PiDCoMKgwqDCoMKgwqAgZGVzYy0+Y3RybCA9IGN0cmw7DQo+Pj4+DQo+Pj4+IFsxXQ0KPj4+
PiBodHRwczovL2V1cjAzLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0
cHMlM0ElMkYlMkZnaXQua2VybmVsLm9yZyUyRnB1YiUyRnNjbSUyRmxpbnV4JTJGa2VybmVsJTJG
Z2l0JTJGdG9ydmFsZHMlMkZsaW51eC5naXQlMkZ0cmVlJTJGZHJpdmVycyUyRm5ldCUyRmV0aGVy
bmV0JTJGY2FkZW5jZSUyRm1hY2JfbWFpbi5jJTIzbjE5NTgmYW1wO2RhdGE9MDQlN0MwMSU3Q3Rv
bWFzLm1lbGluJTQwdmFpc2FsYS5jb20lN0M0ZDVlZjVhMmEyNzI0NzY5N2IwYjA4ZGEwZTY1Mzlm
ZiU3QzZkNzM5M2UwNDFmNTRjMmU5YjEyNGMyYmU1ZGE1YzU3JTdDMCU3QzAlN0M2Mzc4MzgxMjUx
ODM2MjQ2NzAlN0NVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01EQWlMQ0pR
SWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCZhbXA7c2Rh
dGE9diUyRiUyRmRFMVk4QnhIV3NtdG4zblg3ME9GTjVvQ2IlMkJ6bGI4ODFVWHVZdG9NcyUzRCZh
bXA7cmVzZXJ2ZWQ9MA0KPj4+Pg0KPj4+Pg0KPj4+Pg0KPj4+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
IG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2JfcmVhZGwoYnAsIE5DUikgfCBNQUNCX0JJVChUU1RB
UlQpKTsNCj4+Pj4+IMKgwqAgfQ0KPj4+Pj4NCj4+Pj4+IC0tIA0KPj4+Pj4gMi4zNS4xDQo+Pj4+
Pg0KPj4+Pg0KPj4NCg0K
