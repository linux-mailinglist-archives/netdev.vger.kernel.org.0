Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3AD2A6040
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 06:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfICEbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 00:31:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36072 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfICEbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 00:31:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id y19so15841291wrd.3
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 21:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z0oXXrEKtc8EdgwHFoYmCJHy0FilmLBjuJgt7feFnwY=;
        b=Qoxkv0EglU+czOYAWWfQvKINepnyjwwccD1dO8zGpuHkKvw/IyN665JRd46uFSsA9x
         Ib6ORt6BJYBMhRyZxa2Th1P7XHAGsHTyp+v9knkmOCZjKGuQP4KwrCsfQZaA3yLM5q/Q
         NEPw0v1b7UlyMwaIXzuKJJkR8nUBadh18rSmyFd8gOAgjFbcXpWaqTIAOknBfn1Ua+NX
         fAIqHE1qQPaFCVZzMkgiACopEm01SesXw3wv1g9CxaLn1NyRFV1OGYAv5m1A0t5h5Sap
         Jaj0hM8yu7tfcfVWF+J2WEWJKHJW6eMpbF13akiuPY/+sHQgQnTB/GCbx6X30yvQd3ql
         Rjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z0oXXrEKtc8EdgwHFoYmCJHy0FilmLBjuJgt7feFnwY=;
        b=jcw802LcNyVf41Toj2N+XxWidixmJ6t4jRCOg/xgnVAbgBvalFjZOGkVm+LYeOtpoI
         utkC7QdByD6OFJhFwwADJpgAxoy7gq6XgicprADqB+Id80+5TL+WsvfmolAaM6CeB3OX
         35ile121a/fIaTamPR2gUK5Sf6TJgiN49cT496vqWYu1SsGYGUvU4PsbJGnWwGk4xMp9
         l80Z7dZ4UxEPKJW4LrAEB+UG8P6sCAyKFDId1PV8n9/A68UHWhw3Oy9l1nM+iSh5Ql7+
         pusnRi8vLjjGX5hfSFDf4tmTWZgCiHt+IxJsM18BaSF1zAbEgIB1QJZXv/G4abZpg0I6
         ML/Q==
X-Gm-Message-State: APjAAAU1uf94JfrA2keMBBktJr/UW8N91y+NDyFwJdsfzjCYHIxaFMGQ
        mlQzzbsC6JLImvGqJg4dZy2/Dw==
X-Google-Smtp-Source: APXvYqyDJ7iUYlh4LCBPv1Nl2/SXGBRxAe1c8KvvWVsEtjm8/RI6e3M/4h1G8zOr3rg3zjW+P6FgtA==
X-Received: by 2002:adf:d187:: with SMTP id v7mr41910929wrc.33.1567485101797;
        Mon, 02 Sep 2019 21:31:41 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e13sm21024465wmh.44.2019.09.02.21.31.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 21:31:41 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 4/5] net/tls: clean up the number of #ifdefs for CONFIG_TLS_DEVICE
Date:   Mon,  2 Sep 2019 21:31:05 -0700
Message-Id: <20190903043106.27570-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS code has a number of #ifdefs which make the code a little
harder to follow. Recent fixes removed the ifdef around the
TLS_HW define, so we can switch to the often used pattern
of defining tls_device functions as empty static inlines
in the header when CONFIG_TLS_DEVICE=n.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h  | 38 ++++++++++++++++++++++++++++++++------
 net/tls/tls_main.c | 19 +------------------
 net/tls/tls_sw.c   |  6 ++----
 3 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 6dab6683e42f..c664e6dba0d1 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -366,13 +366,9 @@ ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
 			   struct pipe_inode_info *pipe,
 			   size_t len, unsigned int flags);
 
-int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
 int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
 int tls_device_sendpage(struct sock *sk, struct page *page,
 			int offset, size_t size, int flags);
-void tls_device_free_resources_tx(struct sock *sk);
-void tls_device_init(void);
-void tls_device_cleanup(void);
 int tls_tx_records(struct sock *sk, int flags);
 
 struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
@@ -649,7 +645,6 @@ int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
 		      unsigned char *record_type);
 void tls_register_device(struct tls_device *device);
 void tls_unregister_device(struct tls_device *device);
-int tls_device_decrypted(struct sock *sk, struct sk_buff *skb);
 int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 		struct scatterlist *sgout);
 struct sk_buff *tls_encrypt_skb(struct sk_buff *skb);
@@ -662,9 +657,40 @@ int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info);
 
