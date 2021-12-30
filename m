Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE8481ED5
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 18:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbhL3Rwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 12:52:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236799AbhL3Rwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 12:52:43 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE783C06173F;
        Thu, 30 Dec 2021 09:52:43 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t123so21879155pfc.13;
        Thu, 30 Dec 2021 09:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0liyv0ToSBMIYrvXZ3u/lR+qbXOeZrNLleid0iHOqc=;
        b=UwhACIBMpTCqTeFWIIpIThAcu9FScxwgeEAnCYARFR9ysWAujmW9SpDFIpxQEnizu0
         k7ZibOsX//is819Hm1qg8Wt2FKNxuJNRMpap95Nka/cbp70hchsYoV/M6zqdJYQ8U2Gi
         /1YFE/fZx24scTmFrF/k/byN/84jHyJJRCxLOFglcehsCTOQPLcXX6IfnkfGHjZcCqmH
         0P55b2MtFmbvXEGKmQeuVhaslguC0N6dKFaRCnF1rlwFBJ1Wq9ErfoXqc68xp46X7r3/
         008ExkCC4Brr4PGjqLOY+r20w00urdMGk3ZlDy9YZk9tJ0tvFWe9soVRtmOnbVNQpuYS
         Y2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0liyv0ToSBMIYrvXZ3u/lR+qbXOeZrNLleid0iHOqc=;
        b=fYLobNTY6dF46RrK+YN9PvYUZcqtZRGdbPIOphvULC0PtMevdDXAlYzjEI00qkWwRh
         IvaY7gRZydOepfIWqHDxrIOU9hMp6XgyO+rGnlQsPDtipuXSiF39oIYFw+u/r9AQCVDB
         LpfwJ6NZqMyOkAg3FyDbOH6DZ+je+tqicFZj4oCB95rZe3tAFXPy/h27sv4n0bfRtnsH
         05BGpywBjqZXFuYQofGGCuEDNIiL2QWJAh8UeUc7bF6cNvcT6akdbvZxR3EXOVxdhGxC
         lxf3p/4XUzmhY1fwZ5G7R7NpeiJscprFJUl50NLE/CiGJH6CUak/5ZDHqpJ5YLlQpi6I
         idVA==
X-Gm-Message-State: AOAM530L9Pl7s1OJ7CfYE07rcI6BYjB+DOiEfNhCn4iq57m6deMn8wYS
        DRv2KfIZ7R/VU40YDV+Ag0c=
X-Google-Smtp-Source: ABdhPJx3Nv4l80f/k9aApZ3ZA5UFPLCE2tYfT4ZuKxdOQuBZkyk3a5zKThldi1/+NOo/V8UUA4xQvg==
X-Received: by 2002:aa7:8188:0:b0:4ae:db42:6f98 with SMTP id g8-20020aa78188000000b004aedb426f98mr32726332pfi.26.1640886763240;
        Thu, 30 Dec 2021 09:52:43 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id 185sm9244188pfe.26.2021.12.30.09.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:52:42 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v3 1/3] io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
Date:   Fri, 31 Dec 2021 00:52:30 +0700
Message-Id: <20211230173126.174350-2-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230173126.174350-1-ammar.faizi@intel.com>
References: <20211230115057.139187-3-ammar.faizi@intel.com>
 <20211230173126.174350-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we can perform `send` and `recv` via io_uring. And now, we
are going to add `sendto` and `recvfrom` support for io_uring.

Note that:
  Calling `send(fd, buf, len, flags)` is equivalent to calling
  `sendto(fd, buf, len, flags, NULL, 0)`. Therefore, `sendto`
  is a superset of `send`.

  Calling `recv(fd, buf, len, flags)` is equivalent to calling
  `recvfrom(fd, buf, len, flags, NULL, NULL)`. Therefore, `recvfrom`
  is a superset of `recv`.

As such, let's direct the current supported `IORING_OP_{SEND,RECV}` to
`io_{sendto,recvfrom}`. These functions will also be used for
`IORING_OP_{SENDTO,RECVFROM}` operation in the next patches.

Cc: Nugra <richiisei@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---

v3:
  - Fix build error when CONFIG_NET is undefined for PATCH 1/3. I
    tried to fix it in PATCH 3/3, but it should be fixed in PATCH 1/3,
    otherwise it breaks the build in PATCH 1/3.

v2:
  - Added Nugra to CC list (tester).
---
 fs/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 90002bb3fdf4..7adcb591398f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5273,7 +5273,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, unsigned int issue_flags)
+static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
@@ -5499,7 +5499,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
+static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
@@ -5707,8 +5707,8 @@ IO_NETOP_PREP_ASYNC(sendmsg);
 IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
-IO_NETOP_FN(send);
-IO_NETOP_FN(recv);
+IO_NETOP_FN(sendto);
+IO_NETOP_FN(recvfrom);
 #endif /* CONFIG_NET */
 
 struct io_poll_table {
@@ -7061,13 +7061,13 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_sendmsg(req, issue_flags);
 		break;
 	case IORING_OP_SEND:
-		ret = io_send(req, issue_flags);
+		ret = io_sendto(req, issue_flags);
 		break;
 	case IORING_OP_RECVMSG:
 		ret = io_recvmsg(req, issue_flags);
 		break;
 	case IORING_OP_RECV:
-		ret = io_recv(req, issue_flags);
+		ret = io_recvfrom(req, issue_flags);
 		break;
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout(req, issue_flags);
-- 
2.32.0

