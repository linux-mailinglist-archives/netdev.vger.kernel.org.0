Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CA424921E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgHSBHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbgHSBHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:07:22 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C3FC061389;
        Tue, 18 Aug 2020 18:07:22 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u128so10821126pfb.6;
        Tue, 18 Aug 2020 18:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+wK+rbb5LFUWKURBdXLnf6TcSgWtJm3SjVLoS6sfcuI=;
        b=brh0Ktr9dycNhnLW0TLf+gpUU1vGvFAIch6QvlYZD2h3wpkxtOUXJpYuj5T7Mg4MoH
         fdcfOOddoaJoAdFiceyY9Bvl65u1M5WXv5lsjc/zYiYr4Xx5oh79H1UlIZ0xsAkuCR0c
         k8LPYnUO8G5h87s8/KZgQzG3FTKI/pYVyTykiElXJIwatK/4FDc5lplRbLdUBAVwncjI
         aEp6y79FP44uK4F19CV+I0tQlN+6Rdf6A2RIyhkDyvRDkIhPwD9gElmk8RVC+3RvZyrJ
         pYTprYuxPXU8Z1Q9pyHGlzh0Vn4ZO/lYZU8yyeE7oXzZYmrLYfBnfYQzwP7H6nHUXEVg
         rQzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+wK+rbb5LFUWKURBdXLnf6TcSgWtJm3SjVLoS6sfcuI=;
        b=Ufl+dvkZP2KHHT+10EzZn97wvpbZ5Zcx/A4sKdk8UTrXtRn8HdICXx2rwv1TwwVdTZ
         V6eMkRd+qDs8do1ilpkBez+JOtmbqK5htYy7JTRkGDlVpngoJ0qMy/gk3/S0qXji6epe
         lOMHWGxZG6M2ZmXAkzWtlTVfNvvhWR1aN23uA9b4JFTqXV2saIZTShswn6d9Hb9k8cRs
         BH0RlQZEzV+qF9uQq5T0QZR05DBsYEJ8TLJql12RJShvQhfZM/p/gMF+qLAmrh9Ve6wp
         hJjXEM2fVnZw9GS3N8znSlVsUALptYcjavTjQZRcRvcHbnF31RNm4pKntmsHUCvM+nGt
         yP9Q==
X-Gm-Message-State: AOAM530oPiELc/4C7MBKCqhxGkG3NSk8nNDFqH6CAoFKsFwEKC0aG+ZG
        jee4KfymrQqoR4Zmn3kULyI=
X-Google-Smtp-Source: ABdhPJwxddduoYdkGM2dQ7x6yTJRwPoAWBQclChxX2K6PuPejzkXW7RRl1/JLLhDhZgvN8XjQvEOeg==
X-Received: by 2002:a62:8105:: with SMTP id t5mr17454448pfd.94.1597799240520;
        Tue, 18 Aug 2020 18:07:20 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:a28c:fdff:fee1:f370])
        by smtp.gmail.com with ESMTPSA id 193sm25881853pfu.169.2020.08.18.18.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 18:07:19 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH bpf-next 1/2] net-tun: add type safety to tun_xdp_to_ptr() and tun_ptr_to_xdp()
Date:   Tue, 18 Aug 2020 18:07:09 -0700
Message-Id: <20200819010710.3959310-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This reduces likelihood of incorrect use.

Test: builds
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/net/tun.c      | 6 +++---
 include/linux/if_tun.h | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3c11a77f5709..5dd7f353eeef 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -225,13 +225,13 @@ bool tun_is_xdp_frame(void *ptr)
 }
 EXPORT_SYMBOL(tun_is_xdp_frame);
 
-void *tun_xdp_to_ptr(void *ptr)
+void *tun_xdp_to_ptr(struct xdp_frame *xdp)
 {
-	return (void *)((unsigned long)ptr | TUN_XDP_FLAG);
+	return (void *)((unsigned long)xdp | TUN_XDP_FLAG);
 }
 EXPORT_SYMBOL(tun_xdp_to_ptr);
 
-void *tun_ptr_to_xdp(void *ptr)
+struct xdp_frame *tun_ptr_to_xdp(void *ptr)
 {
 	return (void *)((unsigned long)ptr & ~TUN_XDP_FLAG);
 }
diff --git a/include/linux/if_tun.h b/include/linux/if_tun.h
index 5bda8cf457b6..6c37e1dbc5df 100644
--- a/include/linux/if_tun.h
+++ b/include/linux/if_tun.h
@@ -28,8 +28,8 @@ struct tun_xdp_hdr {
 struct socket *tun_get_socket(struct file *);
 struct ptr_ring *tun_get_tx_ring(struct file *file);
 bool tun_is_xdp_frame(void *ptr);
-void *tun_xdp_to_ptr(void *ptr);
-void *tun_ptr_to_xdp(void *ptr);
+void *tun_xdp_to_ptr(struct xdp_frame *xdp);
+struct xdp_frame *tun_ptr_to_xdp(void *ptr);
 void tun_ptr_free(void *ptr);
 #else
 #include <linux/err.h>
@@ -48,11 +48,11 @@ static inline bool tun_is_xdp_frame(void *ptr)
 {
 	return false;
 }
-static inline void *tun_xdp_to_ptr(void *ptr)
+static inline void *tun_xdp_to_ptr(struct xdp_frame *xdp)
 {
 	return NULL;
 }
-static inline void *tun_ptr_to_xdp(void *ptr)
+static inline struct xdp_frame *tun_ptr_to_xdp(void *ptr)
 {
 	return NULL;
 }
-- 
2.28.0.220.ged08abb693-goog

