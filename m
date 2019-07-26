Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE57477391
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfGZVlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:41:22 -0400
Received: from mail-eopbgr00056.outbound.protection.outlook.com ([40.107.0.56]:4481
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726999AbfGZVlV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 17:41:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtcEThEWYKO5z0kMmK2Ojv9+pP4H+CK5eHsR/eff6PbesTDnUd9I4B48D7d2oRMMrfTiNiwLqFhw/hSLD4v9dhsgsk8lHhqYFfULUdI+hUldfWfNvxRW9he79PQ5EEeG/4Ji7OST+MAHg8vkJIhAYpb+KL/HZZNpP6SzLCkAmfiU96DIBhqhCXta6/TKaubIv92SR2vEWebTDuMsgX/XPlrVYSwRfm1zqVs5qoiU4zNSxNz1OUNjYoRDOhfgpsutFU2gOCp7gzO2skWObbUgl8gZmX6fUGjRZxEbinxtnr59Hz0Le3XMf+kULcDDrVmiOArOuhiRQLH2UOgQYTqlqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRMhb2iMe5r7b41wv7kOVQGCW7O/NUdEjFmR6dANKMo=;
 b=c0pPn/2Nt8FK1A8s+UChfRhSpCNVQyIbgC4+cEzznng9bmdvW2TVRGR2JnZMajvZjn+LT8meZoejk/9VohbT1CDNfkyjBqpK57ZWx3kPMasYDCOBZwHQa/3loeFz+RXhUb0FsdtfeFRyXlahEKVjjYL1kjSjNOmsjIQnR70OOAewEU0ZqQqOl3cXl3JCHZAYBuj7ZXvU/eAMUWp258KfkAke23Qm2ntgxRJKMcuPu2B//4fbuOQ01489a9Qrdh2/cVuEuC0PyFHpSaE8Q5nElRbg3ZS8zt4lZ/pvk0QIYBOWiMejx4VEODHJAArPsAm6PM01NNCg646E7rSisrbCEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qRMhb2iMe5r7b41wv7kOVQGCW7O/NUdEjFmR6dANKMo=;
 b=JbCRADmQVW9xhaa+G1kVMumKwVBsGZVhAaO5uFDsV5ejGfoHwrkajyjXO3Ob3bCDIKhoaxANgjTT2kWC69VxLf+Wj4Z5RWLb+TtUu7y1F5mQhAOh8oDZ9SNT1T+DOuC3KRn24lUIc+rtlWCBbOtnhdIVtcLrVdMHjUMqgpAd4Og=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2840.eurprd05.prod.outlook.com (10.172.227.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 21:41:17 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 21:41:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 7/9] net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
Thread-Topic: [net 7/9] net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
Thread-Index: AQHVQyiuIyJivam7i0Wpy/eyS+CZSqbbzq8AgAGgsoA=
Date:   Fri, 26 Jul 2019 21:41:17 +0000
Message-ID: <256df7f47312f676f9644f59be8e3b3e2b99da28.camel@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
         <20190725203618.11011-8-saeedm@mellanox.com>
         <20190725134950.74733e62@cakuba.netronome.com>
In-Reply-To: <20190725134950.74733e62@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 631c13a7-a176-44de-ad02-08d71211fd9c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2840;
x-ms-traffictypediagnostic: DB6PR0501MB2840:
x-microsoft-antispam-prvs: <DB6PR0501MB28405DC59247370A91EDE1D6BEC00@DB6PR0501MB2840.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(189003)(199004)(6506007)(54906003)(6486002)(8676002)(6512007)(5640700003)(14454004)(76176011)(118296001)(102836004)(107886003)(26005)(486006)(66066001)(186003)(4326008)(229853002)(53936002)(76116006)(7736002)(81156014)(8936002)(14444005)(6116002)(256004)(6246003)(2351001)(3846002)(6916009)(5660300002)(71190400001)(476003)(71200400001)(66446008)(316002)(2616005)(68736007)(446003)(11346002)(58126008)(86362001)(66556008)(36756003)(66476007)(66946007)(25786009)(64756008)(2501003)(478600001)(99286004)(91956017)(2906002)(6436002)(81166006)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2840;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7YhlWok5TjXBlIGPmNnZgQW/riYaTkVShBjULR9uTL/hVR/CuG/rP7YlhiyWOcZaDoeHjMZigNe9Ay0l6sPHTQXB9HDuIU4YhkJCq9XKyvhpzC4Rri2oBCfillrUzi4EwDG/gnuyEWsuhDpcl0T+Hbu58eAFNJrB9+eZppWdPPj03KGfaVW7Z52HAL4o02cZyW+ZdaRFQZ0+wwbn+t1Qtr7ffjW5IXei9DwDtdsnFEYG0hrIEXEEFTn1DyBGaCSmW4oDJYqy2QHgg6nPVNVykud4Cv2Gg5Smat84f3zCeep1TPZB4iayBlY2BlQOIhXTLzzqvbFC+0+H1dS/JEdxsRWnF3SGzqp4YtbR8jlvCQejqkgJ9ij8Icp9SYRtQ3FEyzmJCrh6g5OCHtbgdm/WXANqhB1brmRuTwxpGzVIt+0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0265264C7AE9FC49B7029373A18CD208@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 631c13a7-a176-44de-ad02-08d71211fd9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 21:41:17.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2840
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDEzOjQ5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyNSBKdWwgMjAxOSAyMDozNjo0OCArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gRnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiA+IA0K
PiA+IEEgbmV0ZGV2IG1pc21hdGNoIGluIHRoZSBwcm9jZXNzZWQgVExTIFNLQiBzaG91bGQgbm90
IG9jY3VyLA0KPiA+IGFuZCBpbmRpY2F0ZXMgYSBrZXJuZWwgYnVnLg0KPiA+IEFkZCBXQVJOX09O
Q0UgdG8gc3BvdCBzdWNoIGNhc2VzLg0KPiA+IA0KPiA+IEZpeGVzOiBkMmVhZDFmMzYwZTggKCJu
ZXQvbWx4NWU6IEFkZCBrVExTIFRYIEhXIG9mZmxvYWQgc3VwcG9ydCIpDQo+ID4gU3VnZ2VzdGVk
LWJ5OiBKYWt1YiBLaWNpbnNraSA8amFrdWIua2ljaW5za2lAbmV0cm9ub21lLmNvbT4NCj4gPiBT
aWduZWQtb2ZmLWJ5OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBtZWxsYW5veC5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gLS0t
DQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9r
dGxzX3R4LmMgfCAyICstDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3R4LmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3R4LmMNCj4gPiBp
bmRleCBlYTAzMmY1NDE5N2UuLjM3NjY1NDVjZTI1OSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwva3Rsc190eC5jDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2t0
bHNfdHguYw0KPiA+IEBAIC00MTIsNyArNDEyLDcgQEAgc3RydWN0IHNrX2J1ZmYgKm1seDVlX2t0
bHNfaGFuZGxlX3R4X3NrYihzdHJ1Y3QNCj4gPiBuZXRfZGV2aWNlICpuZXRkZXYsDQo+ID4gIAkJ
Z290byBvdXQ7DQo+ID4gIA0KPiA+ICAJdGxzX2N0eCA9IHRsc19nZXRfY3R4KHNrYi0+c2spOw0K
PiA+IC0JaWYgKHVubGlrZWx5KHRsc19jdHgtPm5ldGRldiAhPSBuZXRkZXYpKQ0KPiA+ICsJaWYg
KHVubGlrZWx5KFdBUk5fT05fT05DRSh0bHNfY3R4LT5uZXRkZXYgIT0gbmV0ZGV2KSkpDQo+IA0K
PiBBaCwgbml0OiB0aGUgdW5saWtlbHkgaXMgcHJvYmFibHkgdW5uZWNlc3NhcnkgYnV0IHRoYXQn
cyBubyBiaWcgZGVhbC4NCj4gDQo+ICNkZWZpbmUgV0FSTl9PTl9PTkNFKGNvbmRpdGlvbikgKHsJ
CQlcDQo+IAlzdGF0aWMgaW50IF9fd2FybmVkOwkJCQlcDQo+IAlpbnQgX19yZXRfd2Fybl9vbmNl
ID0gISEoY29uZGl0aW9uKTsJCVwNCj4gCQkJCQkJCVwNCj4gCWlmICh1bmxpa2VseShfX3JldF93
YXJuX29uY2UgJiYgIV9fd2FybmVkKSkgewlcDQo+IAkJX193YXJuZWQgPSB0cnVlOwkJCVwNCj4g
CQlXQVJOX09OKDEpOwkJCQlcDQo+IAl9CQkJCQkJXA0KPiAJdW5saWtlbHkoX19yZXRfd2Fybl9v
bmNlKTsJCQlcDQo+IH0pDQo+IA0KDQppbmRlZWQsIGkgc2VlIERhdmUgYWxyZWFkeSBhY2NlcHRl
ZCB0aGlzLCB3aWxsIGZpeCBpbiBuZXQtbmV4dC4NCg0KVGhhbmtzIEpha3ViICENCg0K
