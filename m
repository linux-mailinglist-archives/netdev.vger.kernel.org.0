Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40371D3630
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbfJKAiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:38:54 -0400
Received: from mail-eopbgr00063.outbound.protection.outlook.com ([40.107.0.63]:57314
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727557AbfJKAix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 20:38:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTZMPMYPYtpPmLBzxzs5hIZnh/YBFAdANJj4+6/RN3NiOhHES4LaKOTzhI7vtuRS6Y/2iEJoPyN9ME1o+OyKSJko/VB8DAPaRH1hQU3qlq+0HqXI5DsPXKWpYumkSeDaV39Z7RpjBAhMzVsI/3xohP7JcQEXoLFNIV+/Lj+prbtFaC5QcowLg5uz2JOs3/WGyB4Gw8X2tG41/xnUFi801larjqEddBW2jbc/sI6WY+1Z8SkJqf2BVoPBq9Objt1Osk+oon8ppxWKG4ssRndW9VD5AmE28TJTy84cw8SZ6ega38v4gPDRocbqMl5+UlYHTvjTsG8yIBlv72H95bycfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wC0vrRZO0f3tcGy03obFAMVg5Tr/vNAVWSkjsa0KwU=;
 b=O6P4cqF12nqlnRZYmhZnnlRYOkyPsc0O5mvwnNo69NLmborRcAdl4O1K3sm8Q6CM7ChUEni84iPcac/6tnRcdavXWSkCVy8suR37ng7vjsopcjVfgStOmATkEFaIjeHRvpT8ddayVxj9BvteyxKraNQDnquIDrFAV6TMUPn9VYhlWj+EZI1VSxU2Kl9vqikzqWPA0BQVGbvZ+NN5g8IExjrP4z+mchys1+mg+6wJmszAA28rC4CZEmv6seAzZ/+bQFk4wzF7cAp7OjMTb0gks45SGomWQyCozBnUliUhvKWuh6JIHDXzzBj/eMJkvnJClpdvkT9ZBaSz5NKqQ+lT9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wC0vrRZO0f3tcGy03obFAMVg5Tr/vNAVWSkjsa0KwU=;
 b=Pgn31yRg1zm2K8It8vk4OCEx0M8ZCW5rmBV+zSE27XlX5VOcSX0tiQxanmSlVvQLERs4sjHtyPdJ2XlL+dM5KkXgjLR0VbAs4mopkeXUoqz3dX1Omnpa/OYTnGDJLREwOJD4MXPixTVPHsUSxKTbkCxKN4/bZnEr7GvjC/lBywY=
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com (52.134.72.18) by
 DB3PR0402MB3692.eurprd04.prod.outlook.com (52.134.65.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 11 Oct 2019 00:38:50 +0000
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0]) by DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0%6]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 00:38:50 +0000
From:   Anson Huang <anson.huang@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional()
 to avoid error message
Thread-Topic: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Thread-Index: AQHVforZimETp53I4UOLcQPYAMVf3qdUghaAgAAN4TCAAAnBAIAAAP3Q
Date:   Fri, 11 Oct 2019 00:38:50 +0000
Message-ID: <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
        <20191010160811.7775c819@cakuba.netronome.com>
        <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <20191010173246.2cd02164@cakuba.netronome.com>
