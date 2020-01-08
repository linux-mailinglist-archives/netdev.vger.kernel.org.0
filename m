Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F928133C15
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgAHHPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 02:15:55 -0500
Received: from mail-eopbgr1300059.outbound.protection.outlook.com ([40.107.130.59]:37152
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725944AbgAHHPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 02:15:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7/t1YLWd1KoQ6Qm3hg7nBj72w5eyghmuIAW5a9oeC9xUWB/v/C2Wgu7/5aL2yaWMb40umqnqfnXrieCR9fT1rm1Hb4r7b/uWrGEOGzeh6yO+eRYa0+8geGZAl9hdfrGnHg8n28YL78sBLq83Tq1zNtPHaJrVEIxGVLYBfL7iHgOSfLFprBx8aMr/Ry9fo+/YOs94xwQX1fI+eNV7R+oHZGEC90LeX5Wju1RKXr4u3Sk+fTjT6K6NE4oe7l602wTJZTBB2NJWG5zzAJVY17tbZuI56ZA/1hHcHD3mchgNEkFSf4jrSpWVA3PRj+tOPX8vvETZMihBvm6K3268ZIcIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHNXtWTMrmFzpTp1CSsClQKuNIjKBlsj0XVonTfrhhI=;
 b=UvKQxEfe3kn3bgnL1QdNtELkbTg25I+gwNP9x61HUjMbhqdXdAZbtIZysNDe+n906bzBrcBRkBWRpK0CbyCQhJIPTL2sfX53zhy1eb9JA+tveVrpWP/gnu6oOMth2miGjpQ0hNgln/Jq7Ihx5l/8gFV2k8Sx6p2MIaOjmv/n5EgHBYsrozMTMFnupFIVoW4PPiyvImSGpLoF3nlkXGsLpSkuGbnhD9U1qrqNLkShtvD1AHZWb9Hj12AZ8oDBgkIWRs+qUJKoS1eboVYa22IigPS2Djm7ZuhjIUF9fBbX8XlQfDChjqN/o3Qu6Tcfcl7cfk3FzxOek/KPNA+DGG0Qvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=moxa.com; dmarc=pass action=none header.from=moxa.com;
 dkim=pass header.d=moxa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Moxa.onmicrosoft.com;
 s=selector2-Moxa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHNXtWTMrmFzpTp1CSsClQKuNIjKBlsj0XVonTfrhhI=;
 b=D6ieEGkwD2/8RYtUZX7QM2oSFiWT9Gd4Ipxr/SwkSm0FcQpiE/g4em3Dn3DDdBGlMQu73v775qMXtp/fU6rQOd4AocRaHJpbYquZUE+VjrieyLoj7GP0TFS+AldjU2mS10iNBQCUGGiqBuVhf03nJGDAmP1kN7OQc9O5miFoVnk=
Received: from HK0PR01MB3521.apcprd01.prod.exchangelabs.com (52.132.237.22) by
 HK0PR01MB3490.apcprd01.prod.exchangelabs.com (10.255.253.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 07:15:49 +0000
Received: from HK0PR01MB3521.apcprd01.prod.exchangelabs.com
 ([fe80::3433:35cd:2be4:d042]) by HK0PR01MB3521.apcprd01.prod.exchangelabs.com
 ([fe80::3433:35cd:2be4:d042%6]) with mapi id 15.20.2602.016; Wed, 8 Jan 2020
 07:15:49 +0000
From:   =?utf-8?B?Sm9obnNvbiBDSCBDaGVuICjpmbPmmK3li7Mp?= 
        <JohnsonCH.Chen@moxa.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zero19850401@gmail.com" <zero19850401@gmail.com>
Subject: RE: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Thread-Topic: [PATCH] gianfar: Solve ethernet TX/RX problems for ls1021a
Thread-Index: AdXFRAcg+ooT8TPrTsG92JEuKMTbqwALfpoAACBDpFA=
Date:   Wed, 8 Jan 2020 07:15:49 +0000
Message-ID: <HK0PR01MB35219F5DF16CE54D088ACE2CFA3E0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
References: <HK0PR01MB3521C806FE109E04FA72858CFA3F0@HK0PR01MB3521.apcprd01.prod.exchangelabs.com>
 <CA+h21hpERd-yko+X9G-D9eFwu3LVq625qDUYvNGtEA8Ere_vYw@mail.gmail.com>
In-Reply-To: <CA+h21hpERd-yko+X9G-D9eFwu3LVq625qDUYvNGtEA8Ere_vYw@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=JohnsonCH.Chen@moxa.com; 
x-originating-ip: [122.146.92.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 274c2fed-c2f8-4360-5046-08d7940a96db
x-ms-traffictypediagnostic: HK0PR01MB3490:
x-microsoft-antispam-prvs: <HK0PR01MB34902C8485102CA4007B7CEBFA3E0@HK0PR01MB3490.apcprd01.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(39850400004)(366004)(136003)(189003)(199004)(85182001)(6916009)(4326008)(316002)(33656002)(478600001)(186003)(8936002)(966005)(81156014)(86362001)(54906003)(81166006)(2906002)(55016002)(66476007)(7696005)(5660300002)(66946007)(66446008)(76116006)(64756008)(71200400001)(26005)(8676002)(6506007)(52536014)(9686003)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:HK0PR01MB3490;H:HK0PR01MB3521.apcprd01.prod.exchangelabs.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: moxa.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIfHQdvFB2KP7pZ9uSnIUBGIlCEU5WvXB0DEvhKlT67POeZKLc13iUNhH2HwWQ1KIKPRk9UmpCIcpvXZzkeTxj8o9j2xzBP3b+0mePrmTNG2cppfW3pY1bZwGkYz2BglpKU/FfhrkMXUTYXHkCfWF+utBHMJHnA75rRjVbSbrs9zKZX5qPqM458koQ6I1zcl0Goko170yDJjfBCTZ/UHApF8jXTf21kNDI+LOomrlCXeoVj/KXSTacgguftc5wYdkJ8QPG/37GBzyBrse7X3lXpi8QqHoEqBZZALGT872DezUQUgzypleDekmVuvZLLF+lvbjXC/I6d7FCue6olT2Qir7TKyhSJXP3xiWgswOGVjN9h85fNaWz109Q/j6QaZeCM0IcDOC/T6Xn/bJZzx0TeFnrUxBhpa1U5IZ9Ld9qFHdsbnABuAWjvOYOCXxkeGKTQFDr3nP6Y2fDWSzvIbJCnw7Yd4oM9bTJxxm0GXH64Ws5t8f++rkq+5TS6MtyyzmrFWvequsB0J8ezQV7h34w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: moxa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 274c2fed-c2f8-4360-5046-08d7940a96db
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 07:15:49.6154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5571c7d4-286b-47f6-9dd5-0aa688773c8e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: swOmOjtnmhRAOgbe5mRQiYJ6kL9Anpb8G0s0/0gOna/KzD0N5Ebo51fOoJhNKIpRLUhQPdEEC7q3YG3+1Jk13w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR01MB3490
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNClZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+IOaWvCAy
MDIw5bm0MeaciDfml6Ug6YCx5LqMIOS4i+WNiDExOjQ55a+r6YGT77yaDQo+DQo+IEhpIENoZW4s
DQo+DQo+IE9uIFR1ZSwgNyBKYW4gMjAyMCBhdCAxMjozNywgSm9obnNvbiBDSCBDaGVuICjpmbPm
mK3li7MpDQo+IDxKb2huc29uQ0guQ2hlbkBtb3hhLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBBZGQg
ZG1hX2VuZGlhbl9sZSB0byBzb2x2ZSBldGhlcm5ldCBUWC9SWCBwcm9ibGVtcyBmb3IgZnJlZXNj
YWxlIA0KPiA+IGxzMTAyMWEuIFdpdGhvdXQgdGhpcywgaXQgd2lsbCByZXN1bHQgaW4gcngtYnVz
eS1lcnJvcnMgYnkgZXRodG9vbCwgYW5kIHRyYW5zbWl0IHF1ZXVlIHRpbWVvdXQgaW4gbHMxMDIx
YSdzIHBsYXRmb3Jtcy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvaG5zb24gQ2hlbiA8am9o
bnNvbmNoLmNoZW5AbW94YS5jb20+DQo+ID4gLS0tDQo+DQo+IFRoaXMgcGF0Y2ggaXMgbm90IHZh
bGlkLiBUaGUgZW5kaWFubmVzcyBjb25maWd1cmF0aW9uIGluIA0KPiBlVFNFQ3hfRE1BQ1RSTCBp
cyByZXNlcnZlZCBhbmQgbm90IGFwcGxpY2FibGUuDQo+IFdoYXQgaXMgdGhlIHZhbHVlIG9mIFND
RkdfRVRTRUNETUFNQ1IgYml0cyBFVFNFQ19CRCBhbmQgRVRTRUNfRlJfREFUQSANCj4gb24geW91
ciBib2FyZD8gVHlwaWNhbGx5IHRoaXMgaXMgY29uZmlndXJlZCBieSB0aGUgYm9vdGxvYWRlci4N
Cj4NCg0KVGhhbmtzIHlvdXIgc3VnZ2VzdGlvbi4gSSB1c2UgbGludXgtZnNsLXNkay12MS43LCBh
bmQgZmluZCAiZG1hLWVuZGlhbi1sZSIgaXMgdXNlZCBpbiBsczEwMjFhLmR0c2kgYW5kIGdpYW5m
YXIuYy8uaC4gRm9yIGJvb3Rsb2FkZXIsIHZlcnNpb24gaXMgVS1Cb290IHZlcnNpb24gaXMgMjAx
NS4wMS1kaXJ0eSBhbmQgaXQgc2VlbXMgb2xkIGFuZCBub3QgaW5jbHVkZXMgIlNDRkdfRVRTRUNE
TUFNQ1IgYml0cyIuDQoNCkl0IHNlZW1zIHNvbHV0aW9uIGlzIGluY2x1ZGVkIGluIGJvb3Rsb2Fk
ZXIsIG5vdCBpbiBkZXZpY2UgdHJlZSBmb3INCmZyZWVzY2FsZS9OWFA6IGh0dHBzOi8vbHhyLm1p
c3NpbmdsaW5rZWxlY3Ryb25pY3MuY29tL3Vib290L2JvYXJkL2ZyZWVzY2FsZS9sczEwMjFhaW90
L2xzMTAyMWFpb3QuYw0KDQpJdCBtZWFucyBib290bG9hZGVyIHByb3ZpZGVzIGZ1bmN0aW9ucyBh
cmUgdGhlIHNhbWUgYXMgZGV2aWNlIHRyZWUncy4NClNvIHdoYXQncyBiZW5lZml0IGZvciB0aGlz
IGRlc2dpbj8gSXQgc2VlbXMgd2UgbmVlZCB0byB1cGdyYWRlIGtlcm5lbCBhbmQgYm9vdGxvYWRl
ciB0byBzYXRpc2Z5IG91ciBuZWVkLCBub3QganVzdCB1cGdyYWRlIGtlcm5lbCBvbmx5LiBTbyBt
YW55IHRoYW5rcyENCg0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZh
ci5jIHwgMyArKysgIA0KPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFy
LmggfCA0ICsrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKykNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5j
IA0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KPiA+IGlu
ZGV4IDcyODY4YTI4YjYyMS4uYWI0ZTQ1MTk5ZGY5IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFyLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5jDQo+ID4gQEAgLTgzMyw2ICs4MzMsNyBAQCBzdGF0
aWMgaW50IGdmYXJfb2ZfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlIA0KPiA+ICpvZmRldiwg
c3RydWN0IG5ldF9kZXZpY2UgKipwZGV2KQ0KPiA+DQo+ID4gICAgICAgICAvKiBGaW5kIHRoZSBU
QkkgUEhZLiAgSWYgaXQncyBub3QgdGhlcmUsIHdlIGRvbid0IHN1cHBvcnQgU0dNSUkgKi8NCj4g
PiAgICAgICAgIHByaXYtPnRiaV9ub2RlID0gb2ZfcGFyc2VfcGhhbmRsZShucCwgInRiaS1oYW5k
bGUiLCAwKTsNCj4gPiArICAgICAgIHByaXYtPmRtYV9lbmRpYW5fbGUgPSBvZl9wcm9wZXJ0eV9y
ZWFkX2Jvb2wobnAsIA0KPiA+ICsgImZzbCxkbWEtZW5kaWFuLWxlIik7DQo+ID4NCj4gPiAgICAg
ICAgIHJldHVybiAwOw0KPiA+DQo+ID4gQEAgLTEyMDksNiArMTIxMCw4IEBAIHN0YXRpYyB2b2lk
IGdmYXJfc3RhcnQoc3RydWN0IGdmYXJfcHJpdmF0ZSAqcHJpdikNCj4gPiAgICAgICAgIC8qIElu
aXRpYWxpemUgRE1BQ1RSTCB0byBoYXZlIFdXUiBhbmQgV09QICovDQo+ID4gICAgICAgICB0ZW1w
dmFsID0gZ2Zhcl9yZWFkKCZyZWdzLT5kbWFjdHJsKTsNCj4gPiAgICAgICAgIHRlbXB2YWwgfD0g
RE1BQ1RSTF9JTklUX1NFVFRJTkdTOw0KPiA+ICsgICAgICAgaWYgKHByaXYtPmRtYV9lbmRpYW5f
bGUpDQo+ID4gKyAgICAgICAgICAgICAgIHRlbXB2YWwgfD0gRE1BQ1RSTF9MRTsNCj4gPiAgICAg
ICAgIGdmYXJfd3JpdGUoJnJlZ3MtPmRtYWN0cmwsIHRlbXB2YWwpOw0KPiA+DQo+ID4gICAgICAg
ICAvKiBNYWtlIHN1cmUgd2UgYXJlbid0IHN0b3BwZWQgKi8gZGlmZiAtLWdpdCANCj4gPiBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFyLmggDQo+ID4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5oDQo+ID4gaW5kZXggNDMyYzZhODE4YWU1Li5h
YWUwN2RiNTIwNmIgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNj
YWxlL2dpYW5mYXIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9n
aWFuZmFyLmgNCj4gPiBAQCAtMjE1LDYgKzIxNSw3IEBAIGV4dGVybiBjb25zdCBjaGFyIGdmYXJf
ZHJpdmVyX3ZlcnNpb25bXTsNCj4gPiAgI2RlZmluZSBETUFDVFJMX0lOSVRfU0VUVElOR1MgICAw
eDAwMDAwMGMzDQo+ID4gICNkZWZpbmUgRE1BQ1RSTF9HUlMgICAgICAgICAgICAgMHgwMDAwMDAx
MA0KPiA+ICAjZGVmaW5lIERNQUNUUkxfR1RTICAgICAgICAgICAgIDB4MDAwMDAwMDgNCj4gPiAr
I2RlZmluZSBETUFDVFJMX0xFICAgICAgICAgICAgIDB4MDAwMDgwMDANCj4gPg0KPiA+ICAjZGVm
aW5lIFRTVEFUX0NMRUFSX1RIQUxUX0FMTCAgMHhGRjAwMDAwMA0KPiA+ICAjZGVmaW5lIFRTVEFU
X0NMRUFSX1RIQUxUICAgICAgMHg4MDAwMDAwMA0KPiA+IEBAIC0xMTQwLDYgKzExNDEsOSBAQCBz
dHJ1Y3QgZ2Zhcl9wcml2YXRlIHsNCj4gPiAgICAgICAgICAgICAgICAgdHhfcGF1c2VfZW46MSwN
Cj4gPiAgICAgICAgICAgICAgICAgcnhfcGF1c2VfZW46MTsNCj4gPg0KPiA+ICsgICAgICAgLyog
bGl0dGxlIGVuZGlhbiBkbWEgYnVmZmVyIGFuZCBkZXNjcmlwdG9yIGhvc3QgaW50ZXJmYWNlICov
DQo+ID4gKyAgICAgICB1bnNpZ25lZCBpbnQgZG1hX2VuZGlhbl9sZTsNCj4gPiArDQo+ID4gICAg
ICAgICAvKiBUaGUgdG90YWwgdHggYW5kIHJ4IHJpbmcgc2l6ZSBmb3IgdGhlIGVuYWJsZWQgcXVl
dWVzICovDQo+ID4gICAgICAgICB1bnNpZ25lZCBpbnQgdG90YWxfdHhfcmluZ19zaXplOw0KPiA+
ICAgICAgICAgdW5zaWduZWQgaW50IHRvdGFsX3J4X3Jpbmdfc2l6ZTsNCj4gPiAtLQ0KPiA+IDIu
MTEuMA0KPiA+DQo+ID4gQmVzdCByZWdhcmRzLA0KPiA+IEpvaG5zb24NCj4NCj4gUmVnYXJkcywN
Cj4gLVZsYWRpbWlyDQoNCkJlc3QgcmVnYXJkcywNCkpvaG5zb24NCg==
