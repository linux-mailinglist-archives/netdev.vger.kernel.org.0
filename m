Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB8F426AAE
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbhJHM1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:27:49 -0400
Received: from mail-bn8nam12on2052.outbound.protection.outlook.com ([40.107.237.52]:63777
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230197AbhJHM1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:27:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDQmd1DdIQiHLC48j3ODheP6YdJDzxepiSnXKx4Ubdey7s8fuk57zMXX03TyuVUwYSM6duafZ6q9H7CtvMEX8sTpLBdl9QF3c0lVT1fUMwSC0tQTY6tJDzo2GzimUiXrXW2Ko5CCvUvmYKiPuZ4rmInEgZ2ab75wlMsDumE6YqTHetNGJDYGiCa1+IhjlsM0HRJst8yWDxwN3hhUb789Nb4ITsBRTalsv3vHTZdeuQvZUJXY3yTtW2FAiCOBDq/wyOzHibAkR+ihW3sMZiGYbhOQm0NMtRARaYwseG+1cFU4xK3FyGNrpG7d+zY7+oCq2VPaovulniI/DvUmovfSsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnCiPQd997ciMNti3z4Az2SiXBhuupC/BRLmm2bCnq4=;
 b=j6kEScn6WERkt8T0eO1vvY5CAEf1SsvV8F8We++KENVigul6zYZMYaxY8MEo+PlLHNEprHkwv7d6lJp8hiq90Q29ofGhUJisYPojFa2X1wNOZg5EqRXiTBWnIFGMHK8N5XQ+/1p4zD9XJyh361vaO+2X4V3LqTNgH6AxXv5+q9RtKuzGnzAZNoT5DXV6O5mq6aLwHW2hjfJyKbEz/9REKLXAW4w7KvrNiytzroGNVwPPDdNzEmyAxlyKW0agA4Rs1le5qxwIv4DO5cjEkns945q3ebnzuOgjWCrNbEaZcxucFt3slo76ydXh+bTMPnHpAcpcvuZHtHpRutgWmoTSjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnCiPQd997ciMNti3z4Az2SiXBhuupC/BRLmm2bCnq4=;
 b=CgjeFp33RGAE8+oNlHJgAmUU3aR3dVTbbupfLlgT0iX6RXk5uwOaWDYMqNuw2mnvapNItC7P78uAkR3kb04c+tx6XyzqaOdch9j2N+A6nl4N54vvl7wbma11lG0WbYktO1pUCOyEXKLTLh50Ahb4kpktVrCULpLphbd6Osq6n34jio6j0VUndunf3DwMD+ZwnhKfptxYM5kOrmCBAk/z9qSCcHVE1vqN3dcOJesTSkvaFA6kt1UBsghogR7KNVC2KzKh7g0BiAbEQR0jOuiDPCvJmw+u4vqunam6JuA7KbnDr7OrFx9A7onERxqtTefLGLtDZ4U0txNgu+2Zvo7Wqg==
Received: from MWHPR1701CA0007.namprd17.prod.outlook.com
 (2603:10b6:301:14::17) by BN6PR12MB1490.namprd12.prod.outlook.com
 (2603:10b6:405:f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Fri, 8 Oct
 2021 12:25:51 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::55) by MWHPR1701CA0007.outlook.office365.com
 (2603:10b6:301:14::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend
 Transport; Fri, 8 Oct 2021 12:25:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:25:51 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:25:50 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:25:45 -0700
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        <dennis.dalessandro@cornelisnetworks.com>, <galpress@amazon.com>,
        <kuba@kernel.org>, <maorg@nvidia.com>,
        <mike.marciniszyn@cornelisnetworks.com>,
        <mustafa.ismail@intel.com>, <bharat@chelsio.com>,
        <selvin.xavier@broadcom.com>, <shiraz.saleem@intel.com>,
        <yishaih@nvidia.com>, <zyjzyj2000@gmail.com>,
        "Mark Zhang" <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 00/13] Optional counter statistics support
Date:   Fri, 8 Oct 2021 15:24:26 +0300
Message-ID: <20211008122439.166063-1-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4948ff-9b1f-45b2-f1a2-08d98a56c421
X-MS-TrafficTypeDiagnostic: BN6PR12MB1490:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1490DEAF5C9320BFFF449FBDC7B29@BN6PR12MB1490.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Th/T+tTNBQbWmjEbs6yE2+yjfeb+JfIcti7V5fJD9gqz5KqiDNkA7xmo6D3fWSPtOxF5hAds8ZxSSfaxl6zYWCrIaM3kuFis0q4QlLx7kyfhWpJFknnybC2mzIwlqIljwrxkt4iSq2k3ODss+eIwRZiBZRJ6DJsDZsbE5RENgMB8Z21ji1/p2ooqH0vA58HMpbsHnKfdtvYgASsJJ67HRywG2r0iRnA2ndMhYEB885LRe8myi0FaGufV6Knvgt9tWd2vHEIkSpmQDGtdMUb5FbVE3giCO2aoiiB6JaPd2nIJnzlw6mTHU9VHwdUZf6tj0Pj7sTH3V/SbBlgLKVc6iApu8996F1wFrcBj2lXIiFIAz8Hgg0zPiK/6tulKYtLRw1bDnVKlUEV/bz1jzhbwPiHwWmR4BNgQ6DsrbJZrIBXrigWuf4YUMzFmWo1MvhZJuQut9oeO3Qg2ijRv3236nQMWExo63J/yCpmyOa5pXf6HjWaf/Ii+AiuYuzivtaG9m81u6QmhWMcUwpyRl5YLCjw6ZnoC9PVZzbacvixufK+wZP6RyJOO9BRHDzcyrW7CruKnT6/lmahac1exGVgGmYZ1BCeup8+WDPcglYh4rXTSP3fKdf7nHl98eOW/hFy7z9r0VU+yc1jy9849yJ9qq+NHa0FET5IIb/wQVrpWPGZq00hYpCA+1GKK6eVjkITG2NQLUb7e80YPJZsXXBB9TmgF1yJ5osbbCDPc+Wdrm17Le1+nPGbVAkNd5cbn+Is41PKF27CijJTSMzHJwh4fRHg8YAkL1f2Pr7+dVjKaKHgDOFrxFZDG1yy5UXsk0x8Bl4beqNskLyEZPoZ/t8J3hQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(6636002)(4326008)(1076003)(508600001)(107886003)(7416002)(8936002)(6666004)(356005)(70206006)(70586007)(83380400001)(186003)(5660300002)(7636003)(7696005)(8676002)(110136005)(82310400003)(54906003)(26005)(316002)(336012)(47076005)(966005)(2906002)(36756003)(426003)(36860700001)(86362001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:25:51.0982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4948ff-9b1f-45b2-f1a2-08d98a56c421
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1490
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change Log:
v4:
 * Add stats NULL check in rdma_free_hw_stats_struct();
 * Improve nldev_stat_set_doit() and nldev_stat_set_mode_doit();
 * Remove RDMA_NLDEV_ATTR_STAT_HWCOUNTER_DYNAMIC attribute dependence when
   set dynamic counters;
v3: https://lore.kernel.org/all/cover.1633513239.git.leonro@nvidia.com/
 * Many cosmetic changes;
 * Fixed rebase error which caused to have two same patches with
   different implementation;
 * New patch that split nldev_stat_set_doit;
v2: https://lore.kernel.org/all/cover.1632988543.git.leonro@nvidia.com
 * Add rdma_free_hw_stats_struct() helper API (with a new patch);
 * In sysfs add a WARN_ON to check if optional stats are always at the end;
 * Add a new nldev command to get the counter status;
 * Improve nldev_stat_set_counter_dynamic_doit() by creating a target state
   bitmap;
v1: https://lore.kernel.org/all/cover.1631660727.git.leonro@nvidia.com
 * Add a descriptor structure to replace name in struct rdma_hw_stats;
 * Add a bitmap in struct rdma_hw_stats to indicate the enable/disable
   status of all counters;
 * Add a "flag" field in counter descriptor and define
   IB_STAT_FLAG_OPTIONAL flag;
 * add/remove_op_stat() are replaced by modify_op_stat();
 * Use "set/unset" in command line and send full opcounters list through
   netlink, and send opcounter indexes instead of names;
 * Patches are re-ordered.
v0: https://lore.kernel.org/all/20210818112428.209111-1-markzhang@nvidia.com

----------------------------------------------------------------------
Hi,

This series from Neta and Aharon provides an extension to the rdma
statistics tool that allows to set optional counters dynamically, using
netlink.

The idea of having optional counters is to provide to the users the
ability to get statistics of counters that hurts performance.

Once an optional counter was added, its statistics will be presented
along with all the counters, using the show command.

Binding objects to the optional counters is currently not supported,
neither in auto mode nor in manual mode.

To get the list of optional counters that are supported on this device,
use "rdma statistic mode supported". To see which counters are currently
enabled, use "rdma statistic mode".

Examples:

$ rdma statistic mode supported
link rocep8s0f0/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts
link rocep8s0f1/1 supported optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts,cc_tx_cnp_pkts

$ sudo rdma statistic set link rocep8s0f0/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts
$ rdma statistic mode link rocep8s0f0/1
link rocep8s0f0/1 optional-counters cc_rx_ce_pkts,cc_rx_cnp_pkts

$ rdma statistic show link rocep8s0f0/1
link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0
out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0
local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 roce_adp_retrans_to 0
roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 rx_icrc_encapsulated 0 cc_rx_ce_pkts 0
cc_rx_cnp_pkts 0

$ sudo rdma statistic set link rocep8s0f0/1 optional-counters cc_rx_ce_pkts
$ rdma statistic mode link rocep8s0f0/1
link rocep8s0f0/1 optional-counters cc_rx_ce_pkts

Thanks

Aharon Landau (12):
  net/mlx5: Add ifc bits to support optional counters
  net/mlx5: Add priorities for counters in RDMA namespaces
  RDMA/counter: Add a descriptor in struct rdma_hw_stats
  RDMA/counter: Add an is_disabled field in struct rdma_hw_stats
  RDMA/counter: Add optional counter support
  RDMA/nldev: Add support to get status of all counters
  RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
  RDMA/nldev: Allow optional-counter status configuration through RDMA
    netlink
  RDMA/mlx5: Support optional counters in hw_stats initialization
  RDMA/mlx5: Add steering support in optional flow counters
  RDMA/mlx5: Add modify_op_stat() support
  RDMA/mlx5: Add optional counter support in get_hw_stats callback

Mark Zhang (1):
  RDMA/core: Add a helper API rdma_free_hw_stats_struct

 drivers/infiniband/core/counters.c            |  40 ++-
 drivers/infiniband/core/device.c              |   1 +
 drivers/infiniband/core/nldev.c               | 278 ++++++++++++++---
 drivers/infiniband/core/sysfs.c               |  52 ++--
 drivers/infiniband/core/verbs.c               |  48 +++
 drivers/infiniband/hw/bnxt_re/hw_counters.c   | 137 +++++----
 drivers/infiniband/hw/cxgb4/provider.c        |  22 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |  19 +-
 drivers/infiniband/hw/hfi1/verbs.c            |  53 ++--
 drivers/infiniband/hw/irdma/verbs.c           | 100 +++----
 drivers/infiniband/hw/mlx4/main.c             |  44 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   2 +-
 drivers/infiniband/hw/mlx5/counters.c         | 282 +++++++++++++++---
 drivers/infiniband/hw/mlx5/fs.c               | 187 ++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  28 +-
 drivers/infiniband/sw/rxe/rxe_hw_counters.c   |  42 +--
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  54 +++-
 include/linux/mlx5/device.h                   |   2 +
 include/linux/mlx5/fs.h                       |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |  22 +-
 include/rdma/ib_hdrs.h                        |   1 +
 include/rdma/ib_verbs.h                       |  58 ++--
 include/rdma/rdma_counter.h                   |   2 +
 include/uapi/rdma/rdma_netlink.h              |   5 +
 24 files changed, 1127 insertions(+), 354 deletions(-)

-- 
2.26.2

