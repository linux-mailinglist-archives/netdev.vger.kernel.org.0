Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF69616EB89
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbgBYQgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:36:38 -0500
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:4164
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728051AbgBYQgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 11:36:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sr4gg6bMOVWEt+u7y5wiTiwrP9FMYc077kvfzGm5RjhozFDoe6mb9YhH3wun8DxjTbOZp99ZxImvvMFGMxuxfvRFgOCWN5kFPK6oRCVQxLazsm3akBpVfOOoDyvBwZprrS5VWKBzJ6MkYDMZ0x7NgO/5+bluX34S+TvPBdwMPntiDFoz+Z6k6lLs/wRZZ+/OauVEU2kQvvrpO3jJXXe8XyNMVasDv2K5DCxom3DS5LoQI1/9Ut4jNw1RnNsPYXCG9RdyPx3X7ectFs2fKn3HzMAi0F/DVmLJrvHmEY0y4RY81G0/XGiNa8W3nmYtNEbZIw0prhDQZ+qYImuRkYhx3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMaVo8UjQAd6maA5jfw/7GDFwyPr4eLugPKPQSowyd0=;
 b=Tb+X/grsWepsuCuCG+JviDz3FE++/NgikGXWRyToy4hyL4I2UsZ1DT+OKfjdcIpS7TrV8Kcu3vBM41oazwc/ZSWGPrRd/0+lX0Qem8tWDsrjwWd9PZwgeEAiUJbXrXK2zWu540GNgealRk7rL6yIRfPekZbdzGr+YfRur2eulirCcwrOkY4uw6mgrQJ3S3b3TOT3k/or6aj0OrC4YMMQ7eeIsw2fRgroRshsUMIA9c4bONBAsJRA2ZFeq0NQ2GMVifogQnrZTB1prumwRiZRk55+q+H38JG7RaqANtZM9+LsJS1FpA+jPF1DXGxu4fbPv9HjutdPD7NH6PGKS1fTtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMaVo8UjQAd6maA5jfw/7GDFwyPr4eLugPKPQSowyd0=;
 b=ZmBxeNPGfvTXp3dxxnlBzWk0/bWESEeLDcMXarCzrdAvkBVlXLKPrHYAviOqBqpujEioidWvhgCwcuZmzm7ijIEDpvM5PCoJ1z/qJhOKF5VfkBkIh4pOTbL13NlXDiT4PM7aIcsSNbORpcrlwwrU+kz5ty0oxsh2Rp0NyNetxCU=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB6378.eurprd04.prod.outlook.com (10.255.170.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.21; Tue, 25 Feb 2020 16:36:32 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697%6]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 16:36:32 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Felix Fietkau <nbd@nbd.name>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jose Abreu <joabreu@synopsys.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: RE: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Thread-Topic: [PATCH net-next 5/8] net: dpaa2-mac: use resolved link config in
 mac_link_up()
Thread-Index: AQHV67+le9Rplv4RF0eFqNNnaoBGEagsGLhg
Date:   Tue, 25 Feb 2020 16:36:32 +0000
Message-ID: <DB8PR04MB68282F710FB598B977C36F99E0ED0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200225093703.GS25745@shell.armlinux.org.uk>
 <E1j6WgG-0000TJ-CC@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j6WgG-0000TJ-CC@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b3e188bd-970a-4daf-34ea-08d7ba10df74
