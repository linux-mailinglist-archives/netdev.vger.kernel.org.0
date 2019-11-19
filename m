Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DBC102601
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfKSOJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:09:37 -0500
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:24655
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727763AbfKSOJh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 09:09:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YffEX7w6turTYLU06UaI2lkWAOfLCWqZs8pxtAktJQ9Tqw3j8fTsN+eA93ek7UQ2dee7ZZtn7hNl4qde6Mt5gE+0RF/0LpJbsn95rukdW/XntlKkxUV1yZBYunzK73aeorW6r6BFUkuTEc8IEd6M2mbZUlCxkQf90sXMD9ghyPd8lobwLEerqFgn00PpXiznZp9xoOtSP3CYMl/votlHIYP2fDy+PbJ4sPMnAYfhxL3hUdTR3euKcSMw5aFkMaxWyKgCmU7yP2YFVuVtNvoQiTAkCgQWmBdJTckDszE1vidqb1OgOCJRJ2I5bAJdU1fA27BIBrsWeWH4L+7jw5AEFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zfr4Lbzrl5AIdj1VBAanovp/87Zj4CE934jajYhuYk8=;
 b=No20EHcQmtWGJZITOopezf2TMGdR+KJfCOfkSNlVQ3cB03HF64KtcjctnCEwgDwlzSLwl5SeAbxIIrTDoIw2ZMz8ueqx5IJZGgOoi2KbSr5qJnlYYCYD8n8lG9G9+VAtiDFZvcQTjyy02JJ4TSxa1z+I01Ps2cYQM1yiNGJaewgbdbXup1yTbY/G+rAY/zRuWUSiEhNFQBJsLAMAP10fFC7VT24j82ftlrN+6vXjOX8RGJZ1jyaUjjk01MGqpXtpq5CY9eh+htp6uwCyDCO7DnTc4M0v6+7/DP4KfiScA1ahC9v70xM1gvsfBU9GRGyBnHwMCL3wAIoZjGTh+2E5dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zfr4Lbzrl5AIdj1VBAanovp/87Zj4CE934jajYhuYk8=;
 b=HB+1Up9x7EqLbFXU+/9OGILTKmRM8MWrvn8iq6yIJ8xY1/X3l+dxAU7JF93ULD1Cwmy1w979S2cCvV6mLeaxVX7DUEAZvEfaqKgkXBMjw91B/nYqRvXli5/U18uz5j31TPYLBKvtyxjl03y6EgWpYjlgw/2MTv4aadD32wudtTk=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.19.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Tue, 19 Nov 2019 14:09:31 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2451.031; Tue, 19 Nov
 2019 14:09:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        David Miller <davem@davemloft.net>
CC:     "hch@lst.de" <hch@lst.de>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Roy Pledge <roy.pledge@nxp.com>
Subject: RE: [PATCH v3 0/4] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Topic: [PATCH v3 0/4] dma-mapping: introduce new dma unmap and sync
 variants
Thread-Index: AQHVmh1EAM9HSxnkaEm+5zOWq0YV/qeJiNoAgAD7/oCACAud0A==
Date:   Tue, 19 Nov 2019 14:09:30 +0000
Message-ID: <VI1PR0402MB280097A09BC2CF202EF3004EE04C0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20191113122407.1171-1-laurentiu.tudor@nxp.com>
 <20191113.121132.1658930697082028145.davem@davemloft.net>
 <81b6e75b-a827-32e2-77bd-50220ddd66cc@nxp.com>
