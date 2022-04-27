Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA82B511DDA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244490AbiD0RyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 13:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiD0RyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 13:54:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4078F81482
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 10:51:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5SFw+B/2c5ynhIKhJq12R5NCALapzt3fVIEpRAZWAaL/R8eooe+KY+A2wB6IwXUxP/mR4LOEVyo1Bb65QpMUgSinloDo7xayEBlfLO2ydymrgo8TRM0Vqv5QfVX7KbPnTVYgfuyGVlr2E02gR3UU51coPiFhJhaRXhew1zI2Ojo7A5vcniJh4TNfJL22JOenGH9CsCf4uhyDqqaswWFh++qwYtvFejYtbCc1T0sNgpbYCnuShzc+mMPvm1t+UFWiPVXB+BaVdYYwNovQ/W2ETO+rL5JOho8NO5GjdV/11jWn5O+Qi2397vREVhnmBzf27vCSCNTQ63ZhCcQjfUXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLhcVTCNiriO/Mz4IMMjzzeg4A+BV9JruAyLkaLvCYk=;
 b=nE0gETdyWCdZfS4f3j4ysI+UcXAO+Id0CnWWhmcIrvEyOVWX81VjH7C2QEloBxwMQT92AQd/7gmgaxXvfy07ZCoGlrKp1dtMu9h7n79UO1j5mFcdJjD5sqJvuh+jagfJDEmuISuTG2Z8LEOYQ5xpvjgp86DjuZ5zWXumAXnZULAM3frzazzyynvtud3W3DdrM6/FhpTEFjyyHx/4xnOfAa1dhsyJy8Bt4uyKkt7lQw2oIobNTp1zCl993a7J25yBCYUOOvwv717VjDmwGkl3mPNmqjULnyx7Y/OY93Z+QEDzkWkaCyx4FcOjsCtXydqtD5w3owt7gYGiMj8O1HKQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLhcVTCNiriO/Mz4IMMjzzeg4A+BV9JruAyLkaLvCYk=;
 b=hAKQNRpw1dz5dFsJEyFgP8nw8lb94wKMxNzfLAhaWAGbjW7778gUYQv2VB1kKmy/Jye4Iz1r9sKh+pl3c+KWu0OLFYV4HLo+c8xaHiy3xpzXl+ul5pv2HXaRsYZINkiIdAcoIXakM+XzoXFmS0YmU47k4vwpzsenxm/R6fCt3UI6n9GvCgwU5Cr4W65E+O+tCcmUz6Wj+RY46nXBjESGs3CcX9fJwZ0S2cfgPjj19WanzUWDNGenJkKj6ErcO+yyzByukkOdyrELGKjywUOc1jtW/IF/hxs3xrSYMlHWpoSp/97rKmmlpR7poX6rUxENA+FIoA40PCAr/305FZD0Aw==
Received: from MW4PR04CA0083.namprd04.prod.outlook.com (2603:10b6:303:6b::28)
 by CY4PR12MB1382.namprd12.prod.outlook.com (2603:10b6:903:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 17:51:08 +0000
Received: from CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::bf) by MW4PR04CA0083.outlook.office365.com
 (2603:10b6:303:6b::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15 via Frontend
 Transport; Wed, 27 Apr 2022 17:51:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT011.mail.protection.outlook.com (10.13.175.186) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Wed, 27 Apr 2022 17:51:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 27 Apr
 2022 17:51:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 27 Apr
 2022 10:51:06 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 27 Apr
 2022 10:51:04 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next] tls: Add opt-in zerocopy mode of sendfile()
