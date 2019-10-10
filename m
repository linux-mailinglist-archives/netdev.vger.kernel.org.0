Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF43D2B7C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbfJJNhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 09:37:42 -0400
Received: from mail-eopbgr1400092.outbound.protection.outlook.com ([40.107.140.92]:51904
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728393AbfJJNhm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 09:37:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bg5+WQ1SSS+7tMmETgTXVIzjb2/8b0i7m5RKjUXswrmxEGbv/esN0ZV+6aesGJGaaNjxtPIAFe+huSjJviYDGSNSWZ1EugQwge8mTrzFaXC6/XCEj/RgCM91z1PFADHKPU8GtF/CFb0nj6UQmYxWIUTIxWBUnPYCPK5vzOw7oH4lDfk4I5H35HsqlDFoW7hefDc5N/vyoQmJdR7k1ZSMNydBvIyFSgj4IpJ39XaRWE7Nz03Hz72p8gvtKjVKEyDC2xXAC6ySSsoJT1os0HAKiDsCZiI+6ICoWE6po4qqzCg4NbOXBwpE8sQYPUOXI15yw6eXd4Ewxk8WERkOgTkv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZT8oEWdY3BF97DHylgR8GkgHd4MXorQEq6q+Nnu7hkc=;
 b=CEcNxjgokL8BtfX2hojGuRNE9cUs5yr0laaKKJG/LdU6v6XgVnBiSVOcscMyk/CxHuXMqfeh8zOd+sT3giObGhfjBv8e0UmAm9FTwkKzGvsRemb8Yq3ekZbE3Kf/6yy6gE3iHajZ8d8gKVUmeql1/0GWUOwSe6zdEcqW2a+IdUdwlue9cTH2kOTqyRxDjZbFTJF3ye0ws54CLVB/KgG4sX/JHlTxVHIG1MeROhEY/O05pxVz3aJ/7a2Olg8fwXL5tZwGjLTFlhN39uXCTbY2Rw9ofP1Ru/GpGa1kKpBRhz5OcABhdyYh2goLZxQoAmN+2iXpRXYRv7ptEUk4cgX0Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZT8oEWdY3BF97DHylgR8GkgHd4MXorQEq6q+Nnu7hkc=;
 b=APtFsSq4zOJx2qQrkJDLeE+bJHYenp22HlqUUwz6mTFgXx6CBf9SjG2naUxGIo+xeboderqpbfuK9qcJ7BPubrKdtX2g8+WsHrbo09ro07tPpPbJbjK1ZxEw+JcZfNgTpDNhEsPMelKtU9K+MNAvUFMJEcn5YIWnx3SOCnqMwF8=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.13) by
 TY1PR01MB1833.jpnprd01.prod.outlook.com (52.133.163.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Thu, 10 Oct 2019 13:37:38 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::55fe:d020:cc51:95c4]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::55fe:d020:cc51:95c4%7]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 13:37:37 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Subject: RE: [PATCH net-next 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
Thread-Topic: [PATCH net-next 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
Thread-Index: AQHVf2eHe5M8eoW8NUej/XOaiYSJ3qdT0q0AgAAMOHA=
Date:   Thu, 10 Oct 2019 13:37:36 +0000
Message-ID: <TY1PR01MB177051B4DCAD29E5D4954F11C0940@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1570711049-5691-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570711049-5691-3-git-send-email-fabrizio.castro@bp.renesas.com>
 <CAMuHMdV5XUPSrgoDm62p0f_B1TtvhMyOX3NVho=QVqdesq31jg@mail.gmail.com>
In-Reply-To: <CAMuHMdV5XUPSrgoDm62p0f_B1TtvhMyOX3NVho=QVqdesq31jg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22aa36b8-a6b7-4967-371b-08d74d87039d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: TY1PR01MB1833:|TY1PR01MB1833:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TY1PR01MB18331B48A04AE7D7696A1FEBC0940@TY1PR01MB1833.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(6506007)(53546011)(7736002)(66476007)(305945005)(7696005)(26005)(102836004)(256004)(52536014)(99286004)(74316002)(81156014)(66556008)(8936002)(81166006)(186003)(76176011)(66446008)(66946007)(8676002)(64756008)(76116006)(4326008)(7416002)(229853002)(14454004)(316002)(33656002)(6246003)(44832011)(71190400001)(5660300002)(71200400001)(86362001)(6436002)(54906003)(6916009)(3846002)(6116002)(9686003)(476003)(486006)(2906002)(25786009)(66066001)(446003)(11346002)(55016002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1833;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1LlDR4IE+9u3nirLZ9e2pPYTCnHysbhFglIJew7yiK5KCRsHlQrT7d9DRaAXiybYICTT30IjIcva3wS48m7Hatt3a/SeoHM3cOP7otGMFtY1ynxsxtuiZHh/AmKHiH9PnNSfo9AlZvRTO0fx+09QUkMu5Q1dDiRhnVHECmExpfGFoYkxNer+4GBB4cBQ+11GbimTGxP95xV25qQ9yYBy9XHOz0uSAwCcbm4qm3FAZ9Ggo5FXLjvkwp5WQ22UErJIqgT0VF4wq8l2YpKiYXBczrSIcsrgE+vC5huXQW2b63HtD6MWKJl15C53hSU0wSv8c8bBfJpn/rxBcYINlHY+ji1ML07qharzqheXRkq4LffTAd/HvWlhLpkx1vDeJuzH0PPJnKbJ9fDWy/xFs+nMXoD89tHrmOZ4meOx8jRAMJI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22aa36b8-a6b7-4967-371b-08d74d87039d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 13:37:36.7965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QvwizLohb1Q7NX/7I5UNGNKdhD2ifRT01XeQrbGVznu5nmQ80b9uynhNyQQU4sFxvdrjC1NQbCbgQsvmTArjoUxrC8fmktvDUGxusFFqYHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1833
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rIHlvdSBmb3IgeW91ciBmZWVkYmFjayENCg0KPiBGcm9tOiBHZWVy
dCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3JnPg0KPiBTZW50OiAxMCBPY3RvYmVy
IDIwMTkgMTM6NDcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCAyLzNdIGR0LWJpbmRp
bmdzOiBjYW46IHJjYXJfY2FuZmQ6IGRvY3VtZW50IHI4YTc3NGIxIHN1cHBvcnQNCj4gDQo+IEhp
IEZhYnJpemlvLA0KPiANCj4gT24gVGh1LCBPY3QgMTAsIDIwMTkgYXQgMjozNyBQTSBGYWJyaXpp
byBDYXN0cm8NCj4gPGZhYnJpemlvLmNhc3Ryb0BicC5yZW5lc2FzLmNvbT4gd3JvdGU6DQo+ID4g
RG9jdW1lbnQgdGhlIHN1cHBvcnQgZm9yIHJjYXJfY2FuZmQgb24gUjhBNzc0QjEgU29DIGRldmlj
ZXMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBGYWJyaXppbyBDYXN0cm8gPGZhYnJpemlvLmNh
c3Ryb0BicC5yZW5lc2FzLmNvbT4NCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBwYXRjaCENCj4gDQo+
ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9jYW4vcmNhcl9j
YW5mZC50eHQNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0
L2Nhbi9yY2FyX2NhbmZkLnR4dA0KPiA+IEBAIC01LDYgKzUsNyBAQCBSZXF1aXJlZCBwcm9wZXJ0
aWVzOg0KPiA+ICAtIGNvbXBhdGlibGU6IE11c3QgY29udGFpbiBvbmUgb3IgbW9yZSBvZiB0aGUg
Zm9sbG93aW5nOg0KPiA+ICAgIC0gInJlbmVzYXMscmNhci1nZW4zLWNhbmZkIiBmb3IgUi1DYXIg
R2VuMyBhbmQgUlovRzIgY29tcGF0aWJsZSBjb250cm9sbGVycy4NCj4gPiAgICAtICJyZW5lc2Fz
LHI4YTc3NGExLWNhbmZkIiBmb3IgUjhBNzc0QTEgKFJaL0cyTSkgY29tcGF0aWJsZSBjb250cm9s
bGVyLg0KPiA+ICsgIC0gInJlbmVzYXMscjhhNzc0YjEtY2FuZmQiIGZvciBSOEE3NzRCMSAoUlov
RzJOKSBjb21wYXRpYmxlIGNvbnRyb2xsZXIuDQo+ID4gICAgLSAicmVuZXNhcyxyOGE3NzRjMC1j
YW5mZCIgZm9yIFI4QTc3NEMwIChSWi9HMkUpIGNvbXBhdGlibGUgY29udHJvbGxlci4NCj4gPiAg
ICAtICJyZW5lc2FzLHI4YTc3OTUtY2FuZmQiIGZvciBSOEE3Nzk1IChSLUNhciBIMykgY29tcGF0
aWJsZSBjb250cm9sbGVyLg0KPiA+ICAgIC0gInJlbmVzYXMscjhhNzc5Ni1jYW5mZCIgZm9yIFI4
QTc3OTYgKFItQ2FyIE0zLVcpIGNvbXBhdGlibGUgY29udHJvbGxlci4NCj4gDQo+IFRoZSBhYm92
ZSBsb29rcyBnb29kLCBidXQgSSB0aGluayB5b3UgZm9yZ290IHRvIGFkZCBSOEE3NzRCMSB0byB0
aGUNCj4gcGFyYWdyYXBoIHRhbGtpbmcgYWJvdXQgdGhlIENBTiBGRCBjbG9jayBiZWxvdy4NCg0K
SSBtb3N0IGNlcnRhaW5seSBkaWQgZm9yZ2V0IHRvIGFkZCB0aGUgUjhBNzc0QjEgdG8gdGhlIENB
TiBGRCBjbG9jayBwYXJhZ3JhcGguDQpUaGFuayB5b3UgZm9yIHBvaW50aW5nIHRoaXMgb3V0LCB3
aWxsIHNlbmQgYSB2Mi4NCg0KPiBXaXRoIHRoYXQgZml4ZWQ6DQo+IFJldmlld2VkLWJ5OiBHZWVy
dCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPg0KPiANCj4gV2hpbGUgYXQg
aXQsIHRoZSBleGFtcGxlIGluIHRoZSBiaW5kaW5ncyBzYXlzIHRoZSBDQU5GRCBjbG9jayBzaG91
bGQgYmUNCj4gY29uZmlndXJlZCB0byA0MCBNSHosIHdoaWNoIG1hdGNoZXMgd2hhdCBpcyB1c2Vk
IGluIHRoZSB2YXJpb3VzIERUUyBmaWxlcy4NCj4gSG93ZXZlciwgdGhlIEhhcmR3YXJlIFVzZXIn
cyBNYW51YWwgc3RhdGVzIGl0IHNob3VsZCBiZSA4MCBNSHosIGV4Y2VwdA0KPiBmb3IgUi1DYXIg
RDMuDQo+IElzIHRoYXQgY29ycmVjdD8NCg0KVGhlIG1hbnVhbCBzdGF0ZXMgODAgTUh6LCBhbmQg
SSBkaWQgdGVzdCB0aGUgSVAgaW4gQ0FOIGFuZCBDQU4gRkQgbW9kZSBhdCA4MCBNSHoNCmEgd2hp
bGUgYmFjaywgYnV0IFJhbWVzaCByZXBvcnRlZCBzb21lIGluc3RhYmlsaXR5IGF0IDgwIE1IeiB3
aGVuIGhlIGZpcnN0IGJyb3VnaHQNCkNBTiBGRCB1cC4gV2UgZG9uJ3Qga25vdyBpZiB0aGUgaW5z
dGFiaWxpdHkgd2FzIGR1ZSB0byB0aGUgSVAgb3IgdG8gdGhlIGJvYXJkIGhlIHdhcw0KdXNpbmcs
IGF0IHNvbWUgcG9pbnQgaXQgd291bGQgYmUgbmljZSB0byByZXRlc3QgdGhlIHNhbWUgdGhpbmcg
b24gYSBkaWZmZXJlbnQgU29DL2JvYXJkDQpjb25uZWN0ZWQgdG8gdGhlIHNhbWUgcGVyaXBoZXJh
bCBoZSB3YXMgdXNpbmcgZm9yIHRlc3RpbmcsIGFuZCBzZWUgaWYgd2UgZ2V0IHRoZSBzYW1lDQpp
c3N1ZXMuIEZvciB0aGUgdGltZSBiZWluZywgdG8gYmUgb24gdGhlIHNhZmUgc2lkZSBvZiB0aGlu
Z3MsIHdlIHdvdWxkIGxpa2UgdG8ga2VlcCB0aGUNCmNsb2NrIGNvbmZpZ3VyZWQgYXQgNDBNSHou
DQoNClRoYW5rcywNCkZhYg0KDQo+IA0KPiBUaGFua3MhDQo+IA0KPiBHcntvZXRqZSxlZXRpbmd9
cywNCj4gDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIEdlZXJ0DQo+IA0KPiAtLQ0KPiBHZWVy
dCBVeXR0ZXJob2V2ZW4gLS0gVGhlcmUncyBsb3RzIG9mIExpbnV4IGJleW9uZCBpYTMyIC0tIGdl
ZXJ0QGxpbnV4LW02OGsub3JnDQo+IA0KPiBJbiBwZXJzb25hbCBjb252ZXJzYXRpb25zIHdpdGgg
dGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4gQnV0DQo+IHdoZW4gSSdt
IHRhbGtpbmcgdG8gam91cm5hbGlzdHMgSSBqdXN0IHNheSAicHJvZ3JhbW1lciIgb3Igc29tZXRo
aW5nIGxpa2UgdGhhdC4NCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAtLSBMaW51
cyBUb3J2YWxkcw0K
