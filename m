Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79EAE3584E5
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhDHNkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:06 -0400
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:3712
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231748AbhDHNkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vu9ISAO0cHBlcVsgxIGBBRjkyryJsDhybPm9BXv1kTOOIommRoYR9tPonoKmZ/WVhXCP1hTk201i0NHcBj9jngMo7ylu/d6vJBtePUhzN1wuK3TuVt5DsCrnny7Aas9zpozu8p1DkaDDC7raZBBji7Q2oWQUIbXVisDKXm1NQK1QnX8rbYuxLndy04XVSNgUWEf/kB8zqKJBituuzzk/AnlLNi1YxGauW4/GnAyZJxwPR4FgIVg6pufJhfdiU+9MggJLprAmBg+eS/uY0MVWUP49B2b77uGmp5ED7sJMpljvrDD35+7BMC14tkpMgudDiwoHmJzS+rjmC/Z3H97g2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU0bTpPIFYOJrf09nI7oJZVs3s525tkOo/t2iEWVNbA=;
 b=ffd1vTOs+GtOSOC54iV+RikeIZEKdyCgVd9V0zIFo1/40tAfK/jMK1jbOJO4saQRyyoUsnHJ8h967oAB6NjbxUCx9VzcTnXNkXvxtvuOcJ3uSSuAnQgt2PJMtxE9g8jaV8EMPSFsJjMeGygaIU9Sdpyqc40ZyOZ6CXGFPPp7jbRMAFLRMOtao6RVJtCX5JFKDe8zBorvqEKsqMGcP/RphNXA9PftzTzFf833JZfs0sNFEZ4RSwj77OK7ZPrSi8rXwyM6FU9tBaSLQB4u40bIYMkK6x6q/gP27yLahgxTHRejhjAhd9P6fI33LbQOMQ8BwbZTblMLZLgs+KrpRH5AhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU0bTpPIFYOJrf09nI7oJZVs3s525tkOo/t2iEWVNbA=;
 b=oElZM7zh3XQOzitZ784o3ocLeqKvwkEHIzwyO/CBZDJRQHxnjCExpCwCpwTzzFrf7BDhlao51QVuKXpIXPWfFUWOC68tvP+4lY5tpmOEoKfNJGF4r3+mksNsnULp2xKGKWpt+XQBUWd4Zh5SjyWVNqwp0a/x5FoP+j/YiVdfq4Ft86eAYfsBD6FXQCDNj/N1DSl1mm2zxhQg61/KcIIswWhXxAN2fJm5dbam8QSwbQLniXhCdjpoSajEbW6/qZtBU065r4RoB4aKOL5rIkgTV3DgzHRAAq2xo12MzU+jgdOUJvoTJi7YiEtFNmzuZQyzbQV935p/+/7xzEbzAFfkRA==
