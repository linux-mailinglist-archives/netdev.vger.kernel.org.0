Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461542486EC
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgHROPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 10:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgHROMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 10:12:51 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22985C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 07:12:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id k18so10017916pfp.7
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 07:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0iCeYrx8o1t/2yAgAIsRKZLwyaHgROAVi4jMRtLf/A=;
        b=o1ZsWfOZCzDWqikyXBImLpLjpd95KhDkutvRs5ERQrc4lqqTBs+Mwwtsgi2Bub1vaf
         WhStPGqhYOA5NVnRGMKOueLetXFcisjnH91quWWgSkVFiF/zw2o2mFfNVCOSzQ5wcFRh
         6GNmIJEvGToSnGCHyfjNmPtjfq/gojK7MJDz5WfY3tmr9nIAb48Yns7Vv7vrzraWDo/S
         uYL4b6fUhFdiD7hKs4emmvJ8ZQNm0BJlBnuXqrw5DU+ML2bDcMzFOwxcWjzC4VUW2J8A
         7N+j+Ul8RU/lo/QeyBRf+JN//Rz0IrlpB2eiL96zlEM1McDwKbmBUp29uLmK/4pgGAeL
         hcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N0iCeYrx8o1t/2yAgAIsRKZLwyaHgROAVi4jMRtLf/A=;
        b=OIqjFkwgbD5s5eJbnaHnIXSHQWxm/bvHT/EGEEtknQstSHHUIbpimJh/DegLbbvHjt
         QCNMTSUcPD1yHN+4N9lpMigyQ6OZ4ThFGpOmr4BuhPahcCJ1hhkpxHZ0cpwR+jYJAtmd
         nbrp+8ATyCccVuCyqP8ULCx6i+IXtJsUONY0d4w9qcf1Wx0gs81qQtLX0Kpx6xdk2B4O
         XHpFbGliQs0lgzBhpSO4I7mH0mTUu92tE7kje7SuMTit8h8p/+mevBpXcz5eLuCpsoOT
         zFN8sTC0k7ADIQHTpa/I5D0kmpgfoCOAilhzxMXRVyPZrj78itNl7E1Vu8o/czS4usur
         tqdQ==
X-Gm-Message-State: AOAM533D2wptGy6D0zcH7qza/n0WcI3UyC4by7qgzJH0ZokSSwrISmyr
        YmKdBkrLFwxk6jbEISYrgYw3mZnZqKhatQ==
X-Google-Smtp-Source: ABdhPJzT6pWsg+nmZY4mb7xG/bF4DY9mg3H4k0L9+mZaUR0SvMZjX8m1b5k+Z/STLPk0ooze8I7JYw==
X-Received: by 2002:a63:4b5e:: with SMTP id k30mr13327699pgl.205.1597759966346;
        Tue, 18 Aug 2020 07:12:46 -0700 (PDT)
Received: from localhost.jp (fp9f1cad42.knge118.ap.nuro.jp. [159.28.173.66])
        by smtp.gmail.com with ESMTPSA id l12sm110632pjq.31.2020.08.18.07.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 07:12:45 -0700 (PDT)
From:   Yutaro Hayakawa <yhayakawa3720@gmail.com>
To:     netdev@vger.kernel.org
Cc:     michio.honda@ed.ac.uk, Yutaro Hayakawa <yhayakawa3720@gmail.com>
Subject: [PATCH RFC net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
Date:   Tue, 18 Aug 2020 14:12:24 +0000
Message-Id: <20200818141224.5113-1-yhayakawa3720@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the getsockopt SOL_TLS TLS_RX which is currently missing. The
primary usecase is to use it in conjunction with TCP_REPAIR to
checkpoint/restore the TLS record layer state.

TLS connection state usually exists on the user space library. So
basically we can easily extract it from there, but when the TLS
connections are delegated to the kTLS, it is not the case. We need to
have a way to extract the TLS state from the kernel for both of TX and
RX side.

The new TLS_RX getsockopt copies the crypto_info to user in the same
way as TLS_TX does.

We have described use cases in our research work in Netdev 0x14
Transport Workshop [1].

Also, there is an TLS implementation called tlse [2] which supports
TLS connection migration. They have support of kTLS and their code
shows that they are expecting the future support of this option.

[1] https://speakerdeck.com/yutarohayakawa/prism-proxies-without-the-pain
[2] https://github.com/eduardsui/tlse

Signed-off-by: Yutaro Hayakawa <yhayakawa3720@gmail.com>
---
 net/tls/tls_main.c | 50 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bbc52b088d29..ea66cac2cd84 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -330,8 +330,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		tls_ctx_free(sk, ctx);
 }
 
-static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
-				int __user *optlen)
+static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
+				  int __user *optlen, int tx)
 {
 	int rc = 0;
 	struct tls_context *ctx = tls_get_ctx(sk);
@@ -352,7 +352,11 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 	}
 
 	/* get user crypto info */
-	crypto_info = &ctx->crypto_send.info;
+	if (tx) {
+		crypto_info = &ctx->crypto_send.info;
+	} else {
+		crypto_info = &ctx->crypto_recv.info;
+	}
 
 	if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
 		rc = -EBUSY;
@@ -378,11 +382,19 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			goto out;
 		}
 		lock_sock(sk);
-		memcpy(crypto_info_aes_gcm_128->iv,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
-		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
-		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
-		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+		if (tx) {
+			memcpy(crypto_info_aes_gcm_128->iv,
+			       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+			       TLS_CIPHER_AES_GCM_128_IV_SIZE);
+			memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
+			       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+		} else {
+			memcpy(crypto_info_aes_gcm_128->iv,
+			       ctx->rx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+			       TLS_CIPHER_AES_GCM_128_IV_SIZE);
+			memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->rx.rec_seq,
+			       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
+		}
 		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
@@ -402,11 +414,19 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 			goto out;
 		}
 		lock_sock(sk);
-		memcpy(crypto_info_aes_gcm_256->iv,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
-		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
-		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
-		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
+		if (tx) {
+			memcpy(crypto_info_aes_gcm_256->iv,
+			       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
+			       TLS_CIPHER_AES_GCM_256_IV_SIZE);
+			memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
+			       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
+		} else {
+			memcpy(crypto_info_aes_gcm_256->iv,
+			       ctx->rx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
+			       TLS_CIPHER_AES_GCM_256_IV_SIZE);
+			memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->rx.rec_seq,
+			       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
+		}
 		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
@@ -429,7 +449,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 
 	switch (optname) {
 	case TLS_TX:
-		rc = do_tls_getsockopt_tx(sk, optval, optlen);
+	case TLS_RX:
+		rc = do_tls_getsockopt_conf(sk, optval, optlen,
+					    optname == TLS_TX);
 		break;
 	default:
 		rc = -ENOPROTOOPT;
-- 
2.26.2

