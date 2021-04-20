Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0A4365B88
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhDTO4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:56:11 -0400
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:31713
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232760AbhDTO4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:56:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRDtkkZk6gNu/C1rhakStYFKFsRR+UvLmBH6GVDzBlLwhZjMWtLzUOsnWXvnej5VElVkayC2v+YxAaKcC/Nmw+KH9VJfBBCNwULXl36LD6TNqKJgq04FngolNYX30HgACzGorZr5UcrIdTsBvtp18D9mvZtfuMz2KmytIDi0g1nDtaTDGkT+9bPGnI1diNk+bCVjjzIQcNs9DtgDxFSBraun+j+Jo9Dbka4l6DZ0evys0iLHwRfvFOHVVZ87CjzWA554OjQCGE+l7gitoN6SrS1jc/HdpWYfsNmUxKkF7U17gTaFcPTPoaHdnEfcbsUbyzBfDVYbNpunTyXehESihA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csC1su5YlX1iT1C8QOka4bAUTb5dAzv4vCnwfZP/dAM=;
 b=VF8oNgtKpxGqzVmfrgPaK8VEwGPKmATXCJckCc0VsBzDMwiUPyL4AocRpl15zjbDKkvfIX775wo06O47vxEadgy68jPH10KCGjjr4IrmWL72YASNMTjjK4RZvjCErAldr/nJy8YU71tKGa6n96KvkvzSazUKzy1fKDGZo28QKO+gCxVxZvomIbCBv6u2KjkuLzwsYNS0kdFdmIzx1QuwTuzFopuMXx+htkGogB0KGgQ+r0OSE4LBrPelnuL/y3EEecJgNNLldzReVUHYb/S9bMbVs5eIx8ELyCn10lvl7ihA2jdGOeA41lnhjHTHXKheOtk+rnAiGxDhyRYi70vY8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csC1su5YlX1iT1C8QOka4bAUTb5dAzv4vCnwfZP/dAM=;
 b=pr/Ge2lenfe9MFO8Ijh3l3ei6N197As3F+wlm76FMAMgtB1ubQe0yQLZK2Xssca7aQvHzrke7N440gwResnXPIIRzCxmphraqpbt8CSJWrXbhvBGzz3cIdXHB9NH4yXtWg40jrtCxshqs5hr/fFIJZCXIz+5bWRzvcHN98HdSwxbeOHKV1WlMt6Jh21p8NzFeT7hFf8A6g2nkBPpoYK60PmfQYE59CFnjsxyK8EbQnkoWG6+dVeG3wBSrp8F9zyTUZRijkaeaULKBAXxG5oQaFVaJS0yM/OG37Z9CbS08EqM/DQMXtUTrwpUKZ6Tkn0Mx85XGxM+dllLm/TYEcPFAw==
Received: from BN9PR03CA0934.namprd03.prod.outlook.com (2603:10b6:408:108::9)
 by CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 14:55:35 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::8c) by BN9PR03CA0934.outlook.office365.com
 (2603:10b6:408:108::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18 via Frontend
 Transport; Tue, 20 Apr 2021 14:55:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 14:55:35 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 20 Apr
 2021 14:55:32 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 00/10] mlxsw: Refactor qdisc offload