In-Reply-To: <81b6e75b-a827-32e2-77bd-50220ddd66cc@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac3f5fab-a51e-48c0-0246-08d76cfa18ea
x-ms-traffictypediagnostic: VI1PR0402MB3677:|VI1PR0402MB3677:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB367759DCB0492337A81A6006E04C0@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 022649CC2C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(199004)(189003)(25786009)(7696005)(76116006)(64756008)(66476007)(6506007)(26005)(66446008)(66556008)(66946007)(4326008)(76176011)(5660300002)(53546011)(52536014)(86362001)(110136005)(54906003)(14444005)(256004)(2906002)(8936002)(102836004)(8676002)(99286004)(74316002)(478600001)(229853002)(446003)(476003)(55016002)(81156014)(33656002)(11346002)(71200400001)(14454004)(71190400001)(7736002)(186003)(81166006)(6436002)(9686003)(6116002)(44832011)(486006)(6246003)(3846002)(316002)(66066001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: puEtLq3ZEuUiZGIccjiKydi5LSDg89/Qapl9qFXliP05zpcZ5WmLoBkAkcBzR0GC21ZVPvHeb/pRo9XVQquaacLErUWKqVK3tSnZEtocxH5UH6jqwrcXhyLpDziI16EvOCTNp5+O13v4adtb1fYXTW5lZDnybqoDTahQ3npMem2EzkbPTiePUx17IJmc8T8Zdc5Og1V2ANbyvhzeflnU+j5sKY/S90Is2TrXCJsYwFFpFRCikE+s6BK20RTuDO4fO78GL8OllTsPh1X27h5ODPq78gaygjb5c3MLmwCMXnJq9pQHOZUbORHWiLvYlWcBMY22/i0B+u6u1cSiTRz3uIg777hByfUaNz7L0TGzPMOa8eTPpIZmMid6ECQ1hU2RjWcWMH/ypS1YPiCQIzpnlRG0W3EA62KN/rj1RN5P5es/jAsHPCSeY7a7CmFdBc1Q
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac3f5fab-a51e-48c0-0246-08d76cfa18ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2019 14:09:31.1187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyaBOACnGYcnbir31FFj9PHCYr40qDMwxS/IrxIAJ7DGEpOMlL0UpsksMdEc91i+sVIRXycR67wZTc8P4oymvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBSZTogW1BBVENIIHYzIDAvNF0gZG1hLW1hcHBpbmc6IGludHJvZHVjZSBuZXcg
ZG1hIHVubWFwIGFuZCBzeW5jDQo+IHZhcmlhbnRzDQo+IA0KPiBPbiAxMy4xMS4yMDE5IDIyOjEx
LCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+ID4gRnJvbTogTGF1cmVudGl1IFR1ZG9yIDxsYXVyZW50
aXUudHVkb3JAbnhwLmNvbT4NCj4gPiBEYXRlOiBXZWQsIDEzIE5vdiAyMDE5IDEyOjI0OjE3ICsw
MDAwDQo+ID4NCj4gPj4gRnJvbTogTGF1cmVudGl1IFR1ZG9yIDxsYXVyZW50aXUudHVkb3JAbnhw
LmNvbT4NCj4gPj4NCj4gPj4gVGhpcyBzZXJpZXMgaW50cm9kdWNlcyBhIGZldyBuZXcgZG1hIHVu
bWFwIGFuZCBzeW5jIGFwaSB2YXJpYW50cw0KPiA+PiB0aGF0LCBvbiB0b3Agb2Ygd2hhdCB0aGUg
b3JpZ2luYWxzIGRvLCByZXR1cm4gdGhlIHZpcnR1YWwgYWRkcmVzcw0KPiA+PiBjb3JyZXNwb25k
aW5nIHRvIHRoZSBpbnB1dCBkbWEgYWRkcmVzcy4gSW4gb3JkZXIgdG8gZG8gdGhhdCBhIG5ldyBk
bWENCj4gPj4gbWFwIG9wIGlzIGFkZGVkLCAuZ2V0X3ZpcnRfYWRkciB0aGF0IHRha2VzIHRoZSBp
bnB1dCBkbWEgYWRkcmVzcyBhbmQNCj4gPj4gcmV0dXJucyB0aGUgdmlydHVhbCBhZGRyZXNzIGJh
Y2tpbmcgaXQgdXAuDQo+ID4+IFRoZSBzZWNvbmQgcGF0Y2ggYWRkcyBhbiBpbXBsZW1lbnRhdGlv
biBmb3IgdGhpcyBuZXcgZG1hIG1hcCBvcCBpbg0KPiA+PiB0aGUgZ2VuZXJpYyBpb21tdSBkbWEg
Z2x1ZSBjb2RlIGFuZCB3aXJlcyBpdCBpbi4NCj4gPj4gVGhlIHRoaXJkIHBhdGNoIHVwZGF0ZXMg
dGhlIGRwYWEyLWV0aCBkcml2ZXIgdG8gdXNlIHRoZSBuZXcgYXBpcy4NCj4gPg0KPiA+IFRoZSBk
cml2ZXIgc2hvdWxkIHN0b3JlIHRoZSBtYXBwaW5nIGluIGl0J3MgcHJpdmF0ZSBzb2Z0d2FyZSBz
dGF0ZSBpZg0KPiA+IGl0IG5lZWRzIHRoaXMga2luZCBvZiBjb252ZXJzaW9uLg0KPiANCj4gT24g
dGhpcyBoYXJkd2FyZSB0aGVyZSdzIG5vIHdheSBvZiBjb252ZXlpbmcgYWRkaXRpb25hbCBmcmFt
ZSBpbmZvcm1hdGlvbiwNCj4gc3VjaCBhcyBvcmlnaW5hbCB2YS9wYSBiZWhpbmQgdGhlIGRtYSBh
ZGRyZXNzLiBXZSBoYXZlIGFsc28gcG9uZGVyZWQgb24gdGhlDQo+IGlkZWEgb2Yga2VlcGluZyB0
aGlzIGluIHNvbWUga2luZCBvZiBkYXRhIHN0cnVjdHVyZSBidXQgY291bGQgbm90IGZpbmQgYSBs
b2NrLWxlc3MNCj4gc29sdXRpb24gd2hpY2ggb2J2aW91c2x5IHdvdWxkIGJyaW5nIHBlcmZvcm1h
bmNlIHRvIHRoZSBncm91bmQuDQo+IEknbGwgbGV0IG15IGNvbGxlYWd1ZXMgbWFpbnRhaW5pbmcg
dGhlc2UgZXRoZXJuZXQgZHJpdmVycyB0byBnZXQgaW50byBtb3JlIGRldGFpbHMsDQo+IGlmIHJl
cXVpcmVkLg0KPiANCg0KQXMgTGF1cmVudGl1IHBvaW50ZWQgb3V0IGJlZm9yZSwga2VlcGluZyBh
IG1hcHBpbmcgaW4gdGhlIGRyaXZlcidzIHByaXZhdGUgZGF0YSBkb2Vzbid0DQpzZWVtIGZlYXNp
YmxlIHdpdGhvdXQgYSBsb2NraW5nIG1lY2hhbmlzbSB3aGljaCBpbiB0dXJuIHdvdWxkIGJlIGFu
IGltbWVuc2UgaW1wYWN0DQpwZXJmb3JtYW5jZSB3aXNlLg0KDQpXZSBhbHNvIGZlZWwgdGhhdCBp
bnN0ZWFkIG9mIGhhY2tpbmcgb3VyIGluZGl2aWR1YWwgZHJpdmVycyB3ZSBzaG91bGQgZXh0ZW5k
IHRoZQ0KY29yZSBETUEgQVBJIHRvIGFsc28gZml0IHRoaXMgdXNlIGNhc2UsIHdoaWNoIGlzIGV4
YWN0bHkgd2hhdA0KTGF1cmVudGl1J3MgcGF0Y2ggc2V0IGlzIGRvaW5nLg0KDQpPdXIgaG9wZSBp
cyB0byBjb21lIHRvIGEgY29tbW9uIHVuZGVyc3RhbmRpbmcgb2YgdGhlIG5leHQgc3RlcHMgc2lu
Y2UgdGhpcw0Kd291bGQgdW5ibG9jayBzb21lIGFjdGl2aXRpZXMgY3VycmVudGx5IGluIHRoZSBi
YWNrbG9nLg0KDQpJb2FuYQ0K
