Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D0F57B8E6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240056AbiGTOvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiGTOvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:51:51 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7308725E2;
        Wed, 20 Jul 2022 07:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658328708; x=1689864708;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1O3umCiWXZLJhpwSePCT6mRZd2bfztjgQS9443wq/6Y=;
  b=S/DYJZsqgaWh93WXyyKuJykHlwD+plQJRFJVcK/yvoofR6xDZZ7WFsJg
   L1mTdKEdufhqRXIG2/Lj0dnLjGkhcROmyIdtsl+Uc8WxUppqwVHwk34hZ
   zrydY1vm/h910Q7QVjsFbdgCoZif4QBaX/LIAoM+oizvGPPDhiZx3wnEq
   NNUyw5/KRFPwy+jDDJQDr7CTJHZz1a1qW7YfNzQYxKLUB76kb5T21PBbG
   dkXGZO1h9pJA8Hp9luKyVWWxFs2r+WZ+whVLB6F+dmxJ8GI6sHhBNmTfT
   ajvXouwogj3XRSWxPmjIIt5KmLhk4qYc6bF7tO5Nv+6loq7+ML4+9i4Vv
   A==;
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="183010470"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2022 07:51:47 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 20 Jul 2022 07:51:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 20 Jul 2022 07:51:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQxPg1AUMzhxrNxBu/vIN1cY2y5vzeEPyzeEs4e323CUu+V0gDz9RLNgRztjQKU0p/8KRdiJcFX0TWhNBZdYm+aw0r8Er7Qnyhqv2v7UR4fVEUP7Y93fTj+Ulwnc2SsbgdtqqbOjs2HKWMVP4JqlCNVtDajrDYtWovcnyCJTg6MrZFCn2yCkHPGHO/CZm4FdyCu161xJ7+JKaruwK/5QtZLyDYU1rQZP+TCnwDEG1F4xUQ+J1hJ4IKMDvTdLPi/BtbxmnwDudixYbDvNu3FpWpYmXXDvOqcOy6ItHZo27jpqFIvq2N8GPEo5hpdKv5JzHmAW5nB9BuoWtTHBOni6KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1O3umCiWXZLJhpwSePCT6mRZd2bfztjgQS9443wq/6Y=;
 b=DPF13Tu+Q//FF9x1BGP3O30ErMUgvOn1xuW2NWpnF2LJbM9CjbksxEzdF1DQ7k0sKfq9exhIcHIcgZhIHl44orUu6i7Onu5Q6xEsg3j0SMHoCXUCM2Ag4Y+kyCWT87xwIQ9SjjZpQcribmbb8YoWo8aQNRjqhLJgzQk1XxtzcymvJxYjwH3CjN9ssA7ay0vp0d8UKWNgFBTgEjcs2KmQ4I3Pu2zAKUYynOVVr0gGuSoa6Zwn4TlL2qdZrSCMN1aYPppqC89S/LJY1PA7+DcsCl2N8WDYp9kM0Yir6+LRusytAF2+CPlhJ93zWREtHhlM5l4HNKJ0fCH+WDwCMOYE9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O3umCiWXZLJhpwSePCT6mRZd2bfztjgQS9443wq/6Y=;
 b=tdFXfAbFVZ5FXOyYq18Zk1kjBLXQYgkyXLh2ANQvsjKw18DXv3s1ysrMWN16h1SzPPZC2KhWYi9Ki6AJwkDYue59cm2547dRGn3Lz9MkB9cz4cu0wzkPpdsopKaoWkRw+VlaEu7foyIGzejyx2KmDroNBrcDEG0xnHHLSvD6tHo=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA1PR11MB5945.namprd11.prod.outlook.com (2603:10b6:806:239::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.22; Wed, 20 Jul
 2022 14:51:42 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Wed, 20 Jul 2022
 14:51:42 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next 07/10] net: dsa: microchip: apply rgmii tx
 and rx delay in phylink mac config
Thread-Topic: [RFC Patch net-next 07/10] net: dsa: microchip: apply rgmii tx
 and rx delay in phylink mac config
