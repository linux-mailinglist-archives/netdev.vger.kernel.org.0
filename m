Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673604ECB6E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbiC3SLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbiC3SLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:11:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2067.outbound.protection.outlook.com [40.107.243.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1543D492;
        Wed, 30 Mar 2022 11:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwOoCnrVx3Vcm099wfgaMH25hE9Tb6K0lYqyxOZWrls=;
 b=YGFXWV2T/eXQH5DdwQU4rFaxNRcrY3TB1hi93OsarfIQFeXsooIauQcwzrSC5XZe7HRqgR2ky5RcNP3STjRACcZ5wvn9lYeYHggnYAPMzNj7a4kGbEmUChtsVMMXIyRpQnGvJL9O/WHozWrEsq257iusVEw4jFioNen33c6i9lM=
Received: from DS7PR05CA0066.namprd05.prod.outlook.com (2603:10b6:8:57::11) by
 SN1PR02MB3711.namprd02.prod.outlook.com (2603:10b6:802:29::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.19; Wed, 30 Mar 2022 18:09:25 +0000
Received: from DM3NAM02FT019.eop-nam02.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::6b) by DS7PR05CA0066.outlook.office365.com
 (2603:10b6:8:57::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:09:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by DM3NAM02FT019.mail.protection.outlook.com (10.13.4.191)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:09:24 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 3EB4341CDE;
        Wed, 30 Mar 2022 18:09:24 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqEwNZQmQsjtiRye+0qSyCdSjibwPxro85/Yur7AAZwMbm7ngn581qah3fr85jQyLnrnXlze0tA9RIIoXVLsrcqXQsFjDkhdIXRo+tvMJh/MR3PsYrElNYiI3g2YmnicJsV0h6JwbZZDGElX3z2K7bzf9Ue0z29Q9JQB7mv9rR/Rfl8nA3boQyNoXSoMct2KyIrHz3y5oS1r0DirmHvaUO3ixjbPfXKxZrNVqNxJ5Q0g+izKq31bLAbYjpq1vranB35QJXPZHS+I4R/WWq0WOp0s7+icam9Yiimb0l9JtKDRPW8Qa6lKE1OKYgNbik3Y7uvg9sx90K0C9uk5+Ghpzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwOoCnrVx3Vcm099wfgaMH25hE9Tb6K0lYqyxOZWrls=;
 b=En1OgMrtflXlzmJUoXeXo3eY5jONoixSI75d0Vy38f18C05rP6InzHvEVCaCwJ3y2/dLAClwhnGdsKJdUwIbkh/Fl20t762Jn2doZ2ZH/7QNBBHHIZn5RxstmWbGtGPlwhDE7UUpbSW6uvQ7KKfZflZ+6oh0Is5xvjOSYa96kohRGM2hwPLSqbENE5hq3RV7PlzXPcWrQZZ0+0tzHK6fqnj99mEIThw/zuxyydS5vWoRylSovur7L+Nnvg11xngBIg8AQI9RcUmq0jhHu1JLyI2il/+z2Lk2N676cc4FpFZ/a0a53XqDXAdHSvAcTnrbg9q9NqqrQmiutxemrTKw4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from DM5PR07CA0033.namprd07.prod.outlook.com (2603:10b6:3:16::19) by
 PH0PR02MB8454.namprd02.prod.outlook.com (2603:10b6:510:100::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 30 Mar
 2022 18:09:21 +0000
Received: from DM3NAM02FT057.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::c6) by DM5PR07CA0033.outlook.office365.com
 (2603:10b6:3:16::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:09:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT057.mail.protection.outlook.com (10.13.5.64) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:09:21 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:09:20 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:09:20 -0700
Envelope-to: mst@redhat.com,
 jasowang@redhat.com,
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
 zhang.min9@zte.com.cn,
 virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org,
 netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com,
 ecree.xilinx@gmail.com,
 eperezma@redhat.com
Received: from [10.170.66.102] (port=44662 helo=xndengvm004102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <gautam.dawar@xilinx.com>)
        id 1nZcky-000CCQ-Bf; Wed, 30 Mar 2022 11:09:20 -0700
From:   Gautam Dawar <gautam.dawar@xilinx.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gdawar@xilinx.com>,
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
        Zhang Min <zhang.min9@zte.com.cn>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <martinh@xilinx.com>, <hanand@xilinx.com>, <martinpo@xilinx.com>,
        <pabloc@xilinx.com>, <dinang@xilinx.com>, <tanuj.kamde@amd.com>,
        <habetsm.xilinx@gmail.com>, <ecree.xilinx@gmail.com>,
        <eperezma@redhat.com>
Subject: [PATCH v2 05/19] vdpa: introduce virtqueue groups
Date:   Wed, 30 Mar 2022 23:33:45 +0530
Message-ID: <20220330180436.24644-6-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 48860585-0813-46e2-22cf-08da12786c63
X-MS-TrafficTypeDiagnostic: PH0PR02MB8454:EE_|DM3NAM02FT019:EE_|SN1PR02MB3711:EE_
X-Microsoft-Antispam-PRVS: <SN1PR02MB37114CAD519D23C9691F5124B11F9@SN1PR02MB3711.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: FpPiosj1aGPHhS6kMT9Bi74w750KaD2UkXTQQum/JuFqoUusBo9r+6F+qzzOmG67lZsKARznjpxzLaVu5Qu8WS+41z34bWnm93tIibL03HYgLlRjwXmjWrcGBqMPi7fP9IGHLUINv7u5aY6EL9Ni5MjkAirPCSEJwNYpeFTaOaKmO/WF7pa5PBMCGcb9v3qgArL6C6zaWP2rsGoqjOTiDMPyXOEIik2vL5F/WO0c5oXR5njoczJWh30JVGdRvuu+L9j+GPg3NOmK7uaUvrZBFnQDW0PJ7cLBGsa8uyvEkYzqR4JyxqtxCYfBz/lrI05lTB+Fjs1ea+gKekw9ew7IQTfvVfjZryd4Ci107smVKJWeX8UQIVuMwhPuJ4TP28uW8FQl+O3ZATzTuGF1UtmzTbzZ+0z6+f3nxBhqSFEI/55xkytUQeSCbm5IW4zP5DwVtAcQXl35tssSXUvBTnI9JzYu07ifSyvWg2VShueUoK9NQGFYqytTclrI4wv9K27j56sdGTXewRNnFtpV1XJgwe0xeJd1Ir2hCOM4S+b8yUKxFhTvu8XgZsrUzHmXlPruILYEWiW0wPf2kVvSx4443+obvG7dozf/UtwHsqYRsbHm1GA2JQFHGIteZBptqqNnV+8tCQqRF52HQtzTDPTTfYMbXV/3FvFjQqe4yLPWaW7jgMsZVgBcXj4J2pZKyv2ek9EZauu525WNCdtW9dIaF9+XjGVIvhSnBM4Hq5c5ynM=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(83380400001)(2616005)(44832011)(186003)(9786002)(36860700001)(47076005)(426003)(7696005)(6666004)(336012)(26005)(1076003)(36756003)(30864003)(4326008)(82310400004)(110136005)(7416002)(5660300002)(40460700003)(70206006)(8676002)(508600001)(2906002)(316002)(70586007)(8936002)(54906003)(7636003)(921005)(356005)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8454
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DM3NAM02FT019.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9c9a1863-dbc8-4bca-9f5b-08da12786a50
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VCbF2jdXoRRQYFMA29tbxwOC/SBcFNqw9610FGxM+MFTvTIWsLE0Y+AfzowCGLMc/iaGziISBZpPX0ZzTymaXyJQSb4tFeqtp6xnr4/JyOc/F+01hjCAWkFYuQlj/Meu7zmIvjcnZI9C5GMuNqkI1/i0MdzYpwPfVW24hLTvXnGPDdN476Y+IkwBz/2N6xfO7yNYJqVspcW/lCWiJ0pKQMJtJwxhVvuDQzjmswF7RA7Z2ctfu93c9KBd8UrLLzUw8Ie77e1EsgZAPkhcwdiAKm1Sk3oMpOFIuNuQP2ms6/5yBXLeVfaNs1BjFbSN44eLPF8vApl+89UgcMRwnrpt9FDLO3yjEqDZ3q2LLXYezdOPx5ObwjLKVavkZBbI+rzi2+cXGL95IFE2qP2Uv4xFdlLXk38+ixaRBPl2gvq3bFTyr/DPsx2rDr1LYe5TK18aZcvgNcYIrL2Yszr1XZd4DuMT0pXxoO9FWTqSmfW2hhJ+s0wstWjU26sS/1/66ewnM+5bS2yY3yADT76fSSdW8UKZf+RaXY9NkCVHdm2vgue4zs+0angaZ19HHKVJ19AObBPyy7SYaTtndvJvOacxkc1Tk+nzAyqSiY4mqu/cF5wNnu13SdJOen0t0AcyWVfJqQzBiuNvc08pEbWvVCY2gyDeZ0SRS3q8fo5VO6IRoMFrtBAF1aPvodUZPPbgqwNI7G2kL4H7Fo9VBQUWHpL8opuQuWw60paU+7DzL8b7JoXzC3T6AiA74ov1UV01tq/z4mdVVgQpZIsssK29eMSkg==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7696005)(6666004)(47076005)(36860700001)(508600001)(5660300002)(921005)(8936002)(26005)(30864003)(44832011)(7416002)(1076003)(336012)(2616005)(186003)(9786002)(426003)(82310400004)(2906002)(40460700003)(36756003)(4326008)(8676002)(70206006)(81166007)(83380400001)(316002)(54906003)(110136005)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:09:24.8908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48860585-0813-46e2-22cf-08da12786c63
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-DM3NAM02FT019.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR02MB3711
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces virtqueue groups to vDPA device. The virtqueue
group is the minimal set of virtqueues that must share an address
space. And the address space identifier could only be attached to
a specific virtqueue group.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/alibaba/eni_vdpa.c    |  2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c    |  8 +++++++-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  8 +++++++-
 drivers/vdpa/vdpa.c                |  3 +++
 drivers/vdpa/vdpa_sim/vdpa_sim.c   |  9 ++++++++-
 drivers/vdpa/vdpa_sim/vdpa_sim.h   |  1 +
 drivers/vdpa/vdpa_user/vduse_dev.c |  2 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c  |  2 +-
 include/linux/vdpa.h               | 16 ++++++++++++----
 9 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/vdpa/alibaba/eni_vdpa.c b/drivers/vdpa/alibaba/eni_vdpa.c
index f480d54f308c..3e93c5eb0cf9 100644
--- a/drivers/vdpa/alibaba/eni_vdpa.c
+++ b/drivers/vdpa/alibaba/eni_vdpa.c
@@ -470,7 +470,7 @@ static int eni_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	eni_vdpa = vdpa_alloc_device(struct eni_vdpa, vdpa,
-				     dev, &eni_vdpa_ops, NULL, false);
+				     dev, &eni_vdpa_ops, 1, NULL, false);
 	if (IS_ERR(eni_vdpa)) {
 		ENI_ERR(pdev, "failed to allocate vDPA structure\n");
 		return PTR_ERR(eni_vdpa);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 4366320fb68d..fde33e143246 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -626,6 +626,11 @@ static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
 	return  vf->config_size;
 }
 
+static u32 ifcvf_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
+{
+	return 0;
+}
+
 static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
 				  unsigned int offset,
 				  void *buf, unsigned int len)
