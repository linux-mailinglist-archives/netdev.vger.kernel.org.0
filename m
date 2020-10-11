Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80B28A7FC
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbgJKPfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 11:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388174AbgJKPfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 11:35:33 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D91C0613CE;
        Sun, 11 Oct 2020 08:35:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n18so16084368wrs.5;
        Sun, 11 Oct 2020 08:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N3w+u3WCpyf2Vmxu08flBAYgvj/+mZSLxfWdcFvbf9A=;
        b=is0pGkhosYP4T2lFntud/fVUdOErxzaBOMphwYQ+jimFNuLOPiyszvkD+Lm0P0w/wC
         lJ4MjsQTHbulo1nx/YKOCXEx7e5lqTf96lRJYp4ns+y7necMy1INEbj8vBo91MrKyXc9
         NJXCGUe5teb6OXrKhgAKtPTuwHpT/siUay3pqRltaGBueMGYAVqPHX8P0dtyVqb3Yuy3
         14+FN83DAgG31kz2nLLUUaHsfX4imHgMvHnRTk9rVTzjGQwp1/utq0s3SbJeknEfbT+f
         7ug7IF6QV08qMoF7TN42T48w7q+7EksbT+X0DuNBDfCh7lKVqUaxV/fEPiaOh1YllNbp
         Smnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N3w+u3WCpyf2Vmxu08flBAYgvj/+mZSLxfWdcFvbf9A=;
        b=YPV9GS3f+A7YjgUalJH9xFKT6U9+U725WJ+bwsqVg5XWhUlhwtisaJl16tyjre5ksa
         XH8FNuwheEh+C2QLeVsnIEQcYl9UUsiuHzrqXXaGZZ+Oii7KMQUCSuakKwSrTguqFPeZ
         m6s3MDmHHGZB/uOMFD1WfFiZ+9qrJo2sH6t4UKYc8MBtQ5FK69DKBHdQmhtuKn4Ox2t/
         dQhIuMXwn3BZ5G30v0jLmVXjI3KrwlZDD5Q6iu/veC6vgk0xTIZT6BHgY80i/oaxsQxz
         JJUoKr78ljCmj968qU48euiBqauqWKncyaSeKGBP6O0aeRMxd5yMJbs3fPvKAv2YnNyt
         noJw==
X-Gm-Message-State: AOAM531M3LWr5gxrBGKVokhLWmV3QbBJ4VzCXtJwnZ5Fs6IaFh5tM4zB
        mts7sZId6a9stt/FgnferhFKu2foEjSLIqbQ
X-Google-Smtp-Source: ABdhPJwAUxKzsVVN5goil3FjwV7IzV49fihju/Qq955hCEYJeP1uRw6KOEJqosZwlQvoOAa8GIJK2g==
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr21029873wrx.4.1602430531606;
        Sun, 11 Oct 2020 08:35:31 -0700 (PDT)
Received: from localhost.localdomain (bzq-79-182-88-189.red.bezeqint.net. [79.182.88.189])
        by smtp.gmail.com with ESMTPSA id y7sm20309176wmg.40.2020.10.11.08.35.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 08:35:31 -0700 (PDT)
From:   Or Cohen <orcohen2006@gmail.com>
X-Google-Original-From: Or Cohen <orcohen@paloaltonetworks.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Or Cohen <orcohen@paloaltonetworks.com>
Subject: [PATCH] net/af_unix: Remove unused old_pid variable
Date:   Sun, 11 Oct 2020 18:35:27 +0300
Message-Id: <20201011153527.18628-1-orcohen@paloaltonetworks.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 109f6e39fa07c48f5801 ("af_unix: Allow SO_PEERCRED
to work across namespaces.") introduced the old_pid variable
in unix_listen, but it's never used.
Remove the declaration and the call to put_pid.

Signed-off-by: Or Cohen <orcohen@paloaltonetworks.com>
---
 net/unix/af_unix.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3385a7a0b231..26d3bf81186f 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -613,7 +613,6 @@ static int unix_listen(struct socket *sock, int backlog)
 	int err;
 	struct sock *sk = sock->sk;
 	struct unix_sock *u = unix_sk(sk);
-	struct pid *old_pid = NULL;
 
 	err = -EOPNOTSUPP;
 	if (sock->type != SOCK_STREAM && sock->type != SOCK_SEQPACKET)
@@ -634,7 +633,6 @@ static int unix_listen(struct socket *sock, int backlog)
 
 out_unlock:
 	unix_state_unlock(sk);
-	put_pid(old_pid);
 out:
 	return err;
 }
-- 
2.17.1

