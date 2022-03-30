Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213244ECB75
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349764AbiC3SMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349752AbiC3SM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:12:28 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAAE65D4;
        Wed, 30 Mar 2022 11:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyixZqeyQvnvr2Bdft565badxBxC5+EO1EWET8/79pk=;
 b=bYOVaBS43TD7a6gQxH70eam/nd8QgTWq1zkeidtgbFWskTI8D+RjflAz+WLeXO1qu4APO2NFH79EEBMotNXRGjgC+zGkVZBw8mfTEw7ySt9DQqL/SBwfCXzrV62iWdmV7zv1UbwtJjOGoNDBdOKQ2kAUDtds3Zrv6LatWklCVf4=
Received: from SA1P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::28)
 by BL0PR02MB4610.namprd02.prod.outlook.com (2603:10b6:208:4b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.20; Wed, 30 Mar
 2022 18:10:39 +0000
Received: from SN1NAM02FT0052.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:22c:cafe::a8) by SA1P222CA0021.outlook.office365.com
 (2603:10b6:806:22c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:10:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0052.mail.protection.outlook.com (10.97.5.70)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:10:39 +0000
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 34EEF42CBD;
        Wed, 30 Mar 2022 18:10:38 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaZXgYZP39sQ+vOXZm0ZH0YiVx49hWMhBGLTfc4Dqw11kw0tHXdhtM+10v2Cuj1pEe926nM4qyqZX5DwkAJn4o8njf88E84bJHEj6GBmkmP6ZVnkGNh2vCWmgxYv0cRYJr958hCsq5A4Lyhz9Hp8O9DyPAfAm1+AuInn2C+Kjr9XkI+I3JhcVOdRVKA1poDN9xcy3pF4cGRPGpFZ2olxSI5HzO/rwiXpj9AwxqqO2IAmQy4A971HPZx3jiGRQ+ynZ9EeRsLEOTdAAtBIzsrRRdKFPpXCPqtBM8vUFeweyWuPT3ldyVEunKSGV5Y3btVIP7vWfEdUZsel8bkwtDFovw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyixZqeyQvnvr2Bdft565badxBxC5+EO1EWET8/79pk=;
 b=ZQt5uqrIz2Ee+kr9rGxpN5FaWvQbjazpykmfJEyJGYBcyW3VaatteAs75yjZ3OpklRexxdij9buk/SzVwkOEEmkVMf49sij1oBnV6pHJmMjWV+pZ15+HNLn3CKW/LV44mwJb8Unp/pS8QCu6c0+O02wHK8wEgkTj2rGkL1eannzzPnGbNkSMBHyzTvBMwlv27WIPuhjGCFoflUzfgVyWV1sHN2jVBzB+VhxdIPJdZ4Fjv6ZWej7oGzSGCOwNCvQc74LCaI4/YaCrnhZ4jr1gXt7UKuNZLzk7C5k8CrbgQ3fv/hpCqg7kmujcnBX4tc9iwhRVrCnufJf9KfTNocyJHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from DS7PR03CA0071.namprd03.prod.outlook.com (2603:10b6:5:3bb::16)
 by BYAPR02MB5110.namprd02.prod.outlook.com (2603:10b6:a03:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 30 Mar
 2022 18:10:33 +0000
Received: from DM3NAM02FT010.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::e3) by DS7PR03CA0071.outlook.office365.com
 (2603:10b6:5:3bb::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18 via Frontend
 Transport; Wed, 30 Mar 2022 18:10:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT010.mail.protection.outlook.com (10.13.5.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:10:32 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:10:32 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:10:32 -0700
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
        id 1nZcm8-000CCQ-1M; Wed, 30 Mar 2022 11:10:32 -0700
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
Subject: [PATCH v2 06/19] vdpa: multiple address spaces support
Date:   Wed, 30 Mar 2022 23:33:46 +0530
Message-ID: <20220330180436.24644-7-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 403a3399-52f9-4a80-db99-08da12789893
X-MS-TrafficTypeDiagnostic: BYAPR02MB5110:EE_|SN1NAM02FT0052:EE_|BL0PR02MB4610:EE_
X-Microsoft-Antispam-PRVS: <BL0PR02MB4610EE56EB807E3FA4540817B11F9@BL0PR02MB4610.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 5Utf/4ccupRfY7qapGhlL6Da2G+w/AXcubSXMzWEkpnFmul5vaXid6EpPECdZ56QfhwStnrXTYAM9QCMDOzNHQQf1HZJjLfQJOPDmlsWCrowFlM6lzMGxYOBDR3t4EaGct2taHEe8g0cvHLJbN/qMpNBi0YAZNbJuFxEOg0AIgw32qLXq/JEOJY7As67Y/N/Kra0oRPXVfTZk1j5L5Zn2LEKLzIO7LJB1ter+d5Qmbl5ssL0V1raEJ3hS3IiAYwOnvcrRCRs46l3c+MhoqFk/64MVbM2M+FscsgrT5oGIHpOtbXuCNNhklDb65QQ595WvsuU1HSXaKEtbBo1qop1MYx9vuSOBaSe3Qkxf1e8gP6QS4LMxZKXvE267uDhNyOc82Ll0PZNbkVoF0py81yIDF+epz43cD78cMhjLgZa3SvDNMSxZ93srIQVr3TFl49CgURHW65eb2tp07s/tos4lrxHzDF1TFT7QA9/9sc5DbJxwNSTo5sTuLqD0GRLyssERZGAw5YDMLTXEgXzgQEycFYWHzJAldv+OzLczF1+UBavxzOXtXQkPYPCUTB5tJn7MdM5xXMCEqx9fYcCzIqL0QOE0fAhbxUY47f7Gk3cOrmB+5MxXBCmfyg9pTwuIIywmPxyTyMXYWfGvt5tUrwAz4YWdsrDkEVgpDznvc8KXNK+Vea4DF6bdKRShLcbHpogfHU+poBJ51GQR7oxwPofXXi3LN35KCzi2jMaUAjDcyA=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8676002)(26005)(70206006)(316002)(186003)(7696005)(47076005)(4326008)(921005)(356005)(70586007)(82310400004)(40460700003)(7636003)(36860700001)(5660300002)(6666004)(1076003)(54906003)(336012)(30864003)(44832011)(508600001)(426003)(2906002)(2616005)(9786002)(7416002)(8936002)(36756003)(110136005)(83380400001)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5110
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0052.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 40f3b6c5-0d8d-4688-6d8a-08da127894f0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8GIGNtyVaz/ldsxv7MfskfJrUShS7XN24Cd29iD6GBbqlcae9uz0DyRFIod7Kb6+oIoTNJJTBiVYr1CoyG9RICriTPzvown6CfZFZp8IJFCtV3HBRanBhkzvNUH/AE7U4+c0gvlZO/M0jHxLR83QkjSHPYSzS4iR8tqXhI+nr5F5OpOkYH1E2a3biXbfUmPPlBGXXHNlQs6+X52bImOhx2L6LxqkvDKM6iZCWP26EpqwrV1F6E0fYz1ZLuGqfBE4sgKeVXKM5ijMVXPbeIXUsm+m8U5UXGZsrvHZ36TKlL0OZk1/8XoQLt82u/p5NplhkzJgQvO1vHEIv9MWzkOA5i3RsIDl1tHcV5zYov6l5SSn58Go4ywa4bGxpMEmEoPQX0E22llOqYHX5cS9GqF/frxEGOVyjUPSB6Sk3g0g3GXLBOj7RAJyxR1WwcVRxBylW15602skAdsOmtSU3M5vKbzJjv7ydlLGFSmt9IQiOaPaZK/KfPqT+UbkHUmqVc3VRnQlqR61HSKReKVP9nVRnVybm1kLmHcQWXqJ5/NwOa41OJt++uG7ghiJ5XPveElLXjHymxvV3ukHvTh1EFhNjkFg/Mknwf6z5dOg0ZHlPKcODAGCcP+qgvjA+E9Jgx+j43esdHT4GIGl2QRA/C3eI0JHew0ixTgyvaH4/VgnkGz7jm64Lvx0GVmePj2N/BBLLNmz5RiIzBr2UdBzNKzMtyoABHq7H9SDVSLYz6U9yLPyeLTzKwLaJTxtnPorWL3KrYT/QVAmg+KReeE1kwnwA==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(70206006)(36756003)(8676002)(4326008)(81166007)(82310400004)(2906002)(40460700003)(36860700001)(921005)(44832011)(7416002)(47076005)(30864003)(5660300002)(7696005)(508600001)(186003)(2616005)(6666004)(316002)(8936002)(9786002)(54906003)(83380400001)(110136005)(1076003)(336012)(426003)(26005)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:10:39.0142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 403a3399-52f9-4a80-db99-08da12789893
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0052.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR02MB4610
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches introduces the multiple address spaces support for vDPA
device. This idea is to identify a specific address space via an
dedicated identifier - ASID.

During vDPA device allocation, vDPA device driver needs to report the
number of address spaces supported by the device then the DMA mapping
ops of the vDPA device needs to be extended to support ASID.

This helps to isolate the environments for the virtqueue that will not
be assigned directly. E.g in the case of virtio-net, the control
virtqueue will not be assigned directly to guest.

As a start, simply claim 1 virtqueue groups and 1 address spaces for
all vDPA devices. And vhost-vDPA will simply reject the device with
more than 1 virtqueue groups or address spaces.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vdpa/alibaba/eni_vdpa.c    |  2 +-
 drivers/vdpa/ifcvf/ifcvf_main.c    |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  5 +++--
 drivers/vdpa/vdpa.c                |  4 +++-
 drivers/vdpa/vdpa_sim/vdpa_sim.c   | 10 ++++++----
 drivers/vdpa/vdpa_user/vduse_dev.c |  3 ++-
 drivers/vdpa/virtio_pci/vp_vdpa.c  |  2 +-
 drivers/vhost/vdpa.c               | 14 +++++++++-----
 include/linux/vdpa.h               | 28 +++++++++++++++++++---------
 9 files changed, 45 insertions(+), 25 deletions(-)

diff --git a/drivers/vdpa/alibaba/eni_vdpa.c b/drivers/vdpa/alibaba/eni_vdpa.c
index 3e93c5eb0cf9..5a09a09cca70 100644
--- a/drivers/vdpa/alibaba/eni_vdpa.c
+++ b/drivers/vdpa/alibaba/eni_vdpa.c
@@ -470,7 +470,7 @@ static int eni_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	eni_vdpa = vdpa_alloc_device(struct eni_vdpa, vdpa,
-				     dev, &eni_vdpa_ops, 1, NULL, false);
+				     dev, &eni_vdpa_ops, 1, 1, NULL, false);
 	if (IS_ERR(eni_vdpa)) {
 		ENI_ERR(pdev, "failed to allocate vDPA structure\n");
 		return PTR_ERR(eni_vdpa);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index fde33e143246..c1767a0ce630 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -764,7 +764,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	pdev = ifcvf_mgmt_dev->pdev;
 	dev = &pdev->dev;
 	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, 1, name, false);
+				    dev, &ifc_vdpa_ops, 1, 1, name, false);
 	if (IS_ERR(adapter)) {
 		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
 		return PTR_ERR(adapter);
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 89874624eb2a..85dc3e93758e 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2368,7 +2368,8 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
 	return mvdev->generation;
 }
 
