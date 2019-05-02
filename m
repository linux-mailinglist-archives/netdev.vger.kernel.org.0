Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5967C115AC
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfEBIpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:45:06 -0400
Received: from mail-eopbgr20068.outbound.protection.outlook.com ([40.107.2.68]:26597
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfEBIpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REQElg20qAbYRs2veFouFWQo4EJT+BLD7/xhiQYvHHA=;
 b=XMBZLtjW7aylmMrCHkUtQGyzoDYiFdgPIsKFpN51tteiSx3E8iJCSD0qeWUV5eK0C8l6yy5FW/tnu5VY+dTnKS948esVUBGMbBcYkAk0EOKcY0cfsbPXhUsyHjeTPj3pzGnG4RsLW7B/OKfP/ytqjg16vTEE6openhbrgHF9kVA=
Received: from AM6PR05MB5288.eurprd05.prod.outlook.com (20.177.196.225) by
 AM6PR05MB5505.eurprd05.prod.outlook.com (20.177.188.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Thu, 2 May 2019 08:45:02 +0000
Received: from AM6PR05MB5288.eurprd05.prod.outlook.com
 ([fe80::ac0c:21b7:bdfa:c4e]) by AM6PR05MB5288.eurprd05.prod.outlook.com
 ([fe80::ac0c:21b7:bdfa:c4e%6]) with mapi id 15.20.1856.008; Thu, 2 May 2019
 08:45:02 +0000
From:   Tal Gilboa <talgi@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Idan Burstein <idanb@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-for-next 0/9] drivers/infiniband: Introduce rdma_dim
Thread-Topic: [PATCH rdma-for-next 0/9] drivers/infiniband: Introduce rdma_dim
Thread-Index: AQHVACyKoTvknlLO7kOSxA4Fp6QZcKZWbquAgAEXiQA=
Date:   Thu, 2 May 2019 08:45:02 +0000
Message-ID: <a6ca622e-9203-e69c-8d34-22e151529f0a@mellanox.com>
References: <1556721879-35987-1-git-send-email-talgi@mellanox.com>
 <20190501160409.GA15547@ziepe.ca>
In-Reply-To: <20190501160409.GA15547@ziepe.ca>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: AM0PR01CA0031.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::44) To AM6PR05MB5288.eurprd05.prod.outlook.com
 (2603:10a6:20b:64::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=talgi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 12a16f7d-6b8a-4ea9-5ca7-08d6ceda7758
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5505;
x-ms-traffictypediagnostic: AM6PR05MB5505:
x-microsoft-antispam-prvs: <AM6PR05MB5505287124D7629262B039FDD2340@AM6PR05MB5505.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0025434D2D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(376002)(366004)(39860400002)(396003)(189003)(199004)(3846002)(86362001)(36756003)(476003)(4744005)(186003)(6116002)(31686004)(31696002)(229853002)(53936002)(8936002)(8676002)(14454004)(81166006)(6512007)(81156014)(6486002)(26005)(6436002)(256004)(66066001)(102836004)(66446008)(54906003)(478600001)(6246003)(5660300002)(25786009)(7736002)(305945005)(53546011)(6506007)(68736007)(486006)(6916009)(71200400001)(71190400001)(99286004)(4326008)(11346002)(64756008)(2616005)(66946007)(76176011)(446003)(66476007)(386003)(52116002)(2906002)(73956011)(316002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5505;H:AM6PR05MB5288.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 89pzj+9oh17BGfaN2OUsHWlnzZ8zT5REdbslC2vSIrK3TXE1Bx7TPTibFpxFsDRgLMgsMCrpN3St/U4Lrdr1+7avgHxNdf7mdQFXGceTqWHKnnPlKnd/7oBKy2jKZDD+QQ2DNZi92/sAjBcO/DyDwjSuSiYD+jQpiHLFg8gfbu3g4JCkUnHXz3FhG2cuHTFW76XvzNrsasr4z2ZPajfxT3VS5nD6+wbUkGEimCZ+52kfSARgGD96kZty0/OoFsT5Vchmw9vM7v3qlzXDU+NrhqMLmkbPw0ZWuSlGk/R+qDG8efY7aDfhH5H9GS/5GinpwNqmi5R7m9lm0qzFKesePnRNrQt8EPy4P0ohF3AwYa0E2AdURfVUsXVD43A039o13BDYSFhK2LP54Ljjuxhop+aGnbeLROoR33IiTETUzcM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22854B5815F29D45B77BE94ABAD1FC31@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12a16f7d-6b8a-4ea9-5ca7-08d6ceda7758
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2019 08:45:02.3348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5505
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8xLzIwMTkgNzowNCBQTSwgSmFzb24gR3VudGhvcnBlIHdyb3RlOg0KPiANCj4gQSBsb3Qg
b2YgdGhpcyBpcyB0b3VjaGluZyBuZXRkZXYsIHdoeSB3YXNuJ3QgbmV0ZGV2IGNjJ2Q/DQo+IA0K
PiBXaG8gaXMgc3VwcG9zZWQgdG8gbWVyZ2UgdGhpcz8NCj4gDQo+IEkgdGhpbmsgeW91IG5lZWQg
dG8gdGFrZSB0d28gc3RlcHMgYW5kIGhhdmUgbmV0ZGV2IG1lcmdlIHRoZSBhYm92ZQ0KPiBwYXJ0
IGFuZCB0aGVuIHNlbmQgdGhlIHNpbmdsZSBwYXRjaCB0byBSRE1BIGZvciB0aGUgbGFzdCBwYXJ0
LCBJIGRvbid0DQo+IHJlYWxseSB3YW50IHRvIHRha2Ugc28gbXVjaCBuZXRkZXYgY29kZSBoZXJl
Lg0KDQpPaywgSSdsbCBzdWJtaXQgdGhlIGZpcnN0IDcgcGF0Y2hlcyB0byBuZXRkZXYgYW5kIHRo
ZSAyIFJETUEgc3BlY2lmaWMgDQpwYXRjaGVzIHdpbGwgYmUgc3VibWl0dGVkIG9uIHRvcCBvZiB0
aGVtLg0KDQo+IA0KPiBUaGUgbWFpbnRhaW5lcnMgZmlsZSBzaG91bGQgYWxzbyBoYXZlIHNvbWUg
aW5kaWNhdGlvbiB3aGljaCB0cmVlDQo+IHBhdGNoZXMgZm9yIGxpYi9kaW0vKiB0aGlzIHNob3Vs
ZCBnbyB0aHJvdWdoLi4NCj4gDQo+IEphc29uDQo+IA0K
