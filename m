Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06535232C0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiEKMQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiEKMP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:15:59 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EED2610F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 05:15:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arSDYKkNITXOzMbOtFsMvr/BSKWCC79vAy/i/bvzCcbHxk9lXfBvwSOTN5fw0ntLuXOOu7zjE3WphFy/4teqHfPqaWcisxq1YAU/UfO5TqafO5DwETeClmiz5LpM/QJRdJlBluMYMcSiXZNflE1+cPLAlc+ExTS9uuXZVrbEm1cAA7/7MvGMa/VBFyps+T2f1oBdZzN7K+MsbRC/9RXtkapU4texsQaPvUqKlRkK9FO09KFlR92R2kU71HXyA0e3wPaQqMImCdNyxs5b8BASJ9q8TPH2ZWESBiBwV5MccqkiDq217qQjFjJEyZwoTs8H3Lwqfhk9UqUfb1ksA1L+kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqfCS5T75mhgxryjNMT0pNSWmF4MTeO47pi8EUsJUOc=;
 b=koJUMmd+tRFREDnCwXWhMXvRjT9KB0gkxP4XdZeCL4mMujOpjmJKmQYv18ABe8dnjmUYOLPoBMkrtvskUgGWWWreqBYk54iJoFvuvcz/eVY0vIrhIFtuPVKFKunbVtvlW6E76Zd0YjXewOHtuxUf6WO5wfF5a9xCpLZ8KWgXfJiZkOkl7qXd3SL4QrtRbFmYBXls3Xi11IrWXgbkfiHkOjz2p1cSgdnaIhpnHRr6hAUBqpRaInKD09PoiyLKuQ2YXVuJARdHY8ye2BXIvYLaSUUpHsFiZxjK2hL6LSqpHJCIoN+7bteKqX7mgiedy50BTT6z/il1jzlRAZXkRuglog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqfCS5T75mhgxryjNMT0pNSWmF4MTeO47pi8EUsJUOc=;
 b=bi9RFEJl5jV6F4TCPjuVE5dGmch2w8mCMVXXp2qr+yMyXdf/06YtHLQCHI77Cc0LMKgBl3oDABK07Hd4YWzu+UHvQeEDufPZov6B+HRgEQlw7uftsvYhKSqaTaFDnBd5Jgr3C+S7shRYam4/JlVQnfDNEABYYi+C33nFmth6gSzu8emnM8PZN4lnPQKaB/7ZS6ru4eLJvU9FQx7IcCSjNxQUWvlVJMrRUxmsdkFj+Z3PYsApm3C6AfaR0FN5avN/uSwMlQ2ifu3gsa30SRQ8rPoAJYnQjujlgicuhSIozDVmqROnjC+cGH+lp2QdxMzo0GK++yDCVQuLAh1i4PssSQ==