Received: from BN6PR18CA0003.namprd18.prod.outlook.com (2603:10b6:404:121::13)
 by DM6PR12MB2618.namprd12.prod.outlook.com (2603:10b6:5:49::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 13:39:53 +0000
Received: from BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:121:cafe::e6) by BN6PR18CA0003.outlook.office365.com
 (2603:10b6:404:121::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 13:39:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT003.mail.protection.outlook.com (10.13.177.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:39:53 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:39:49 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 0/7] tc: Introduce a trap-and-forward action
Date:   Thu, 8 Apr 2021 15:38:22 +0200
Message-ID: <20210408133829.2135103-1-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bf1b917-f452-45b5-6054-08d8fa93ca60
X-MS-TrafficTypeDiagnostic: DM6PR12MB2618:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2618EDCBDDF689489693A37DD6749@DM6PR12MB2618.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A7gkskk21WuTXJSxJrnuNwnkYFztJ2cqBfHX0jnqD0A7wudwmWVaRPmKx9VpGe5UgBC0VI9lDKYoBj1+A3ReRvITfo+uhpv17kvsnx3AuhH17ftn4xhVXPGp8aAGStuDz95566nCih83i5xAjFA5C1gMevJjua6ranIIY7w4TSBIWU7/EevYaJC6bRT20RzLnPTJAsIcAj0jFUSRWETETxq1irsZQLkWmFINQ35HywVEfURvuz/obwyVADtLZboEtbbexC5r085f/hYO1RQbhwMig4+vodQgkeyyIP2X3DAWVdDktfXy//3kp65JgSxUYQ+hSg87yJhOmeNIMqnJb4q6XPAJunab55RlwKFoCa7OT0tC0RvjyRsO/MIGE2FEQvVjeDXjQQePfQWxct/b1NhyKyxH6TDFNcHf41GhKS/krJZlSemQFoypE52CE8wYZAr4WO0ZR5k6SJ/kxfRwxtCc3adMp4GG4i+LVkgmTY5coX0UCBSEGPyUK7pfjarD1vTXWGNvwSawxZTMfyOaAF3Z873n3M+UdCB3ccKRg20bPoD5qeMbfe8zg4/w9T/sLYLsTgCkjWymW1fCMipmKhJFwluXqjo7y7zE61slQWoQSvjp8cWYkwxOfa+1qHbECzu5WnEr44AqPXBS7XxjpA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(46966006)(36840700001)(7636003)(8676002)(82740400003)(8936002)(36756003)(6916009)(70206006)(426003)(16526019)(186003)(83380400001)(336012)(5660300002)(4326008)(26005)(2616005)(70586007)(36906005)(316002)(82310400003)(478600001)(6666004)(36860700001)(54906003)(2906002)(86362001)(356005)(47076005)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:39:53.3626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bf1b917-f452-45b5-6054-08d8fa93ca60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2618
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TC action "trap" is used to instruct the HW datapath to drop the
matched packet and transfer it to the host for processing in the SW
pipeline. If instead it is desirable to forward the packet in the HW
datapath, and to transfer a _copy_ to the SW pipeline, there is no
practical way to achieve that.

As a particular use case, the mlxsw driver could instruct a Spectrum
machine to mirror packets that are ECN-marked to the host. However these
packets are still forwarded in the HW datapath, therefore describing this
mirroring through the "trap" action is incorrect. A new action is needed.

To that end, this patchset introduces a new generic action, trap_fwd. In
the software pipeline, it is equivalent to an OK. When offloading, it
should forward the packet to the host, but unlike trap it should not drop
the packet.

This patchset proceeds as follows:

- In patch #1, introduce the new action, and modify the TC code to
  recognize it as an OK.

- In patches #2 and #3, introduce the artifacts necessary for offloading
  the trap_fwd action, and a new trap so that drivers can report the
  trapped packets.

- Patches #4 and #5 offload trap_fwd in mlxsw.

- Patches #6 and #7 add selftests.

Petr Machata (7):
  net: sched: Add a trap-and-forward action
  net: sched: Make the action trap_fwd offloadable
  devlink: Add a new trap for the trap_fwd action
  mlxsw: Propagate extack to mlxsw_afa_block_commit()
  mlxsw: Offload trap_fwd
  selftests: forwarding: Add a test for TC trapping behavior
  selftests: mlxsw: Add a trap_fwd test to devlink_trap_control

 .../networking/devlink/devlink-trap.rst       |   4 +
 .../mellanox/mlxsw/core_acl_flex_actions.c    |  28 ++-
 .../mellanox/mlxsw/core_acl_flex_actions.h    |   3 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +-
 .../mellanox/mlxsw/spectrum1_acl_tcam.c       |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  11 +-
 .../ethernet/mellanox/mlxsw/spectrum_flower.c |   9 +-
 .../mellanox/mlxsw/spectrum_mr_tcam.c         |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   |   8 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 include/net/devlink.h                         |   3 +
 include/net/flow_offload.h                    |   1 +
 include/net/tc_act/tc_gact.h                  |   5 +
 include/uapi/linux/pkt_cls.h                  |   6 +-
 net/core/dev.c                                |   2 +
 net/core/devlink.c                            |   1 +
 net/sched/act_bpf.c                           |  13 +-
 net/sched/cls_api.c                           |   2 +
 net/sched/cls_bpf.c                           |   1 +
 net/sched/sch_dsmark.c                        |   1 +
 tools/include/uapi/linux/pkt_cls.h            |   6 +-
 .../drivers/net/mlxsw/devlink_trap_control.sh |  23 ++-
 .../selftests/net/forwarding/tc_trap.sh       | 170 ++++++++++++++++++
 23 files changed, 288 insertions(+), 19 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_trap.sh

-- 
2.26.2

