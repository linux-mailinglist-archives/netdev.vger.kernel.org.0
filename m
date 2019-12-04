Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0074211215C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 03:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLDCWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 21:22:34 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:22004
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfLDCWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 21:22:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0FjtU7DG92khteA2jEJWevfemyVOqTE+soQJ7xlX/d/UwMwUlFcq+3o7Bvt2ioCyjxqQ9P2KAXI/zXRa4rZK/55FlWS74IbqkRQknBUEf+LgmJtPH5N1VSfcEucUBoNTsXfWUiKtlUInwt2Yx3wQQ1ikWqA2XX1cMxc7kM8kfFU7yDsw3JhDjTVhKpVh874x2UuULan3XOO0L/fA+4EHulMYWS1qUrPjJG6sRTd+BIZRyH5hBXMwltptr/kDD+UzV3OLWltI9ZPqF2kjC+hJr9A2tyEMIla1PjyFksLLcgAknO3OQtaiS4gRbd4c8izU6FYSk+wERUu/kLro+t1xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWDoFVojJl6z6rj79GW7lf3isVHJn4UfTOTzO1MrywE=;
 b=P7IcTigUlnuUX+i4gWxJd7pW6Yw7o5K5ryhySg3UODm8LQXEgunOJfgTb1OIqzSNbLR8pkZAtf4bdPoTNEkGAVjxDHAkkvPviTxEwXa72MyUco2rRtlUHKSz9AKiopWk28FVX5heV1rlH+mbSs1NpCpI93uPKUB/lbx6P38bja0LDo6g91ephZXc8mGk3wYZY+S90XPAWpjQQ0G2S94oXkcwom8SaP5Meo8v9W4XgYle7jQGhZ7mmc31OcZxX316/EV6AL/9TjyY3A1EmBgWAAKjzKDerpA4F/ehm1QvY34Pis8wVNNEck6ndugZOAer1ZORGbnnn4ElyE3uX6Hi3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KWDoFVojJl6z6rj79GW7lf3isVHJn4UfTOTzO1MrywE=;
 b=aFzDwBk9GYkyeGbD8nZkzzrVsW6i6KADpvk3Tix2HFXZZG/GgED5ZlQexRD0EHjtPDhF7U2Abd2C+uZq20mbSy0wkO+1mnsxn/umeiLpQEV4e0PPqmPO+V5rmKB8yp2PyT1nx+f3lJe/+uVkxYLaJ7lFygOwLOWjuD+ThbECxTQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4857.eurprd04.prod.outlook.com (20.176.233.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Wed, 4 Dec 2019 02:22:30 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 02:22:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Topic: [PATCH V2 2/4] can: flexcan: try to exit stop mode during probe
 stage
Thread-Index: AQHVpOd0/zAyRBOEIkuRK6cuc/m3PqeowUOAgACCKzA=
Date:   Wed, 4 Dec 2019 02:22:29 +0000
Message-ID: <DB7PR04MB46180C5F1EAC7C4A69A45E0CE65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-3-qiangqing.zhang@nxp.com>
 <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
In-Reply-To: <ad7e7b15-26f3-daa1-02d2-782ff548756d@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: sean@geanix.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f9cefacc-1205-46e9-695e-08d77860d026
x-ms-traffictypediagnostic: DB7PR04MB4857:|DB7PR04MB4857:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4857879EBF894FE4FFE461FAE65D0@DB7PR04MB4857.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(13464003)(199004)(189003)(55016002)(3846002)(26005)(33656002)(99286004)(86362001)(7736002)(966005)(6436002)(305945005)(2906002)(4326008)(2201001)(25786009)(71200400001)(52536014)(446003)(186003)(8676002)(6306002)(5660300002)(54906003)(11346002)(110136005)(6246003)(71190400001)(81166006)(81156014)(6116002)(76116006)(2501003)(66946007)(316002)(76176011)(478600001)(229853002)(14444005)(8936002)(66556008)(9686003)(14454004)(102836004)(53546011)(6506007)(64756008)(256004)(74316002)(66446008)(7696005)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4857;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mCQirs/7cyZ2V+4WCZ8I68XHr3CdgFN0VElU7n5O/TnQsxMaMWrKW5oXm5CsL3mvWLwfY40RLlIPb+wy5JV2DN5BTU7DUfJT5jAvuGTlUIuiavTVp4J/oCMBZN7MLzwVwkyWcWJJAiHFqCXEG8htINuGm3dWU0l5epwhWAW9RkTkgocdJYpf2fohVUguqJLW2BJ0/XpWNzIGmPyJtUDu8iAOHdegDUmi5yH7WzZ46daNiqiFfEgOMQ46amJRfsj3uKI4l1JTI3dNgBYiL+N1pxNv9fH7s2nilMNEy7sjYRHhV4KZI+OmsjSs6ivZ5DjAGHB4vlxQj8ksvGDs/Z6HNbGcO0rnVVIaf2ca2c22MuiF/8UJVJR5rprtQuIJuloA011eQ30LhanYlKKZV5q7SWxFPfOOmFITJEqYu3mgOOShvwLMePj0/eokRqCCrQRpIqyQrZUv35JVamkCyFPnGvRDCVUXnX+fa4I6DHTsx2Pk1+mulwqTcPrzjUxyI9fLd2ilsXmm0avJT5cE6zKZtf/CrLRLDo9sIPZ7GTPGawk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9cefacc-1205-46e9-695e-08d77860d026
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 02:22:29.8837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HCHyfnGHvuNO1+E66851jpJZsUVV/+fLfulSVWf+rmYC5jMLAuq9eX3KBIAFPXrNxqPlUAJHTJ2U71QpwrXOig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4857
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMjoxNQ0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IHNlYW5AZ2Vhbml4LmNv
bTsNCj4gbGludXgtY2FuQHZnZXIua2VybmVsLm9yZw0KPiBDYzogZGwtbGludXgtaW14IDxsaW51
eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBWMiAyLzRdIGNhbjogZmxleGNhbjogdHJ5IHRvIGV4aXQgc3RvcCBtb2RlIGR1cmluZyBw
cm9iZQ0KPiBzdGFnZQ0KPiANCj4gT24gMTEvMjcvMTkgNjo1NiBBTSwgSm9ha2ltIFpoYW5nIHdy
b3RlOg0KPiA+IENBTiBjb250cm9sbGVyIGNvdWxkIGJlIHN0dWNrZWQgaW4gc3RvcCBtb2RlIG9u
Y2UgaXQgZW50ZXJzIHN0b3AgbW9kZQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgIF5eXl5e
Xl4gc3R1Y2sNCj4gPiB3aGVuIHN1c3BlbmQsIGFuZCB0aGVuIGl0IGZhaWxzIHRvIGV4aXQgc3Rv
cCBtb2RlIHdoZW4gcmVzdW1lLg0KPiANCj4gSG93IGNhbiB0aGlzIGhhcHBlbj8NCg0KSSBhbSBh
bHNvIGNvbmZ1c2VkIGhvdyBjYW4gdGhpcyBoYXBwZW4sIGFzIEkgYXNrZWQgU2Vhbiwgb25seSBD
QU4gZW50ZXIgc3RvcCBtb2RlIHdoZW4gc3VzcGVuZCwgdGhlbiBzeXN0ZW0gaGFuZywgaXQgY291
bGQgbGV0IENBTg0Kc3R1Y2sgaW4gc3RvcCBtb2RlLiBIb3dldmVyLCBTZWFuIHNhaWQgdGhpcyBp
bmRlZWQgaGFwcGVuIGF0IGhpcyBzaWRlLCBAc2VhbkBnZWFuaXguY29tLCBjb3VsZCB5b3UgZXhw
bGFpbiBob3cgdGhpcyBoYXBwZW4gaW4gZGV0YWlscz8NCg0KPiA+IE9ubHkgY29kZSByZXNldCBj
YW4gZ2V0IENBTiBvdXQgb2Ygc3RvcCBtb2RlLA0KPiANCj4gV2hhdCBpcyAiY29kZSByZXNldCI/
DQoNCkFzIEkga25vdywgImNvZGUgcmVzZXQiIGlzIHRvIHByZXNzIHRoZSBQT1dFUiBLRVkgZnJv
bSB0aGUgYm9hcmQuIEF0IG15IHNpZGUsIHJlYm9vdCBjb21tYW5kIGZyb20gT1MgYWxzbyBjYW4g
Z2V0IENBTiBvdXQgb2Ygc3RvcCBtb2RlLg0KQmVsb3cgaXMgZXhwZXJpbWVudCBJIGRpZDoNCglG
aXJzdGx5LCBkbyBhIGhhY2tpbmcgdG8gbGV0IENBTiBzdHVjayBpbnRvIHN0b3AgbW9kZSwgdGhl
bjoNCgkoMSkgcHJlc3MgcG93ZXIgb24vb2ZmIGtleSwgZ2V0IENBTiBvdXQgb2Ygc3RvcCBtb2Rl
Ow0KCSgyKSByZWJvb3QgY29tbWFuZCBmcm9tIGNvbnNvbGUsIGdldCBDQU4gb3V0IG9mIHN0b3Ag
bW9kZTsNCgkoMykgdW5iaW5kL2JpbmQgZHJpdmVyLCBjYW5ub3QgZ2V0IENBTiBvdXQgb2Ygc3Rv
cCBtb2RlOyAgDQoJKDQpIHJlbW9kL2luc21vZCBtb2R1bGUsIGNhbm5vdCBnZXQgQ0FOIG91dCBv
ZiBzdG9wIG1vZGU7DQoNCj4gPiBzbyBhZGQgc3RvcCBtb2RlIHJlbW92ZSByZXF1ZXN0IGR1cmlu
ZyBwcm9iZSBzdGFnZSBmb3Igb3RoZXINCj4gPiBtZXRob2RzKHNvZnQgcmVzZXQgZnJvbSBjaGlw
IGxldmVsLCB1bmJpbmQvYmluZCBkcml2ZXIsIGV0YykgdG8gbGV0DQo+ICAgICAgICAgXl5eIHBs
ZWFzZSBhZGQgYSBzcGFjZQ0KPiA+IENBTiBhY3RpdmUgYWdhaW4uDQo+IA0KPiBDYW4geW91IHJl
cGhyYXNlIHRoZSBzZW50ZW5jZSBhZnRlciAic28gYWRkIHN0b3AgbW9kZSByZW1vdmUgcmVxdWVz
dCBkdXJpbmcNCj4gcHJvYmUgc3RhZ2UiLiBJJ20gbm90IGNvbXBsZXRlbHkgc3VyZSB3aGF0IHlv
dSB3YW50IHRvIHRlbGwuDQoNClN1cmUuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
PiA+IE1DUltMUE1BQ0tdIHdpbGwgYmUgY2hlY2tlZCB3aGVuIGVuYWJsZSBDQU4gaW4gcmVnaXN0
ZXJfZmxleGNhbmRldigpLg0KPiA+DQo+ID4gU3VnZ2VzdGVkLWJ5OiBTZWFuIE55ZWtqYWVyIDxz
ZWFuQGdlYW5peC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT4NCg0KWy4uLl0NCg0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRy
b25peCBlLksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8
DQo+IEVtYmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0
cm9uaXguZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTog
KzQ5LTIzMS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4
NiB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