In-Reply-To: <20191010173246.2cd02164@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=anson.huang@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dedfd8ee-ffb4-48c5-963b-08d74de362d0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB3PR0402MB3692:|DB3PR0402MB3692:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3692D527E5943E0C7553520AF5970@DB3PR0402MB3692.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(136003)(396003)(39850400004)(189003)(199004)(55016002)(6246003)(7736002)(446003)(44832011)(229853002)(81166006)(8936002)(8676002)(81156014)(11346002)(15650500001)(86362001)(476003)(6436002)(9686003)(25786009)(486006)(305945005)(74316002)(4326008)(66556008)(66476007)(64756008)(76116006)(66946007)(99286004)(186003)(66446008)(66066001)(478600001)(2906002)(5660300002)(14454004)(316002)(256004)(14444005)(52536014)(26005)(3846002)(76176011)(71200400001)(102836004)(6506007)(6116002)(7696005)(33656002)(71190400001)(54906003)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR0402MB3692;H:DB3PR0402MB3916.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yi6zOS7WzViUuSiTpXXtQ1l/wmmF8CkC5HesGsfXgZJpcbBxf73X6RpK1eNygYwFUZ1zhUgjffNzweyvFsQvciUxyTLCBk4/4dobh4yJu42hptya9dCDMpn6I3Rzq59dOpMafS7qrAAnW++k/t7gZdfgMHb3M7LmawM3hLXglZQWsR55yQ2ULDwj0Y/6xuynNSISgPifKsHQusk1L+tX5NmCe6CXCHwu9Fx87jsfVhcQe5voxEeat+qEcBOVH7LdXiR4ZxiuNSuFgXJtdlJ9JT8J+RJGI8UzIAJF3EdnRd2LsKlyutaZxje+klrm3a50Nfjz/a3g5SPthDhNxdHyMvKiQ2bNfRAkOuSi4hAKGYC73NJcJ+qracy/9s1NmQtDIpYmNb901TqToLNDBp+5ja6FOaxCu/m0egs8p+Kue/Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedfd8ee-ffb4-48c5-963b-08d74de362d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 00:38:50.6197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yN2gelHDuj/B2I1tZOn0xXlDsGCmD9GzqaT4jkNQoCjt0hyt3ANkMkW61i6SqVOsxn9jp0GEKlV0yhicWjFw6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3692
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIEpha3ViDQoNCj4gT24gRnJpLCAxMSBPY3QgMjAxOSAwMDowMzoyMiArMDAwMCwgQW5zb24g
SHVhbmcgd3JvdGU6DQo+ID4gPiBPbiBXZWQsICA5IE9jdCAyMDE5IDE4OjE1OjQ3ICswODAwLCBB
bnNvbiBIdWFuZyB3cm90ZToNCj4gPiA+ID4gRmFpbGVkIHRvIGdldCBpcnEgdXNpbmcgbmFtZSBp
cyBOT1QgZmF0YWwgYXMgZHJpdmVyIHdpbGwgdXNlIGluZGV4DQo+ID4gPiA+IHRvIGdldCBpcnEg
aW5zdGVhZCwgdXNlIHBsYXRmb3JtX2dldF9pcnFfYnluYW1lX29wdGlvbmFsKCkgaW5zdGVhZA0K
PiA+ID4gPiBvZg0KPiA+ID4gPiBwbGF0Zm9ybV9nZXRfaXJxX2J5bmFtZSgpIHRvIGF2b2lkIGJl
bG93IGVycm9yIG1lc3NhZ2UgZHVyaW5nDQo+ID4gPiA+IHByb2JlOg0KPiA+ID4gPg0KPiA+ID4g
PiBbICAgIDAuODE5MzEyXSBmZWMgMzBiZTAwMDAuZXRoZXJuZXQ6IElSUSBpbnQwIG5vdCBmb3Vu
ZA0KPiA+ID4gPiBbICAgIDAuODI0NDMzXSBmZWMgMzBiZTAwMDAuZXRoZXJuZXQ6IElSUSBpbnQx
IG5vdCBmb3VuZA0KPiA+ID4gPiBbICAgIDAuODI5NTM5XSBmZWMgMzBiZTAwMDAuZXRoZXJuZXQ6
IElSUSBpbnQyIG5vdCBmb3VuZA0KPiA+ID4gPg0KPiA+ID4gPiBGaXhlczogNzcyM2Y0YzVlY2Ri
ICgiZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBBZGQgYW4gZXJyb3IgbWVzc2FnZQ0KPiA+ID4gPiB0
bw0KPiA+ID4gPiBwbGF0Zm9ybV9nZXRfaXJxKigpIikNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
QW5zb24gSHVhbmcgPEFuc29uLkh1YW5nQG54cC5jb20+DQo+ID4gPg0KPiA+ID4gSGkgQW5zb24s
DQo+ID4gPg0KPiA+ID4gbG9va3MgbGlrZSB0aGVyZSBtYXkgYmUgc29tZSBkZXBlbmRlbmN5IHdo
aWNoIGhhdmVuJ3QgbGFuZGVkIGluIHRoZQ0KPiA+ID4gbmV0d29ya2luZyB0cmVlIHlldD8gIEJl
Y2F1c2UgdGhpcyBkb2Vzbid0IGJ1aWxkOg0KPiA+ID4NCj4gPiA+IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jOiBJbiBmdW5jdGlvbiDigJhmZWNfcHJvYmXigJk6DQo+
ID4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYzozNTYxOjk6IGVy
cm9yOiBpbXBsaWNpdA0KPiA+ID4gZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24g4oCYcGxhdGZvcm1f
Z2V0X2lycV9ieW5hbWVfb3B0aW9uYWzigJk7IGRpZCB5b3UNCj4gPiA+IG1lYW4g4oCYcGxhdGZv
cm1fZ2V0X2lycV9vcHRpb25hbOKAmT8gWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tDQo+IGRl
Y2xhcmF0aW9uXQ0KPiA+ID4gIDM1NjEgfCAgIGlycSA9IHBsYXRmb3JtX2dldF9pcnFfYnluYW1l
X29wdGlvbmFsKHBkZXYsIGlycV9uYW1lKTsNCj4gPiA+ICAgICAgIHwgICAgICAgICBefn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiA+ID4gICAgICAgfCAgICAgICAgIHBsYXRmb3Jt
X2dldF9pcnFfb3B0aW9uYWwNCj4gPiA+IGNjMTogc29tZSB3YXJuaW5ncyBiZWluZyB0cmVhdGVk
IGFzIGVycm9ycw0KPiA+ID4NCj4gPiA+IENvdWxkIHlvdSBwbGVhc2UgcmVwb3N0IG9uY2UgdGhh
dCdzIHJlc29sdmVkPyAgUGxlYXNlIGFkZCBBbmR5J3MgYW5kDQo+ID4gPiBTdGVwaGVuJ3MgYWNr
cyB3aGVuIHJlcG9zdGluZy4NCj4gPiA+DQo+ID4gPiBUaGFuayB5b3UhDQo+ID4NCj4gPiBTb3Jy
eSwgSSBkaWQgdGhpcyBwYXRjaCBzZXQgYmFzZWQgb24gbGludXgtbmV4dCB0cmVlLCB0aGUgYmVs
b3cgcGF0Y2gNCj4gPiBpcyBsYW5kaW5nIG9uIExpbnV4LW5leHQgdHJlZSBvbiBPY3QgNXRoLCBz
byBtYXliZSBuZXR3b3JrIHRyZWUgaXMgTk9UIHN5bmMNCj4gd2l0aCBMaW51eC1uZXh0IHRyZWU/
DQo+IA0KPiBsaW51eC1uZXh0IGlzIGFuIGludGVncmF0aW9uIHRyZWUsIHdoaWNoIG1lcmdlcyBh
bGwgZGV2ZWxvcG1lbnQgdHJlZXMNCj4gdG9nZXRoZXIgdG8gaGVscCB3aXRoIGNvbmZsaWN0IHJl
c29sdXRpb24uIFN1YnN5c3RlbSBtYWludGFpbmVycyBuZXZlciBwdWxsDQo+IGZyb20gaXQuDQo+
IA0KPiA+IEkgc2F3IG1hbnkgb3RoZXIgc2ltaWxhciBwYXRjaGVzIGFyZSBhbHJlYWR5IGxhbmRp
bmcgb24gTGludXgtbmV4dA0KPiA+IHRyZWUgYWxzbywgc28gd2hhdCBkbyB5b3Ugc3VnZ2VzdCBJ
IHNob3VsZCBkbz8gT3IgY2FuIHlvdSBzeW5jIHRoZQ0KPiA+IG5ldHdvcmsgdHJlZSB3aXRoIExp
bnV4LW5leHQgdHJlZSBmaXJzdD8gSSBkbyBOT1Qga25vdyB0aGUgcnVsZS9zY2hlZHVsZSBvZg0K
PiBuZXR3b3JrIHRyZWUgdXBkYXRlIHRvIExpbnV4LW5leHQuDQo+ID4NCj4gPiBjb21taXQgZjFk
YTU2N2YxZGMxYjU1ZDE3OGI4ZjJkMGNmZTgzNTM4NThhYWMxOQ0KPiA+IEF1dGhvcjogSGFucyBk
ZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT4NCj4gPiBEYXRlOiAgIFNhdCBPY3QgNSAyMzow
NDo0NyAyMDE5ICswMjAwDQo+ID4NCj4gPiAgICAgZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBBZGQg
cGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0aW9uYWwoKQ0KPiANCj4gSG0uIExvb2tzIGxpa2Ug
dGhlIGNvbW1pdCB5b3UgbmVlZCBpcyBjb21taXQgZjFkYTU2N2YxZGMxICgiZHJpdmVyIGNvcmU6
DQo+IHBsYXRmb3JtOiBBZGQgcGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0aW9uYWwoKSIpIGFu
ZCBpdCdzIGN1cnJlbnRseSBpbg0KPiBHcmVnJ3MgdHJlZS4gWW91IGhhdmUgdG8gd2FpdCBmb3Ig
dGhhdCBjb21taXQgdG8gbWFrZSBpdHMgd2F5IGludG8gTGludXMnZXMNCj4gbWFpbiB0cmVlIGFu
ZCB0aGVuIGZvciBEYXZlIE1pbGxlciB0byBwdWxsIGZyb20gTGludXMuDQo+IA0KPiBJJ2Qgc3Vn
Z2VzdCB5b3UgY2hlY2sgaWYgeW91ciBwYXRjaGVzIGJ1aWxkcyBvbiB0aGUgbmV0IHRyZWU6DQo+
IA0KPiAgIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9uZXRk
ZXYvbmV0LmdpdA0KPiANCj4gb25jZSBhIHdlZWsuIE15IGd1ZXNzIGlzIGl0J2xsIHByb2JhYmx5
IHRha2UgdHdvIHdlZWtzIG9yIHNvIGZvciBHcmVnJ3MNCj4gcGF0Y2hlcyB0byBwcm9wYWdhdGUg
dG8gRGF2ZS4NCg0KVGhhbmtzIGZvciBleHBsYW5hdGlvbiBvZiBob3cgdGhlc2UgdHJlZXMgd29y
aywgc28gY291bGQgeW91IHBsZWFzZSB3YWl0IHRoZSBuZWNlc3NhcnkNCnBhdGNoIGxhbmRpbmcg
b24gbmV0d29yayB0cmVlIHRoZW4gYXBwbHkgdGhpcyBwYXRjaCBzZXJpZXMsIHRoYW5rcyBmb3Ig
aGVscC4NCg0KQW5zb24uDQo=
