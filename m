Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A82A510DCF6
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 08:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbfK3Hcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 02:32:45 -0500
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:43892
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbfK3Hco (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Nov 2019 02:32:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhHAbsc54XUevHByedkCg1MVLh7GyoaBswlmaGeCxQGdvZ3UsH7Jv6RZh1P/pCzHIlhYrRpRdZQE+5jUZFzbW6gVCQnSLAvoHehSIoctatTVoeg5CLpr3r+HsrEkXZ4dynQ2RTPrHPHBUQnbTkndroJmZ3YNlg/FvKXZhPoYsHwx2PMhgHAFAEc400n5szn70ZBjRUjMPXLsslRGyeGWjbdLQFHGQPvjAdbMDX2pTukmOwtnPrsvi9U+nVBTEBjCw5+7D29W0uuzMFxUA1iG/rN4SAO21Sqjudf3vfw31asEzL3dBJSuiE5nqU9ZJKrUXk6gvpkGr5lCeTll7T7KkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeY0I2g6RFhdmN6yqcuG4rlfiI0Yp1vurt4OViGrbBI=;
 b=X8m59HhQRW7RIabuES8uw+GWg8PmZJY5dxBJBhzylwRabRPFzWS2fKe3EKC/UY2UCPuLZM0IYWhlYztJBloPg3KyP1QAUJxSMWeEVGtnIhn9r5xoUHPl1UcgNLvdXaRlNBmECEY0L+Ej96avDrq9R5C3eJ25Wfrn9WUZHQzWJ4FHSOp1lWRN6zu2HnKOYKK0TlaLU592dusCQqSP134bPPMTWxH0a/i9p8QmbZJelL4x62+8uZRDALP9cBW+Xv7Ew7LyiT807tjOcR5sHd7LAWYqq6CGjs7Cm9XXoTe1k+Hi/y27yaG1vTAmhAkq8qSCnKjJHGhtkYg5sn5ZUOUGMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeY0I2g6RFhdmN6yqcuG4rlfiI0Yp1vurt4OViGrbBI=;
 b=q87TpYmkMXXyue2VjOY26FEFWnLB6Gnxh/k3nTQDz5RvLnC0CE5+9cL9qdh6Xlo+d92xzwPZjNFbTHorme5XQvg181M8t2r5RyMiiPJjoPXSLJhK3qv9YZHzYVFMrcJfhH6PjXPhqFxEoogqV6FPQwlLlAgtDm5JGxmnGCYhnDw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3421.eurprd05.prod.outlook.com (10.170.239.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Sat, 30 Nov 2019 07:32:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2495.014; Sat, 30 Nov 2019
 07:32:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Oz Shlomo <ozsh@mellanox.com>, Eli Cohen <eli@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "leon@kernel.org" <leon@kernel.org>, Roi Dayan <roid@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix build error without IPV6
Thread-Topic: [PATCH] net/mlx5e: Fix build error without IPV6
Thread-Index: AQHVpSZsTv6MbE28T0uVnnRWLx0w9KejVl6A
Date:   Sat, 30 Nov 2019 07:32:38 +0000
Message-ID: <0225e67bfeedebca1dc5d1daef12f2cdc13452d4.camel@mellanox.com>
References: <20191127132700.25872-1-yuehaibing@huawei.com>
In-Reply-To: <20191127132700.25872-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 20592e94-ca01-4a5f-33b5-08d775677a26
x-ms-traffictypediagnostic: VI1PR05MB3421:|VI1PR05MB3421:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB34219DF3077D1856B3D76B89BE410@VI1PR05MB3421.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02379661A3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(396003)(346002)(376002)(366004)(136003)(189003)(199004)(102836004)(6506007)(110136005)(4326008)(256004)(5660300002)(6246003)(186003)(54906003)(66066001)(6512007)(305945005)(7736002)(6636002)(3846002)(6116002)(66556008)(118296001)(316002)(14454004)(6436002)(64756008)(26005)(2616005)(66446008)(8936002)(71190400001)(2501003)(478600001)(66946007)(66476007)(71200400001)(36756003)(76176011)(81166006)(2906002)(4744005)(6486002)(91956017)(86362001)(76116006)(4001150100001)(11346002)(81156014)(25786009)(446003)(58126008)(8676002)(99286004)(229853002)(2201001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3421;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xlcu1QyYzt4xCOMwbMdRI6F1+5rO3kpaQ6sE7t+WG8gZhEb+Nz0Hx1HOpG416kiEIWzsSOb951wNDy4FZAFKHCKsSbosXv9h17gLHJDYfSUFjvG7fDZCgx6RfdlNEiJuZyAfCWe9avFOrE27hZF1kMZQjA1CP+jrcsItKvYCeRL/E/1nWzMUoHp2UgefFPmUkJL05rgKIkDpvl2w8glEehOMU1x9jQou8G6EB1QSrxIsfTeok5x/x1fTGP/uMSJQU/9Y8B8Dyur6cHsvpqGJHgdPlkd6Aqy3YAmjG4YNH7IihNmmRgpF7MVpDNvJ1lrDDu0Jao7pQFUaRH/Ftd8VO3rRfOuh17iJmi0NjFflpNNS1zW7N++jzez0BfWZZFpzRazXEnZU2vif0jSN/SmUBHkzwb46sDslo2cq2JCI911cHvyiuljIWlk7dUILgPGq
Content-Type: text/plain; charset="utf-8"
Content-ID: <483D765392B63443A76D76282BB220F0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20592e94-ca01-4a5f-33b5-08d775677a26
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2019 07:32:38.6490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 455zh+4+IE/sj1mtSMdKIM2dfmD99rDPRM9uyi9sedMG+jzlaj6cmKvD29Cwhi1etwXi1mo6k66Xyim7D9aydw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3421
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTExLTI3IGF0IDIxOjI3ICswODAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBJ
ZiBJUFY2IGlzIG5vdCBzZXQgYW5kIENPTkZJR19NTFg1X0VTV0lUQ0ggaXMgeSwNCj4gYnVpbGRp
bmcgZmFpbHM6DQo+IA0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUv
ZW4vdGNfdHVuLmM6MzIyOjU6IGVycm9yOg0KPiByZWRlZmluaXRpb24gb2YgbWx4NWVfdGNfdHVu
X2NyZWF0ZV9oZWFkZXJfaXB2Ng0KPiAgaW50IG1seDVlX3RjX3R1bl9jcmVhdGVfaGVhZGVyX2lw
djYoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQo+ICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fg0KPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20NCj4gZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3RjX3R1bi5jOjc6MDoNCj4gZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3RjX3R1bi5oOjY3OjE6IG5vdGU6DQo+IHByZXZp
b3VzIGRlZmluaXRpb24gb2YgbWx4NWVfdGNfdHVuX2NyZWF0ZV9oZWFkZXJfaXB2NiB3YXMgaGVy
ZQ0KPiAgbWx4NWVfdGNfdHVuX2NyZWF0ZV9oZWFkZXJfaXB2NihzdHJ1Y3QgbWx4NWVfcHJpdiAq
cHJpdiwNCj4gIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4NCj4gDQo+IFVzZSAjaWZk
ZWYgdG8gZ3VhcmQgdGhpcywgYWxzbyBtb3ZlIG1seDVlX3JvdXRlX2xvb2t1cF9pcHY2DQo+IHRv
IGNsZWFudXAgdW51c2VkIHdhcm5pbmcuDQo+IA0KPiBSZXBvcnRlZC1ieTogSHVsayBSb2JvdCA8
aHVsa2NpQGh1YXdlaS5jb20+DQo+IEZpeGVzOiBlNjg5ZTk5OGUxMDIgKCJuZXQvbWx4NWU6IFRD
LCBTdHViIG91dCBpcHY2IHR1biBjcmVhdGUgaGVhZGVyDQo+IGZ1bmN0aW9uIikNCj4gU2lnbmVk
LW9mZi1ieTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KDQpBY2tlZC1ieTog
U2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQoNCg==
