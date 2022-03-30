Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27EC24ECBA7
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349927AbiC3STM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349922AbiC3STF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:19:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04926580DF;
        Wed, 30 Mar 2022 11:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esJHknQdTo2+BZfwxrgZ/rhILZWgCmUGuSy0sCnrq2A=;
 b=X/QBkIQ2KX6Gt9014Y2sIevaSLrayWdzJ4YJubt9ICJhw9SNdOA+I/XmFBySuXh9P9LdVXd2PtURxBy5ZNlY/sEtdu8IkKjVA7+EF+aGzn6+B6nJrVZnpbaIYzf4f0MGzMkRyhceluxRL0tfdoqOQoaE+WlKqy91i3HSt/TuVaY=
Received: from BN9PR03CA0497.namprd03.prod.outlook.com (2603:10b6:408:130::22)
 by BN7PR02MB3971.namprd02.prod.outlook.com (2603:10b6:406:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 18:17:14 +0000
Received: from BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::e) by BN9PR03CA0497.outlook.office365.com
 (2603:10b6:408:130::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:17:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by BN1NAM02FT024.mail.protection.outlook.com (10.13.2.138)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:17:13 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 03E8A41D82;
        Wed, 30 Mar 2022 18:17:13 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oChnJHB7qyHoTp7LJQOhcat8kgMU4Ko4/UBXtJHX/YM6nikCNiEOPPEWPEG7GFQHurJhzcjN7FPYz3QBNd7un0fxJ4RoDr+CtgUZQslGC1dWGkT1Ba9kWZcyimyU2L5Id8XHWuPL6ipYdkxoUmi+T6ynnXWbUxsTjr8IJUNYrHwg+ijB9uuTf9GIW/sh2y5NBhanQaxn/AwonSpgsliho7TBfJJrsnNK4tY+uS2gAlOGs34r1r0DVzIeZ/BuUIab9ttDmJcM9SUjUmkyc7Ond3I7DGnnHR8qL8rlBYQk26IpClT4Sigikk7mPMD71PtHPRPaNoDJJM2XhI60qPhv2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esJHknQdTo2+BZfwxrgZ/rhILZWgCmUGuSy0sCnrq2A=;
 b=S0HWMi4oNr8vzLg83qlcDRq7Y8JKmwxuqUOgMy0v2vgFgiMGXOl4QSrPdhjhSF6H0n/I9oGMYkf96Dv2tghLeTcv7La9lyRctWW8xnR+2z3A7QoCLtQOhu9mGmJsUry2CFuxKJAtr54YVs6A4HGVXLPh/K4pWohiJB5hCOG17wDbbh1PAPARSoEKUXR3dxYvb8mWlOzvrufgQpznRdIQ7x4PiEP82D2Ai5n22pWfeJSgqoOHazYiklv6jEyGyYybU2zEZIbBq/Atcme6w1ZQmsCiJ65P6Bb91keKAcDYio1IfHfj3Tjoous9BYtXTX9PBJlaMQi3NNYdsADau0GkcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN6PR19CA0070.namprd19.prod.outlook.com (2603:10b6:404:e3::32)
 by CO1PR02MB8619.namprd02.prod.outlook.com (2603:10b6:303:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.18; Wed, 30 Mar
 2022 18:17:10 +0000
Received: from BN1NAM02FT054.eop-nam02.prod.protection.outlook.com
 (2603:10b6:404:e3:cafe::b8) by BN6PR19CA0070.outlook.office365.com
 (2603:10b6:404:e3::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:17:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT054.mail.protection.outlook.com (10.13.2.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:17:10 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:17:06 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:17:06 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
 kvm@vger.kernel.org,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com,
 wuzongyong@linux.alibaba.com,
 christophe.jaillet@wanadoo.fr,
 elic@nvidia.com,
 lingshan.zhu@intel.com,
 sgarzare@redhat.com,
 xieyongji@bytedance.com,
 si-wei.liu@oracle.com,
 parav@nvidia.com,
 longpeng2@huawei.com,
 dan.carpenter@oracle.com,
 zhang.min9@zte.com.cn
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcsU-000CCQ-5v; Wed, 30 Mar 2022 11:17:06 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>, Gautam Dawar <gdawar@xilinx.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eli Cohen <elic@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: [PATCH v2 15/19] vhost-vdpa: support ASID based IOTLB API
Date:   Wed, 30 Mar 2022 23:33:55 +0530
Message-ID: <20220330180436.24644-16-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 0f5aa748-db1d-4962-7dcd-08da127983d7
X-MS-TrafficTypeDiagnostic: CO1PR02MB8619:EE_|BN1NAM02FT024:EE_|BN7PR02MB3971:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB397167E6BAAAB7AEEC88B75EB11F9@BN7PR02MB3971.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: uMqXjwAtSEvSMUU+chXdXT8tBDmsEZUMLGwhcLVoHFThSOX4z8nfpdtbRMD+0Wj+vmyLsfRuBoFGPRUG+YhJR03XJB/S/4G/+xZo140SiVS8DNRYulP+mV9eTYfHqvuk14HrKF6as71nakvimFzS3/c/8UIctHHYGRsLEEiOswN1aavpWoS/aLYiSWB4MmLnBt4gx1iybWlRmePDSAN6bo3G5DAqLcyJZVSv6Gxl2SKKgPNuKkAkx0O9NX/+kzFbtdcRlHyvgbE/toE2RWwEZz1nNgAXbJvfn4+bWQlePto75R4lMBIVmX+Jmfn0K7yiicPBzFaAtRvgvSbJE7fqadF7gf3IUyRRleSDu8zI08o60gyEp0MCk3DwFx7qe3LcM5DgP6/Dncr2NG7SQKznIqTao2nlhwY0OjMKF++D8ZJu8wVzipsGWK+/iTzNtm8IaO/jxWWInwPLZWafYnhgcgApYNy7U2rkcV7uRwqy/+QpLdc+rLS96b+dBgQhX1MnUmo/PXmGXZDz+ZCKt/9vOAy9GhhL/Vtdcvcz40Uv5nr/dQcvVnJoKxaFvdhHYGjlRPIO7tB89NdkRdtCwuSvhecpR1BvdsXpEw4rKZs+eNqQffX0WN7b7GD4f62CKvo/SL3egr0GoWcz219rQUAMTXSXzsTX6qdu6ZtxGDEyQOYEIjEDtuxPM0s0rnKcJMQQFlEuJoJcH/4CJH5wdO6pcA==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(36756003)(36860700001)(4326008)(316002)(70586007)(54906003)(6666004)(7696005)(83380400001)(82310400004)(70206006)(8676002)(5660300002)(110136005)(40460700003)(2906002)(2616005)(336012)(1076003)(426003)(186003)(508600001)(26005)(44832011)(356005)(47076005)(7416002)(9786002)(8936002)(7636003)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8619
X-MS-Exchange-Transport-CrossTenantHeadersStripped: BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0ea5c464-ed9d-410e-4bb1-08da127981a8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MEJEnW42WgknA574EAJn7fi0/y80SMSipoMQ2k6IyHQh5MdgSd7CeV4gqBr/hqSb5A15C8S+VJI19Cyzfa/aAaYpeo6g2g6FEaMaBkDZ3YB5MAUPlkOTxMWCPa3nFCqzjYPqJHh48GnUhc4y9Zc0D9Hf4XTH71eyjK/NnZEYz+HVEc/d5OR9RwCYT1va/BTQ8PYSV18GvQBgHZfTMUQgX2/7bkdHhrzHFlZjXN48D77yyU1d5U4Oakplw05ddnnFLKE2ZxsDHeguQoTiuobJ8rDICkXH+zxmeBbmnWcTAlL9hdgBr63ziqVh/KIgee6cYMBunj2cz8w4ZVLiaPbRdn2h6WVOhdeRh/YzXoD07VRLhSV25ErAFpveZj2zFU3OpFBtMfslKLUOhxby3kcr0erjbuyn1GPIZbLRLY305yNjyMmW7dGHiYI2pLYaeDJNMcbjrVMmVvok557My6v9iDRCxzSIV2D/cRRhr+e5/MnWCRb4b1Sh2fMLpqx6oS4lMg6JfCd/WwkriuhczQ8HLQ7HfWWA8vST2wx9G6iMOIg6B/PKxZr62vY9AzCoJq+jISmQvYj5IRC4rTr4uMWKZKEX/Xn3ow4ideGIxWrvVHqkxWhpP3ntyoDiwaOnVmLL1Tvmf8XjiisBuOajykqDDwrBQMUtcF7VVzS3/3Nzl0qzNA94pND+xATV2SuOazY9ZHCZ+KTRjOjaUpu1Dsel4cp7jC9z8M1pteMt4vjd3ZWrx+D/lahlr82m9Ote0KE3
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(47076005)(5660300002)(70206006)(8676002)(110136005)(54906003)(40460700003)(82310400004)(81166007)(4326008)(316002)(36860700001)(7416002)(2616005)(2906002)(26005)(8936002)(186003)(6666004)(83380400001)(44832011)(508600001)(336012)(1076003)(426003)(36756003)(9786002)(7696005)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:17:13.6908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f5aa748-db1d-4962-7dcd-08da127983d7
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-BN1NAM02FT024.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB3971
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the vhost-vdpa to support ASID based IOTLB API. The
vhost-vdpa device will allocated multiple IOTLBs for vDPA device that
supports multiple address spaces. The IOTLBs and vDPA device memory
mappings is determined and maintained through ASID.

Note that we still don't support vDPA device with more than one
address spaces that depends on platform IOMMU. This work will be done
by moving the IOMMU logic from vhost-vDPA to vDPA device driver.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c  | 109 ++++++++++++++++++++++++++++++++++--------
 drivers/vhost/vhost.c |   2 +-
 2 files changed, 91 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6c7ee0f18892..1f1d1c425573 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -28,7 +28,8 @@
 enum {
 	VHOST_VDPA_BACKEND_FEATURES =
 	(1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2) |
-	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH),
+	(1ULL << VHOST_BACKEND_F_IOTLB_BATCH) |
+	(1ULL << VHOST_BACKEND_F_IOTLB_ASID),
 };
 
 #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
@@ -57,12 +58,20 @@ struct vhost_vdpa {
 	struct eventfd_ctx *config_ctx;
 	int in_batch;
 	struct vdpa_iova_range range;
+	u32 batch_asid;
 };
 
 static DEFINE_IDA(vhost_vdpa_ida);
 
 static dev_t vhost_vdpa_major;
 
+static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
+{
+	struct vhost_vdpa_as *as = container_of(iotlb, struct
+						vhost_vdpa_as, iotlb);
+	return as->id;
+}
+
 static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
@@ -75,6 +84,16 @@ static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
 	return NULL;
 }
 
+static struct vhost_iotlb *asid_to_iotlb(struct vhost_vdpa *v, u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	if (!as)
+		return NULL;
+
+	return &as->iotlb;
+}
+
 static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
@@ -83,6 +102,9 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	if (asid_to_as(v, asid))
 		return NULL;
 
+	if (asid >= v->vdpa->nas)
+		return NULL;
+
 	as = kmalloc(sizeof(*as), GFP_KERNEL);
 	if (!as)
 		return NULL;
@@ -94,6 +116,17 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
 	return as;
 }
 
+static struct vhost_vdpa_as *vhost_vdpa_find_alloc_as(struct vhost_vdpa *v,
+						      u32 asid)
+{
+	struct vhost_vdpa_as *as = asid_to_as(v, asid);
+
+	if (as)
+		return as;
+
+	return vhost_vdpa_alloc_as(v, asid);
+}
+
 static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
 {
 	struct vhost_vdpa_as *as = asid_to_as(v, asid);
@@ -692,6 +725,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 	struct vhost_dev *dev = &v->vdev;
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
 	int r = 0;
 
 	r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
@@ -700,10 +734,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, 0, iova, size, pa, perm, opaque);
+		r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, 0, iotlb);
+			r = ops->set_map(vdpa, asid, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
@@ -725,17 +759,24 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	u32 asid = iotlb_to_asid(iotlb);
 
 	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, 0, iova, size);
