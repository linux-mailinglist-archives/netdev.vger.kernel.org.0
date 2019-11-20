Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A16610309B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKTAP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:15:29 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:50450
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727226AbfKTAP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 19:15:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRrrwyeFkdFx+TawXIA88xT7pi0Agnso/iwT2ZKWNh0uBO1lUUnsQANoHbrkRBYXD1/AF5xvXTlAaFL0HT9hRBjFHyxQ0dPB+eImbWRRpYmR7jyd7G6E3YdlYrHgTp61Zm8gnkGAd51D8O6Es2HbV4jhoPg/8zLpadAIj5bHv69+7NapisPzM0dDnxOwIt15dgpL5mFIXFagZP8nmvCKgdcmApJBUyS2CX6IIXrTbSJ5ZbD7nApz3e2rA6yS224EDo1ftCTvATC8VQ9zu+YPES9x56wYGgif19tst33o72lzFUGgMWbIRBAeGHD4ew6NzkGudxixFGjmFCjHoLGwaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w53b4wuOJS4p6492nG3Zz20WhPAcG6FevpBxQ/Lcqyo=;
 b=gCgozUZAXdmdwNF1EiSt00rG27Tls7nWSDK2lP+YdLgcfHtvFPJLlkYoXqcMWHZUUTRBRP1Z4PAhagxJAmW+CA5q204ePe567sZdXiM6mSVjIlPuObRfYoP5t2im2qeJr0NQwe81cfNmzcc0J5XGqJ4x649+0M0z2IVF3LXr15+YzUnCPchNjfXF0Bvcj6pFq+Tv/riQh8wUgjGUiqYlqo+aLCWNnDDU5taWjqrwOCYGLDJ/0LjUF80ZFH1nHTCWigzlQN8YFq4UzFZWGySa5+3+Z5u64g58iB64qIR6dkgQEOdszgI7IHdg8ixE3TPzomYfHHoiZxjmSJXuQE9eKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w53b4wuOJS4p6492nG3Zz20WhPAcG6FevpBxQ/Lcqyo=;
 b=IDOUhLsLStq522VRvW6P5H2xtrHwW8DILhzmJtwJtNYSEXc44KljOoMMAy404pPLYxLPmVXfnW4AXw626BUw9f5o2C6TMvXf93v4+0PITzltpSu3Z+A7v3FoHPBYdNVwcjPpXC3s3GEHITYPGPkyprAablCLyOyQI7NzueSng9o=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5378.eurprd05.prod.outlook.com (20.177.188.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 00:15:15 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4%6]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 00:15:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next V3 0/3] page_pool: API for numa node change handling
Thread-Topic: [PATCH net-next V3 0/3] page_pool: API for numa node change
 handling
Thread-Index: AQHVnzeUldfLnBUTe0q7mcdCU78m5Q==
Date:   Wed, 20 Nov 2019 00:15:14 +0000
Message-ID: <20191120001456.11170-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c92b7d7-d67c-41f0-02d2-08d76d4eb739
x-ms-traffictypediagnostic: AM6PR05MB5378:|AM6PR05MB5378:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5378785F6BA9E31D403E1A40BE4F0@AM6PR05MB5378.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(6116002)(3846002)(256004)(14444005)(66946007)(110136005)(107886003)(305945005)(81156014)(6506007)(386003)(81166006)(36756003)(6512007)(2906002)(54906003)(14454004)(71190400001)(71200400001)(316002)(7736002)(64756008)(66556008)(66476007)(66446008)(486006)(476003)(2616005)(102836004)(50226002)(99286004)(52116002)(186003)(5660300002)(6486002)(86362001)(478600001)(8936002)(6306002)(25786009)(6436002)(26005)(4326008)(1076003)(966005)(66066001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5378;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HCq96NQEuNjW8XDd1h65hvRe8ct/rRg9hGazoUOzg67/qlUH64DF4kKn8c6hQLhHP0H6LfCNLf6g167lcRjk1WbEiRbX0GM7iMHFTpitlmR5vksak2u/D3Xw6Xfkea4CMfU2G4N3CfYsNsYtkxByb1eDiIevCFgkO2DRbETzTB5GDNk0WK9fBdllo9xHdvS4j+XLS1qQvfVz9q1z7KvQ6L74bawajlmfw5/x4ZHyy5EywJ6gfz8Dvh1+tZJ3aqoZFEIhgyW9Y869XkT0H98HMRAgGj02Xws0ScOFMng8QJicM+shU6wY3ygQ45Iykl9ue3fXJfXlIMbcv3YD46QQYhY0FYrEqIvCzKWx1Kf3tUuzCGvtj/3SN01lJpPARlNbRz9raHXu0JMXjpziwfGQIR2k7t4KtIgp4IxbpjE4e1/i08WrVV8jtSC7fTpmK0HTVakXkjWDXkA0M7p6XZRn2bLFZNGdpk2AiXZ+1rz0IS8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c92b7d7-d67c-41f0-02d2-08d76d4eb739
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 00:15:14.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bxFFOUIht1NE67zdLMJtRWn+N3JPdncf2rWJlPXx+bEKyHC6qGfqT41RHvVvrhZNHSn8mbjXNtI4xXNdXRphqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Performance analysis and conclusions by Jesper [1]:
Impact on XDP drop x86_64 is inconclusive and shows only 0.3459ns
slow-down, as this is below measurement accuracy of system.

v2->v3:
 - Rebase on top of latest net-next and Jesper's page pool object
   release patchset [2]
 - No code changes
 - Performance analysis by Jesper added to the cover letter.

v1->v2:
  - Drop last patch, as requested by Ilias and Jesper.
  - Fix documentation's performance numbers order.

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_p=
ool04_inflight_changes.org#performance-notes
[2] https://patchwork.ozlabs.org/cover/1192098/

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

