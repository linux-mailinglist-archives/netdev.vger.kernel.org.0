Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466B64ECB7D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiC3SOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349874AbiC3SN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:13:58 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199EF3ED16;
        Wed, 30 Mar 2022 11:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zenqFNVZNHbyE8ohECsWWLdJRxtHCCmc/O9Ihzlzv8=;
 b=G/4+WxeKQRqNw/gRwcxQoWxjhBaexVySCdGpDoV+kxkdwE9uuViAaQ62hEaURI1jYt8cAT+7SFgf/D8JQrgnwQAKTUyYsdFi1Z7m4A9nDMSckKxp+7Dz41v0GbhZc8bJ9j5qd+113K8jk85YG8CpSPM5ccAipSMD75Dss7evwpc=
Received: from SN4PR0201CA0053.namprd02.prod.outlook.com
 (2603:10b6:803:20::15) by DM6PR02MB6138.namprd02.prod.outlook.com
 (2603:10b6:5:1fd::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 18:12:10 +0000
Received: from SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:20:cafe::bf) by SN4PR0201CA0053.outlook.office365.com
 (2603:10b6:803:20::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Wed, 30 Mar 2022 18:12:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0031.mail.protection.outlook.com (10.97.4.64)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:12:10 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 934FB41D82;
        Wed, 30 Mar 2022 18:12:09 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=newGDtDHY66MugRK+uw95QIcKbNjzY4/a20ENx0q/r3i8zk70taQlwSFTD4gPZaEAFr6x9IC+fvHkbyGrqqqC3IWr4VjNc8dRGr7ACOpj8tFMebAZXrqAf+BScjfc1RrY3zDJkTyIMvGXkACm04r5DRUtTvQzKVFdUddzO49hfxfaRs+dcGT6ieViEVzmTZbRqaI86wOwmue/cSvj0IweT59N+xBw1wCI4Jd1LR+G6n1DVHcUiLAK89inFtlRismN/vP7OcPhzmKZ+2C+pbgxvNE7fpIe6zRApphFYGMUSXeZMHLZCwQgCr7kWP2kh+IOo0GuvKT1E1Rp3ID8Bv6Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zenqFNVZNHbyE8ohECsWWLdJRxtHCCmc/O9Ihzlzv8=;
 b=hwimoE+I1ntzHEZaYZDCzlk3wKmt9LOwR9r8n4reebB4DP8Anl0qIgqGsEh1DvpwnGbn+cqRW4j1I4KpZkOcVL8zWMKTnT4Q3P7uIsRNbGWF9ib5bE+NRuiZ7n6bHw+PLvA5Kx4ZRgP+8cuBTSWkKa1+3hbB+8yWQLsHvEopPR792XbAFv0FQOxA1oLRho6DEchLoKCkyTWTwz6rOj451vfU5BlXFEc2SsxXtak4Qru011EhgaFKs134Fx4FCyVqec3PFYeWQB3PyUO9+n4zN3d+o2oKeTF5VMVK6BlSOK9wzAH6kOARXdQGGziA7e1wPux3qXvREFAEiHcM/5D44A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN0PR04CA0107.namprd04.prod.outlook.com (2603:10b6:408:ec::22)
 by CH0PR02MB7914.namprd02.prod.outlook.com (2603:10b6:610:113::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Wed, 30 Mar
 2022 18:12:08 +0000
Received: from BN1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::1) by BN0PR04CA0107.outlook.office365.com
 (2603:10b6:408:ec::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:12:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT061.mail.protection.outlook.com (10.13.3.184) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:12:07 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:11:59 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:11:59 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 elic@nvidia.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcnW-000CCQ-G0; Wed, 30 Mar 2022 11:11:58 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Gautam Dawar <gdawar@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 08/19] vhost_iotlb: split out IOTLB initialization
Date:   Wed, 30 Mar 2022 23:33:48 +0530
Message-ID: <20220330180436.24644-9-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 15c36d53-040e-445a-28cb-08da1278cee1
X-MS-TrafficTypeDiagnostic: CH0PR02MB7914:EE_|SN1NAM02FT0031:EE_|DM6PR02MB6138:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB6138D0FEBFFBB4EF6F04AF95B11F9@DM6PR02MB6138.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: u43bh7yShunAU5HQboxzlx2dVYriSG0NcP8YFj/c2GvXvp3hV27MI1jIETX6ofrDW0RYoPxy3AC+uUFfdlp66BK6dQ7WpzZKkTNSPbLDelC9xTX1yiq9vJFZgl+kxcZeXmETfXgWCc1vx69ZQeVrzA/+d0+l244Ra3ctgt6Cl45rAxob8VmcEZlIzyIsMSeBL2fzfoQXi6OW5EYipL/nV9a+phyVYqBmmeiSnyqJSfXVhGE+mzC13cPpgQi/odjTasYz+ihSUupf3nL75Ldfe4b3NhNNFJlETl5rTXlLD/sLm/FiSecjJRevaU5KpKduG48Owpj3qZmYrzmdQAzkQhSDHx2zaZt8dczkKA+9QLhfa6IDQq9mFGK7yyS4VXim9+GGWbXZMDYpDXMgKXKAA1ufH+bz83/aXe1qY+DgCG2YK0cWoybYHo+ubZZwrjCocEwklLY+WKi7xuO6Qp6mhYKaRISlB84Zn32aJ2CclaevGmZ/qI99TdXB74UdggN+56wbNzOwOmfLV7CzX42VwYba4xmhdAiJ3OSEcOoJHSDQXPK0GXHBoHuMUua7ZeWMEOQdHUfktymmKQSSQnBw8eH2JD72fj0MfVH5OgYVKztea0zVmKh05BQw+AJI5b3b9dUuRgadfMMLlWWWDmWkMqltLK5x8evWOhaszuPbPTWFySIhpSsJffbz+43dWn91brW+grFNVQ5CAyeIWVaP59FxTq5pBvh3F1gL1hBEoAM=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(110136005)(2906002)(8936002)(70206006)(7416002)(4326008)(7636003)(356005)(186003)(2616005)(26005)(7696005)(316002)(70586007)(8676002)(336012)(6666004)(83380400001)(54906003)(44832011)(1076003)(426003)(508600001)(36860700001)(9786002)(40460700003)(47076005)(5660300002)(82310400004)(36756003)(102446001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7914
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: c9e7c293-0860-4ce9-8466-08da1278cd80
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZWyGcwfKu95775rnYbkFzY6oQwXpePX26fLN6WrzR/uqLwS7q4EwQQ6o/SzZYctWO6kf3gLNBt0nCrOcoVLnXbhrxfYgPD6jRSUOKe/rCn+Btr62JpbXdL2+T46rwtwVvVKEpR/vVK472H/ylLmUOA++TjQdOQp0HZzHvpIf1Cr2nmbg2uAnh2rDUjv1rRProvZ3InFaze7AU8GFHkJqlB0t3d4SrwLaQdbEYiTqjtPPAO1B7dgD00Np5oj69KKZp0pjFzNhAJ5J1qxqD8d/4iEmXLOmhqMbR/tEY35pHWN6OBCxs+uznNGZ0bl+Fg0YX6gE6CkzkB/7RzVtuY538o04DCHqTeo2Fo5czXiG0yShcyZULY8VGfAwJhX9QCeSyZogBH9RUEiRCTVGZTc8DI9P4eyDrA2or7XdQwMEb1BIp/zHlCxNn4rnw1xi3pYDAEjBEY/u7aHPl5ZJwh3satAnw8FQoAMuApdyL1iBbyTsNSdCnmXbQ8BOGNeiNagYdLlSwz7xJ7C5AqH9f0xMVkiet1p+UolXGoCf8GzefT0tAEi1y6NGnkhMXN6dyMZjo4LhzYIJ/zwL+mvhbEE1uRUyWFLd16H/aw3+IHXRwIhFumxcRCvGKQw+RE1RICuOg1YaAfIB73+YljaMrtJx9mFKYopyg975ICOB059i33usSiRIWNdSqs8hgrtBii1PgfK/0I3vQPMXj4PPwv/TwEEfXQVfYMS7NU7kK+ulfzLQ+ieQPNTEjanRU3e7Lksg64kDpdSlmn+12CVUWLVB1w==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(44832011)(82310400004)(36756003)(1076003)(336012)(426003)(54906003)(26005)(70206006)(8676002)(40460700003)(81166007)(4326008)(110136005)(6666004)(2616005)(186003)(7696005)(8936002)(9786002)(83380400001)(7416002)(36860700001)(5660300002)(47076005)(508600001)(2906002)(316002)(102446001)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:12:10.1178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c36d53-040e-445a-28cb-08da1278cee1
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0031.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6138
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch splits out IOTLB initialization to make sure it could be
reused by external modules.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/iotlb.c       | 23 ++++++++++++++++++-----
 include/linux/vhost_iotlb.h |  2 ++
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
index 5829cf2d0552..ea61330a3431 100644
--- a/drivers/vhost/iotlb.c
+++ b/drivers/vhost/iotlb.c
@@ -125,6 +125,23 @@ void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last)
 }
 EXPORT_SYMBOL_GPL(vhost_iotlb_del_range);
 