Received: from BN9PR03CA0558.namprd03.prod.outlook.com (2603:10b6:408:138::23)
 by BYAPR12MB3046.namprd12.prod.outlook.com (2603:10b6:a03:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Wed, 11 May
 2022 12:15:55 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::c1) by BN9PR03CA0558.outlook.office365.com
 (2603:10b6:408:138::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22 via Frontend
 Transport; Wed, 11 May 2022 12:15:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 12:15:54 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 11 May 2022 12:15:53 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 11 May 2022 05:15:52 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 11 May 2022 05:15:49 -0700
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
Subject: [PATCH net-next v2] tls: Add opt-in zerocopy mode of sendfile()
Date:   Wed, 11 May 2022 15:15:25 +0300
Message-ID: <20220511121525.624059-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e204a09-3f68-40b1-346f-08da3347ff8f
X-MS-TrafficTypeDiagnostic: BYAPR12MB3046:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3046815799295007BCF26A5CDCC89@BYAPR12MB3046.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HlHvQ7LVm+UTa99GMmGDG4IW4PR/zkUfUrYefkMtbrgYFRlhtDbaP/8h6jLeY1tcc7Dgtcd8q3ipbSA2l3/L/1Q7LP3ukDPzoGDU1mcgBXBiV2vVZCM/70RVrutJq3z7C7b/Dl2DJlaJe2ebTBruiA1i2fOZMj53AMxEkeBBnvrI+Ed6NzJWx6xEgm4tHN5MHB3L+2TO/zJvCZhDre8BKQk0iKNzvK8S/ld8HY1Gkn0KfaKsuAfAOuSjx2NRQQnoWvc0pAn6pSEOqZPK1bAyIlUEPRgSrH0TxJa3E2DwoKBuKS2+c0T3GPuP8wOowQG7zjA6JKH8BFjPM8cWhzP3BS9rcqWxmj/yr7xo0mAC1ttpyCKcRzCLwPtHqYpSPtlZV5XodmgxJtkhvWJE79oiIwS8w0K4dHV7PiR7hq0mPj5Or4mXEupwldktIKe7geoNXAAbYW/U4VTi8JDUYEPXGwuPCCo7Loyy+iGBMVk2gmRxgYRNbqf+d2PeIKiKN9hsViPWzJO6fcbeohmu2nsuoe97eonUm5spp6YxqXh3NZYoMJ5MsPM7LXZIeatE57n7NX2rtXhqbnUIMGxWvUIrfucUR/LWaUvEhb1kVbETFz2eRakjEhW4NiSC39LRY+UxWMxjT/1HSncikdrq5W/3ug3mpmflyaEtdcop8f6JzRpV6Q/NCx/WspG5UEUTA4B65yOJCB3sBB48kr9N9FmG4g==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(81166007)(36860700001)(26005)(82310400005)(508600001)(70586007)(70206006)(6666004)(40460700003)(4326008)(8676002)(7696005)(1076003)(54906003)(356005)(2616005)(86362001)(8936002)(47076005)(426003)(336012)(107886003)(5660300002)(186003)(83380400001)(36756003)(2906002)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 12:15:54.8053
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e204a09-3f68-40b1-346f-08da3347ff8f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3046
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
option.

Performance numbers in a single-core test with 12 HTTPS streams on
nginx, under 100% CPU load:

* non-zerocopy: up to 23.5 Gbit/s
* zerocopy: up to 50.0 Gbit/s

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/net/tls.h        |  1 +
 include/uapi/linux/tls.h |  1 +
 net/tls/tls_device.c     | 53 ++++++++++++++++++++++++++++++----------
 net/tls/tls_main.c       | 48 ++++++++++++++++++++++++++++++++++++
 4 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index b59f0a63292b..8017f1703447 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -238,6 +238,7 @@ struct tls_context {
 
 	u8 tx_conf:3;
 	u8 rx_conf:3;
+	u8 zerocopy_sendfile:1;
 
 	int (*push_pending_record)(struct sock *sk, int flags);
 	void (*sk_write_space)(struct sock *sk);
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
index bca00521ebc1..ec6f4b699a2b 100644
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
@@ -480,12 +486,21 @@ static int tls_push_data(struct sock *sk,
 		}
 
 		record = ctx->open_record;
-		copy = min_t(size_t, size, (pfrag->size - pfrag->offset));
-		copy = min_t(size_t, copy, (max_open_record_len - record->len));
 
-		if (copy) {
+		copy = min_t(size_t, size, max_open_record_len - record->len);
+		if (copy && zc_page) {
+			struct page_frag zc_pfrag;
+
+			zc_pfrag.page = zc_page;
+			zc_pfrag.offset = iter_offset.offset;
+			zc_pfrag.size = copy;
+			tls_append_frag(record, &zc_pfrag, copy);
+		} else if (copy) {
+			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
+
 			rc = tls_device_copy_data(page_address(pfrag->page) +
-						  pfrag->offset, copy, msg_iter);
+						  pfrag->offset, copy,
+						  iter_offset.msg_iter);
 			if (rc)
 				goto handle_error;
 			tls_append_frag(record, pfrag, copy);
@@ -540,6 +555,7 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 {
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
+	union tls_iter_offset iter;
 	int rc;
 
 	mutex_lock(&tls_ctx->tx_lock);
@@ -551,8 +567,8 @@ int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			goto out;
 	}
 
-	rc = tls_push_data(sk, &msg->msg_iter, size,
-			   msg->msg_flags, record_type);
+	iter.msg_iter = &msg->msg_iter;
+	rc = tls_push_data(sk, iter, size, msg->msg_flags, record_type, NULL);
 
 out:
 	release_sock(sk);
@@ -564,7 +580,8 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct iov_iter	msg_iter;
+	union tls_iter_offset iter_offset;
+	struct iov_iter msg_iter;
 	char *kaddr;
 	struct kvec iov;
 	int rc;
@@ -580,12 +597,20 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 		goto out;
 	}
 
+	if (tls_ctx->zerocopy_sendfile) {
+		iter_offset.offset = offset;
+		rc = tls_push_data(sk, iter_offset, size,
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
+	iter_offset.msg_iter = &msg_iter;
+	rc = tls_push_data(sk, iter_offset, size, flags, TLS_RECORD_TYPE_DATA,
+			   NULL);
 	kunmap(page);
 
 out:
@@ -656,10 +681,12 @@ EXPORT_SYMBOL(tls_get_record);
 
 static int tls_device_push_pending_record(struct sock *sk, int flags)
 {
-	struct iov_iter	msg_iter;
+	union tls_iter_offset iter;
+	struct iov_iter msg_iter;
 
 	iov_iter_kvec(&msg_iter, WRITE, NULL, 0, 0);
-	return tls_push_data(sk, &msg_iter, 0, flags, TLS_RECORD_TYPE_DATA);
+	iter.msg_iter = &msg_iter;
+	return tls_push_data(sk, iter, 0, flags, TLS_RECORD_TYPE_DATA, NULL);
 }
 
 void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 7b2b0e7ffee4..6d0ae30e7861 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -513,6 +513,26 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 	return rc;
 }
 
+static int do_tls_getsockopt_tx_zc(struct sock *sk, char __user *optval,
+				   int __user *optlen)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	unsigned int value;
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	if (len != sizeof(value))
+		return -EINVAL;
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
@@ -524,6 +544,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = do_tls_getsockopt_conf(sk, optval, optlen,
 					    optname == TLS_TX);
 		break;
+	case TLS_TX_ZEROCOPY_SENDFILE:
+		rc = do_tls_getsockopt_tx_zc(sk, optval, optlen);
+		break;
 	default:
 		rc = -ENOPROTOOPT;
 		break;
@@ -675,6 +698,26 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 	return rc;
 }
 
+static int do_tls_setsockopt_tx_zc(struct sock *sk, sockptr_t optval,
+				   unsigned int optlen)
+{
+	struct tls_context *ctx = tls_get_ctx(sk);
+	unsigned int value;
+
+	if (sockptr_is_null(optval) || optlen != sizeof(value))
+		return -EINVAL;
+
+	if (copy_from_sockptr(&value, optval, sizeof(value)))
+		return -EFAULT;
+
+	if (value > 1)
+		return -EINVAL;
+
+	ctx->zerocopy_sendfile = value;
+
+	return 0;
+}
+
 static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			     unsigned int optlen)
 {
@@ -688,6 +731,11 @@ static int do_tls_setsockopt(struct sock *sk, int optname, sockptr_t optval,
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

