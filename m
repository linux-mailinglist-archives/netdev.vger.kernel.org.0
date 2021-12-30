Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17ADC48181F
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 02:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbhL3BgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 20:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbhL3BgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 20:36:23 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207F9C06173F;
        Wed, 29 Dec 2021 17:36:23 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso13221690pje.0;
        Wed, 29 Dec 2021 17:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=14lTngi1IoPvjN6s3SioOn5jd/f/gDMNhtlGGEjDRSs=;
        b=nmYp9B6XpYOIPss4T/J3Stj5BIUqEQj0uEwPmiszgG2cGAu92v0Zmx/CFy+9AWGuJ2
         W5aF+LhE3sH2bstS0aAThwVzz1qU1fXBWKpwpr37lWNVTfUFolgHaY1p6U0BDi2bnb5n
         iVGVS5+H2yRzXUB+lXo1yxmHsC+Mn1Mc/2yE1AUnaAUjIdz+3POqqEIVuBNQwshuWm0s
         UCcR7dWPDXeOuo9h+ViMpUzTGjNP1oMtx7nDGkaJpcXYFkCKAG+npcL+BmgF9Qk3lRrb
         Em5/7qdXHwUntsZwg6UJo0YCkjbxvEYVyVOeY88nYZrPcTOyP4FwDRBz78fuI6Es7ODq
         HALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=14lTngi1IoPvjN6s3SioOn5jd/f/gDMNhtlGGEjDRSs=;
        b=fxbNv3VwOj1Lvdk6Vdv/h0Gi/1sXAHK0WsriMyHNV/boudFNrZ5bYxxRhdLn/P0vBG
         pL8P5pviLxffQKZuNgs1H1LB2XUcaP959OnfkGzt804qLTG+UgpoZ4nKFRvLawarD21M
         U4moCq9MMgZbeZa75Z99sK1L7e8UWQnoBLRxFHR0LWZ7iHWnwNl7SBgqcclhFc9omRDd
         YPZGJVXZOQeKfyg95kkfrSH6xaz4u4en5knr3qcxGEu5U6381xZG7w0HMmROvCwjqDCB
         jzvTtUrELYJRgo6a1FbDDBwZ/zXs9URzb0Yx+bOpwu5Eg+xUDmVWu2fJDof9EkQ2eZLH
         v5hQ==
X-Gm-Message-State: AOAM530Z7rrCnDjExCka1dS5+LR+wDqI052wVl0uhPhh93HRSw+rj/Tm
        Z0s1i1Pov6GSqg8RGSYFo5A=
X-Google-Smtp-Source: ABdhPJxgrdMa8T+rLk4cDvmIvijPmjc5sAJAaZTJW+ZNwprlQT7aZP6uDkl7G2/nzLgLAXUAainiTg==
X-Received: by 2002:a17:902:9b8c:b0:148:9c40:690c with SMTP id y12-20020a1709029b8c00b001489c40690cmr29258518plp.8.1640828182328;
        Wed, 29 Dec 2021 17:36:22 -0800 (PST)
Received: from integral2.. ([68.183.184.174])
        by smtp.gmail.com with ESMTPSA id v8sm19616795pfu.68.2021.12.29.17.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 17:36:22 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>
Subject: [RFC PATCH v1 1/3] io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
Date:   Thu, 30 Dec 2021 08:35:41 +0700
Message-Id: <20211230013250.103267-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230013154.102910-1-ammar.faizi@intel.com>
References: <20211230013154.102910-1-ammar.faizi@intel.com>
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

Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 90002bb3fdf4..d564f98d5d3b 100644
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

