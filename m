Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3092483A80
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfHFUnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:43:02 -0400
Received: from mail-eopbgr70070.outbound.protection.outlook.com ([40.107.7.70]:48206
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726068AbfHFUnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 16:43:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlVMYeM3Za9NXBpc8tVwsIKe45Je13FhqDhvoKYVN5fkpvs+713j5LeWTe+5awLsZvxao5skQgCqV0D+YyvffAwXENzp2nfQK2KToWw1unMXk7YQKxswpzFiSlzqN76UWcwwN88Kqfs2VotP2EPVhEXlHYh470qdHQAt8ypi9Rf0iQs9dO/nHcUGMWM9dQmniGyYmIOrpI0j/4LUMpd7Bq0KpyFBBdxXrfnQceGQAc3JjV7w4VujgB2ZWQatyGK9wQHAcnI5b+NY33Bgm0yuRNGj3V9e42zTNfj/vhfeqyH3tjvSAn3sZNZ8Kt02UyIde6kuAdFywLNwUHqALqaC3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RC6UTi8hbsNJx196SNdi2dODmCtlTPfqnbKPeSV3LE0=;
 b=LYii3s4ujERJ6ryXl6arML+ZLaeYDFyCLAOkUcper+BzY4PPdv1WOf8HecbNetL9c+ukP0BLQn3xyjPgfgfDg2x00G8YRUMj40XmJywe3o7QrRNxJk9zUrxj30/pgApDCzJ/VKTQkX/rv7p4QZK1DJ5q5HG6Hb6ihPCfUZDbFJc/Wa6ftvdpEi+xE80qPh6nT5+7aaCgEEcMo0Ov8pGgfZozdN66LLncmUyQRXJtxIi1Y82wQP8wxAaB7cx/QzCnGhar2NNVWHJ9Jy4ANFYij8rY+z3ZpXKVuti3/qmSfejs05y7CAY00jo/DddzOV0jEWqFHo6qp+iItPX7jpnAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RC6UTi8hbsNJx196SNdi2dODmCtlTPfqnbKPeSV3LE0=;
 b=OlW+pdsbh1SuPsaIb6okb2eFs/6u1VC5COXr8WzlLb5usC2dKtCbxgc5USilYKgRUTnck6F4JXu9KOP10pk5cl5mA6RId6MBdrfNNE2iokSh4pElliCopgWCj9qtxvyU1lHTzbVtH+owmNs/wiGXRavaoll/0O05IAo+WpFNX4Y=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2213.eurprd05.prod.outlook.com (10.168.58.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Tue, 6 Aug 2019 20:42:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 20:42:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Topic: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Index: AQHVSVIhSHjGbDfeSka9iay/Nq7XtqbunGYA
Date:   Tue, 6 Aug 2019 20:42:56 +0000
Message-ID: <aaf9680afe5c62d0cf71ff4382b66b3e4d735008.camel@mellanox.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
In-Reply-To: <20190802164828.20243-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e91cb3db-a096-47fa-18b7-08d71aaea9c1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2213;
x-ms-traffictypediagnostic: DB6PR0501MB2213:
x-microsoft-antispam-prvs: <DB6PR0501MB2213CE4EDF3D2748828AE692BED50@DB6PR0501MB2213.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(189003)(199004)(54906003)(25786009)(99286004)(2906002)(91956017)(36756003)(76116006)(86362001)(76176011)(2351001)(316002)(58126008)(1411001)(11346002)(446003)(71200400001)(2501003)(71190400001)(186003)(102836004)(6506007)(256004)(26005)(486006)(476003)(2616005)(64756008)(66556008)(66476007)(6436002)(6916009)(81156014)(81166006)(5640700003)(14454004)(8676002)(6512007)(4326008)(305945005)(6246003)(66446008)(7736002)(66946007)(229853002)(8936002)(53936002)(118296001)(5660300002)(66066001)(68736007)(1361003)(3846002)(6486002)(6116002)(4744005)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2213;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +3rTcz0Zl0/QDXt1GNSILPI7n2u6tyspYfL24+R4O28Bs71KQATACOqSHWu67z6pdcsGwqGaJ5ASF4TXX6DqgQXzGAfBCHKVdI2vgClOQVbOKhjPyX3q3Ej5hLoNrSZsYS1OqudqDhfB1JRRIqRGWflI8rZwkKlJpP/R3QsBDU3F+zTZEJAb3SU/YCOKQKWyUhd3AzuV4n2w50kqIxbNu7aHNOt1rvfnKTjeI8hYJuqZXZeVWh/4kEGyFPAv7T4Y+opuZej/Xgy81awG1iRgHeRhSmuCNg+EZ8oB142S6ylB3hROLj8f1MYRRMir8OdhplgyqzsMvBX9+ZUL0mCfDecSqfBLRzArfEvXTaxDY7E6hze0PmbPcApt+fSHbcWkQUTTFmuhYf+iGhYkUJBFJOGFbHAjXP6avu1SmN8jOwY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B85D9351BAF1A43924BC19ACC9325AC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e91cb3db-a096-47fa-18b7-08d71aaea9c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 20:42:56.9491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2213
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDE5LTA4LTAzIGF0IDAwOjQ4ICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+
IHJlZmNvdW50X3QgaXMgYmV0dGVyIGZvciByZWZlcmVuY2UgY291bnRlcnMgc2luY2UgaXRzDQo+
IGltcGxlbWVudGF0aW9uIGNhbiBwcmV2ZW50IG92ZXJmbG93cy4NCj4gU28gY29udmVydCBhdG9t
aWNfdCByZWYgY291bnRlcnMgdG8gcmVmY291bnRfdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENo
dWhvbmcgWXVhbiA8aHNsZXN0ZXI5NkBnbWFpbC5jb20+DQo+IC0tLQ0KPiBDaGFuZ2VzIGluIHYy
Og0KPiAgIC0gQWRkICNpbmNsdWRlLg0KPiANCg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxz
YWVlZG1AbWVsbGFub3guY29tPg0KDQpEYXZlLCB1cCB0byB5b3UgdGFrZSBpdCwgb3IgbGVhdmUg
aXQgdG8gbWUgOikuDQoNCg==