+		ops->dma_unmap(vdpa, asid, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, 0, iotlb);
+			ops->set_map(vdpa, asid, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
+
+	/* If we are in the middle of batch processing, delay the free
+	 * of AS until BATCH_END.
+	 */
+	if (!v->in_batch && !iotlb->nmaps)
+		vhost_vdpa_remove_as(v, asid);
 }
 
 static int vhost_vdpa_va_map(struct vhost_vdpa *v,
@@ -943,19 +984,38 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_vdpa_as *as = asid_to_as(v, 0);
-	struct vhost_iotlb *iotlb = &as->iotlb;
+	struct vhost_iotlb *iotlb = NULL;
+	struct vhost_vdpa_as *as = NULL;
 	int r = 0;
 
-	if (asid != 0)
-		return -EINVAL;
-
 	mutex_lock(&dev->mutex);
 
 	r = vhost_dev_check_owner(dev);
 	if (r)
 		goto unlock;
 
+	if (msg->type == VHOST_IOTLB_UPDATE ||
+	    msg->type == VHOST_IOTLB_BATCH_BEGIN) {
+		as = vhost_vdpa_find_alloc_as(v, asid);
+		if (!as) {
+			dev_err(&v->dev, "can't find and alloc asid %d\n",
+				asid);
+			return -EINVAL;
+		}
+		iotlb = &as->iotlb;
+	} else
+		iotlb = asid_to_iotlb(v, asid);
+
+	if ((v->in_batch && v->batch_asid != asid) || !iotlb) {
+		if (v->in_batch && v->batch_asid != asid) {
+			dev_info(&v->dev, "batch id %d asid %d\n",
+				 v->batch_asid, asid);
+		}
+		if (!iotlb)
+			dev_err(&v->dev, "no iotlb for asid %d\n", asid);
+		return -EINVAL;
+	}
+
 	switch (msg->type) {
 	case VHOST_IOTLB_UPDATE:
 		r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
@@ -964,12 +1024,15 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
 		vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
 		break;
 	case VHOST_IOTLB_BATCH_BEGIN:
+		v->batch_asid = asid;
 		v->in_batch = true;
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, 0, iotlb);
+			ops->set_map(vdpa, asid, iotlb);
 		v->in_batch = false;
+		if (!iotlb->nmaps)
+			vhost_vdpa_remove_as(v, asid);
 		break;
 	default:
 		r = -EINVAL;
@@ -1057,9 +1120,17 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 
 static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
 {
+	struct vhost_vdpa_as *as;
+	u32 asid;
+
 	vhost_dev_cleanup(&v->vdev);
 	kfree(v->vdev.vqs);
-	vhost_vdpa_remove_as(v, 0);
+
+	for (asid = 0; asid < v->vdpa->nas; asid++) {
+		as = asid_to_as(v, asid);
+		if (as)
+			vhost_vdpa_remove_as(v, asid);
+	}
 }
 
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
@@ -1095,12 +1166,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	if (!vhost_vdpa_alloc_as(v, 0))
-		goto err_alloc_as;
-
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_alloc_as;
+		goto err_alloc_domain;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -1108,7 +1176,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
-err_alloc_as:
+err_alloc_domain:
 	vhost_vdpa_cleanup(v);
 err:
 	atomic_dec(&v->opened);
@@ -1233,8 +1301,11 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int i, r;
 
-	/* Only support 1 address space and 1 groups */
-	if (vdpa->ngroups != 1 || vdpa->nas != 1)
+	/* We can't support platform IOMMU device with more than 1
+	 * group or as
+	 */
+	if (!ops->set_map && !ops->dma_map &&
+	    (vdpa->ngroups > 1 || vdpa->nas > 1))
 		return -EOPNOTSUPP;
 
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d1e58f976f6e..5022c648d9c0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1167,7 +1167,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 				ret = -EINVAL;
 				goto done;
 			}
-			offset = sizeof(__u16);
+			offset = 0;
 		} else
 			offset = sizeof(__u32);
 		break;
-- 
2.30.1

