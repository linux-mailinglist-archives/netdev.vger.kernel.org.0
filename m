Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F02A3F028F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 13:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhHRLZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 07:25:39 -0400
Received: from mail-mw2nam08on2064.outbound.protection.outlook.com ([40.107.101.64]:56545
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233798AbhHRLZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 07:25:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbU9Hn4sGnbuhTKg4G4HTp1fHZypIS3uQKcXmxgB6TVklUsWe/twVE64hrHDgb3Bl7r18CG6BNeLsTG6vSdbOv2UOcJSIwdrvFaBu5o1/4bltdON+kWXYQG6I39vCjFXP8agI4+O0jgMT1v1F1x0d7rbXa+1T387lGjKI0HSRGVEREkOahoilD3uP8ItCRvMZhr3MkhDZWUnu5ZJ1TmVdQee6qjkKBEianSyGol6VgFvMk3GT6hrCYWTJymUQsdNVgvSuZ5qzLJnUojL9DZaVMFSc6FoRK0Nr9dzMwX+vRrW1XI2l+aLk8TRVhspf3QC4qF8qzObagOmKgUvfAJocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpvYki+rp3dUKoSYnSe0PPV4By3h5TVJeh1wPlukIRI=;
 b=TVWA3BlN/KCod3aZYLjHguT7TZTtik/OHnpIpgpycwAekX4cRNwGMf9Dvjqcj0LZ7FS/9etnNdyTr5Vtwmj5gdkXThcturGTtB1DPYgOeV3o+T87IISASmXWyGFfj2EstmaKS36C05mN8ckww2ri11V9dhzUacxpw6o/TU6WXxRytly7OngevnaEQi5JHMew/h40dzlAU0NP92UTAG/u3qDz7AOYzFC+hLzqsMCqjL1mtW1VK7rZk+ddHADOPEPc/vnzzqPPu+mjR27qt5xoqMiMjWEf9e3KrErFNsaWd6vAXA5pXw2ctUS6ak89WGIGdtMpo4tFkDlAvlJlS9ASTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpvYki+rp3dUKoSYnSe0PPV4By3h5TVJeh1wPlukIRI=;
 b=olUTgSfJfN4AIzZVAe2R45YF9vBLZ75Q+tpsGLq7StmhmQJygLhr5cAoZL+VYV4x6i4qx6YdzDsvHtb2KrmcVLoksBG3CezsdByAJsL8QtM1NAzlRqPQt5Hf//0dJ25d+YDRee3xD/8hf1fxOfUJghkKlbi3tmCzwcUe0I194kATXscsyMagA6T3+CvtkmoRTRpQDADLMhl2AV3Rry0YsUQcLiQCOzSA0czpBGN8KVcpL1ATUQPIbv+PLssM9qmHyd+XFGB9M1y2AU2D37mKciDsA2PGrGV+KI6CRolV3NLFV5kDzYUNOgJbl1ZLpHqgjocKTcFfAxlNOlBy3x0M9g==
Received: from BN9PR03CA0630.namprd03.prod.outlook.com (2603:10b6:408:106::35)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Wed, 18 Aug
 2021 11:25:02 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::8f) by BN9PR03CA0630.outlook.office365.com
 (2603:10b6:408:106::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 11:25:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 11:25:01 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 04:25:00 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 11:24:58 +0000
From:   Mark Zhang <markzhang@nvidia.com>
To:     <jgg@nvidia.com>, <dledford@redhat.com>, <saeedm@nvidia.com>
CC:     <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aharonl@nvidia.com>, <netao@nvidia.com>, <leonro@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next 00/10] Optional counter statistics support
Date:   Wed, 18 Aug 2021 14:24:18 +0300
Message-ID: <20210818112428.209111-1-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e2857da0-9177-43e6-150e-08d9623ad1d0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB53621AA823F54FF4DBD907D6C7FF9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8biX44gAzzAQidMLAa/UhkzedlJVa+V8uuhwW9iuYKtnhdGZrmOMUEc1XoZMHP7NHBdjINs5jr72RvZkfPpeLLCw0uWT9ppl4gx2RW1+r0ed6beNEEFMEcei/+3Ks0kkR6wHnaYzlfoIrkOKWr370OV4uq6v+9E5O8tz/J9otGrSkXQ4xh477bcLxBncaH8t+zVN7AJa1xRIYhMpKAbWJWK6YdkyqUBaS9eHj9YyuErx2tN1NbjYN9uoQBUsyBookkI4rkS+8XiDCjf41eLntzn2ePv08s9q2hG+K2mbJt3QHQy0ns7ObSCjNXzZwJ7eC4O/bSMlV4QsVFppbjYIDmfgM3WUa8AM1fc4F4jSdoWu2pAuF/xseVOP+d3Ge93DJCnM/tkphjejq+R1xRbVLN4W+9K82Bz2/K0PMNTGW4p1Z/KUElp/kc7HPL0kEeYAvZI/ufOot2hd+77Hv1/NRT3/RXoBSLfHy3GURUW09LQcK17XFXZMafM4dEkl+/eSeavxYLyL/s7oV9LesJibeKbeGkJck6dEimqcz4EIWiA/0xqHIZzmJFJS3o6ajwvoBLyxNB5UZCva8j4RRPkl1wXcQvfB5SCf+JcU2N7YTVNcsNomc/oAVVBjvJk26m8YEqflL56pGClIOv+GzQfHFTz3jPEiq1Bta5gZa+jfifKCF+8x+s5yyhx2Hwq+PA6oV/dSctxnzjYif4bVAssiQ==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(7696005)(54906003)(6636002)(8936002)(83380400001)(8676002)(426003)(107886003)(356005)(316002)(1076003)(2616005)(110136005)(82740400003)(6666004)(36860700001)(2906002)(186003)(7636003)(70206006)(36756003)(70586007)(478600001)(82310400003)(4326008)(86362001)(47076005)(5660300002)(26005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 11:25:01.5696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2857da0-9177-43e6-150e-08d9623ad1d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series from Aharon and Neta provides an extension to the rdma
statistics tool that allows to add and remove optional counters
dynamically, using new netlink commands.

The idea of having optional counters is to provide to the users the
ability to get statistics of counters that hurts performance.

Once an optional counter was added, its statistics will be presented
along with all the counters, using the show command.

Binding objects to the optional counters is currently not supported,
neither in auto mode nor in manual mode.

To get the list of optional counters that are supported on this device,
use "rdma statistic mode supported". To see which counters are currently
enabled, use "rdma statistic mode".

$ rdma statistic mode supported
link rocep8s0f0/1
    Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts
link rocep8s0f1/1
    Optional-set: cc_rx_ce_pkts cc_rx_cnp_pkts cc_tx_cnp_pkts

$ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_rx_ce_pkts
$ rdma statistic mode
link rocep8s0f0/1
    Optional-set: cc_rx_ce_pkts
$ sudo rdma statistic add link rocep8s0f0/1 optional-set cc_tx_cnp_pkts
$ rdma statistic mode
link rocep8s0f0/1
    Optional-set: cc_rx_ce_pkts cc_tx_cnp_pkts

$ rdma statistic show link rocep8s0f0/1
link rocep8s0f0/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0
out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0
local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0 roce_adp_retrans 0 roce_adp_retrans_to 0
roce_slow_restart 0 roce_slow_restart_cnps 0 roce_slow_restart_trans 0 rp_cnp_ignored 0
rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0 rx_icrc_encapsulated 0
    Optional-set: cc_rx_ce_pkts 0 cc_tx_cnp_pkts 0

$ sudo rdma statistic remove link rocep8s0f0/1 optional-set cc_rx_ce_pkts
$ sudo rdma statistic remove link rocep8s0f0/1 optional-set cc_tx_cnp_pkts

Thanks

Aharon Landau (9):
  net/mlx5: Add support in bth_opcode as a match criteria
  net/mlx5: Add priorities for counters in RDMA namespaces
  RDMA/counters: Support to allocate per-port optional counter
    statistics
  RDMA/mlx5: Add alloc_op_port_stats() support
  RDMA/mlx5: Add steering support in optional flow counters
  RDMA/nldev: Add support to add and remove optional counters
  RDMA/mlx5: Add add_op_stat() and remove_op_stat() support
  RDMA/mlx5: Add get_op_stats() support
  RDMA/nldev: Add support to get current enabled optional counters

Neta Ostrovsky (1):
  RDMA/nldev: Add support to get optional counters statistics

 drivers/infiniband/core/counters.c            |  86 +++++
 drivers/infiniband/core/device.c              |   4 +
 drivers/infiniband/core/nldev.c               | 297 ++++++++++++++++--
 drivers/infiniband/hw/mlx5/counters.c         | 157 ++++++++-
 drivers/infiniband/hw/mlx5/fs.c               | 111 +++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  21 ++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  54 +++-
 include/linux/mlx5/device.h                   |   2 +
 include/linux/mlx5/fs.h                       |   2 +
 include/linux/mlx5/mlx5_ifc.h                 |  20 +-
 include/rdma/ib_hdrs.h                        |   1 +
 include/rdma/ib_verbs.h                       |  36 +++
 include/rdma/rdma_counter.h                   |   8 +
 include/rdma/rdma_netlink.h                   |   1 +
 include/uapi/rdma/rdma_netlink.h              |  11 +
 15 files changed, 775 insertions(+), 36 deletions(-)

-- 
2.26.2

