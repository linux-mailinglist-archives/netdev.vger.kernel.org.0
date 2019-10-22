Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D86E0BFA
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbfJVSwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:52:39 -0400
Received: from mail-eopbgr130085.outbound.protection.outlook.com ([40.107.13.85]:31207
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731740AbfJVSwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 14:52:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5/ZzkRjPlvEp0nqJep5ksQOPzPmvig5YAoGB8FVzw65ACkjPx99MIOMD4F12bZFY1HsfcWdzUNXfDFkc3x2F7WbQaIqdhAA0SShxWnrbv2gskKwg68Es8Va9nhwfs11EeK2Dlrl9BYizj4Wetypa7wvoBzE9T58/arfXjnebwToUS2e16UODf1OaajFQDRv7GyWrUWAeHz25jEKJ9POm9gUHPpfav/lBVtxQDbOh4WXmgoUlwwC8I/vZNm/bywsNOflif4aPdAnvl96A9xCztHb9EcNkSZH7LzKo7qu4GRL43igjRnWAn9c+VUI9PXf086DY4XqVMfDpURbIVGiBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x1alln0bwiuRPH2PvfgoZExeJd1MAOsAqMjPaG8yrQ=;
 b=Kl/cDYpXezk8kAW5bJZmPqadWUv8A370Z3q7aAH2qNbarn3S12KVFqEOqAg+BvrAIb2AvSb+YUP0BYTljELOqZP81CqXYznNFk1wwlFRuPePl3WC0xI+MKtF3+K+W29kkahrswORo74NG++rs7IwpVqan8O+n4o8ayfEspz3CmXtghzHWeuQJatVky0fvNRu98/DyIqXWFIu2QX4t7iF14cg0Eh27jh7azEaPkW9Yh+NGBtJaZx9iGVmOj1UasP/18YZZoMd9pnF/hfSfOJBsJlB7KAcEQ6F41/f2OGJPvsTjA0NZJLTwfW65wRkKiHMlEDRDKnE23EEoBqQ5bPgwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x1alln0bwiuRPH2PvfgoZExeJd1MAOsAqMjPaG8yrQ=;
 b=D8YPWi/nDBAC84a8V6jaclX7X1XoUFsPWNeG5DZ3VSM114+F6l0xKYkMLF22xOUysTC4CuaOrJOlPlRby/WnFnRPXlBpK7AlAvB9bI+BwJbDF38V81Tn8rGpe6O18SpRPqhp9UGBBcfq5yH7PwHp8tObYvFncPw+K2YAPrcSAxY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5070.eurprd05.prod.outlook.com (20.177.50.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 18:52:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 18:52:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Thread-Topic: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Thread-Index: AQHVheubJJkqR3lyxEm2rDcZyu4JaqdhM5oAgAXIWQCAAAk0gIAAAroA
Date:   Tue, 22 Oct 2019 18:52:34 +0000
Message-ID: <d35e1bc263bdbe89016de92ef6488326d666c641.camel@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
         <20191018193737.13959-13-saeedm@mellanox.com>
         <20191018185128.0cc912f8@cakuba.netronome.com>
         <b52dee38856c98dc4702ad269d85cf35d3689cf7.camel@mellanox.com>
         <20191022114247.144461a5@cakuba.netronome.com>
In-Reply-To: <20191022114247.144461a5@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 75ad55f5-8247-4e73-d25b-08d75721007e
x-ms-traffictypediagnostic: VI1PR05MB5070:|VI1PR05MB5070:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB50709093FE7282CD45189A78BE680@VI1PR05MB5070.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(446003)(5640700003)(4001150100001)(2616005)(476003)(186003)(58126008)(11346002)(316002)(54906003)(71200400001)(486006)(26005)(36756003)(6116002)(3846002)(2906002)(71190400001)(6916009)(2501003)(66066001)(5660300002)(2351001)(14454004)(6436002)(6486002)(229853002)(91956017)(305945005)(107886003)(6246003)(66446008)(64756008)(66556008)(81156014)(81166006)(6512007)(7736002)(8936002)(8676002)(4326008)(76116006)(66476007)(66946007)(118296001)(25786009)(478600001)(6506007)(102836004)(256004)(99286004)(14444005)(86362001)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5070;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lALB8/9wXcitMJVe2rH1b9rjCZT+S/5hsIwWPlG8/Y1vFnyar5kk5Lkka84SBKl7NZKYDF9Xk2KWii+ztyFvB4uGi4UgY8JXW1YaG+FW/Dv5OZpfTurqIi2YE3Kb7TeIw8+chTpNdkCWWZkt3W9g+8eeZxrSSA17YOsttEes7pIT/GAl1j/HOZ+fbPZOMQgZTeDDEhIl1gKhGbhSJbFJwXd6FmbBA412pJoHyw/7KnMbjU/JM0pORE5+K759gWHYi+hN7sAebjf2Ndt9hDU24xNE1Xg79SDTkQPagcdAfN15Y/Ig+/WuRuvBHa3gbEQhsWWTXNPzPqFweHskb0TItmZ1uSJY5+AKi6FpIotb3lzSgyHkAgRtmmV2LI5fMwBSHd20Z0YM7EoVsaUeFog6dC2pFP6IfHGxGi18PESuxW53+v2RDFIjMkYtZtMcVbM0
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FD23CBA5D884F4EAF6CED64F987F2C7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75ad55f5-8247-4e73-d25b-08d75721007e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 18:52:34.8074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fsJWI6t8yz3P7hMUiuxire3WJb9DDtD/AEf2Ym3X4da9aq1/QdmCjG0Drfr1y0o0nRZuF8nK2BZ/xJHnNNS0qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5070
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTEwLTIyIGF0IDExOjQyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyMiBPY3QgMjAxOSAxODoxMDoxMSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gT24gRnJpLCAyMDE5LTEwLTE4IGF0IDE4OjUxIC0wNzAwLCBKYWt1YiBLaWNpbnNr
aSB3cm90ZToNCj4gPiA+IE9uIEZyaSwgMTggT2N0IDIwMTkgMTk6Mzg6MjQgKzAwMDAsIFNhZWVk
IE1haGFtZWVkIHdyb3RlOiAgDQo+ID4gPiA+IEZyb206IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1l
bGxhbm94LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IE9uY2UgdGhlIGtUTFMgVFggcmVzeW5jIGZ1
bmN0aW9uIGlzIGNhbGxlZCwgaXQgdXNlZCB0byByZXR1cm4NCj4gPiA+ID4gYSBiaW5hcnkgdmFs
dWUsIGZvciBzdWNjZXNzIG9yIGZhaWx1cmUuDQo+ID4gPiA+IA0KPiA+ID4gPiBIb3dldmVyLCBp
biBjYXNlIHRoZSBUTFMgU0tCIGlzIGEgcmV0cmFuc21pc3Npb24gb2YgdGhlDQo+ID4gPiA+IGNv
bm5lY3Rpb24NCj4gPiA+ID4gaGFuZHNoYWtlLCBpdCBpbml0aWF0ZXMgdGhlIHJlc3luYyBmbG93
IChhcyB0aGUgdGNwIHNlcSBjaGVjaw0KPiA+ID4gPiBob2xkcyksDQo+ID4gPiA+IHdoaWxlIHJl
Z3VsYXIgcGFja2V0IGhhbmRsZSBpcyBleHBlY3RlZC4NCj4gPiA+ID4gDQo+ID4gPiA+IEluIHRo
aXMgcGF0Y2gsIHdlIGlkZW50aWZ5IHRoaXMgY2FzZSBhbmQgc2tpcCB0aGUgcmVzeW5jDQo+ID4g
PiA+IG9wZXJhdGlvbg0KPiA+ID4gPiBhY2NvcmRpbmdseS4NCj4gPiA+ID4gDQo+ID4gPiA+IENv
dW50ZXJzOg0KPiA+ID4gPiAtIEFkZCBhIGNvdW50ZXIgKHRsc19za2lwX25vX3N5bmNfZGF0YSkg
dG8gbW9uaXRvciB0aGlzLg0KPiA+ID4gPiAtIEJ1bXAgdGhlIGR1bXAgY291bnRlcnMgdXAgYXMg
dGhleSBhcmUgdXNlZCBtb3JlIGZyZXF1ZW50bHkuDQo+ID4gPiA+IC0gQWRkIGEgbWlzc2luZyBj
b3VudGVyIGRlc2NyaXB0b3IgZGVjbGFyYXRpb24gZm9yDQo+ID4gPiA+IHRsc19yZXN5bmNfYnl0
ZXMNCj4gPiA+ID4gICBpbiBzcV9zdGF0c19kZXNjLg0KPiA+ID4gPiANCj4gPiA+ID4gRml4ZXM6
IGQyZWFkMWYzNjBlOCAoIm5ldC9tbHg1ZTogQWRkIGtUTFMgVFggSFcgb2ZmbG9hZA0KPiA+ID4g
PiBzdXBwb3J0IikNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRA
bWVsbGFub3guY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2Fl
ZWRtQG1lbGxhbm94LmNvbT4gIA0KPiA+ID4gDQo+ID4gPiBDb3VsZCB5b3UgZG9jdW1lbnQgdGhl
IG5ldyBjb3VudGVyIGluIHRscy1vZmZsb2FkLnJzdD8gIA0KPiA+IA0KPiA+IFRhcmlxIGFscmVh
ZHkgcHJlcGFyZWQgdGhlIHBhdGNoLCBkbyB3ZSB3YW50IHRoaXMgaW4gbmV0IG9yIG5ldC0NCj4g
PiBuZXh0ID8gDQo+ID4gbW9zdCBvZiBvdXIga1RMUyB1c2VycyBhcmUgZ29pbmcgdG8gdXNlIDUu
My81LjQgc3RhYmxlIGtlcm5lbHMsIGJ1dA0KPiA+IGkNCj4gPiBhbSBub3Qgc3VyZSB0aGlzIHNo
b3VsZCBnbyB0byBuZXQuLiANCj4gDQo+IFRoYW5rcywgSSBhc2tlZCBEYXZlIHJlY2VudGx5IGFi
b3V0IGRvY3MgYW5kIGhlIHNhaWQgd2UgY2FuIGFwcGx5IHRvDQo+IG5ldA0KPiAoc2luY2UgZG9j
IGNoYW5nZXMgY2FuJ3QgcmVhbGx5IGJyZWFrIGFueSBjb2RlKS4gU2luY2UgdGhlIGNvZGUgaXMg
aW4NCj4gbmV0LCBJIHRoaW5rIG5ldCB3b3VsZCBiZSBhcHByb3ByaWF0ZSBmb3IgdGhlIGRvYyBh
cyB3ZWxsLiANCg0KQWxyaWdodCEgd2lsbCBzZW5kIGl0IGluIG15IG5leHQgYmF0Y2ggb2YgZml4
ZXMgdG8gbmV0Lg0KDQpUaGFua3MsDQpTYWVlZC4NCg==
