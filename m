Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A424C82CE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbiCAFGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiCAFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:14 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123487523D
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giJPZVJmyzBS94YjbCE1SnASBk1Ld4NUmvNwQv5+tnm7fdUR6SQ+A39XQb+mcdCs8bcLs64DKmadcmtZCaETRz6j1MMAyCNT9D4yLdKWzj7r6HbGdCILeCEspinreXXofQXzjQgKkcimekkd3dY+9DuPrY2R246WdhyzrD1uXyuvi/4+M2zs6esr2li7DhhCQ3eTgbJXbNXQU5rmxxuA19Fwevw0AhBCH6Fnc/jPxufbuJn8si8DpD3DEQs7T9YGEMh3b4W1ojxhTi1SXc1MwrP08R8Txyb9diFFAAHjYwl0kdi+7hroyAucsozmisRdvXn3H9IM6Qy2qJsqUXim8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1snBE3sMBACWZBiCZZlX1qip0hPDvh7E1WzhMtzkzQ=;
 b=W/TmIwNWpN8HmFw6MzB83lSOoCbGY4XRIKyxrojpdMU8o8BcJ3nrHLof2BYgNZQ15ZSGkbLsu0u1IMOcnGpZAXZGx9QpSjoQdjs1OHsgOJEwziG2E5O15+HGW/KDg5YTzU8RAlXuZEtNVpNJ8feJtGgVpbMk0oy5I/4jmlVUnh8X3qyWSoL8UMeuNqP4LCJRs1vMGF+TOxqJyqCj37htJnZBjz3ygdsv/20FHSuahYw9SC20YQHJ8pqX/X3XP5gc8909zOuzhJr+S1Xs2aH57eTIz6382kRUB73Srn/6irIP8YqZ6C7pLoFb0ODDi2cNHb2kqNSBKFA6kwtoVbxd5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1snBE3sMBACWZBiCZZlX1qip0hPDvh7E1WzhMtzkzQ=;
 b=rPElJAMcwFoAggLhNGYvUV8j8g+xZuJleIV4IymXXOiE/xW+VDTDYiRk1px1fVpxZrDzGwPYccFYzRcJJIDp398jQiq7z7qON5qzxc7TnPq68544p1M6ePKtJ0Wi5qWasK1GERb3hmTL9KDLDWSB/MrKw8sJNZXSOTAsiI3/ZfkvCzAta9X6iWFNSRPXcwVRPet358fmNvkHL5FMIpv+cuZr+T/6o5SxajIkwwKFQNL4j5TQfF8T0/YOe2O5ijzGUHXcmiZhDj1HbK62tEEvnGK9jfsg4HEbJu6Ibvdm5G02LHM8yLEqMkN0ApqnoTK22bvNjsP5GkQhSxlnLWZDFA==
Received: from MWHPR18CA0045.namprd18.prod.outlook.com (2603:10b6:320:31::31)
 by CH0PR12MB5204.namprd12.prod.outlook.com (2603:10b6:610:bb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Tue, 1 Mar
 2022 05:04:45 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:320:31:cafe::84) by MWHPR18CA0045.outlook.office365.com
 (2603:10b6:320:31::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:43 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:42 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 04/12] vxlan_core: move some fdb helpers to non-static
Date:   Tue, 1 Mar 2022 05:04:31 +0000
Message-ID: <20220301050439.31785-5-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45cc1c23-3d17-4c37-4ef9-08d9fb410052
X-MS-TrafficTypeDiagnostic: CH0PR12MB5204:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB52042094A39297617B2A2957CB029@CH0PR12MB5204.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: av/dq/8wGFP4nD7y1gGT0I5i03SiGdbMBFxLFewcDt/MiSXaa0G5M8TvTOt5RYCxQ8UfqlnzcjdRDQrkkjRDVZn2X+pwJIufUmKkYf1HDVM2woCnHMaVNoo2u2JSvqV53Jfm5PYdIzopoWCs5WdCpcV19QrlREOGWpDKF8wOQwSNi7C4EX1KrMlPhQSrF5va4i0ynN52Abw7hQasEDRcuxK1g4AqEg88Y87b8YmnK+u0rJ9Lt5EfPKI7NlG88lJbox3bTJA+MXOl/rnZXx1Ep9NJM4BVz7lqt8jBMI+m1v2cEcEkWUKYlZS9f6ajKHs0Uj/nfPISjsOhk5iASt4+LVfqlogPxk33iuYd9vHEkpEkQQtDWvj4K3+Wz6oyAsNUJd8aJkS/x2H24rtkiozYYUetyw0tvVkLwmXUZ+yX2YYtcxa4y7dVHiSY/uXxVjKN5K0AdqVi7K1kk13Y6+uIP/YcNor36MZbCMq47XPT4HGgXNBRUjt/kHKe1N2znqAhfMyMSotuvcXqiZcvGU40Or3fgUXiq+PFZ8JbtyT5+0+g4x7mnOH0La/+SDONi25vx64GLMSomPWVQd9uyWXONhAbz6THLlWxrAt01g4qDBOkK7J6KNIbLmo025t0XBxeWl1Q+UAw7WHhSUzOItjv5o9yyFvFx7SyoplxnAZrOFrlGe+lj0DyYvChJOeqCdXGJ5MF6w78fP8+oAPccMPV7w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(426003)(336012)(5660300002)(86362001)(508600001)(83380400001)(8936002)(70206006)(70586007)(8676002)(82310400004)(4326008)(6666004)(81166007)(110136005)(356005)(54906003)(2616005)(1076003)(107886003)(40460700003)(2906002)(47076005)(186003)(36756003)(26005)(316002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:44.5382
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45cc1c23-3d17-4c37-4ef9-08d9fb410052
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5204
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/vxlan/vxlan_core.c    | 38 +++++++++++++++----------------
 drivers/net/vxlan/vxlan_private.h | 20 ++++++++++++++++
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index f4ef7d5e2376..2e0fc43769cb 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -419,7 +419,7 @@ static u32 eth_hash(const unsigned char *addr)
 	return hash_64(value, FDB_HASH_BITS);
 }
 
-static u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
+u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
 {
 	/* use 1 byte of OUI and 3 bytes of NIC */
 	u32 key = get_unaligned((u32 *)(addr + 2));
@@ -427,7 +427,7 @@ static u32 eth_vni_hash(const unsigned char *addr, __be32 vni)
 	return jhash_2words(key, vni, vxlan_salt) & (FDB_HASH_SIZE - 1);
 }
 
-static u32 fdb_head_index(struct vxlan_dev *vxlan, const u8 *mac, __be32 vni)
+u32 fdb_head_index(struct vxlan_dev *vxlan, const u8 *mac, __be32 vni)
 {
 	if (vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA)
 		return eth_vni_hash(mac, vni);
@@ -846,12 +846,12 @@ static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
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
@@ -1076,13 +1076,13 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
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
 
@@ -1233,10 +1233,10 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
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
index 03fa955cf79f..b21e1238cd5d 100644
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