-static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb)
+static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
+			     struct vhost_iotlb *iotlb)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
@@ -2694,7 +2695,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
 	}
 
 	ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
-				 1, name, false);
+				 1, 1, name, false);
 	if (IS_ERR(ndev))
 		return PTR_ERR(ndev);
 
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 946cc536078c..36be04621fb3 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -160,6 +160,7 @@ static void vdpa_release_dev(struct device *d)
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
  * @ngroups: number of groups supported by this device
+ * @nas: number of address spaces supported by this device
  * @size: size of the parent structure that contains private data
  * @name: name of the vdpa device; optional.
  * @use_va: indicate whether virtual address must be used by this device
@@ -172,7 +173,7 @@ static void vdpa_release_dev(struct device *d)
  */
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					unsigned int ngroups,
+					unsigned int ngroups, unsigned int nas,
 					size_t size, const char *name,
 					bool use_va)
 {
@@ -206,6 +207,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 	vdev->features_valid = false;
 	vdev->use_va = use_va;
 	vdev->ngroups = ngroups;
+	vdev->nas = nas;
 
 	if (name)
 		err = dev_set_name(&vdev->dev, "%s", name);
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index c98cb1f869fa..659e2e2e4b0c 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -251,7 +251,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
 		ops = &vdpasim_config_ops;
 
 	vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
-				    dev_attr->name, false);
+				    1, dev_attr->name, false);
 	if (IS_ERR(vdpasim)) {
 		ret = PTR_ERR(vdpasim);
 		goto err_alloc;
@@ -539,7 +539,7 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
 	return range;
 }
 
