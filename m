Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1D4BA02E
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240445AbiBQMbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:31:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240466AbiBQMbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:31:03 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2043.outbound.protection.outlook.com [40.107.101.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69F02AE285
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:30:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkMGHhbNNgWtqbT/ik6tLXcgnP/VlXInSfHTZ2V9BSxebOcRtwkS+CykRx9dsN2/813J/J7UkeI+O/KHaFqqCpRcjPTYaFsCnnsXFfr9lnTSrQKVd4bAGPJbeSHKz+EVVcn14RE72U6OoNGiygBgsK9NC5qDiqkM8Pft9U8tqI0hutaSKjHOsoCNRXUuVi0UCDRLIlYqi/1XsvTdrEo077yE3MCSvI6fwyCjvFedEcUvhinYbi6XWQXRxEWHB23wSd36cTr0C1R3FRd4YWSDOQZZ/zX3oz38cwQ0SP1bC0FhBeNdYk1MHf+MU6a/vMy0YU6m2ze3J66biTiIOPbSPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iN4Ek6wjJtFoCabV8LWa89JIOALbln+927Jyd3Ub49M=;
 b=M2EYasUroQGn0fxnjpAWXL6ZVNrHzaz0cPJJ4PE9+bN2YLwoaTVa+cpaKWnmb+2I1z/a5yJweJb89Beh6g2INXMxNtHtbIY7AYv9BRxE9h+nscSBUiATtJbOTM2e97RKAjBSTV9UzMdIy/vHHZVPM75nOX9t/gaGL5jD8sCLD2qhiiTVrtRysk48FSGLfBjfmunGEtBYHreCnDeCFhW0oLhMElbnkH8a5vWw6NVIDUTRcM9kon/OK+z9PsKtEuo3YtRpb18+UMFLVTMu4ahFo8Z6lb5T5Ur+/lzd1n2kCvN6GxHmQ9tjw5GtpHxb6oA9LyCAXZ/DyTlkm1FJ4fT4CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iN4Ek6wjJtFoCabV8LWa89JIOALbln+927Jyd3Ub49M=;
 b=GROAq+rX+X36HUCtpXbhgRG0KakIrp6a59KjtyYNdSuY+hca7dPsgj4SQMZIaJLetIH7FRJZNvxG6EO5BpZXOtEtowE/8YGf+vjcgC7hHkfYN5l4Z5X7TbNRk0MQal/iBX7jIdVihIa33w6VqCg7Cdr980KEtD6W4N83N510L1HjtG2DXpIesRmsxpR4hENvt4n8NZeANh8qRwX6x3/FSU4zvV51s3jLsBPNM64CCv0iMGajD0hF6asOWww9sriX6QhC3EaWeRl811Zlgr66AtAdTd5JwiG8rlsXSoJ5FI9ciPTEUcG36h0kIyCezdpXabL7vrAfK7ivRhSTHcLsJg==
Received: from MWHPR22CA0062.namprd22.prod.outlook.com (2603:10b6:300:12a::24)
 by MWHPR1201MB0047.namprd12.prod.outlook.com (2603:10b6:301:54::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 12:30:40 +0000
Received: from CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::40) by MWHPR22CA0062.outlook.office365.com
 (2603:10b6:300:12a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Thu, 17 Feb 2022 12:30:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT035.mail.protection.outlook.com (10.13.175.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:30:40 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:30:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:30:38 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 04:30:37 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v2 4/4] vdpa: Support reading device features
Date:   Thu, 17 Feb 2022 14:30:24 +0200
Message-ID: <20220217123024.33201-5-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220217123024.33201-1-elic@nvidia.com>
References: <20220217123024.33201-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7c5dcc1-d62d-461f-97cc-08d9f2114f28
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0047:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0047B9A7E9598CBCCF02E583AB369@MWHPR1201MB0047.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2DsKLMYkHJin32TmqrNj8Kj9WWxc1AZ5XjrDCG5Kt01qUoUXyVswAqoIz0gMd4dyBDet95hqKQ9Li2j6tt21U7aOW4EQtSyT1qtgeJbSy6aO9WHxTZhaDJeqOqW4Cu9LtWvaDe4BcgpmbfgN1KHFVQtXx9DEFprWfvWnOoKobUQdbWgAsAkbO3vwmdNEwGbr1TNHhm+kAsYaDxLx1CiTvVqhRqNApDrqtktuKBs9nYh3NXu8vp6Ojmrdq6E+fJK89A/q/6p7sMbDJ2qT3PKbUeTESXhfofgpv+G8zWGk5N9FXLLFOCBC8Z4EfEBNrnioTP0NYWaclTAfMklPxm1BNBXq1OvhbGmCcVkn2Xs/ztH0Mdu0/tkdsZYvPx2bKRwDUjo1RF61VPqU6xKKkUDFsw6KTxZ63jKaGvmzBJU2PbMvzjIFddd2uKvH+1XwUAse2u0+7hZykrXDftvVcMm/2wpgNPQDoR+llpkO+rEwG0kXtvY2XGVZzBhKwvqlcnS22A8IC1FAha8enVjt4HDrBP2pH67hNcBQZrja1uampbz3KIvr4aIiK/r9SDosBNYPxDR53366ykwQmuYb5qyO/FbWbNBrUk4jVwvzXseOTtvTD2Eo7cctBA2bfj89eGXeErk63my+TtxQ41LPhYLM6cGKTWuv0eZX0bqBvzdMwWV3n325bxkrYZvie9vRLvrYnRLhH/KTfpTahs0pkogRQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(8936002)(70206006)(2906002)(86362001)(316002)(5660300002)(508600001)(186003)(26005)(2616005)(7696005)(6666004)(1076003)(426003)(336012)(107886003)(47076005)(356005)(81166007)(83380400001)(40460700003)(4326008)(8676002)(110136005)(54906003)(82310400004)(36860700001)(36756003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:30:40.4968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c5dcc1-d62d-461f-97cc-08d9f2114f28
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0047
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |  1 +
 vdpa/vdpa.c                    | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

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
index 78736b1422b6..bdc366880ab9 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -84,6 +84,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -494,13 +495,14 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
 static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 				struct nlattr **tb)
 {
+	uint64_t classes = 0;
 	const char *class;
 	unsigned int i;
 
 	pr_out_handle_start(vdpa, tb);
 
 	if (tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]) {
-		uint64_t classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
+		classes = mnl_attr_get_u64(tb[VDPA_ATTR_MGMTDEV_SUPPORTED_CLASSES]);
 		pr_out_array_start(vdpa, "supported_classes");
 
 		for (i = 1; i < 64; i++) {
@@ -522,6 +524,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
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

