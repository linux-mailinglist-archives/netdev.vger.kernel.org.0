Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E2A416507
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242705AbhIWSPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:15:33 -0400
Received: from mail-eopbgr1410091.outbound.protection.outlook.com ([40.107.141.91]:23163
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242826AbhIWSPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:15:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a/rIJ3Mqa3ixBGgBUuNTl5Tklz6kVWfNqbdaPfwxDcoodLd3Vp9pJ5/4H3Vpyt0huYkZxUJF6eV6b1X/4NTJiqAZrkNK6QhJE6Bbq1uyWWPNHKgk9ml8FAg6v/xZK7l79yDg58YVaN7E7hTTfchDnqeVTsCHPnpSSmdlS/ndVY1mGl67/hdvhTIQqsck5n8I3h9ZOHJv9TMScJI5xoCpq3f63/k9f6OyNo19eJBtnI/OvqbdeRoV+mCzJZzYGtWD0yTgO71nfnBQ2B7c4UB+TPWhH14lmNax9w+tmO2rPqDxkQiWqYcByam6wyiMRCfP3GvW4xvom8083NxFBlcekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=urlbFqMrXAahX5PZ3kQt8gbkiSfv1dN0sgIqQ5Lm78Q=;
 b=Mi+20XeI3QlQZ5VQn1UaH5ImztPeT1HaHoyuuu0KbUu7wpSvOhZXQ4d8v1D4umYungQaemsDd6md3GdQeH9xcgqhPb5N4s9Gcjfq5d2PaSvZH922hB2K1XndfVyiGuq2uIuTVFqXS/bpIxnl/0aLUDvfcIm/m0yzUezTC8TgZkwsIiM3mNL85u0MzLqOs5wL8w21CULhsgkGoGzWGyQ6AOsCHxRk6fDTy4FyvMwec8kvv+9BfX/5drWt0t+QCnKk0UIUOsXAcLbzrmm7ubtMP23BRPulq75WspsGovvrJs8S88wRQLGN63KuCcv7FxTPg4tSYQ73LrsEKugwgdLDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urlbFqMrXAahX5PZ3kQt8gbkiSfv1dN0sgIqQ5Lm78Q=;
 b=E8Y3b1FqUVOWLrv/w4VwS2NZBUA8QqVtvXG8GcFDh7pfV5fFQPU7OL4J+AN/1pY0gz4VZOpViy+SsER4c3cQobB7rUGh16c0D3IzasSFrMcHBYzpkxe6F346btF0NlipuE4nQ/ZAm5BlMoskiCw2pvFK2IjJXrYR3QjhdvMo5C8=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5444.jpnprd01.prod.outlook.com (2603:1096:604:ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 18:13:40 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 18:13:39 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 04/18] ravb: Enable aligned_tx and tx_counters for
 RZ/G2L
Thread-Topic: [RFC/PATCH 04/18] ravb: Enable aligned_tx and tx_counters for
 RZ/G2L
Thread-Index: AQHXsIR/rI9qtDBWJEutPtc4C318GKux6kYAgAABRFA=
Date:   Thu, 23 Sep 2021 18:13:39 +0000
Message-ID: <OS0PR01MB59225ECD831AFBAB4427441F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-5-biju.das.jz@bp.renesas.com>
 <61e541a7-338c-a9d1-0504-f2f7baf0ffed@omp.ru>
In-Reply-To: <61e541a7-338c-a9d1-0504-f2f7baf0ffed@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bd0820b-70b6-4003-a6b5-08d97ebddead
x-ms-traffictypediagnostic: OS0PR01MB5444:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB544424B844A7B74E589A502586A39@OS0PR01MB5444.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x9osHwUdLKmfdWNNFD4pOXvd9V9d9MqNyZXsq5aCB84OkDNsT1Gab2KJ+8DOvmmWojleM2q6VIYfE0Q9HkM7LbUWPzGQN0PxyfERz9z51H6tUrFMeIa/zEpPq00diXYDF5BhtNjRFfojw+xJ9zz2xwHA3ijsKnMITfN1/YOSMenwFYL/ZMBybOaMceR+MGCG8x42rZ7LrJO1XRdH80QM7XYrLHoIlc51f9+d+3YbWSSuwRQW7BYXoi2Mnr6nxpBdmUPaR5cWALKNTFxpeycpKBidu9P/jjie3O8ZLBeNxwXJrLVkDIKNSa05itHwUQxHQsF6xadCKdY2qwju3FeKuE6p4rO0luP4zAzJi8JLCy6y55al2mPtfJ/CkJSCWA/glTUHLrCEGfEq7o5Q1NFxUdFaJHg7mSEmQXPfiUYathU9mZM5VRci9N6ny2bAmT/MhhtsmtRKs31XIAY1YEnmbn8G8gIRFASE8b8Q1sm+zvm7DDcv1GMnsYkncchvaVyoLUCx47YSYQMUoqleiHaqcoEmc2K6FHi4FHvC8atP1SQapkGjFRi9t4egeTy6jn0Hyl99Vdq86VRXOH3Lg+5xx4RlbPRurnoyD+wpr/HuFa4VOrD7/MxoKJiYtK6zhqfNwz4mfLuR5EEmAB7ypoidrfBXdj4beVXzJcz1GnPN7To9URdmhaL4cPqblaT6ieIT0aEnceDvkANpL+R33Rryrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(26005)(38100700002)(52536014)(5660300002)(54906003)(53546011)(6506007)(55016002)(8676002)(83380400001)(110136005)(7696005)(9686003)(508600001)(186003)(107886003)(4326008)(38070700005)(2906002)(316002)(8936002)(66476007)(122000001)(64756008)(66946007)(66556008)(66446008)(33656002)(76116006)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlRUNlFjejdIb0thQnFYSXpnb2JCdkRmcXpTRWxSTFdISG4xM3R3ZUdCd3JX?=
 =?utf-8?B?QzhjNnMvNWxvcVl0N3JENy9OYmFvME1YZVduNzRGRTZGS2M5VnBZb05MamFx?=
 =?utf-8?B?U0xPaEpFWXI5ZGN4Tnptb2JKWDFxRTAzcm5wc2Q4bDVzNTluVi95bGVVazlv?=
 =?utf-8?B?MTNDNHlxNXYyK0c4RGdnMzUyRy91bmVIU2FlTy9HcjFDc3NvYTBHdGFIczhW?=
 =?utf-8?B?Z1BNTFVJSzJGV0JESFlTTjB4YnJzcTBVY3RWMDFiYkI0a2JpbmNkd3Jta0p0?=
 =?utf-8?B?Y0ZhSjB4U0ovNWMxM3lLOGJESldKeHFhT3FUOFVXL0ZnN0x2WWJ2T0QwNzhq?=
 =?utf-8?B?bG9jSnJjS1QxeTZLSlFicE4vOFhoYXh2ZGhHL3oxRVBkTVY5eW9RZTkxYThQ?=
 =?utf-8?B?WXc4YTZlbjRURHo3QXgzMVpZRk96QXlYeEhxeW1XN3pnZHBYd29UVnIyVGky?=
 =?utf-8?B?U3FBaDVNSWF6eGlPcnlQdnd1emFWOUNLUmQyR04rSG44Z3JlQmR4RUhUSGU4?=
 =?utf-8?B?dkMwTXladUk4VERJaXNieGZsZ2RFMUw0Z25SQ2xGb1c1eVpLbkNTUUxjLzhO?=
 =?utf-8?B?MlNTSnNtYVhMV3ZYbEtDMDF4UCtvc3RVMGhiVUtnWnJ2RzkxSmdmYlBXVVRB?=
 =?utf-8?B?dFNBM3IwOC9vZFNwZ3g4TDlXTmN6REJyeUFSdFJUWVhZQzlRdXB2YkRnTXAr?=
 =?utf-8?B?VGJFcjRyNmF1TXl2NmNhTVc3WG9SWEs4K1hHZzVMb0g2YW9LdzBvaFB2TXMr?=
 =?utf-8?B?NnVkRXN2anc0bXU0U0xuMWNLYUJ0U0lVOCswYkMxVUFkK3NJQkJuSExMV2Nk?=
 =?utf-8?B?ZTByWGdSWlNTbmpGcDZSR3N3eTFyL3B3WGlYZHZGMHI4UjZlejJPQ0o3cWFk?=
 =?utf-8?B?cFBUcUlQd1U5Y1Zqa2t6amtGU3pTVGV2NHYxYTVXVFBqdXN6RXEzanNJc2s3?=
 =?utf-8?B?SnVpRmU0ZC9zTE5lN21TV2xVZk5QQlVoN3hKdzJxdzAyeGlYZ01jZDFtbFRp?=
 =?utf-8?B?SVVkK1d1SkN0V0NFN3EwNFB3NXd5VGorR0xsMEhzdkVRa3RtMUw0MVAvNjF0?=
 =?utf-8?B?MUlFWEMzeERxNWZ4d0gyZzczWk53bzh5bVhlTmhNSmt6Uy9NbjdTMHBEZUVD?=
 =?utf-8?B?cHY0UndraDVLVzlTWnoxTmI5anVqQVhQVmEwR3BHb1hsamw2QklJeVNQMkx6?=
 =?utf-8?B?U3JCK0ZiTFdMa3E0dzNWMk1iOWFQTnZGOEFIN0x5YjE0ZGZuTUhNSStJemY3?=
 =?utf-8?B?VXNQeWNodUxseDRjTnQyV1RPeXNueHpBWGtTdzJHeGlCekxrd3hBYTlHSHIr?=
 =?utf-8?B?cnQrd3BwM2VXSjlzWC9lbThWT2UrN1dPbUQxQk5NMkJ1eHNBYjRQVzhnN0dv?=
 =?utf-8?B?NmYxSFVXSkRSL0h1ZnZnTXN2Zk00VHRndWtWUC9NK3VEUkduUzVVR0wwVG0y?=
 =?utf-8?B?RmtTZmVLdUxIbGRNOHdUSXQ4VjVBTXViekNqbnB1MEEyaWxOL3QvajAzeHFV?=
 =?utf-8?B?MXlyZ3l0aWRqOHRGUDhLMnlVdFB5UHRlNWx3ZFVTTXE0cGRPUEN2VWk3aDk2?=
 =?utf-8?B?Wm9OZTg0dE5QNytLRFVydWJjWjBKdm05cVV3UWhRSzRpRzZMU2NhYUVoejc4?=
 =?utf-8?B?UEVJNDRybHpjUHJwalJKUHl4cGZxeWE4S0VlNFBHcm5rdzZLOFlSa0tPZy83?=
 =?utf-8?B?TU53YXhaS3ROZmlqSkk3YlNMVDlTa1FCQ2J3Z1FFNVJQMERsVGFsRFh1MzF2?=
 =?utf-8?Q?KEK+Q9WHvQrDwhnEfqSsJjXUKGs5QmCkdOSt6Ur?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd0820b-70b6-4003-a6b5-08d97ebddead
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 18:13:39.7764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GmLsdTv0Ckp9y0uLUWRDyJWS3JOJN6vkc2jV9AF3JuEwdNU2AhzvDtq2SDVmDfRuFXpMZfVV+yWJ3K+4geC5X71H+qe7wevAZkUVqVD9NMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5444
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gU3ViamVjdDogUmU6IFtS
RkMvUEFUQ0ggMDQvMThdIHJhdmI6IEVuYWJsZSBhbGlnbmVkX3R4IGFuZCB0eF9jb3VudGVycyBm
b3INCj4gUlovRzJMDQo+IA0KPiBPbiA5LzIzLzIxIDU6MDcgUE0sIEJpanUgRGFzIHdyb3RlOg0K
PiANCj4gICAgU29tZWhvdyB0aGlzIHBhdGNoIGhhdmVuJ3QgcmVhY2hlZCBteSBPTVAgZW1haWwg
LS0gSSBnb3QgaXQgb25seSB0aHJ1DQo+IHRoZSBsaW51eC1yZW5lc2FzLXNvYyBsaXN0Li4uIDot
Lw0KPiANCj4gPiBSWi9HMkwgbmVlZCA0Ynl0ZSBhZGRyZXNzIGFsaWdubWVudCBsaWtlIFItQ2Fy
IEdlbjIgYW5kIGl0IGhhcw0KPiA+IHR4X2NvdW50ZXJzIGxpa2UgUi1DYXIgR2VuMy4gVGhpcyBw
YXRjaCBlbmFibGUgdGhlc2UgZmVhdHVyZXMgZm9yDQo+ID4gUlovRzJMLg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IC0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgMiArLQ0K
PiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jIHwgMiArKw0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IGJlZTA1ZTZm
YjgxNS4uYmI5MjQ2OWQ3NzBlIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yi5oDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9y
YXZiLmgNCj4gPiBAQCAtMTk1LDcgKzE5NSw3IEBAIGVudW0gcmF2Yl9yZWcgew0KPiA+ICAJR0VD
TVIJPSAweDA1YjAsDQo+ID4gIAlNQUhSCT0gMHgwNWMwLA0KPiA+ICAJTUFMUgk9IDB4MDVjOCwN
Cj4gPiAtCVRST0NSCT0gMHgwNzAwLAkvKiBSLUNhciBHZW4zIG9ubHkgKi8NCj4gPiArCVRST0NS
CT0gMHgwNzAwLAkvKiBSLUNhciBHZW4zIGFuZCBSWi9HMkwgb25seSAqLw0KPiA+ICAJQ0VGQ1IJ
PSAweDA3NDAsDQo+ID4gIAlGUkVDUgk9IDB4MDc0OCwNCj4gPiAgCVRTRlJDUgk9IDB4MDc1MCwN
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4u
Yw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IGlu
ZGV4IDU0YzRkMzFhNjk1MC4uZDM4ZmMzM2E4ZTkzIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gQEAgLTIxMTQsNiArMjExNCw4IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHJnZXRoX2h3X2luZm8gPSB7DQo+ID4gIAku
c2V0X2ZlYXR1cmUgPSByYXZiX3NldF9mZWF0dXJlc19yZ2V0aCwNCj4gPiAgCS5kbWFjX2luaXQg
PSByYXZiX2RtYWNfaW5pdF9yZ2V0aCwNCj4gPiAgCS5lbWFjX2luaXQgPSByYXZiX3JnZXRoX2Vt
YWNfaW5pdCwNCj4gPiArCS5hbGlnbmVkX3R4ID0gMSwNCj4gPiArCS50eF9jb3VudGVycyA9IDEs
DQo+IA0KPiAgICBNaG0sIEkgZG9uJ3Qgc2VlIGEgY29ubmVjdGlvbiBiZXR3ZWVuIHRob3NlIDIg
KG90aGVyIHRoYW4gdGhleSdyZSBib3RoDQo+IGZvciBSWCkuIEFuZCBhbnl3YXksIHRoaXMgcHJv
bGx5IHNob3VsZCBiZSBhIHBhcnQgb2YgdGhlIHByZXZpb3VzIHBhdGNoLi4uDQoNClRoZXJlIHdh
cyBhIGRpc2N1c3Npb24gdG8gbWFrZSBzbWFsbGVyIHBhdGNoZXMuIElmIHRoZXJlIGlzIG5vIG9i
amVjdGlvbiwgb24NCnRoZSBuZXh0IHJldmlzaW9uIEkgd2lsbCBhZGQgdGhpcyBhcyBwYXJ0IG9m
IHByZXZpb3VzIHBhdGNoLg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQoNCg==
