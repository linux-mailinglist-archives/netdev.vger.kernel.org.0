Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E42481EC6
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241527AbhL3Rux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241518AbhL3Ruv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:50:51 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E75C061574;
        Thu, 30 Dec 2021 09:50:51 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id v13so21925179pfi.3;
        Thu, 30 Dec 2021 09:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8lod7fnVTBJHDQ4ufvLD8YBxdSNhFnY3bwtUaLmQ5+Y=;
        b=UsIw9MUXjcU60imQnPacUzRcXxSrChCUhx3tGsYqFpu+UvG4kXj+9Ncls/O7R/lvVO
         aCL47nsw2k76rzIP6KNNh3XhD/uTk/TJeNm9z027nLNvfOQRi89JVyIJEoBSJWiCTEoO
         dyjPVtE+pG86zh75tOJKHpm6f6DzeubiP/wVU5IsCl9fsPRAvv3xA6iPzTC4+DCnizq2
         lK5IM5mDXzqKFddrp1p3hicTZzpcuUmgFR6DkRWP0YghciT7rwC80voeV24RvkyyJvpk
         9m+8G5TPgkvTlMcqQtQ4d0fHF15LaFTMpQeczw1Ub2RoNEhX5DSV11fYcwBZhdbDkI+o
         X/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8lod7fnVTBJHDQ4ufvLD8YBxdSNhFnY3bwtUaLmQ5+Y=;
        b=z7jEBMhb/pW9KBZ6/PYCrZ+b2xA/90Ri62UnEIyx4DGKihsV0sGXd6cheUr2/sUGuU
         2X88FyaFMwv4dZ3B1t5TYc3v2cn31UolXEhJ82mNZHS38DUeZ/ZxnK6cL1DuALIpXVL/
         w22t4a5YwvVBEB002MVVszElk79j6m8OWiDg+V0SvZkB3mDNDKHX7Yo0ZA7j5kv8k4D2
         +uYOwumKe1UDmCgbhfVgczxQFu++di5qGIvtr/VSkHgkcXrNvGE9x6dK5rBddn+aFhNP
         w5IZ1zmJTqA2OrIUNDjP/wGXoRExCpL8hIeILPv3KYNw2VmgH42iLMmhwwv8R/HOS9Qf
         9wZw==
X-Gm-Message-State: AOAM530imAsmlUeNioktgsg4uTfj3IzIN7kNWiF8kOR9G/+IDmSjZpIe
        qI6UNn9Qy8gU8LqWD5OlPZKrHEfhN3tXag==
X-Google-Smtp-Source: ABdhPJwtlzh7IbZExWB+yWgyqNpkT4IiBsPNnZ0BhtS3N8rJLaG6DG/TjKVDtDlWNIjLcCiRPf3bLA==
X-Received: by 2002:a05:6a00:1311:b0:4ba:1288:67dc with SMTP id j17-20020a056a00131100b004ba128867dcmr32466272pfu.43.1640886651442;
        Thu, 30 Dec 2021 09:50:51 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id s34sm29980811pfg.198.2021.12.30.09.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:50:51 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH liburing v1 2/5] io_uring.h: Add `IORING_OP_SENDTO` and `IORING_OP_RECVFROM`
Date:   Fri, 31 Dec 2021 00:50:16 +0700
Message-Id: <20211230174548.178641-3-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230174548.178641-1-ammar.faizi@intel.com>
References: <20211230174548.178641-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync with the kernel to support for `sendto(2)` and `recvfrom(2)`,
this adds those two new opcodes.

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 src/include/liburing/io_uring.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 9d8c7f9..47038f6 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -154,6 +154,8 @@ enum {
 	IORING_OP_SETXATTR,
 	IORING_OP_FGETXATTR,
 	IORING_OP_GETXATTR,
+	IORING_OP_SENDTO,
+	IORING_OP_RECVFROM,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.32.0

