Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4274E6AE2
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355535AbiCXWsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 18:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiCXWsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 18:48:21 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50090.outbound.protection.outlook.com [40.107.5.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32393BAB87;
        Thu, 24 Mar 2022 15:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntZBLZlS3bxnighcrjV8cm04ybQrXbvWuy7nsFA9nktd91MdVBmWNZdDNGHFGR7/LPuKf2mEeOYQMy2v2re9XXx+kPrmU+pZi+Yy2mhMHB4lBKSXRWI8N7qCtOigFZVKcJgu/H3uJXSrpFu6tQM73dzUpgPYO1dY9AOkjxD2rwIZ0U/abYYJtJHFfdpS2y4Uu0Y9nBviwT9WaLGPurzwWh7KkMFrgbC2VFwVnSU9YPw5kS+TuR8TpzgAEOpV+NDDgae3NqBtJHoq8ZfDP+AVuNVsqSTjxseNDfKrt9UG2ZvNAdFHumx2Uu45mfaHxf9uzgq2ASqSzWBPHaHY5W2i+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LSoFD52XqiR9uBW5Yn+sPL7hg8nm9gfRjKO9pdAm2w=;
 b=gxFOduZi0N1NO/J8XzAxoEAaYxsAQu2pLZ3/b3OBOrkKIhVx3kKfq8zWccUrX+1Vi6QwOVTnH340gTHnk1P/J3X6+8msOlS86yVeniKksP7jpujaHw8ZzWhmlPdSKWyUptBOt+tIAQkKtmdFsjibTrzFJN2nwNJqVtCySHuAd2DNV99JDc+Rf1IZJh07IGDWHPaSxmqpcE9w+nnMfkbvY38JIfYLRPYoWQUeI0NMA88MmdX6HjK91sYiyoQAPpEZLTxU6jppbeSpqG0JE93AgVjuJRGhrObLl0tQarR0pvGjATjwmJI/MCmTf0Gf+SOyUZQb7RJCzkCthukoSIOSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LSoFD52XqiR9uBW5Yn+sPL7hg8nm9gfRjKO9pdAm2w=;
 b=pG6a7wp5FcubqO2n3+lF/DU74GcSdp/Q9ppQKpmhDnnRmz8oWeU7ygiy5wKZMypBQn5h4S1QW4wNMjaCCYkYNGyShuFydfAV4r2JbFT172mEf8hQZGsHm+yDMa5eA8s2Ue0kYv8uNr5MTP43Obbpktx7prCtyTF+H5mSQe9InZU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PA4PR03MB8158.eurprd03.prod.outlook.com (2603:10a6:102:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.22; Thu, 24 Mar
 2022 22:46:45 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::3ce4:64bf:3ed:64c2]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::3ce4:64bf:3ed:64c2%6]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 22:46:45 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: realtek: make interface drivers depend
 on OF
Thread-Topic: [PATCH net-next] net: dsa: realtek: make interface drivers
 depend on OF
Thread-Index: AQHYPrNz45zCE6bCjEaBGmJXraNsLKzM7dWAgAAOeACAAB7GgIABEvgAgADw6gCAAAW2AA==
Date:   Thu, 24 Mar 2022 22:46:45 +0000
Message-ID: <20220324224644.6ot2hgfydf7sjvit@bang-olufsen.dk>
References: <20220323124225.91763-1-alvin@pqrs.dk> <YjsZVblL11w8IuRH@lunn.ch>
 <20220323134944.4cn25vs6vaqcdeso@bang-olufsen.dk>
 <20220323083953.46cdccc8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220324080402.wu2zsewgqn2wecel@bang-olufsen.dk>
 <CAJq09z62hjhfW_TYWt1tfmzVTnxzr=pyXq7a2mf55sv0EOhn4Q@mail.gmail.com>
