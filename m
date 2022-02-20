Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB724BCEF0
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243919AbiBTOGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243902AbiBTOGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2045.outbound.protection.outlook.com [40.107.94.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1267135856
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iu89AZlb+7QnO0hrLDV5vr/UAe9XNnXSER2uP1paeA0Eg9wY5c2iVAkOhBhIg25/vBgf7mD8MJFOE6+9drRITreoZuDRf7IixBYUUKZ/xH/DRHL3c50dfRLbNiLYv/lpoD+vtIAuQaY5LRk3H/Jv1eaHPQnKx4jgODNl5lBY2M417VdaW9qAIwfFhR9nDm6gZlVChc1J/P3l2TTaHO3I2P/mhyd1duEidgvXqVWjIfBoZHLI8EdVQ0/tZ8M1yr0s5KAM8dthxNEFoF9HS++L/DRVta4bpY4aqrEfn36psc08YbLRcyCTR94wSsnalvImS5NbU94XJ6fr/6/vkdQH9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TpFcBFqylHrn3cTaAoyCxxLQWrk8xlb6Gfuz3fb35o=;
 b=Lz+Hwg6lBlKoH4zyFskx1bJSzoSAcNd3AoYQUvh2Qbiy+GHD9jp1u3zzDRFaicRGUh9C/c8c//C397IciPl2egAXJXK1n50ye6YcJdgDKyuKg+Nm1Z74U4Dx5UempZ+jhCy6oOVhDjwZO8dVXQbVfP7e2UWbx06f7aGXLY1u4RFryrUxpLxGPi/QSnUpt7ujS+TWNGyMOxVKbLudtUNyrk2cIUojGrnN+FhcFAA+oavzUfb+oT4Y1LKSjHRvGdoxt4E61gtdkIp86UDBIZHnYx2+XUxvdUj0YbMl+4/2gWiGzQyNt9ZOKx/et9XVFwy9DgllUyFmJUvTmNLJ1K06HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TpFcBFqylHrn3cTaAoyCxxLQWrk8xlb6Gfuz3fb35o=;
 b=A7onUqDFxRU1jFhx6JKrHlk3SDKbsxCmm8uXCQaOmuMtDEnQUvOmUHPs6KZb47SBIsYRHoLHOSZL8CSdEeiE+xmqhM/6Rz9r2iymM+m3Ss+TlW7Qyg1JwKHJgSQCrHYSj0vSid+WC6CzKTmDB0ulZwaNMgfW9s8bdvv95njHRU0rkMMNMeRwST3z174Nmd2JFDAzqu+iFHKZbpHsX37fa9vyymLn4L2uyJg47lfypTIQO6ZC2W4UHSTBnfqtRjeCIMds09gA+EmI7RN7F+yqLDAIZm5vnMOawHK9CUPLeHmr/lmil/unq98AeyEkOPAQ4qoBhTT6wqdbWBR+34IvHQ==
Received: from BN9P223CA0002.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::7)
 by MWHPR12MB1917.namprd12.prod.outlook.com (2603:10b6:300:113::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sun, 20 Feb
 2022 14:05:35 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::f3) by BN9P223CA0002.outlook.office365.com
 (2603:10b6:408:10b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:32 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:30 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 03/12] vxlan_core: move some fdb helpers to non-static
