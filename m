Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC1D481822
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhL3Bg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:36:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhL3BgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:36:25 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93925C06173E;
        Wed, 29 Dec 2021 17:36:25 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t187so6509431pfb.11;
        Wed, 29 Dec 2021 17:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0qsyKVqTT5J+RWEg/K7IO/ejuuZwYWzgsrX1QRq8WA=;
        b=oqLmMI/Lo2Q3L+4iXZU9AGTBbTyc1hYnDlpSOsEaOYUYKu3MqJ3dVCFgdcBtCZR2Na
         JyDvYBnTgwKfLQtKiqAbl+Tc8Mwv+5bwnhE+gSl/zhV9HxO3eGgfEFWAWvNwvaLuUlyN
         o1ULdCJ8A0xsMttDt/rZ26vFw0ZgFh+JS28n6ngzOyua0HuqFD9WdPByZc0ZVrKl/raH
         sk3SOk2fQkEt5JopIb27Irol0/iHYMkUGswyF0OfqIvNOreJP8h4sDVqB5utHiEBCLbg
         48ERxrQXo3F770D2y5dbMWd89aazi9ahbRYQ/Z9/Wn+Li2lqDi7FANltZFG2agofXOlS
         EMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0qsyKVqTT5J+RWEg/K7IO/ejuuZwYWzgsrX1QRq8WA=;
        b=RTRIvMOI0dkaG/QCOLt5ICpa+6JMwp7t/OVPH5EMIzzmmASzOa3lsdwCJIpQsA/pnO
         nWso6yxZ6WTAAoEPfbMRHOdAhUCe0q4AjCb4QAJH3OlLv9t9U2pfSHp9zPX3NcpNYdbX
         XrH2eEQdRXIe8SdsowH9FiqItNqo89gcULyoMlG77xjtQhT0OxojGftqk8xObwstp3rG
         we9dUpR2av0S7Asw/23/gNlPXKJakBcquhKk+QQb6sKY2ohP4ownHlVcumtujAxNzbo8
         Sw0SsBwLpw89sdpvYXct4oHyhlYMw0Qb+0DhZbdWpLh2HSjNZIZzer7ZB2U48aXvlPeq
         Naqw==
X-Gm-Message-State: AOAM533lHlrwVNss8AFkBAFb90uexfa/N26YTuRpq1it0hL8m1Xct6As
        CluPvYzvN+2uxi8M3o2ceA0=
X-Google-Smtp-Source: ABdhPJy3exkUinL63a2gfH2jmHYFJL1xslRMwF6mlgpwHDrq9HJADzWnGCWRQBBZQlL+0Juy0qbACg==
X-Received: by 2002:a63:ea0c:: with SMTP id c12mr25248060pgi.378.1640828185202;
        Wed, 29 Dec 2021 17:36:25 -0800 (PST)
Received: from integral2.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id v8sm19616795pfu.68.2021.12.29.17.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 17:36:24 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [RFC PATCH v1 2/3] net: Make `move_addr_to_user()` be a non static function
Date:   Thu, 30 Dec 2021 08:35:42 +0700
Message-Id: <20211230013250.103267-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230013154.102910-1-ammar.faizi@intel.com>
References: <20211230013154.102910-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to add recvfrom support for io_uring, we need to call
`move_addr_to_user()` in fs/io_uring.c.

This makes `move_addr_to_user()` be a non static function so we can
call it from io_uring.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 include/linux/socket.h | 2 ++
 net/socket.c           | 4 ++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 8ef26d89ef49..0d0bc1ace50c 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -371,6 +371,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
+extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+			     void __user *uaddr, int __user *ulen);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec64;
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..af521d351c8a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -267,8 +267,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
  *	specified. Zero is returned for a success.
  */
 
-static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
-			     void __user *uaddr, int __user *ulen)
+int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+		      void __user *uaddr, int __user *ulen)
 {
 	int err;
 	int len;
-- 
2.32.0