-static int vdpasim_set_map(struct vdpa_device *vdpa,
+static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
 			   struct vhost_iotlb *iotlb)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -566,7 +566,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
 	return ret;
 }
 
-static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
+static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
+			   u64 iova, u64 size,
 			   u64 pa, u32 perm, void *opaque)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
@@ -580,7 +581,8 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
 	return ret;
 }
 
-static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
+static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
+			     u64 iova, u64 size)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 4ee6850b9a68..d503848b3b6e 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -693,6 +693,7 @@ static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)
 }
 
 static int vduse_vdpa_set_map(struct vdpa_device *vdpa,
+				unsigned int asid,
 				struct vhost_iotlb *iotlb)
 {
 	struct vduse_dev *dev = vdpa_to_vduse(vdpa);
@@ -1495,7 +1496,7 @@ static int vduse_dev_init_vdpa(struct vduse_dev *dev, const char *name)
 		return -EEXIST;
 
 	vdev = vdpa_alloc_device(struct vduse_vdpa, vdpa, dev->dev,
-				 &vduse_vdpa_config_ops, 1, name, true);
+				 &vduse_vdpa_config_ops, 1, 1, name, true);
 	if (IS_ERR(vdev))
 		return PTR_ERR(vdev);
 
diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
index e18dfe993901..35acba0e8d6d 100644
--- a/drivers/vdpa/virtio_pci/vp_vdpa.c
+++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
@@ -466,7 +466,7 @@ static int vp_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return ret;
 
 	vp_vdpa = vdpa_alloc_device(struct vp_vdpa, vdpa,
-				    dev, &vp_vdpa_ops, 1, NULL, false);
+				    dev, &vp_vdpa_ops, 1, 1, NULL, false);
 	if (IS_ERR(vp_vdpa)) {
 		dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\n");
 		return PTR_ERR(vp_vdpa);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 632c43eb5ecf..9202ff97ddb5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -633,10 +633,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
 		return r;
 
 	if (ops->dma_map) {
-		r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
+		r = ops->dma_map(vdpa, 0, iova, size, pa, perm, opaque);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			r = ops->set_map(vdpa, iotlb);
+			r = ops->set_map(vdpa, 0, iotlb);
 	} else {
 		r = iommu_map(v->domain, iova, pa, size,
 			      perm_to_iommu_flags(perm));
@@ -662,10 +662,10 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
 	vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
 
 	if (ops->dma_map) {
-		ops->dma_unmap(vdpa, iova, size);
+		ops->dma_unmap(vdpa, 0, iova, size);
 	} else if (ops->set_map) {
 		if (!v->in_batch)
-			ops->set_map(vdpa, iotlb);
+			ops->set_map(vdpa, 0, iotlb);
 	} else {
 		iommu_unmap(v->domain, iova, size);
 	}
@@ -897,7 +897,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 		break;
 	case VHOST_IOTLB_BATCH_END:
 		if (v->in_batch && ops->set_map)
-			ops->set_map(vdpa, iotlb);
+			ops->set_map(vdpa, 0, iotlb);
 		v->in_batch = false;
 		break;
 	default:
@@ -1163,6 +1163,10 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 	int minor;
 	int r;
 
+	/* Only support 1 address space and 1 groups */
+	if (vdpa->ngroups != 1 || vdpa->nas != 1)
+		return -EOPNOTSUPP;
+
 	v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!v)
 		return -ENOMEM;
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index f7764e097bab..7ab0e29ae466 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -69,6 +69,8 @@ struct vdpa_mgmt_dev;
  * @cf_mutex: Protects get and set access to configuration layout.
  * @index: device index
  * @features_valid: were features initialized? for legacy guests
+ * @ngroups: the number of virtqueue groups
+ * @nas: the number of address spaces
  * @use_va: indicate whether virtual address must be used by this device
  * @nvqs: maximum number of supported virtqueues
  * @mdev: management device pointer; caller must setup when registering device as part
@@ -86,6 +88,7 @@ struct vdpa_device {
 	u32 nvqs;
 	struct vdpa_mgmt_dev *mdev;
 	unsigned int ngroups;
+	unsigned int nas;
 };
 
 /**
@@ -241,6 +244,7 @@ struct vdpa_map_file {
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
  *				@vdev: vdpa device
+ *				@asid: address space identifier
  *				@iotlb: vhost memory mapping to be
  *				used by the vDPA
  *				Returns integer: success (0) or error (< 0)
@@ -249,6 +253,7 @@ struct vdpa_map_file {
  *				specific DMA translation (on-chip IOMMU)
  *				and preferring incremental map.
  *				@vdev: vdpa device
+ *				@asid: address space identifier
  *				@iova: iova to be mapped
  *				@size: size of the area
  *				@pa: physical address for the map
@@ -260,6 +265,7 @@ struct vdpa_map_file {
  *				specific DMA translation (on-chip IOMMU)
  *				and preferring incremental unmap.
  *				@vdev: vdpa device
+ *				@asid: address space identifier
  *				@iova: iova to be unmapped
  *				@size: size of the area
  *				Returns integer: success (0) or error (< 0)
@@ -310,10 +316,12 @@ struct vdpa_config_ops {
 	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
 
 	/* DMA ops */
-	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
-	int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
-		       u64 pa, u32 perm, void *opaque);
-	int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
+	int (*set_map)(struct vdpa_device *vdev, unsigned int asid,
+		       struct vhost_iotlb *iotlb);
+	int (*dma_map)(struct vdpa_device *vdev, unsigned int asid,
+		       u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
+	int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
+			 u64 iova, u64 size);
 
 	/* Free device resources */
 	void (*free)(struct vdpa_device *vdev);
