Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3E457DECE
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236658AbiGVJgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 05:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiGVJf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:35:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDCF868BF;
        Fri, 22 Jul 2022 02:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658481885; x=1690017885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g5gCp40sYKYS7F56bsepTmOp+/QYBVVwv6riG5wfVg4=;
  b=k48GgyOA5S/Oj1IFIazntH4dHIsVXgqT/VoS+RaXFhe6EmQC9bVOxK3A
   cEHOUf7ceGWOL+G+hARIsGy9qfN0yCP/Kn/b+uKGyC2rFK1CIbqQp4EZU
   k79rvr9loBw0MsKejk+R8o9PWnTJYfc8TDDQbDM5jszNmUpNjxV9wnBf3
   FTP4Lx842ZkW/92aCSKtVIEYUnf/ElyZdWdkKSrguIxrpi8IL7T/YsocC
   2w1CF+NWxBwehTpxI6KlYG61GkCgX1JZA8uZSgDFfI8RE6khJ9Q898Ht0
   /lvNQIPAGUGSn9a8rwWjP4N6rRHOrBRYV6A6RpoxwrP0bGwUU0i/fpFEs
   A==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="165939220"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 02:24:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 02:24:42 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 22 Jul 2022 02:24:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keHI+dIMAH6Kmwzps9//l2u43ZHayfVLKur2QZLmsgSH5uRFKM0FKaQhUiCfM/0+eXpFhbzZ2+VtFmKgkwNv/hSS7YpdNG7ZHg75JybCCe4CE2Y77469qaAv8BDwAGLHEpeOoR9owz9kFOfhcaCG0ro32SSKR2Wajvhc/ANS/aoMUhCsTTrHN4tJfYB7328c5q72/WMnW07wFi+xnMmuNK++RJ/bLbZyl6ax3rC09acuLCBTIKOfUNrIHwCsifvfKm6eA1m0J2Z8qaD5hkm34uRnpEJiLLZcvY8cJy9DVlAgsEVLcdR4YL0vQ6gdTKBqalxOPO8kHfHZZV7IIX8lfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5gCp40sYKYS7F56bsepTmOp+/QYBVVwv6riG5wfVg4=;
 b=gGXPsVgyYx11aqiEAEVwR7L5sFpWmjKo7AW4CO06oWL47+0DU8XQedY/44WNRmM8TM1ZSsKS1waRaEPQfZ0NE+Ialv77qjKhDryAovzHcd9TXbJmC40tYVTuQuPrUjGQ8uwCAfO7fk+SzgMD9zY1Gi7Aouz/vpHt0lJ52m3xjejETSvUyIGUqly69HDoeDoj5vvSTxiWJlxc88nUDzRI6jS9l+C9cogFk1Vx3M881A0mW1McJjexdEnjQBHI8zEXRFSkTZQXOddrddDG6qrMJ0Bzo1rZyRDfUF3A9b5LFRpUwsTbMb52wzcHHj6m1F3+QCBimsnOEl4kvZIzeNJECA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5gCp40sYKYS7F56bsepTmOp+/QYBVVwv6riG5wfVg4=;
 b=TcbBpJR7I5c+1t6ZqNu18XHU0/mTm0tUtwzYNtCFhdSjG7+ng9Mm6Bd1bs0ITsw/yq5PK32nT78cmTF+N0AsRlL+A6rMUTdn2/8ZjIwwzX2in+t/ifKmJvdma+bWcQQ/RfPVniq3dZ1r8DQoqLNSj+VsiY3kYSQyfyHlx0JJ8iM=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by MWHPR11MB0064.namprd11.prod.outlook.com (2603:10b6:301:64::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 22 Jul
 2022 09:24:37 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%7]) with mapi id 15.20.5458.018; Fri, 22 Jul 2022
 09:24:37 +0000
