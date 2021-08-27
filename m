Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822393F9C06
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245198AbhH0P4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:56:52 -0400
Received: from mail-eopbgr1410129.outbound.protection.outlook.com ([40.107.141.129]:55680
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234232AbhH0P4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuBxtszQ3dca38CInIDT0ul3/RtXClE0cygegRdZEKa9hERLcuL0aCYuVOEc/ZpkvdVUFlHzkNzD1F8irwA3muKO9AnlvUyHvP6mVl6+xIyZXdR2dOkN+MDhlIc68hAeK0NEtBK1htb7VMYX20azlWlkbnLWWyYJfco9DeAB41eSj/ZNgR9I2zE4Px5mrP9HTNmRl92QNb5sr3gGGQpiX8/XJ3tw0Yok+sP82BWnKaJ1Nc11VrD8SCdyZG4GYWDiYcJUShx2W/zS3eHpHzTS7ci4WWQt6wOxiSNBWEUJqodKF4HTnrE7GA+6pEfgFngWvPN0j9NUqtFmWwXUgT12ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95kTqb1T6PNhzITofwVLhBIR8h995WghQ48zwvMZ23Y=;
 b=R5cHnOw3NTW8oBlNmKIqE/9YxJLvaCAChkuZzHfSwLPzkDCva699M9Er2DbqTw54Pu4UzFFCCG1s196JsAlDXcVZjSpiwig61P+UoYGPBdz1ib/T6bSIB72hgAIJONpnkWoF5/cS0x8BXOABjLMMek7aRkM7+NmjW1ZDY6ZlF8brDs2SVJNlezuCS7q/H4Xn0IYRiKkMP6KE5XOYSgdPEZ4mph0tsKLqhjU+9HIjqosNNFAuLvq5YCytMSgYj8IVFE1nQVkT31NOpkDz5jKsow7pr7Utr8IfA4DqaTVOXS4jqxkPNsWDKHuN0k76Sc6xil4sm9C1Ld0aZFqdZpxyKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95kTqb1T6PNhzITofwVLhBIR8h995WghQ48zwvMZ23Y=;
 b=crqiARdzHNl6yGI45/ak3E79WyCuJUu7D79/cqcgWLAz4O5XrrOLvDLbrkHa0lVu4Wdm5iKIQ/6EGRhuSD3IkXDE7+moXoZQAzfW2SxONNxk5Z4x+pen+j8YVO+XuY4scDjTPAw0Fz+l7UZ2xgZJROU4fMnmfKTHg8i3izsBIvs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5441.jpnprd01.prod.outlook.com (2603:1096:604:a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Fri, 27 Aug
 2021 15:56:00 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::e111:61:43af:3b98%3]) with mapi id 15.20.4436.025; Fri, 27 Aug 2021
 15:55:59 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>, Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next 04/13] ravb: Add ptp_cfg_active to struct
 ravb_hw_info
Thread-Index: AQHXmX8jVvjbtjTRLEe2lQMMRo0BcquEr1UAgAChqBCAAEagAIAAAOMggAACgwCAAAEbsIAAeyUAgAAONACAAAFFgIAAAhaAgAAHRlCAAAe6AIAAry5ggACcFQCAAAGvkA==
Date:   Fri, 27 Aug 2021 15:55:59 +0000
Message-ID: <OS0PR01MB5922A6AB6E7F2D802CD665C386C89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210825070154.14336-5-biju.das.jz@bp.renesas.com>
 <777c30b1-e94e-e241-b10c-ecd4d557bc06@omp.ru>
 <OS0PR01MB59220BCAE40B6C8226E4177986C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <78ff279d-03f1-6932-88d8-1eac83d087ec@omp.ru>
 <OS0PR01MB59223F0F03CC9F5957268D2086C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <9b0d5bab-e9a2-d9f6-69f7-049bfb072eba@omp.ru>
 <OS0PR01MB5922F8114A505A33F7A47EB586C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <93dab08c-4b0b-091d-bd47-6e55bce96f8a@gmail.com> <YSfkHtWLyVpCoG7C@lunn.ch>
 <cc3f0ae7-c1c5-12b3-46b4-0c7d1857a615@omp.ru> <YSfm7zKz5BTNUXDz@lunn.ch>
 <OS0PR01MB5922871679124DA36EAEF31F86C79@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <0916b09c-e656-fa2a-54d9-ca0c1301a278@omp.ru>
 <OS0PR01MB59220DB4277F4414D5779E6A86C89@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <8c8d95e7-790f-382f-bf8c-21c45bdb257e@omp.ru>
