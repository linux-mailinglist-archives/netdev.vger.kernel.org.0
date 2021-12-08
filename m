Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10DB46D926
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237501AbhLHRG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:06:29 -0500
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:32161
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234434AbhLHRG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 12:06:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7dzPiG3At28ySE14YWgnAWxx+FaQhcxtGS3k0aKSMuEwgzu/YIz9I/vvLHjX0IIMPbgiPXvw/Q796hMsm4Rieu7l1lC66oAyjgwvpF0wmOc97bxlWtAMhb9ZjZUuuoJuxEamcNOWhCYSDgrlKMVzKk46BBUc4UQqFbpnKWFCvE49XLLHBn95enLFQzJvob3/oFZK9tHWTdOzmhfiiFPolRe/zeYLawKfqoPLi5f/TxGkkBUN0FFz09jgdDqZOVFTnb4omSm8xl3HxbMUNL2CGb5NAhCVviWvixFk3CCU9mePdfcOuNVLx/SK9kDxeE42HkXSy+qNbaVEndH8OCTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucmqPWNTtPyWHfovV/ZBIfn8tb+EI4ycl9cQCgUSeSg=;
 b=hG6UzJg5zosCC5L1GnmlcnZ4pwCOUsGcXJGRcC5IIz3VxlDKIj246d1auI/FAQepxBIwb7FAFxwfrsrqStk/rGxbuaAf30jyteuiJ/CwWNQQjOVTxhaZboAbLo0ty4AB0aYQzbZSrfa9FjV28mC8ayeRYbVY9pUh5GIIuyyDDr0oWIPHZC2s4w6U0CXICcaOUfvMa8P0bMmF+mzksRck+cJa7RS2Hk5EflNH5Cf7yNW6Nbco3+kjh/fHT3e1ArXrN7iMEAS2p0E5MvJ+2SdU63L40VrxSfJMZ7v5gEHpg5rZpclN5kld3rmhAjhubT/ne5LTX5UM7t1Tjp7iPCfnHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=openvswitch.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ucmqPWNTtPyWHfovV/ZBIfn8tb+EI4ycl9cQCgUSeSg=;
 b=V+560bsDvKb5P5w7ydtVRIo5zE23F9AQ9MVfZCPr1fxYnES/vS+jZyL+BwwWaFv7goKefKwzA/+YWx5vs96bDw0MsN90wDe7V8mnb4CRS7dZmjfBB5GbMmttmdx1ujSi65ZkUf2UWJJSZAbiQM34LMugWiVFK2JYxVgMtHvo8DVm3ZwwAviJPoJfbFtpbPZLcU9cOEeKzUkQWfDaSyBTuq16j4ZCAtOr5oON2ZuZFJMXjrzh2A6ryUuZeXT3GyeGZlnRIXuThTqTLK3/fCk9HMZnw98VqvceXlisazZP+QbczE98XzmxY9V1JHzVdilM5ExDjpqyf1GpwP1KnPnc9g==
Received: from MW4PR03CA0120.namprd03.prod.outlook.com (2603:10b6:303:b7::35)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Wed, 8 Dec
 2021 17:02:54 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::7f) by MW4PR03CA0120.outlook.office365.com
 (2603:10b6:303:b7::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend
 Transport; Wed, 8 Dec 2021 17:02:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 17:02:53 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 17:02:52 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 09:02:50 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Wed, 8 Dec 2021 17:02:48 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net 0/3] net/sched: Fix ct zone matching for invalid conntrack state
