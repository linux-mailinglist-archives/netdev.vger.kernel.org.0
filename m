Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375984BEFB9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239418AbiBVCx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiBVCxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:21 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D121F25C7C
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfS0WWPK4TnO19+D23VdbToZdU1NMZfcEM195GAj6dA6VtGhZfcbhRL0623fvv3l1nlyZUSzSgp7R+aLvjH+ooNAfCdZRsUMSsPpkcfAUG6lR9GK9fu2wAXNHX7daEYBDFMmzEA8SverIenYYwnR+cJTouO8olhgo01WzHK6cYwzrIWBEBf5UIvaurGks5njldVmP5ssI7+DKvk2TZSjLnx06uXwzsBxhGgm+xQQk7aSr3L3A5Q4rwP6cv0krP6ydalFJcppZ3k0p9Vq6D2EUMKQf+we5uoqfBHfkmumLrUN6PHXqEOSCt+fR+diBWGmVN3C6cqBL+aRuGt6spr/4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1snBE3sMBACWZBiCZZlX1qip0hPDvh7E1WzhMtzkzQ=;
 b=eOmQmnJ+T1DNKaAXTHSydth9t6SrTj4ix+Dc4s8eLRtnIktlt84YW1W8YEZhn+YoJoB/FJkKfMtd/rW+GH9Ku7HeH4vtVgFNg1FKyvqdguMn4oFYlNyysOa9bYwc328qqgmIooiMpF7opMC9aqmLXWJQrwpWBfIcizj11X10tvGK7/uwtdSEKdJhOu/qeNIDcqD2f5+ZgxU4AIgMUN3xLGfc29PAzfUszL+m8ZWadtPEySoreM6c82rlEMv2ZYlMtWWJi8BF8qGNBfJLzbvgd7du17XrS7sr/Oom4d8/f12UjNOq770Y3gTxbWkShUT0l+0kS/Scm0hu8Xd/yJHBJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1snBE3sMBACWZBiCZZlX1qip0hPDvh7E1WzhMtzkzQ=;
 b=IarvQ054NdNKwZFt2mktMwr9iVo2eWseWtZ+5al1gayyfJWTJQ95YYRpm7qYQMhs2emqscJuJseKKCCDFhweCWabQj9BAQy9DdaTwQx89JzVs5n7WZq//atWMkcd9sc4PuBdQuOB3po5kFqTP8kffPRkb5EGfDreUQQfKhRAEXKq3zCgqU3HPX/M5RZuF4Hhrqz7EWm0aUpSaUI+D/EAFIlBTTyKk/TuK2J861ZZN9S9yrpIEjKyCYPnazjHm1FZImBzjbEuuf015YS4DCbHa0KlmESfHpJebJK+m+JivsJMt8P1/ChKfyIvLpGkJjBHy6/Yn6lSXC7DGKxq4DeiNg==
Received: from BN9PR03CA0872.namprd03.prod.outlook.com (2603:10b6:408:13c::7)
 by DM6PR12MB3484.namprd12.prod.outlook.com (2603:10b6:5:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Tue, 22 Feb
 2022 02:52:53 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::c7) by BN9PR03CA0872.outlook.office365.com
 (2603:10b6:408:13c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:50 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:50 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 04/12] vxlan_core: move some fdb helpers to non-static
Date:   Tue, 22 Feb 2022 02:52:22 +0000
Message-ID: <20220222025230.2119189-5-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51d47c6f-79e1-43a4-c5af-08d9f5ae6b9d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3484:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3484FD2C0267A9B98642B644CB3B9@DM6PR12MB3484.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PpFD25oc86/9HGJDOAW/cHyoEz5XHHGg/aDoYp3n5QUEq90iBeCNOcjmVvL755gf3Clugw4pMYvaEmMUspkWvKlU1rfLRsoNzpNIikFrplk22YHFik+vhpnLNbcqjD3DG1a2Jk1jEkS+ccTaLAg+ufT1v6wgeUf9AEXETBgvNgq6xnTCFQCBEsJcR4fzkPbfm5EA3qqBvbEDHl5e1brHXFCMPcfVQA4zDbY7IYF2r9lQ9q+qc7g9y5fp4zD3y5pJYBS/jPk7n3fX2r7d0BhypzN2Wc4ST86VqQyiG78bWMGmqTTOE4mW0sqBkzOdYMPiswTUcrUl0lnOkHQXBomD5SA78M2xGZRSSAxCqifyjsSdvRiNeSZP93DuLWr07pIudBy/Fb0VmvNEP6/gKZAOfQyl+cV99C/yyuE4uYn5KZcEpgtJ74E7K6Is8TG5HlwqhQullKYqu+YH0xc9Rq8SzQkG47xrB9UAR+g0Om26C5tbQZlKc3fTpKVNSesqQDKqCz9dMoyHtWmAB6ibw0g6dOOvY5ZXDJGFZJ795XAuVcBgKiT2sRAoes4oxWwNTT3e9M4o9HvvzZIp8Ay4XmrQmgGsg8GXmUbzgxy5k4wa7A7J6rYsheB6g1o7TGVgelOo4wZjcJv8shoG4PtjdxnSYwnXB1V0yfZQ8z1XMJtiJVfYScB1BTSuKLNXVNfGTKCXgYZZuu0hD5h5b7rGV7gPwDY/jXhi6TZ1epHNT6oN9Mt2oyyVjrIK1/vt1ZjIerZr
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(426003)(47076005)(336012)(83380400001)(36756003)(40460700003)(5660300002)(2906002)(8936002)(26005)(2616005)(1076003)(107886003)(186003)(36860700001)(70206006)(70586007)(81166007)(356005)(54906003)(110136005)(508600001)(316002)(6666004)(86362001)(8676002)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:52.6533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 51d47c6f-79e1-43a4-c5af-08d9f5ae6b9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3484
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

