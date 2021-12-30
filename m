Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBB4481EC9
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbhL3Ru6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241524AbhL3Ruz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:50:55 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7111BC06173F;
        Thu, 30 Dec 2021 09:50:55 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id l15so3914548pls.7;
        Thu, 30 Dec 2021 09:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vh9k3yzpWTJ0rz/QUtXD9eGCZU6BoOLDd0nqDuasgMs=;
        b=bLC7LU9IFRr8T9IhR8t7RD6GE/pLGh3Myyxff7R5nr7+oWdYtvx9Z3/5FjoW7mwvmm
         heWdTjyaLnM3SEt6/u1L/0Ds90tJo5y/m6EJDNoJWlhLTameWVCRPxu7U0mB8lMjXtTS
         aSh655R7ZroX8YfoYjAXMohOBekLJZAYtbc7mJ8DNai5t3cEcRKELkOUdcup7d3xsXYa
         7mqy1YRMFjDLTdF+GoxcnO0NBaD0MOoKooiZwDMOFAvLwfQYbcTj+TvGAKYIBYlyjwac
         shyV80uMigZz6DM1OGwNd0KXIj4E8jsGFONsq2thlA7vMzO5RoO0Cl5j3U27TP8BlWFK
         Q9+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vh9k3yzpWTJ0rz/QUtXD9eGCZU6BoOLDd0nqDuasgMs=;
        b=r5XFRiMavZMOLBONhg1AIyuLu9RS4z5AK2MrSbpVQrDvvDevjS9iYiJzcSqw24NP7q
         xOYvvH8KumgcagGJkrfncLvPWcZCm5p8dYvOVldw1OIBvOCiAjs4IN+KlCMTtHhpFp6u
         ZSwwuhliMStkLaakwX4h7+xGFd7fHCStKNDKiEnKRC/99Snh77rTL/sxhMTbZ1Zz+B5B
         oJ5fHZHqxU5ht2IhXYYIuIulkhOzGBSaWfznMCAoNRCrePQZOrge4bTni7IHyG6V2+QO
         7FSu8KiSgm7m6JIQ2JSyCFVGhrRfSGtcfIj+bilUnZahE55lMgZ678EZ0y2D6fkdXSMK
         hwQQ==
X-Gm-Message-State: AOAM533/8Hz4Lp+zYW2RB44Iyb5j0kQXRFdWWTNpXhvpo4XQV/ARISFE
        xk/6dJvdh4W1aWE7GqtoL8I=
X-Google-Smtp-Source: ABdhPJycF9EoJav//XmpcGCl0ufu0e9LGgtjczpWifWk4k6AKFQ3x3mPSGZiHVdVw5YHjYQd/pgzvQ==
X-Received: by 2002:a17:903:2307:b0:149:1bb6:fc28 with SMTP id d7-20020a170903230700b001491bb6fc28mr31692856plh.84.1640886655039;
        Thu, 30 Dec 2021 09:50:55 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id s34sm29980811pfg.198.2021.12.30.09.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:50:54 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH liburing v1 3/5] liburing.h: Add `io_uring_prep_{sendto,sendto}` helper
Date:   Fri, 31 Dec 2021 00:50:17 +0700
Message-Id: <20211230174548.178641-4-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230174548.178641-1-ammar.faizi@intel.com>
References: <20211230174548.178641-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds IORING_OP_SENDTO and IORING_OP_RECVFROM prep helper.

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 src/include/liburing.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index a36d3f6..c22e69c 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -750,6 +750,28 @@ static inline void io_uring_prep_fsetxattr(struct io_uring_sqe *sqe,
 	sqe->xattr_flags = flags;
 }
 
+static inline void io_uring_prep_sendto(struct io_uring_sqe *sqe, int sockfd,
+				      const void *buf, size_t len, int flags,
+				      const struct sockaddr *dest_addr,
+				      socklen_t addrlen)
+{
+	io_uring_prep_rw(IORING_OP_SENDTO, sqe, sockfd, buf, (__u32) len, 0);
+	sqe->msg_flags = (__u32) flags;
+	sqe->addr2 = (__u64) (uintptr_t) dest_addr;
+	sqe->addr3 = (__u64) addrlen;
+}
+
+static inline void io_uring_prep_recvfrom(struct io_uring_sqe *sqe, int sockfd,
+					  void *buf, size_t len, int flags,
+					  struct sockaddr *src_addr,
+					  socklen_t *addrlen)
+{
+	io_uring_prep_rw(IORING_OP_RECVFROM, sqe, sockfd, buf, (__u32) len, 0);
+	sqe->msg_flags = (__u32) flags;
+	sqe->addr2 = (__u64) (uintptr_t) src_addr;
+	sqe->addr3 = (__u64) (uintptr_t) addrlen;
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
-- 
2.32.0