+/**
+ * vhost_iotlb_init - initialize a vhost IOTLB
+ * @iotlb: the IOTLB that needs to be initialized
+ * @limit: maximum number of IOTLB entries
+ * @flags: VHOST_IOTLB_FLAG_XXX
+ */
+void vhost_iotlb_init(struct vhost_iotlb *iotlb, unsigned int limit,
+		      unsigned int flags)
+{
+	iotlb->root = RB_ROOT_CACHED;
+	iotlb->limit = limit;
+	iotlb->nmaps = 0;
+	iotlb->flags = flags;
+	INIT_LIST_HEAD(&iotlb->list);
+}
+EXPORT_SYMBOL_GPL(vhost_iotlb_init);
+
 /**
  * vhost_iotlb_alloc - add a new vhost IOTLB
  * @limit: maximum number of IOTLB entries
@@ -139,11 +156,7 @@ struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags)
 	if (!iotlb)
 		return NULL;
 
-	iotlb->root = RB_ROOT_CACHED;
-	iotlb->limit = limit;
-	iotlb->nmaps = 0;
-	iotlb->flags = flags;
-	INIT_LIST_HEAD(&iotlb->list);
+	vhost_iotlb_init(iotlb, limit, flags);
 
 	return iotlb;
 }
diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
index 2d0e2f52f938..e79a40838998 100644
--- a/include/linux/vhost_iotlb.h
+++ b/include/linux/vhost_iotlb.h
@@ -36,6 +36,8 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb, u64 start, u64 last,
 			  u64 addr, unsigned int perm);
 void vhost_iotlb_del_range(struct vhost_iotlb *iotlb, u64 start, u64 last);
 
+void vhost_iotlb_init(struct vhost_iotlb *iotlb, unsigned int limit,
+		      unsigned int flags);
 struct vhost_iotlb *vhost_iotlb_alloc(unsigned int limit, unsigned int flags);
 void vhost_iotlb_free(struct vhost_iotlb *iotlb);
 void vhost_iotlb_reset(struct vhost_iotlb *iotlb);
-- 
2.30.1

