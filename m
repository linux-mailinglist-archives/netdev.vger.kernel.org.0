Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBD12D0B90
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 09:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgLGIQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 03:16:21 -0500
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:19270
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726158AbgLGIQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 03:16:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bsKfSeOGS7eEvLwgPeYqW+SKwqiIWrzRFNtnGUvjgQgJG9UIp9VC8aeVkcikYg1zUrMzG7xn/0ihaEKLhHfY659VTPVx08zmO9fzHOHmnWG3y2JWvSkcYjaA5qVLsD4RhQ4UHpgB0TcDygJjBQoUCMmpDx2HUo9uSCkyvAA9zlXLkFAYTb4ihcLYXtiEN7358+Fz3A0/II6L7QfmidWlwv2Ak74Gs+YwVwRssGt2U9Txa8T0OKj/IK5HanWPYYccpqe4PA5OhMTmO5bt839Cb0z1mAwfXcslfIZKkucu8angvgvaGtyiZbGuCyAhh9A/4ON0WYROp1p0cN3FHgl9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKchcRjUVs32vURWEzf/s9dcT7e+BTe24pSnNKuPueg=;
 b=JB/qms7gnKxmkeCKqsa+SCdFRhljSqBs66sKsGCtVPaWkuJ7m2fF2U9ANPupdrRYXTz7ARbQ/7cSGED6fLqDs7EHEnHDegwP/cFNN+WZwnBjHCEm38bTJK2nAY/67tBasDCDn6QCUJdpnmy6TZq56KLC2JDKlFJusmuUvaSp56ZeBIiSsmk4BnGNmMKo2fOwjlyACyWR+byKCzbVSrB8qg6UWxCL7XoUXGIFV5D9/hJQxQKVFDr1vWB7JWTxY0qCfKAEqhaxaZPDXSpbWzVT3Ljp6Nv+/PnN3SKiKagIPyc/KI9x6/jIjj8gb2uzigde5Si6zYlnHgchwP2EK7Orjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sKchcRjUVs32vURWEzf/s9dcT7e+BTe24pSnNKuPueg=;
 b=ZwuOYIOHYD4U9UYJBLfc2puHD62XAl5eUbHHRXnz5mLxawN/LuEAkjV2NkFO/0MSzjC3jF94TPlzN1ZRn73qLduTB/gA559VjdTr+7gic22HERZeIXv7AZWcQuEyrjcCnavi6I0fdwAFd0w+4dRnOTBXJXbnhUzQDDqTBE10LqU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3205.eurprd04.prod.outlook.com (2603:10a6:6:e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.23; Mon, 7 Dec 2020 08:15:29 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 08:15:29 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: implement .set_intf_mode() callback for
 imx8dxl
Thread-Topic: [PATCH] net: stmmac: implement .set_intf_mode() callback for
 imx8dxl
Thread-Index: AQHWySo+sOjqNs0JjkyidmZfh7ed+6no74sAgAJf27A=
Date:   Mon, 7 Dec 2020 08:15:29 +0000
Message-ID: <DB8PR04MB679504FD15F09CCBE3BD061FE6CE0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201203041038.32440-1-qiangqing.zhang@nxp.com>
 <20201205115802.1dc00448@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205115802.1dc00448@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04a5f257-bbbe-469d-c51d-08d89a88428b
x-ms-traffictypediagnostic: DB6PR04MB3205:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB3205FA253A5A7C20C473162AE6CE0@DB6PR04MB3205.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: forkSx+spI5o2PbMpdaKxhDAFw9CORKrwqrzCmzLH9dcVHPBbf6iCwu+6XAPB1eZCwnK0bqsAAA/RjqbfBeWJeSfHyXI7WITyu2ZN5gQbmKyLcfibo760aadVm4HrpJcF+EFwJgzHVhdn3WxkeOIoaJRlUpI32f1kAifN/IX4EBhUjCE7HIlm0RRC78pRPCTMVof6M7FSgrl1Ku1b2DdgXCf8IUOt3icqeac6brcdM96PRyraN8DEDoTRchBpcZnYfL5c3vPeU45B2SRwSbUnMjkQUIMRL+gAR09H/2nu4Tpvn1Y1fqq6cAqEWgDKlQ2eXzmaMSXBJ7n0TqrijTkVFdB0geD0XnKIGPfzq6z6tnQfVFCzbsXl3y6PiAVFIoQR7ihKVA6VhgkfMTQPgtMXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(66946007)(64756008)(8936002)(76116006)(55016002)(478600001)(316002)(66446008)(66476007)(66556008)(54906003)(33656002)(52536014)(4326008)(83380400001)(186003)(5660300002)(26005)(71200400001)(86362001)(53546011)(6506007)(7696005)(6916009)(9686003)(8676002)(2906002)(142923001)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?SzhCdnQ5TUl5azB5aENndWpsaXZuRnhiK2Robk5kbytObENVWnFoNVlIaWpX?=
 =?gb2312?B?OStZWUJYYXRwVloxelI5UWJnTFU2VzU2NWJpaE0zOXR4SW9SbDZsdytGYjJU?=
 =?gb2312?B?MjJ2YU93VUtaY2g2SDZySWJabE1udjB4eENkKzIySDdFdlhJeDdaRThRMW5l?=
 =?gb2312?B?Nk0wazFueE9mSFVLUzRFb3NXRER5bTNnaklkYnBHSElscjA5T0xKY25aZ2Fu?=
 =?gb2312?B?K3l6a2UxdVZiaTdXWVNubFNMK1pFRzFidGl1bytIMyt1Y2ErMmVXR2sxd2hK?=
 =?gb2312?B?VUwrR0pYVHZoUEk2OVZUZVkwcTFOQ2RDamFnZVpiV3RFTDBFWG9lSktLT295?=
 =?gb2312?B?U01nK1BKVm5MUFJFVFo1Tm9RYU9uWVFNV2ZQemcrTk5uMmwvb1NEVFZ5VzNM?=
 =?gb2312?B?M1E2dEY0bkdkSjJiWXloQXE1akV1NElYVmJZalNKWHJNeE9EdXBIV2pjNkxr?=
 =?gb2312?B?ZlV3SUhhc01OK29NU1BnZWpLRys3VlQ2ampvWnAwZ2xCVWE2K0tVWnZJRUMr?=
 =?gb2312?B?SHRnK0JkL3FXMU16eTZ0QXJodnEyQ1lRNFY0L0c2R1R3WXBYSXdraVRYWktP?=
 =?gb2312?B?QWJPK2VoT0NmVERsMGwwYmlWOXRiVlFybFpPNVlzQnk4QkVjeXpRWVQzc3hi?=
 =?gb2312?B?MGFoaHl2OUZLaTlVWTdycEU5dllmSHRSdkxhVXBYZzh1b0dhMXZQNG4vdlZk?=
 =?gb2312?B?dHFrWkNvdDA4cWZMT05xZ2lGamk2ejlLdWNsNTNObjkxdFJnUmlZdjVqWGR0?=
 =?gb2312?B?RmI0bjhpVG9acXBUZFE2aGpESmJweFNsM3R6WExoWVRzZU9KV3dua2VTcHhm?=
 =?gb2312?B?NXRKaXZldTd6ZGkwckpYMU8vL2NpT1ZhQ0U3d0dzNWFva083M1Zxdm5aNE44?=
 =?gb2312?B?NSsrZWV3OHFRaTlPS2hyUzdNcDZGbXVwNWJGYWVocm8yckpibkk5aUMrdHMy?=
 =?gb2312?B?eVVzSmhnUTdVMmc0cjEzcURtQURKVllGWkFtNDdGQzRNV2RTa25EUEUwY0Nh?=
 =?gb2312?B?VWhRQ2pmK3htYWM1eTNZZ2gyZERBMWtjRGRoWHVkaWszM1ptbFMwYWlsejhj?=
 =?gb2312?B?ZEFza2ZicHR1aHpTb29hQUdoMXVWZFdsdTZwekhMSHlQTkFsZkdQNStPbTkx?=
 =?gb2312?B?aFdtRTQ4NXlNTnk2ZHJkT2I0NEpRcmtPM0ZBZzhDYVR6YmVya2pzV0pqZC9F?=
 =?gb2312?B?bjN2djFDbmd5Tjl6MkFRYVIrbENHQWxueVdMRW9va0JaYU92RjZZc1ZKNi9T?=
 =?gb2312?B?T3QrQnVTaW93ZHdDWnYrK041V0FUaHFZVDRTaW1xc3cwQWdhbXcrMzZCNldX?=
 =?gb2312?Q?nUdMmeLd7AuDs=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a5f257-bbbe-469d-c51d-08d89a88428b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 08:15:29.4914
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+VbGCQ3KR/KHpooUoHMK9e9TF/Zi6MQztlaAt2N1865K7fmGDG1ZoWJc9bZSiBdLOJOa/Pvj5Uic+O8GKot3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjDE6jEy1MI2yNUgMzo1OA0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0Bz
dC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBzdG1t
YWM6IGltcGxlbWVudCAuc2V0X2ludGZfbW9kZSgpIGNhbGxiYWNrIGZvcg0KPiBpbXg4ZHhsDQo+
IA0KPiBPbiBUaHUsICAzIERlYyAyMDIwIDEyOjEwOjM4ICswODAwIEpvYWtpbSBaaGFuZyB3cm90
ZToNCj4gPiBGcm9tOiBGdWdhbmcgRHVhbiA8ZnVnYW5nLmR1YW5AbnhwLmNvbT4NCj4gPg0KPiA+
IEltcGxlbWVudCAuc2V0X2ludGZfbW9kZSgpIGNhbGxiYWNrIGZvciBpbXg4ZHhsLg0KPiA+DQo+
ID4gU2lnbmVkLW9mZi1ieTogRnVnYW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4g
U2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
DQo+IENvdXBsZSBtaW5vciBpc3N1ZXMuDQo+IA0KPiA+IEBAIC04Niw3ICs4OCwzNyBAQCBpbXg4
ZHhsX3NldF9pbnRmX21vZGUoc3RydWN0DQo+IHBsYXRfc3RtbWFjZW5ldF9kYXRhDQo+ID4gKnBs
YXRfZGF0KSAgew0KPiA+ICAJaW50IHJldCA9IDA7DQo+ID4NCj4gPiAtCS8qIFRCRDogZGVwZW5k
cyBvbiBpbXg4ZHhsIHNjdSBpbnRlcmZhY2VzIHRvIGJlIHVwc3RyZWFtZWQgKi8NCj4gPiArCXN0
cnVjdCBpbXhfc2NfaXBjICppcGNfaGFuZGxlOw0KPiA+ICsJaW50IHZhbDsNCj4gDQo+IExvb2tz
IGxpa2UgeW91J3JlIGdvbm5hIGhhdmUgYSBlbXB0eSBsaW5lIGluIHRoZSBtaWRkbGUgb2YgdmFy
aWFibGUNCj4gZGVjbGFyYXRpb25zPw0KPiANCj4gUGxlYXNlIHJlbW92ZSBpdCBhbmQgb3JkZXIg
dGhlIHZhcmlhYmxlIGxpbmVzIGxvbmdlc3QgdG8gc2hvcnRlc3QuDQo+IA0KPiA+ICsNCj4gPiAr
CXJldCA9IGlteF9zY3VfZ2V0X2hhbmRsZSgmaXBjX2hhbmRsZSk7DQo+ID4gKwlpZiAocmV0KQ0K
PiA+ICsJCXJldHVybiByZXQ7DQo+ID4gKw0KPiA+ICsJc3dpdGNoIChwbGF0X2RhdC0+aW50ZXJm
YWNlKSB7DQo+ID4gKwljYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9NSUk6DQo+ID4gKwkJdmFsID0g
R1BSX0VORVRfUU9TX0lOVEZfU0VMX01JSTsNCj4gPiArCQlicmVhazsNCj4gPiArCWNhc2UgUEhZ
X0lOVEVSRkFDRV9NT0RFX1JNSUk6DQo+ID4gKwkJdmFsID0gR1BSX0VORVRfUU9TX0lOVEZfU0VM
X1JNSUk7DQo+ID4gKwkJYnJlYWs7DQo+ID4gKwljYXNlIFBIWV9JTlRFUkZBQ0VfTU9ERV9SR01J
SToNCj4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9NT0RFX1JHTUlJX0lEOg0KPiA+ICsJY2FzZSBQ
SFlfSU5URVJGQUNFX01PREVfUkdNSUlfUlhJRDoNCj4gPiArCWNhc2UgUEhZX0lOVEVSRkFDRV9N
T0RFX1JHTUlJX1RYSUQ6DQo+ID4gKwkJdmFsID0gR1BSX0VORVRfUU9TX0lOVEZfU0VMX1JHTUlJ
Ow0KPiA+ICsJCWJyZWFrOw0KPiA+ICsJZGVmYXVsdDoNCj4gPiArCQlwcl9kZWJ1ZygiaW14IGR3
bWFjIGRvZXNuJ3Qgc3VwcG9ydCAlZCBpbnRlcmZhY2VcbiIsDQo+ID4gKwkJCSBwbGF0X2RhdC0+
aW50ZXJmYWNlKTsNCj4gPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiArCX0NCj4gPiArDQo+ID4g
KwlyZXQgPSBpbXhfc2NfbWlzY19zZXRfY29udHJvbChpcGNfaGFuZGxlLCBJTVhfU0NfUl9FTkVU
XzEsDQo+ID4gKwkJCQkgICAgICBJTVhfU0NfQ19JTlRGX1NFTCwgdmFsID4+IDE2KTsNCj4gPiAr
CXJldCB8PSBpbXhfc2NfbWlzY19zZXRfY29udHJvbChpcGNfaGFuZGxlLCBJTVhfU0NfUl9FTkVU
XzEsDQo+ID4gKwkJCQkgICAgICAgSU1YX1NDX0NfQ0xLX0dFTl9FTiwgMHgxKTsNCj4gPiAgCXJl
dHVybiByZXQ7DQo+IA0KPiBUaGVzZSBjYWxscyBtYXkgcmV0dXJuIGRpZmZlcmVudCBlcnJvcnMg
QUZBSUNULg0KPiANCj4gWW91IGNhbid0IGp1c3QgZXJybm8gdmFsdWVzIHRvIGdldGhlciB0aGUg
cmVzdWx0IHdpbGwgYmUgbWVhbmluZ2xlc3MuDQo+IA0KPiBwbGVhc2UgdXNlIHRoZSBub3JtYWwg
ZmxvdywgYW5kIHJldHVybiB0aGUgcmVzdWx0IG9mIHRoZSBzZWNvbmQgY2FsbA0KPiBkaXJlY3Rs
eToNCj4gDQo+IAlyZXQgPSBmdW5jMSgpOw0KPiAJaWYgKHJldCkNCj4gCQlyZXR1cm4gcmV0Ow0K
PiANCj4gCXJldHVybiBmdW5jMigpOw0KPiANCj4gUGxlYXNlIGFsc28gQ0MgdGhlIG1haW50YWlu
ZXJzIG9mIHRoZSBFdGhlcm5ldCBQSFkgc3Vic3lzdGVtIG9uIHYyLCB0byBtYWtlDQo+IHN1cmUg
dGhlcmUgaXMgbm90aGluZyB3cm9uZyB3aXRoIHRoZSBwYXRjaCBmcm9tIHRoZWlyIFBvVi4NCg0K
DQpUaGFua3MgSmFrdWIgZm9yIHlvdXIga2luZGx5IHJldmlldywgSSB3aWxsIGltcHJvdmUgcGF0
Y2ggZm9sbG93aW5nIHlvdXIgY29tbWVudHMuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFu
Zw0KPiBUaGFua3MhDQo=
