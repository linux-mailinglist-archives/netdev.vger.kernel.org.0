Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991544B0ECD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242246AbiBJNbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:31:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242243AbiBJNbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:31:32 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB880BBF
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 05:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxut6K1FRpBSh+g0TNsQqtmv1j1vn6a8BCID/IGRmr6cUFq8AfwGPl0GxcC03Qx04wK818QbAPWbOWCRADD+59Gg9w33va97RYj9Hvfwi5dd/diyOrMFoQV3FmUhG+3VMrpkajvnv2aOV1SbIY5m5BlC76igO2j0/GwSGCEJPU5L1hUIEAcEGk7QSBwTxMvJBG+3k2AKOTb/t9qEGzzGzZy+b0CjgEjjPyNwlNoYdpmnDSufjcHa6k5OGrJpTbvlC6pDpizpIsi/dSYJhZXsqDKQX8fe1LUvBeDHKgTWQtGV1kChY3tIOs+dCpO6euWrF3PhgnQivv34QRBF43SclQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CDakSM0HrmXSBPClR2t8m3EX4a4hnvGJz5Gzytmd/go=;
 b=gIObEXYvs7Jf3Ar0Bg/1/2ZXib2jl6NndmsyM71fruhbh4zLP00OlNAsJ8FI5tzzqlONTS+dRdEzkrQMSfWIywBbS2h/BGOolF9AP8beFzL4M0wgyzx/b+qCD6lABUg8bae9eVxFQj7+2sCesEWa8i0ZUd09/EXVPbiLxyc4zn/yfndb342CgAPagaF4Yi0lcdiy+8iiDW+bZ5C0IahfPBc7IKpmshSRWb+6qPhu3bEJcnzsS+NctiSusOqKPBqNQK1JEQ6V+Ez11cceJXERLjBe5eBOoEsBqji+CKecpvpqiHD9jsdqdYEYJrQ8x5FWNpyJMu6SskfRSebZ93seQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDakSM0HrmXSBPClR2t8m3EX4a4hnvGJz5Gzytmd/go=;
 b=RkLNL6mJZ4ArXsMUHEPhFQ48Igpv0hh+d00fiIRJO11HiNhhZRyBVHKRDUkGKJFeAhllB5uYcQ4slGoJiYZUU4bRwkf7eJJAoqE6K1wLo7XxsfBOTEGtwKHecK9lSAkKm3uFCFf0ErhDJWQ4KwfXzH942N7JRmBRc+Q6txjcKPE1BhtNl25YgtSejMa3J2fcZPLXwafecXOeci2vyokLcvFBmtNH/Qrr6HaZgG7oZcscuRKZ740+jegtHBK5oP+tG2rx8olNgN+K0+nGbbWDwnqiuqET7JbrbV2TaWQ0hUvo/IBDxr2zVbtVubBIZTTYtvtQJiryv1HUjsvt28LrUg==
Received: from BN8PR15CA0061.namprd15.prod.outlook.com (2603:10b6:408:80::38)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 13:31:32 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::b1) by BN8PR15CA0061.outlook.office365.com
 (2603:10b6:408:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 10 Feb 2022 13:31:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 13:31:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 13:31:31 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 05:31:30 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 10 Feb
 2022 05:31:28 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>
Subject: [PATCH v1 4/4] vdpa: Support reading device features
Date:   Thu, 10 Feb 2022 15:31:15 +0200
Message-ID: <20220210133115.115967-5-elic@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210133115.115967-1-elic@nvidia.com>
References: <20220210133115.115967-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99af2189-35b8-4eee-a4f7-08d9ec99a690
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB29401B35715AEBD356C48DB7AB2F9@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdA15txyIMjeYGkHUINdOd7adTIHZS8Jrgx1LFJYPd36mYiXdL4UeI5UGcfBrAhvOvCGLV+9+b2343gi+lRsHNPHjSNZwKnxgxoR5Fuf1y2ypw1G5m4fRQrsHTXl3yBur7ZqzG5ocRHx6MDwW6PuORoOJMEdhiW7GYwaO1CkfqDvVrjkU175EscqMn6K+2uFlu3PyADtxJ1/kUXTRDkdcxRyOduVFp9DNIwa+ucmg9dpKzdXgex8Wi1AouaAZPsOzjhk0DpkNpUJ2DxuB4RUCRBQsBSwcbBz0EpLC3sN8sPAyy9w7hLI/gSP9FcKmSVpQeIX2afBN8G+iyfiC+uYWzP66iBO+bx1mhNzy4Mxd+Tb0F3BrmI50pAtd8YTmGWabAJm15BmUfNCT5AHuXw7VBBf5huN24Xpb3Y+NMVvyx47zEd91qHK2O+Js9tpISXdMiKiqWDXg2dngzfUt71m2MqAIcjrPyMbW0gtMMxr/OvGvN/Lmy+Enx34PSUFIzEkEVhOR43/SZV+foLYnqz19cegZTWoGwSvS218OWgTCOf+62FU3L0MmXLhjY+4HzJFPpi2XyFv1b9WI/qXVRCAOp/MX7/RslwGaeyP6K6ZRtSk2UiY2uqgibqRVwe37Gq493R+PY4S5/HvmWGR7KESg9dqcdpzQFoSHbu9q2VcJ7vDQHSWmDctLm83aupgbR/+P658wjyri1NQIbweJ+JOoQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(107886003)(1076003)(426003)(2616005)(8676002)(186003)(5660300002)(26005)(336012)(4326008)(8936002)(70206006)(7696005)(6666004)(36860700001)(54906003)(508600001)(82310400004)(86362001)(40460700003)(316002)(47076005)(36756003)(110136005)(2906002)(83380400001)(356005)(70586007)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 13:31:31.6409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 99af2189-35b8-4eee-a4f7-08d9ec99a690
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

Example:
$ vdpa mgmtdev show
auxiliary/mlx5_core.sf.1:
  supported_classes net
  max_supported_vqs 257
  dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ MQ \
               CTRL_MAC_ADDR VERSION_1 ACCESS_PLATFORM

Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/include/uapi/linux/vdpa.h |  1 +
 vdpa/vdpa.c                    | 11 +++++++++++
 2 files changed, 12 insertions(+)

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
index 99ee828630cc..44b2a3e9e78a 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -83,6 +83,7 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
 	[VDPA_ATTR_DEV_MAX_VQ_SIZE] = MNL_TYPE_U16,
 	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
 	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
+	[VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
 };
 
 static int attr_cb(const struct nlattr *attr, void *data)
@@ -535,6 +536,16 @@ static void pr_out_mgmtdev_show(struct vdpa *vdpa, const struct nlmsghdr *nlh,
 		print_uint(PRINT_ANY, "max_supported_vqs", "  max_supported_vqs %d", num_vqs);
 	}
 
+	if (tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]) {
+		uint64_t features;
+
+		features  = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_SUPPORTED_FEATURES]);
+		if (classes & BIT(VIRTIO_ID_NET))
+			print_net_features(vdpa, features, true);
+		else
+			print_generic_features(vdpa, features, true);
+	}
+
 	pr_out_handle_end(vdpa);
 }
 
-- 
2.34.1