@@ -321,7 +329,7 @@ struct vdpa_config_ops {
 
 struct vdpa_device *__vdpa_alloc_device(struct device *parent,
 					const struct vdpa_config_ops *config,
-					unsigned int ngroups,
+					unsigned int ngroups, unsigned int nas,
 					size_t size, const char *name,
 					bool use_va);
 
@@ -333,17 +341,19 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
  * @parent: the parent device
  * @config: the bus operations that is supported by this device
  * @ngroups: the number of virtqueue groups supported by this device
+ * @nas: the number of address spaces
  * @name: name of the vdpa device
  * @use_va: indicate whether virtual address must be used by this device
  *
  * Return allocated data structure or ERR_PTR upon error
  */
-#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, name, use_va)   \
+#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, nas, \
+			  name, use_va) \
 			  container_of((__vdpa_alloc_device( \
-				       parent, config, ngroups, \
-				       sizeof(dev_struct) + \
+				       parent, config, ngroups, nas, \
+				       (sizeof(dev_struct) + \
 				       BUILD_BUG_ON_ZERO(offsetof( \
-				       dev_struct, member)), name, use_va)), \
+				       dev_struct, member))), name, use_va)), \
 				       dev_struct, member)
 
 int vdpa_register_device(struct vdpa_device *vdev, u32 nvqs);
-- 
2.30.1