In-Reply-To: <8c8d95e7-790f-382f-bf8c-21c45bdb257e@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d3a94c0-c67a-4766-9207-08d969732a30
x-ms-traffictypediagnostic: OS0PR01MB5441:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB5441CBBE1AD90CB57906F7B186C89@OS0PR01MB5441.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9bQigvwZNceTjlImR5sbI8LitY7mXPjpTrihu5JF7JupOA5KHnfHpvPuld7rcjFAsEMNEGSFCsSrs1EfiVSig7j0N5v/LE8BXmetbPbSgndUFEJHDPfpuQX920fseLoKdPbAxF49CGkwFVCWYXwTJIAP2HjtDqFYuohKm6kvcuCV63kFh8tsqOfhlHFeH8eYgEEIPbKMcZxTpkTCSXSv+YVLPm2FxLh10oCJ6oZibGPnrw3kux/Bw7/AeFKxR/6TQ8KANJN7GcPB2vgU/LWsYyK0yKYXHX0XbKwTn9+7bOkYMfoQih09DNI8E/1O1aKVz5iYAWcgc3qti/uAvbN3qVuKOo0YyhZM+PeVRUSUMbzzZNTo2ypUwE4uIhjiggOLsEnlO7Rlz3MgXE3+H+8C/y2WGGwaftmqkzn2wQm6VeQDLrb5Xd+DErmBQeviIBJ43q2+2SfukMSm0IQ3gF5NLI+38XNwFtSvXaWVwX6pW1s1FhceKPzC75WOSQt3dK7OyIBzOU3J6IWqnDmNR2743tU1dJqg52NcVYOnCorNHjWiCQ521yfVbjccp8cTGuUniEtPPm6tLQoVKhrCNvL7YxSuZBVFui+1hGYaDPKDYrhXOVLt9XooJBufByHtWUzcSk1HisRtsl0NUMhKw1CG0ixKh40fcGxsvBBGBSDP81rsmjU5/iszHyBmBpd0PMwoEEEpAmPw8gSQ6B5ei+vPsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(396003)(376002)(71200400001)(76116006)(38070700005)(122000001)(6506007)(9686003)(55016002)(86362001)(186003)(478600001)(2906002)(5660300002)(8936002)(7696005)(53546011)(316002)(33656002)(107886003)(38100700002)(66446008)(66556008)(66946007)(64756008)(26005)(66476007)(54906003)(52536014)(110136005)(4326008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2FXTys0ZVBiZmFKdUFaTzJVRCtkeDFkSTlyc0l4dk41NFVoL1JQa0FzUGlT?=
 =?utf-8?B?NDhMclNRZGUzNDdLRWt0QUUyamY0d2hnVTFKWDI0YTgvY2lrUm82RjZKc3FR?=
 =?utf-8?B?Q3d4ZmN0c0tyR3hMNFFSa2pVdU9DYTdSVitxdFVLbWMvUzVPb2xsbmREZDEx?=
 =?utf-8?B?ZFJuZjNGSTlBSlF3UEcvUTdBb2pUeThpSWxxNFFnY283dm5CVEhheTZWK0dY?=
 =?utf-8?B?YWN2QXRiRnJJeHhVZTJQZ0VxUkpUMmlBT2FvWXI2dDlPUUVYMGhwMHdpTTdX?=
 =?utf-8?B?VzA4eGptTEZjM3QwOXJQNDJvWmRVM2dNTTFxYlpacnNPNURQUWYwaDV0RWhW?=
 =?utf-8?B?RXNrRUhpOXM3QXUxMkYxa1FpNGhsd01yQ3h5M2NQTnpjZzdMV2ZEYXgwaDhI?=
 =?utf-8?B?ditBbm5SeUZ3TVBLbk9LWDhkaVFoZVRua0ZXaTVJUmIvdjJ3Z1c5bU1zS2lh?=
 =?utf-8?B?SnByOGdaYVk3QTJlZ0dmK3MyK2NHS1MrclczaFdudkthVzU4YjF4K2JMRjh4?=
 =?utf-8?B?Zy9xUUhNKzJmTWkxLzhPL2NlSHQwLy9WeVZlNnhOWngwRTBRbFNkU0lsdEdq?=
 =?utf-8?B?VTE1SEh2WitWUnBramRYUVlicnVXcmxVeVlyWS9yelhGdUMwcHBhaEtmdjhI?=
 =?utf-8?B?YUdJRzdxQ092NU9xdEJpckxvM0RWSE93TU5OUDNTV1VLQ25yY3p3T09zQjc0?=
 =?utf-8?B?YmxrY1R4c25RbXBSU1JCVS9EL1BiWVJJdm1WTy9ZVGIrU1FLcDdQbjlTL0hW?=
 =?utf-8?B?WnBWTzBLVGhORnhxMlFKaEpzeGQ0Zkhvc3MwaWIzWitsZmJBdmlJenhiZXUw?=
 =?utf-8?B?Y1ZPOHNJODB0SWgwbUljVXY1MVZoUFd3aWFlUGo1QUZYSFQ2amd3RnYwNWQr?=
 =?utf-8?B?RnQ1cDhzbkJBV2kvbkVKbHhibDRPU1NYMFVKTlhhUWhsQUhyTlRXM2hJVzN2?=
 =?utf-8?B?alBZOW12ejdZZ1lkLzBYbnB0b2tpRzFMLy9iTlQrejFPT0xZTnBsdWJySExK?=
 =?utf-8?B?bXFxYVgxdlllMDIyVVg1RnZNNjRCRms5VGhwdXN1SGlhdnhUS09BaXpzWFZE?=
 =?utf-8?B?U3VtQUN0eGZPaHlkNERQaUpDQW1YZ3NaUTJNSlNyYUZJNDdvc1l5VDdxTXRJ?=
 =?utf-8?B?QnZGeXNLSUNsTFlUdm5jOTcvekc2cXFJOG1LbURaYlZjL1IvemF3MVFRZ1Rl?=
 =?utf-8?B?M2d2VGtSTi90MHVrNk85b1YwMXFvUU83cUx0V0pwUFNBVzhWeWJKbFcyS00r?=
 =?utf-8?B?dGpDOUUxOXJTRlZyc0JPNUhxR1JLSXJIT2wyc2doQmsxUUZwcVJkaHJsUUIz?=
 =?utf-8?B?NnhaUlRHeWpEaTZSa051MzNKRzdVd3c2R0owK2V0aU9hak9oYVBNamRBL0Qv?=
 =?utf-8?B?WlA0cVdRdjNSSDRiV2xCNUUvMW82L3lHL1pjRVNsSTMrNkdNS1F5aUNNQ01j?=
 =?utf-8?B?MlNJWXlOQnZ2dlBDN1hhc3p2clVhYWc2N0NvV3pDRUpPVE5VZ0JZQzJpVmZr?=
 =?utf-8?B?bTk3NFM2aW9acjVmRDBqZ2FjSlkzVlp4RHd3cEVuR250Q2tsbnVLTENYYlNS?=
 =?utf-8?B?WGRyT0YvaktZZzFKbEFzWHhmN2dvQ2F3dkQ1WkpvWmx5ZEp6TWxRNDFud2dk?=
 =?utf-8?B?bUx6SkwxYk9jZnBTZ2s0MG9JVHo5OEZyQmFnL2E5UE5ZOHdDS01Gcmtkb0JE?=
 =?utf-8?B?RjRUay9JQjdEUFVGSTR1eXJFYnhjUnNULzViV2NMMFRVTDhhblM3NzRXRWR6?=
 =?utf-8?Q?M1+Uw+rxYcZix8DDIE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d3a94c0-c67a-4766-9207-08d969732a30
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 15:55:59.8124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hJS8osS+eciNpSi8uqI6iHP72/w2J1/0aW9Ai7bLxOCkPOWFoFevqTiJs7k2Fj32vj+dDZDXMSBGQXENWhl0fxIZFEO6zlVOmyAvyuBSJso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDA0LzEzXSByYXZiOiBBZGQgcHRwX2NmZ19hY3RpdmUgdG8gc3RydWN0
DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gMjcuMDguMjAyMSA5OjM2LCBCaWp1IERhcyB3cm90
ZToNCj4gDQo+IFsuLi5dDQo+IA0KPiA+Pj4+Pj4+PiBEbyB5b3UgYWdyZWUgR0FDIHJlZ2lzdGVy
KGdQVFAgYWN0aXZlIGluIENvbmZpZykgYml0IGluDQo+ID4+Pj4+Pj4+IEFWQi1ETUFDDQo+ID4+
Pj4gbW9kZSByZWdpc3RlcihDQ0MpIHByZXNlbnQgb25seSBpbiBSLUNhciBHZW4zPw0KPiA+Pj4+
Pj4+DQo+ID4+Pj4+Pj4gICAgIFllcy4NCj4gPj4+Pj4+PiAgICAgQnV0IHlvdSBmZWF0dXJlIG5h
bWluZyBpcyB0b3RhbGx5IG1pc2d1aWRpbmcsIG5ldmVydGhlbGVzcy4uLg0KPiA+Pj4+Pj4NCj4g
Pj4+Pj4+IEl0IGNhbiBzdGlsbCBiZSBjaGFuZ2VkLg0KPiA+Pj4+Pg0KPiA+Pj4+PiAgICAgIFRo
YW5rIGdvb2RuZXNzLCB5ZWEhDQo+ID4+Pj4NCj4gPj4+PiBXZSBoYXZlIHRvIGxpdmUgd2l0aCB0
aGUgZmlyc3QgdmVyc2lvbiBvZiB0aGlzIGluIHRoZSBnaXQgaGlzdG9yeSwNCj4gPj4+PiBidXQg
d2UgY2FuIGFkZCBtb3JlIHBhdGNoZXMgZml4aW5nIHVwIHdoYXRldmVyIGlzIGJyb2tlbiBpbiB0
aGUNCj4gPj4+PiB1bnJldmlld2VkIGNvZGUgd2hpY2ggZ290IG1lcmdlZC4NCj4gPj4+Pg0KPiA+
Pj4+Pj4gSnVzdCBzdWdnZXN0IGEgbmV3IG5hbWUuDQo+ID4+Pj4+DQo+ID4+Pj4+ICAgICAgSSdk
IHByb2xseSBnbyB3aXRoICdncHRwJyBmb3IgdGhlIGdQVFAgc3VwcG9ydCBhbmQgJ2NjY19nYWMn
DQo+ID4+Pj4+IGZvciB0aGUgZ1BUUCB3b3JraW5nIGFsc28gaW4gQ09ORklHIG1vZGUgKENDQy5H
QUMgY29udHJvbHMgdGhpcw0KPiBmZWF0dXJlKS4NCj4gPj4+Pg0KPiA+Pj4+IEJpanUsIHBsZWFz
ZSBjb3VsZCB5b3Ugd29yayBvbiBhIGNvdXBsZSBvZiBwYXRjaGVzIHRvIGNoYW5nZSB0aGUNCj4g
bmFtZXMuDQo+ID4+Pg0KPiA+Pj4gWWVzLiBXaWxsIHdvcmsgb24gdGhlIHBhdGNoZXMgdG8gY2hh
bmdlIHRoZSBuYW1lcyBhcyBzdWdnZXN0ZWQuDQo+ID4+DQo+ID4+ICAgICBUSUEhDQo+ID4+ICAg
ICBBZnRlciBzb21lIG1vcmUgdGhpbmtpbmcsICdub19ncHRwJyBzZWVtcyB0byBzdWl0IGJldHRl
ciBmb3IgdGhlDQo+ID4+IDFzdCBjYXNlIE1pZ2h0IG5lZWQgdG8gaW52ZXJ0IHRoZSBjaGVja3Mg
dGhvLi4uDQo+ID4NCj4gPiBPSywgV2lsbCBkbyB3aXRoIGludmVydCBjaGVja3MuDQo+ID4NCj4g
PiBTbyBqdXN0IHRvIGNvbmNsdWRlLA0KPiA+DQo+ID4gJ25vX2dwdHAnIGFuZCAnY2NjX2dhYycg
YXJlIHRoZSBzdWdnZXN0ZWQgbmFtZXMgY2hhbmdlcyBmb3IgdGhlDQo+ID4gcHJldmlvdXMgcGF0
Y2ggYW5kIGN1cnJlbnQgcGF0Y2guDQo+IA0KPiAgICAgIFlvdXIgcGF0Y2hlcyBoYXZlIGJlZW4g
bWVyZ2VkIGFscmVhZHkuIE1pZ2h0IHRyeSB0byBlbmNvbXBhc3MgYWxsDQo+IGdQVFAgZmVhdHVy
ZXMgd2l0aCBvbmUgcGF0Y2ggKGp1c3QgYSB0aG91Z2h0KS4uLg0KDQpPSywgaW4gdGhhdCBjYXNl
IGl0IHdpbGwgYmUgdGFrZW4gY2FyZSBpbiBuZXh0IFJGQyBwYXRjaCBzZXQuDQoNClJlZ2FyZHMs
DQpCaWp1DQo=
