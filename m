Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2182A7BBE
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgKEK2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKEK2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:28:52 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108F1C0613CF;
        Thu,  5 Nov 2020 02:28:52 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id z3so1140370pfz.6;
        Thu, 05 Nov 2020 02:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p+7zqDEUsInVWiiKbv2mU/avNMxBK0HvJzz4eBBZxRg=;
        b=cSCF6EWwqlV4sr+11UpBhltnSGG1MbOtp32F1+d9G8EEeefns+C98yXxtsVPkONGj4
         9GsGDfx/AhdHpLaKaYNajCOda1gVXfwaOLgbo267pQkCBxf8qYBx89zWQOb//YCOwGPq
         xga0LHe54AHI2pr8S4tU9obFRHzZknTTGb40WrcjAXZUaOJfZgQOrJtYCUlbqKLDlPlv
         86dMjgKTtgDWq6szK6/IKHqFpwJr874jMwQN3nzYKK2eYgwjlKLnWSKOkjVsRASTzw1b
         7Cv0ugS5f6GPraoPVV9eL1uKg+gHYRJC9Kb2Wzu0AlwstboCah6SaXcFBEUcOOfEg2/h
         hB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p+7zqDEUsInVWiiKbv2mU/avNMxBK0HvJzz4eBBZxRg=;
        b=DaaTt+S2vDmFUk1Ev8pxjEK1yZoZbQ9PkVcqQJpkhJgXBgXqANEzW9DplZI1DC+Mp6
         sNSUSlJyMKkY1pG2WEGoNNOUd5lDvStOVSNEbPQ63x1OL0A9C4+iSZyNSbb5B8Ina0jh
         wyuz1ztF1EWA14X2sblHWdBeBmJogKdIfMJ2GdCxqHzzgFWTmL4drkswNw3VU7rMDSXt
         gbUWZDL6lfQ6RKg5redI+oM6EdtfK7AXmNeOW9+rYzKh7uOTlzNLCZdaCFi+Tlxzh3Gf
         Jp2qT3pmVzCdNmxG5UncrxDlU78/oh0sqTmTJ7DNupAOQZauzFkr+BdSczR+mQF6fhUi
         lGdQ==
X-Gm-Message-State: AOAM533ivU+Fc13S0WyKEkEaB644Cgw7Z+cpvnN8YnhJrVWWFTB7gN6K
        QNXxkcZpdsyPZSVYWnnCmE/exso5eA0vHwir
X-Google-Smtp-Source: ABdhPJyp2lylD1cOovj07EBLr19iwlvRQnx2AFY5SusVU4BghQXm44b6z4xqmyV+U1NImZZnvdtHew==
X-Received: by 2002:a17:90a:6284:: with SMTP id d4mr1807253pjj.92.1604572131049;
        Thu, 05 Nov 2020 02:28:51 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 192sm2050117pfz.200.2020.11.05.02.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:28:49 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next v2 3/9] xsk: add support for recvmsg()
Date:   Thu,  5 Nov 2020 11:28:06 +0100
Message-Id: <20201105102812.152836-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201105102812.152836-1-bjorn.topel@gmail.com>
References: <20201105102812.152836-1-bjorn.topel@gmail.com>
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

