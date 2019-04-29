Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C57B0ED28
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfD2XE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:04:58 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:38612 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729684AbfD2XE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 19:04:56 -0400
Received: by mail-it1-f193.google.com with SMTP id q19so1782325itk.3
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 16:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jwKsDaXGjYO7Q1qUenHH00w7DqPliGu7mDra++7KLns=;
        b=YJ5KnG1g68b961zyjHvdbGXH4DMOVWXTgOM3xUBxjSv+Hp5uEpnAKXsfAA1q55QoHN
         EIiBxKhJaReSMVsrBBpVLjtLmOhU8gmZyK8ucT69AWv94gfzLZN3D2Fe24fbXiKnoLaB
         GoNDeoJiUtoCThIa2ru/X61GiXKBpGBh1NYaRtlCOeibPrKwpd/I9+ytQIeCEOHkM8ef
         +Vq6V0rP/pt2jGLutjYF/DfjSu60995G2iaGisr0rPlakga4zS60iXq20li4RAGHlePZ
         HgFxLOQw4Fwq6ETkm0h+xJ1WeNyRtBBOtxNSAvwl2kxbc6/Ych+ixMbnfh1y8wqy7B+Q
         easA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jwKsDaXGjYO7Q1qUenHH00w7DqPliGu7mDra++7KLns=;
        b=WOADJdjd6vVeTGmzMacnkGgGh+exyBgvKF4A/BUUu4rJcMETFSgDyu++6SnY2/qs7s
         /7hjkKQcK2pQtF3sFrfKlUDEycBFsHxmyXpk3ReZB6mszOMT6lSVcIFf2QP1b1MwN/nV
         cchTUYZerCSAmSGaNRBU6dOXh5npLweCqqg1fd4SVlLz5t+TD59ah4ljAEAzy4v9dldX
         2qPTR2L/8kMCb3f/nCaJQTngHgbGG3KdQQkc2nlvftPBMbO7g3eItGYapHoQ5A9QXtxw
         +aCF/ujavkPncKIeTfmxXy1w34+mfNfQ2ZLYrow2GjfQvRBEEPqEDtd6y4dKdzeRnBjd
         ylWw==
X-Gm-Message-State: APjAAAVbyGOAUpmKi1SYf8R8oh3WForTp7XK9zLz0QJUJWwHB7N0Yn9w
        3z1A1HINHirNnW6ozJM03YA0gw==
X-Google-Smtp-Source: APXvYqw93l6xhUc2Vaksul9ZKq9zzkjHW8UpCEze6irxyszwGaF3kvdjwu/HtPpdPxzd4QMBOsALow==
X-Received: by 2002:a24:b349:: with SMTP id z9mr1419342iti.77.1556579096049;
        Mon, 29 Apr 2019 16:04:56 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id y62sm340626itg.13.2019.04.29.16.04.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 16:04:55 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v8 net-next 6/8] ipv6tlvs: opt_update function
Date:   Mon, 29 Apr 2019 16:04:21 -0700
Message-Id: <1556579063-1367-7-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556579063-1367-1-git-send-email-tom@quantonium.net>
References: <1556579063-1367-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a utility function to replace socket's options with a new set.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h       |  2 ++
 net/ipv6/ipv6_sockglue.c | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 8c19c6f..a8c1e6c 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -379,6 +379,8 @@ struct ipv6_txoptions *ipv6_renew_options(struct sock *sk,
 					  struct ipv6_opt_hdr *newopt);
 struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
 					  struct ipv6_txoptions *opt);
+int ipv6_opt_update(struct sock *sk, struct ipv6_txoptions *opt,
+		    int which, struct ipv6_opt_hdr *new);
 
 /*
  *     Parsing tlv encoded headers.
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 5045818..b8ef0ea 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -118,6 +118,22 @@ struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
 	return opt;
 }
 
+int ipv6_opt_update(struct sock *sk, struct ipv6_txoptions *opt,
+		    int which, struct ipv6_opt_hdr *new)
+{
+	opt = ipv6_renew_options(sk, opt, which, new);
+	if (IS_ERR(opt))
+		return PTR_ERR(opt);
+
+	opt = ipv6_update_options(sk, opt);
+	if (opt) {
+		atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
+		txopt_put(opt);
+	}
+
+	return 0;
+}
+
 static bool setsockopt_needs_rtnl(int optname)
 {
 	switch (optname) {
-- 
2.7.4