In-Reply-To: <CAJq09z62hjhfW_TYWt1tfmzVTnxzr=pyXq7a2mf55sv0EOhn4Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a9d377d-8e19-4656-aa1a-08da0de82c3a
x-ms-traffictypediagnostic: PA4PR03MB8158:EE_
x-microsoft-antispam-prvs: <PA4PR03MB8158D9CE185609404F18BAD383199@PA4PR03MB8158.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dVqXym2w+YdZxipA3a0HjsVRm+1iYRwxQI+2UZW9S99cMJFAR9lMBRzihd1Hsz/N0ZdbdNJLpm5gxuSnRZrBhJEs74NojNj7dB33mRiD4RpNBaPSJXQhjHjXnbWbx2Dl1ki9vi7Uy2BsrEos0/K3fa5xxzb3nIRfA9+iVFmadltYwPs8LAl7gztFxrtoUCVgnR/zAfkVlecnUjA0hbLQZhJQjj4dy/1gsEvs17pl1rs+uUANviqeof82nb7b4qnUQ6PSa0RP7+lqT7kMtIq1Jssh7LXLu5FUiPwBX4UGEEn4AdVVI3R/ZMOpSryUMN1VRcZ9ydCRK/2xELXaE1hl2ItJcemwS9VMOLM2XsSzbdfn/gISRzjAo9tyWmPtmcIREC/EzgIXkEDMehSrYYRnFmN02t2JvNaFLYCXtKxdZt+vkXHRVAIk964gdhMqr0hzeQ1MzuNY+qLfYOFJlR6W7lniMfe3DJC5YTHJB3PTj/kjC+SdT3riqVe9h+RyDzStkhqok/Q5W9KqlssEbNb5TYf5vAijAojTBTXbXUyshWVrMMcJRxkC440pNYfcKqR2xhfGS8s16uGYs7yeN6E1U/xOokyU9VxQ+uutqOmZQ6RzSFGD0fzSyrhlBP0mcbrU///FAd4Ysn6/v0QrgmOHKFwccq2nrTZ8Vq54HSGQ5nd7H82y5taScaobO6DyA6yiKmcXyJtIVPKLCu9PtzmFqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(8676002)(66446008)(64756008)(38100700002)(91956017)(6916009)(66476007)(4744005)(85202003)(4326008)(508600001)(86362001)(316002)(5660300002)(6486002)(6512007)(7416002)(66946007)(122000001)(8936002)(186003)(2906002)(6506007)(2616005)(1076003)(26005)(54906003)(36756003)(71200400001)(76116006)(8976002)(38070700005)(85182001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzFFYkpkaHpZb0pvalFYZVkvN0ZndzdSZllxTkl5dzBzTk45RGgzZVJ6ZmVT?=
 =?utf-8?B?OEZNN2xtZk92S3Ryd1BpWUJCOUhRWkJobEVBT3pxN3k2ZlNFQWIyWkE1eTZw?=
 =?utf-8?B?Y0N4cEdDOU4yTlBtSklQRGlwL2Q5SC9xN2xXWXgwWnBVYnVFeG5TVkEyRnIy?=
 =?utf-8?B?NTE5RVRlaFBaSmJjU0s1QWYwVml1ejFDMUpzVmMvb3Z2RWtkK3lISjZQb0Fp?=
 =?utf-8?B?OThzUm9pQ0c1ZjJZenA2TExaVjhLM3lhZEVIdkNMMmJQeDZRWU51NTJEb2JJ?=
 =?utf-8?B?dktZb0UrN3FFUUJUOE8rdHhpdGJkOWFtL3BDSEs0UVZuUVBGZThwT2lCZnhB?=
 =?utf-8?B?WXdsUCtJOWtCd2tYRlRWcHFya0tMaGRMY05XeXgxOXZFSUZ3M1dCVFQxc081?=
 =?utf-8?B?SkpZZnJIS3RkcmpJYnBjVTBWU1pKK0FBSlFLakZQSE9KVGxEUmNzbW1XaDhK?=
 =?utf-8?B?cnhGVnRtWHpDdWM4Z093Z0M5bEJ4VWxHSSs1TEZRSG0wa0lKWG9FM0FhMWRV?=
 =?utf-8?B?OWVkRk5WVWRnWDYrQXRVZ2k2U3pPWVIrcVVsZEQxc3ZsNktRRjI4K3JWclVN?=
 =?utf-8?B?M3BKeEJITnlVekNxb20xYy9qcHR3cHl0N0Y4d1hpSS9yaGZwTmVpZTRhcmZx?=
 =?utf-8?B?QmJqdUhhRjVQbTB4MVRxeFRMRkJBdXBwek1PSjZ2YldIcTk0Zm1mM1lkcDY3?=
 =?utf-8?B?dlBraURmcUp2TXV0NFFFNjQ5aFJyY1dsTnkrNDRURk9zaXRwWWsvY3dTc1Fa?=
 =?utf-8?B?c0dxRHJKckJ0QUwwMi9WTjBoWVRncjA0VkFtcjRFeVJ5VVBBaUkzMUpVcmZQ?=
 =?utf-8?B?ek5FL1VlNVZJc0VhbGtwSEg2MCs1L2svcVJZVHVVVVFyVlV4d2pNamtlb0VL?=
 =?utf-8?B?eERtbXpVQVd1N1dIK1pBVTZOOXY5VXlVWndSYmZWUDF4L0lIWFlhVWhzSlNo?=
 =?utf-8?B?d3Q4d0h6MUpOa2Z1NkIzSjUrVDU2VmFJc3ZlaEtGRk15OStKaUlsbHJLU1Z0?=
 =?utf-8?B?ZTZyRWFuUkh5Qk1YS2llclRBUjlvU0lhcEdrTnhUZEI5TkVMQVNNM09TUUhl?=
 =?utf-8?B?N0VTcXFvZ09NRENpZi9wVEoyY0FTOTk2TVFuU2J3Qi90K1dINjNWSW40dXRS?=
 =?utf-8?B?U3lPUWYwSnp1WnFIb1Q4SlRjRDlVYVhPZTlMRk9xQWdGRW5KK3hMcWYrSkQ2?=
 =?utf-8?B?TFMzU1hsZVhZVUo1WGdmN2NkcmxUS2d2cU9kckVHdmh4eW9zUUJTbHNsTWkv?=
 =?utf-8?B?elJWZTdSMlBlZnRUbVIrZGxRanpPc0pSM0VzbVpIVDZTVFBSaURHMzFhdDN0?=
 =?utf-8?B?V1hWOGg5RmQzOXMzOHN2cGN6RFpEWlFIQWlya3M5V0NhRTVUcDJicTVReVNv?=
 =?utf-8?B?RmlSdnpxY21uZHE0NU1id2tUOGVCT1hEQUZ5eFhUOTFDZ0JFQkhEZGdvUElS?=
 =?utf-8?B?eERHcm4rWnVKYVRQejBSZ051UktHRnQxTldqcmNxYjhKcUZpdkNReEQvc1Ar?=
 =?utf-8?B?RW5hOGFseWJtOEVrZnZ3eUVQSXlteFZ3aTlYK21zaGRHWGRrSExUOVZ1U2tz?=
 =?utf-8?B?RDdMOGFURHVFSnY2QmU5ZzZvSjJLT25qL2hsdFZ4b0hjY29aSDlSazIvZC9n?=
 =?utf-8?B?Q29WWnRrdnZaZUxhRzdVa1RaYVZTNXR2a1dFU2tnMEJmYnhCK004cHlwazVk?=
 =?utf-8?B?NktHMXpVeWpZRElEamxZa3NyRFR3eDg2akZKa05YNE5BUklNZ3YvM21VTXRz?=
 =?utf-8?B?OGZkaUFYU1dvQnNFam9oUTlFeitWOXNmSFVVZ3F5VllQTkZtd29yRDc0cHFV?=
 =?utf-8?B?RitNbWQyZU1iUXF0WE9lekc1RFNCVXlPWTQ3dFk1aURBZXRLWTRoMlFnWWZ3?=
 =?utf-8?B?MXJRQXNJQjR6VDlZR2k0aU1VSjBmTkNrdUxVUWRkamdWL0Z1akx1NU1zS2N6?=
 =?utf-8?B?NnFtVEhkck93ZkZRNGdvVnpxVjdyZTZ0Tkl2VmpXTXB1c0tyY0dIREwvaEZn?=
 =?utf-8?B?cGdRVTBjOXNnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B84CAD28CBE8104EA832F1ADFCFAB4C6@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a9d377d-8e19-4656-aa1a-08da0de82c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 22:46:45.1024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eCl72cGrmFLTt3g3433yjprU+KH5Vwutw3gXf7LAoVqNan5xaWZKwvC4xWSCl378KgYlWstpamj2ZY25DpLfgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB8158
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBNYXIgMjQsIDIwMjIgYXQgMDc6MjY6MThQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gPiBGaXhlczogYWFjOTQwMDEwNjdkICgibmV0OiBkc2E6IHJl
YWx0ZWs6IGFkZCBuZXcgbWRpbyBpbnRlcmZhY2UgZm9yIGRyaXZlcnMiKQ0KPiANCj4gVGhhbmtz
IEFsdmluIGZvciB0aGUgZml4LiBNYXliZSB5b3Ugc2hvdWxkIGFkZCBib3RoIGNvbW1pdHMuDQoN
Cldvb3BzLCB5b3UncmUgcmlnaHQuIE91Z2h0IHRvIGFsc28gY2FycnkgdGhpcyB0YWc6DQoNCkZp
eGVzOiA3NjVjMzlhNGZhZmUgKCJuZXQ6IGRzYTogcmVhbHRlazogY29udmVydCBzdWJkcml2ZXJz
IGludG8gbW9kdWxlcyIpDQoNClRoYW5rcyBMdWl6Lg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg0K
DQo+IA0KPiBBY2tlZC1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21h
aWwuY29tPg0KPiANCj4gUmVnYXJkcywNCj4gDQo+IEx1aXo=
