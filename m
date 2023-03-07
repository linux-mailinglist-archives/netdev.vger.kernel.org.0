Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81D56ADADA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCGJrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjCGJro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:47:44 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC7356174;
        Tue,  7 Mar 2023 01:47:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0VbmbOT2u2PaWgpuh3FM/IgU2Sbgkvx9KUxTmlnSQITRBIfIY/eu/furYtCKkKfGxx1EqUQ6k8O5HIatoN2j3AUAxBV7wCMRUDkj7M7wVXTx6tDg918gnoXXVhQ1iLZi8rCuRhmZYWLgexSSqayE9RGstOmMURuzH18IQltuQbjzK8rFXlgH7Oo5P7VN1jReKXaGabOqXR2vkTizFSDmriX+qfQrIOYKfrs5UQiUNtSDw0VW3qxF2aoD2I3S/II4guEatmADA4gLso8nRe8S0OS6SSsHIx76UWA74WcLkWQHtNPU3hQzGl6NOAR/OdxZTZH2s2SMgLgoXXEZV+O/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=FHJZTRMejMuO/XHP/Cx3XmF3X4PM9ZeyWcuzosGBSTiD0iCePpFdzIYIjGdO/1oRoWfeVKcEKsPDGrmhOYBsjqE0hovSbRODeUvZ2Lquwf/EJsBBQ6DbCPKKWXNPVeomJa9CGw6pGsbDmZmJdmQJvM+7PiuvAAIHcXL/1yfu5EgBrjEqSDhnux1KsDxNQmofXZpYBjgAzt5rhFDwMyLD/9RDUvMNXGBzr7f2AzZNMhdcQbgRC44629GnPWMfhH3BS0KtvXo3fgghafb/jOttGU8q2llaqGjAhBk6S9imYOgP5QutrIsp794lP/DLcg6ShMzyP1N/cFMzOxlkHn0QAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujul2KGrmfcoaS9XrNmTunJFhP8wR2gVoIlq74Lykb0=;
 b=EoMOQK6UUBCOHm3cqeiiSEsq1jklQo50TcvEqkLarPpIoW+fDFY94buUkIQQGRuJh+LIbwcPzRomu38kyVMARod1Et3khaSi0YdRMx86qKiGq8pyK5TcUeW5QFfO0nGTQD8UMOOqQtFwCJA5U+TzSFjTTkhjZej9gQUBDjc+RR+GyUHPPl0PIqCaS5l79OOP9106ir83ebYvqxGyQldV3dyKvSeiqm3aTFBp6IJKWXQ/rpiF3x285wt++x/CQAq7SjllJpdsR26DEEj/cMa+dnCuDyEuZ/oc48WjLRoWLSkiCpu1Eo3Q2rL7VD5vhPicoHb23VZ0hQGj7OZpjxLh8Q==
Received: from DM6PR06CA0064.namprd06.prod.outlook.com (2603:10b6:5:54::41) by
 DM4PR12MB6493.namprd12.prod.outlook.com (2603:10b6:8:b6::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.26; Tue, 7 Mar 2023 09:47:13 +0000
Received: from DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::e) by DM6PR06CA0064.outlook.office365.com
 (2603:10b6:5:54::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 09:47:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT101.mail.protection.outlook.com (10.13.172.208) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 09:47:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 7 Mar 2023
 01:47:04 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 7 Mar 2023
 01:47:01 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v5 1/4] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
Date:   Tue, 7 Mar 2023 11:46:34 +0200
Message-ID: <20230307094637.246993-2-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307094637.246993-1-gavinl@nvidia.com>
References: <20230307094637.246993-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT101:EE_|DM4PR12MB6493:EE_
X-MS-Office365-Filtering-Correlation-Id: 816c5f04-1bb5-4a6b-854b-08db1ef0ed81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFVJSZzYC0aBJgcPF5q5nbx3Q/QEuhxQA6nh89rDagz5uO76Umjeem8Hg28/Dah3D9hOm0x6P13YhpImcqU+YgjxqyTD7eoycSGo9bVYeAZOp0whOuvOSXud75+ctU8UeIoDQsn8Ay8DK1rccl3LZcv9TFs1bQE4Ab0d2ZxvOSfhjX1dumsT6/xU/MUQkQHBxTU4TQOPRXT0l1MqrAMTKDvvpsFM6Ox+2Dp0izYfxre6hCJAaIZB6zDPV+6q1vXugQqe9JOj2Q3XEC19sQ8v58IURdBnCDk2OEbF/6CtR+4TQi7m7TWGaP8k2RWFI5o2dLGkkqfDCIfSrjAooWP9xKEnZjHVNOEKLu76IbSpCgvVMVhFciojyf5Nhd59rClITRaXhulOGdeciFlcziE9PTb7BTgNtN+SA0Rs5ZHZL++mOYRr5SmiRAe4Z/6RfVTfxdBY6sizY3qLuhsmk9L6Y5bzfbidbBSlOO6wbvuwI37AWt2ZUHSGQm8M07lNMdP2rdJ3rR6HTzNCCKHGr7kjh4oKByoUARBd2btqJhESXr0bH4sQesREISJ4F6zgQqMqh31hkL9BV/BrxyTeIHiMfO7Swk3vsYPct7qV4Lq64clsntwWRRQb8opUHAc4fcFmnDfKkBbY2QHGifxac1CzQOxR8+K7AsvtcZRaKWJBGUPr9GoMvHQpm4vh/w7qOYYscOCalxC0zK4TMSZHiiBYEA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199018)(40470700004)(36840700001)(46966006)(8936002)(70206006)(41300700001)(5660300002)(2906002)(4326008)(8676002)(110136005)(316002)(54906003)(478600001)(7696005)(1076003)(36756003)(36860700001)(426003)(70586007)(47076005)(6666004)(26005)(40480700001)(186003)(336012)(2616005)(55016003)(86362001)(356005)(82740400003)(83380400001)(40460700003)(7636003)(82310400005)(16526019)(6286002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 09:47:12.7167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 816c5f04-1bb5-4a6b-854b-08db1ef0ed81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused argument (i.e. u32 vxflags) in vxlan_build_gbp_hdr( ) and
vxlan_build_gpe_hdr( ) function arguments.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/vxlan/vxlan_core.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index b1b179effe2a..86967277ab97 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,8 +2140,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
-				struct vxlan_metadata *md)
+static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
 {
 	struct vxlanhdr_gbp *gbp;
 
@@ -2160,8 +2159,7 @@ static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, u32 vxflags,
 	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
 }
 
-static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, u32 vxflags,
-			       __be16 protocol)
+static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
 {
 	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
 
@@ -2224,9 +2222,9 @@ static int vxlan_build_skb(struct sk_buff *skb, struct dst_entry *dst,
 	}
 
 	if (vxflags & VXLAN_F_GBP)
-		vxlan_build_gbp_hdr(vxh, vxflags, md);
+		vxlan_build_gbp_hdr(vxh, md);
 	if (vxflags & VXLAN_F_GPE) {
-		err = vxlan_build_gpe_hdr(vxh, vxflags, skb->protocol);
+		err = vxlan_build_gpe_hdr(vxh, skb->protocol);
 		if (err < 0)
 			return err;
 		inner_protocol = skb->protocol;
-- 
2.31.1