Date:   Wed, 8 Dec 2021 19:02:37 +0200
Message-ID: <20211208170240.13458-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8b6b0bd-a988-4778-822a-08d9ba6c933e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4243:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB42436F8F37F5ACF719B39535C26F9@BY5PR12MB4243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RtW6B2g6CnWIpenBZcRwF2j8DxhXM7gpuZpUb7OL0fEaSbdCZNDY8o4YSTsJCowVgTOeD+Io2SOGFSkEP0x2aptp2Wgo9QtG1vWPsOdf3RPZF4FKy3fpzbpVprQ52fxA5WWBEcfVFJ+Gbvn50fM8BKdNiamWNowbbStMSqZx1PYRtJlCjw8hnEZ2uWkiNAaJ3PQ6pbyhALF4O9iblgPGQSS9tznpQT7TI8fdVRy5AtjG2wspHNPGptkqTlq6xtj2FAWESwHs4WfZ/tG+QIsNBnwbD6tG2G8vd2S1o7A0bM1/aVi5gG6fZZSEt+WqSTTCTR9Dj8LR8DOW1knRqkwRyYQcj2GTBUxAKwDEYobLfUBbYqd6Y6WvpdwHZZwjfNgebMJZzryOIoumIl2j+Ns+Imb/ZajM7MBIOWz3UOYoJ2vuNGvFxxeOFYRedUUQP9HBQZJXjYYabuSe+QG7GCT23C5vuSlTIArKsmvDrTRKSveb5QWORbc2QFdHtQn2waULy0lGkj6JdnzYST6WYDr0RlPUMCe1a5Vre51mK0ThHGKFWElWWE7v7gFcpc/MS1J/iVpoeMAbAWl3Qx6tiYgUsZ0+F9HbRtTmLAQUiZSubodpEunoAFLcAXACKI0fwHJFC/2/0q20V/sr4UtgEj+MV9WGMwqZUT8hCldsq06ztPPheDp6AqbRh4oqrl0jC/caYPwzK7rql32drNG66K7ZeNrmkc/tmYOfdQPPzSUIonlA/b8tiWfVSRElpSmc0aOKrx6BUWFtkVHkp7ZRPZTss8IdlTOdzRvVKMDhBFbnlHQ=
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(316002)(34070700002)(54906003)(83380400001)(8936002)(356005)(86362001)(4326008)(107886003)(110136005)(36756003)(7636003)(36860700001)(6666004)(8676002)(70206006)(2906002)(336012)(426003)(40460700001)(2616005)(508600001)(6636002)(47076005)(82310400004)(186003)(26005)(5660300002)(1076003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 17:02:53.5155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b6b0bd-a988-4778-822a-08d9ba6c933e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Currently, when a packet is marked as invalid conntrack_in in act_ct,
post_ct will be set, and connection info (nf_conn) will be removed
from the skb. Later openvswitch and flower matching will parse this
as ct_state=+trk+inv. But because the connection info is missing,
there is also no zone info to match against even though the packet
is tracked.

This series fixes that, by passing the last executed zone by act_ct.
The zone info is passed along from act_ct to the ct flow dissector
(used by flower to extract zone info) and to ovs, the same way as post_ct
is passed, via qdisc layer skb cb to dissector, and via skb extension
to OVS.

Since there was no more for BPF skb cb to extend the qdisc skb cb,
tc info on the qdisc skb cb is moved to a tc specific cb that extend it
instead of within it (same as BPF).

Paul Blakey (3):
  net/sched: Extend qdisc control block with tc control block
  net/sched: flow_dissector: Fix matching on zone id for invalid conns
  net: openvswitch: Fix matching zone id for invalid conns arriving from tc

 include/linux/skbuff.h    |  4 ++--
 include/net/pkt_sched.h   | 16 ++++++++++++++++
 include/net/sch_generic.h |  2 --
 net/core/dev.c            |  8 ++++----
 net/core/flow_dissector.c |  6 +++++-
 net/openvswitch/flow.c    |  8 +++++++-
 net/sched/act_ct.c        | 15 ++++++++-------
 net/sched/cls_api.c       |  7 +++++--
 net/sched/cls_flower.c    |  6 +++---
 net/sched/sch_frag.c      |  3 ++-
 10 files changed, 52 insertions(+), 23 deletions(-)

-- 
2.30.1

