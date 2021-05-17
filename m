Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84253822B3
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbhEQCZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 22:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhEQCZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 22:25:11 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69510C061573;
        Sun, 16 May 2021 19:23:56 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id v4so3906216qtp.1;
        Sun, 16 May 2021 19:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bEsPwwNFf32UFdaDZbxPaslRUti+w4Of7ShpBcFVMxQ=;
        b=icqNTmpCYke5Nt06vWg3XWpHcmRPt2t56Fww1vFSxPN+bjleVaZ6n6VSqwEEimoBPB
         h9kVaswXs1SYIRIWs0y5gOtEvIHfNwLb1gOah53nL+ZdyY5UHFjMsdnCcm7wTln3fRf+
         r+FRRr88FqJTDTl15bwZcJHOlCDYGb4Skb1hQsxL8Reo5wCiaya+fdaekvuHR5sggM8o
         QcklZTpaGnVMgLkIFATYRBBgf/1SPS6dHF0gwMbYRszwnPv+LKnQFjIdV5S6vdeBaCpH
         9zCfk0vMWuBxRWPAQr2iBGHYA6xWBKWO/xXWnfdiDjYl7bUQT9r6Qr0FPKM26nq0Ymfy
         sG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bEsPwwNFf32UFdaDZbxPaslRUti+w4Of7ShpBcFVMxQ=;
        b=li5rtzM2SOq86N4ldGkjZGIH8sIG639YTcQAn4WQ7WjDLqWMj+s3U+Ih/q/3vM4xT9
         krWDTl5E/MRRydj3xwnefdHZZgxZbQsQ4yllXZhMkriE4uYnO45GDO5m9zVsXLwu9KR3
         oiagK6fJyALkYtTTgePzfH8wd33GW14dQvTMk8geYfqNebyhuESFBEtscZqfF36QFLJc
         mJi0yzWMfhBnRUl2M430uG6Ti3zSTJk1+UuLjQ/qh7RUf+7h4jHrpWug2mIfTwWfbpXZ
         ErP/+vwcYsSddNzm1eTXuHCgR7fyueDc3qVQdLROjKuyRHEfnFV7RBToTbrHH5hK/dun
         9UiA==
X-Gm-Message-State: AOAM5303gWLYtmWyqR8+4fjHy9KPe115z0IFknmK8j2m43ORSBGZ62wD
        OtWFr7RM5LPZambuyH7+JXqEsY/o698Qlg==
X-Google-Smtp-Source: ABdhPJxRw3FXPCSRVoZ2YHmOnpTjR94MmvjEWSeIIwtiikuOu0eLAS7vlE7RxLQzbIxUMIZKYx/F/Q==
X-Received: by 2002:ac8:7f13:: with SMTP id f19mr27843478qtk.202.1621218235494;
        Sun, 16 May 2021 19:23:55 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a15a:608b:20ec:867f])
        by smtp.gmail.com with ESMTPSA id e128sm9495771qkd.127.2021.05.16.19.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 19:23:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf] skmsg: remove unused parameters of sk_msg_wait_data()
Date:   Sun, 16 May 2021 19:23:48 -0700
Message-Id: <20210517022348.50555-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

'err' and 'flags' are not used, we can just get rid of them.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skmsg.h | 3 +--
 net/core/skmsg.c      | 3 +--
 net/ipv4/tcp_bpf.c    | 9 ++-------
 net/ipv4/udp_bpf.c    | 8 ++------
 4 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index aba0f0f429be..fcaa9a7996c8 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -126,8 +126,7 @@ int sk_msg_zerocopy_from_iter(struct sock *sk, struct iov_iter *from,
 			      struct sk_msg *msg, u32 bytes);
 int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 			     struct sk_msg *msg, u32 bytes);
-int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
-		     long timeo, int *err);
+int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo);
 int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		   int len, int flags);
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 43ce17a6a585..f0b9decdf279 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -399,8 +399,7 @@ int sk_msg_memcopy_from_iter(struct sock *sk, struct iov_iter *from,
 }
 EXPORT_SYMBOL_GPL(sk_msg_memcopy_from_iter);
 
-int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, int flags,
-		     long timeo, int *err)
+int sk_msg_wait_data(struct sock *sk, struct sk_psock *psock, long timeo)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int ret = 0;
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ad9d17923fc5..a80de92ea3b6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -184,11 +184,11 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
-		int data, err = 0;
 		long timeo;
+		int data;
 
 		timeo = sock_rcvtimeo(sk, nonblock);
-		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		data = sk_msg_wait_data(sk, psock, timeo);
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
@@ -196,14 +196,9 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			sk_psock_put(sk, psock);
 			return tcp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 		}
-		if (err) {
-			ret = err;
-			goto out;
-		}
 		copied = -EAGAIN;
 	}
 	ret = copied;
-out:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return ret;
diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 954c4591a6fd..b07e4b6dda25 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -43,21 +43,17 @@ static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
 	if (!copied) {
-		int data, err = 0;
 		long timeo;
+		int data;
 
 		timeo = sock_rcvtimeo(sk, nonblock);
-		data = sk_msg_wait_data(sk, psock, flags, timeo, &err);
+		data = sk_msg_wait_data(sk, psock, timeo);
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
 			ret = sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
 			goto out;
 		}
-		if (err) {
-			ret = err;
-			goto out;
-		}
 		copied = -EAGAIN;
 	}
 	ret = copied;
-- 
2.25.1

