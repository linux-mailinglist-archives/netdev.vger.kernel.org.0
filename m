Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9534D7734
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 18:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiCMRN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 13:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiCMRNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 13:13:49 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39B113AA25
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 10:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbUnBsxE5GyRgHOLmN+IPfMY0H3Tbdyet1AjFBOdfZkn0n3mBE0y32mlORlvOXnubol4qMavZaGRHv1EgnxYaQavwyKp0AXtj3Y+oUve6IVpa43k/lj5InbC58WUx91nldruODjxKdGeYd2Cn1AUdM0S4H2N5ncG02dRCK7OiPcfhIHMqEH52rSaujxcOVBLnBGZv7ATsbZKEasj6ThHm5Pj/SvUlMCFDm5gk9UnjVTZz5E9lmqHqen47QcRr2WIc/CjnulM3xjq5sCanFYvqiJPhztYNsbg+oyCLejyZbwQHtXP5juZtMpp3uvo/cMsWSFLcp6oSe9koa5WpS7W3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMRTtJu2IbEN4NzspsYPzY01j8n5IfMJNEenFVLt9Lc=;
 b=BWZokGeBYdn8+47ddXI0LRyRwgnfAJhSg+0iTqUawT9tl++kxabUvELJSVb1EdkknnGk595WEJRxabNJxZqe9K06NLLBRwFBhAAz5+tNA24bleQj+6eFwlLD1vhCK6wwGFrMuXucDYVua15xptgk+51xdg4LgahxlSi/tcOHx5nYD9PTxrRgloPLgGj5QOsqaEoh/GSxKs+r+EEwdaETuiJCC/4VCHTRk4x6gPbGAnW0LShJf1oel4ZX/yoC1LflUmTHxTmiI8i15FtID3rPhZlQ6eMMLL0jPyXqtpnBc4KslM5kzBS6bhp7NIGttbRK2wS+Bdpo3ggNd/M4ModZsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMRTtJu2IbEN4NzspsYPzY01j8n5IfMJNEenFVLt9Lc=;
 b=CbAvXG2ky90c4zMV8nAgahwDuB8vgB0CsmQvBIlRJJTDnAdfeDBJt+ZWEbLEH7xjEyHdSnPME4kg5dCVh930Ec296r20Sw8Znjt1tSclfsKG3KseuIbEiACIFybIG5uAYKDsN1v4MM2Jv5wed7684bL9jG/e0RyQednREXoLPQWSNUkQ9YOYalHu0Ex+Jm1tEZ4v9TgY9x9Dmjjldy0ijdTcSDW+sBqhpr7YUUSgQpjU4vl4bulY6j1J3kZY2QvHtRr6+laUGZwUWwa1LjotcWO3A4t+2mbt0puGSejU0nXIJui9J/AwS9mHIesLu0sdsukQX7fJtgfSU/DHbCMEpQ==
Received: from DM6PR18CA0016.namprd18.prod.outlook.com (2603:10b6:5:15b::29)
 by DM6PR12MB3802.namprd12.prod.outlook.com (2603:10b6:5:1c5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Sun, 13 Mar
 2022 17:12:39 +0000
Received: from DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::a9) by DM6PR18CA0016.outlook.office365.com
 (2603:10b6:5:15b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26 via Frontend
 Transport; Sun, 13 Mar 2022 17:12:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT053.mail.protection.outlook.com (10.13.173.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Sun, 13 Mar 2022 17:12:39 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 13 Mar
 2022 17:12:38 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 13 Mar
 2022 10:12:37 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Sun, 13 Mar
 2022 10:12:35 -0700
From:   Eli Cohen <elic@nvidia.com>
To:     <dsahern@kernel.org>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>,
        <si-wei.liu@oracle.com>
CC:     <mst@redhat.com>, <lulu@redhat.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>
Subject: [PATCH v7 4/4] vdpa: Support reading device features
Date:   Sun, 13 Mar 2022 19:12:19 +0200
Message-ID: <20220313171219.305089-5-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313171219.305089-1-elic@nvidia.com>
References: <20220313171219.305089-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40237a47-a09d-4b34-08d8-08da0514ad61
X-MS-TrafficTypeDiagnostic: DM6PR12MB3802:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB380211A471650A1441AD2972AB0E9@DM6PR12MB3802.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6rpbXUM+rHWvKYcw7vCZSworf/V2f0iQPfw8JMUMHoUMESMWKwp55cBDw4iFZeN+XZe6ZYD1//BI38iitvl20jQb0EsIeOIaBG/FWGcPsDn6i5PLL1LqfNHpG/y3ASnzmft6VzvRVhtMQ36IxyKoI0vkbPI5GpGjkU94W9YdUGA8dFhGWhN4ir9fibRw35dpSlvqyOWdYG4coCoybzraXVNldlX3y5nglERNpfUvoqirQlDf40nc/90RZS1q/EDXeo3AAI5mq1YRjVhq+dndc7WTUYSmyw8VJEFd5YeYa5CbvSsh2oLI7RMVzlArik8pndmSus6l1lQzCO7xeOPARjs8isNIJJqz6pddqa1wazEnnPNd+Va8607nKprfPquF6FbOcByOqcYP6WJrSBJPIEgqX710qkUTK3ajjVaFdjRqGlZEnA4GIT7M/BX9V0w5bzj3u0266tDkuuJG9tINPsYA+trLsyaqGYzcqU8fJpP9PkhLRhfc4zrWi6UFoa/YOHyw4dAiTZFXdmSmlhxSYjySzxGQluEQJ9PeuDymb1df+5end4W76nAgOR3hzs8uBD10dxNVXoj9fIK8x8B4PYy1UNfFn1A6XJypYcdEzaRJsHrgyyorriHbnAWJzWlPOnmntrke1xb1xOU4VpyC6BSMrt5uWeN2uIYP6gQYB9NXDBrXQKdcHRT+kfGh75zmmnh2isYBblglnqnQpw8dCnXMcN2PKJuT/dNcCHZPOlo=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8676002)(508600001)(70206006)(70586007)(36860700001)(2906002)(40460700003)(47076005)(54906003)(86362001)(82310400004)(356005)(8936002)(81166007)(107886003)(36756003)(6666004)(7696005)(4326008)(83380400001)(110136005)(26005)(5660300002)(2616005)(186003)(336012)(316002)(426003)(1076003)(334744004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2022 17:12:39.1399
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40237a47-a09d-4b34-08d8-08da0514ad61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3802
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
index c2b1207af8cf..ffda00e85c26 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -84,6 +84,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -495,14 +496,14 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
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