+#ifdef CONFIG_TLS_DEVICE
+void tls_device_init(void);
+void tls_device_cleanup(void);
+int tls_set_device_offload(struct sock *sk, struct tls_context *ctx);
+void tls_device_free_resources_tx(struct sock *sk);
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
-
 void tls_device_offload_cleanup_rx(struct sock *sk);
 void tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq);
+int tls_device_decrypted(struct sock *sk, struct sk_buff *skb);
+#else
+static inline void tls_device_init(void) {}
+static inline void tls_device_cleanup(void) {}
 
+static inline int
+tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void tls_device_free_resources_tx(struct sock *sk) {}
+
+static inline int
+tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void tls_device_offload_cleanup_rx(struct sock *sk) {}
+static inline void
+tls_device_rx_resync_new_rec(struct sock *sk, u32 rcd_len, u32 seq) {}
+
+static inline int tls_device_decrypted(struct sock *sk, struct sk_buff *skb)
+{
+	return 0;
+}
+#endif
 #endif /* _TLS_OFFLOAD_H */
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 2df1ae8b77fa..ac88877dcade 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -286,19 +286,14 @@ static void tls_sk_proto_cleanup(struct sock *sk,
 		kfree(ctx->tx.rec_seq);
 		kfree(ctx->tx.iv);
 		tls_sw_release_resources_tx(sk);
-#ifdef CONFIG_TLS_DEVICE
 	} else if (ctx->tx_conf == TLS_HW) {
 		tls_device_free_resources_tx(sk);
-#endif
 	}
 
 	if (ctx->rx_conf == TLS_SW)
 		tls_sw_release_resources_rx(sk);
-
-#ifdef CONFIG_TLS_DEVICE
-	if (ctx->rx_conf == TLS_HW)
+	else if (ctx->rx_conf == TLS_HW)
 		tls_device_offload_cleanup_rx(sk);
-#endif
 }
 
 static void tls_sk_proto_close(struct sock *sk, long timeout)
@@ -537,26 +532,18 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 	}
 
 	if (tx) {
-#ifdef CONFIG_TLS_DEVICE
 		rc = tls_set_device_offload(sk, ctx);
 		conf = TLS_HW;
 		if (rc) {
-#else
-		{
-#endif
 			rc = tls_set_sw_offload(sk, ctx, 1);
 			if (rc)
 				goto err_crypto_info;
 			conf = TLS_SW;
 		}
 	} else {
-#ifdef CONFIG_TLS_DEVICE
 		rc = tls_set_device_offload_rx(sk, ctx);
 		conf = TLS_HW;
 		if (rc) {
-#else
-		{
-#endif
 			rc = tls_set_sw_offload(sk, ctx, 0);
 			if (rc)
 				goto err_crypto_info;
@@ -920,9 +907,7 @@ static int __init tls_register(void)
 	tls_sw_proto_ops = inet_stream_ops;
 	tls_sw_proto_ops.splice_read = tls_sw_splice_read;
 
-#ifdef CONFIG_TLS_DEVICE
 	tls_device_init();
-#endif
 	tcp_register_ulp(&tcp_tls_ulp_ops);
 
 	return 0;
@@ -931,9 +916,7 @@ static int __init tls_register(void)
 static void __exit tls_unregister(void)
 {
 	tcp_unregister_ulp(&tcp_tls_ulp_ops);
-#ifdef CONFIG_TLS_DEVICE
 	tls_device_cleanup();
-#endif
 }
 
 module_init(tls_register);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 91d21b048a9b..c2b5e0d2ba1a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1489,13 +1489,12 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	int pad, err = 0;
 
 	if (!ctx->decrypted) {
-#ifdef CONFIG_TLS_DEVICE
 		if (tls_ctx->rx_conf == TLS_HW) {
 			err = tls_device_decrypted(sk, skb);
 			if (err < 0)
 				return err;
 		}
-#endif
+
 		/* Still not decrypted after tls_device */
 		if (!ctx->decrypted) {
 			err = decrypt_internal(sk, skb, dest, NULL, chunk, zc,
@@ -2014,10 +2013,9 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 		ret = -EINVAL;
 		goto read_failure;
 	}
-#ifdef CONFIG_TLS_DEVICE
+
 	tls_device_rx_resync_new_rec(strp->sk, data_len + TLS_HEADER_SIZE,
 				     TCP_SKB_CB(skb)->seq + rxm->offset);
-#endif
 	return data_len + TLS_HEADER_SIZE;
 
 read_failure:
-- 
2.21.0

