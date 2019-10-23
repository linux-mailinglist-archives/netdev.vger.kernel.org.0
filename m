Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735B9E235E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391410AbfJWTjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:39:13 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:11076
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732606AbfJWTjM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:39:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRAqVVD3KD52cVPk9jjsJL8+CsRMX/7m1nXVR7lGC6qSEyP2b+3njbTJNGj8sPzJ5XAOOgUu9ndvR/zHQL2ER08Dufx2wcaAvSTo9tUr4CZs3VsJ+8ovn8cxffZQw7rrEUpF+bo1NQcjKrVd2oNHm3jc/Ya4WhJTI2VPElUnyhJ6mWpf9anPRGAbQ41pA0bFOsOuIAG3ZxtW+UGPAbsr7JtvZNOLoffCAjpVOHHorwSbC+K+LH5FrfieejPy+HaptML6YzTW48//6hQ62SMHv1HvqP6Am5nGPz2WJZ2rwyv2lNrwlVF7QKJFwWTDGBdmn1YzR7adiEEjkRdOFRKwFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqUFhsmnZA+0QDEAvka7ma3Y2A0wptQPGMePJIEUXP8=;
 b=Is49qNH11dEHsFfxUvbnl6xdBydDPQLqrca5DmoD0g991pRdkYNalW+F/gEmzv/4kgJn0hj8iALfVpB1glfKEcQYaqLS6JfKxVx0TbD5sIZwpVLCudat2i2amNOc/B6YBHCdfA/o0EmAIgBAOLe36mrh+jLCiFwT6aXEuHlU6kC+w17+bfnok54XtXVHtD4KBIo5CXPh9J6C4/dCrNEBJwgD2JOpT9G7DdCTpSj6x3VO1hOFZ6q8pPJc/gYLpqySHWmuYQZY45qi1MusTNPBNQhTMuCqKsUEXGu3SQqd8GfBP/phIceqwNJLc1IYOGQDdsW89+WRJOLgVXvRh0WTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqUFhsmnZA+0QDEAvka7ma3Y2A0wptQPGMePJIEUXP8=;
 b=eYf7Ge4NasewJP3s+qixxCDxyY2+yhVr9JJfFUugZNx/5KIWCBK9d+VzMmVldntUvjJNklHQNLpNa9ZpHIebTPUGe6ofd9vz274jKQsVwkH2VYcdHREjppI2hZKYHWYUgOCK6CrnWLsklXR2DpJgzfKrZCWFIRHFUS7SjK/B7dA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5744.eurprd05.prod.outlook.com (20.178.121.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 19:36:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:36:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-nex V2 0/3] page_pool: API for numa node change handling
Thread-Topic: [PATCH net-nex V2 0/3] page_pool: API for numa node change
 handling
Thread-Index: AQHVidk6Ea56jG7m2EGnzBZhdABMig==
Date:   Wed, 23 Oct 2019 19:36:56 +0000
Message-ID: <20191023193632.26917-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 82d7f40c-c773-4127-95e9-08d757f05d22
x-ms-traffictypediagnostic: VI1PR05MB5744:|VI1PR05MB5744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5744A62572A84A1CF6970469BE6B0@VI1PR05MB5744.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(6506007)(66066001)(186003)(6116002)(25786009)(8676002)(3846002)(66446008)(14454004)(66476007)(36756003)(71190400001)(2616005)(71200400001)(478600001)(102836004)(107886003)(26005)(66556008)(99286004)(4326008)(52116002)(81156014)(8936002)(386003)(50226002)(6436002)(6486002)(81166006)(14444005)(1076003)(5660300002)(64756008)(6512007)(110136005)(486006)(256004)(2906002)(305945005)(7736002)(66946007)(54906003)(476003)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5744;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SEu9oK5quX4AMrYzh+SsR9IEHruCGWLwktUoyXWowUrN8J/q/cCOXp+CFwosaG9Mvw+ck1UIyVhn7GRukE1Wk/f6Q9z5wgR75NFVuclLM7kLNRlYotPqjXf+ouvFBA9RnN+di1FB3DT0s7yByW6dblJBrYK0/8ny6sKrQ0KjP2ycb1qVejyljMNNCZBJOS58t2ILrhiTQpmwq24E5DkCvhSwH1S5JSLe3au4kCW8h8hD8gT6NnXw7Vgx38Ho5E3G7RNfVt+UGfQU+kx3DnohddTf2ZDSD/kDYg8UK2p8YdS5hbxe+WuiZ17Cctl7mCv/Ldo/j0J+SUlyBX3cs3xnQufEWHQrTbwt4Syor3WVK4W2Tyr4RxhMxt1C3WQDKuTrVGFOlVEOPBmfA2mAC8RcyU1+qz7YwpNrSCb93DphmOt5t3IqJkSSsZ66lLRTGLm0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d7f40c-c773-4127-95e9-08d757f05d22
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:36:56.6457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HTrqIbR3+Z/NqOcrBXeG0QZiT1z18ws3HiHb3wGn1g2yC4gZabmJbz0DOcNx1FpuDvbx28AVncwLoAq8CTxlQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave & Jesper,

This series extends page pool API to allow page pool consumers to update
page pool numa node on the fly. This is required since on some systems,
rx rings irqs can migrate between numa nodes, due to irq balancer or user
defined scripts, current page pool has no way to know of such migration
and will keep allocating and holding on to pages from a wrong numa node,
which is bad for the consumer performance.

1) Add API to update numa node id of the page pool
Consumers will call this API to update the page pool numa node id.

2) Don't recycle non-reusable pages:
Page pool will check upon page return whether a page is suitable for
recycling or not.=20
 2.1) when it belongs to a different num node.
 2.2) when it was allocated under memory pressure.

3) mlx5 will use the new API to update page pool numa id on demand.

The series is a joint work between me and Jonathan, we tested it and it
proved itself worthy to avoid page allocator bottlenecks and improve
packet rate and cpu utilization significantly for the described
scenarios above.

Performance testing:
XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
while migrating rx ring irq from close to far numa:

mlx5 internal page cache was locally disabled to get pure page pool
results.

CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)

XDP Drop/TX single core:
NUMA  | XDP  | Before    | After
---------------------------------------
Close | Drop | 11   Mpps | 10.9 Mpps
Far   | Drop | 4.4  Mpps | 5.8  Mpps

Close | TX   | 6.5 Mpps  | 6.5 Mpps
Far   | TX   | 3.5 Mpps  | 4   Mpps

Improvement is about 30% drop packet rate, 15% tx packet rate for numa
far test.
No degradation for numa close tests.

TCP single/multi cpu/stream:
NUMA  | #cpu | Before  | After
--------------------------------------
Close | 1    | 18 Gbps | 18 Gbps
Far   | 1    | 15 Gbps | 18 Gbps
Close | 12   | 80 Gbps | 80 Gbps
Far   | 12   | 68 Gbps | 80 Gbps

In all test cases we see improvement for the far numa case, and no
impact on the close numa case.

v1->v2:
  - Drop last patch, as requested by Ilias and Jesper.
  - Fix documentation's performance numbers order.

Thanks,
Saeed.

---

Saeed Mahameed (3):
  page_pool: Add API to update numa node
  page_pool: Don't recycle non-reusable pages
  net/mlx5e: Rx, Update page pool numa node when changed

 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  3 +++
 include/net/page_pool.h                       |  7 ++++++
 include/trace/events/page_pool.h              | 22 +++++++++++++++++++
 net/core/page_pool.c                          | 22 ++++++++++++++++++-
 4 files changed, 53 insertions(+), 1 deletion(-)

--=20
2.21.0

