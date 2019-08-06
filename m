Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE6AD83A70
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfHFUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:40:16 -0400
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:46979
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726058AbfHFUkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 16:40:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB7oMe+oT/vLYcxQPcWTXFXWN0rFbPPHuYMTLZSQ90ia826GEP9ybmFZCt7Lg8auT+migAlAoRkjJOW4iWFDvAHhJzOANj+Azn/0hJb9VxifGlhgxTHaZJsLk9KyATcMlWlT2B8K6rwlD7wHrH9nIoqLf9VtEMls51KvgCUx+5iXyJCrmDQUJ5uGkmmvKbkCWvNl/0PSh/5tDgyxlBCXP42ru6Yf1+c1Y4Lzwug1K99eafMUWxGz2+kY1n8bSE+4Jj683yyiJIAyWNKURgjVAQFQD1qCaC5etTQce3XYvhV/02ssMcyyXSrmxL9RLaejtVTr3YDGrmP447g3xl4edQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTry/fAWroqprwSPBrq0WTt0lYf/5Vhw9ZBd4xITDV4=;
 b=N4CO0WcenCFcH0iAPDv27MHm0ofKYqIDil2AqOFYyOBK6HuyCukarPEt3W1oJZp9s05NnA8lSLy0+LoATFpdI4QuGRcOAewrMIXrF9mCIx70DJ0u8m+148s0NCEzLU2oQCCCVF15wkE1/V5lUhooPkc+XiIckNm6yXIJJZQt/MPOk35QTcFTuoMuIMfmCHmPGJl7fCnCDCreDvHV2121kVuIc7EmcThyGQ3TN6gepzw6aEkW9gdJBtIFVY1IrtCDaKEZoGcJRJ4Ie55zyWYsGVIcfVouVFhMbkLbg8pOEP+OAdxLz1NNKOkKWH9LsWz0Nr8uXFnq42QKmyt4mIn+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTry/fAWroqprwSPBrq0WTt0lYf/5Vhw9ZBd4xITDV4=;
 b=J0sF7COu6MWFhJwwdOknlBGy8AUzz5l+Mft9bs4IQTwmzvzP9helxAbsHtxpk1N7AoFzPkZsqda8kfq/G9HxQtLIR9ypLxSyxp80r6CBkL6Pvu7OXAeqOp7zo9+VnucneBHJdPhY296PO2EgpruVcNkG6riDPckJn0PQiDIeRgM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2790.eurprd05.prod.outlook.com (10.172.227.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Tue, 6 Aug 2019 20:40:11 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 20:40:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH v3] mlx5: Use refcount_t for refcount
Thread-Topic: [PATCH v3] mlx5: Use refcount_t for refcount
Thread-Index: AQHVS/qqPWmA6k0y9U2jqPKx2/PeLKbullCA
Date:   Tue, 6 Aug 2019 20:40:11 +0000
Message-ID: <cbea99e74a1f70b1a67357aaf2afdb55655cd2bd.camel@mellanox.com>
References: <20190806015950.18167-1-hslester96@gmail.com>
In-Reply-To: <20190806015950.18167-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 600f9a09-79f6-44b8-d1cd-08d71aae472e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2790;
x-ms-traffictypediagnostic: DB6PR0501MB2790:
x-microsoft-antispam-prvs: <DB6PR0501MB27909C7F2CB109976939AA5CBED50@DB6PR0501MB2790.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(186003)(6486002)(11346002)(256004)(6436002)(91956017)(3846002)(6116002)(8676002)(86362001)(446003)(5640700003)(68736007)(478600001)(229853002)(76116006)(66556008)(36756003)(476003)(6512007)(6246003)(81156014)(66476007)(99286004)(66946007)(2616005)(6916009)(2351001)(81166006)(26005)(76176011)(7736002)(14454004)(2501003)(1361003)(8936002)(53936002)(66446008)(316002)(64756008)(4744005)(71200400001)(71190400001)(102836004)(58126008)(2906002)(5660300002)(4326008)(305945005)(25786009)(14444005)(1411001)(6506007)(486006)(54906003)(118296001)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2790;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: maBUFQkYf57Hd+pWxYIqn9ubVqz9Mw55VOIftYIJ6r4lGJGOlMA/iVlllkv3tATaxZdtzF5q3/7FaCHWO6H7zdoZ/UjSTGXebLW2CqY98aoi0e/SA19BPJL53Ux49SXKe8QZJIqVIq0YPnO+7hmUGtQXsXmnez4ZGZy+haXjKopDpVL0RqmBQoeMBzKTYLYMmP2p5Tmmj86esM5sGGgX0YuwO3WvI2KlgE5dnU/KtElFnnA/v2Hhk+G4a27mJtiSu+Tvqfpw9OwxeLg4iWzlC9p5/0oyUctWYUOKA407EFpkb/YBJHTbxrepLVvIMzdq94XxrFXGfI+BD2oudLX0WczNHAZgZiLxYiRaabtMm58bclGaFmXhpo7lMJuVSl/HhRnK4IRGdnvTKbykcLqkXwlpt7YmaVCpD7XgEVRoqqM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A7A5275462F844DBE7C38ABF2E9A190@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600f9a09-79f6-44b8-d1cd-08d71aae472e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 20:40:11.5857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2790
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDA5OjU5ICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+
IFJlZmVyZW5jZSBjb3VudGVycyBhcmUgcHJlZmVycmVkIHRvIHVzZSByZWZjb3VudF90IGluc3Rl
YWQgb2YNCj4gYXRvbWljX3QuDQo+IFRoaXMgaXMgYmVjYXVzZSB0aGUgaW1wbGVtZW50YXRpb24g
b2YgcmVmY291bnRfdCBjYW4gcHJldmVudA0KPiBvdmVyZmxvd3MgYW5kIGRldGVjdCBwb3NzaWJs
ZSB1c2UtYWZ0ZXItZnJlZS4NCj4gU28gY29udmVydCBhdG9taWNfdCByZWYgY291bnRlcnMgdG8g
cmVmY291bnRfdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENodWhvbmcgWXVhbiA8aHNsZXN0ZXI5
NkBnbWFpbC5jb20+DQo+IC0tLQ0KPiBDaGFuZ2VzIGluIHYzOg0KPiAgIC0gTWVyZ2UgdjIgcGF0
Y2hlcyB0b2dldGhlci4NCj4gDQo+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9zcnFfY21k
LmMgICAgICAgICB8IDYgKysrLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvcXAuYyB8IDYgKysrLS0tDQo+ICBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgg
ICAgICAgICAgICAgICAgICB8IDMgKystDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgNyBkZWxldGlvbnMoLSkNCj4gDQoNCkxHVE0sIExlb24sIGxldCBtZSBrbm93IGlmIHlv
dSBhcmUgaGFwcHkgd2l0aCB0aGlzIHZlcnNpb24sIA0KdGhpcyBzaG91bGQgZ28gdG8gbWx4NS1u
ZXh0Lg0K
