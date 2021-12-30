Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE84481BE3
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 13:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239164AbhL3MB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 07:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbhL3MBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 07:01:25 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD73C061401;
        Thu, 30 Dec 2021 04:01:24 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id i8so12753680pgt.13;
        Thu, 30 Dec 2021 04:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SXKZhmw0DntqN3lXPBfZG3vOv+diEwlNuMVW/hXFmB8=;
        b=FuycI1w5QoYAIOIjm3+OLASs6NMDHAtJkXwijUjprxcbNcvLfv13lzRQVcNWPCitJL
         /n0oZqiSiKp8z2vBLP6AUxXw9wpyqHnk5mxG8a0q9GeiBUd38WoWBEF0MWW8ie+kVgeA
         Gb3PWTHuM+15EETXLutKCUrdCBOLCAtsF0RgGJ/jH0vY/3gF8ejzmtiow0fbZT0cn8Ud
         G6G7LF5iDiDt2aRuz5cfoEXXcuXlY4fd7G3OwQn2W2v1Cg1kPfM3eaO+uJRRoeLPn02s
         E0F/UQukUpq+cAyStAhrG6yw73UN/HSswXtOJyg4D35jKWL8qN3mN2Vdd5WfL/Fdbtpq
         /OIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SXKZhmw0DntqN3lXPBfZG3vOv+diEwlNuMVW/hXFmB8=;
        b=UTKo4hFyX9FvmMB7l8kyjiAcSIK2NLIkkdSS+2UiitoOVORoSATqHzY97C1Tp1Ac8E
         z73lXKiXDYsv10RL6d9Ize57kYYqbXRD9dw0jha0YSWpRZ4zWZXTCl5wSuJxpiBAfiOS
         nC0RREulauPCtkKRJSQslkVR0UMoAjEPAB0JWubEF2MUWRSfmuadR3e+2QOXH0dBbgqS
         OAELIJmLrVDgIpM6Yp0JEGSRKwm78q0qRRWTsvToGF9B6i0Fcjh2sctj+8VO0ilWKFJq
         f47hx7X7VPm6ZpGrAc/wox3MnHXGitqHmcDVi8vGWVZkaFqxGBSwg6dymBYoDJQ5Sm/R
         2Ncw==
X-Gm-Message-State: AOAM531nYJqc2eQTFfTyCJtQIEbnT7mWz2cCA2Yl64eofiYh5eYaXkiv
        ccUv7Dbnkds7Ai3NFlh/UY4=
X-Google-Smtp-Source: ABdhPJxqwj4rnHI59Om5vv6n74ym0YPBO1MS9r0VaQft8oeHyB3/O16wNyW0L4xbHc74ZDUADNtTQQ==
X-Received: by 2002:a62:b503:0:b0:4bc:657e:cfa6 with SMTP id y3-20020a62b503000000b004bc657ecfa6mr1033254pfe.25.1640865684242;
        Thu, 30 Dec 2021 04:01:24 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id nn16sm30121257pjb.54.2021.12.30.04.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 04:01:23 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v2 2/3] net: Make `move_addr_to_user()` be a non static function
Date:   Thu, 30 Dec 2021 19:00:43 +0700
Message-Id: <20211230115057.139187-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230114846.137954-1-ammar.faizi@intel.com>
References: <20211230114846.137954-1-ammar.faizi@intel.com>
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
Cc: Nugra <richiisei@gmail.com>
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