@@ -704,6 +709,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
 	.get_device_id	= ifcvf_vdpa_get_device_id,
 	.get_vendor_id	= ifcvf_vdpa_get_vendor_id,
 	.get_vq_align	= ifcvf_vdpa_get_vq_align,
+	.get_vq_group	= ifcvf_vdpa_get_vq_group,
 	.get_config_size	= ifcvf_vdpa_get_config_size,
 	.get_config	= ifcvf_vdpa_get_config,
 	.set_config	= ifcvf_vdpa_set_config,
@@ -758,7 +764,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	pdev = ifcvf_mgmt_dev->pdev;
 	dev = &pdev->dev;
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, name, false);
+				    dev, &ifc_vdpa_ops, 1, name, false);
 	if (IS_ERR(adapter)) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return PTR_ERR(adapter);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 79001301b383..89874624eb2a 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -1910,6 +1910,11 @@ static u32 mlx5_vdpa_get_vq_align(struct vdpa_device *vdev)
 	return PAGE_SIZE;
 }
 
+static u32 mlx5_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
+{
+	return 0;
+}
+
 enum { MLX5_VIRTIO_NET_F_GUEST_CSUM = 1 << 9,
 	MLX5_VIRTIO_NET_F_CSUM = 1 << 10,
 	MLX5_VIRTIO_NET_F_HOST_TSO6 = 1 << 11,
@@ -2454,6 +2459,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
 	.get_vq_notification = mlx5_get_vq_notification,
 	.get_vq_irq = mlx5_get_vq_irq,
 	.get_vq_align = mlx5_vdpa_get_vq_align,
+	.get_vq_group = mlx5_vdpa_get_vq_group,
 	.get_device_features = mlx5_vdpa_get_device_features,
 	.set_driver_features = mlx5_vdpa_set_driver_features,
 	.get_driver_features = mlx5_vdpa_get_driver_features,
@@ -2688,7 +2694,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	}
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 name, false);
+				 1, name, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 2b75c00b1005..946cc536078c 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -159,6 +159,7 @@ static void vdpa_release_dev(struct device *d)
  * initialized but before registered.
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
+ * @ngroups: number of groups supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
  * @use_va: indicate whether virtual address must be used by this device
