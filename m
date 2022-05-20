Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604D152E465
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243365AbiETFgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiETFgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:36:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB5192AC;
        Thu, 19 May 2022 22:36:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDuqov+X1MGrLQoy2PIg9vEERx6pNlbd7t655fYwJX+25PSV2Bf7xq2jjhcH9Vk8zcidh3RrJyXSVJ1f1AFHML1K3/6mtOsuitkwK+tb/UOE6jgsbQXPE3IbTP14tLH+HaStdr8pjZlR1CCGFmt6HqnUGyg6lPqp2ZKcTGZmWcvfkYxNQxhlKGt/hPwezf15/ddiecliStvZz/gPWKiBDjm65GIV7ykWFedNB7gZkE21krBMppRLYU6A2HYyo4cUOcTnzOjuOfGX4NwuGjTON+Ks8KGSbY0novfmsK/qiIZSgQ5XUwKKutJRUrVyGKMrD59Et1YvKGxL/XnJBoYGww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+Xhk3f2PNpc6K2Hvrqo8nXGECCyOtlyYMk6p5Sljt8=;
 b=ctauCsTZ0J8Gvdoblt9JfwJTU3OYJ5qv6t/GY+cCERzbjZfjaZ/iAdYclOuUCKJU+v6OgrhAUeUaz2DNjIIKA24dF4T4ZwtufSfzE/yESDp9xn3eddEvjYYuomE3m1JOfDX7HJOftsjKjqg2UL6qfm9aYhte32Cg43vv6vjH/RW4HAi9//frQ5SmBc8LHN4ywlZMZBVtws5FiJ+yeT2BglJcqk6TIcK6lRBI+lr3OT+IGBKeNx9TfEzKOz5WWxpR/H2/vtqObPImH2UkmR69CA+R45ioCSof//ob/nvxbXwrJCor62JprKLwSt8l60qvk6+RtVEXrEtpqmyIbIkuQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+Xhk3f2PNpc6K2Hvrqo8nXGECCyOtlyYMk6p5Sljt8=;
 b=h/gYECHKv8uSYs3Y7GqEbb6qR2BA/ijumNGRnICcEKAKT0HENkcTRUHeaY6Pugp+j/ibbmad+UG8iewdzr4V4K/Bgf+WN7TGhy9UnpfgYrAm9TV226nGz4uffUSQDfmIVIuVx1/0SVGkz197RwvmV2bh84cMdce3GwU2OUkV9UQ=
Received: from BL3PR02MB8187.namprd02.prod.outlook.com (2603:10b6:208:33a::24)
 by SA2PR02MB7820.namprd02.prod.outlook.com (2603:10b6:806:14e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Fri, 20 May
 2022 05:36:11 +0000
Received: from BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::1065:9b01:3481:47eb]) by BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::1065:9b01:3481:47eb%4]) with mapi id 15.20.5273.016; Fri, 20 May 2022
 05:36:11 +0000
From:   Harini Katakam <harinik@xilinx.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "harinikatakamlinux@gmail.com" <harinikatakamlinux@gmail.com>,
        Radhey Shyam Pandey <radheys@xilinx.com>
Subject: RE: [PATCH net v3] net: macb: Fix PTP one step sync support
Thread-Topic: [PATCH net v3] net: macb: Fix PTP one step sync support
Thread-Index: AQHYatncNlifgBNK7kePTqv2HBgN6q0mg9AAgAC9KaA=
Date:   Fri, 20 May 2022 05:36:10 +0000
Message-ID: <BL3PR02MB81874B2E48A1FC160F201DEDC9D39@BL3PR02MB8187.namprd02.prod.outlook.com>
References: <20220518170756.7752-1-harini.katakam@xilinx.com>
 <3ecbe9d60f555266fe09d5a8c657b87d6f7564b8.camel@redhat.com>