x-ms-traffictypediagnostic: DB8PR04MB6378:
x-microsoft-antispam-prvs: <DB8PR04MB6378696520D522AFB90DC04FE0ED0@DB8PR04MB6378.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 0324C2C0E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(8936002)(81166006)(81156014)(5660300002)(110136005)(316002)(44832011)(478600001)(9686003)(33656002)(2906002)(54906003)(52536014)(55016002)(71200400001)(7416002)(66446008)(66556008)(76116006)(86362001)(4326008)(26005)(7696005)(8676002)(6506007)(66476007)(64756008)(66946007)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6378;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOn5fBFNdBLP4MykGNwDl1ipSCY4PP0m/gcufXdxe2oWTnyyvFekANXdXq2EzKK5+mGec7Cs/08lq6/1ywr3PtbAzGkzEDn7xQ8kJ/JZZj/h5gLQgowdWSWb19yOD1rwf4jWIyKRTTQYGlha+wuUYojUjkRY+lzyme/inT7vA5VsuXJQZlnC3FghWfdZ81Ob9HzHtXIpzPpje7A1bMoxOmR/vJzkXwc9s00dAxozMs+3zlBDp8z8+t/cH07Ssr2rzERIS1vgbdFRQ9m5eR1OGTEbZ99WNHD4f0gQf1zKfEPYz8O0K0ZZ6mF8KXztonJaQARpZGKECbN8jZU5UBQ9MFr/vXstRRKPT707HT/LAWDX/uw53ON/3tZQlKWqtF1SgIpxGRoYFklg+Xon/5D+h+svad5k8md3wwY3Y4xq9wlQjOgqbZASUAfhsKREb8zj
x-ms-exchange-antispam-messagedata: E0oYTVgO9PNcXsRCumsiz9e7Ui5SBdEZpN+Amn+mXnMhCmx2ugcqQpHImetvi59uFzvxyBDRgSjiUZ5you142aNZbJNr7OfFfLsVpH2gdQyVs02KK6Wq4Wf1Y+LJ8hiORHGTtWoV0DzEFKJtHdjyXw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e188bd-970a-4daf-34ea-08d7ba10df74
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2020 16:36:32.5550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B203kxPU35tv3vsAJhXoG0tbdg8D4QYsvlvFgrGOLMlsMPNCxV+S7nrw4zdBI2kEuuFnLO4EpdDPCLvYATenmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5leHQgNS84XSBuZXQ6IGRwYWEyLW1hYzogdXNlIHJlc29s
dmVkIGxpbmsgY29uZmlnIGluDQo+IG1hY19saW5rX3VwKCkNCj4gDQo+IENvbnZlcnQgdGhlIERQ
QUEyIGV0aGVybmV0IGRyaXZlciB0byB1c2UgdGhlIGZpbmFsaXNlZCBsaW5rIHBhcmFtZXRlcnMg
aW4NCj4gbWFjX2xpbmtfdXAoKSByYXRoZXIgdGhhbiB0aGUgcGFyYW1ldGVycyBpbiBtYWNfY29u
ZmlnKCksIHdoaWNoIGFyZSBtb3JlDQo+IHN1aXRlZCB0byB0aGUgbmVlZHMgb2YgdGhlIERQQUEy
IE1DIGZpcm13YXJlIHRoYW4gdGhvc2UgYXZhaWxhYmxlIHZpYQ0KPiBtYWNfY29uZmlnKCkuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJtaytrZXJuZWxAYXJtbGludXgub3Jn
LnVrPg0KDQpUZXN0ZWQtYnk6IElvYW5hIENpb3JuZWkgPGlvYW5hLmNpb3JuZWlAbnhwLmNvbT4N
Cg0KPiAtLS0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLW1hYy5j
ICB8IDU0ICsrKysrKysrKysrLS0tLS0tLS0NCj4gLi4uL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZHBhYTIvZHBhYTItbWFjLmggIHwgIDEgKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAzMyBpbnNlcnRp
b25zKCspLCAyMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItbWFjLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItbWFjLmMNCj4gaW5kZXggM2E3NWM1YjU4Zjk1Li4z
ZWUyMzZjNWZjMzcgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2Fs
ZS9kcGFhMi9kcGFhMi1tYWMuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZHBhYTIvZHBhYTItbWFjLmMNCj4gQEAgLTEyMywzNSArMTIzLDE2IEBAIHN0YXRpYyB2b2lk
IGRwYWEyX21hY19jb25maWcoc3RydWN0IHBoeWxpbmtfY29uZmlnDQo+ICpjb25maWcsIHVuc2ln
bmVkIGludCBtb2RlLA0KPiAgCXN0cnVjdCBkcG1hY19saW5rX3N0YXRlICpkcG1hY19zdGF0ZSA9
ICZtYWMtPnN0YXRlOw0KPiAgCWludCBlcnI7DQo+IA0KPiAtCWlmIChzdGF0ZS0+c3BlZWQgIT0g
U1BFRURfVU5LTk9XTikNCj4gLQkJZHBtYWNfc3RhdGUtPnJhdGUgPSBzdGF0ZS0+c3BlZWQ7DQo+
IC0NCj4gLQlpZiAoc3RhdGUtPmR1cGxleCAhPSBEVVBMRVhfVU5LTk9XTikgew0KPiAtCQlpZiAo
IXN0YXRlLT5kdXBsZXgpDQo+IC0JCQlkcG1hY19zdGF0ZS0+b3B0aW9ucyB8PQ0KPiBEUE1BQ19M
SU5LX09QVF9IQUxGX0RVUExFWDsNCj4gLQkJZWxzZQ0KPiAtCQkJZHBtYWNfc3RhdGUtPm9wdGlv
bnMgJj0NCj4gfkRQTUFDX0xJTktfT1BUX0hBTEZfRFVQTEVYOw0KPiAtCX0NCj4gLQ0KPiAgCWlm
IChzdGF0ZS0+YW5fZW5hYmxlZCkNCj4gIAkJZHBtYWNfc3RhdGUtPm9wdGlvbnMgfD0gRFBNQUNf
TElOS19PUFRfQVVUT05FRzsNCj4gIAllbHNlDQo+ICAJCWRwbWFjX3N0YXRlLT5vcHRpb25zICY9
IH5EUE1BQ19MSU5LX09QVF9BVVRPTkVHOw0KPiANCj4gLQlpZiAoc3RhdGUtPnBhdXNlICYgTUxP
X1BBVVNFX1JYKQ0KPiAtCQlkcG1hY19zdGF0ZS0+b3B0aW9ucyB8PSBEUE1BQ19MSU5LX09QVF9Q
QVVTRTsNCj4gLQllbHNlDQo+IC0JCWRwbWFjX3N0YXRlLT5vcHRpb25zICY9IH5EUE1BQ19MSU5L
X09QVF9QQVVTRTsNCj4gLQ0KPiAtCWlmICghIShzdGF0ZS0+cGF1c2UgJiBNTE9fUEFVU0VfUlgp
IF4gISEoc3RhdGUtPnBhdXNlICYNCj4gTUxPX1BBVVNFX1RYKSkNCj4gLQkJZHBtYWNfc3RhdGUt
Pm9wdGlvbnMgfD0gRFBNQUNfTElOS19PUFRfQVNZTV9QQVVTRTsNCj4gLQllbHNlDQo+IC0JCWRw
bWFjX3N0YXRlLT5vcHRpb25zICY9IH5EUE1BQ19MSU5LX09QVF9BU1lNX1BBVVNFOw0KPiAtDQo+
ICAJZXJyID0gZHBtYWNfc2V0X2xpbmtfc3RhdGUobWFjLT5tY19pbywgMCwNCj4gIAkJCQkgICBt
YWMtPm1jX2Rldi0+bWNfaGFuZGxlLCBkcG1hY19zdGF0ZSk7DQo+ICAJaWYgKGVycikNCj4gLQkJ
bmV0ZGV2X2VycihtYWMtPm5ldF9kZXYsICJkcG1hY19zZXRfbGlua19zdGF0ZSgpID0gJWRcbiIs
DQo+IGVycik7DQo+ICsJCW5ldGRldl9lcnIobWFjLT5uZXRfZGV2LCAiJXM6IGRwbWFjX3NldF9s
aW5rX3N0YXRlKCkgPQ0KPiAlZFxuIiwNCj4gKwkJCSAgIF9fZnVuY19fLCBlcnIpOw0KPiAgfQ0K
PiANCj4gIHN0YXRpYyB2b2lkIGRwYWEyX21hY19saW5rX3VwKHN0cnVjdCBwaHlsaW5rX2NvbmZp
ZyAqY29uZmlnLCBAQCAtMTY1LDEwDQo+ICsxNDYsMzcgQEAgc3RhdGljIHZvaWQgZHBhYTJfbWFj
X2xpbmtfdXAoc3RydWN0IHBoeWxpbmtfY29uZmlnICpjb25maWcsDQo+ICAJaW50IGVycjsNCj4g
DQo+ICAJZHBtYWNfc3RhdGUtPnVwID0gMTsNCj4gKw0KPiArCWlmIChtYWMtPmlmX2xpbmtfdHlw
ZSA9PSBEUE1BQ19MSU5LX1RZUEVfUEhZKSB7DQo+ICsJCS8qIElmIHRoZSBEUE1BQyBpcyBjb25m
aWd1cmVkIGZvciBQSFkgbW9kZSwgd2UgbmVlZA0KPiArCQkgKiB0byBwYXNzIHRoZSBsaW5rIHBh
cmFtZXRlcnMgdG8gdGhlIE1DIGZpcm13YXJlLg0KPiArCQkgKi8NCj4gKwkJZHBtYWNfc3RhdGUt
PnJhdGUgPSBzcGVlZDsNCj4gKw0KPiArCQlpZiAoZHVwbGV4ID09IERVUExFWF9IQUxGKQ0KPiAr
CQkJZHBtYWNfc3RhdGUtPm9wdGlvbnMgfD0NCj4gRFBNQUNfTElOS19PUFRfSEFMRl9EVVBMRVg7
DQo+ICsJCWVsc2UgaWYgKGR1cGxleCA9PSBEVVBMRVhfRlVMTCkNCj4gKwkJCWRwbWFjX3N0YXRl
LT5vcHRpb25zICY9DQo+IH5EUE1BQ19MSU5LX09QVF9IQUxGX0RVUExFWDsNCj4gKw0KPiArCQkv
KiBUaGlzIGlzIGxvc3N5OyB0aGUgZmlybXdhcmUgcmVhbGx5IHNob3VsZCB0YWtlIHRoZSBwYXVz
ZQ0KPiArCQkgKiBlbmFibGVtZW50IHN0YXR1cyByYXRoZXIgdGhhbiBwYXVzZS9hc3ltIHBhdXNl
IHN0YXR1cy4NCj4gKwkJICovDQoNCkluIHdoYXQgc2Vuc2UgaXQncyBsb3NzeT8gSSBjYW5ub3Qg
c2VlIGhvdyBpbmZvcm1hdGlvbiBjYW4gYmUgbG9zdCBieSB0cmFuc2xhdGluZyB0aGUgcngvdHgg
cGF1c2Ugc3RhdGUgdG8gcGF1c2UvYXN5bS4NCklmIGl0J3MganVzdCBhYm91dCB0aGUgdW5uZWNl
c3NhcnkgZG91YmxlIHRyYW5zbGF0aW9uLCB0aGVuIEkgYWdyZWUuLiB0aGlzIGNvdWxkIGhhdmUg
YmVlbiBkb25lIGluIGFuIGVhc2llciBtYW5uZXIuDQoNCg0KPiArCQlpZiAocnhfcGF1c2UpDQo+
ICsJCQlkcG1hY19zdGF0ZS0+b3B0aW9ucyB8PSBEUE1BQ19MSU5LX09QVF9QQVVTRTsNCj4gKwkJ
ZWxzZQ0KPiArCQkJZHBtYWNfc3RhdGUtPm9wdGlvbnMgJj0gfkRQTUFDX0xJTktfT1BUX1BBVVNF
Ow0KPiArDQo+ICsJCWlmIChyeF9wYXVzZSBeIHR4X3BhdXNlKQ0KPiArCQkJZHBtYWNfc3RhdGUt
Pm9wdGlvbnMgfD0NCj4gRFBNQUNfTElOS19PUFRfQVNZTV9QQVVTRTsNCj4gKwkJZWxzZQ0KPiAr
CQkJZHBtYWNfc3RhdGUtPm9wdGlvbnMgJj0NCj4gfkRQTUFDX0xJTktfT1BUX0FTWU1fUEFVU0U7
DQo+ICsJfQ0KPiArDQo+ICAJZXJyID0gZHBtYWNfc2V0X2xpbmtfc3RhdGUobWFjLT5tY19pbywg
MCwNCj4gIAkJCQkgICBtYWMtPm1jX2Rldi0+bWNfaGFuZGxlLCBkcG1hY19zdGF0ZSk7DQo+ICAJ
aWYgKGVycikNCj4gLQkJbmV0ZGV2X2VycihtYWMtPm5ldF9kZXYsICJkcG1hY19zZXRfbGlua19z
dGF0ZSgpID0gJWRcbiIsDQo+IGVycik7DQo+ICsJCW5ldGRldl9lcnIobWFjLT5uZXRfZGV2LCAi
JXM6IGRwbWFjX3NldF9saW5rX3N0YXRlKCkgPQ0KPiAlZFxuIiwNCj4gKwkJCSAgIF9fZnVuY19f
LCBlcnIpOw0KPiAgfQ0KPiANCj4gIHN0YXRpYyB2b2lkIGRwYWEyX21hY19saW5rX2Rvd24oc3Ry
dWN0IHBoeWxpbmtfY29uZmlnICpjb25maWcsIEBAIC0yNDEsNg0KPiArMjQ5LDggQEAgaW50IGRw
YWEyX21hY19jb25uZWN0KHN0cnVjdCBkcGFhMl9tYWMgKm1hYykNCj4gIAkJZ290byBlcnJfY2xv
c2VfZHBtYWM7DQo+ICAJfQ0KPiANCj4gKwltYWMtPmlmX2xpbmtfdHlwZSA9IGF0dHIubGlua190
eXBlOw0KPiArDQo+ICAJZHBtYWNfbm9kZSA9IGRwYWEyX21hY19nZXRfbm9kZShhdHRyLmlkKTsN
Cj4gIAlpZiAoIWRwbWFjX25vZGUpIHsNCj4gIAkJbmV0ZGV2X2VycihuZXRfZGV2LCAiTm8gZHBt
YWNAJWQgbm9kZSBmb3VuZC5cbiIsIGF0dHIuaWQpOw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLW1hYy5oDQo+IGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLW1hYy5oDQo+IGluZGV4IDRkYTgwNzliOTE1
NS4uMjEzMGQ5YzdkNDBlIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZHBhYTIvZHBhYTItbWFjLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJl
ZXNjYWxlL2RwYWEyL2RwYWEyLW1hYy5oDQo+IEBAIC0yMCw2ICsyMCw3IEBAIHN0cnVjdCBkcGFh
Ml9tYWMgew0KPiAgCXN0cnVjdCBwaHlsaW5rX2NvbmZpZyBwaHlsaW5rX2NvbmZpZzsNCj4gIAlz
dHJ1Y3QgcGh5bGluayAqcGh5bGluazsNCj4gIAlwaHlfaW50ZXJmYWNlX3QgaWZfbW9kZTsNCj4g
KwllbnVtIGRwbWFjX2xpbmtfdHlwZSBpZl9saW5rX3R5cGU7DQo+ICB9Ow0KPiANCj4gIGJvb2wg
ZHBhYTJfbWFjX2lzX3R5cGVfZml4ZWQoc3RydWN0IGZzbF9tY19kZXZpY2UgKmRwbWFjX2RldiwN
Cj4gLS0NCj4gMi4yMC4xDQoNCg==
