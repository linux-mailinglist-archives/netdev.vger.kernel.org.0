Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D1229D7EF
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733038AbgJ1W2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387422AbgJ1W2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:28:10 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73ACFC0613CF;
        Wed, 28 Oct 2020 15:28:10 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f38so700562pgm.2;
        Wed, 28 Oct 2020 15:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p+7zqDEUsInVWiiKbv2mU/avNMxBK0HvJzz4eBBZxRg=;
        b=OgykjbeBYTcwSjAJLswfBmSpu1YsZF27KG6D/MRCQVqUmHCuYYMJytcrH+RQXviJFv
         OFpc2lZtT/zrN9NPlVxVbV/cKdTUEdxu4p0k2/w7cHLBOU2jd3TtFC2kWLi0pdWeAgB8
         nOAUZXdFSQa+qnNaSJvy918NPqfJKi7c39qDSfg0hzSTcU5cMRHqvEKqihRR8WH1dMqs
         tFg4hqxvUSCWie8BCN6/OTuxV9FhjoGrm8UboeP5HMBKHqNsGRQnOTpzhtpzWs2fRCDT
         FuO65G8Meu2jt9aKFfT4cdZsji/kNeB6X5seMYVfWtcnZN2eKTC0/4qcDOUZ0766e7A+
         iGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p+7zqDEUsInVWiiKbv2mU/avNMxBK0HvJzz4eBBZxRg=;
        b=gwzLz8s7/wgt1nlMKW6ayOGadLF+VJfMuHxHKoslrSHVXcciKVTyiL3lSKr8uSxnN1
         jESTQaa10AvGM3lDMPHc4uIkt2SepeH66kyy77BwDbeHHSGDMbI6pJEv4FZw/XrfP5wc
         rKxoNFDGy+rI79Ne4ILYqCl849TXuMeKAFQAFzYYo+1bJ5FVEbNwtB7CEOYop+Sxs1AS
         MTSq8csjYSMqkZmtG3E5HQNDuxKG4wu6UnhwX8nzD3ywfNW18awyUQRdOI4dW9Y94Z59
         vG9KRotIo8H9oFfUelzGBw1eqevD0ztphxCVoEmRkWYpFwLDFIUS91rfNYuNfbW44486
         MpgQ==
X-Gm-Message-State: AOAM533XvqMVP0+3mXu2lnwWMezbYLPDZc2DZABBCoO4ng7lfUmyYcl5
        vDczOeKqA9rIqcg/fG7Y2hkAw4TbBBJpzlLo
X-Google-Smtp-Source: ABdhPJyg91YP5G0ly1+wJndgmQ+pQQEXBSh2NKhveMXIaGJ3NqHZZSc+XmBwH86rU6ST9iPb0aIa7w==
X-Received: by 2002:aa7:954b:0:b029:154:8ee9:e4d with SMTP id w11-20020aa7954b0000b02901548ee90e4dmr7751812pfq.11.1603892121903;
        Wed, 28 Oct 2020 06:35:21 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:21 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 3/9] xsk: add support for recvmsg()
Date:   Wed, 28 Oct 2020 14:34:31 +0100
Message-Id: <20201028133437.212503-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add support for non-blocking recvmsg() to XDP sockets. Previously,
only sendmsg() was supported by XDP socket. Now, for symmetry and the
upcoming busy-polling support, recvmsg() is added.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b71a32eeae65..17d51d1a5752 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -474,6 +474,26 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return __xsk_sendmsg(sk);
 }
 
+static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+{
+	bool need_wait = !(flags & MSG_DONTWAIT);
+	struct sock *sk = sock->sk;
+	struct xdp_sock *xs = xdp_sk(sk);
+
+	if (unlikely(!(xs->dev->flags & IFF_UP)))
+		return -ENETDOWN;
+	if (unlikely(!xs->rx))
+		return -ENOBUFS;
+	if (unlikely(!xsk_is_bound(xs)))
+		return -ENXIO;
+	if (unlikely(need_wait))
+		return -EOPNOTSUPP;
+
+	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
+		return xsk_wakeup(xs, XDP_WAKEUP_RX);
+	return 0;
+}
+
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
@@ -1134,7 +1154,7 @@ static const struct proto_ops xsk_proto_ops = {
 	.setsockopt	= xsk_setsockopt,
 	.getsockopt	= xsk_getsockopt,
 	.sendmsg	= xsk_sendmsg,
-	.recvmsg	= sock_no_recvmsg,
+	.recvmsg	= xsk_recvmsg,
 	.mmap		= xsk_mmap,
 	.sendpage	= sock_no_sendpage,
 };
-- 
2.27.0

