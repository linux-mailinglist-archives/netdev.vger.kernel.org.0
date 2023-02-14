Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF80696532
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjBNNom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbjBNNoB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:44:01 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047AE65B3;
        Tue, 14 Feb 2023 05:43:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jA5a0583n6W4zJK8zHM54X86D+bOXk03O2cYnmKXcqibtaJTY5voqjbE34UJ7TGMCMOSIQfqCR4eU9mSBNIIyA0pQzdeBR7HjLZrTNtPRIihvg/whYybBIOq7xbdYAsL1uc26XvI1X2RkY5ARUp4OA7RRmmXElWRhO6DclkwIcuWUrwP8seAyUU7EXhpHAkun25iprrjsaUag/GpSEnLyGp3MxM/DgXHS45v635oe2VWlKnMk4xE26TaN+u37QY0HKN3CwLdfPLGgtD6DUI7v/TnQZB6CAOmrPL5WC503HwxmhRqycuIUN/xTFloMEqcusyS9+ua7iJNJ7eYcWvf4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JCwTRebozR9QmVm37XQ12xMMD8arV/C4js/BSxuccs=;
 b=JrJk85UeJ99QBph0WHWtmgeS/s0pe7NNRDZwb/m1bCD5E2erOQ1oTE1uiyFEjS98xQBNhOYS/02h+wKxFeDIdLvtltJcVu7fZbPpTMZGN5xEow1E0GZcFDMkJ1decksgrd/46kEUCTIYzalZxFJNpsD6BJU1SOygnHhsxYATJfSew9uZL65vupgb1sTEpCgF7IXUUn2LC6/TbWxUH9ThazCMcxpw5ZivGC4Ro6rGrK3wk3X0LFzz39ZygCaG4w4z+QhuwuW1oDLguNZIUSqJLEkgWz/VTr4NxqRBuU2lvUvDsm1VNcojNsZMjJW8fV5uk/a0GqiDI9tKptVgrM4yXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JCwTRebozR9QmVm37XQ12xMMD8arV/C4js/BSxuccs=;
 b=TRZymOQvQ5RHFolNqyHj0m6yYCV1GE3KUVoR0R2X7GbJrFaDElQhpUBLCQ46uBvfoFloZPnkIXG2gTQLBDVxBufRWQlUhjHASvOvsTLFcx+v7a7/xR8Ufeu0+P1yZZ+RTkRnkvYOINvWKQLEaj7kxUWE6f0HFvqbRJRthFAsK+rhIXcmNEHtzPrX7B9pfK+Yo1PNjSqnqN2oXBina8clOCd3UV35kkhQ2Dp0iK5mFjPmZW1whM2+xEe6MlgYdBjt/ttJDIhkG0iNvRQnyHo6/RTLYg4P9WcOOFMlr/CqKLziuOI4tbPN41hbL0zDjYeV1x8b/4Qn72oHvpAhAmWDLg==
Received: from DM6PR05CA0053.namprd05.prod.outlook.com (2603:10b6:5:335::22)
 by IA0PR12MB7650.namprd12.prod.outlook.com (2603:10b6:208:436::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 13:42:16 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:335:cafe::14) by DM6PR05CA0053.outlook.office365.com
 (2603:10b6:5:335::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Tue, 14 Feb 2023 13:42:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 13:42:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:09 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:06 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 1/3] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Tue, 14 Feb 2023 15:41:35 +0200
Message-ID: <20230214134137.225999-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214134137.225999-1-gavinl@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|IA0PR12MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2b27ff-ea61-4fb8-9c68-08db0e9148df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ec/6jxvi2KsHLw1hvGtRzoanWvM6nI5c5vs+M4EZXyNfN0IOy/yMnN1sKry/kglTOyvDSqEd62OOsj5ONXRYL8powDfTiyiFghNvUUUM6iatngJrmNOnnjimYIuk8upgpGIvI9L6hMCJkE5qcE6dwDxBP5oqJICieFzfCdzTe/zMSUIcORhqbx71t/iysu7epBNvpv31yd+96knkrTQRJDUEo5OJnWT0u0SGzAnqcpwW2sjct+EPnOMYrF2SfrQfDLCDE/hzsa2PGWSmmCCIRYb66O13VfvdnalBx8LoD2idIUitl1ZPW+9UjwS9nUpIGLgavHROhz1ZBD1sTE0uXORZmiY+mKjJpzLKXlE9vSo2ja0SI/QdyXIS5l6jh62lxj/7DcnaOKuJ6GwNedIQUiebIDJL94FGqCR7hGoVrP9KRqh7WeErqrjemlATu9Pu+6Mxp8vtIqNRvHVM2vb9I9ti0VX0xz1D7l6ZqaL7bfsoQKPOovXxZtzlMz/SZPCFWGbx0eCMAZWfwCAWtwsdZuAw07cbozSeBePsBUO07phLERm2Eg0ipT5zERlAcZkkkK0OhIb3bS0S873JzIfyidF7EYJ2Iooi6l6dQgaogSXFfy6Hvec1BIJQtYy1YEqEsLS/Okd195krYkw0TQ0gGuj9GjQY+uZb0ZLSJGmtOrm51ytJfavbQ3bq/61XVGpm0tlS4/b5cTNjiEBR0kkCIw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199018)(36840700001)(40470700004)(46966006)(26005)(186003)(6286002)(16526019)(1076003)(40460700003)(2616005)(356005)(41300700001)(70206006)(70586007)(4326008)(82310400005)(86362001)(8676002)(36860700001)(8936002)(5660300002)(2906002)(7636003)(478600001)(336012)(82740400003)(7696005)(47076005)(426003)(107886003)(6666004)(40480700001)(55016003)(36756003)(54906003)(316002)(83380400001)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:42:15.7155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2b27ff-ea61-4fb8-9c68-08db0e9148df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7650
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan_build_gbp_hdr will be used by other modules to build gbp option in
vxlan header according to gbp flags.

Change-Id: I10d8dd31d6048e1fcd08cd76ee3bcd3029053552
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 20 --------------------
 include/net/vxlan.h            | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..bd44467a5a39 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,26 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
-				struct vxlan_metadata *md)
-{
-	struct vxlanhdr_gbp *gbp;
-
-	if (!md->gbp)
-		return;
-
-	gbp = (struct vxlanhdr_gbp *)vxh;
-	vxh->vx_flags |= VXLAN_HF_GBP;
-
-	if (md->gbp & VXLAN_GBP_DONT_LEARN)
-		gbp->dont_learn = 1;
-
-	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
-		gbp->policy_applied = 1;
-
-	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
-}
-
 static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
 			       __be16 protocol)
 {
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index bca5b01af247..08bc762a7e94 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -566,4 +566,24 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
 	return true;
 }
 
+static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
+				       struct vxlan_metadata *md)
+{
+	struct vxlanhdr_gbp *gbp;
+
+	if (!md->gbp)
+		return;
+
+	gbp = (struct vxlanhdr_gbp *)vxh;
+	vxh->vx_flags |= VXLAN_HF_GBP;
+
+	if (md->gbp & VXLAN_GBP_DONT_LEARN)
+		gbp->dont_learn = 1;
+
+	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
+		gbp->policy_applied = 1;
+
+	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
+}
+
 #endif
-- 
2.31.1

