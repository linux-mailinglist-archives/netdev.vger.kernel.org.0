Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D285E465D5A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355317AbhLBE0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:26:31 -0500
Received: from mail-dm6nam08on2071.outbound.protection.outlook.com ([40.107.102.71]:37824
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344930AbhLBE01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 23:26:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i03saBSSaPU6IibT3gliwV+086OStg5b1t9G6XeLmEBHCLgvZgh7dnPQt9w5Luvr8mBJ10b+XaheO8oWqCtddWy0gbvxC4krYWncxVAkdDoKKEzTnRDBjMsMlrV6CBgtU+fHkVKwfTdRNKp4JtiIeDiqoicd3EtM4MTQTzmc8300FGfXN9u9T7zUWqi9hCnebiUGFkDQlpS4wV7sN4tggpeYJzvL/bRlhDEe9f6OD7u75mSzSBVxv7rQzeOlORNaniC6RM/L0JBXqJhKns9/Fp6fUMOSzyeQPz8KPgsu0ZfSAhHTPOdQEpUKs4UagHtHNJW/mRsyCOpTdJUs4bDtrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3z5matWWMtkiXlET9YFz6SGwVny+giDkwB9AzgXq2lg=;
 b=Yp9B1zfXBZ7D7rciv/X5tqC4deWCXlKwjOeFK6s5xEV6o8DP6O5NHJV4/CEohRg79Jm/v68ykl8Ug336fD1d7W6JkZnZHoDkWPtjoJ0S9MtELhLX61PV9iXS/ag0R0jHlxvo47aZQlNhmdc9Ifvnes3rbGngwXD42B6rIbyfx8U4HTrbodGG/fNepokx2xTAhl5KCRFoHmTG1yYKGsvZyo/JA+GUUibHpCUIJzQ1uDx0EUG4D0NNXOt3c37vhZf4hoRuWSVU9Aj1txZ8v4FKVPwBVShATZsxF++YpFg1NT36KCsmNuGIPR+CeZFtzCrYnQL0vwEnliJl8UrurwhPZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3z5matWWMtkiXlET9YFz6SGwVny+giDkwB9AzgXq2lg=;
 b=Ky5OyLjkVfrKvjHBYa3lLVSiCiAlVqcZiWTE+eK7YgIjNxF4s6dsl/XOM+6hJhz84d4WP81dTV7RBqJveJSjzYMBrTdpl9zR8bFvBWSqxxhoi9q5VUn9ZnkDCUVhyiEera+8rc4SJ/+nU0uqEVz6T69qmqOR1b7mROdOj7gVPfpy5T14uCMRvZHh91455XNja0fItArBT09xUNUxf37EUHR2UaBF2SmJpsmdEJ05nmioeOxD6GLbS4IgpEP5ImV25keEdC8tPeQ7ok4zO04HTqtJ3WK0GydNwFq+KNLZp56tuY1TchI6zUm2VFFJSRFICs3TvoSD4wrFmNLtfg/J+g==
Received: from BN0PR04CA0038.namprd04.prod.outlook.com (2603:10b6:408:e8::13)
 by DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 04:23:04 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::f7) by BN0PR04CA0038.outlook.office365.com
 (2603:10b6:408:e8::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11 via Frontend
 Transport; Thu, 2 Dec 2021 04:23:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 2 Dec 2021 04:23:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 2 Dec
 2021 04:22:58 +0000
Received: from unicorn01.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 1 Dec 2021 20:22:56 -0800
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     <virtualization@lists.linux-foundation.org>, <mst@redhat.com>,
        <jasowang@redhat.com>, Parav Pandit <parav@nvidia.com>
Subject: [iproute2-next 1/4] vdpa: Update kernel headers
Date:   Thu, 2 Dec 2021 06:22:36 +0200
Message-ID: <20211202042239.2454-2-parav@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211202042239.2454-1-parav@nvidia.com>
References: <20211202042239.2454-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6510058-4614-456a-99f4-08d9b54b6ee3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5264:
X-Microsoft-Antispam-PRVS: <DM4PR12MB526475C1273D5818995FD808DC699@DM4PR12MB5264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OEsodMd3BubfdTlcAsELWcyXGD8ka4v4dyskCpuz52rYD+XjGoKb3M8JBnOBINbcOWoWvVk4k2dZMV3cbUJKNHabqWx2EyQzAqSLaVhJn3IttPS6a6fiOy2kpGLgoiqIhWMHYUl5dRoUppYwdNjtf/z3oNrBIPT+Sybw8cdLpz/yIZoT/t1l/G1ncSEZXBp2Q+lDdUA0ONg6cls/T85sbh79Ex2eobr85xG0XQIezcgdEsaCkErBXDJVvZG+YIme5C70ERAYcp4o0P4JKz7srVBJe+iAv9Y3b1n5FRQmY9ms+dnQyxcU7un4t1lSp9g8WEJ8Eifg19iDYOFubH4ChqOOSZWlPQrGL8Fnhnsj8OdY0gdIiWkm6hEUltKyILReRxs+CGXHvxO39AtcIN+m6CiKo2wNBtolMlTqWSl08Sw35uZnghPumHh4fW0e79BT0iZFyVJ5LrURyc7PTp7OZgwujC5K7XGEBrLRfBlbqCKqEBZH0o84dBfvMdmjG3QOYUMy7Vwj3e2Lmb0sBq463NyRCS5FHm2edyutRGSSBiLrxC61HY+5Syd9uZWfdn/ptAZKXOumLtRrR9+3KBPDE1oRI9DQX0E4OyHmb2mim5eGuVjM8xOsOrFn0z8290Sd8b6jyHrEIjfQqim7wLoRwdtCJ4y98suvUonmoIgqFuigRyL1LyNEArx5AblfFA5swCrSusCIh4il0Ds8K0KIXKNYIp3rQ1ZYFph/h/ANZmubhYuUrL5S9l/QGHB1ZlkbaqdPM4onAlQ+x9JZIEo1yQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(26005)(54906003)(2616005)(356005)(83380400001)(6666004)(8936002)(36860700001)(70206006)(70586007)(110136005)(15650500001)(16526019)(36756003)(426003)(7636003)(8676002)(336012)(316002)(1076003)(47076005)(5660300002)(82310400004)(107886003)(40460700001)(508600001)(4326008)(86362001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 04:23:03.4876
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6510058-4614-456a-99f4-08d9b54b6ee3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5264
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

