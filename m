Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C4C4ECBB0
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349938AbiC3STv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350028AbiC3SSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:18:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C0960A82;
        Wed, 30 Mar 2022 11:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L0BsGdQsZOVSkg/wQOptjKuV2l1vscjGpi+dmt8KFR4=;
 b=pJ+IXe8bU+krPKpceMc/XE9XWbQLyw+l4ZPIDtAbXXbD4B/kdYofIMXLV69j91ggHoHAY0HZkjd5hCLGLMvAMMKY0Ju2lfVhgaNKU/9cQLO7RpTwyTA9Ca04JbcdTqiqDCcN99pHSFBpJldMIDtl32u5xuRKDPSbK6Y5hi3pzuk=
Received: from SA9PR13CA0025.namprd13.prod.outlook.com (2603:10b6:806:21::30)
 by DM6PR02MB6250.namprd02.prod.outlook.com (2603:10b6:5:1f5::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.20; Wed, 30 Mar
 2022 18:16:06 +0000
Received: from SN1NAM02FT0056.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:21:cafe::c7) by SA9PR13CA0025.outlook.office365.com
 (2603:10b6:806:21::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.12 via Frontend
 Transport; Wed, 30 Mar 2022 18:16:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0056.mail.protection.outlook.com (10.97.4.111)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:16:05 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 035CA3F03C;
        Wed, 30 Mar 2022 18:16:05 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moInRE4BZLRt01ALn+HNfqtqFzvCj8AoJEtEj6XDQ38PukVkClp98jo7qyCkY5kkhTDBPAk6d6UPdluUYhjwILzVNWiwFarLawE8Okptl2OWC5d1+Tp0Iopu2YZI7rVPLi50ETZ6mPceNhaNsEL1TBh8dY3qWU5QFYi+NI+Jr5fytC/ovYyKLoTY7pPXPw3g8X16R4Uz714L6YxsGSu5uexuZmXM1VChjfMrfi8K6aXMv11uDYO6n56fjYa/cvo2jPGFOFn8QEwpLunzgjFUCEVIJihHi0sjXjAF7RJYLzG/DqMoP3UgOMNhToi63vuHmwZoaPQazpySU27wROZ68g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L0BsGdQsZOVSkg/wQOptjKuV2l1vscjGpi+dmt8KFR4=;
 b=FJjfmrfzEa9Nw0u9E7kLfp4Re5sMGLe4SvfHW4BWShYtfsjeWBeYnqQfLNTjg5EmQdmpzAxY6KBzCuLmLw7QVf9zSaSzn6CeWOpPDVpjivCcVqd3gxnK8yy2ep79tla7NWqOwZaLp9HxgbUd2hkkTuswJ6EcApsaamSEAvwnYpXhi6UKtALuggSCqbp/63uuT+6L445J7HAJYDYEQ6O2MXwg8Pm5QSMRv9ElUEKltwfZLkerFQBeC2S96Y6ndYkx637FoAp8rmQFQjip95m16vDKumILR+3A/JPbIGbVGQ2ckznWtFlxMjcy+XxJguFOlF0/hEMkABAme+R/86xe3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN6PR1201CA0023.namprd12.prod.outlook.com
 (2603:10b6:405:4c::33) by BYAPR02MB5349.namprd02.prod.outlook.com
 (2603:10b6:a03:67::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 30 Mar
 2022 18:16:02 +0000
Received: from BN1NAM02FT047.eop-nam02.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::6c) by BN6PR1201CA0023.outlook.office365.com
 (2603:10b6:405:4c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:16:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT047.mail.protection.outlook.com (10.13.3.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:16:01 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:15:40 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:15:40 -0700
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
        id 1nZcr5-000CCQ-OK; Wed, 30 Mar 2022 11:15:40 -0700
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
Subject: [PATCH v2 13/19] vhost-vdpa: uAPI to get virtqueue group id
Date:   Wed, 30 Mar 2022 23:33:53 +0530
Message-ID: <20220330180436.24644-14-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: dea6366e-9682-4bd8-44ca-08da12795b4d
X-MS-TrafficTypeDiagnostic: BYAPR02MB5349:EE_|SN1NAM02FT0056:EE_|DM6PR02MB6250:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB6250A32D15AFAD95637E528DB11F9@DM6PR02MB6250.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: THE+A/iX12LrmClIWmokAcNMtVS8k2vPs7NdPThaMSDkB+Sw/cGVX4WE1Yn9DZ9sFrCivz2k5mkhvSNHKoOSOjbGkhryQDhZkDmuISEcadg6qwhKRFoecPthAsdQFEzuz2dm58xPadmjWJTGIW9wWpy3xOMAt1ANQY9W+s+AQlgPw+MtkYDg1s/PZEzJobWhQY2O6h7eIWNHsMs/io2tLTRJ5GwTSmw3PxeMlg2tkRLSmUm6yhrRZOzx0T9ta5mXjBAKrxdVApiGE27E7zq0DUqH1BvfrFWGAJkzUU/HWXltfNXTVx0MxoUs8N06Pi+NHtbe4gdj5x79zlg36nFGd2LvQbWTbBgmMeB+ze+ETdMC3udOonmUu6MJVKk5CM0CIv1sXdL/7iXGO0MV0IaY0xJk0FnfyjL8I9Hk5a3LMHDM6lfk63TKGI/aLK+ocOFp6j273sVC4uGF3J2eCI3q7qCGFvaYsh+zMCxJpSZ7rb+7pIULnC37HjR17/wkAYS6XoiC/Mr00JNDawrm+sfRIExx6ZGvTrEB4BmCZl0Tig4J88AFOHF7knBcbW8WjhWZfWtQCzrDy+3QdfwuSa3BMIMsoCMzliYwFIU8b3Hx3Dcns1DiiSkEpAirJqSJXSCzp8fglFCwzT0l6zgP4aqosd1HD70nWXTn+iNy+7tHyzqYkxla170FyHYIx9LvADDPZ6tCYZqa5Cg0LmIQ67g0ng==
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7696005)(44832011)(8676002)(83380400001)(36860700001)(4326008)(82310400004)(1076003)(26005)(186003)(336012)(426003)(2616005)(47076005)(2906002)(70586007)(70206006)(508600001)(316002)(5660300002)(6666004)(110136005)(7636003)(9786002)(54906003)(36756003)(7416002)(40460700003)(356005)(8936002)(102446001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5349
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0056.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 0dacc4f6-2aa1-45af-38e5-08da127958a5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zub0LPYc7gNas1MYTMbZXB4zGt+K05oX8ZqJcb33mkDl0ZD0m06h2fwDm6DYuOg4BpeV2iYL2VHeKzfTjTduJEBfVgebKIszoN3vTxwo1cD6f1RM5f3zRN6sdlRJ3OiTHG6dTf5PlWhtO4vJkCD2mvbn6RdDH9wKE6lSNc1Mr/nsrTD3FyWIUNrG8KPklO6xE9e9NwWjfrKRCdb1L65pp367vpEHMYX58oF23Z5YDCk+3J26PPrwGt+nLPrBRjHGTtktBO0DNTCx0N+LDEbbfRrJUkS6qtU3VOJ5iR0JrhEgHwpN4bJjzjsH/zU8aK++pGlLhqmpGRlzhZnSUZ83vfx9ERzXulVPGbER1mSj9ZCFSmn/1qCt/O5v7POavxXuCaChwSedXKuCClVF0gwX3IvaErQwc0Hi9KUL36mUagoNBq3RcGzud3h5fYle0vn4nU+OusmH9RmHXsu3gAgzJzIC8fMOYuH6fVfGpbOqKAe5wI2Ym0EuR4H9vR8T3t6+Wd8AdnTb6i2oS5nEzy4bMdnRonNZrWeCClXXB0Hgo4E1MhuHUf6fNt/ye9bPJhj8Yo4sjZG/9hdJhYzX5N7JXMZOTS+/wvWW9SzTsh72AdukO+xAYQRb0PiKTthYGZXL1oEb363Cu9Pq58LywGG7m7htHLPNlpLO5ECesgpJxsvajLEn25AnkvNjJK2/11ln4yrLpqovDTt/gEpPn1mFti7SLVDo3g8MzUNWkNr2FRlEoZyxjseCZx3p9xZddDlG
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(7416002)(2906002)(7696005)(5660300002)(83380400001)(26005)(1076003)(186003)(44832011)(9786002)(36860700001)(36756003)(8936002)(6666004)(2616005)(47076005)(70206006)(81166007)(316002)(508600001)(40460700003)(426003)(336012)(54906003)(82310400004)(4326008)(110136005)(8676002)(102446001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:16:05.6761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dea6366e-9682-4bd8-44ca-08da12795b4d
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000000.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0056.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6250
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows the support for virtqueue group in vDPA. This patches
introduces uAPI to get the virtqueue group ID for a specific virtqueue
in vhost-vdpa.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 8 ++++++++
 include/uapi/linux/vhost.h | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a017011ad1f5..aa5cacdc5263 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -465,6 +465,14 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 			return -EFAULT;
 		ops->set_vq_ready(vdpa, idx, s.num);
 		return 0;
+	case VHOST_VDPA_GET_VRING_GROUP:
+		s.index = idx;
+		s.num = ops->get_vq_group(vdpa, idx);
+		if (s.num >= vdpa->ngroups)
+			return -EIO;
+		else if (copy_to_user(argp, &s, sizeof(s)))
+			return -EFAULT;
+		return 0;
 	case VHOST_GET_VRING_BASE:
 		r = ops->get_vq_state(v->vdpa, idx, &vq_state);
 		if (r)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 51322008901a..668914c87f74 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -156,4 +156,12 @@
 
 /* Get the number of address spaces. */
 #define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
+
+/* Get the group for a virtqueue: read index, write group in num,
+ * The virtqueue index is stored in the index field of
+ * vhost_vring_state. The group for this specific virtqueue is
+ * returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_GROUP	_IOWR(VHOST_VIRTIO, 0x7B,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.30.1

