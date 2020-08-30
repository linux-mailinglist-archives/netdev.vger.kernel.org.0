Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B2256FF6
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 21:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgH3THh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgH3THf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 15:07:35 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8B1C061573
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 12:07:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id z15so1987457plo.7
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 12:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ReY8rbmHGavaf04+//aDgHpUIFi1gK0MqCo38fiWAsw=;
        b=cBMKxO2j3nhBmZGnXeZiRS7Y0CQJy5jnevt77aA3eeBV+MGG+RI1zcGOCoPAX0HCZc
         djbGZ2XXXostmQeV3ZeMsGXiEiOKPl8FVUCPxJxCQ8NywEcW0EBAAllss8Kp6W6w/9+H
         U/+W/M5sQQ/Jlrqvw4VFJtKZ22w+ILBryoTlZmHrUGkAA8yBpN5wHsOj5JZNyQCp4tL7
         5FdQ11CiSUa9tPQMsUBfd+ruGJTNOJZo2SnHsyoSfZUGMtjUvS+CluhX8BXMU00Ju9TB
         cbc+5v/zBxdQGsrb4IlilhojcjyrQgtbGoX2EA2bNaO3wlNngizO9fuGJRvAP1w4HGGc
         b++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ReY8rbmHGavaf04+//aDgHpUIFi1gK0MqCo38fiWAsw=;
        b=W4vrDhKDZ6HqoRg6PV4sSxRvlnrD0hBNkxXBcIqY/jxx3Y35hJfI5EgmjTEmyO6Rd8
         +fEB8bvaXqb/tu20Ggh3j11rW/p9ubiZTSQ5Yq+lw0QB55Qa1FStaxYcn2HxiO8Y80qB
         0UFB6pYGMweP9Ph8ea8BJY3D0zdJlWOEposv511wQHOBc94+oR5DjwhOBwpGMfkGtbWP
         CmLLJ6K0XaKXfxQlf7tfONElJM1MZkKPdE1Ly1hc02gSI9rr2JBOUlY92HYrHUjSdnXW
         gsthd1ijMNuLJqMgdeRGcfW8ASaOwxvFx3n8sDRXwVacq7nsyIf7wi9d9s7ugB6wpBvj
         9bgg==
X-Gm-Message-State: AOAM5336kwFT5NjrneoH8y6K2O3mjcnfaZkOtnEMsPu4ei4DQsAHrOW6
        atgZfDGJZOQjmDQqHPCZCJc=
X-Google-Smtp-Source: ABdhPJzlqvTcWYibYh3QbpDV1lJNP58FkhqHJWIzaZHSzyQx9Ey54Jra3oMXe4UXwsIfgiGhcRugVQ==
X-Received: by 2002:a17:90a:d18d:: with SMTP id fu13mr7712600pjb.137.1598814454362;
        Sun, 30 Aug 2020 12:07:34 -0700 (PDT)
Received: from localhost.localdomain (fp9f1cad42.knge118.ap.nuro.jp. [159.28.173.66])
        by smtp.gmail.com with ESMTPSA id c4sm5469536pfo.163.2020.08.30.12.07.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Aug 2020 12:07:33 -0700 (PDT)
From:   Yutaro Hayakawa <yhayakawa3720@gmail.com>
X-Google-Original-From: Yutaro Hayakawa <yutaro.hayakawa@linecorp.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, michio.honda@ed.ac.uk,
        Yutaro Hayakawa <yhayakawa3720@gmail.com>
Subject: [PATCH RFC v3 net-next] net/tls: Implement getsockopt SOL_TLS TLS_RX
Date:   Mon, 31 Aug 2020 04:07:13 +0900
Message-Id: <20200830190713.69832-1-yutaro.hayakawa@linecorp.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <CABTgxWF5vtQu4H6-_54QdMcM2mJW3h8Co254+Qb4q88k0He1dA@mail.gmail.com>
References: <CABTgxWF5vtQu4H6-_54QdMcM2mJW3h8Co254+Qb4q88k0He1dA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yutaro Hayakawa <yhayakawa3720@gmail.com>

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
Changes in v3:
- Fix compilation error

 net/tls/tls_main.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bbc52b0..002b085 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -330,12 +330,13 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		tls_ctx_free(sk, ctx);
 }

-static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
-				int __user *optlen)
+static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
+				  int __user *optlen, int tx)
 {
 	int rc = 0;
 	struct tls_context *ctx = tls_get_ctx(sk);
 	struct tls_crypto_info *crypto_info;
+	struct cipher_context *cctx;
 	int len;

 	if (get_user(len, optlen))
@@ -352,7 +353,13 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 	}

 	/* get user crypto info */
-	crypto_info = &ctx->crypto_send.info;
+	if (tx) {
+		crypto_info = &ctx->crypto_send.info;
+		cctx = &ctx->tx;
+	} else {
+		crypto_info = &ctx->crypto_recv.info;
+		cctx = &ctx->rx;
+	}

 	if (!TLS_CRYPTO_INFO_READY(crypto_info)) {
 		rc = -EBUSY;
@@ -379,9 +386,9 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 		}
 		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
+		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
-		memcpy(crypto_info_aes_gcm_128->rec_seq, ctx->tx.rec_seq,
+		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
 		release_sock(sk);
 		if (copy_to_user(optval,
@@ -403,9 +410,9 @@ static int do_tls_getsockopt_tx(struct sock *sk, char __user *optval,
 		}
 		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
-		       ctx->tx.iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
+		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
-		memcpy(crypto_info_aes_gcm_256->rec_seq, ctx->tx.rec_seq,
+		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
 		release_sock(sk);
 		if (copy_to_user(optval,
@@ -429,7 +436,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,

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
1.8.3.1
