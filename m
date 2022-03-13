Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72774D754C
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 13:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiCMMsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 08:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiCMMsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 08:48:31 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738D960D90
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 05:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bniOfE0UY3TrMly2rQU+gvxWFMo8QuVGnDvJEMEYZEZi/AvbikJWT1UPUxy6qQceCLnWInUHeMSSPvMdDb7fn8J0EirRCzS0GnziKqvw/UiXv/Ubeqyd789LM7ReOuscaKzqreg1hQvopxUO+NEsj6v8Vb236wm2zx/yz0Vj/xK6TPLxyDukzXqQtsEULSmMlzZGyO7z8oXrygh/QmGi22hm6RrF8Wsjk9T5bKyWONJr4Jrgp4AhyNAeyjC6sq/GKyvUEiKMHr3QIEWSV1FgpQiPSUE6TJ0rMW4bWTKn+7Tf2oFpw1Q1K4TLuSqH87SIVHhfB/bnO7fslHyLB/6FSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fd1gJP9AO15sEsh3QfoNcgLvh6JS6DNtsg6WQWoibtU=;
 b=VVQe1zYiGlYYKwL/+Cd9mcjQ+JRTBLTXKu1vQhE6zuzozi3F+JG5rTnWwoWVYTuQ67MFentaBncpp9N8wWmzWPWfW+kk3lLXJYYNKzTXf7zeVC7g2agiEkaabbxDahkJ9bwb3qgg+QseTgxZr+YHgP2tv+EDxuhIPw4r9eXA+khL7+QGuZQmJalPaI0eKoDwchLNC2MFuM9czWZtnNnkZtSEc2Nb/MBoAdZdr10dZXzDkLSnABnua1gpIm+qf1dhTBi3sjVmRMbQ1mRGQXRr8IUC74qGEjMwRN0uTEm6/hWyy6+5ANZeGSZ2IL7bYyVOIRMGm0dAUOJe3mzS5imjdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fd1gJP9AO15sEsh3QfoNcgLvh6JS6DNtsg6WQWoibtU=;
 b=HekotbRwnA/SYzgvSPJSHlKWTQA8rZLGuyJynnEWi8HlTlIaQVHYJGQWeBLorKOFiAAPySh3lVJcAonXlaaFSztUijXlQnhJQST+TJwZI6NzY59WHlJ+Np1ZLuu6olmoT0BBiZcaAfH00bNO+GrUGOJo8S9gjP6QCSpxW9SVz9qRngeNd1iywxcyNr8bX+5XX7OgmnZ6U+6BZx9TLxW/C5OHmILFkLx3TpN/o8/fgy6xIQPWcNZSH2XaLyScAAQ7WQL6aEM3GHNLbr9O77TrzAGyGyh6iUNZ/15cPvSZEUgDU+/UaRns4STO+DSK3K0+xpNlzKt2HdoxwMdZlrtJjw==
Received: from BN9PR03CA0425.namprd03.prod.outlook.com (2603:10b6:408:113::10)
 by SN6PR12MB2720.namprd12.prod.outlook.com (2603:10b6:805:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Sun, 13 Mar
 2022 12:47:20 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::65) by BN9PR03CA0425.outlook.office365.com
 (2603:10b6:408:113::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25 via Frontend
 Transport; Sun, 13 Mar 2022 12:47:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 12:47:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 12:46:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 05:46:48 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 05:46:45 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v6 4/4] vdpa: Support reading device features
Date:   Sun, 13 Mar 2022 14:46:29 +0200
Message-ID: <20220313124629.297014-5-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313124629.297014-1-elic@nvidia.com>
References: <20220313124629.297014-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 253bf52a-29a2-4fca-2e0e-08da04ef9d1f
X-MS-TrafficTypeDiagnostic: SN6PR12MB2720:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2720D6463C8E3D84BBA82EBAAB0E9@SN6PR12MB2720.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WIEjEH+mgFdCWksBRTFuq1cSpDGVNMPdaF6VOo9tgDGgYZmgFQ2GGZ1h1jmLFUS8Gf5yfNn0/h3X+3uVT80LV1K2MniutEDUV/qSgbK1uD7jsgR1t5lLgnvJOMr+o2i+ywf80DqyUu0K/9xXPu4EqVo5QW1CP2YkorpMziuL8ZyfEYtW6T8yB1CC7Oj2n9ltrkVC5azHtd/f7EPZATJ0GovGbQVUBHWZoWzajwFuqRlKoNtdudclMzsYTcFB94c9DHFhKO/JqPHI7nNMrsW8lPOq+w4Ds5kxqByPMImOVjQG1WpL85F3SdZiLCXcZoDT76sE6eAc2hyGHb3Zrt2iDxTVZNngcQjgf/0D6UyKsNAjKBUqR/BqdMqpwBgEkAtlDU3eLczHlERGi7PAIXolnBz0k+zuimavOy/+odBnTLP3WsQ+2OiEPfw6OocO5O9gKrcrTI4/MM0VDve4JNhxOEz3o0VXgN70kODdJk8OvpuNOHAoopYX1OgDR9dwHTXjoAj05c8qlN2dkcDj98uMaeF0IZurX6ym8Vm6efM00hSTyM0dJA6s3H0IAk1IowbSLcIRgqssOFytLzZOOqg2/lbR0rKYbAcnAbziPNKzad8I76NWSm5TjK7c6NWtQDCRRnBQKg/NGLieymnRrLr68aP6hYhN2PdK5yexUqSW7bwoAbiaZUHM/OeAyVcM8jjHmuk2lcaaNZLikWIo6j2eNg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(47076005)(83380400001)(54906003)(70586007)(7696005)(70206006)(4326008)(8676002)(6666004)(508600001)(86362001)(110136005)(426003)(82310400004)(316002)(26005)(1076003)(107886003)(2616005)(186003)(8936002)(36756003)(2906002)(81166007)(5660300002)(40460700003)(356005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 12:47:20.4389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 253bf52a-29a2-4fca-2e0e-08da04ef9d1f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2720
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When showing the available management devices, check if
VDPA_ATTR_DEV_SUPPORTED_FEATURES feature is available and print the
supported features for a management device.

Examples:
$ vdpa mgmtdev show
auxiliary/mlx5_core.sf.1:
  supported_classes net
  max_supported_vqs 257
  dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ MQ \
               CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

$ vdpa -jp mgmtdev show
{
    "mgmtdev": {
        "auxiliary/mlx5_core.sf.1": {
            "supported_classes": [ "net" ],
            "max_supported_vqs": 257,
            "dev_features": [
"CSUM","GUEST_CSUM","MTU","HOST_TSO4","HOST_TSO6","STATUS","CTRL_VQ","MQ",\
"CTRL_MAC_ADDR","VERSION_1","ACCESS_PLATFORM" ]
        }
    }
}

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 1326a63e729d..c63bf52d3c49 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -84,6 +84,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -496,14 +497,14 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
 static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 				struct nlattr **tb)
 {
+	uint64_t classes = 0;
 	const char *class;
 	unsigned int i;
 
 	pr_out_handle_start(vdpa, tb);
 
 	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
-		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
-
+		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
 		pr_out_array_start(vdpa, "supported_classes");
 
 		for (i = 1; i < 64; i++) {
@@ -524,6 +525,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
 	}
 
+	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
+		uint64_t features;
+
+		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
+		if (classes & BIT(VIRTIO_ID_NET))
+			print_features(vdpa, features, true, VIRTIO_ID_NET);
+		else
+			print_features(vdpa, features, true, 0);
+	}
+
 	pr_out_handle_end(vdpa);
 }
 
-- 
2.35.1