Date:   Wed, 27 Apr 2022 20:50:48 +0300
Message-ID: <20220427175048.225235-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d7cf864-72b2-4b8c-669d-08da2876825c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1382:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB138205D899A3DE6488A8C0E2DCFA9@CY4PR12MB1382.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: samWloiQ3DEKHq16xawyrufY0/dazsRL7Qn7bpW6WV8leTB2HCimloms0WK9zUbe82TXIeI0XEyQsR4S+t1xuVTTCtmGLU11JY61Vcs75SuCJSQ5U5ep/P/BT9QBegmKR/PbxCOax++exSwKcNl6F0zUbLJsop0eyk9gwlRDcwE53e9l/sCFQ9rWtqq28OKHS56/rVE1ArNlIIU9/5FWZbHZCcoZI/8bI1WTA8khfVEVJV0I1pvoaCTwpHWU/d7PidhiNfkuISZWHm806HVCz8HXhYX/z24Pe0HIqUsZ2gDrAj6Yu9dceT7UyHcp7ABc9+saG56pDAkSBCQJuSRqPyHTi/gUk7wtJgrLMEBThbhvBbO582E8MefZW4jlUYFoLKnUuoRc7bI9m7fjLeImIJcPZcbvvB/OkEEiluQpqwXuLpeqoJgygn/Ovj9IkZkwkl6whoyyqLr7Pb1r22L9sUvQk8KcqxdB5x2e+KIbPwNXR8XkJdKg19o9g5+/z3SRRrkj+sSxrgY9WSx3N7Scntvft4fWkD0R5vvG9UVCnYi+0wVvZY4KB8u3KNZlCCgGqCc6aGCJg8nx13zCm8g8bmkTuf1UombQiugcW/w01Hn1np5je70KjlMULS3RE1F4hoOWU6fYc6eDZgtIA7n7862RubvFOh5qRNGYhgL/4BvbCj/AJOxZi8ISzzB7ObfD3LYKnFeqlLVGhQPO4jKeryJAVAugehOKUq+VQtv4yY9vNyTsHu+Wp0irN3wb6U4MUqYkZAAWXw1UGrRoL+pL/1nUH5TLl1MQHtW87o6UA5s0dbytfoeevnPmIgYoXz/wIDd70Bzv58+wVrEQtWkarg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(110136005)(82310400005)(81166007)(2616005)(36860700001)(356005)(2906002)(86362001)(6666004)(83380400001)(70206006)(70586007)(45080400002)(8676002)(4326008)(186003)(54906003)(8936002)(40460700003)(966005)(7696005)(36756003)(1076003)(107886003)(5660300002)(316002)(508600001)(47076005)(336012)(426003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 17:51:08.2660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7cf864-72b2-4b8c-669d-08da2876825c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1382
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@nvidia.com>

TLS device offload copies sendfile data to a bounce buffer before
transmitting. It allows to maintain the valid MAC on TLS records when
the file contents change and a part of TLS record has to be
retransmitted on TCP level.

In many common use cases (like serving static files over HTTPS) the file
contents are not changed on the fly. In many use cases breaking the
connection is totally acceptable if the file is changed during
transmission, because it would be received corrupted in any case.

This commit allows to optimize performance for such use cases to
providing a new optional mode of TLS sendfile(), in which the extra copy
is skipped. Removing this copy improves performance significantly, as
TLS and TCP sendfile perform the same operations, and the only overhead
is TLS header/trailer insertion.

The new mode can only be enabled with the new socket option named
TLS_TX_ZEROCOPY_SENDFILE on per-socket basis. It preserves backwards
compatibility with existing applications that rely on the copying
behavior.

The new mode is safe, meaning that unsolicited modifications of the file
being sent can't break integrity of the kernel. The worst thing that can
happen is sending a corrupted TLS record, which is in any case not
forbidden when using regular TCP sockets.

Sockets other than TLS device offload are not affected by the new socket
option, and attempts to configure it will fail.

Performance numbers in a single-core test with 12 HTTPS streams on
nginx, under 100% CPU load:

* non-zerocopy: up to 23.5 Gbit/s
* zerocopy: up to 50.0 Gbit/s

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
Following up on the discussion [1], this is the patch that adds an
opt-in feature of zerocopy sendfile for TLS offload. Note that this
patch depends on bugfix [2], which should be applied first.

[1]: https://lore.kernel.org/netdev/DM4PR12MB5150C0ACA2781ABD70DB99E8DC0A9@DM4PR12MB5150.namprd12.prod.outlook.com/T/#u
[2]: https://lore.kernel.org/all/20220426154949.159055-1-maximmi@nvidia.com/

 include/net/tls.h        |  1 +
 include/uapi/linux/tls.h |  1 +
 net/tls/tls_device.c     | 62 +++++++++++++++++++++++++++++-----------
 net/tls/tls_main.c       | 55 +++++++++++++++++++++++++++++++++++
 4 files changed, 103 insertions(+), 16 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index b59f0a63292b..fc291e2747b5 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -164,6 +164,7 @@ struct tls_record_info {
 
 struct tls_offload_context_tx {
 	struct crypto_aead *aead_send;
+	bool zerocopy_sendfile;
 	spinlock_t lock;	/* protects records list */
 	struct list_head records_list;
 	struct tls_record_info *open_record;
diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 5f38be0ec0f3..47989b77ebcf 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -39,6 +39,7 @@
 /* TLS socket options */
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
+#define TLS_TX_ZEROCOPY_SENDFILE	3	/* transmit zerocopy sendfile */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index b12f81a2b44c..715401b20c8b 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -411,10 +411,16 @@ static int tls_device_copy_data(void *addr, size_t bytes, struct iov_iter *i)
 	return 0;
 }
 
+union tls_iter_offset {
+	struct iov_iter *msg_iter;
+	int offset;
+};
+
 static int tls_push_data(struct sock *sk,
-			 struct iov_iter *msg_iter,
+			 union tls_iter_offset iter_offset,
 			 size_t size, int flags,
-			 unsigned char record_type)
+			 unsigned char record_type,
+			 struct page *zc_page)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
@@ -480,15 +486,29 @@ static int tls_push_data(struct sock *sk,
 		}
 
 		record = ctx->open_record;
-		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
-		copy = min_t(size_t, copy, (max_open_record_len - record->len));
-
-		if (copy) {
-			rc = tls_device_copy_data(page_address(pfrag->page) +
-						  pfrag->offset, copy, msg_iter);
-			if (rc)
-				goto handle_error;
-			tls_append_frag(record, pfrag, copy);
+
+		if (!zc_page) {
+			copy = min_t(size_t, size, pfrag->size - pfrag->offset);
+			copy = min_t(size_t, copy, max_open_record_len - record->len);
+
+			if (copy) {
+				rc = tls_device_copy_data(page_address(pfrag->page) +
+							  pfrag->offset, copy,
+							  iter_offset.msg_iter);
+				if (rc)
+					goto handle_error;
+				tls_append_frag(record, pfrag, copy);
+			}
+		} else {
+			copy = min_t(size_t, size, max_open_record_len - record->len);
+			if (copy) {
+				struct page_frag _pfrag;
+
+				_pfrag.page = zc_page;
+				_pfrag.offset = iter_offset.offset;
+				_pfrag.size = copy;
+				tls_append_frag(record, &_pfrag, copy);
+			}
 		}
 
 		size -= copy;
@@ -551,8 +571,8 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto out;
 	}
 
-	rc = tls_push_data(sk, &msg->msg_iter, size,
-			   msg->msg_flags, record_type);
+	rc = tls_push_data(sk, (union tls_iter_offset)&msg->msg_iter, size,
+			   msg->msg_flags, record_type, NULL);
 
 out:
 	release_sock(sk);
@@ -564,11 +584,14 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_tx *ctx;
 	struct iov_iter	msg_iter;
 	char *kaddr;
 	struct kvec iov;
 	int rc;
 
+	ctx = tls_offload_ctx_tx(tls_ctx);
+
 	if (flags & MSG_SENDPAGE_NOTLAST)
 		flags |= MSG_MORE;
 
@@ -580,12 +603,18 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 		goto out;
 	}
 
