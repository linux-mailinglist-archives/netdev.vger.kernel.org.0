Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3A4426AC1
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241788AbhJHM2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:44 -0400
Received: from mail-sn1anam02on2040.outbound.protection.outlook.com ([40.107.96.40]:22147
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241584AbhJHM2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yu83WouqecI2pSjgYjzjp/n1NmkICFK04nLi27Fy+NcAtl1vkHdjPY9UOyX1Ry3Uk/yam42Ob3H7NuW00xW73DcxKulOTKppAdMb3+e41GEed+1dyNExK8Vv7Ub+jR3K2M7oER5c1t2fJD1SO6VkTk4gHJyFLBYFNGfd+vSEnDTqcPT/52+ggwqu6LlB5XK3Fye2yumTUS4JshQlhCjUpWGhVo7NNcvyQNFqn6Wk0BSWCNNsJrDwj/CigwiH997MPfVtZ2wHg09VMHDbpxbBH3X9TinBoCQ+iicUoIPPUZ4Q/K3mS+ooNN4k+YwFtN1xesWMfd8VaGfqASHNwmgcHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sm//V2ka1xPcvvKhc93o14Xo19TIuAIk6TF+GKlItv4=;
 b=L9Or6DEbqIPq77OrUCZKSQGrbFvn/bwbqh86t8Do00+aRTvpG4lPreJmqipW9tTYMIwcQ+aCGADGtiVH5SMGXRIxVn/2Rng3giDfNg2t3evWf/dib1fvbs+t3NLL/Rr3/q34dDcfQgsVenSMqYri/5yrBdZQyJi79dKILCUuKucThYKeSIR4aVQNSjHMK9pSE+eB2SoDAx9GSD+Bv4+vEgGopXfm/TLAKKReAz7I6/bYJ61QPToC//Wp/ZHJY3rspZivkahAaCUS/Bztb3K8sgN6p5z71rz16ACSM0NjyTbNtHUqedDVpOAWxLwXUKHAHXog7FJ66/mqsNtJmtjc8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sm//V2ka1xPcvvKhc93o14Xo19TIuAIk6TF+GKlItv4=;
 b=WNnxmUwFgS8OuIIRwmAr5TFSH1geB6sHJzZ9WrkhQ8243IvKZtMV6NxJMqNIYzR2lASsMsM+1kmiORq6boAJocnMRHQfB8d6iASIvDG4hzArcMQBkWFI4FwkYKGcLczHaETXt/nDlZsXMD6rFxkypSLTEZ8UvdzkHmGcLjQ+qjWMPVTeaji6doWvrNfDWDNiB2vtevdZkNVukUu4AahQJWaDjL6WtZpm4ibKiKkXg4RQWDNglwMobpgi7hjEumV12Wy2pEBAgYRlks81uZuv5/ZZUEI8MPQ5zjtfU51TuVkcsAMXIVkTcM96M2eUdy74GkrUkcFXaUJbUxXlOdPLOA==
Received: from MWHPR22CA0019.namprd22.prod.outlook.com (2603:10b6:300:ef::29)
 by DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Fri, 8 Oct
 2021 12:26:35 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ef:cafe::49) by MWHPR22CA0019.outlook.office365.com
 (2603:10b6:300:ef::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:34 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 05:26:32 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:28 -0700
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
        Mark Zhang <markzhang@nvidia.com>
Subject: [PATCH rdma-next v4 09/13] RDMA/nldev: Allow optional-counter status configuration through RDMA netlink
Date:   Fri, 8 Oct 2021 15:24:35 +0300
Message-ID: <20211008122439.166063-10-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f176ffa-46f3-4edf-297e-08d98a56ddee
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1706837A2852CEB42DB66C99C7B29@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v2P+IuRwzJwXXVVdd3PJYvcRFm8bYGge60NhL2lDO1XfaIOKHRz0Y7syzp1VstkexMG20Z7+C+ZPI1kvXyn2VqBSz9JxMF8LiOshXXRbP+5fzWS6Gk8s6ILhkftelFD2J/WewcpHYjlFmNx79PHEoVnIZYf6Ktrzixbza2kbVAiM4pbIXLIb4nogkXY0ezNKGQmHN0lD6I83Wu7K4ktWkuv2qvmqdxsJ71T1AFt6HSTpFFP9NSU4L6LOlaCtUuBFomvyM76Lwq0Vkb8WI2M+I+M/9GS3m1sQAUE4j9F8ZijQGD0CIPAbQ5lpP0OLSlJYkYvo3mzTQPiFyXbwGDJNX5zIBTSyxKs/huvg2Nr4/KeGMi37jwGuj5HSYqVMbxv61XbnK0zFVN+BqqxpN12zPfzb1oE0O+NcIQQteiwW9CU/FzePdUbghUcSdLGp+iY0GZhibwR8WhunZkorYuQPTmwCJpwmg8PltpPeX8Cc1IXpIAWLrGd3sA6Fi0U0foKeL2ag0V9xJ8Tnnj70aj5H2ZfSIBXEJoRYRLiLEmnM3fwiClNwaU7TbOfZBW/oWVdDAYZJu0yMiVO/atKc5xtwKdzL04eLnm7a4LbNriYX3pUOn6gmbWK4lVeVkZcRN4bsDWzib0ymizCAbXspsJWGGqCsuVIkLzL+Ljezh+Ugvm2UAD6vb4DpdProTLeGjmteys3hv4tJ4UthjHIj+JeqTg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(7416002)(336012)(70586007)(5660300002)(70206006)(2906002)(356005)(508600001)(54906003)(1076003)(426003)(107886003)(316002)(47076005)(6666004)(83380400001)(2616005)(7696005)(4326008)(7636003)(86362001)(36860700001)(8676002)(8936002)(82310400003)(186003)(36756003)(26005)(110136005)(6636002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:34.3719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f176ffa-46f3-4edf-297e-08d98a56ddee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Provide an option to allow users to enable/disable optional counters
through RDMA netlink. Limiting it to users with ADMIN capability only.

Examples:
1. Enable optional counters cc_rx_ce_pkts and cc_rx_cnp_pkts (and
   disable all others):
$ sudo rdma statistic set link rocep8s0f0/1 optional-counters \
    cc_rx_ce_pkts,cc_rx_cnp_pkts

2. Remove all optional counters:
$ sudo rdma statistic unset link rocep8s0f0/1 optional-counters

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 61 ++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 8361eb08e13b..fedc0fa6ebf9 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1945,6 +1945,50 @@ static int nldev_stat_set_mode_doit(struct sk_buff *msg,
 	return ret;
 }
 
+static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
+					       struct ib_device *device,
+					       u32 port)
+{
+	struct rdma_hw_stats *stats;
+	int rem, i, index, ret = 0;
+	struct nlattr *entry_attr;
+	unsigned long *target;
+
+	stats = ib_get_hw_stats_port(device, port);
+	if (!stats)
+		return -EINVAL;
+
+	target = kcalloc(BITS_TO_LONGS(stats->num_counters),
+			 sizeof(*stats->is_disabled), GFP_KERNEL);
+	if (!target)
+		return -ENOMEM;
+
+	nla_for_each_nested(entry_attr, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS],
+			    rem) {
+		index = nla_get_u32(entry_attr);
+		if ((index >= stats->num_counters) ||
+		    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		set_bit(index, target);
+	}
+
+	for (i = 0; i < stats->num_counters; i++) {
+		if (!(stats->descs[i].flags & IB_STAT_FLAG_OPTIONAL))
+			continue;
+
+		ret = rdma_counter_modify(device, port, i, test_bit(i, target));
+		if (ret)
+			goto out;
+	}
+
+out:
+	kfree(target);
+	return ret;
+}
+
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
@@ -1971,7 +2015,8 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err_put_device;
 	}
 
-	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE] &&
+	    !tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
 		ret = -EINVAL;
 		goto err_put_device;
 	}
@@ -1991,9 +2036,17 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err_free_msg;
 	}
 
-	ret = nldev_stat_set_mode_doit(msg, extack, tb, device, port);
-	if (ret)
-		goto err_free_msg;
+	if (tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+		ret = nldev_stat_set_mode_doit(msg, extack, tb, device, port);
+		if (ret)
+			goto err_free_msg;
+	}
+
+	if (tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
+		ret = nldev_stat_set_counter_dynamic_doit(tb, device, port);
+		if (ret)
+			goto err_free_msg;
+	}
 
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
-- 
2.26.2

