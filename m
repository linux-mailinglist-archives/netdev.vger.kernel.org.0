Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14500481BE0
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 13:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239135AbhL3MBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 07:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239136AbhL3MBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 07:01:20 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274A7C061574;
        Thu, 30 Dec 2021 04:01:20 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c3so4886674pls.5;
        Thu, 30 Dec 2021 04:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zo8MqU7um74x8FzU/Cge4ipaSqWEBCRhFz3uE6S7/GE=;
        b=i/HzMOcV4lYhLZ4t43adzpIbSrK5BIqylqbtgWU599ncKVBhXaDK7e+XyQL+ddWLUl
         tFkSMmjg2+tgtacKhJolp7mUlG/dOIr6Lb2u0eOl8hNgFMnqQBpac2zhn63I8ir/jWsU
         uB8uoM9zu7bln35zW4m8QIoqEwC3UnkDY4H1hx0DvPfuwo2O/aVm2Q5vRQx8AlvtXnao
         EXi42044hzYZE3kWJXICzlNirMsOriurO3Ag5TElHlvrh/C454bh/LVzNVodoxeADAk8
         lWSFhJOkSynHG0NvBxTYzaQXRAe4mfdcnm53+Bl1i64ihyLTQtvVeVPKUYXgXuDhwkV+
         fhsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zo8MqU7um74x8FzU/Cge4ipaSqWEBCRhFz3uE6S7/GE=;
        b=j81mYbkKeIO3h31dATEg3stbbj+9UKEcb0aXBLWvKBurfnZfrtj58J3XbO5eZe8cyl
         peVtMqXd0kGPbkXfGTVreJZwVeZP+DWZdHcpUz0ceTgfuL+dCnZJqnI+l0/wB79cMZCE
         EJnQNJEurG5/q46nfQiXSxGAhN2jk05bOtOld/BHYWYR1SPujrQE6lD6XGhqpKboXuh/
         oDQf90yG01fm2eV/kJxggyA006ra/nCHDe7lhD9dK+4HLldkcPD851RfTwVLiZDYfVJA
         6T/rz3dTlo/YpNn5v5L+TKyMynGgf0o4AncEZ1D6WQD4+WKeFk5XY+qRBsL5LHE/0pfH
         lDKA==
X-Gm-Message-State: AOAM533oc9NoY5Wjbpx8lBnxqgVcu9Q2iISngaZVzUp+nEViun4k3IY4
        wnUy/b7apKZtj4jB8YWii7M=
X-Google-Smtp-Source: ABdhPJwN2YNvvBPxemF14e5XC0gLkj9dMX87HImTBE8sXe9NgyN2SvD2n20xcRp8cbZn5f6ASrGZpQ==
X-Received: by 2002:a17:90a:d3c2:: with SMTP id d2mr17592450pjw.219.1640865679742;
        Thu, 30 Dec 2021 04:01:19 -0800 (PST)
Received: from integral2.. ([180.254.126.2])
        by smtp.gmail.com with ESMTPSA id nn16sm30121257pjb.54.2021.12.30.04.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 04:01:19 -0800 (PST)
From:   Ammar Faizi <ammarfaizi2@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ammar Faizi <ammarfaizi2@gmail.com>,
        Nugra <richiisei@gmail.com>
Subject: [RFC PATCH v2 1/3] io_uring: Rename `io_{send,recv}` to `io_{sendto,recvfrom}`
Date:   Thu, 30 Dec 2021 19:00:42 +0700
Message-Id: <20211230115057.139187-1-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211230114846.137954-1-ammar.faizi@intel.com>
References: <20211230114846.137954-1-ammar.faizi@intel.com>
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