+	if (ctx->zerocopy_sendfile) {
+		rc = tls_push_data(sk, (union tls_iter_offset)offset, size,
+				   flags, TLS_RECORD_TYPE_DATA, page);
+		goto out;
+	}
+
 	kaddr = kmap(page);
 	iov.iov_base = kaddr + offset;
 	iov.iov_len = size;
 	iov_iter_kvec(&msg_iter, WRITE, &iov, 1, size);
-	rc = tls_push_data(sk, &msg_iter, size,
-			   flags, TLS_RECORD_TYPE_DATA);
+	rc = tls_push_data(sk, (union tls_iter_offset)&msg_iter, size,
+			   flags, TLS_RECORD_TYPE_DATA, NULL);
 	kunmap(page);
 
 out:
@@ -659,7 +688,8 @@ static int tls_device_push_pending_record(struct sock *sk, int flags)
 	struct iov_iter	msg_iter;
 
 	iov_iter_kvec(&msg_iter, WRITE, NULL, 0, 0);
-	return tls_push_data(sk, &msg_iter, 0, flags, TLS_RECORD_TYPE_DATA);
+	return tls_push_data(sk, (union tls_iter_offset)&msg_iter, 0, flags,
+			     TLS_RECORD_TYPE_DATA, NULL);
 }
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7b2b0e7ffee4..8ef86e04f571 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -513,6 +513,31 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 	return rc;
 }
 
+static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
+				   int __user *optlen)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_tx *ctx;
+	int len, value;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	if (len != sizeof(value))
+		return -EINVAL;
+
+	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
+		return -EBUSY;
+
+	ctx = tls_offload_ctx_tx(tls_ctx);
+
+	value = ctx->zerocopy_sendfile;
+	if (copy_to_user(optval, &value, sizeof(value)))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int do_tls_getsockopt(struct sock *sk, int optname,
 			     char __user *optval, int __user *optlen)
 {
@@ -524,6 +549,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = do_tls_getsockopt_conf(sk, optval, optlen,
 					    optname == TLS_TX);
 		break;
+	case TLS_TX_ZEROCOPY_SENDFILE:
+		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
@@ -675,6 +703,28 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	return rc;
 }
 
+static int do_tls_setsockopt_tx_zc(struct sock *sk, sockptr_t optval,
+				   unsigned int optlen)
+{
+	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	struct tls_offload_context_tx *ctx;
+	int val;
+
+	if (!tls_ctx || tls_ctx->tx_conf != TLS_HW)
+		return -EINVAL;
+
+	if (sockptr_is_null(optval) || optlen < sizeof(val))
+		return -EINVAL;
+
+	if (copy_from_sockptr(&val, optval, sizeof(val)))
+		return -EFAULT;
+
+	ctx = tls_offload_ctx_tx(tls_ctx);
+	ctx->zerocopy_sendfile = val;
+
+	return 0;
+}
+
 static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			     unsigned int optlen)
 {
@@ -688,6 +738,11 @@ static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 					    optname == TLS_TX);
 		release_sock(sk);
 		break;
+	case TLS_TX_ZEROCOPY_SENDFILE:
+		lock_sock(sk);
+		rc = do_tls_setsockopt_tx_zc(sk, optval, optlen);
+		release_sock(sk);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
-- 
2.25.1

