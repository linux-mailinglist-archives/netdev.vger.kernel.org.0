Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3F1691985
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjBJIEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:04:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBJIEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:04:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2041.outbound.protection.outlook.com [40.107.21.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA07B15A;
        Fri, 10 Feb 2023 00:04:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtDxmF6u/YgEHks5J8AKXQnI0YpElsQmoWLUa+ERDPq93iMCKvKoxBnwsXrER0EVzMuL0SWjhfVjS49QQo3tDoyH+j4uZUgLeVaHhaOV/TnJCSXEq6eb4gxNnCepRv03fFFYu/YHcEMKFAn5Bc+IU3HXHdywQXNnibgfOTzZf0jj/jTShgOYwwdTqOunlcumKZLdaIVrrebJbNqgEoESKiOdjyBYpZeqM5Lre7p13ycNRveGmiEdBptFY3NI/cSp2KlPbT4lloR65NVYerZPgZiDJ3htZXKGcAD536Li9swxrf0h/y6WR4Kbl9RXYFIDOgbAYQuu1MklgiGIWsZK3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CESV4ca9AJJ6Ua0wOiB+XuVsKqXXxZxATWz2eDqPK98=;
 b=kSQIX9GcOT9vLhm2F5zeHIQoL3IhuugL65xyJcEWOkTPI3emEX5VOXfMC+MrvjRPuoqk+/K1g7dIlDVoeZ0smtDMc3U4ogduOS1uTdnbA+G+15eqr6a1Htb/XzVrmHHGxWRDmR+HR/ZIfQdYXTiZTjUuEcwicMreKiRpokVGUY1GABRjwVqzm6x+ytplVhWWD1fmJ0itgl9iQIBRINvO3VTfePF+WBJacG4ACsG3O65tHoVcAToDI6E2m3EhasRqYIOdSnwNYypHRm74yhCmNNTYUso0DZfLrthJtxLb+on3csT/EyoBSLhkh+03jAcmpcNaylf12FIyVexcsm1ddw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CESV4ca9AJJ6Ua0wOiB+XuVsKqXXxZxATWz2eDqPK98=;
 b=IvIlTsd3uG/2ZuC7uOi8n/FOxmS5Aue9F0jknyACulILtXV0R6iQNojB4hkFDgS31/5rHNh7/IyzKGFOSjScf/7L5cBsx5giBHpQ4fGhMroB861rJaUyj4toVa1YOVb/p4DsbWb2GyoKVLLtqKIw6kv/piwhdedpJdVCT+w7NOg=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DBBPR04MB7723.eurprd04.prod.outlook.com (2603:10a6:10:20a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 08:04:18 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 08:04:18 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH net-next] net: fec: add CBS offload support
Thread-Index: AQHZPGjDAN8AB0LseESjQjG6/rgk/q7HFBiAgAC0+DA=
Date:   Fri, 10 Feb 2023 08:04:18 +0000
Message-ID: <DB9PR04MB810668EFE5F6F509B229DF2888DE9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230209092422.1655062-1-wei.fang@nxp.com>
 <Y+VZwaFbLBAj2Ng0@lunn.ch>
In-Reply-To: <Y+VZwaFbLBAj2Ng0@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DBBPR04MB7723:EE_
x-ms-office365-filtering-correlation-id: 40205da3-5c26-4096-7cdd-08db0b3d6933
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NAwYcbVzfQblEHU/XppQeynmjjreBAkkcmbDv+qs/KKkzkvWgyfE2+J+addeaBpWR9U5pT9eIWZjW0tco8Bhu2rPThopHssutjaSrkZp95jz3b790M4TWeQA6Npy1+9PfINKvVXVVB8EvYSkqay2fwXXoBoDXJnGHt3RH7Cx1SL7U1Yxi6vSx1hbdI4KKDm5Hw1XXp1nHhrxyiMMDX70E+9jjrOizhQS9sPa53XsTg4pbMybc//w8qwCLg9ppFEivo3zQfWnUFQnqiwHDg3fXAoOK49vf+WCq4YLlXEsYHqaopxmqdYVxaFlTdUDxLLkfdZ7AJmQ+eyNFK0w4c4hphMlfgO9oFf1l3DwgohHntUwONtugWFvTRbALDN4PlE5azLGrfQmuLwlGfIkMYknL8/wpY6geSojnxgrYb7FKCecDVz3QZDx/rMLng3B5kqAc3vmG8J7oxQFoyohdA3YQb7i3X4J93ZTsxbpPDkiiXIwLyz5eDQFmLD75OWX0E9CaczLCf8qFxhYNm6Qwvvm6sMzN2/IHz6ych2dfUc61ksGGr2nKuhGfiodkz7n3hd0d5yBhMgO3wcKSIUrErQYiEioj7lQB2YeQo6rLeHa5CYayV+gMg3WCPIrbwLFwu1OZylPwAGzJWk7w5p2HpBD34L/l8DgmFw7W+TvxD3Z+Fu6rSsQ0quRG0ceNi+TLm0ujR/O+hKq7bCZDFxh0gpTqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(44832011)(52536014)(186003)(86362001)(122000001)(8936002)(5660300002)(38070700005)(26005)(55016003)(7696005)(6506007)(53546011)(478600001)(71200400001)(83380400001)(33656002)(6916009)(9686003)(38100700002)(316002)(64756008)(4326008)(66946007)(8676002)(66556008)(66476007)(66446008)(41300700001)(54906003)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?a3VaaXdiclprSGtqVUpadW1kejdTQVNtM3hYeU9jbm5MTnNxcllEd1JqNTY1?=
 =?gb2312?B?Lzc5SXZaTFlBRDlUejNjQjJ3T0YzYjN3THdFNkN5R0s4czhxZzBXSnNiVE0r?=
 =?gb2312?B?ZHI1MnRJWHFvVy9nSGYyS3l0a040TDdZK0pDZ25UekF2Wko4cFp1RUFVY3Vs?=
 =?gb2312?B?TnREOEdURTRMNVRFcXJqWWJJQk9KWnhzcVRRckdoRTBXR0pCazVua0pVK2hx?=
 =?gb2312?B?L1RGVHRBQ2NRQm1ySDdFWEpJcFdDWXZYdGNDbm1Lc2h5eUxkN0J4aDJXZnpa?=
 =?gb2312?B?QTM4MzR6eml2MUs1MDdwV0tiSlFOU0JrMWE3K0M2MHNXSk5WMTJIUHBZU05M?=
 =?gb2312?B?U0VNYnQzaFkwQlowM3lLRzhFY0ExNEJyYjZRd1V0VnBvR2lIeGxKRy9OYkxz?=
 =?gb2312?B?Rjh2UXZiRm9ZSGNJS1RzZVVWc2dVSFg4VDFpT3d4bTJwR3FmNTRVQVZrSFBk?=
 =?gb2312?B?aGEvOUhnUkFWOFZyNGZ5UDlrWm9xU21Xd1hEdXZ6N005N1dWWXhpK0Y0dlNx?=
 =?gb2312?B?U3FpeVY0QWI2alY0WkF1dW5KZ0NZVUlrUjlzaUNEVFUvVmExUVFpU2Y3RjNJ?=
 =?gb2312?B?a0JIYlN2OHRyeWFEVW9DSEU1VmIyRWpoTExBTnBtZWcyTmZtdWpBT0FSYWtE?=
 =?gb2312?B?SENGU1VzUTVBVlQrOWZpYW5JT1N0MTc4SXptRE9vaU5XTGlKcVJsaERmZmI4?=
 =?gb2312?B?bVFHbi92OFBtK0MyblFaRFRSd0xabFVOOFVmZjBBMnUyQXg5K00vaGdYTGhw?=
 =?gb2312?B?MHUyOENLNmtJcG5xY3l0K3d1NUdDU2RxTkg5NGk1MURGWm9vdndXMFI2K1ZQ?=
 =?gb2312?B?TXRpenp1bjVIOHRkWGNYNTlzN3JuMUpoWDRZbUoxYmJzcDE0QUxIcGhIWVVB?=
 =?gb2312?B?UERWR2MrMTYvUEdJdkRBeGp3aVpLY29KZXRpZjhBSjJtSVo3WmJYeThqb0N2?=
 =?gb2312?B?Z3I1UE0zMmJabGVQeXhweGZRYWUwTlAwQVdxTnk0VkNlZG0xZWF1VHYwbmF5?=
 =?gb2312?B?MzU4eXVtT2dmQVFGa1prb3J0K001d1p2VXRJeS9LamsrZWJXZlpicXpNbHgv?=
 =?gb2312?B?alpVVHIwak9KNHZPSXJmMU55NGhqajBiRjErK3lud2ZSa1p2bUVlYkZwbGhI?=
 =?gb2312?B?QzE4RzlIa25UZ0ljdGQ1cXJaU3FNTXdicGd4VDJHL1NpVGlnMlRxcXRnOVBJ?=
 =?gb2312?B?Q2xPamQ4NWh6MkIrenQ0V1dENncyQnE4Wm5RL3ltWnJzVjNVc1U0cGhoQzZl?=
 =?gb2312?B?SXBTeGFZVlZkY3pnK2lidGpCRGhvNjNxTm1TTkJMcU56K25GMVpZZnVqVXI5?=
 =?gb2312?B?NU5ZbFk3QTNadlY0eHpGa1lqU3dxcGZ3ZGsyaDBkUFBqRFZXUDlMSjdKQXRY?=
 =?gb2312?B?QzJkODBIMDBTME1iU0d4K2I1R1pLU2ZiM0t6bFRwMHFBSWo5ZGFXckY3dy93?=
 =?gb2312?B?ZzVxWGVpdHBJT1FodHY3c3NsWWZuc3djY1QyNThidkMrZVRmdzJrUnZ5NVYy?=
 =?gb2312?B?L0tuTXBUa3BqMFJiNGlvb1ZPQ1dZaUt5QmcrRXV1MEM2WTJTeHBhdXRqYW9p?=
 =?gb2312?B?RllVSlc3cXBobmdBS09vZmh2a09oM052b1FIVGVsYWZyV2lGUGc3d0tReTIr?=
 =?gb2312?B?NjZlejlpSUdOdWNPT2JDZ3J4U3R5Z3BDQUhmNzlLTHF4OS95VUl0cGdsZFRO?=
 =?gb2312?B?V1c1a2JMNXhJOVdLVmpnMklKajJqdVJEb3hoMGpKb3Y0aERSR3N2TkJmYmtt?=
 =?gb2312?B?QVFkcmJNYkZqZDlYTFU4Q2M3VUpjMEdUdFNnSTgzSm5UNm9iOStwWHc3VGF1?=
 =?gb2312?B?RXBrRkZCejdoRGZLazZIVUkvWk5WUmQzbmtDUkhDRHh0SFNaNXN0b3krUCtU?=
 =?gb2312?B?YjVwVCtLUGJxd2Q2Zi9QdzNvelorUDd4ZVJOL29HS1hidjhZaFVNRU1IMlBl?=
 =?gb2312?B?UkZnbVM5d0I5dlRFZjZYVVdyOEx1K2xsL0ExRTlWaStZdmRKMW1HY1VHdGdx?=
 =?gb2312?B?UnVrQTBybnM5NVN4R2FEeGFGUWhmSytsODdHUE1XbE9UVy9zYy9QMnlFR0Ix?=
 =?gb2312?B?SFB0NGMybE5aZ0lsaGVSYTg3d0xNVUprM21TOURaclBzQnpCUkZUcmg1MjJk?=
 =?gb2312?Q?RCAc=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40205da3-5c26-4096-7cdd-08db0b3d6933
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 08:04:18.8637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aEOcDmcUgIWI3ooc6tgKjQzpa4k2y+N9Y0LijTcpBr/e5gF7WTn4glutQHm7b5Ab2E/g7oNiJtElJ0AVvrtSQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IDIwMjPE6jLUwjEwyNUgNDozOA0KPiBUbzogV2VpIEZhbmcgPHdl
aS5mYW5nQG54cC5jb20+DQo+IENjOiBTaGVud2VpIFdhbmcgPHNoZW53ZWkud2FuZ0BueHAuY29t
PjsgQ2xhcmsgV2FuZw0KPiA8eGlhb25pbmcud2FuZ0BueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVk
aGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14DQo+IDxsaW51eC1p
bXhAbnhwLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBmZWM6IGFkZCBDQlMgb2ZmbG9hZCBzdXBwb3J0DQo+IA0K
PiA+ICsJLyogY2JzLT5pZGxlc2xvcGUgaXMgaW4ga2lsb2JpdHMgcGVyIHNlY29uZC4gc3BlZWQg
aXMgdGhlIHBvcnQgcmF0ZQ0KPiA+ICsJICogaW4gbWVnYWJpdHMgcGVyIHNlY29uZC4gU28gYmFu
ZHdpZHRoIHJhdGlvIGJ3ID0gKGlkbGVzbG9wZSAvDQo+ID4gKwkgKiAoc3BlZWQgKiAxMDAwKSkg
KiAxMDAsIHRoZSB1bml0IGlzIHBlcmNlbnRhZ2UuDQo+ID4gKwkgKi8NCj4gPiArCWJ3ID0gY2Jz
LT5pZGxlc2xvcGUgLyAoc3BlZWQgKiAxMFVMKTsNCj4gDQo+IFRoaXMgYXBwZWFycyB0byBiZSBh
IC8gMCB3aGVuIHRoZSBsaW5rIGlzIG5vdCB1cCB5ZXQ/ICBBbHNvLCBpZiB0aGUgbGluayBnb2Vz
DQo+IGRvZXMsIGZlcC0+c3BlZWQga2VlcHMgdGhlIG9sZCB2YWx1ZSwgc28gaWYgaXQgY29tZXMg
dXAgYWdhaW4gYXQgYSBkaWZmZXJlbnQNCj4gc3BlZWQsIHlvdXIgY2FsY3VsYXRpb25zIGFyZSBh
bGwgd3JvbmcuIFNvIGkgdGhpbmsgeW91IG5lZWQNCj4gZmVjX2VuZXRfYWRqdXN0X2xpbmsoKSBp
bnZvbHZlZCBpbiB0aGlzLg0KPiANClllcywgc3BlZWQgPSAwIGlzIGluZGVlZCBhIHByb2JsZW0s
IHdlIHNob3VsZCBjaGVjayB0aGUgdmFsdWUgZmlyc3QuDQpGb3Igc3BlZWQgY2hhbmdlLCBJJ2xs
IHRoaW5rIGFib3V0IGhvdyB0byBoYW5kbGUgdGhpcyBzaXR1YXRpb24uDQoNCj4gDQo+ID4gKwkv
KiBidyUgY2FuIG5vdCA+PSAxMDAlICovDQo+ID4gKwlpZiAoYncgPj0gMTAwKQ0KPiA+ICsJCXJl
dHVybiAtRUlOVkFMOw0KPiANCj4gV2VsbCA+IDEwMCUgY291bGQgaGFwcGVuIHdoZW4gdGhlIGxp
bmsgZ29lcyBmcm9tIDFHIHRvIDEwSGFsZiwgb3IgZXZlbg0KPiAxMDBGdWxsLiBZb3Ugc2hvdWxk
IHByb2JhYmx5IGRvY3VtZW50IHRoZSBwb2xpY3kgb2Ygd2hhdCB5b3UgZG8gdGhlbi4gRG8NCj4g
eW91IGRlZGljYXRlIGFsbCB0aGUgYXZhaWxhYmxlIGJhbmR3aWR0aCB0byB0aGUgaGlnaCBwcmlv
cml0eSBxdWV1ZSwgb3IgZG8geW91DQo+IGdvIGJhY2sgdG8gYmVzdCBlZmZvcnQ/IA0KQWN0dWFs
bHksIHRoZSBGRUMgaGFzIGFsd2F5cyB1c2VkIHRoZSBjcmVkaXQtYmFzZWQgc2hhcGVyIGJ5IGRl
ZmF1bHQuIFNvIEkgdGhpbmsNCml0J3MgYmV0dGVyIHRvIGZhbGwgYmFjayB0aGUgZGVmYXVsdCBz
ZXR0aW5nIGFuZCByZXR1cm4gZXJyb3IgaWYgdGhlIGJ3ID4gMTAwJS4NCg0KPklzIGl0IHBvc3Np
YmxlIHRvIGluZGljYXRlIGluIHRoZSB0YyBzaG93IGNvbW1hbmQgdGhhdA0KPiB0aGUgY29uZmln
dXJhdGlvbiBpcyBubyBsb25nZXIgcG9zc2libGU/DQo+IA0KU29ycnksIEkgaGF2ZSBubyBrbm93
bGVkZ2UgYWJvdXQgdGhlIHRjIHNob3cgY29tbWFuZC4NCg0KPiBQcmVzdW1hYmx5IG90aGVyIGRy
aXZlcnMgaGF2ZSBhbHJlYWR5IGFkZHJlc3NlZCBhbGwgdGhlc2UgaXNzdWVzLCBzbyB5b3UganVz
dA0KPiBuZWVkIHRvIGZpbmQgb3V0IHdoYXQgdGhleSBkby4NCj4gDQo+ICAgICBBbmRyZXcNCg==
