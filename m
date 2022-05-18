Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B68552B5EB
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbiERJ2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiERJ2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:28:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B22B762B9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 02:28:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQfkdqC16q3Ll51zewcMW7vrl3N1fL/sd6Pz1EQAtoA+Il5EsrwxiDGn68XIydtl/2CkBHyik1nEr/+HtGJO7dj0VqP9pa/8CGECRo+6z8+f0vwsWgLZqIK8jDxio5MH+RPTKXS3IDQVsazCBCpwydWBQUppyGhNPDws0wMeXsrZATAITK1+jWvfDdYKxeYDz09cncaeq7r0MkJrRw6vTmS8E5yWyaLzVr9g7sXJm+W59B5mkyMosJIegYqiWqzwfEtDoi/ar2kvoNe6MljwIiczXhb/GHM95Qwnuy5P8A8w2drTB+ExANaqQdh40GAxqZVq5dhFE1G6ZIlqSJOXLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHoyvw4bUFyFYgJ4Va90ZeecdRQxRxj3298S6aYyf8o=;
 b=l+1IqXG5fumsp6us0RDf+xwwPiAvKzDzQRQDoYWzEaaRkxQC56gRJw1HTM47VxuhsdHUo5dubZRdH7B0gEOfx7Wv64l3Y0SXoh9v/iPw0FG0C7n6xNDRS760Zm2lxDPNoKbE5Zpp46q696EQb+y9sbBcV6h0fXT03RiD3cn4Hj2GCjpfkYiQrdWLBvpiCvfikwhEGmFn56vU8GRgNEUZ8nhQK2fC482df0qWoiRs1ZudbsDDFXBoi1vJqQUj+Tlw3JJ0b97oPCjxvwFm+1S80XM+7N3eXdtzgO+M+uNh+dLZAaURa6QLo4GYnhjFV9Ueu8Fp4eYeD4yehtnW/0zjGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZHoyvw4bUFyFYgJ4Va90ZeecdRQxRxj3298S6aYyf8o=;
 b=TUgjThc/Vg6Bg9c4l51NQ7QPlyQ47lc5RgZjFNjRV3MWi1bcefL8RzupKTuMJmJMRsuLb3DAy7dLh2GmOg+4w4h81/yYot4XDBK6Td2VrKZMoCkxUrok4uDBb5xeoxwhHwJJNUSiLnl6ES/mP8BkgLQTKYzEq2kVQ+P+fbSVdNd0KWxslZttOpu9A/HSwTGfdAlv1G1PWuWExWQm8TS0Cv2sZW5OYWJRAMGFIjyqU89V/SXnUJR/XnG2mPVrfgQm0UkvdNLWwsRH7Nw5eRgojA0I3DOe4umlUhuUD6CymqPz5/S9LcyeqSdki/Wvgv6lacDh9hMfVyBqzfdKY7CKuQ==
