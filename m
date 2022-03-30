Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047DC4ECB96
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 20:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349912AbiC3SR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 14:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349918AbiC3SRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 14:17:18 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FE8654B3;
        Wed, 30 Mar 2022 11:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NFbMzJTO3OxwwdIRZlHDzzTQ4bZkkWtfHEDZBHx9i0=;
 b=floVBQVGrsnPFDa+3v7rqE9FSH+Pu4h4oSpqZX1aRP/2ZMhORY8f/Faqx2hiNeDdY5TuwFdMrMppxCcuF1kws/N3ruZefD70BO44+gk9s3saNgjcEUnCQEGmRPpJjKfwqLP/aofQUBkxAoHpwfLHL4FkOE3q2yfvmNCtEbznj2Y=
Received: from SA0PR11CA0053.namprd11.prod.outlook.com (2603:10b6:806:d0::28)
 by SN6PR02MB4014.namprd02.prod.outlook.com (2603:10b6:805:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Wed, 30 Mar
 2022 18:15:30 +0000
Received: from SN1NAM02FT0053.eop-nam02.prod.protection.outlook.com
 (2603:10b6:806:d0:cafe::c) by SA0PR11CA0053.outlook.office365.com
 (2603:10b6:806:d0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:15:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 20.83.241.18)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 20.83.241.18 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.83.241.18;
 helo=mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;
Received: from
 mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net
 (20.83.241.18) by SN1NAM02FT0053.mail.protection.outlook.com (10.97.4.115)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19 via Frontend
 Transport; Wed, 30 Mar 2022 18:15:30 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net (Postfix) with ESMTPS id 23DED3F03B;
        Wed, 30 Mar 2022 18:15:30 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qsl270JWNTGRseoXanZmjWwKj09F72Qs2iOEgaie18XHSQjHen/1H2EC5gtGi2VG/nd3RWbaypyKT2idBntvBeLHsv+BdtW394ypj9zKp6rV5/sMQY37va1lPPkDe2W//8n5WjoIchEZRUxcTB/5peHuSYr+thHHB51bmvG/XtPAT0384BIBYA96JI7mErb21ye9s7W5HEslzp5YZygz+l9adBz9V2swHI414rJo8QbqtstDW8fjzptA4SVFsI+aYx4FKA/FXNW/B3IZPSt24Hmsu/7Qv0hysaNCBP3jUufRk0GgTFyfW5xPSrqVHhcqRQ61MKxF/+3MuTeGrF85Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NFbMzJTO3OxwwdIRZlHDzzTQ4bZkkWtfHEDZBHx9i0=;
 b=gkXCYEVNIJSAa/kx1/TWLz6eMbJxmLo/dcFX922Uc86xXdiS+azt11S+3OiioJJX3qc3FFdmmKkETAlDFIxzzz0MV905mbPShHN5xM2fSw4OdJ/aJHIIytzAREr3+Bc783amRt7JJoHJR/9McnRRVM3Hp3uhUimQrMjJXwSxlo1cj+QDs3yTDQ9s6x110iwD7/0/BHe7ABiHxzvQKCP2vKa+YoF0lg+ExfRJzXt5kcF9e+f0UScGbc+hwRaDLCvNSxyrL11l5I1m7+rjnH4/M8MuF0HgMbJR6BiHZPsUJ33XhOCCdZNsFxkQyfnTVnra8bG+5bh81S6hODzhZ/NXGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=redhat.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
Received: from BN8PR15CA0061.namprd15.prod.outlook.com (2603:10b6:408:80::38)
 by MW2PR02MB3737.namprd02.prod.outlook.com (2603:10b6:907:3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.21; Wed, 30 Mar
 2022 18:15:28 +0000
Received: from BN1NAM02FT036.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::fe) by BN8PR15CA0061.outlook.office365.com
 (2603:10b6:408:80::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 30 Mar 2022 18:15:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT036.mail.protection.outlook.com (10.13.2.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5123.19 via Frontend Transport; Wed, 30 Mar 2022 18:15:27 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 30 Mar 2022 11:14:56 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 30 Mar 2022 11:14:56 -0700
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
        id 1nZcqN-000CCQ-RG; Wed, 30 Mar 2022 11:14:56 -0700
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
Subject: [PATCH v2 12/19] vhost-vdpa: introduce uAPI to get the number of address spaces
Date:   Wed, 30 Mar 2022 23:33:52 +0530
Message-ID: <20220330180436.24644-13-gdawar@xilinx.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20220330180436.24644-1-gdawar@xilinx.com>
References: <20220330180436.24644-1-gdawar@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 1
X-MS-Office365-Filtering-Correlation-Id: 24bdedf3-0bc8-40f1-7930-08da12794669
X-MS-TrafficTypeDiagnostic: MW2PR02MB3737:EE_|SN1NAM02FT0053:EE_|SN6PR02MB4014:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB40144C44362FA8E8BF4FBB61B11F9@SN6PR02MB4014.namprd02.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: y30d15eb3hbsFtrjlCNG8CH7FL0w303i/ccOOIG0Fz2a6Uv1Ym/h/7VB4qUs2sn88en/1WmORjOG97ofD8gheW0auXqVS23GA1VPbMuMmK29O8uPbGqV2pJLP/qWRmadVT8sLyspp1q4GM3teB8gQPPZXnCMiSRQZvTUDTaLTRfniCC/4Iq7Bqg/zQneyvLjT6iHsP94bgSBpjRluqJGBPKa9a1jnT1I2bOEQdprNuWDm+XM6tu3gHAV/67shENU3+QuZLlIUBt8n0Ch3QU7D/KqlEVblu4oHfFz/qp1Az9l2NXS1i3GFkEyaErEC+01dmm0r8xZ6dsSKvpeJ3tzWyByz8tlc21vRLcVT6BsEWTCRUnp3BE2kMP2LckdeuQq/O3bRYQCWCKne4qZYBYpe0hi73j9jO/YqGqtKY58fpw/hKTRDZi4Tg/pRbppVdsKvVexJoG4f11kKJrF43A84mHlZhgSKglbXUrN0dQw5iYfUgNwYcmVMM2W0NutUrqq5INdRonnBOUDILcVKH/zXO5akQU+mX8tFLLCk9SFOUrHGf2bCec31MolEnmWRwtLW+qW1ClEuIOr9/WXE0rvIOWWr+XgrLz4/LTBeLSvQx9SGDsbXpBB5w6e90HarJCpWm7ILzWKD0UStoh2s0SiIrZs/q4dgGiU3XJ2HSx9QvSWY3Uma2T9Y/ri2Hd9AuAa3/MELL6O6+UcFKCqK0dge1ahNDE5+qxskVV3AqUKjnc=
X-Forefront-Antispam-Report-Untrusted: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(36756003)(426003)(1076003)(508600001)(83380400001)(356005)(7636003)(36860700001)(336012)(7416002)(70586007)(70206006)(186003)(44832011)(82310400004)(26005)(47076005)(8676002)(6666004)(4326008)(8936002)(316002)(40460700003)(110136005)(9786002)(2906002)(5660300002)(7696005)(2616005)(54906003)(102446001)(15583001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3737
X-MS-Exchange-Transport-CrossTenantHeadersStripped: SN1NAM02FT0053.eop-nam02.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: e0cf7c2d-401e-4c28-c769-08da127944cd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lL2HnboubD+5gnTx14FKvzLft6eWmxtF5aOaHyrhnEhbbJtitvZySGQ30zaGDHf7a3jtbW1B5Es59cp2SNRHkkpu5EjpYyYap3BFjNBDSbDEogmDOKQSZYjTHLhmsJaqkUyX8McPBVzFA4XcFrTr5qO8xDTbOI+GdPvV8HOX5ch7RJvtJ2gJ/YWmV6XFkZ1AyT64XU2B4Vub7yrDMeTKCWmPiIKDb0EqTaKV7ahnm52g6SOAkjmOn1l8AdQ3MEDfFXHU/sfWDs3FNwXQidB97UoUOJrjntlZnAjs7WxREh7as63touooacCDTjsp2Elfg0njDE8W5EGZ4iot23SCpACyvvUJgA1al+KmpQdIX6KCnjEdT7wlry/XdCW1knMBqkneRvjjHOc8uLXCmh6QOl8b5TTT5FmzLR/9FsMnRLjeBxhewcKw28dOmjriOikkSIO0lmkhUZ6I0t/C+hzOvsZF9dwEe/XHdZnyzvlkeNIAKEcn4O+hWoKXiL6r7mEnY/h72+zbOeEH+UiOrt7H16amMYrHyMygtnCQyYiHWVkZkZiYk7e/wNPOnwydfzWG48eht0xphKoqU6c/dUK0BkesfzvyZYRV8w+iFVYNiIJu+qxPEF98vlYfda16zm7FxO0pPHz0z5rjgF/kbZ2OMmr0SeY7zdYdoP8XHxe/F9BI6uOHeBhec2PclFqlEmlo289xZ9hxS3Yd63SVM2AsvOtRsWQmMo4cBlOUhaQGHOpk7wT2JAnpbpWZCdad+paxJ8z8lej7/kRGiTaDgpkE2w==
X-Forefront-Antispam-Report: CIP:20.83.241.18;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(47076005)(316002)(36860700001)(54906003)(8936002)(426003)(5660300002)(336012)(36756003)(81166007)(508600001)(110136005)(4326008)(70206006)(26005)(6666004)(82310400004)(8676002)(40460700003)(186003)(7696005)(9786002)(83380400001)(7416002)(2616005)(2906002)(44832011)(1076003)(102446001)(15583001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 18:15:30.6756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24bdedf3-0bc8-40f1-7930-08da12794669
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[20.83.241.18];Helo=[mailrelay000001.14r1f435wfvunndds3vy4cdalc.xx.internal.cloudapp.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-SN1NAM02FT0053.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4014
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the uAPI for getting the number of address
spaces supported by this vDPA device.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
---
 drivers/vhost/vdpa.c       | 3 +++
 include/uapi/linux/vhost.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 92f78df0f685..a017011ad1f5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -563,6 +563,9 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		r = copy_to_user(argp, &v->vdpa->ngroups,
 				 sizeof(v->vdpa->ngroups));
 		break;
+	case VHOST_VDPA_GET_AS_NUM:
+		r = copy_to_user(argp, &v->vdpa->nas, sizeof(v->vdpa->nas));
+		break;
 	case VHOST_SET_LOG_BASE:
 	case VHOST_SET_LOG_FD:
 		r = -ENOIOCTLCMD;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index 61317c61d768..51322008901a 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -154,4 +154,6 @@
 /* Get the number of virtqueue groups. */
 #define VHOST_VDPA_GET_GROUP_NUM	_IOR(VHOST_VIRTIO, 0x81, __u32)
 
+/* Get the number of address spaces. */
+#define VHOST_VDPA_GET_AS_NUM		_IOR(VHOST_VIRTIO, 0x7A, unsigned int)
 #endif
-- 
2.30.1