Date:   Sun, 20 Feb 2022 14:03:56 +0000
Message-ID: <20220220140405.1646839-4-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b318579c-01be-422c-9f4c-08d9f47a0fe1
X-MS-TrafficTypeDiagnostic: MWHPR12MB1917:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB191702436310D73545ECF9E7CB399@MWHPR12MB1917.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6k4G2Y5GZTsSmBV620XMl3ATJmtPG9OANBqnyyRS9tRMFxNyvaJcBo3uJEmbj22PMLI//WOmkVtFXpDypW8P7IUl2ZSbkTY2wH9l8ejReXimMNWuEbAhiW14QIFKh93MRyA2U6Lq1GjnFPbMeviQxwilA0ppsQ0i0YZN68XYd3f6+MDE018GQaZRDStAua2SKQIbnwTvtZYN99N4iZphefhrvFswxVJ+WX863CPai6QU8XHlHs3ZHvEP3rlX87PjB0pBIaYZTDZ8y0WpccrhMbI1iZTEF8h8/85EjNYcJu80XXh/Jkh8I0YVUJRT+hRG5gjdcxHOxVOk0gVMXQUAKtIUztRkAMO6Ar4pWJp2BZXmHR0ypG+ir5NSb9cmylsvuGESgQnViEJGQcOmslD8gfoci9cTT9cLzjcg+RZFBTMdXP2FBjavDOkj+oQSqHlOVPYCJfd9kb/orTrt8Rc9BRzSNxHvedkHnr+1LMvX4jSNCjEhQEvfev5iauUyzyktU+vvHZP7q1AULRa0Y5LBPDF/gtlzGt9JTWvfI7EHwnDfWvkWhrtXtji3ZuXqjAAFL2lY1xfiZOMOUjawlIgPUvpU1ACb/reZ+yxPKj9zPZVvgFBNskK3RzdDZtHo50Yb2KJF1zlk6JEpxUgKB8bor6pOxqMDzgZbTaeAQU2K1fNAkbmTzrcU2PcDM6sfQAbg3xXniKEpajzZ5rOWrZ30A==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70206006)(4326008)(8676002)(82310400004)(2906002)(86362001)(81166007)(5660300002)(70586007)(356005)(8936002)(26005)(186003)(336012)(426003)(2616005)(1076003)(6666004)(54906003)(316002)(36860700001)(508600001)(47076005)(83380400001)(110136005)(40460700003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:33.7705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b318579c-01be-422c-9f4c-08d9f47a0fe1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1917
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch moves some fdb helpers to non-static
for use in later patches. Ideally, all fdb code
could move into its own file vxlan_fdb.c.
This can be done as a subsequent patch and is out
of scope of this series.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c    | 54 +++++++++++++++----------------
 drivers/net/vxlan/vxlan_private.h | 20 ++++++++++++
 2 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 5856ef92b9c9..c4e76c5c3b9e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -418,7 +418,7 @@ static u32 eth_hash(const unsigned char *addr)
 	return hash_64(value, FDB_HASH_BITS);
 }
 
-static u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
+u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
 {
 	/* use 1 byte of OUI and 3 bytes of NIC */
 	u32 key = get_unaligned((u32 *)(addr + 2));
@@ -426,7 +426,7 @@ static u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
 	return jhash_2words(key, vni, vxlan_salt) & (FDB_HASH_SIZE - 1);
 }
 
-static u32 fdb_head_index(struct vxlan_dev *vxlan, const u8 *mac, __be32 vni)
+u32 fdb_head_index(struct vxlan_dev *vxlan, const u8 *mac, __be32 vni)
 {
 	if (vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA)
 		return eth_vni_hash(mac, vni);
@@ -845,12 +845,12 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 	return err;
 }
 
-static int vxlan_fdb_create(struct vxlan_dev *vxlan,
-			    const u8 *mac, union vxlan_addr *ip,
-			    __u16 state, __be16 port, __be32 src_vni,
-			    __be32 vni, __u32 ifindex, __u16 ndm_flags,
-			    u32 nhid, struct vxlan_fdb **fdb,
-			    struct netlink_ext_ack *extack)
+int vxlan_fdb_create(struct vxlan_dev *vxlan,
+		     const u8 *mac, union vxlan_addr *ip,
+		     __u16 state, __be16 port, __be32 src_vni,
+		     __be32 vni, __u32 ifindex, __u16 ndm_flags,
+		     u32 nhid, struct vxlan_fdb **fdb,
+		     struct netlink_ext_ack *extack)
 {
 	struct vxlan_rdst *rd = NULL;
 	struct vxlan_fdb *f;
@@ -938,14 +938,14 @@ static void vxlan_dst_free(struct rcu_head *head)
 	kfree(rd);
 }
 