From:   <Conor.Dooley@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <gregkh@linuxfoundation.org>,
        <ronak.jain@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@xilinx.com>, <git@amd.com>
Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Topic: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Thread-Index: AQHYnazdd3Koc4IPq0ezbroTQMoC5A==
Date:   Fri, 22 Jul 2022 09:24:37 +0000
Message-ID: <efa4a57e-82e8-885d-4087-fe039adeaac4@microchip.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 597a8c0d-96e0-4b04-02dd-08da6bc3ffaa
x-ms-traffictypediagnostic: MWHPR11MB0064:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l+YGHY+LOBalqNN93iWvZSil09pwxahOKx9BWcasSjr7pjVImX1nRcBmU18vLQWSvzbq3LcAHJNjOqTuDDy8VlnlK8TnC98Co3j8e/Y1SRPp71xKjkJirYUKa8z6c14I1UPeAbdcnkEzwZXBLdMXyK7y7jQdeRQ9+nY2IkSFaNhK1hUaP/bm+maL0xJ9Bhf5xh/N/YBIweM66kR5aFVTUD3SdIg/JTYgeWyF/Erev/PJgkFZnE/rq3sVMQ6+wdRzXE9n0YbMy6r+EusZzkX5zLUEEYC96UcDLyjMbOcohSIben/PDmc1dbZlZruUy6sWL6vIBWFMrEL86y5ks8eRSfsgLv9Acw3UWGcgqN6wmczewSvbogIY8qMisIsIvRGe2trasPF+K6XUUqYH+iS+GRAM2v8MFxhBJbbj0WLvQI7/OBV+nhxOL044+EevTmolJnfJliie0ZDC93Qo8Sn0g+Jjq0hmAZ5vJ3I+QDku2eR93ZIDmwTvCvrdR53je8vtmDlE+XoFH4aoEkwXFsxU3MhsytrkRnDfiOtvfQ02P/V+YW9t1jsVw+fWtY4D7FLkS9b4G5xpLClXdH3/B3LhnSMiTDrOQ2mBkTeVxQSW4RfB3enOm4Cxr+I/ZcgPKrP+Zxv1d6rrFqkM4AX1f4EL1E7A8GoLrqOo1+tpgjOCmb0Idhmk4k0c0OnHb1yAUbW5nf4eG+3zI75DtdhPLYQ1TtK6DNGj+zpIdzLlFFMXncQj9/n4FOPjFuSm19p3xvRgi+WwAjY24sD/TOJ5wdOH2v+YIEMT4/GzLyhQS6BLxkdI+gzKc4gousC2Xh9VaIDM5vHIxJmFeAV0JrwSelwLq9Mq8r23qSpBsTw0zkZSqssHCbUtU6Wgq+CsccmtfRNY0C4rAPACG16S48DTt0MSEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(136003)(396003)(366004)(346002)(66946007)(64756008)(4326008)(38070700005)(7416002)(66446008)(8676002)(122000001)(316002)(66476007)(76116006)(54906003)(8936002)(110136005)(86362001)(91956017)(66556008)(38100700002)(31686004)(2906002)(921005)(5660300002)(41300700001)(6506007)(53546011)(26005)(186003)(71200400001)(31696002)(6512007)(2616005)(6486002)(36756003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2ZFMG5qK0ErZ1JnZVhITjYyZjF5eWhnaGdJeHdBYjhtLzVSN0NUc0J0SjRX?=
 =?utf-8?B?M0RDN0VpRy9ta3hyYy96WEdUSHg2ekxtU1MrSWpOSE8zRjRsMUIwMVIzRlZv?=
 =?utf-8?B?cDdnQVdFVndpZjd3ZWFNN2xYRHBXekhzd015ZGZRTjBjc1FRbThvbEZTU1VD?=
 =?utf-8?B?alN0NFhHU0FBaEE0LzZBQ21Kd2Jzc05lbkQydU1JN3c4bUNucFhSWnp3OXh2?=
 =?utf-8?B?R1BlQS9aN1F1a3B6RGNlR05BT1lnaU1WUmZyRFp0VEtxbURqWGp4M2R6eWh5?=
 =?utf-8?B?ZzJsZHU3cUxTYkluQVNPNXRxbVBuSEQ2WjhxK1VtWmtGandJTnZ5aDVNdits?=
 =?utf-8?B?K1ZLU0R5b2Q2a0lKbCtDWFc2T3NNWlhJTlZTWW1qa3dKang5NGgxL2lialpP?=
 =?utf-8?B?Tk9rNlJJSi9xaFhNdEpQNjdudUFPcVJmQXU1OUdjeHJqeFNhSFprZjY1TVFt?=
 =?utf-8?B?WkxYTktVdzV1UzBzTmVhK0xwd0hOMW91VUN6dCtDSU84Q1A0Wmx5bVNwaXIv?=
 =?utf-8?B?Q0NYN0M3Y1JPcFpqdzlMOFNiRzJTN01pTjFNVHprN2tMaUtrWVQ2dHdPUzFU?=
 =?utf-8?B?WE1PS0EvT2o0alhpYmNXSW43YWVOSXdkRkVZOHhtUEM4ZmJUNmR6U1JXUzZw?=
 =?utf-8?B?UTZNaGJJeWduUjNTbTZNcGw3NjNhNFBuTHAvcEJyYlFnYnZuNXpsK2ZOeGZW?=
 =?utf-8?B?OFpQVGlFRVVrM1JFeTFWSDhzMDFISjkyYTRnelFKMllhbGNvZ3dhdm0zWHRa?=
 =?utf-8?B?M3d1NnFBSlpjbEdxSmdoMTZWcCtac2xsSTlPNjZudjZoOVJsMGgyUFZ3RFRP?=
 =?utf-8?B?aEV1cmpQc3pMbTh2WDQrM0RGaWtuQ1VVRHpTdHg1eGdwVzdvb1dWK2FwUWNL?=
 =?utf-8?B?YVczZW11MDE4Ni9TcDRQTGdGUGdTVFNKT2ZYMk9wYUhkREJkWWd4UzZPd3Vt?=
 =?utf-8?B?a0s1VmkzR2Y1d3FBakg0VTlsRXJLY2Y0UTZRalgyMGJoNm1aamI4dVRzM0px?=
 =?utf-8?B?L2tuM1R5MVVscGJIeUgrekZ0Nis0MTZPT3VYL2xFVkNrZG1mZndjbUlORmli?=
 =?utf-8?B?Z0szTURmVmdBR3J6MUZ3RzdPMTYxTk13Mmt2Y0hkZld6c0J2R2dkdXhJUzdv?=
 =?utf-8?B?ZmhpQlZZNFlJWXZQZnRwTFVRaVFxTFBwdFRkYnRmQ2JZbVhBY2xRam52T2pD?=
 =?utf-8?B?ZUM1cGp5TTJlaUdmOFpYazFqdFdLTmFJZXZCUzFmbTJUeG54aHRMY2J4M0Zm?=
 =?utf-8?B?WXpvdzhRSERzY1R3Mk1vZ1A2VG9IUDhtVmFqY0NYSmR2WkhNaTlxUzhaem9Z?=
 =?utf-8?B?a2R1QmljT0ExUkp2MGZScmVNWlUxb3hyNUEvTFVnQlBOWVVBZ002UTFrbTE2?=
 =?utf-8?B?NXV1dkhjcW1RUVMwcmNvRjRCY1d4cm1rZFJVSHRlYjJpRWpuK2hMRjNCK0tQ?=
 =?utf-8?B?Z3NOMkoyYUI3bUlEZEZ2WWVGK1J4UG1Fc2xzVlJqUjRZZ09pcFhSZ1RnSGl5?=
 =?utf-8?B?RktoYkdlbU13OHUxUklVOTNpVEd6SFMxL1RuWFdndkJnTkFNRkxUYVgwTEU4?=
 =?utf-8?B?YzhIaXZCdjliQ3k3TjdKdDZCQzRoTHkvM1FhWmFJcHBrL1hUbVlveTR6ZGp6?=
 =?utf-8?B?RzBmL1RBakVTcEFGdWtvUm1yOThBWlpUQ0ltWEFtRlhGNHI1ZzFzOTd2SWtw?=
 =?utf-8?B?cmIzWFAzdHkyWkNCV1VEWm0zVDhpWWs2UXF6cG9qa0poWFYvTStoa21pVjl6?=
 =?utf-8?B?dGJ2bFQ5TkNYYmpDRUZtd1dKaEhSMTEvb29vR1o5NzZ6bDgzUHRybFhCeDhS?=
 =?utf-8?B?d2RweEZDQWE0T2RoaUtxbllVanZDTE0zdUt3M1N6YlM2NEFZVVVUV0pVK2lT?=
 =?utf-8?B?dDBMOXBvK2ZWMnB5ZVlXMUZNYkxQN3RZbVpjYVZ5aGgybWZuOEdUU3dqSnRu?=
 =?utf-8?B?RXJNelNuM2pWRCs1bFV6bWQ3Zk9vdDlteGcrY1AvUlNIbjNVbnlxakd5TXZz?=
 =?utf-8?B?elFQZTZUUnFmQ1l2MzU1bS92bVJEMWxlczNvQzVMTFFsYzJhY24xODluYmM3?=
 =?utf-8?B?NzMrbVpmZUNKZlpHQmhhTS82QnQvK3ZReHhGU2VNSTAzOHlTQkt1QWVTQ3ZO?=
 =?utf-8?B?dGc3LzJhWlpqOE5LMmhpcUxpYXZWc2VvRE1BWVdoOXdrWGRvMjJuM2VINWY2?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C57E896F7DBA494096287BEA23914E1B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597a8c0d-96e0-4b04-02dd-08da6bc3ffaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 09:24:37.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zBXkJLGR0Q0t+65Hm18Thqq8MF+mOJfx2ti3Z3rlX25ZlBwWBPTuhW7Ys7/ZGqqLrW3TGLpnHaDMdAUIz9Euprv79Sm0bCcIx0DJDlxsbHM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0064
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIvMDcvMjAyMiAwOToxMiwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gQWRkIHN1
cHBvcnQgZm9yIHRoZSBkeW5hbWljIGNvbmZpZ3VyYXRpb24gd2hpY2ggdGFrZXMgY2FyZSBvZiBj
b25maWd1cmluZw0KPiB0aGUgR0VNIHNlY3VyZSBzcGFjZSBjb25maWd1cmF0aW9uIHJlZ2lzdGVy
cyB1c2luZyBFRU1JIEFQSXMuIEhpZ2ggbGV2ZWwNCj4gc2VxdWVuY2UgaXMgdG86DQo+IC0gQ2hl
Y2sgZm9yIHRoZSBQTSBkeW5hbWljIGNvbmZpZ3VyYXRpb24gc3VwcG9ydCwgaWYgbm8gZXJyb3Ig
cHJvY2VlZCB3aXRoDQo+ICAgR0VNIGR5bmFtaWMgY29uZmlndXJhdGlvbnMobmV4dCBzdGVwcykg
b3RoZXJ3aXNlIHNraXAgdGhlIGR5bmFtaWMNCj4gICBjb25maWd1cmF0aW9uLg0KDQpGb3IgbXBm
czoNClRlc3RlZC1ieTogQ29ub3IgRG9vbGV5IDxjb25vci5kb29sZXlAbWljcm9jaGlwLmNvbT4N
Cg0KPiAtIENvbmZpZ3VyZSBHRU0gRml4ZWQgY29uZmlndXJhdGlvbnMuDQo+IC0gQ29uZmlndXJl
IEdFTV9DTEtfQ1RSTCAoZ2VtWF9zZ21paV9tb2RlKS4NCj4gLSBUcmlnZ2VyIEdFTSByZXNldC4N
Cj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJhZGhleSBTaHlhbSBQYW5kZXkgPHJhZGhleS5zaHlhbS5w
YW5kZXlAYW1kLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21h
Y2JfbWFpbi5jIHwgMjAgKysrKysrKysrKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAy
MCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
Y2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9t
YWluLmMNCj4gaW5kZXggN2ViNzgyMmNkMTg0Li45N2Y3N2ZhOWUxNjUgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiBAQCAtMzgsNiArMzgsNyBAQA0K
PiAgI2luY2x1ZGUgPGxpbnV4L3BtX3J1bnRpbWUuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9wdHBf
Y2xhc3NpZnkuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9yZXNldC5oPg0KPiArI2luY2x1ZGUgPGxp
bnV4L2Zpcm13YXJlL3hsbngtenlucW1wLmg+DQo+ICAjaW5jbHVkZSAibWFjYi5oIg0KPiAgDQo+
ICAvKiBUaGlzIHN0cnVjdHVyZSBpcyBvbmx5IHVzZWQgZm9yIE1BQ0Igb24gU2lGaXZlIEZVNTQw
IGRldmljZXMgKi8NCj4gQEAgLTQ2MjEsNiArNDYyMiwyNSBAQCBzdGF0aWMgaW50IGluaXRfcmVz
ZXRfb3B0aW9uYWwoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAkJCQkJICAgICAi
ZmFpbGVkIHRvIGluaXQgU0dNSUkgUEhZXG4iKTsNCj4gIAl9DQo+ICANCj4gKwlyZXQgPSB6eW5x
bXBfcG1faXNfZnVuY3Rpb25fc3VwcG9ydGVkKFBNX0lPQ1RMLCBJT0NUTF9TRVRfR0VNX0NPTkZJ
Ryk7DQo+ICsJaWYgKCFyZXQpIHsNCj4gKwkJdTMyIHBtX2luZm9bMl07DQo+ICsNCj4gKwkJcmV0
ID0gb2ZfcHJvcGVydHlfcmVhZF91MzJfYXJyYXkocGRldi0+ZGV2Lm9mX25vZGUsICJwb3dlci1k
b21haW5zIiwNCj4gKwkJCQkJCSBwbV9pbmZvLCBBUlJBWV9TSVpFKHBtX2luZm8pKTsNCj4gKwkJ
aWYgKHJldCA8IDApIHsNCj4gKwkJCWRldl9lcnIoJnBkZXYtPmRldiwgIkZhaWxlZCB0byByZWFk
IHBvd2VyIG1hbmFnZW1lbnQgaW5mb3JtYXRpb25cbiIpOw0KPiArCQkJcmV0dXJuIHJldDsNCj4g
KwkJfQ0KPiArCQlyZXQgPSB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcocG1faW5mb1sxXSwgR0VN
X0NPTkZJR19GSVhFRCwgMCk7DQo+ICsJCWlmIChyZXQgPCAwKQ0KPiArCQkJcmV0dXJuIHJldDsN
Cj4gKw0KPiArCQlyZXQgPSB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcocG1faW5mb1sxXSwgR0VN
X0NPTkZJR19TR01JSV9NT0RFLCAxKTsNCj4gKwkJaWYgKHJldCA8IDApDQo+ICsJCQlyZXR1cm4g
cmV0Ow0KPiArCX0NCj4gKw0KPiAgCS8qIEZ1bGx5IHJlc2V0IGNvbnRyb2xsZXIgYXQgaGFyZHdh
cmUgbGV2ZWwgaWYgbWFwcGVkIGluIGRldmljZSB0cmVlICovDQo+ICAJcmV0ID0gZGV2aWNlX3Jl
c2V0X29wdGlvbmFsKCZwZGV2LT5kZXYpOw0KPiAgCWlmIChyZXQpIHsNCg==
