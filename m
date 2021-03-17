Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6E233E6B7
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhCQCWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCQCWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:22:48 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919EEC06175F;
        Tue, 16 Mar 2021 19:22:48 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id o19-20020a9d22130000b02901bfa5b79e18so413695ota.0;
        Tue, 16 Mar 2021 19:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vwBCDi/Trp5W1pFSVwRRUUYgEK05t0TKOcvxMF4nzg=;
        b=UHZw//bS/uitbIV6oS1GMVKj90rUhNJ1Ivt8WI/9Vv/ZVZ7b2m7VCRgWl7+EhGzxaw
         r4yA4E7lpbGgOh5H5IQmbyztJ7icTzTbehc3FqMU2jfwricCHM/V5YSLuvf3yqcberzc
         WX5ARnAyc2mekelR6nmgvW8FjdCR9HmueQGVn8yi5gYkOHJcQBH8H+MtIzuNXaMgICSA
         KcoP1IHczwbdYRomde5kJr/BYvmZCEySH1eG5HW1TLUQd2p1g77A6LZpHPGZju7v46vw
         uNxrwfiNW6GYXwZ3Nd3lJcKl28R4RMnyxOzBSC4YJIPLbBVjgZwl+Zb1Ot3Lx4bLixpR
         gu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vwBCDi/Trp5W1pFSVwRRUUYgEK05t0TKOcvxMF4nzg=;
        b=SwXsk7VpsxdNlR7C4V3uFI4vprqiGUWz7Coybp/d8dv3UzSM+Ppt5ffBBmJLUuKMU9
         6WfjGEXEurhTCli7kaPR7eL36I0BcQt6Y9rR3vxfVOn/IaZlC1+Nrfoc+oPi1YJT8jGc
         /UuQ8RmYKCVziwEPOmHdoWPod86MK0fOOs3ZQZb0yj0JK4a3duL8sBUqnvMn4/I1Wv2u
         9JBOY7YYZ9nXlMCLgea+iY/bshTVCI3cfwsnE9IT+PVEkTfB8jQVtTNgVP7HbpfZY4cg
         Qxa8RbdvwwRWf4Tp9mYQY3UE3jOaR1DaGTQdkCg9K4N9JAU5NsDSTdhB5lg/KmWBj2JS
         FhwQ==
X-Gm-Message-State: AOAM530+CNvFJElD3ix7+WSK/VsqlLcA9QSJdyzlhtH1Yvuk4O8Pccw4
        vXCKv28FmdZwbyPhxGfQ2HF5q81TNRgF/A==
X-Google-Smtp-Source: ABdhPJzJq5iVVA9cJV8qxZSIsHKYMZiP6Cxzi0a2ANcAihHHjGBWbmjQ96dWFOVmu+nr3jGe7F6c+w==
X-Received: by 2002:a9d:ac6:: with SMTP id 64mr1424151otq.337.1615947767854;
        Tue, 16 Mar 2021 19:22:47 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:47 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf-next v5 03/11] skmsg: introduce skb_send_sock() for sock_map
Date:   Tue, 16 Mar 2021 19:22:11 -0700
Message-Id: <20210317022219.24934-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We only have skb_send_sock_locked() which requires callers
to use lock_sock(). Introduce a variant skb_send_sock()
which locks on its own, callers do not need to lock it
any more. This will save us from adding a ->sendmsg_locked
for each protocol.

To reuse the code, pass function pointers to __skb_send_sock()
and build skb_send_sock() and skb_send_sock_locked() on top.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/linux/skbuff.h |  1 +
 net/core/skbuff.c      | 55 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0503c917d773..2fc8c3657c53 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3626,6 +3626,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		    unsigned int flags);
 int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 			 int len);
+int skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset, int len);
 void skb_copy_and_csum_dev(const struct sk_buff *skb, u8 *to);
 unsigned int skb_zerocopy_headlen(const struct sk_buff *from);
 int skb_zerocopy(struct sk_buff *to, struct sk_buff *from,
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c421c8f80925..14010c0eec48 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2500,9 +2500,32 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(skb_splice_bits);
 
-/* Send skb data on a socket. Socket must be locked. */
-int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
-			 int len)
+static int sendmsg_unlocked(struct sock *sk, struct msghdr *msg,
+			    struct kvec *vec, size_t num, size_t size)
+{
+	struct socket *sock = sk->sk_socket;
+
+	if (!sock)
+		return -EINVAL;
+	return kernel_sendmsg(sock, msg, vec, num, size);
+}
+
+static int sendpage_unlocked(struct sock *sk, struct page *page, int offset,
+			     size_t size, int flags)
+{
+	struct socket *sock = sk->sk_socket;
+
+	if (!sock)
+		return -EINVAL;
+	return kernel_sendpage(sock, page, offset, size, flags);
+}
+
+typedef int (*sendmsg_func)(struct sock *sk, struct msghdr *msg,
+			    struct kvec *vec, size_t num, size_t size);
+typedef int (*sendpage_func)(struct sock *sk, struct page *page, int offset,
+			     size_t size, int flags);
+static int __skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset,
+			   int len, sendmsg_func sendmsg, sendpage_func sendpage)
 {
 	unsigned int orig_len = len;
 	struct sk_buff *head = skb;
@@ -2522,7 +2545,8 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		memset(&msg, 0, sizeof(msg));
 		msg.msg_flags = MSG_DONTWAIT;
 
-		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
+		ret = INDIRECT_CALL_2(sendmsg, kernel_sendmsg_locked,
+				      sendmsg_unlocked, sk, &msg, &kv, 1, slen);
 		if (ret <= 0)
 			goto error;
 
@@ -2553,9 +2577,11 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		slen = min_t(size_t, len, skb_frag_size(frag) - offset);
 
 		while (slen) {
-			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
-						     skb_frag_off(frag) + offset,
-						     slen, MSG_DONTWAIT);
+			ret = INDIRECT_CALL_2(sendpage, kernel_sendpage_locked,
+					      sendpage_unlocked, sk,
+					      skb_frag_page(frag),
+					      skb_frag_off(frag) + offset,
+					      slen, MSG_DONTWAIT);
 			if (ret <= 0)
 				goto error;
 
@@ -2587,8 +2613,23 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 error:
 	return orig_len == len ? ret : orig_len - len;
 }
+
+/* Send skb data on a socket. Socket must be locked. */
+int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
+			 int len)
+{
+	return __skb_send_sock(sk, skb, offset, len, kernel_sendmsg_locked,
+			       kernel_sendpage_locked);
+}
 EXPORT_SYMBOL_GPL(skb_send_sock_locked);
 
+/* Send skb data on a socket. Socket must be unlocked. */
+int skb_send_sock(struct sock *sk, struct sk_buff *skb, int offset, int len)
+{
+	return __skb_send_sock(sk, skb, offset, len, sendmsg_unlocked,
+			       sendpage_unlocked);
+}
+
 /**
  *	skb_store_bits - store bits from kernel buffer to skb
  *	@skb: destination buffer
-- 
2.25.1