-static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
-				     union vxlan_addr *ip,
-				     __u16 state, __u16 flags,
-				     __be16 port, __be32 vni,
-				     __u32 ifindex, __u16 ndm_flags,
-				     struct vxlan_fdb *f, u32 nhid,
-				     bool swdev_notify,
-				     struct netlink_ext_ack *extack)
+int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
+			      union vxlan_addr *ip,
+			      __u16 state, __u16 flags,
+			      __be16 port, __be32 vni,
+			      __u32 ifindex, __u16 ndm_flags,
+			      struct vxlan_fdb *f, u32 nhid,
+			      bool swdev_notify,
+			      struct netlink_ext_ack *extack)
 {
 	__u16 fdb_flags = (ndm_flags & ~NTF_USE);
 	struct vxlan_rdst *rd = NULL;
@@ -1075,13 +1075,13 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 }
 
 /* Add new entry to forwarding table -- assumes lock held */
-static int vxlan_fdb_update(struct vxlan_dev *vxlan,
-			    const u8 *mac, union vxlan_addr *ip,
-			    __u16 state, __u16 flags,
-			    __be16 port, __be32 src_vni, __be32 vni,
-			    __u32 ifindex, __u16 ndm_flags, u32 nhid,
-			    bool swdev_notify,
-			    struct netlink_ext_ack *extack)
+int vxlan_fdb_update(struct vxlan_dev *vxlan,
+		     const u8 *mac, union vxlan_addr *ip,
+		     __u16 state, __u16 flags,
+		     __be16 port, __be32 src_vni, __be32 vni,
+		     __u32 ifindex, __u16 ndm_flags, u32 nhid,
+		     bool swdev_notify,
+		     struct netlink_ext_ack *extack)
 {
 	struct vxlan_fdb *f;
 
@@ -1232,10 +1232,10 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	return err;
 }
 
-static int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
-			      const unsigned char *addr, union vxlan_addr ip,
-			      __be16 port, __be32 src_vni, __be32 vni,
-			      u32 ifindex, bool swdev_notify)
+int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
+		       const unsigned char *addr, union vxlan_addr ip,
+		       __be16 port, __be32 src_vni, __be32 vni,
+		       u32 ifindex, bool swdev_notify)
 {
 	struct vxlan_rdst *rd = NULL;
 	struct vxlan_fdb *f;
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index 6940d570354d..6b29670254a2 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -92,4 +92,24 @@ bool vxlan_addr_equal(const union vxlan_addr *a, const union vxlan_addr *b)
 
 #endif
 
+/* vxlan_core.c */
+int vxlan_fdb_create(struct vxlan_dev *vxlan,
+		     const u8 *mac, union vxlan_addr *ip,
+		     __u16 state, __be16 port, __be32 src_vni,
+		     __be32 vni, __u32 ifindex, __u16 ndm_flags,
+		     u32 nhid, struct vxlan_fdb **fdb,
+		     struct netlink_ext_ack *extack);
+int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
+		       const unsigned char *addr, union vxlan_addr ip,
+		       __be16 port, __be32 src_vni, __be32 vni,
+		       u32 ifindex, bool swdev_notify);
+u32 eth_vni_hash(const unsigned char *addr, __be32 vni);
+u32 fdb_head_index(struct vxlan_dev *vxlan, const u8 *mac, __be32 vni);
+int vxlan_fdb_update(struct vxlan_dev *vxlan,
+		     const u8 *mac, union vxlan_addr *ip,
+		     __u16 state, __u16 flags,
+		     __be16 port, __be32 src_vni, __be32 vni,
+		     __u32 ifindex, __u16 ndm_flags, u32 nhid,
+		     bool swdev_notify, struct netlink_ext_ack *extack);
+
 #endif
-- 
2.25.1

