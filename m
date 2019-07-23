Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F83720D4
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 22:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732614AbfGWUeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 16:34:11 -0400
Received: from mail-eopbgr10073.outbound.protection.outlook.com ([40.107.1.73]:64736
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729564AbfGWUeK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 16:34:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flspn/vsxkYGT8XVsf03yIyuXrV1jjkCouECuaR18MgH4mAIz6J9L4CAJayckPWl8cxB1sVCy1v0F5spdCXXhQ2jOa8yzJ1dRDfELVzNmWz2JEDBDwHLU0wjhbAhX3qhQcEZPbEBNyQE8jp3Z7nLjpi4ckmK7bgCAI2vRYoFa5Jrw9KJkWWe/5HfS/VAZEO4OmdRayBz1mPEXawU7oft4FxGl3j/mPzy89v6cKfaMMGAVlj5fG8TGQEYwmcoX/67tWuB5+xfqlQu3hqZX1jdguiuvuOUb+XfxB8j7X3HmIY6r7GeI986yYANAgwy9SR+OHCOaG+tJTLFjyiZAGbgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRXDRolrgS9Odwn+yOinm51yas6drLvWLR0UunQKy4k=;
 b=CZXo2agGYMhPpCNhhaQhaBqxzgmBFzNx487if13HHcW7eGyX1f5K9DmquDMfvwTSAra6IfUDA6cSCxEmRUZtkO07ExRK8+UQut8WPJ5X0ERQYDECBCa/g+nTe36T5TpbcDxRuBp6o18chysFvXZnuaJAYiwSLGiOPQPgQKwWmqsfSBcyT3tfBhzTOqGKpFfG4kSnEx4J2a9HRQDAMrltlFKTwW613jOCR0yNgc0EcppUpiQas8jMpDNQruDZD/hsDNv9s1vSQPShjdyBsXmoZcfxmc3jpmjO0CjCirmmwxgTDYDvgFt6CIM9LpZ2vxglBOAFMTDBHGwWIjjFFh88cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRXDRolrgS9Odwn+yOinm51yas6drLvWLR0UunQKy4k=;
 b=blnjUyLsNEECNUtvP/lmRTKOomqnfzaZwLqwl0R7ibJEYqPGzcOErYSf0vXFdz/WmZfErCt6Xag3AAdv1xIp98gje8BJCIYYv9hn/AlcLuh79xWS6JggX4bVfgzzjLWKN5SDCJEBcXbDmK2tv6Rlrs+pnhslXxXGY6nNVbbHTV4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2231.eurprd05.prod.outlook.com (10.168.56.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Tue, 23 Jul 2019 20:34:07 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 20:34:07 +0000
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
Thread-Index: AQHVQSYU/XFyboT9FUmZvXfwV+sFwqbYhqUAgAAJ5ACAABAxgIAACOkA
Date:   Tue, 23 Jul 2019 20:34:07 +0000
Message-ID: <702add119e2059101ce67b7e153b5ad0ef0df288.camel@mellanox.com>
References: <20190723071255.6588-1-leon@kernel.org>
         <20190723.112850.610952032088764951.davem@davemloft.net>
         <20190723190414.GU5125@mtr-leonro.mtl.com>
         <20190723.130211.1967999203654051483.davem@davemloft.net>
In-Reply-To: <20190723.130211.1967999203654051483.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8cfaac19-6a04-4f6e-ff42-08d70fad1c3a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2231;
x-ms-traffictypediagnostic: DB6PR0501MB2231:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB2231D3E8CEA06FF4BF7595BEBEC70@DB6PR0501MB2231.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(199004)(189003)(110136005)(58126008)(107886003)(6486002)(66556008)(76116006)(305945005)(64756008)(66476007)(66446008)(66946007)(36756003)(316002)(66066001)(6436002)(54906003)(25786009)(118296001)(4744005)(478600001)(476003)(446003)(102836004)(6512007)(2501003)(2906002)(3846002)(6246003)(68736007)(6506007)(53936002)(486006)(99286004)(7736002)(966005)(2616005)(229853002)(5660300002)(76176011)(81166006)(26005)(86362001)(8676002)(14454004)(81156014)(186003)(71200400001)(71190400001)(256004)(6306002)(8936002)(4326008)(11346002)(91956017)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2231;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kCjLp5YCMsSEWe5JnXnbvlWLZEVSwSrgmODIRRLVRXrDBCArBKj/zikT8K3PBUOcB9wELZAqlj68iTdY94xIltFKsezwAZJngB3huVO/tMIDa7HaMeb+wt0x2Glij1Vq2Kw9D32m7zuG6CxLUvPNxKSo0k28qNmPc5k+UPERwPDzv29DVjmL9V6q/bPPcqHyF/LkBLSYzRa8L7R0nN4Ssv7h+CUzzJG+KJ2Di4/3WSF8PfdqqPyu14yWk6aSObzeFn6XXjIhM5B4uYE0gf/GrACNHfkWdh5+MW7sCniIS4+7UWerFF+tuwLkhSQGBvHXHGMT54h+miITYSjjZc//Pvn2QiU2+B7q7p6A8II8c6ZFv3VnsrBy025pnlX+wX10BSyiD3V3G0Sn28EgKzBBl5JY6UxCAwhtvOQyRE4zv6s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <54F6A43BFBCD0C42A68D3277DE768FCC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cfaac19-6a04-4f6e-ff42-08d70fad1c3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 20:34:07.1692
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

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDEzOjAyIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IExlb24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBEYXRlOiBUdWUsIDIz
IEp1bCAyMDE5IDIyOjA0OjE0ICswMzAwDQo+IA0KPiA+IFRoZSBpbnRlbnRpb24gd2FzIHRvIGhh
dmUgdGhpcyBwYXRjaCBpbiBzaGFyZWQgbWx4NSBicmFuY2gsIHdoaWNoDQo+ID4gaXMNCj4gPiBw
aWNrZWQgYnkgUkRNQSB0b28uIFRoaXMgIkNjOiBzdGFibGVALi4uIiB0b2dldGhlciB3aXRoIG1l
cmdlDQo+ID4gdGhyb3VnaA0KPiA+IFJETUEgd2lsbCBlbnN1cmUgdGhhdCBzdWNoIHBhdGNoIHdp
bGwgYmUgcGFydCBvZiBzdGFibGUNCj4gPiBhdXRvbWF0aWNhbGx5Lg0KPiANCj4gV2h5IHdvdWxk
bid0IGl0IGNvbWUgdmlhIFNhZWVkJ3MgdXN1YWwgbWx4NSBidWcgZml4IHB1bGwgcmVxdWVzdHMg
dG8NCj4gbWU/DQoNClRoYXQgc2hvdWxkIGhhdmUgYmVlbiB0aGUgcGxhbiBpbiBmaXJzdCBwbGFj
ZSwgaSB3aWxsIGhhbmRsZSB0aGlzLA0KdGhhbmtzIERhdmUgYW5kIHNvcnJ5IGZvciBhbnkgaW5j
b252ZW5pZW5jZS4NCg0KSSB3aWxsIGFwcGx5IHRoaXMgcGF0Y2ggdG8gbXkgKG1seDUpIG5ldCBx
dWV1ZSwgd2lsbCBzdWJtaXQgdG8gbmV0DQpzaG9ydGx5Lg0KDQpMZW9uIGNhbiBtZXJnZSB0aGUg
bmV4dCAtcmMgd2hlbiB0aGlzIHBhdGNoIGxhbmRzIHRoZXJlLg0KbWVhbndoaWxlLCBMZW9uIGNh
biBhbHNvIG1lcmdlIG15IChtbHg1KSBuZXQgcXVldWUgd2hpY2ggaXMgYWx3YXlzDQpiYXNlZCBv
biBsYXRlc3QgLXJjLg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvc2FlZWQvbGludXguZ2l0L2xvZy8/aD1uZXQtbWx4NQ0KDQoNCg==
