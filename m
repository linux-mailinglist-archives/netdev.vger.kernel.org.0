Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E603D72334
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfGWXyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:54:33 -0400
Received: from mail-eopbgr60050.outbound.protection.outlook.com ([40.107.6.50]:36576
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726862AbfGWXyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 19:54:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcSiRdKbRLNvShBM3AnXvYfpsJD9f4Iqjzv20KU1eRx4HxheANSjhTab6GOSHQQ3bP4vcqX61AEhW+j0T3cZoIZhm3Ineh7830G6O360zxAyUh/b6cxoEHM5N0B0t0em+pEJe1KcOZI3Ol4XAvMCCZ5r+gaIEtWZg7rAh6rpCCOwYw0UpdXxMQ+iDjKmT59QzKKP7vBo3Zhmu1WufiGPD/FPefwcShpTKg1u1jEhCf+Hw+pwLWLrwKYGLhNkEGgTPC9NuMbtrL0Hy46P1a6mEGUcqMtvoWLcUYvbbdzTABGEh8lGskXDd0PSibE13kc85Bdhuz4yA8QmAp3iL4lDUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilYVIweH+FlEWyEuX8DPkyf5M2Of556PZPUMNU25coQ=;
 b=VS5Wfy2jsxZNkWFDBN1+3xlE191Esq7mz+UJEn1VoEYAqcSOG0bj3q4lTLExKal/UWGroxZts1vrRi8XbflKLXoXBb/RfeeVttrqHnIHm5ClsgMp4VOYxrroY7vwYKL3a2yr45hG80Nfo+upF2Q1EyWKJjZuHbNnDBpMHHpYYim/ou4nPQoeYmsY3vKvY0WSo7saaHonLkmAoe/xgisutO+4OuA4Y5MlA0Zw2CrvWpibG9GzXbEKGyUg1fsyM6UtwkYx7zasGmG994A0a/J+6M6q1LgL9KPUk+wv2JlZWCeH93BMhL1rkvrqm8iXOVHyHaeDPqGf9toU/T3I1Ahd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilYVIweH+FlEWyEuX8DPkyf5M2Of556PZPUMNU25coQ=;
 b=f1OGU+0/48aC6MHcwzdFGumiY7eAqJpNHbDSIZ+1XQQHxxqui4SmKTrAfbgAe/pJMkLZwNTbkgtQqoaay52kmPSiuUtusDYgbQt77xjDCzOyD8cPArEPG4J6YkZ74Ta7uz2v2rV+S3aoRvp7fNgtu5aTKj7TUTRGgAilY+w0NTU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2327.eurprd05.prod.outlook.com (10.168.55.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 23:54:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 23:54:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "snelson@pensando.io" <snelson@pensando.io>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
Thread-Topic: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
Thread-Index: AQHVQNYh0hIXTEJm+k+NKGK2L/AMCqbYutkAgAAVmICAAARmAIAADWiA
Date:   Tue, 23 Jul 2019 23:54:29 +0000
Message-ID: <ba8349adaea24d955be3e98abf9ade59b0a9f580.camel@mellanox.com>
References: <20190722214023.9513-12-snelson@pensando.io>
         <20190723.143326.197667027838462669.davem@davemloft.net>
         <e0c8417c-75bf-837f-01b5-60df302dafa7@pensando.io>
         <20190723.160628.20093803405793483.davem@davemloft.net>
In-Reply-To: <20190723.160628.20093803405793483.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b4d0b20-4a04-4b67-7d99-08d70fc919f2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2327;
x-ms-traffictypediagnostic: DB6PR0501MB2327:
x-microsoft-antispam-prvs: <DB6PR0501MB232704939AB6332AF686B0A3BEC70@DB6PR0501MB2327.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(71200400001)(71190400001)(6436002)(53936002)(6486002)(66066001)(486006)(118296001)(2906002)(6512007)(8936002)(102836004)(68736007)(2501003)(6116002)(25786009)(6506007)(53546011)(76176011)(2616005)(478600001)(81166006)(99286004)(64756008)(26005)(14454004)(186003)(11346002)(66476007)(305945005)(58126008)(316002)(8676002)(4326008)(7736002)(256004)(4744005)(6246003)(3846002)(229853002)(76116006)(36756003)(5660300002)(86362001)(66556008)(66446008)(110136005)(66946007)(476003)(91956017)(14444005)(81156014)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2327;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: aiB4RP+VfHkhD8/2plrXmF/fbKUG5AxZCdefsX5QcS9il5F57MWRmsNfSNOgDj5+Jv1+QwntWr50E3p9l3yu0aFDSaG3jDy6H8Fzuhcx7VGtp6lKHO/gbRodJX+lozgIIMeGv1fC8ROMWk/EKXmI9gjJbfivKTe6rHzo+S8eeBoLPQfez350H+UNHQyUVwYsFEabqppA8pW8wmkauRCMWirUt1Rg36sdhfWGr04AASYGHCit6xNrS46bKg9bxVI3yZJmir41GZ3IQ/lk9mU1OdU2wCuykHCkZNA0cHbJIw3r9Js6RW1xIYxjlw6bdt2G0Fq68PVFLYntqvvCwaSoC6qGb3wZ1M/DrX1L/IfXxNGVIBILoucWwd2zfOCVh5xIrCmn+nFmvlHXEZo0p03QJAf9e7+xhRUOZ1muailoQkE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9686E58695F586448FFF113D31822FB2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4d0b20-4a04-4b67-7d99-08d70fc919f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 23:54:29.2680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDE2OjA2IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNoYW5ub24gTmVsc29uIDxzbmVsc29uQHBlbnNhbmRvLmlvPg0KPiBEYXRlOiBUdWUs
IDIzIEp1bCAyMDE5IDE1OjUwOjQzIC0wNzAwDQo+IA0KPiA+IE9uIDcvMjMvMTkgMjozMyBQTSwg
RGF2aWQgTWlsbGVyIHdyb3RlOg0KPiA+ID4gR2VuZXJhbGx5IGludGVyZmFjZSBhZGRyZXNzIGNo
YW5nZXMgYXJlIGV4cGVjdGVkIHRvIGJlDQo+ID4gPiBzeW5jaHJvbm91cy4NCj4gPiBZZWFoLCB0
aGlzIGJvdGhlcnMgbWUgYSBiaXQgYXMgd2VsbCwgYnV0IHRoZSBhZGRyZXNzIGNoYW5nZSBjYWxs
cw0KPiA+IGNvbWUNCj4gPiBpbiB1bmRlciBzcGluX2xvY2tfYmgoKSwgYW5kIEknbSByZWx1Y3Rh
bnQgdG8gbWFrZSBhbiBBZG1pblEgY2FsbA0KPiA+IHVuZGVyIHRoZSBfYmggdGhhdCBjb3VsZCBi
bG9jayBmb3IgYSBmZXcgc2Vjb25kcy4NCj4gDQo+IFNvIGl0J3Mgbm90IGFib3V0IG1lbW9yeSBh
bGxvY2F0aW9uIGJ1dCByYXRoZXIgdGhlIGZhY3QgdGhhdCB0aGUNCj4gZGV2aWNlDQo+IG1pZ2h0
IHRha2UgYSB3aGlsZSB0byBjb21wbGV0ZT8NCj4gDQo+IENhbiB5b3Ugc3RhcnQgdGhlIG9wZXJh
dGlvbiBzeW5jaHJvbm91c2x5IHlldCBjb21wbGV0ZSBpdCBhc3luYz8NCg0KVGhlIGRyaXZlciBp
cyBkb2luZyBidXN5IHBvbGxpbmcgb24gY29tbWFuZCBjb21wbGV0aW9uLCBkb2luZyBvbmx5IGJ1
c3kNCnBvbGxpbmcgb24gY29tcGxldGlvbiBzdGF0dXMgaW4gdGhlIGRlZmVycmVkIHdvcmsgd2ls
bCBub3QgYmUgbXVjaA0KZGlmZmVyZW50IHRoYW4gd2hhdCB0aGV5IGhhdmUgbm93Li4gDQoNCmFz
eW5jIGNvbXBsZXRpb24gd2lsbCBvbmx5IG1ha2Ugc2luY2UgaWYgdGhlIGhhcmR3YXJlIHN1cHBv
cnRzDQppbnRlcnJ1cHQgYmFzZWQgKE1TSS14KSBjb21tYW5kIGNvbXBsZXRpb24uDQo=
