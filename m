Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82783B08
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfHFV0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:26:01 -0400
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:11744
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbfHFV0B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 17:26:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wk72cbqzZm7yTdY4T7yv/tMHn3Ly+YQwJugsAP+ciWyc1fhzo6H/S8Zhjvpcpdy9s32IZwxewr8pHDwEo+DlyOQj9UkaVYRt5zOW4aGKxEaRtLZ8eaAYxuErUkPKnRFnspSrJclY9EVUlkfSUKtITGPExAg+M+l+YiIN2Tp7EM1r+JLZL3/ia8AI4choQ7/4fcWIFtHqwHjsM9rsbg3wNgfbE5qxxKc/3G2Sacx8W/fp/MLD3dkl2hKcpoYzLFx+n1qF8lm58kCJ2PWXzT5ccvT+B7W1tKV9I4fvsFKkIC5dbwd6sBX0wpqwyQaJMY7h3ZmLI7ogYfF1ajfZAD/E2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nql08hVIJI8Q0Xr00jlqwb993QQn2lnk0uN+7xKbuWs=;
 b=HJurNLf1XyEZlm3xBgYWJqzJzRug3V5Sf9TSZoTpmLiQ1fefWTgroZkBWdgTqnVgm2nrHeqmAcHYS9UT4qpAY0X1u6bzk6bxrPlsDgm+n6DlakreDEFLsRNm3cI31Dy49E1r1bU5OBXuhMSfW1HEG381zVZhX41Pa9umdi71m+XMJOdAkjQymvfkV/GcysQrOfESVAoonSQXqp3T47iVVi983VtwVaJoghtOAP2km013wFnP5Fg/2M7nutqLhEDfEe2zS9+WrA3l3qDGjpA5hLu5jemf7KZQij0qST/75pF9vguU4KApZg/vzyKjvzzoQ083CTIzzsPsuQ9clCImEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nql08hVIJI8Q0Xr00jlqwb993QQn2lnk0uN+7xKbuWs=;
 b=rJxitHnvRTmeQr51+WiYaxTT/hCnEmDHCKTWd7LEgGnu2drtQ0fR1+RuZq7NSpBWPesP7ZkvmkdPx2sa+IbexQczia5pOFAqO8xURKqGVir8FxliThlfQwR2uZ/eUTZrkummXejiJc1ceY+DQRaWlN9T+8zmwUZUQG/tJXHuWIg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Tue, 6 Aug 2019 21:25:56 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 21:25:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Topic: [PATCH v2] net/mlx5e: Use refcount_t for refcount
Thread-Index: AQHVSVIhSHjGbDfeSka9iay/Nq7XtqbunGYAgAABpgCAAApdgA==
Date:   Tue, 6 Aug 2019 21:25:55 +0000
Message-ID: <bd5df8d6fc9ed2be710dbca06739b7b580a309cc.camel@mellanox.com>
References: <20190802164828.20243-1-hslester96@gmail.com>
         <aaf9680afe5c62d0cf71ff4382b66b3e4d735008.camel@mellanox.com>
         <20190806.134848.2232719643712591918.davem@davemloft.net>
In-Reply-To: <20190806.134848.2232719643712591918.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93720661-8681-4eef-73c0-08d71ab4ab09
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-microsoft-antispam-prvs: <DB6PR0501MB268021EF0FAF2ABC2AF2CFADBED50@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(366004)(39860400002)(189003)(199004)(11346002)(4744005)(5640700003)(58126008)(66946007)(66556008)(66476007)(6246003)(4326008)(102836004)(26005)(6506007)(66446008)(64756008)(91956017)(316002)(6512007)(14454004)(86362001)(66066001)(2906002)(76116006)(6436002)(486006)(256004)(476003)(186003)(2616005)(229853002)(446003)(6486002)(118296001)(7736002)(478600001)(53936002)(81166006)(99286004)(81156014)(71200400001)(71190400001)(36756003)(1730700003)(5660300002)(2351001)(54906003)(305945005)(3846002)(8936002)(6116002)(8676002)(25786009)(68736007)(76176011)(6916009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5hvwgCPR7tCQIiblLL/hw6a/Cy5NbS8A9iz+MVhlyeQ4vCZiS3BZ2NCORyDNqlAfwSRpHfiTExNyeQCxvLecdt2SUL9SlpnSdV3T63jxUZ7IT7ea/IJ6Rs2woUoE772LAkTprwqJZ0Ng1SJ83X5zh47Sl+PyBIEGjfzWRp/UPtcnkGEVwE1qDPJVkx0n8p6IwroIBeSWti7wb7pBPSKJi7BFQXjOgHTKPgKwhLWX+muh7B1vMjZuBUVpn1FzlirxBhk34ah50BcXEf4wvpV+TMg54eet6JWiGKzadmVeAGJEUwFGJtBnqGZ1JVJDZQmRWu241YAqSIkWw40X7Dc8/+GA8WXCkFZ26RhbXxnPTvzw6UWWksNnSAoPe3qcSDvIWAh0UQpxjUXdvOMwyD2ttgl/J4nz7WlbIUegnFoNKW4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D727C5CD0484B418A0B9FE74C3E583A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93720661-8681-4eef-73c0-08d71ab4ab09
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 21:25:56.0204
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDEzOjQ4IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUdWUs
IDYgQXVnIDIwMTkgMjA6NDI6NTYgKzAwMDANCj4gDQo+ID4gT24gU2F0LCAyMDE5LTA4LTAzIGF0
IDAwOjQ4ICswODAwLCBDaHVob25nIFl1YW4gd3JvdGU6DQo+ID4gPiByZWZjb3VudF90IGlzIGJl
dHRlciBmb3IgcmVmZXJlbmNlIGNvdW50ZXJzIHNpbmNlIGl0cw0KPiA+ID4gaW1wbGVtZW50YXRp
b24gY2FuIHByZXZlbnQgb3ZlcmZsb3dzLg0KPiA+ID4gU28gY29udmVydCBhdG9taWNfdCByZWYg
Y291bnRlcnMgdG8gcmVmY291bnRfdC4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQ2h1
aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gQ2hhbmdl
cyBpbiB2MjoNCj4gPiA+ICAgLSBBZGQgI2luY2x1ZGUuDQo+ID4gPiANCj4gPiANCj4gPiBBY2tl
ZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gDQo+ID4gRGF2
ZSwgdXAgdG8geW91IHRha2UgaXQsIG9yIGxlYXZlIGl0IHRvIG1lIDopLg0KPiANCj4gUGxlYXNl
IHRha2UgaXQsIHRoYW5rIHlvdS4NCg0KT2ssIHJ1bm5pbmcgc29tZSBidWlsZCB0ZXN0cyB3aWxs
IGFwcGx5IHNob3J0bHkgdG8gbmV0LW5leHQtbWx4NS4NClRoYW5rcyBldmVyeW9uZSENCg==
