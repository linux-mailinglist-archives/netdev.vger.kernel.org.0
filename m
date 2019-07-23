Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB81720BB
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbfGWUZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:25:51 -0400
Received: from mail-eopbgr10060.outbound.protection.outlook.com ([40.107.1.60]:8100
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbfGWUZv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 16:25:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvieNlS4o8yIMfrJrEAM48aZjdjtI7XzPV2fAu4iSpZ/MudZDIUk56tUfVDJhzqa1417zeyCKuMo+PfNlJ/1fA483+CH93hlMz2kZpORsR5GLzADcRKdU/yqbdB04Ygzqa1mrvtL/nTnp+1c1ejfwGgLhfFqV1uFw/99mETAro84mRNuqiZI6K/UfdoP1mMsjWbyCr99tmJaDWRUve8d+r62nteQ13I8q15bl5Spwp7yTZoHaMAUNmPY+/NZ7otS/0OrT2uXd5tLVAaevvTH8yfBSaTmBZVTQKo5BvMH7LAnmSCr3hVLKmoBtB1aA0W9RM6Pc7fOK56Of5S1sIJzKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngDvDZOUAxq+qIcd19DKBPOEeSA8JszmF0KJI3Fgc6c=;
 b=KKjjShh+EsrQr0PeN8XkCwTY5GVD3f3/+ro78XnzfF5tk9TMDVyHiNN66CKjKKDJaky7FTRGxeBN3GW1071pqwwCHtt2PNEMlYxCkA7SKD4XwaY6mvCS+deYNtbu5mo+Bm7Z+kdu6wjJP3sCyetXiaxpNZKBc4BnaGOVPL8mwrxg+PzNVXC76J78pE1OE/t8Ctw9stHyfJuAcwHt6O4fuPsx9B447pIwuWLG7up/Pbs4ocNEknJCN2GLQQHo1nSjbGB5lzw2xJFlbxQBO39UuCLhVAN2TBlndb4OT3uztwmBnZUDQIvtEkzE3fOFk8X8myQNCio9vp5IBa34h221xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngDvDZOUAxq+qIcd19DKBPOEeSA8JszmF0KJI3Fgc6c=;
 b=bE66AqaFOr+tjzVTmbhVNE5WWQ9JaRJAd+JJse1dxmX66S18HYkJ3+AFYF9aUpPGcus+NrXkuyt4XD5DvUSDEIDTgFTNalZ9WIOLi3E6EFLoZl++LVIf1sSgvutaKDYxrGWbb9rviybthFPfkW1YHYs2qGVyc+0pqdSwLP9kPI8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2231.eurprd05.prod.outlook.com (10.168.56.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 23 Jul 2019 20:25:47 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 20:25:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Edward Srouji <edwards@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Thread-Topic: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Thread-Index: AQHVQSYU/XFyboT9FUmZvXfwV+sFwqbYhqUAgAAJ5ACAABbGAA==
Date:   Tue, 23 Jul 2019 20:25:46 +0000
Message-ID: <70c2f2a817f9be2c9b4ceb9bae70313cd5807240.camel@mellanox.com>
References: <20190723071255.6588-1-leon@kernel.org>
         <20190723.112850.610952032088764951.davem@davemloft.net>
         <20190723190414.GU5125@mtr-leonro.mtl.com>
In-Reply-To: <20190723190414.GU5125@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa1b51db-6a6d-4698-7b54-08d70fabf23f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2231;
x-ms-traffictypediagnostic: DB6PR0501MB2231:
x-microsoft-antispam-prvs: <DB6PR0501MB223191A9546C80A542ACF271BEC70@DB6PR0501MB2231.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(199004)(189003)(110136005)(58126008)(107886003)(6486002)(66556008)(76116006)(305945005)(64756008)(66476007)(66446008)(66946007)(36756003)(316002)(66066001)(6436002)(54906003)(25786009)(118296001)(478600001)(476003)(446003)(102836004)(6512007)(2501003)(2906002)(3846002)(6246003)(68736007)(6506007)(53936002)(486006)(99286004)(7736002)(2616005)(229853002)(5660300002)(76176011)(81166006)(26005)(86362001)(8676002)(14454004)(81156014)(186003)(71200400001)(71190400001)(256004)(8936002)(4326008)(11346002)(91956017)(6116002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2231;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k7gaS+r2bDJhZvXFMVxcjicOeHqMR+gCCyR8pOjojpdu/5MaIAy/uJ+cSeciYPYVRloh/qdA7IeS/BjmiVEb9NPAeW5G/XY6UbjLf9RgSLuSsgCUOEi9gFBpnp1Y9PhQpD54XZtKDsXaAoErzmNwfzmp5/LmcHn9+QIcrjWWW/zuE59Wf42gxSx9n1I63AMpL0zvdE/iNqnSxqVZg4KY/tqkQpeoYnvL+kBayHDB4TqhAW1LisZT6FKYeIpSuq9gR1WOtJvq5Y7y0FZ5yBCkANvRT//FBBBHvgSxsGTYl4SAJmcjd6FR+PejQ3JGBDfLLaxu0demVbJMUEDFu4kq8wpLT2RodS4N1DIuDJ1j0rgH8SeqLWnqDSOwu4R7+7GYsOqLIJZiab6dYWXOCmyvbpWkIg9TCDeKgJMBKlY0ndE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52D44420F0E45243BA17E0A96D9EBCDF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1b51db-6a6d-4698-7b54-08d70fabf23f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 20:25:47.0407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2231
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDIyOjA0ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgSnVsIDIzLCAyMDE5IGF0IDExOjI4OjUwQU0gLTA3MDAsIERhdmlkIE1pbGxl
ciB3cm90ZToNCj4gPiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4g
PiBEYXRlOiBUdWUsIDIzIEp1bCAyMDE5IDEwOjEyOjU1ICswMzAwDQo+ID4gDQo+ID4gPiBGcm9t
OiBFZHdhcmQgU3JvdWppIDxlZHdhcmRzQG1lbGxhbm94LmNvbT4NCj4gPiA+IA0KPiA+ID4gRml4
IG1vZGlmeV9jcV9pbiBhbGlnbm1lbnQgdG8gbWF0Y2ggdGhlIGRldmljZSBzcGVjaWZpY2F0aW9u
Lg0KPiA+ID4gQWZ0ZXIgdGhpcyBmaXggdGhlICdjcV91bWVtX3ZhbGlkJyBmaWVsZCB3aWxsIGJl
IGluIHRoZSByaWdodA0KPiA+ID4gb2Zmc2V0Lg0KPiA+ID4gDQo+ID4gPiBDYzogPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+ICMgNC4xOQ0KPiA+ID4gRml4ZXM6IGJkMzcxOTc1NTRlYiAoIm5ldC9t
bHg1OiBVcGRhdGUgbWx4NV9pZmMgd2l0aCBERVZYIFVJRA0KPiA+ID4gYml0cyIpDQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBFZHdhcmQgU3JvdWppIDxlZHdhcmRzQG1lbGxhbm94LmNvbT4NCj4gPiA+
IFJldmlld2VkLWJ5OiBZaXNoYWkgSGFkYXMgPHlpc2hhaWhAbWVsbGFub3guY29tPg0KPiA+ID4g
U2lnbmVkLW9mZi1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbWVsbGFub3guY29tPg0KPiA+
IA0KPiA+IFZlcnkgY29uZnVzaW5nIHN1Ym1pc3Npb24gb24gbWFueSBsZXZlbHMuDQo+ID4gDQo+
ID4gQ29taW5nIGZyb20gYSBNZWxsYW5veCBkZXZlbG9wZXIgdXNpbmcgYSBrZXJuZWwub3JnIGVt
YWlsIGFkZHJlc3MuDQo+IA0KPiBJdCB3b3JrcyBmb3IgdXMgYW5kIHdhcyBwcm92ZW4gaW50ZXJu
YWxseSBhcyB0aGUgYmVzdCB3YXkgdG8gaGF2ZQ0KPiBzZXR1cCB3aGljaCBhbHdheXMgd29ya3Mu
DQo+IA0KPiA+IFRhcmdldHRpbmcgdGhlIG1seDUtbmV4dCB0cmVlLCB5ZXQgQ0M6J2luZyBzdGFi
bGUuDQo+IA0KPiBUaGlzIHBhdGNoIHdhcyBmb3VuZCBieSBSRE1BIHRlYW0sIG5lZWRlZCBieSBS
RE1BIGJ1dCBjaGFuZ2VzIGFyZQ0KPiBsb2NhdGVkDQo+IGluIGNvZGUgYWNjZXNzaWJsZSBieSBt
bHg1X2NvcmUgcGFydC4gVGhpcyBpcyB3aHkgbWx4NS1uZXh0Lg0KPiANCg0KTGVvbiwgDQptbHg1
LW5leHQgImhlbmNlIHRoZSAtbmV4dCIgaXMgTk9UIG1lYW50IGZvciBmaXhlcywgaXQgaXMgaW5k
ZWVkDQpjb25mdXNpbmcgd2hhdCB5b3UgYXJlIHRyeWluZyB0byBkbyBoZXJlLCBEYXZlJ3Mgc3lz
dGVtIHdvcmtzIHBlcmZlY3RseQ0KZm9yIHVzLiANCg0KPiA+IEEgbmV0d29ya2luZyBjaGFuZ2Us
IGZvciB3aGljaCBzdGFibGUgc3VibWlzc2lvbnMgYXJlIGhhbmRsZWQgYnkgbWUNCj4gPiBieQ0K
PiA+IGhhbmQgYW5kIG5vdCB2aWEgQ0M6J2luZyBzdGFibGUuDQo+IA0KPiBUaGUgaW50ZW50aW9u
IHdhcyB0byBoYXZlIHRoaXMgcGF0Y2ggaW4gc2hhcmVkIG1seDUgYnJhbmNoLCB3aGljaCBpcw0K
PiBwaWNrZWQgYnkgUkRNQSB0b28uIFRoaXMgIkNjOiBzdGFibGVALi4uIiB0b2dldGhlciB3aXRo
IG1lcmdlIHRocm91Z2gNCj4gUkRNQSB3aWxsIGVuc3VyZSB0aGF0IHN1Y2ggcGF0Y2ggd2lsbCBi
ZSBwYXJ0IG9mIHN0YWJsZQ0KPiBhdXRvbWF0aWNhbGx5Lg0KPiANCj4gSSBjYW4gcmVtb3ZlICJD
YzogLi4uIiBsaW5lIGlmIHlvdSB0aGluayB0aGF0IGl0IGlzIGluYXBwcm9wcmlhdGUgdG8NCj4g
aGF2ZSBzdWNoIGxpbmUgaW4gcGF0Y2ggaW4gbWx4NS1uZXh0Lg0KDQpObywgaWYgdGhpcyB3YXMg
bWVhbnQgdG8gbGFuZCBpbiAtc3RhYmxlIHRoZW4gaXQgc2hvdWxkIGdvIHRvIC1yYyB2aWENCm5l
dCBicmFuY2ggbm90IHRvIG1seDUtbmV4dCwgbGV0J3Mgc2F2ZSBldmVyeWJvZHkncyB0aW1lIGFu
ZCBlbmVyZ3kNCmhlcmUuIG5vIHBvaW50IGluIGFyZ3VpbmcuLiANCg0KSSB3aWxsIHRha2UgdGhp
cyB0byBteSBuZXQgcXVldWUgYW5kIHN1Ym1pdCB0byBEYXZlJ3MgbmV0IGJyYW5jaCwgYXMgd2UN
CmFsd2F5cyBkbyBmb3IgbWx4NSBmaXhlcy4NCg0KZm9yIG5leHQgdGltZSwgbWx4NSBmaXhlcyBz
aG91bGQgYWx3YXlzIGdvIHRvIG5ldCBicmFuY2ggZmlyc3QsIHRoZW4gaXQNCmlzIGp1c3QgYSBt
YXR0ZXIgb2YgZGF5cyB0byBzZWUgdGhlIGZpeCBpbiAtcmMgYW5kIHF1ZXVlZCB1cCB0bw0KLXN0
YWJsZS4NCg0KPiANCj4gVGhhbmtzDQo=