Date:   Tue, 20 Apr 2021 16:53:38 +0200
Message-ID: <cover.1618928118.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58578c9e-6462-4993-617f-08d9040c5a6a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4232:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4232A2F40D76A1F9B14FBD0CD6489@CH2PR12MB4232.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EenfVph4u1RKPSpUC6D5J/TOi9ooR/38yGDMVb97CIPSQFBdRswCvZYEZtzAg3Wbn0gnD+Ygyy1/HSErA6JXAeEVvRM4aGAnwGapIkmd9YXTpSr32WP5uDDEpQhFYKmY8aDfxcwobsPx2dTXR9nDRCJesFcx5uDBA4GWbO6ePGxB/MHhLwRyxfpJ1CB8cBjDtKrCWfTGhNRNTXTUdKY8NJ8655PnA4ssL7KDAfvJB5jM7O8I6EK8mYjhMZhRRjrtao3G6TB8VwsbmAM3antf8gLvfxOMpaZBtYzLaezS55nd3+MOiUyATsypJzolNSB05E+655Nq1buFOHyeVZdYvsWx6fxAMWFhbJg1dOqFQsod03Dv+qK9ppCmlPZ+eeGwWheC9FjV4nZ0MTDIsXS0ITUhGhx8+nKZY+b+mzEwwFn1S3elP3ERYgvqijfKLuQLeWSbR4KpW7bzRrlbRCWH7vvc42NxNgk3c/OzBwHDdleX+BKmmOKFrxKiOzJD6RIkqS02D5Oq5X7YInIZNJHOez4lAMgPG7HfZbApZ04Netglg2YIIpUlhT+qLuCf8HzRQM4sVGhBHaydWcMyMyAhhJbebUb6tKvcXveuZBMAeWlChyXEP4HXXihU3mmgcBCZDf5fH+dscOnprMIeKPyMIPTa1TzInVyqEkOkBYZwLFA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36840700001)(46966006)(107886003)(5660300002)(478600001)(2906002)(86362001)(4326008)(82310400003)(36860700001)(16526019)(186003)(26005)(36756003)(83380400001)(336012)(82740400003)(6916009)(426003)(47076005)(70206006)(70586007)(8676002)(2616005)(8936002)(36906005)(356005)(316002)(54906003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:55:35.0746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58578c9e-6462-4993-617f-08d9040c5a6a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, mlxsw admits for offload a suitable root qdisc, and its
children. Thus up to two levels of hierarchy are offloaded. Often, this is
enough: one can configure TCs with RED and TCs with a shaper, and can even
see counters for each TC by looking at a qdisc at a sufficiently shallow
position.

While simple, the system has obvious shortcomings. It is not possible to
configure both RED and shaping on one TC. It is not possible to place a
PRIO below root TBF, which would then be offloaded as port shaper. FIFOs
are only offloaded at root or directly below, which is confusing to users,
because RED and TBF of course have their own FIFO.

This patchset is a step towards the end goal of allowing more comprehensive
qdisc tree offload and cleans up the qdisc offload code.

- Patches #1-#4 contain small cleanups.

- Up until now, since mlxsw offloaded only a very simple qdisc
  configurations, basically all bookkeeping was done using one container
  for the root qdisc, and 8 containers for its children. Patches #5, #6, #8
  and #9 gradually introduce a more dynamic structure, where parent-child
  relationships are tracked directly at qdiscs, instead of being implicit.

- This tree management assumes only one qdisc is created at a time. In FIFO
  handlers, this condition was enforced simply by asserting RTNL lock. But
  instead of furthering this RTNL dependence, patch #7 converts the whole
  qdisc offload logic to a per-port mutex.

- Patch #10 adds a selftest.

Petr Machata (10):
  mlxsw: spectrum_qdisc: Drop one argument from check_params callback
  mlxsw: spectrum_qdisc: Simplify mlxsw_sp_qdisc_compare()
  mlxsw: spectrum_qdisc: Drop an always-true condition
  mlxsw: spectrum_qdisc: Track tclass_num as int, not u8
  mlxsw: spectrum_qdisc: Promote backlog reduction to
    mlxsw_sp_qdisc_destroy()
  mlxsw: spectrum_qdisc: Track children per qdisc
  mlxsw: spectrum_qdisc: Guard all qdisc accesses with a lock
  mlxsw: spectrum_qdisc: Allocate child qdiscs dynamically
  mlxsw: spectrum_qdisc: Index future FIFOs by band number
  selftests: mlxsw: sch_red_ets: Test proper counter cleaning in ETS

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 448 ++++++++++++------
 .../drivers/net/mlxsw/sch_red_ets.sh          |   7 +
 2 files changed, 306 insertions(+), 149 deletions(-)

-- 
2.26.2

