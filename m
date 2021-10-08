Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC15F426AC0
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241706AbhJHM2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:28:39 -0400
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:29094
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241464AbhJHM20 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 08:28:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSVteQYsfBuL1JrVvOaa7VKFgERqeHdtRC82VFfwWfIFiwn/tFwSAps2xXT1AxKUPrI5OePdV9wWTPtKeQ31gc6DmY/XqRctPhx2Ii7vARM/zM61a+tQLPptv/Chp97+9PECD1+vPT/Z7jKRrh4Bs2Rqz111+uD61VatTIdHVUOC/xBFyr/LL0sAid0n8ywY1r0dqXA5k4MpOlTH0RpXmfdKbz572pb3kTjKA95iRLvYQJuN65IjmM+DpTmqiWLDYEvnWtmFXriUVnJW9YowqxVLahjV8gECEY8hgD4p0Xo3XV0W7/7oMDgvj+bgKLODDPW4WTJltR1w2nVIocOaoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65AI7+lpV1NaLgLYGMwm5DekiaFkNTo8msZrsc0SH98=;
 b=aY8HgR+chcWW+P5DdjLfcCmr0VyeJ8bgFsQXa0Ya4qOFtpWu/fb3bYtpJgTx29/qw/nW8K5EFhuid3SPjhvUgKdcr9epQrlK2qOQqN49Yp+mfPUP1V9Z9ufh3n+mOkJdTm0M/uVKUi5BjEexmRUuxHa+Q/ItiLu6+zDDTsT7z3A6g3RvVF0hMG+934sKNz+QOrnPTBDX0oB2skMgjkyMkeGY5iGAjdwtkvBGqGBI6UXzrJxdXAgbxYPTonnekSiluTUxkGLThXHmxDBCB7JuxTTGeBe0mkqzUdRFOcLM6W7XySclyclk/2GEIxoT/fPrbw0/7xq3nTdyva/2FQ8T2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65AI7+lpV1NaLgLYGMwm5DekiaFkNTo8msZrsc0SH98=;
 b=YOQSjmbn970Ht4HOckdPUdEegPfeddZGAsn9auXjc+DnK+RXUgJtd/2e6VABDm+Cm5nGcVYFPOeaxroziysDNDX+RzJxdzeEMoXQDaGeQi7boPXpFPtR56VX5ryRSGJ7qkgeC5laVAFulZnl5v/r9aW8KKgIKNwerv7WUwQLV6hMgljNS/eN+JEKFy+tzDZHPeLNL0NWFcxAgtkg5hCbzlfwtQsgQxQHAQb2fT0LyDD76DLqc/vyqqHSC5ebbjpVqB/zcsTXcT/vYyFo+ZKF1f2HYIoPAwY0j6tNtTkaNWaUGV6b5xV4pSga9zJ/doQSN5d1A8fQpqoBhMx4yBV6Ww==