@@ -171,6 +172,7 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
+					unsigned int ngroups,
 					size_t size, const char *name,
 					bool use_va)
 {
@@ -203,6 +205,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->config = config;
 	vdev->features_valid = false;
 	vdev->use_va = use_va;
+	vdev->ngroups = ngroups;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index ddbe142af09a..c98cb1f869fa 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -250,7 +250,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 	else
 		ops = &vdpasim_config_ops;
 
-	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
+	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
 				    dev_attr->name, false);
 	if (IS_ERR(vdpasim)) {
 		ret = PTR_ERR(vdpasim);
@@ -399,6 +399,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
 	return VDPASIM_QUEUE_ALIGN;
 }
 
+static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
+{
+	return 0;
+}
+
 static u64 vdpasim_get_device_features(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -620,6 +625,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
 	.set_vq_state           = vdpasim_set_vq_state,
 	.get_vq_state           = vdpasim_get_vq_state,
 	.get_vq_align           = vdpasim_get_vq_align,
+	.get_vq_group           = vdpasim_get_vq_group,
 	.get_device_features    = vdpasim_get_device_features,
 	.set_driver_features    = vdpasim_set_driver_features,
 	.get_driver_features    = vdpasim_get_driver_features,
@@ -650,6 +656,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
 	.set_vq_state           = vdpasim_set_vq_state,
 	.get_vq_state           = vdpasim_get_vq_state,
 	.get_vq_align           = vdpasim_get_vq_align,
+	.get_vq_group           = vdpasim_get_vq_group,
 	.get_device_features    = vdpasim_get_device_features,
 	.set_driver_features    = vdpasim_set_driver_features,
 	.get_driver_features    = vdpasim_get_driver_features,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
index cd58e888bcf3..0be7c1e7ef80 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
@@ -63,6 +63,7 @@ struct vdpasim {
 	u32 status;
 	u32 generation;
 	u64 features;
+	u32 groups;
 	/* spinlock to synchronize iommu table */
 	spinlock_t iommu_lock;
 };
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f85d1a08ed87..4ee6850b9a68 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1495,7 +1495,7 @@ static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
 		return -EEXIST;
 
 	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
-				 &vduse_vdpa_config_ops, name, true);
+				 &vduse_vdpa_config_ops, 1, name, true);
 	if (IS_ERR(vdev))
 		return PTR_ERR(vdev);
 
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index cce101e6a940..e18dfe993901 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -466,7 +466,7 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	vp_vdpa = vdpa_alloc_device(struct vp_vdpa, vdpa,
-				    dev, &vp_vdpa_ops, NULL, false);
+				    dev, &vp_vdpa_ops, 1, NULL, false);
 	if (IS_ERR(vp_vdpa)) {
 		dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\n");
 		return PTR_ERR(vp_vdpa);
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 8943a209202e..f7764e097bab 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -85,6 +85,7 @@ struct vdpa_device {
 	bool use_va;
 	u32 nvqs;
 	struct vdpa_mgmt_dev *mdev;
+	unsigned int ngroups;
 };
 
 /**
@@ -172,6 +173,10 @@ struct vdpa_map_file {
  *				for the device
  *				@vdev: vdpa device
  *				Returns virtqueue algin requirement
+ * @get_vq_group:		Get the group id for a specific virtqueue
+ *				@vdev: vdpa device
+ *				@idx: virtqueue index
+ *				Returns u32: group id for this virtqueue
  * @get_device_features:	Get virtio features supported by the device
  *				@vdev: vdpa device
  *				Returns the virtio features support by the
@@ -283,6 +288,7 @@ struct vdpa_config_ops {
 
 	/* Device ops */
 	u32 (*get_vq_align)(struct vdpa_device *vdev);
+	u32 (*get_vq_group)(struct vdpa_device *vdev, u16 idx);
 	u64 (*get_device_features)(struct vdpa_device *vdev);
 	int (*set_driver_features)(struct vdpa_device *vdev, u64 features);
 	u64 (*get_driver_features)(struct vdpa_device *vdev);
@@ -315,6 +321,7 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
+					unsigned int ngroups,
 					size_t size, const char *name,
 					bool use_va);
 
@@ -325,17 +332,18 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
  * @member: the name of struct vdpa_device within the @dev_struct
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
+ * @ngroups: the number of virtqueue groups supported by this device
  * @name: name of the vdpa device
  * @use_va: indicate whether virtual address must be used by this device
  *
  * Return allocated data structure or ERR_PTR upon error
  */
-#define vdpa_alloc_device(dev_struct, member, parent, config, name, use_va)   \
-			  container_of(__vdpa_alloc_device( \
-				       parent, config, \
+#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, name, use_va)   \
+			  container_of((__vdpa_alloc_device( \
+				       parent, config, ngroups, \
 				       sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name, use_va), \
+				       dev_struct, member)), name, use_va)), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
-- 
2.30.1

