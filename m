Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28214785F0
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhLQIIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:08:47 -0500
Received: from mail-dm6nam12on2050.outbound.protection.outlook.com ([40.107.243.50]:62561
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233453AbhLQIIq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 03:08:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxZTmG3h2XmAIjWwWn0MNlSq0mbznKwjrztKtga7rzdHP49On3vhPtrjzMuYAy/uWXIVgVgpCC25OwTqi8pWjhBWrVgEU+YvRLvT4CLjapVIZDWWVvOU160vaoM45w3jPvQTv3ugvSeTxTf7t/wQLSsA+j7HKxaQQaJnaRDxZjiyHu7MKjrEQe/9h2bHqIp2HwbYs36Cq7pPggHt/1FCWkLPoVI1T92lQJuB+jZyPnJXiB5a/7H559JkZ3NPaOjPnSTAX6sw1RJsFp8Jny/Pv2C667ci3d+ppkiBjBd9G+xagauuGJkKhbydBp42sezjzhf/3RcKcbXG2Xh07c49Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3z5matWWMtkiXlET9YFz6SGwVny+giDkwB9AzgXq2lg=;
 b=CJGOfvalR6QIOitXwu9IALrHhmTi9/+3yDuYFLci1P7jDg7c5n7pO4S73/H+3cX6PLKwiIHoztLlrChXxR1e3aj14KBtxlaTVwhf/EOV8UDS82rxa7to2GZJtfskpb35iCy97GvmshQ0896D4FSDWQAYH6WUbgezqq2RfZT1cybuTCMc+A8+DAsLevEiKZdJsxy6Nj9KqENAO45DHvznE8+bEN5nX0huTWCKecVvzVokvIlbVOmBXqqJ5/GzNRpTVFSL0ZQQNjZG/wyKzyyreQULgKLje9+cfGv83L10oNIlCTwIwTvvlTPfwwAy4zPfc+Rj1AICU7xE9bk4eHDUHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3z5matWWMtkiXlET9YFz6SGwVny+giDkwB9AzgXq2lg=;
 b=WPM3F6Ve9UVM/ugYtG7HD/dI8Zi4TzIPpMr45aCA9NC/t9+pQ4o76riNN0czr9iGxMt94cfjVgSW2FkOfuCajfsm5eQGJu2n43gY0lNB2PbAutsVy2r0Aaw+wrGWla2NtpWCzp2uNbW+Yj4dpsNcdSyt/xTgTnHmgGA66iWHDB27NSlbS23rAyLOO1M3kgUjKzg/5NyVIUk1J+Jys80lAIeT+pRwd16KXKgw//tEGf9fwlGKI4OZKWunq8RaKzGqqqKF4/ec3oSsi1da7r5pFo1UlmuiKJTR3x6Av33XQLJykQHMsaAUifxvWEJirQzRpLwH97yX/fooegI1YzHvrg==
Received: from DM5PR13CA0031.namprd13.prod.outlook.com (2603:10b6:3:7b::17) by
 MWHPR12MB1133.namprd12.prod.outlook.com (2603:10b6:300:d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.17; Fri, 17 Dec 2021 08:08:45 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::6f) by DM5PR13CA0031.outlook.office365.com
 (2603:10b6:3:7b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.8 via Frontend
 Transport; Fri, 17 Dec 2021 08:08:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Fri, 17 Dec 2021 08:08:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 17 Dec
 2021 08:08:41 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Fri, 17 Dec 2021 00:08:40 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next v2 1/4] vdpa: Update kernel headers
Date:   Fri, 17 Dec 2021 10:08:24 +0200
Message-ID: <20211217080827.266799-2-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211217080827.266799-1-parav@nvidia.com>
References: <20211217080827.266799-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1e5a68d-9955-4759-c278-08d9c134723a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1133:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1133F10EF125E6F3C1D77525DC789@MWHPR12MB1133.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yhq7HqgrdIy+7W2KeF4s2ocmCuLNy0xC19a2L4/jZnumxKRt4++NLV+kEjIlEWyw2o9MbKDTRFV8KEcNJmPTi1eZGJzBJYOVDM9S/trMDomlFrwijtmjcaCR6ZV93YAvAHbxR8auTvv6XmmstbGRoM4ItrKml1i+wMFJJhPsjnuS4bHa/KDqGQ00qT/yhmfWzmsPDm4HmSYD0UCQCz5uOOdfujmrNghDoWVvcWVFGUiL03Yc7sTUZdG2fuWHjo0hhodZUR3s1elUf20f3IZJdHFSH7S1w83O9Z04hpts5nLHZals6X+FX+8HWxENaTjasY9O1TGG/cQsa3VeWZ718HlmlufNL7ezSGemLMQctiiVH8TbdJyJxvRMUgZPljTRkSUpAMosFIWkaf0Bz2eZWLkCWloBGgm2FFvhavYb7v7Dr1CEQ26dXOTgIScg8Mb7DQ8qQJNEaWV2JyM1nNgSCGfgsbmVXeS6l471PJZkdPTF245v8MXk0o6aorJ8cKq2+bHCTAeYMOaDHU6vXxBaL1/hZZj55rdk6r1FVjag1uwgFLCb1WkUgXu7k4MkLH/XpOEmqq03vakTu5XEz773BkTT26BECAPBaZUpWCa7O8DaeADtUmxCMYQNEtRYPaXGvIFOgWaoNB4r8Hf0SexRTivuPmclX7THHCqg0R7z+tM3uqMatX1hfG807p8rVXXGfCbkAobEvboDbvy8NVWxEnV9u4Yn2YDlCC3k4pAyt+MiMzs/ykxcjPWqvuz4wvMj1M6TWGnoGT5MkQozJTeXVsFEomm6ir4ccSFJCzsa3pIXuKXT37CUf3fivuLw0tRyzU3SqSDRAbffIxGFH4abJg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(54906003)(15650500001)(47076005)(110136005)(4326008)(356005)(81166007)(34020700004)(1076003)(70206006)(86362001)(186003)(316002)(16526019)(36860700001)(70586007)(83380400001)(36756003)(8936002)(336012)(40460700001)(508600001)(6666004)(8676002)(107886003)(5660300002)(2906002)(426003)(26005)(82310400004)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 08:08:44.7455
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1e5a68d-9955-4759-c278-08d9c134723a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel headers to commit:
ad69dd0bf26b ("vdpa: Introduce query of device config layout")

Signed-off-by: Parav Pandit <parav@nvidia.com>
---
 include/uapi/linux/virtio_net.h | 81 +++++++++++++++++++++++++++++++++
 vdpa/include/uapi/linux/vdpa.h  |  7 +++
 2 files changed, 88 insertions(+)
 create mode 100644 include/uapi/linux/virtio_net.h

diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
new file mode 100644
index 00000000..d52965cf
--- /dev/null
+++ b/include/uapi/linux/virtio_net.h
@@ -0,0 +1,81 @@
+#ifndef _LINUX_VIRTIO_NET_H
+#define _LINUX_VIRTIO_NET_H
+/* This header is BSD licensed so anyone can use the definitions to implement
+ * compatible drivers/servers.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of IBM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED.  IN NO EVENT SHALL IBM OR CONTRIBUTORS BE LIABLE
+ * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+ * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+ * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+ * SUCH DAMAGE. */
+
+/* The feature bitmap for virtio net */
+#define VIRTIO_NET_F_CSUM	0	/* Host handles pkts w/ partial csum */
+#define VIRTIO_NET_F_GUEST_CSUM	1	/* Guest handles pkts w/ partial csum */
+#define VIRTIO_NET_F_CTRL_GUEST_OFFLOADS 2 /* Dynamic offload configuration. */
+#define VIRTIO_NET_F_MTU	3	/* Initial MTU advice */
+#define VIRTIO_NET_F_MAC	5	/* Host has given MAC address. */
+#define VIRTIO_NET_F_GUEST_TSO4	7	/* Guest can handle TSOv4 in. */
+#define VIRTIO_NET_F_GUEST_TSO6	8	/* Guest can handle TSOv6 in. */
+#define VIRTIO_NET_F_GUEST_ECN	9	/* Guest can handle TSO[6] w/ ECN in. */
+#define VIRTIO_NET_F_GUEST_UFO	10	/* Guest can handle UFO in. */
+#define VIRTIO_NET_F_HOST_TSO4	11	/* Host can handle TSOv4 in. */
+#define VIRTIO_NET_F_HOST_TSO6	12	/* Host can handle TSOv6 in. */
+#define VIRTIO_NET_F_HOST_ECN	13	/* Host can handle TSO[6] w/ ECN in. */
+#define VIRTIO_NET_F_HOST_UFO	14	/* Host can handle UFO in. */
+#define VIRTIO_NET_F_MRG_RXBUF	15	/* Host can merge receive buffers. */
+#define VIRTIO_NET_F_STATUS	16	/* virtio_net_config.status available */
+#define VIRTIO_NET_F_CTRL_VQ	17	/* Control channel available */
+#define VIRTIO_NET_F_CTRL_RX	18	/* Control channel RX mode support */
+#define VIRTIO_NET_F_CTRL_VLAN	19	/* Control channel VLAN filtering */
+#define VIRTIO_NET_F_CTRL_RX_EXTRA 20	/* Extra RX mode control support */
+#define VIRTIO_NET_F_GUEST_ANNOUNCE 21	/* Guest can announce device on the
+					 * network */
+#define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
+					 * Steering */
+#define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+
+#define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
+#define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
+#define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
+#define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
+					 * with the same MAC.
+					 */
+#define VIRTIO_NET_F_SPEED_DUPLEX 63	/* Device set linkspeed and duplex */
+
+#ifndef VIRTIO_NET_NO_LEGACY
+#define VIRTIO_NET_F_GSO	6	/* Host handles pkts w/ any GSO type */
+#endif /* VIRTIO_NET_NO_LEGACY */
+
+#define VIRTIO_NET_S_LINK_UP	1	/* Link is up */
+#define VIRTIO_NET_S_ANNOUNCE	2	/* Announcement is needed */
+
+/* supported/enabled hash types */
+#define VIRTIO_NET_RSS_HASH_TYPE_IPv4          (1 << 0)
+#define VIRTIO_NET_RSS_HASH_TYPE_TCPv4         (1 << 1)
+#define VIRTIO_NET_RSS_HASH_TYPE_UDPv4         (1 << 2)
+#define VIRTIO_NET_RSS_HASH_TYPE_IPv6          (1 << 3)
+#define VIRTIO_NET_RSS_HASH_TYPE_TCPv6         (1 << 4)
+#define VIRTIO_NET_RSS_HASH_TYPE_UDPv6         (1 << 5)
+#define VIRTIO_NET_RSS_HASH_TYPE_IP_EX         (1 << 6)
+#define VIRTIO_NET_RSS_HASH_TYPE_TCP_EX        (1 << 7)
+#define VIRTIO_NET_RSS_HASH_TYPE_UDP_EX        (1 << 8)
+
+#endif /* _LINUX_VIRTIO_NET_H */
diff --git a/vdpa/include/uapi/linux/vdpa.h b/vdpa/include/uapi/linux/vdpa.h
index 37ae26b6..b7eab069 100644
--- a/vdpa/include/uapi/linux/vdpa.h
+++ b/vdpa/include/uapi/linux/vdpa.h
@@ -17,6 +17,7 @@ enum vdpa_command {
 	VDPA_CMD_DEV_NEW,
 	VDPA_CMD_DEV_DEL,
 	VDPA_CMD_DEV_GET,		/* can dump */
+	VDPA_CMD_DEV_CONFIG_GET,	/* can dump */
 };
 
 enum vdpa_attr {
@@ -32,6 +33,12 @@ enum vdpa_attr {
 	VDPA_ATTR_DEV_VENDOR_ID,		/* u32 */
 	VDPA_ATTR_DEV_MAX_VQS,			/* u32 */
 	VDPA_ATTR_DEV_MAX_VQ_SIZE,		/* u16 */
+	VDPA_ATTR_DEV_MIN_VQ_SIZE,		/* u16 */
+
+	VDPA_ATTR_DEV_NET_CFG_MACADDR,		/* binary */
+	VDPA_ATTR_DEV_NET_STATUS,		/* u8 */
+	VDPA_ATTR_DEV_NET_CFG_MAX_VQP,		/* u16 */
+	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
 
 	/* new attributes must be added above here */
 	VDPA_ATTR_MAX,
-- 
2.26.2