Received: from BN8PR12CA0011.namprd12.prod.outlook.com (2603:10b6:408:60::24)
 by DM6PR12MB2923.namprd12.prod.outlook.com (2603:10b6:5:180::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Fri, 8 Oct
 2021 12:26:29 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::22) by BN8PR12CA0011.outlook.office365.com
 (2603:10b6:408:60::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 12:26:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; chelsio.com; dkim=none (message not signed)
 header.d=none;chelsio.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 12:26:29 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 8 Oct
 2021 12:26:28 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 8 Oct 2021 05:26:23 -0700
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
Subject: [PATCH rdma-next v4 08/13] RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit
Date:   Fri, 8 Oct 2021 15:24:34 +0300
Message-ID: <20211008122439.166063-9-markzhang@nvidia.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20211008122439.166063-1-markzhang@nvidia.com>
References: <20211008122439.166063-1-markzhang@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c77bf34-5861-4bd7-6222-08d98a56dad4
X-MS-TrafficTypeDiagnostic: DM6PR12MB2923:
X-Microsoft-Antispam-PRVS: <DM6PR12MB292346D389EC4F9D3E4D5096C7B29@DM6PR12MB2923.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DzWm4rcGfe7MUxJ6Ulis6IOmwWchgG2JRa2oq59ekDfl904kXlAVfnNM6ntY1uum68odyi6fJfoLAfzAgPGFTpI2wA2Yf+qsQJPnY3XEBgYyJcR+kuD94T4OH6htJ3VjbJAZsXqHq60RtppL950pPZNJwCYxuZHRSSNDf06JzxHVmpw8rgeoEE5BYhuEv7GXqlXnG8HQMmpaJGCYepVHjNzy4zoww9KoCepFwDkvNtlDiI2IVwACuvmaf/IBP8O/Lt5xaDoxSkuXMd9pqK6NWvjlUafa4MVXt6UkvkkMFbQC1Sr9xamsBF2wBODNxpEwVLS15kS7vuPkZLSipR8UiwTyVZ2EfgHTPsPWJgJqYh85JVddXzdCwSd2ScPq4IudefT7fsjNfn/wAGUWcpWADwl3FYdmmUUWVfhjVHQBawgDtEO1FMb5DcACkpwqRXtBj14nXYTH4B81ualpK2GUjx0J58Jh4gxWrPl1JpJevt8nqKKl15fhnp9JaLHcGAUJj9FHI2V0xIk32mFdKTjO2l82QzqCRvzV3eYDNSbh5b/duepSuSRllGgRZQe3hOx57JwvcGTSyj9MqZJ4GvCCORiQVmncX/LX+GtdmMvJalXSFfK65EMJYIoMfbl2H//IiFZG7pDE0hz5vtxo88726QJLZ+I3bS3Fk81seN6mz9cxPEgyHvoxh+qrDMpNwBQW
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70206006)(82310400003)(7696005)(47076005)(36860700001)(316002)(83380400001)(4326008)(8936002)(426003)(54906003)(2616005)(110136005)(6636002)(70586007)(336012)(8676002)(5660300002)(26005)(86362001)(107886003)(7636003)(1076003)(7416002)(508600001)(356005)(6666004)(2906002)(186003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 12:26:29.1149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c77bf34-5861-4bd7-6222-08d98a56dad4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2923
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

In order to allow expansion of the set command with more set options,
take the set mode out of the main set function.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 116 +++++++++++++++++++-------------
 1 file changed, 70 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 210057fef7bd..8361eb08e13b 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1897,24 +1897,67 @@ static int nldev_set_sys_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int nldev_stat_set_mode_doit(struct sk_buff *msg,
+				    struct netlink_ext_ack *extack,
+				    struct nlattr *tb[],
+				    struct ib_device *device, u32 port)
+{
+	u32 mode, mask = 0, qpn, cntn = 0;
+	int ret;
+
+	/* Currently only counter for QP is supported */
+	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+		return -EINVAL;
+
+	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
+	if (mode == RDMA_COUNTER_MODE_AUTO) {
+		if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+			mask = nla_get_u32(
+				tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+		return rdma_counter_set_auto_mode(device, port, mask, extack);
+	}
+
+	if (!tb[RDMA_NLDEV_ATTR_RES_LQPN])
+		return -EINVAL;
+
+	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
+	if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
+		cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+		ret = rdma_counter_bind_qpn(device, port, qpn, cntn);
+		if (ret)
+			return ret;
+	} else {
+		ret = rdma_counter_bind_qpn_alloc(device, port, qpn, &cntn);
+		if (ret)
+			return ret;
+	}
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
+		ret = -EMSGSIZE;
+		goto err_fill;
+	}
+
+	return 0;
+
+err_fill:
+	rdma_counter_unbind_qpn(device, port, qpn, cntn);
+	return ret;
+}
+
 static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			       struct netlink_ext_ack *extack)
 {
-	u32 index, port, mode, mask = 0, qpn, cntn = 0;
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
 	struct ib_device *device;
 	struct sk_buff *msg;
+	u32 index, port;
 	int ret;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
-	/* Currently only counter for QP is supported */
-	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
-	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
-	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] || !tb[RDMA_NLDEV_ATTR_STAT_MODE])
-		return -EINVAL;
-
-	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1, nldev_policy,
+			  extack);
+	if (ret || !tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX])
 		return -EINVAL;
 
 	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
@@ -1925,59 +1968,40 @@ static int nldev_stat_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
 	if (!rdma_is_port_valid(device, port)) {
 		ret = -EINVAL;
-		goto err;
+		goto err_put_device;
+	}
+
+	if (!tb[RDMA_NLDEV_ATTR_STAT_MODE]) {
+		ret = -EINVAL;
+		goto err_put_device;
 	}
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
-		goto err;
+		goto err_put_device;
 	}
 	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
 			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
 					 RDMA_NLDEV_CMD_STAT_SET),
 			0, 0);
-
-	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
-	if (mode == RDMA_COUNTER_MODE_AUTO) {
-		if (tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
-			mask = nla_get_u32(
-				tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
-		ret = rdma_counter_set_auto_mode(device, port, mask, extack);
-		if (ret)
-			goto err_msg;
-	} else {
-		if (!tb[RDMA_NLDEV_ATTR_RES_LQPN])
-			goto err_msg;
-		qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
-		if (tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]) {
-			cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
-			ret = rdma_counter_bind_qpn(device, port, qpn, cntn);
-		} else {
-			ret = rdma_counter_bind_qpn_alloc(device, port,
-							  qpn, &cntn);
-		}
-		if (ret)
-			goto err_msg;
-
-		if (fill_nldev_handle(msg, device) ||
-		    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
-		    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
-		    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, qpn)) {
-			ret = -EMSGSIZE;
-			goto err_fill;
-		}
+	if (fill_nldev_handle(msg, device) ||
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
 	}
 
+	ret = nldev_stat_set_mode_doit(msg, extack, tb, device, port);
+	if (ret)
+		goto err_free_msg;
+
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
 
-err_fill:
-	rdma_counter_unbind_qpn(device, port, qpn, cntn);
-err_msg:
+err_free_msg:
 	nlmsg_free(msg);
-err:
+err_put_device:
 	ib_device_put(device);
 	return ret;
 }
-- 
2.26.2

