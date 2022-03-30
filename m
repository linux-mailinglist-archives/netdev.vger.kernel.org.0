Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8711E4ECB91
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349844AbiC3SQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349900AbiC3SQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:16:26 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE6D5F94;
        Wed, 30 Mar 2022 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLeIN+fhq8gkKNXJNNj252Lf+cxl6pHIXlqUJ4toR08=;
 b=S4sIbPrhGzA45E5zdFaOMSfZQOqcjXdFhI2IqZCUH8ESpxFTSC6/HJGWBo/JXHqHF3luMYRVr3XX9Hof7S6ujoWtgNnvTctVpN5xqyIoMYfzc39V+4QhR3pg+h3r9EJRQrph4dnkPFs6fEgpViQ7x1dIsnVFmLB1WOAoKNCj6BU=
Received: from SN4PR0201CA0068.namprd02.prod.outlook.com
 (2603:10b6:803:20::30) by BN7PR02MB5044.namprd02.prod.outlook.com
 (2603:10b6:408:25::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:14:39 +0000
Received: from SN1NAM02FT0058.eop-nam02.prod.protection.outlook.com
 (2603:10b6:803:20:cafe::d7) by SN4PR0201CA0068.outlook.office365.com
 (2603:10b6:803:20::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:14:39 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 20.83.241.18) smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=xilinx.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of xilinx.com: DNS Timeout)
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0058.mail.protection.outlook.com (10.97.5.116)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:14:37 +0000
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2048.outbound.protection.outlook.com [104.47.51.48])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id E714741CDF;
        Wed, 30 Mar 2022 18:14:36 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeSI1AxeSPCrJLviLPFlxDat++DJDyxVLFMMWGoQPkaXknZfMTdE3UAtWCJu62anieLZPxfU4aOjlmYFsPJ6gHpOEF8lixd5SsEheR2XXmkr7UPceS3OEL1w1fZ8jqyx9vnZpttDCGSfIaXkWxQPnIvTz0tsiiYkCFIh7AlA9miK1T1K4JWr+Tjf+OFiB6GXa7GwBBmGdfS8uDkU5Ujc0YXaSvuMpjL0J1+15XPgKWKJ04HAlmfXwzTXPlETrTHxL95MtK2Rv7Py+hy+Gcf3QlNMPXp4xg6UDos8h+kkYcokFfVXea+vZYWph5YH8Tz7+RyMx49oQASephHxtxMIEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLeIN+fhq8gkKNXJNNj252Lf+cxl6pHIXlqUJ4toR08=;
 b=J3aoRdD+Sq6upTs4GcOEepr4WxCN3Y4kgjJqIp56ns+NV4l5w8G448fDkhO4k1YzOfx3qXKFstBvYIQri1zKMSs5cYFKWm3gEu7Lq/R7S/fNojayx4/RS7M1xok1I4zjyXD+L4Hpkj3FM2T778343TwRp3or2+WXYbpuhRL8e8fQJ7qO5ZW8rJJIoJ5w9FD8/eoPVeydIYTjRxtPfmKFuO8gz9XVF1DwWVA0bzQcruGH9RCAAjJ2QvBntZnEVw+YhI2QZnmYy8xCRIFtXIgfR2VK8OI4hgoNyxZMoUR26aH7awr12c8tK+IXVosN95RSxGmjia7ezPilt0RHYYimlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN0PR07CA0011.namprd07.prod.outlook.com (2603:10b6:408:141::32)
 by SN6PR02MB3982.namprd02.prod.outlook.com (2603:10b6:805:2d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:14:34 +0000
Received: from BN1NAM02FT020.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::50) by BN0PR07CA0011.outlook.office365.com
 (2603:10b6:408:141::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:14:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT020.mail.protection.outlook.com (10.13.2.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:14:33 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:14:13 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:14:13 -0700
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
        id 1nZcpg-000CCQ-JZ; Wed, 30 Mar 2022 11:14:13 -0700
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
Subject: [PATCH v2 11/19] vhost-vdpa: introduce uAPI to get the number of virtqueue groups
Date:   Wed, 30 Mar 2022 23:33:51 +0530
Message-ID: <20220330180436.24644-12-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 9fad284a-04f6-4aaf-fb31-08da127926ab
X-MS-TrafficTypeDiagnostic: SN6PR02MB3982:EE_|SN1NAM02FT0058:EE_|BN7PR02MB5044:EE_
X-Microsoft-Antispam-PRVS: <BN7PR02MB5044A1DB2F91B3375AC62D39B11F9@BN7PR02MB5044.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EMT/v+O+q6R0I+fKZKym2boRLOuqvSsV7byxcDl6rd7vqwF+4YWrjN3cRbZPXSwv6roh7mGNglcQJ1/yLHq7kHIhkM+mgLhLkW5xw7QTLQ+VmXZx4WtC6TD9zTfszFZF3geZxW1KO5K1TPTfFdZPENHbGIb3JH2QqLlopHxZIy+01YEpNCnzVA5Sm3oGzk1cCTuUpx1WQtS7sARMmO4+KCJN9pC6NdAyd94pczLsrM5xne1MjPQYyC5FkEalZ9aGvZcBNhXuvtSrd+qhwHmmb52hDCW8TidXKLgyfaVBnLmslxC7CRQxkoTDHzJh6cJDXty8ZwtZifylbCZuEi02v59FtPfWeEHZQtRoi5ZvKDNn3BaPyvHG2YG5Pdr1Jf6hRWp2xF4oXmpesR8SqR0TfoTjSb1MwubYIP76B5dyXQTGk8BGdrtO51zCRhVkx7EknEbMydqeQcZSSuNAI7+HMjUXs2ogaZ5xgnfiLJY5DYADMe41VYoWflLbMXrW3DKUnSu/iB7tDhhuXZ6l6Jr/08JXV4+SG72WYPDX5L3TN3Enhsqpf7V60ln1U0cWM5LnKsZ1E+2O1wQgwL9C58yHTSa2XS+zfdDSX7/T3HcEHRgi1Ms7q1a8UkOMxzWHEUPy+ni878PFfw0QGdNDnpIcml7/HI+u6WYitmSdCcV8eteZ9AzwYwjvJG3ajALUOXMFi8Xa0O4q31HaoZsD0TguzJZSiHLhse8Nql1oFWhWJVo=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36756003)(356005)(7636003)(70586007)(7696005)(2906002)(4326008)(316002)(8676002)(70206006)(83380400001)(6666004)(40460700003)(36860700001)(44832011)(426003)(54906003)(47076005)(2616005)(336012)(5660300002)(110136005)(7416002)(9786002)(186003)(82310400004)(26005)(8936002)(1076003)(508600001)(102446001)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB3982
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0058.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 51078932-8b67-45c7-b08b-08da12792496
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xnO0Pi4PFbMHchD/D9IlMh9dRveupeG4lMpsWbFi19vY0FNvp8ES2p2TMT9vs65D4cSi6Ge6SAotY4GoE02lQXZeYlwl/v9EIQENWl8LJHpas9rgvm8EJguXiBZjUAIorsH+GfAT9g7bXuIpr5fFC6zMBrYm6U7nzX1xL2fKTknhq37ZQ8BBLJhaxWAzO22WKV8LPes9aYEM7cJo1aTg3Uvu9pK3xYX93cTAZ9UDUg73OwXqLyPai/b0QGOorYlk9N1pmYaR95wuyeKteGE3917PyOYxoRttOKqQDivaf5WCKUn3Wr4uSNAV9eLbbUGUCTLuzV/B+kqHiZk0nm0XRbEzvzJj1lGZPC9FoPqOrbuVSNqrYC2X6grJEIm8VtpUGBv3FAl4/JeaT2K5dBBKdW/Wj/DEqslWuBrwjexoGQ/f+Cuzr7jN8hooZKpF3LeTO+ddIM7JuTvsJ075e1XifTDvxICujo49OSWOXpH32Px/tLyHpuDZwpt1Z6JcRQQk2f2EShro7ds4ljSk3zuaKRl72TQ1MXTa0EZ6pZMrvLKPnwtnOxVPfFS10zb7HLLwg/IcfChkyuvbAD+jZh0yAPRhiMRNMUoKyHy59GH2JkYj+LZnRQKfan/hhScq8a8nY0v97ua19RYm2LKFLFFHTW6Kj8n/MUeFAfFpZOkSTYntO5Rl8+nrBgigGAqM0wDYLXSx5zF4vSKraMvJ2uTn5czN+PkvXj1Rw933KemJp/SmJ2vt/Sz3cEkQTTzPVJbk4fw1JMoybkokJwzFiRqxuA==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(4326008)(8676002)(36860700001)(81166007)(54906003)(110136005)(2906002)(40460700003)(316002)(336012)(186003)(5660300002)(8936002)(63350400001)(9786002)(426003)(36756003)(1076003)(83380400001)(63370400001)(70206006)(47076005)(44832011)(7416002)(6666004)(26005)(2616005)(7696005)(508600001)(82310400004)(102446001)(15583001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:14:37.4244
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fad284a-04f6-4aaf-fb31-08da127926ab
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0058.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR02MB5044
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the vDPA support for multiple address spaces, this patch
introduce uAPI for the userspace to know the number of virtqueue
groups supported by the vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 4 ++++
 include/uapi/linux/vhost.h | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index cd1bee536c46..92f78df0f685 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -559,6 +559,10 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	case VHOST_VDPA_GET_VRING_NUM:
 		r = vhost_vdpa_get_vring_num(v, argp);
 		break;
+	case VHOST_VDPA_GET_GROUP_NUM:
+		r = copy_to_user(argp, &v->vdpa->ngroups,
+				 sizeof(v->vdpa->ngroups));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 8f7b4a95d6f9..61317c61d768 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -145,11 +145,13 @@
 /* Get the valid iova range */
 #define VHOST_VDPA_GET_IOVA_RANGE	_IOR(VHOST_VIRTIO, 0x78, \
 					     struct vhost_vdpa_iova_range)
-
 /* Get the config size */
 #define VHOST_VDPA_GET_CONFIG_SIZE	_IOR(VHOST_VIRTIO, 0x79, __u32)
 
 /* Get the count of all virtqueues */
 #define VHOST_VDPA_GET_VQS_COUNT	_IOR(VHOST_VIRTIO, 0x80, __u32)
 
+/* Get the number of virtqueue groups. */
+#define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
+
 #endif
-- 
2.30.1

