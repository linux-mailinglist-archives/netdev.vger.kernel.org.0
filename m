Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF58F4D36CC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236937AbiCIRAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbiCIRAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:00:10 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FB81B0BC7
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:47:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aj7Gn60WTtcLtR0YytnNHW7oIRyRfkG8ibRHWgzxdb+vHNguRWOp9INnnk+j6YrAttX/Nl8J4gbYwPiCU7ibFbOt3DAZVMh0bYKnbFNCsSMmrXVw/IS1VFjSmgC30KtfNUk4xVtyPipO9eIiPJJrKKkFkpLeKBm+20zntMp7eOKjUQDdcL5f4T65ts0sCQ3Ubg3d4Zv/GKY11EKHCtTMNnT3GpjJWMSPl67RpLhHrh5KQs4vU2rbxED7CZvI0afAa4VzneuB5dTShAJ019fyYoHxiS+IixpMBdkSLc3Grx06v8ioXwGTrZ6sC+HKj6rKCx4T1UkyokspSapvBXsNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Q+nIJQk4LNHbvIVVGWco8dE1Tr0LsJH6Q6X6NlBYuU=;
 b=HmhhTN2PWYH/uUIVe+2/yW1uF3dGw6JpCL3QqXTdDQ2d6XeaSVUYa0nQVFVekE/8/24MZfBu2A1byKoA2BN6KwgItn8UrhQWQr6YswIzSS5mEBXipAH+N8Erhx7LSr0MmMQ4ctdMWICjKvp7EkutzngF6tleFSW13ejtK2bTNCf+PqTZ4uXzjucXsdI0mLNorf1FDuc4AZmnUe2yoxa7b/3EwUQvDhwfHAm2QDqyXjC1Dtrg1p9qvLC2cg8uSmc7DL6dXUsI4ELDbOH4l6C4rqmd96kaHOgUKSBFWAf6AWOLakaHxHMbhLw2Xr44eZx3l4A2ieA6fyyVavBH6e1LWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Q+nIJQk4LNHbvIVVGWco8dE1Tr0LsJH6Q6X6NlBYuU=;
 b=CX/W85MxUHeJ9j5GpGcjbucnAMwyzVv/SRQ63arjAW6+rvQO1nWMgH/0AXZWM6XvhCepyYJXlDrzJ8moRQdA9Y287A9KNAFe/tfqmcUBl40NJROy1+9yB4nTMhBL2+4q15tnFKX7Sj34BYw1MvOYKy5j4QlGlkFcvBGiBKZjVMzglXG+Qh+IiCgp9avzwyG9Onc7P5uou+8pQfWZ+5JQLHTewmA1c6VWr0B1ersqxMJrE20GTYXeZovuA7ENsP5EgrKvIDqqYzhMbgcjtq9Vm6/izbrIWnhszxKJP6ReZcVG58i17uoRpR5DxEeFJ+PogYemh9lk4+U5eRcor5ud9w==
Received: from BN0PR02CA0030.namprd02.prod.outlook.com (2603:10b6:408:e4::35)
 by MN2PR12MB3069.namprd12.prod.outlook.com (2603:10b6:208:c4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 16:46:31 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::7d) by BN0PR02CA0030.outlook.office365.com
 (2603:10b6:408:e4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29 via Frontend
 Transport; Wed, 9 Mar 2022 16:46:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 9 Mar 2022 16:46:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Mar
 2022 16:46:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 9 Mar 2022
 08:46:28 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 9 Mar
 2022 08:46:26 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v5 4/4] vdpa: Support reading device features
Date:   Wed, 9 Mar 2022 18:46:09 +0200
Message-ID: <20220309164609.7233-5-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309164609.7233-1-elic@nvidia.com>
References: <20220309164609.7233-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bd11147-cba5-405b-2b25-08da01ec5d53
X-MS-TrafficTypeDiagnostic: MN2PR12MB3069:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB30699271D759CC7B60951F49AB0A9@MN2PR12MB3069.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LqA6Zw5gJ8l6bdDGcmAvGRHghfFSMFDe0OcarU5JhNHXkq8NDG7wjptN9IZ5U0tQRwBrtAa9dyZpVWBKxL8gQShvhtpNNr7hs7+aEkEMjT9V72NW66V7rSKkQUSiUK4fBZBIgtmmRmvPKL2fWK1SoIQAGmO/TlSTL8WC3iTlt5SKSbS2QTmB/R4q+dI9d1VQRLctdYcrQIpl5wHyOxTZsvYpSpw9/aWkDQp5P8RL+GG1gJ1KJ8XGdUPpSEOKt9rWvhFyjpxIvAR0QTfjxvk3U7Cu6uSyw50Y7EDyHJAbgeyjTq7ILHhbBTrouUSfvNjmEGPlwkKys9f0TDzys1BXaVHWrhIFueCQahFu+C0dvVS4iGke6JwkZunP+as9v+/ydeTCE9wMfwU40aSEqeSnbrxn5qyH4mjIg0lUKXDK0FND4lzvYB7EMTiIsRl5Sws5ZJZpZPzeFruK6m0J5FAd3u+8510Csnyk9o0B47RJbgl+5kEK6YVuyxW6KDznHOErk+hbSCDY7MiCUof4VQfRrB3xiOMIuHvAe2u+wJ4JFZH8kefHBIolLbTicnHGbJoSrq5QlapRlZKrLerwK0SJPz9J6UknoVg4Oa8GIUc4K5EcmjSvYfa+tvdKLvTXWapTDZc1t3b/76rmskMVqjyBeWyScmKvxpBrq8nIAO59OSF3GVl52JxhD84f1xRn63YCo2XWOhqHpD9MxSbtsvb/cQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(508600001)(6666004)(2616005)(8936002)(107886003)(4326008)(8676002)(70206006)(5660300002)(2906002)(83380400001)(86362001)(1076003)(36756003)(316002)(70586007)(36860700001)(7696005)(186003)(54906003)(110136005)(26005)(81166007)(426003)(47076005)(336012)(40460700003)(356005)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 16:46:31.4112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd11147-cba5-405b-2b25-08da01ec5d53
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3069
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 8b34e29394b2..ae2503435911 100644
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

