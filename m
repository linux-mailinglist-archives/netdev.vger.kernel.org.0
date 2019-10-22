Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF6BDFCD2
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387628AbfJVEpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:45:04 -0400
Received: from mail-eopbgr10042.outbound.protection.outlook.com ([40.107.1.42]:48860
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387462AbfJVEpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 00:45:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQszkbK1W3dFog+alL3cNY1CUZN/J5Aw94XVVCSUGpw1jIuPw1XfgkbsNgcc41yULBE4idZ1XG12IfhNiykDFvcbsmITUUCNg5R5x/NhfBHNWi0gPNCdUnaIoiaGe6xT8dzWXrIxPP8i+2BnSTwQdKGRf1XkKpjeIIbxHRhdBw0VZMkFAxlx5p6x6c/SEVBwZwI6kMYGFddQstsOWBXtuOLwJo3dA9Cernuny9EDjah+k3hEEIBm9HlGdCSxnzls0vowpW29SE54x1tcv5bZkoRrbwnmd9/PBUGkEv6amT9K1nt6EyjONS2Qeh2vQuX9Z8p4RGgddLdejevZNtjkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTQmgv4wJy+/CFOmryHbT8mso4Q5XTrcLs9uTOdj0Yg=;
 b=GUotavVm/eKKVtcxs25LjlydBZCAaWRqmPSsR91ZaOrwaahM1QxFRpue/4mLTDutsDfaDwS7Cy5MEG4c/GJa8X0X3vT+IaiMbXbtYqg3FKfusRl+k52k7QGbSIpXeiOLz0/3Pa60SJBue6AWjWPRyXRQdv03RuRPIrehZ0DZrIPB5K9t8VN7F2VTaUPODQQ02liDmY0WyzE981lFC6zk1kjBgF+NokHio8tYlB7jmGKMuwdY/KPvmzTxGOroqlcBrTo2aIGkk7n1zZqZrQSBATqjbOx9p/E3O0nop/t7xnZ0EtcqQtZi0PiKohAuAEnPq3/x7whHzoQW6XOcTT0DYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTQmgv4wJy+/CFOmryHbT8mso4Q5XTrcLs9uTOdj0Yg=;
 b=QDrj0mrjWchQtyfAO3iNE+7K4MydHtMyQ6w7fVrMlqfjSZOuX+w8I3GacNIKnIsnfNbj+BxEvRd5CWSIrdwox4lUu9hgjdwjHG0hz6uMyuOTRLW1mKF1S2FbAqgC9v/tEza8W1VRCkcZYrCNb7byQytmyhh1gcs0LnpLnKoe9IA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4272.eurprd05.prod.outlook.com (10.171.182.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 22 Oct 2019 04:44:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 04:44:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 0/4] page_pool: API for numa node change handling
Thread-Topic: [PATCH net-next 0/4] page_pool: API for numa node change
 handling
Thread-Index: AQHViJNcsaTCOjw+ME2eyW3PeeMs3g==
Date:   Tue, 22 Oct 2019 04:44:17 +0000
Message-ID: <20191022044343.6901-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 481e6e59-651c-47d9-6ab0-08d756aa7f14
x-ms-traffictypediagnostic: VI1PR05MB4272:|VI1PR05MB4272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB42723F7533DAE4CD5A220074BE680@VI1PR05MB4272.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(4326008)(81166006)(36756003)(316002)(110136005)(25786009)(14444005)(81156014)(256004)(8676002)(305945005)(7736002)(14454004)(54906003)(8936002)(478600001)(2906002)(1076003)(71200400001)(71190400001)(66476007)(50226002)(52116002)(6116002)(6436002)(3846002)(386003)(26005)(102836004)(86362001)(6506007)(6486002)(6512007)(5660300002)(186003)(66446008)(66946007)(486006)(99286004)(476003)(64756008)(66066001)(107886003)(2616005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4272;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MBsa0FgJ+XL3Ea/ZjyHeszmE3JwqyUXWsUaHZoHIAHLC2o9ErcKPK5WrbdRHK52atG375O59EOlgcs2QIxqp1LEOWQ+O7YWHrzNzvPl9RPWVkUQDWk9fryhLBTYIXmvhcpziCoK1SQrmPSPS7170XxBf+jWG51o75vmbDtKFInDh+H0wMkfEt7yk1TAUl2xh4ZYxP9w8Amdc/YXxv5Y+6Ga41TeGq32Yz/6IGetV3AdZ5dDPq60ExmxGcTmyTP6bZM3Q4h5tHu1OO8fscZcH1X77ec5WldGfMhulvWNRBpU9DUGTlKXnDaoiRdqmIxZOKGGSvU64bN82a6WyUrpQHqnVYq/dQFaAOGYg5I0M8HnN3yVXTEwjtKiM7wp4cKBsUZXxcLoODCtdU0WmWcAXHjiCz11WZpNMwhgXbRBi+BfWOeS+8rGelrTf5VTf+N2s
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481e6e59-651c-47d9-6ab0-08d756aa7f14
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 04:44:17.5506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hD/qpvwStbl3bTskneCKVSS4Pjm+CYaEdoAV8lBRiGGXfT7Z2QAeUSDAblSVcYT/fCofMKko7ce7X3XJewOnxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4272
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
Far   | TX   | 4   Mpps  | 3.5  Mpps

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

Thanks,
Saeed.

---

Jonathan Lemon (1):
  page_pool: Restructure __page_pool_put_page()

Saeed Mahameed (3):
  page_pool: Add API to update numa node
  page_pool: Don't recycle non-reusable pages
  net/mlx5e: Rx, Update page pool numa node when changed

 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  3 ++
 include/net/page_pool.h                       |  7 +++
 include/trace/events/page_pool.h              | 22 +++++++++
 net/core/page_pool.c                          | 46 +++++++++++++------
 4 files changed, 65 insertions(+), 13 deletions(-)

--=20
2.21.0