Thread-Index: AQHYlgksiUwHJ6ThxkyZPMnB22ly3K2Fh60AgAHcsoA=
Date:   Wed, 20 Jul 2022 14:51:42 +0000
Message-ID: <d4696bc19472e9efd3a5581ea5c3bca201c90580.camel@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
         <20220712160308.13253-8-arun.ramadoss@microchip.com>
         <20220719102532.ndny6lrcxwwte7gw@skbuf>
In-Reply-To: <20220719102532.ndny6lrcxwwte7gw@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9b8d6a0-0806-41c6-ed63-08da6a5f5c07
x-ms-traffictypediagnostic: SA1PR11MB5945:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wUoUP/ZH/5hP/TnqWqH6RFUR5Tlw/hB4SB6D+6mWOR5tsTdqL5n4v16S3ga1kC35Jrhtt6kPDZ3j3/G2Kp+5bqYEqqt+oHeack5CUtfYUUoP3LREmt1aBnFyN08maHgyItevkJ18thStr9tK1n99Oics2YZyasY4fB1Di5SMsjWcnw3qBD159LXh5105BwXrgNRy7LEPAmy+I19eQVl++DUEkysJuCybc4Usmqgrg7e7ETxuATBF4nRc5+6kDXj/R313eUndBf8DFkCj99/1hIbgbCZR4yFSdl0buZb3EpfIolQhfppx27C/pPczjvyOYJF+Cv6ew3hL87nTStXOjFqq/SKBwocAIPC/coT3MeeNPjUo216zaIOY2elkS/A6e03JOfd9F0GrGrt+xXdJw0cXFINE/kGhKz/YCpAUbH5WLs8C1STUZ9GRtMqnWkWWcoExVcNq/FChPAASia3ZDpn9p92jhrODhJ2+BSGgRc0GkKTWGSzrdV1BMdLpWJ4ZqbB+c9dhywPlKiJ8AnB3dwu8Ils6gXCffC6Ne57Wfz+H13eZOrr577/w23ly9hzq/GHuEEmM4/c0qdsF1B2h8Rcg6C9tUmCJyi0lrkBDD+kSUDPqgTJb+gSbXrl4BBKaIQEh2HNkpEAbzGr7Ncw7Az9tW76vpVIVL1zA7iaLiUb5aJqFz9w8bi5CpR09coBNKO2oEp69xdbVyG4HFW64EX07DD4On0RQRIMK0sGSVR7SdZRSuDLusMbeJj67S89cqWuANv5/aQJwR2aZ4OifG9IdgUgmOGRdDhxtgMDImwifTpM7J8RmK/57GhcBn1Lgi8O+AxUJ6Ag3dzkte+hMW4glmsgV4uN1Hb8p1pgTXGkcRSsPrJMVkZoKE87q5+lf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(346002)(39860400002)(376002)(8936002)(5660300002)(38070700005)(2906002)(7416002)(6916009)(66556008)(54906003)(316002)(66446008)(76116006)(91956017)(66946007)(36756003)(8676002)(4326008)(6512007)(186003)(66476007)(41300700001)(6486002)(6506007)(2616005)(478600001)(122000001)(38100700002)(86362001)(71200400001)(64756008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzJ5bHVJU0FQYW1TeXZvTE82M0lUaSsreFBYVjhRZklFYTVUd1YrelhsdEpX?=
 =?utf-8?B?Mm91cWJ4RnhmWlgvNXVEOE5hYjltSEFodEhoclBadHFNNW45L0xDRnZFVHBS?=
 =?utf-8?B?QTVPZmJYK1l4eFhXaVRYVVZsNXF0V2Z6Q2FJOEFXeUVCYWZrTGU1NDhLREM5?=
 =?utf-8?B?enhEVEZkN1dST0M5aFl4ZlhBWjduZHVmemJHMWpqdjU0OXA2WEkrcDJVZkhy?=
 =?utf-8?B?MXJkWWVoaGZ0bDh0b0pUQVBNRFhtaXV6aVFiRjI5ZnNVWmVMdjYzdGE2Ynpl?=
 =?utf-8?B?aGI4Sml6YVJYSm9meTZtaVlQT0docVErQU5IZ1BSN0Q0SXdINmRRM3M1cFk0?=
 =?utf-8?B?T0c2S0VOUkpvRUxuM05QOUVJc1RWa2pnL1ZhUnhwSmVmcG9sbFNuVGgxalk5?=
 =?utf-8?B?eXovQ3RONVhIa0FkVExGOUdzaDhGRExTMTFqK3lwWDByR3c4L21UQ3lxK2JM?=
 =?utf-8?B?RHpvTUgrd1JLMG9QbTRDdWpvZnNPYldoeDJKclpVbnlyRk5wT0lLWkNvL0xl?=
 =?utf-8?B?L1B6SGVoTytEdkpjamUyelVLSXNjTTdUeFJabktWNDg3d0ZvSnRqWGsvZTRU?=
 =?utf-8?B?d3hiZnQrMlRmNXh0dnlaNi9ROG01NndpNUZrUk1zaTJSb2NtdGFobEt1MXlD?=
 =?utf-8?B?VS95ejErNElPU2xUV3QrZDZGc2tBakl0UUR5dzN1T09yVVNudWUzVkgvZ0Zx?=
 =?utf-8?B?TDk3LzgyeU8vQnFyKzYxZDFWTTlqdWFzYllZR28rdnZrb29id2hlenYrUnFa?=
 =?utf-8?B?UGFtS1ByNVhEUjRVQjVuMWFNOHcvU3VVWGpvVzczNnNVNnhLOG5rVnoyM1Nm?=
 =?utf-8?B?RnBiRjllTHk1OVU2am9CRDI1UEVqY3UvZkRMMmZOcFM2TlNRbEFaWWI2eWsy?=
 =?utf-8?B?R283Z0pjSEJ2aTNHQ1VUNERGTVZqaGdvL0lBMDVWejZOYjVWcnBHQzJtRFp6?=
 =?utf-8?B?Vm1XUHdIamJKcm5OU1E3VE1reUFiRHUzU29ZQ2tiUTJWeVdxaWtha1RsUU1D?=
 =?utf-8?B?NHBYd0RMd3FCa2x4SW9RS1ZiNXg5c1Rla08zRzFsVlV4NVRSUVhBOWVVTWlq?=
 =?utf-8?B?ajR3czhtTUVGWnpWR3ZMQlp1bTZmRkx4aDFaR3RUQ1BUdHJwSHpzS0QreDN1?=
 =?utf-8?B?ZU4wdk1TdW14MXdrdS9MNnF5L3FKZHlFL1dtSG9peG01TzdnVWFUYVV3R0d2?=
 =?utf-8?B?cTBrYnJSNHc5dXFqdDFTSFdLMVVteEg1ZjZiOVpEamFwemNLWHhsVGhTSUZh?=
 =?utf-8?B?MmhLSWVMRm9IYkVBVmhnYmVSZ0p0TkhSYncrWkNsSU5aZUlJbGZjZVdhaDl5?=
 =?utf-8?B?L1RUMnNqUzlSNjlVUTNqWk5zRmtTR0V1WlpHZm1jZGNVc1Bsai9Jd01nYUw1?=
 =?utf-8?B?Wk1MMEtGM2pjV0hRL3ZFY1htcGg4eGNaWWhFTEprUG1hayt0YWFzVGFrL3B6?=
 =?utf-8?B?c1dqZExhS3UxTUlOblI4cUU0Z00yZkRMWEJjdVdzdFhiYy9nb2Z2L0xrdFBU?=
 =?utf-8?B?ZnVPUXJtcWw1SDlwb3JqWnE5VFZueDlGS2V3M241WFNnUkczeU83TExLM3dM?=
 =?utf-8?B?OVNIMC91RUw1RUIwTWI5dFBGbDc0UWlrT2cyRkxoY1k2bFNwSkJCN0NXc3cy?=
 =?utf-8?B?L2JTY0JEcGVibGdkbVJ4ZlNNalI5WmliRGE2MDBsZ3VTMUZuUDFZaTdsaHNa?=
 =?utf-8?B?aS9MUkYrTTRBMGIwSlNkQkZDaVp6dEdXay92OXBMSVV2eTdSR0thWGhXcy9Q?=
 =?utf-8?B?S244UzZzY1Q1OHByNithZngwUFRpSkJFQlpSNXdyamRHQVROY0xjS1ZUVDlD?=
 =?utf-8?B?Y0RvM093OUl2Yld1b2lKMG1ENGNDMEpqbUdJTzBiRDBMWEpqb1NJV08vWFlR?=
 =?utf-8?B?Q1RFSVRpdTFiUnpCamUvZWVRUFdJeXFrbk9hcFd4OVlKS3A2NmFsQ1VmNjFD?=
 =?utf-8?B?QWZTa1Vydkd3dDdtREo3eTExY1drUHlVRzdwWUpCc1E0T0x1T3VPczZuRWJG?=
 =?utf-8?B?RFVRV2xBb1I5RzJWN0R2OWNQdU9HZ3ViQ2NSNHdKK3lLZ0VVVUE3d2VvWm5V?=
 =?utf-8?B?YUVFbGhUeUF0ZEZvTlhndmR3VXE1a2h3Y2p5QjhFcnNNTGk1amU4d20xcjV5?=
 =?utf-8?B?NE9IczVvcktFdFRYU2ZYYlVGQWhzTy8rZjRJNU5iWTlUeEJVejBVMEZpMWhq?=
 =?utf-8?B?VXpLcFRETXBCVFd4elZxRFFxVzQ5eUxrWXo5TWRuT3A5V3Z0Q0VXaHBMYlpX?=
 =?utf-8?Q?vs7w+vcCaJBYv/z+iGoaX3SuPMLAyJ7hqahuSppx1Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <924F6464C1292F488826C8D08371271E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b8d6a0-0806-41c6-ed63-08da6a5f5c07
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 14:51:42.4651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X+8+xlqROKFC6mohfU9hGFatMDAy3j54mMOWEeqRGBwsSYjQHfismGwfMtYXkVx9lWprjGonkGwfhdlC/lSlzfyXESfmxIC8yq19LNRuWe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5945
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTE5IGF0IDEzOjI1ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVHVlLCBK
dWwgMTIsIDIwMjIgYXQgMDk6MzM6MDVQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIGFwcGx5IHRoZSByZ21paSBkZWxheSB0byB0aGUgeG1paSB0dW5lIGFkanVz
dCByZWdpc3Rlcg0KPiA+IGJhc2VkDQo+ID4gb24gdGhlIGludGVyZmFjZSBzZWxlY3RlZCBpbiBw
aHlsaW5rIG1hYyBjb25maWcuIFRoZXJlIGFyZSB0d28NCj4gPiByZ21paQ0KPiA+IHBvcnQgaW4g
TEFOOTM3eCBhbmQgdmFsdWUgdG8gYmUgbG9hZGVkIGluIHRoZSByZWdpc3RlciB2YXJ5IGRlcGVu
ZHMNCj4gPiBvbg0KPiA+IHRoZSBwb3J0IHNlbGVjdGVkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEFydW4gUmFtYWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiAtLS0N
Cj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9sYW45Mzd4X21haW4uYyB8IDYxDQo+ID4g
KysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAv
bGFuOTM3eF9yZWcuaCAgfCAxOCArKysrKysrDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNzkgaW5z
ZXJ0aW9ucygrKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2xhbjkzN3hfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2xhbjkz
N3hfbWFpbi5jDQo+ID4gaW5kZXggZDg2ZmZkZjk3NmIwLi5kYjg4ZWE1NjdiYTYgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9sYW45Mzd4X21haW4uYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvbGFuOTM3eF9tYWluLmMNCj4gPiBAQCAtMzE1
LDYgKzMxNSw0NSBAQCBpbnQgbGFuOTM3eF9jaGFuZ2VfbXR1KHN0cnVjdCBrc3pfZGV2aWNlICpk
ZXYsDQo+ID4gaW50IHBvcnQsIGludCBuZXdfbXR1KQ0KPiA+ICAgICAgIHJldHVybiAwOw0KPiA+
ICB9DQo+ID4gDQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBsYW45Mzd4X3NldF9yZ21paV90eF9k
ZWxheShzdHJ1Y3Qga3N6X2RldmljZSAqZGV2LCBpbnQNCj4gPiBwb3J0KQ0KPiA+ICt7DQo+ID4g
KyAgICAgdTggdmFsOw0KPiA+ICsNCj4gPiArICAgICAvKiBBcHBseSBkaWZmZXJlbnQgY29kZXMg
YmFzZWQgb24gdGhlIHBvcnRzIGFzIHBlcg0KPiA+IGNoYXJhY3Rlcml6YXRpb24NCj4gPiArICAg
ICAgKiByZXN1bHRzDQo+ID4gKyAgICAgICovDQo+IA0KPiBXaGF0IGNoYXJhY3Rlcml6YXRpb24g
cmVzdWx0IGFyZSB5b3UgcmVmZXJyaW5nIHRvPyBJbmRpdmlkdWFsIGJvYXJkDQo+IGRlc2lnbmVy
cyBzaG91bGQgZG8gdGhlaXIgb3duIGNoYXJhY3Rlcml6YXRpb24sIHRoYXQncyB3aHkgdGhleQ0K
PiBwcm92aWRlDQo+IGEgcC0+cmdtaWlfdHhfdmFsIGluIHRoZSBkZXZpY2UgdHJlZS4gVGhlIHZh
bHVlIHByb3ZpZGVkIHRoZXJlIHNlZW1zDQo+IHRvDQo+IGJlIGlnbm9yZWQgYW5kIHVuY29uZGl0
aW9uYWxseSByZXBsYWNlZCB3aXRoIDIgbnMgaGVyZS4NCg0KVGhpcyBpcyB0aGUgdmFsdWUgd2Ug
Z290IGZyb20gdGhlIHBvc3Qgc2lsaWNvbiB2YWxpZGF0aW9uIHRlYW0gd2hpY2gNCmhhcyB0byBi
ZSBwcm9ncmFtbWVkIHRvIGRsbCByZWdpc3RlciB0byBnZXQgdGhlIHByb3BlciBkZWxheS4gVGhl
IHZhbHVlDQppcyBkaWZmZXJlbnQgZm9yIHJnbWlpIDEgYW5kIHJnbWlpMi4NCg0KPiANCj4gPiAr
ICAgICB2YWwgPSAocG9ydCA9PSBMQU45MzdYX1JHTUlJXzFfUE9SVCkgPyBSR01JSV8xX1RYX0RF
TEFZXzJOUyA6DQo+ID4gKyAgICAgICAgICAgICBSR01JSV8yX1RYX0RFTEFZXzJOUzsNCj4gPiAr
DQo+ID4gKyAgICAgbGFuOTM3eF9zZXRfdHVuZV9hZGooZGV2LCBwb3J0LCBSRUdfUE9SVF9YTUlJ
X0NUUkxfNSwgdmFsKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArDQo+ID4gIEBAIC0zNDEsNiArMzgz
LDI1IEBAIHZvaWQgbGFuOTM3eF9waHlsaW5rX21hY19jb25maWcoc3RydWN0DQo+ID4ga3N6X2Rl
dmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiAgICAgICB9DQo+ID4gDQo+ID4gICAgICAga3N6X3Nl
dF94bWlpKGRldiwgcG9ydCwgc3RhdGUtPmludGVyZmFjZSk7DQo+ID4gKw0KPiA+ICsgICAgIC8q
IGlmIHRoZSBkZWxheSBpcyAwLCBkbyBub3QgZW5hYmxlIERMTCAqLw0KPiA+ICsgICAgIGlmIChp
bnRlcmZhY2UgPT0gUEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJX0lEIHx8DQo+ID4gKyAgICAgICAg
IGludGVyZmFjZSA9PSBQSFlfSU5URVJGQUNFX01PREVfUkdNSUlfUlhJRCkgew0KPiANCj4gV2h5
IG5vdCBhbGwgUkdNSUkgbW9kZXMgYW5kIG9ubHkgdGhlc2UgMj8gVGhlcmUgd2FzIGEgZGlzY3Vz
c2lvbiBhDQo+IGxvbmcNCj4gdGltZSBhZ28gdGhhdCB0aGUgIl8qSUQiIHZhbHVlcyByZWZlciB0
byBkZWxheXMgYXBwbGllZCBieSBhbg0KPiBhdHRhY2hlZCBQSFkuDQo+IEhlcmUgeW91IGFyZSBy
ZWZ1c2luZyB0byBhcHBseSBSR01JSSBUWCBkZWxheXMgaW4gdGhlICJyZ21paSIgYW5kDQo+ICJy
Z21paS10eGlkIg0KPiBtb2Rlcy4NCg0KSSBoYXZlIHJldXNlZCB0aGUgY29kZSBvZiBrc3o5NDc3
IGNwdSBjb25maWcgZnVuY3Rpb24gYW5kIGFkZGVkIHRoZSBkbGwNCmNvbmZpZ3VyYXRpb24gZm9y
IGxhbjkzN3ggZmFtaWx5IGFsb25lLiBBbmQgdW5kZXJzdG9vZCB0aGF0IGlmIGRldmljZQ0KdHJl
ZSBzcGVjaWZpY2llcyBhcyByZ21paV90eGlkIHRoZW4gYXBwbHkgdGhlIGVncmVzcyBkZWxheSwg
Zm9yDQpyZ21paV9yeGlkIGFwcGx5IGluZ3Jlc3MgZGVsYXksIGZvciByZ21paV9pZCBhcHBseSBi
b3RoLg0KRnJvbSB5b3VyIGNvbW1lbnQsIEkgYW0gaW5mZXJyaW5nIHRoYXQgYXBwbHkgdGhlIG1h
YyBkZWxheSBmb3IgYWxsIHRoZQ0KcmdtaWkgaW50ZXJmYWNlICJyZ21paSoiLg0KQ2FuIHlvdSBj
b3JyZWN0IG1lIGlmIGFtIEkgd3JvbmcgYW5kIGJpdCBlbGFib3JhdGUgb24gaXQuDQoNCj4gDQo+
ID4gKyAgICAgICAgICAgICBpZiAocC0+cmdtaWlfdHhfdmFsKSB7DQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgIGxhbjkzN3hfc2V0X3JnbWlpX3R4X2RlbGF5KGRldiwgcG9ydCk7DQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgIGRldl9pbmZvKGRldi0+ZGV2LCAiQXBwbGllZCByZ21paSB0eCBk
ZWxheQ0KPiA+IGZvciB0aGUgcG9ydCAlZFxuIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgcG9ydCk7DQo+ID4gKyAgICAgICAgICAgICB9DQo+ID4gKyAgICAgfQ0KPiA+ICsN
Cj4gPiArICAgICBpZiAoaW50ZXJmYWNlID09IFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01JSV9JRCB8
fA0KPiA+ICsgICAgICAgICBpbnRlcmZhY2UgPT0gUEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJX1RY
SUQpIHsNCj4gPiArICAgICAgICAgICAgIGlmIChwLT5yZ21paV9yeF92YWwpIHsNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgbGFuOTM3eF9zZXRfcmdtaWlfcnhfZGVsYXkoZGV2LCBwb3J0KTsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgZGV2X2luZm8oZGV2LT5kZXYsICJBcHBsaWVkIHJn
bWlpIHJ4IGRlbGF5DQo+ID4gZm9yIHRoZSBwb3J0ICVkXG4iLA0KPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBwb3J0KTsNCj4gPiArICAgICAgICAgICAgIH0NCj4gPiArICAgICB9
DQo+ID4gIH0NCj4gPiANCg==