In-Reply-To: <3ecbe9d60f555266fe09d5a8c657b87d6f7564b8.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8639e181-6d7a-4832-601a-08da3a22a5bf
x-ms-traffictypediagnostic: SA2PR02MB7820:EE_
x-microsoft-antispam-prvs: <SA2PR02MB78205BE455C3BA568918612EC9D39@SA2PR02MB7820.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KSB+vDhfnRw8RPBwdm70j/ZUUo4YKr1/ScCFQdFU9zSje6+RFQ/eubz/VVg5sumWjnuFE/ERa8y1bXiSQ0sgl0HWgvsV41s3y69Y+VUKzjxTaL8R4UpHCYAU/Er9ammxdgl8q7KZreUdO0BgVsCA1gwwPj3Y+FsiZZeeq1wH+6cRLnKj79EB6H9R+VIGUiU3UjIM9BS34s5hQ/V4Vkt8KhtO6FDFTdTaOc4xNFkfOcYJz4xIbY0LPEoFPQXooGMJMMWE+X3Bxrr+vIOtf+uJjmJyF6Oo5auA00PMIjZk4xODrLla8jejhAMAtAuCEILNwok8JaNUyEHBW7u2aiiCZXwsVn9ctCeCUxReDyzjfY0HWTz27irsqBjOThjED9Os6GaFieohGp2WukdYOBP74DdvHCyZzY7mmdx8sFjLhO5hVMULvGP+2JhnChZGzyJKp5k/vfRCMhnLEnI9Ib5J7jBQfL4Xq4/Au7gxIeI4/T3T9r9BedfoFOlKpzZqgKOmGoN/Hk43dEk0JWKfQx+eX03s9py1GgPt00YJeQ+qGW5zIxTTyhJJzLdhf3Vx0OnNcNfuAcd8kVGbfs6GBUY+GwbqcUoGErw9hCbGD6KosEH5EgH0Q2qLWGSXo+wz/nmSgJ43pBZ83V2pKyrdT1ZA8nLdRXyBk4Tu8G1n0hLtwHNSIY8VrHez9rcaHKwz8UzKD+8QeaaJmBHEyWKoefgktQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR02MB8187.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(66446008)(64756008)(66476007)(55016003)(508600001)(7416002)(5660300002)(71200400001)(86362001)(2906002)(110136005)(38070700005)(38100700002)(122000001)(66556008)(66946007)(76116006)(6506007)(83380400001)(186003)(316002)(8676002)(8936002)(52536014)(53546011)(9686003)(26005)(107886003)(7696005)(4326008)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnRxRmNWL2dOb1hOZm1lLzhGbXhoUlhwK0pLSDZ5Y1FUSXFQZHIyMjBGK0I4?=
 =?utf-8?B?NHpRY3gzRnJmUnBUaE9ZOGdGSTVwOENZRWdiVk9Yd2J4NTZiYlZRbG9IVFp4?=
 =?utf-8?B?ODB1UXhDS21mSjNtK1NvVTRKenZieGc2ME80YlJLWUlkZTBNeFJtdlVOdFky?=
 =?utf-8?B?K3NMUXlackdad0lpaGg3QzRXTTZuMGtsdVF1LzV3RS81TmQzWitubTV3TEY4?=
 =?utf-8?B?Y2JZOEVNUmgxRnJHNXlSMHlqc3BJa2d2RkJMK1hZZnR3RVhLLzEyUDJFNTRa?=
 =?utf-8?B?U0FWTzgrSS82ZUVla0ZTcjR4bTNKc3IrQWpvM1YwTVQ1TXBGeVpaM0ZsbzNh?=
 =?utf-8?B?cDZFSVdGdXZWSEhzdEVpazVsSU1VbmhYTHl5a1B4QUZvV0llZmUxMkhvWFYr?=
 =?utf-8?B?dDVhMGo4SjQyaGJGbGNWOXlrYlk3ZUFEcFFEcG53cGpJSzlsU0R5YVoyY080?=
 =?utf-8?B?RjdOYlptQzdwRDdOVW9sYkNmL3NKQnNCZEQzSTl0Y3RyMm05T1BCT1M3UE5n?=
 =?utf-8?B?a3lHeVRJUWdOMmdiRXlPUVNqZU5OUmZoZ0lnYUFNRXdXVUZhVnN5ZUl4amFl?=
 =?utf-8?B?Sy9CWFVWdHJkT2w5RzR3b0ViQUJncmkxUTlIajU0bG9TbHdUQS9BcUhTb09N?=
 =?utf-8?B?ZnI3blN4aThyWEtmTGFkTWlqaWViSElXQk44Q0N3RzV1aXZuVVZBcjNua1N5?=
 =?utf-8?B?MUFEb0p1cmtaZmZUdGRDMkVPa1NPeFJjVHNVNENIWmlGVlBuMm9Rekt1TnBF?=
 =?utf-8?B?Z3oxVlpTVEI4WThOTnI1UVpIOENGR1AraFo2cFZFUkRMcWJBN3lnck9zbU9u?=
 =?utf-8?B?YWs1cmpOVHZBSmpoWEZ3VzRuQmNRSVJnb0I4YkJILzVrbTBPb3padzdzNUQw?=
 =?utf-8?B?aXBQTFd0UGdzWi9VNll1eXluc1RkMFVPbkV0UFNxUjNDQSs4OVNyRnlxemNN?=
 =?utf-8?B?TUJTdTNnaWhXeDVoRHgxcTdxWVJsNTdlMHZ2NjY3ME5OT0xCR0k5a2F0dDZs?=
 =?utf-8?B?aDJXV1VBMkxudmx3WEdBcDh2emRPb1pHaEx1QjNwak11NWYrY0FiRi8xU09w?=
 =?utf-8?B?Qm9YQTE4dlhHS2F0cWhUTVRJRGdhVU8wTWVtaGwrOWZIcmtFVER4YlZTZ1Vx?=
 =?utf-8?B?YitsdEZJZ2JKNEtsMFByRit4OW5MZWozVDVpY3BLNEhwVkdvL29SQlM5WHhs?=
 =?utf-8?B?NjRiUG55NXZTL3lvUElORC9rMFcrNG5XY0pqemhucmRjelQ3aytxWkRhUDdJ?=
 =?utf-8?B?eEtIL3RTaUY3RDBNZ3NHZmZIcUJnbmpJTzFPTENFYzhiVjR2Znl1RHpkbGk5?=
 =?utf-8?B?cEw0c0xGcHdFSFZtc0FtN2x0cUpwMWtxNEpUOGxGY3lCZ0F0WFpYVWxjNmQr?=
 =?utf-8?B?T3IzQmpxWW9sNGlrR05qMGJlVzZxUU1tYmRLcTdaL1VDT0o1K2puaDg5WmNp?=
 =?utf-8?B?SzNkZm40Z01BVXJRQ1diempNc20zd3NMM05mdU9PVm9TRnNUK2d2bE9WK2xr?=
 =?utf-8?B?by9FNDJKdmRDVFlSdkZGTThhYUhDUW9GQ2s2VSt1eHQrbUZibWlyYk1ZQzNx?=
 =?utf-8?B?TmRwdmZaUTFodmxYTGRaUFlSMVNyY3Z4RDlENEsxMHBKQ3lJeHFGRGkvcTdF?=
 =?utf-8?B?OUd4RCtsVTc4WEY2SitJR20xSDNLT3hYWElqeW5DS29WdjNRMlBrWmxuNGNC?=
 =?utf-8?B?dG9GZk40VVd2dWFFSzVjaFl2dFhzNzQ0TUdYRXdjL0k4YlczdVhkditxNUEv?=
 =?utf-8?B?VENWRXdGSjBtYXNSU3JBL3V6QUxlanltWFBIVnRwaXZ0eCtaazBNQmlMeVk2?=
 =?utf-8?B?YmhHNDRjb3NnaE5KM21udk1qWnNuSktqMUp6cUdQYlFBM3VaeStJUjZsb29L?=
 =?utf-8?B?bmxJL3NPQ2p1TThxYmF6SW9wdGR5MVpoZHBPYjYzK3Y0bWU0VU9sMWM5dm9J?=
 =?utf-8?B?UXhYaTZ3Qy9DMmxLYS9uQm5xOTdzVWRnWnZBaWMzZm91Y2dTdUdWTkVQa3N1?=
 =?utf-8?B?TmNwT25MaXNOa2toZW9TL2hCTHNNN0huSFZpUStLU00wWUdBUHFnaitRZVU3?=
 =?utf-8?B?OVRzeHovUG01YTFBdkxybmVGU3AvR1dIR25LTmRtQTYxZ3NVSWxVZ0dFWjBJ?=
 =?utf-8?B?VE1HRTZhM3JDWmFwdUY0S01raXplSDdTZUxqZlZjbUpuVGZsOUJlSWs3V1oz?=
 =?utf-8?B?elBORlNPZjBLVWtESkVXR1lpdk1XeEs0b3dzMEEzZ05KNnNZbnIrdkI2QkNt?=
 =?utf-8?B?a3p6Z1ZuSXAzY2NNczlIaGVZSktKVkp4RTJWRnNIT1RvVVpSaXpJc2xzMnA4?=
 =?utf-8?B?ckdiTFdYcFhmSGRPNU95VSsyVUdrRU9BRXlwZjlvc3dvTm1LT2N6Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR02MB8187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8639e181-6d7a-4832-601a-08da3a22a5bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 05:36:10.9958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s0ryS0jyJcUFfWEOml0XhV4MbcQWGIhJUr7Vnj1+KkQ7BZtOD9OhJQ56kBkN9odZRf0O40atEsLt8tdH/4Wu9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7820
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGFvbG8gQWJlbmkgPHBh
YmVuaUByZWRoYXQuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDE5LCAyMDIyIDExOjQ4IFBN
DQo+IFRvOiBIYXJpbmkgS2F0YWthbSA8aGFyaW5pa0B4aWxpbnguY29tPjsgbmljb2xhcy5mZXJy
ZUBtaWNyb2NoaXAuY29tOw0KPiBkYXZlbUBkYXZlbWxvZnQubmV0OyByaWNoYXJkY29jaHJhbkBn
bWFpbC5jb207DQo+IGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb207IGt1YmFAa2VybmVsLm9y
ZzsgZWR1bWF6ZXRAZ29vZ2xlLmNvbQ0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgTWljaGFsIFNpbWVrDQo+IDxtaWNoYWxzQHhpbGlu
eC5jb20+OyBoYXJpbmlrYXRha2FtbGludXhAZ21haWwuY29tOyBSYWRoZXkgU2h5YW0NCj4gUGFu
ZGV5IDxyYWRoZXlzQHhpbGlueC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IHYzXSBu
ZXQ6IG1hY2I6IEZpeCBQVFAgb25lIHN0ZXAgc3luYyBzdXBwb3J0DQo+IA0KPiBPbiBXZWQsIDIw
MjItMDUtMTggYXQgMjI6MzcgKzA1MzAsIEhhcmluaSBLYXRha2FtIHdyb3RlOg0KPiA+IFBUUCBv
bmUgc3RlcCBzeW5jIHBhY2tldHMgY2Fubm90IGhhdmUgQ1NVTSBwYWRkaW5nIGFuZCBpbnNlcnRp
b24gaW4gU1cNCj4gPiBzaW5jZSB0aW1lIHN0YW1wIGlzIGluc2VydGVkIG9uIHRoZSBmbHkgYnkg
SFcuDQo+ID4gSW4gYWRkaXRpb24sIHB0cDRsIHZlcnNpb24gMy4wIGFuZCBhYm92ZSByZXBvcnQg
YW4gZXJyb3Igd2hlbiBza2INCj4gPiB0aW1lc3RhbXBzIGFyZSByZXBvcnRlZCBmb3IgcGFja2V0
cyB0aGF0IG5vdCBwcm9jZXNzZWQgZm9yIFRYIFRTIGFmdGVyDQo+ID4gdHJhbnNtaXNzaW9uLg0K
PiA+IEFkZCBhIGhlbHBlciB0byBpZGVudGlmeSBQVFAgb25lIHN0ZXAgc3luYyBhbmQgZml4IHRo
ZSBhYm92ZSB0d28NCj4gPiBlcnJvcnMuIEFkZCBhIGNvbW1vbiBtYXNrIGZvciBQVFAgaGVhZGVy
IGZsYWcgZmllbGQgInR3b1N0ZXBmbGFnIi4NCj4gPiBBbHNvIHJlc2V0IHB0cCBPU1MgYml0IHdo
ZW4gb25lIHN0ZXAgaXMgbm90IHNlbGVjdGVkLg0KPiA+DQo+ID4gRml4ZXM6IGFiOTFmMGE5YjVm
NCAoIm5ldDogbWFjYjogQWRkIGhhcmR3YXJlIFBUUCBzdXBwb3J0IikNCj4gPiBGaXhlczogNjUz
ZTkyYTkxNzVlICgibmV0OiBtYWNiOiBhZGQgc3VwcG9ydCBmb3IgcGFkZGluZyBhbmQgZmNzDQo+
ID4gY29tcHV0YXRpb24iKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEhhcmluaSBLYXRha2FtIDxoYXJp
bmkua2F0YWthbUB4aWxpbnguY29tPg0KPiA+IFJldmlld2VkLWJ5OiBSYWRoZXkgU2h5YW0gUGFu
ZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+IA0KPiBJJ20gc29ycnksIGJ1
dCBJIGN1dCB0aGUgLW5ldCBQUiB0byBMaW51cyB0b28gZWFybHkgZm9yIHRoaXMsIHNvIHRoZSBm
aXggd2lsbCBoYXZlIHRvDQo+IHdhaXQgZm9yIGEgbGl0dGxlIG1vcmUgKG5vIG5lZWQgdG8gcmVw
b3N0ISkgYW5kIGV2ZW4gbW9yZSBwYXVzZSB3aWxsIGJlDQo+IHJlcXVpcmVkIGZvciB0aGUgbmV0
LW5leHQgZm9sbG93LXVwLg0KPiANCj4gU29ycnkgZm9yIHRoZSBpbmNvbnZlbmluY2UsDQoNClRo
YW5rcyBQYW9sby4gTm8gcHJvYmxlbSwgd2lsbCB3YWl0IGFuZCBzZW5kIG5ldC1uZXh0IGZvbGxv
dyB1cC4NCg0KUmVnYXJkcywNCkhhcmluaQ0KDQo=
