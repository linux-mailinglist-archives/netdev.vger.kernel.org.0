Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8F34ECB6B
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349677AbiC3SKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349712AbiC3SKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:10:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4DBDCD;
        Wed, 30 Mar 2022 11:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SP6ojcmP4JQ0BjSsfSCAtKPMgUZ/gwQ5cS2KSCB/JtU=;
 b=Kc1Bh0jRsi0DesxB35czYbCMrxUQvkWwU0jWaxDN5acEmXwyiiEgGQYdZcMWN474DW9fRu3mBQ/8xElK/IQBsSJddTdBHbaxcIZ1SpiGtQ0C3KCgcNxzCsJRIe2ewO/rHrNr1qFozYHzocoYGcv2NndBQFnTxnOatQPfVeroapw=
Received: from SA9PR13CA0005.namprd13.prod.outlook.com (2603:10b6:806:21::10)
 by CH0PR02MB8210.namprd02.prod.outlook.com (2603:10b6:610:f3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Wed, 30 Mar
 2022 18:08:44 +0000
Received: from SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:21:cafe::f4) by SA9PR13CA0005.outlook.office365.com
 (2603:10b6:806:21::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.12 via Frontend
 Transport; Wed, 30 Mar 2022 18:08:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0040.mail.protection.outlook.com (10.97.5.204)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:08:44 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 86CE53F02B;
        Wed, 30 Mar 2022 18:08:43 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IJdIjFAexsXxhVmzxtZ43YA3f8cn/T6wIbJ0hFKGqWlMrtAXE59cZZ+kTWOvKiQgyPAMIb3YwcNZ/imjs9FK/nOZ09k2hZJv8dtiFC/rz2RB2r+zEV3A199tIgUEggJOtPqheiMFyP1csGAtFeU2rhOBF4gWmsRPZxEdEGaYILpsDgCNPPrXYRRr9LaGNZRlxSBWEI7AQb0nQK3n96PdE8jhfm982SLO/1kluwI6jeZXHhaqnlheacmpprc3kpAKVLivhW8pWawrDMlBjJSVulUh7k0p8Xe80PR3OnajX87K79+Mx4kAA/yZub6mCt7X2V4lczsggpSGi9lk16t04w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SP6ojcmP4JQ0BjSsfSCAtKPMgUZ/gwQ5cS2KSCB/JtU=;
 b=PKg8mkr27MQ8E7lGPYg2l9A97pqyaqVXD5Q1hEjHm2tQh3LEJds8qmXRix14GHEqH5/ew/Q/fpn5Ql8KrmiHCj5lvWD606bZY6qcG1+nK277MFd6xa8tPCI6gesZpCxbnYNbhtpIBifa4mOUuPwcFYaREZE0kz6DfcFUzloGtgJX6F96RcUQBCabOtKGrEUc3wMtiv4QbotFQmGLNIn3aWn65e7MjsRUuC4sYEdZMBQWqS/nvDFlJnhZtu2/e0zD85y94IjuUmuxT/2MWRADlnK1hGJyRf5SV+UGiDT2I68UbJsvJRKWBrZHEBKQS+lWuiBqJ7KWBJHCp3nwTs9DlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from DM5PR07CA0027.namprd07.prod.outlook.com (2603:10b6:3:16::13) by
 DM6PR02MB4908.namprd02.prod.outlook.com (2603:10b6:5:13::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Wed, 30 Mar 2022 18:08:10 +0000
Received: from DM3NAM02FT054.eop-nam02.prod.protection.outlook.com
 (2603:10b6:3:16:cafe::7) by DM5PR07CA0027.outlook.office365.com
 (2603:10b6:3:16::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:08:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT054.mail.protection.outlook.com (10.13.5.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:08:10 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:08:07 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:08:07 -0700
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
        id 1nZcjm-000CCQ-Jv; Wed, 30 Mar 2022 11:08:07 -0700
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
Subject: [PATCH v2 04/19] vhost-vdpa: switch to use vhost-vdpa specific IOTLB
Date:   Wed, 30 Mar 2022 23:33:44 +0530
Message-ID: <20220330180436.24644-5-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: c453c91c-55ba-44fe-80d5-08da1278541c
X-MS-TrafficTypeDiagnostic: DM6PR02MB4908:EE_|SN1NAM02FT0040:EE_|CH0PR02MB8210:EE_
X-Microsoft-Antispam-PRVS: <CH0PR02MB8210AFDE98E50CEEA34DD57DB11F9@CH0PR02MB8210.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: TrScQRry2Kjd8QEuD7N6C6kWZwb4e7ppFwFN9L3Wo+RIamYsX6iqxWTEjjXPMSA4XXe7f0sL0db2xwoqju/BPDEpWZ76O3WIA/KsUY36bjdFAEMpfrHSt09gnqbMtFkWSNbxL5zDQ8XVOH9Bg+NgTHMDWPNNdLn6UsBtj2RN6NOgy1L4oybnm6D9zCIPUXpC1HY/l8W40tbmrvR/pmxAuHKGgovOBKl36sshsR2cKRM2KYklo6p9xQAbSV4tGifBDnYlpIvJ3GI+Ij24OosmbIFqQ7DwljfKkhDPj4Rfn7cSedXGNHrltrWatVEl646H8YxdkEQ/OUjRX7f6bt4p1dRmvmis2MtwxHmEQMzg6jRYrssXHIQYbE1t7XGa/BAefxKhbxi24O6mjpj0coiMz3AoqvlSyLRwZ9n0fdlcUUbd128GBZ/psW5/3BIMdEb7fw+AUuFdwvFEZNrCZd5HVXm7/pPNOiwlIA+ICJmjoomJq+2/h6qMniK2EHCBHfV8uFbLvJmH0V420Tqg5kDKTx8NEkLpN6VjjGLGSddFCcC2dMAvoIjVXK55A4hNNnNmZc5q0VUB6KJGsX+DjYxhHzaslJcnVfFaPFT4DqAFyJ318mIFOc5/qlH+an1xe/J6SWijwx+HgOdoiy+amUO9Pj0LVrp6mEiJh5X85RQzoxvMcMOvzSIcJz30CERzJANTiZs+PBv+ui9A3QqJgjejeA==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(8676002)(4326008)(82310400004)(7696005)(508600001)(6666004)(70586007)(70206006)(316002)(54906003)(110136005)(426003)(83380400001)(36860700001)(40460700003)(47076005)(336012)(8936002)(7636003)(44832011)(2616005)(1076003)(26005)(186003)(36756003)(356005)(9786002)(7416002)(5660300002)(2906002)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB4908
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 704fa12a-e56c-4a4e-f542-08da12784004
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XbwQhQoy1Tz3Ww/TLNWltrR+7BqCaGAW76PwwXwuLmymldTRpY4Ts3yIrzAgdfTuVxvDeDEImdscUkLEPacMIeW5DBjzribbEBJTkyXfm0HRfT7OXxNBLwWJOP/Fn8EW5QY/iO7+LhdUWtsO73myQDSC/0dZr1mnPk0+dsLE4krsa3ecezhOju3v+KFw2DUJeDsXn5bOwgIm72Z8YllcPeDstSId+5HyeseyGNERdbd6FGHuNk6tTm+3ataS59QLD5RxaayFGq34PWNLSm5J3yD7bvUGj8dpIFStxWWUbDruHQkc6IudJSezn7e2NcIOFTFLPpH0BCO0w9bgBBX1l0T7ciLkb750GdMPtSqXrZxh1IWeIpFuSdo6OVrxuOnY7ulU7Kljd07tyngnhuH5nVPqUOAyYvAkoM56GQSbtPmyyPDTLaDqdUO07Yhqvi2oFutFmgXzw3lSgrqV4YzwMzOi3BpSkKFeMT1DBkjTZAztF+qKv9dt3TTmaKKel54IDrRWx6I7pszZfXDlFUZyRD431Maty7erPky6R4s39ssXamkXveHYPo0Kjk2xu636kmT25CrGY+qY1hMYI7RofjDQjuOK5KvOwKX048386GTpC4h6CjyWrXm4Z5a1AVKri2ozGpk105nrvTabdsPReC/BRJ7Rt4ksHrvNUgAnDN//s1pDPxoc9GCKmPP3sOziN52yKdTd9F94q2BNAbRa++CXqU5B+MPOjlBTlB6FJVPrMFm+Na1wbypLnMTMxIhq
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(40460700003)(316002)(54906003)(83380400001)(110136005)(36860700001)(47076005)(426003)(336012)(8936002)(9786002)(4326008)(186003)(7416002)(70206006)(6666004)(36756003)(508600001)(5660300002)(81166007)(26005)(2616005)(1076003)(44832011)(2906002)(7696005)(8676002)(82310400004)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:08:44.1626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c453c91c-55ba-44fe-80d5-08da1278541c
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0040.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB8210
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ease the implementation of per group ASID support for vDPA
device. This patch switches to use a vhost-vdpa specific IOTLB to
avoid the unnecessary refactoring of the vhost core.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6d670e32e67b..632c43eb5ecf 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -39,6 +39,7 @@ struct vhost_vdpa {
 	struct vhost_virtqueue *vqs;
 	struct completion completion;
 	struct vdpa_device *vdpa;
+	struct vhost_iotlb *iotlb;
 	struct device dev;
 	struct cdev cdev;
 	atomic_t opened;
@@ -589,12 +590,11 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
 
 static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
 {
-	struct vhost_dev *dev = &v->vdev;
-	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb *iotlb = v->iotlb;
 
 	vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
-	kfree(dev->iotlb);
-	dev->iotlb = NULL;
+	kfree(v->iotlb);
+	v->iotlb = NULL;
 }
 
 static int perm_to_iommu_flags(u32 perm)
@@ -876,7 +876,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
 	struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
-	struct vhost_iotlb *iotlb = dev->iotlb;
+	struct vhost_iotlb *iotlb = v->iotlb;
 	int r = 0;
 
 	mutex_lock(&dev->mutex);
@@ -1017,15 +1017,15 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
 		       vhost_vdpa_process_iotlb_msg);
 
-	dev->iotlb = vhost_iotlb_alloc(0, 0);
-	if (!dev->iotlb) {
+	v->iotlb = vhost_iotlb_alloc(0, 0);
+	if (!v->iotlb) {
 		r = -ENOMEM;
 		goto err_init_iotlb;
 	}
 
 	r = vhost_vdpa_alloc_domain(v);
 	if (r)
-		goto err_init_iotlb;
+		goto err_alloc_domain;
 
 	vhost_vdpa_set_iova_range(v);
 
@@ -1033,6 +1033,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 
 	return 0;
 
+err_alloc_domain:
+	vhost_vdpa_iotlb_free(v);
 err_init_iotlb:
 	vhost_dev_cleanup(&v->vdev);
 	kfree(vqs);
-- 
2.30.1