Received: from MW4PR03CA0203.namprd03.prod.outlook.com (2603:10b6:303:b8::28)
 by DM6PR12MB3770.namprd12.prod.outlook.com (2603:10b6:5:1c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Wed, 18 May
 2022 09:27:38 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::30) by MW4PR03CA0203.outlook.office365.com
 (2603:10b6:303:b8::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 09:27:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 09:27:38 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 18 May
 2022 09:27:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 18 May
 2022 02:27:36 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 18 May
 2022 02:27:34 -0700
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
Subject: [PATCH net-next v3] tls: Add opt-in zerocopy mode of sendfile()
Date:   Wed, 18 May 2022 12:27:31 +0300
Message-ID: <20220518092731.1243494-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db2ae739-5e90-40b7-0e99-08da38b0a658
X-MS-TrafficTypeDiagnostic: DM6PR12MB3770:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB37705369942D02877DFCEC3FDCD19@DM6PR12MB3770.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nF2thucZhPC/jZ3MoKF5Ji5aHqckliUDDu16Cy9nmAyJSJl5We2EqXxb2sfowsmIYuGVovuVC7YqQUXzHMWceQCDrCAZokXDXVNUUju0/VziGSgRd5KtrEKwEgKj3qTCgNmrW0GcynlorddYXMV64kX5pPHisUH+7uFIS+RRFx1TSyfdMuIHRpKEVyUZ6tfwnSbE9ykv+cpi+rfNx9+J0Ece/FqKdcHajbwuUEjVa2mPpnBSjtTWjAznPR+dK/Kkp66+3qkl6KY1SwF2UpvN81frQ7JW7PNK/l6657ePsiCKnQhaW9w5o5/zPeneydeoj1toI2a5SQy1D4IDf+QkdwERbigxXlwOkz01Uh88ggVrCMYjYCVO1Fpao62Zd0bQUgAr4CuuwcdTNZejHvxaU+yKbWTnKBz8xP45sl28EXGOc6Qg/r4H/TXOzE/BYTfdcncx3eQgB+4J5AbWHKdeEY+lOynIeOPxYD2XtiwB82AFpGE7KsP+fNEXeD/U3r9Oh0wAplNmp0Hvybp5i3BlL5nPafAstwx5pRhqdRwY4DY9Fp4nq9Ig2ltbiMnkjQrhRN87qOsu1ycy02N1oFv5MB+2R3sCbRqv15XUsQEZJHxrT9GOMFqf1NAtsqPzHpnogoBz9qpg7uqZfPPeZ3zJkB0yvvdKslD6EPzmlLe9lmf+d4GVafNNh5C3y8pj2MWOmLCkLQwPC70PbK2nMC23Dw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(83380400001)(6666004)(2616005)(316002)(107886003)(40460700003)(426003)(82310400005)(47076005)(2906002)(110136005)(81166007)(508600001)(8936002)(26005)(8676002)(70206006)(86362001)(4326008)(1076003)(7696005)(356005)(186003)(336012)(36860700001)(54906003)(5660300002)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 09:27:38.1128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db2ae739-5e90-40b7-0e99-08da38b0a658
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3770
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
option. The actual status of zerocopy sendfile can be queried with
sock_diag.

Performance numbers in a single-core test with 24 HTTPS streams on
nginx, under 100% CPU load:

* non-zerocopy: 33.6 Gbit/s
* zerocopy: 79.92 Gbit/s

CPU: Intel(R) Xeon(R) Platinum 8380 CPU @ 2.30GHz

Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/net/tls.h        |  1 +
 include/uapi/linux/tls.h |  2 ++
 net/tls/tls_device.c     | 53 ++++++++++++++++++++++++++++----------
 net/tls/tls_main.c       | 55 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 98 insertions(+), 13 deletions(-)

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
index 5f38be0ec0f3..ac39328eabe7 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -39,6 +39,7 @@
 /* TLS socket options */
 #define TLS_TX			1	/* Set transmit parameters */
 #define TLS_RX			2	/* Set receive parameters */
+#define TLS_TX_ZEROCOPY_SENDFILE	3	/* transmit zerocopy sendfile */
 
 /* Supported versions */
 #define TLS_VERSION_MINOR(ver)	((ver) & 0xFF)
@@ -160,6 +161,7 @@ enum {
 	TLS_INFO_CIPHER,
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
+	TLS_INFO_ZC_SENDFILE,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
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
index 7b2b0e7ffee4..b91ddc110786 100644
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
@@ -921,6 +969,12 @@ static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
 	if (err)
 		goto nla_failure;
 
+	if (ctx->tx_conf == TLS_HW && ctx->zerocopy_sendfile) {
+		err = nla_put_flag(skb, TLS_INFO_ZC_SENDFILE);
+		if (err)
+			goto nla_failure;
+	}
+
 	rcu_read_unlock();
 	nla_nest_end(skb, start);
 	return 0;
@@ -940,6 +994,7 @@ static size_t tls_get_info_size(const struct sock *sk)
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_CIPHER */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_RXCONF */
 		nla_total_size(sizeof(u16)) +	/* TLS_INFO_TXCONF */
+		nla_total_size(0) +		/* TLS_INFO_ZC_SENDFILE */
 		0;
 
 	return size;
-- 
2.25.1

