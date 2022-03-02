Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F205B4C9E0B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbiCBG41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:56:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbiCBG4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:56:24 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2046.outbound.protection.outlook.com [40.107.95.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3840B2E35
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:55:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/VRkkL2lN6/Xa+JEG7iN0d3aSQJaQzkz1YbuJo3FHL7osFVabxpuKDGf4JkdlwubaO62L7OgKxCW8a9qK0lG0fyoTkBppSIsXeg5KV8jqij6NYwaZ5NTEb5RvYwD3mxYwsBb1h+VS7NtyItb0XMkfK4dknkG7WJEZWUcrhQEuPD1J9ovFgI9VLpAwe6w+kGJWgWrrcKsgWoy4LlQZ+f1CfbCKgJr59RSQ/TE4xaKR8z7K8pm0oO6R/L50kOxpvoRzjd+7iKwj/I7KcIlbCl5+lO/HgIC4tJpmzKqeZACn7pFuiFfPgCsYUpwHw5I4v4U0nKopb7jhu2aNX6jx1QXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNE7NKvefSNVY50Z2uZ04J33GI4GxkgfZXXCuGVdfbw=;
 b=lNSzDLfWQiNsJ27kt8gdYC4+TdL+mrFjZo01wYJ6YAM30Jdale7mNY/4oYOk0KeAn9NvJCzEFC0eZhMOr/ADT3IMEDPc69RnHPPaD8JUPRCnAAHGMueXq0Gv2ADUstNSSg4ru212CBIVJrrMi3Oja4UAV25Vk7Qf++AsiToIXAYDjiZU9Vq5cMIC3HkS2T7YIWOebBj6s4M8xVGaK3L8XP+fVgJ2eOfBLd5RVAg/5COLUEt5PYaD1ik2iAY8SnjMFgY28X/DMNoKnzL1Kv41tCHIJ7DyzCob/MJAz4iOZXQRH4tBEeV+yPrO9Vbl29dxvNgZ94msJgm+2x0w0udwJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNE7NKvefSNVY50Z2uZ04J33GI4GxkgfZXXCuGVdfbw=;
 b=dVVlQvLy6u065vMO7Vo3VwC5RmFpk8hHTCHCyPnWjfctzueu98JFlel/gc22V8zftQWCO5pYocT+QsamPv1sCD3JFEph5v/gnLqYuceS6QMAJCjD0zZtZttPO5bNKzmWvXumU8yHYutpkjSpsznZ/f4vuCUcT+AHV06VCYot8Isj3UoRJRf1iwYNNFJeBJvSNMDShpSm3JU4ZPX8wmkN27qN1Kx5WoI99+l4ImdKzhAEtSry5qCnltY4lj8tMsXz5jH+QMdGD63evCnyvg5ab+hq75rOx5/tiAnQ8IyF6CLHEM1t86oPx8oTzpjWepjveOfp0UvafxFuP5BCDx3j0g==
Received: from DM3PR12CA0077.namprd12.prod.outlook.com (2603:10b6:0:57::21) by
 CY4PR12MB1813.namprd12.prod.outlook.com (2603:10b6:903:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.13; Wed, 2 Mar
 2022 06:55:39 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::f3) by DM3PR12CA0077.outlook.office365.com
 (2603:10b6:0:57::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 2 Mar 2022 06:55:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 2 Mar 2022 06:55:39 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Mar
 2022 06:55:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 22:55:37 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 1 Mar
 2022 22:55:35 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <jasowang@redhat.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <si-wei.liu@oracle.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v4 4/4] vdpa: Support reading device features
Date:   Wed, 2 Mar 2022 08:54:44 +0200
Message-ID: <20220302065444.138615-5-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302065444.138615-1-elic@nvidia.com>
References: <20220302065444.138615-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36bb148c-6f62-4fee-becb-08d9fc19a926
X-MS-TrafficTypeDiagnostic: CY4PR12MB1813:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB181348F4E2999701691C85B0AB039@CY4PR12MB1813.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u96bWN9DtaqjcOQY8OTXYtxxhMRBDO//zA1eL6qv8+RK31JVVJOHJMUkVmkb8QgW13jkMTK+Unde9BhviCMVkXDPZsUcvtQ7wAppqQiiRd36cj60tWazXejJ+BupMG/33Fq5Gz+kKZTghSMl+/d+YTvRJHDBF+PeGdeyPOLEkgN3juIiK9E3p6FKvjGa1yaNpJWk8EdHEOrLD3cL38KFUkCutWm4pGZ2DKFNYU1QEKe/0byUwYkabUP0b9mFs83Aic1nJIk3jIYVgn8K41n/mpML3xVTwW53mZZvD3mPfa+fgG11Zqu5PcWWH6sES1Fb69JkSGweNHuc0pxzjRuk3JpMS7MXgNxdL8HMxxD5RujKQcnpH242FWHXfMfA74CWsvNk8oEOlJonFR+E638UeSdlGeQQC+D/Wzad7c5aJEtoP3YOtvRRBhG6YZomjnexoPbPxBKVsPhMIQVYJUQLdQa5zFNcvG3UHxmN9KaROZuvwnC/HVbK8tVjz+VdyBcxjevjchqfUc8l4WPk2mHWUO12CfIV+eGng5/1+nYvk/ePIjBZizTYeaQfbiDaWKNLbQWWO7r2xSjAqeZgSsywe+TFeLeYL9bfziHTqTB5bQl9bxc/rqp/rmXKYDGZTLPX/29R29IF9X+rQ4g1rIcbf2dHhSqKW36xwQxj0H3zcJ7fNzp/+XJKB9qz5j2+mFVAEZoYpMR9mnAjQuFFoS9qTg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(110136005)(316002)(8936002)(4326008)(8676002)(5660300002)(2906002)(26005)(54906003)(1076003)(40460700003)(86362001)(36756003)(508600001)(6666004)(70206006)(70586007)(36860700001)(107886003)(7696005)(356005)(81166007)(2616005)(82310400004)(426003)(336012)(47076005)(83380400001)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 06:55:39.0812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bb148c-6f62-4fee-becb-08d9fc19a926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1813
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 vdpa/include/uapi/linux/vdpa.h |  1 +
 vdpa/vdpa.c                    | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index a3ebf4d4d9b8..96ccbf305d14 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -42,6 +42,7 @@ enum vdpa_attr {
 
 	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
 	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
+	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
 
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index 22064c755baa..bdc366880ab9 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -84,6 +84,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -494,14 +495,14 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
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
@@ -523,6 +524,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
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

