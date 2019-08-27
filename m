Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC489F598
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfH0Vv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:51:58 -0400
Received: from mail-eopbgr00040.outbound.protection.outlook.com ([40.107.0.40]:11295
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfH0Vv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 17:51:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXCha5WGDHeBDUq4/zvGmmLCbw8n3ujnSbr/lt9lCm0GzNhR4fZOX18jq0jexrAwd9kTEhb5BkB5FP9qzT8nb9z34whg9EwMgaYabUhVK4Xroib153R7JfbVTBlMPTPQo3Vr3QSVy2dl0B9z3Oqa8wOacxjEOMGWeSt9oZV+XlRLtr5CyKx3sq22CkTJjFWvh9TaAeU1vzs2mI0ZWvwga4NY/mNdkEiq7E3OaLmPVpyXOq00kprIKvJX1IFVje9KDSmf7QEbq4MlJYHFGWdmYkRDb0RRVHHPcfkwZ3wlQWmBDgor54AhCHF1/j+bDlLuNYK2PYkUGh6HOp83Hjpmsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28XXo6l5g+sEORBSkSVPPtglv6gsftJyZkcePrSe9DU=;
 b=gWEOVWyuu2EF1MLKyrGZj+hQuzyRVnwcyFz6plSJzZ2yD7FiNSc242dRpJGg+hjX9En3anOeuJQnu474O5isXZNJs4fQ70EMqck2PE0dtHN3s5sljNy57P8s7/rXBEJE1QTozfd7Zy2MfwZxi3jewI8j8l8ojM6lUXhPg9vqA8i88dB9VHciC+e6tsa+wLmub6pYGXZ66yXsgRxhme2BqOf/9wLzMfQV4OKUBRxTIgUhdR3XZBkKOns2YbIDDWDBSapsXefAWTdkB18OTisH0JkgstgAHDL/7YtXiM5kMMP4aVU74NSVZjwfCe9aYh3dVLgOa6ScCLEOIPWB3Ge+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=28XXo6l5g+sEORBSkSVPPtglv6gsftJyZkcePrSe9DU=;
 b=UDWWLfCr42qKIkmfc2VUaL/weISiIClGE/JcTVULM7/xIK3wTQKZwZfQ7iS3pZ6lB6avjzMyyE6X1TIl+Ybu1hNUu/OY1Gs2n1h6XjRti2Nx6S1mMbC616K0p8OlANcXFdR3YdACK4XXuiNufBprnyfhxBJwRiqSQ3vrCUyltQE=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2384.eurprd05.prod.outlook.com (10.168.135.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 21:51:54 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Tue, 27 Aug 2019
 21:51:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "cai@lca.pw" <cai@lca.pw>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Thread-Topic: [PATCH] net/mlx5: fix a -Wstringop-truncation warning
Thread-Index: AQHVWezn79S9mYXS9UOCwXmOlPmrCacPj2qA
Date:   Tue, 27 Aug 2019 21:51:53 +0000
Message-ID: <5332ef7927d759dbf0f07ed0dc082fc5d4615e91.camel@mellanox.com>
References: <1566590183-9898-1-git-send-email-cai@lca.pw>
In-Reply-To: <1566590183-9898-1-git-send-email-cai@lca.pw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2d327f1-e5e9-4fa6-d6a6-08d72b38c624
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2384;
x-ms-traffictypediagnostic: VI1PR0501MB2384:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2384FA3990E6FC9793F3987EBEA00@VI1PR0501MB2384.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(189003)(199004)(478600001)(5660300002)(2616005)(3846002)(66066001)(486006)(2501003)(25786009)(7736002)(305945005)(476003)(76116006)(81156014)(81166006)(1730700003)(36756003)(66476007)(91956017)(66946007)(66446008)(64756008)(14454004)(58126008)(2351001)(316002)(54906003)(118296001)(6486002)(6116002)(76176011)(99286004)(8676002)(66556008)(71190400001)(5640700003)(4326008)(6246003)(71200400001)(102836004)(186003)(446003)(11346002)(6506007)(229853002)(6916009)(26005)(256004)(8936002)(14444005)(53936002)(2906002)(86362001)(6512007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2384;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3TGSQYNHIwAE8Q7F3F6KfNqkGAkHPfTPz/z227joerud9EiPgY8Aes9Ek+bq3Y9McWupkD4ylKF4XuxRp59FNszGBwMvYVHLmEBfS1AZfm0EGU/C+pDrNlGrehJplIQ6DvRw9mov+WrhyOociL+BCWTFHoYao65Kb0WMMZMtYVkazmJBwjrkF9iM37q2WZjbGM4CUAGL90vmX8PqGb0napfiaJk9fVGAY+moZDC+zLuI1/X82v56toQGWD+KuG7wnqpJziPyn40p89/ZRPYTmSlAyKRorTUbotwowU8u3DpIRjwmRKHjyv8tHPI4/oPe/FKzFDAQY0V1YlVoTDK5SvAaa88qgAQbfc4YLZBR/AsHTAkwS/RVZte/8wHFQSiCxYjyyFixonBr0IP/yYP2Gi3DGCEL203ctDRKFH6ftgY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84B1A0ED4C5E1B4D8D800C58699CA843@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d327f1-e5e9-4fa6-d6a6-08d72b38c624
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 21:51:53.7411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQMeifwmCED300QbHbGjG5+r3eKoiJlD1mitSw8zTFYRqehDExu4Oq4btWsknA+JKwwxw2I1+bKtSjoFDiPiiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2384
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA4LTIzIGF0IDE1OjU2IC0wNDAwLCBRaWFuIENhaSB3cm90ZToNCj4gSW4g
ZmlsZSBpbmNsdWRlZCBmcm9tIC4vYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL3BhY2EuaDoxNSwN
Cj4gICAgICAgICAgICAgICAgICBmcm9tIC4vYXJjaC9wb3dlcnBjL2luY2x1ZGUvYXNtL2N1cnJl
bnQuaDoxMywNCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC90aHJlYWRf
aW5mby5oOjIxLA0KPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2FzbS1nZW5lcmlj
L3ByZWVtcHQuaDo1LA0KPiAgICAgICAgICAgICAgICAgIGZyb20NCj4gLi9hcmNoL3Bvd2VycGMv
aW5jbHVkZS9nZW5lcmF0ZWQvYXNtL3ByZWVtcHQuaDoxLA0KPiAgICAgICAgICAgICAgICAgIGZy
b20gLi9pbmNsdWRlL2xpbnV4L3ByZWVtcHQuaDo3OCwNCj4gICAgICAgICAgICAgICAgICBmcm9t
IC4vaW5jbHVkZS9saW51eC9zcGlubG9jay5oOjUxLA0KPiAgICAgICAgICAgICAgICAgIGZyb20g
Li9pbmNsdWRlL2xpbnV4L3dhaXQuaDo5LA0KPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNs
dWRlL2xpbnV4L2NvbXBsZXRpb24uaDoxMiwNCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5j
bHVkZS9saW51eC9tbHg1L2RyaXZlci5oOjM3LA0KPiAgICAgICAgICAgICAgICAgIGZyb20NCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9lcS5oOjYsDQo+ICAg
ICAgICAgICAgICAgICAgZnJvbQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZGlhZy9md190cmFjZXIuYzozMzoNCj4gSW4gZnVuY3Rpb24gJ3N0cm5jcHknLA0KPiAg
ICAgaW5saW5lZCBmcm9tICdtbHg1X2Z3X3RyYWNlcl9zYXZlX3RyYWNlJyBhdA0KPiBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYzo1NDk6MiwN
Cj4gICAgIGlubGluZWQgZnJvbSAnbWx4NV90cmFjZXJfcHJpbnRfdHJhY2UnIGF0DQo+IGRyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kaWFnL2Z3X3RyYWNlci5jOjU3NDoy
Og0KPiAuL2luY2x1ZGUvbGludXgvc3RyaW5nLmg6MzA1Ojk6IHdhcm5pbmc6ICdfX2J1aWx0aW5f
c3RybmNweScgb3V0cHV0DQo+IG1heQ0KPiBiZSB0cnVuY2F0ZWQgY29weWluZyAyNTYgYnl0ZXMg
ZnJvbSBhIHN0cmluZyBvZiBsZW5ndGggNTExDQo+IFstV3N0cmluZ29wLXRydW5jYXRpb25dDQo+
ICAgcmV0dXJuIF9fYnVpbHRpbl9zdHJuY3B5KHAsIHEsIHNpemUpOw0KPiAgICAgICAgICBefn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiANCj4gRml4IGl0IGJ5IHVzaW5nIHRoZSBuZXcg
c3Ryc2NweV9wYWQoKSBzaW5jZSB0aGUgY29tbWl0IDQ1OGEzYmY4MmRmNA0KPiAoImxpYi9zdHJp
bmc6IEFkZCBzdHJzY3B5X3BhZCgpIGZ1bmN0aW9uIikgd2hpY2ggd2lsbCBhbHdheXMNCj4gTlVM
LXRlcm1pbmF0ZSB0aGUgc3RyaW5nLCBhbmQgYXZvaWQgcG9zc2libHkgbGVhayBkYXRhIHRocm91
Z2ggdGhlDQo+IHJpbmcNCj4gYnVmZmVyIHdoZXJlIG5vbi1hZG1pbiBhY2NvdW50IG1pZ2h0IGVu
YWJsZSB0aGVzZSBldmVudHMgdGhyb3VnaA0KPiBwZXJmLg0KPiANCj4gRml4ZXM6IGZkMTQ4M2Zl
MWY5ZiAoIm5ldC9tbHg1OiBBZGQgc3VwcG9ydCBmb3IgRlcgcmVwb3J0ZXIgZHVtcCIpDQo+IFNp
Z25lZC1vZmYtYnk6IFFpYW4gQ2FpIDxjYWlAbGNhLnB3Pg0KPiANCg0KQXBwbGllZCB0byBtbHg1
LW5leHQsIFRoYW5rcyAhDQo=
