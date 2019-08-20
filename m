Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E4796A34
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbfHTUYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:16 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728283AbfHTUYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC2uX5Ju81js4CN6nR2PF9ONWyzRxDuZbYneD0dMRlWWXeeimz3zKCvwe86ysGT0BCSQ95Uq8bDcBoKcBrUmM0Aq8/unojiRpIt60auXc6xre+YzLXnXg/k9vAJXUjfEmPZRtTJFiLEx9uY7GpBimepTCflnbGyuu0vsdYsWdHXi2ZMwqp3d32itdKDOalQTIGYoDP3s9UI9hymc1fhk7mnJ1yXOrUB37MezNjCv0ks3BWiKWSrX9EZUg9t5Pn0ebfhojx01qY6X+pVsu81fNy83AhlEExa16jLkvCPl20FiF6NMeawsy2rVUcCD+c11lW8gxp6/CvSzEfoBQOxsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foT7hqlHoqF9ltNPiQS6oX3iyod+f8puyWPuWSECA1U=;
 b=jxtVQa1Kaowzczu+M/wbf7P6Uc9Q0Nac967Yf3kNeJMMFUhfxxsENP8YaD8Mxi65uYTvrXI6RKSjsWQG4YC9uK5O/fxJg+UlqCuRh3RlHggRHwOgnAoWtySrG+D7B5fNYpo9cmHkZInQv2Ujv4jT8Dy0LlhbvldYmugca++KHvC9sBr8nXJa0rvdKoMi+HcKZR53AfOt9kqg1MUtRhmgBab8/m+zzDanmgOZpX9VYlS0j04VX7ceCpis4h30nKqgH2Tqgj6rX6QzAv3D1i3S3bzg4PT4Pwd2UhjYunSEEGur927bnQN9036QiJNKZ+vGNn55VYg5k4CdvFXEV8h1bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=foT7hqlHoqF9ltNPiQS6oX3iyod+f8puyWPuWSECA1U=;
 b=mauqFfwlVDUplcDxbAC3FgEglFdQmLL887ULobvYnK1q26NX0+sdCYQntOSyPx1rXJjB6MBgoVUXtdq0OCZ/Ok1GeTz8pHOSPxXUE8hOhMx55mI18SJaWpuAdzioqznNzISMo0DuNGLQe46EHmlSWy48AkVJCCnGb7KYLQvBym4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next v2 00/16] Mellanox, mlx5 devlink RX health
 reporters
Thread-Topic: [pull request][net-next v2 00/16] Mellanox, mlx5 devlink RX
 health reporters
Thread-Index: AQHVV5U53b9J7W53qk2Mgqsr3980Bg==
Date:   Tue, 20 Aug 2019 20:24:10 +0000
Message-ID: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b172b2ad-9aba-4042-5197-08d725ac5c2c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB26807E49AE9BF960AB85B8ADBEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H1TpN0ENtcHPyzSE/SCXSbaOo522um9Bsg9guj5DEKkRi+Y2Vs/YquaHv8XT8KJrNPTPW+wKpNkbWhIER2PXFDg0hZCQWbOvEIZK7oeV+X1dX9HTTciQw9lb0sm+VSe3XcEu69/z6YNiw33lssf1OWIClKf/cCLJ+zjjg9g0iDGJGsm1C7r/EW0KPM2W9GIp0oYGmv2eD/GAvbkFMg3yszVhoHDQ11i9RBoNvxjBysvN7i57MLjiB+5+MePU0PEwOSZeDpeP3d4CUzxy1FQ3u4Eds/uOMNTOeWe9a+gd4umjX350D3J/JLfVW/a38oSWN1Snjk+pDXD2J5PHcW7omzVP9DmWEdD28BoNDUShFkrZkfihIbAhYaoGOSZw+lqF+E9yBRUw6Gyg9ezF3zDs0t2CqtnREPQ8wxr6moYL6qU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b172b2ad-9aba-4042-5197-08d725ac5c2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:10.8994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0MX3kvlwM3KSPb9dGx3Do9zs581sqdRPWHu9wuLBjf5+RMHKXR8JnCDmpP69SxiMY919pinf9UJup8tmrKQ+Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series is adding a new devlink health reporter for RX related
errors from Aya.

Last two patches from Vlad and Gavi, are trivial fixes for previously
submitted patches on this release cycle.

v1->v2:
 - Improve reversed xmas tree variable declaration.
 - Rebase on top of net-next to avoid a new conflict due to latest=20
   merge with net.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


---
The following changes since commit d2187f8e445403b7aeb08e64c1528761154e9ab3=
:

  r8152: divide the tx and rx bottom functions (2019-08-20 12:18:52 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-08-15

for you to fetch changes up to b1b9f97a0937211dbca638c476ac47ee39875661:

  net/mlx5: Fix the order of fc_stats cleanup (2019-08-20 13:08:19 -0700)

----------------------------------------------------------------
mlx5-updates-2019-08-15

This patchset introduces changes in mlx5 devlink health reporters.
The highlight of these changes is adding a new reporter: RX reporter

mlx5 RX reporter: reports and recovers from timeouts and RX completion
error.

1) Perform TX reporter cleanup. In order to maintain the
code flow as similar as possible between RX and TX reporters, start the
set with cleanup.

2) Prepare for code sharing, generalize and move shared
functionality.

3) Refactor and extend TX reporter diagnostics information
to align the TX reporter diagnostics output with the RX reporter's
diagnostics output.

4) Add helper functions Patch 11: Add RX reporter, initially
supports only the diagnostics call back.

5) Change ICOSQ (Internal Operations Send Queue) open/close flow to
avoid race between interface down and completion error recovery.

6) Introduce recovery flows for RX ring population timeout on ICOSQ,
and for completion errors on ICOSQ and on RQ (Regular receive queues).

7) Include RX reporters in mlx5 documentation.

8) Last two patches of this series, are trivial fixes for previously
submitted patches on this release cycle.

----------------------------------------------------------------
Aya Levin (13):
      net/mlx5e: Rename reporter header file
      net/mlx5e: Change naming convention for reporter's functions
      net/mlx5e: Generalize tx reporter's functionality
      net/mlx5e: Extend tx diagnose function
      net/mlx5e: Extend tx reporter diagnostics output
      net/mlx5e: Add cq info to tx reporter diagnose
      net/mlx5e: Add helper functions for reporter's basics
      net/mlx5e: Add support to rx reporter diagnose
      net/mlx5e: Split open/close ICOSQ into stages
      net/mlx5e: Report and recover from CQE error on ICOSQ
      net/mlx5e: Report and recover from rx timeout
      net/mlx5e: Report and recover from CQE with error on RQ
      Documentation: net: mlx5: Devlink health documentation updates

Gavi Teitz (1):
      net/mlx5: Fix the order of fc_stats cleanup

Saeed Mahameed (1):
      net/mlx5e: RX, Handle CQE with error at the earliest stage

Vlad Buslov (1):
      net/mlx5e: Fix deallocation of non-fully init encap entries

 .../networking/device_drivers/mellanox/mlx5.rst    |  33 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  32 ++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 205 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  53 +++
 .../net/ethernet/mellanox/mlx5/core/en/reporter.h  |  14 -
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 404 +++++++++++++++++=
++++
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 241 ++++++------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  82 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  62 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |   1 +
 18 files changed, 965 insertions(+), 207 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.=
c
