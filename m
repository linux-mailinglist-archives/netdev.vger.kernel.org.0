Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3E4A1F861F
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 03:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726848AbgFNBUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 21:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgFNBUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 21:20:20 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD785C03E96F;
        Sat, 13 Jun 2020 18:20:18 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so12620801qkg.3;
        Sat, 13 Jun 2020 18:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=weNT1L1XKUjhZ/GyqfyR6sCkF+DRrUdSjJ2ej+SbbZw=;
        b=UUWwANTZUf9s6b09wIICLD5DT1wu6LnvZEZitokYHV2htO/B/xWJQS+FtpInW69ekG
         JVqvmJUXWH8Bw9o2+7Q4+FeK5o7+KsIHbkds4v2MsUTHpBkrE9fngOW2kMXrF18tOn8p
         NABJO8ZhMiWs2GCwhpu7If3MOXEYxXGJzQw6NvfhXMSlX5x0UUnOwzhy8IM+IwZDX4M1
         3bY6aN3kwRnoDcQJq3gf5IeJws3uqAoa589vSlDcWcREZIhScvHocIKwKh0qcg2WtccV
         ILJHtHVRoCuqsthHNkSaU1YBcyAhkmqq1K/1Ru8AKyXKYh8B2xIFl3T2fMXj0872XHVe
         +vpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=weNT1L1XKUjhZ/GyqfyR6sCkF+DRrUdSjJ2ej+SbbZw=;
        b=T5IeoVDOj/YJKXIKZQWEx4/umEqEr43dQNB9uLpLjto8ks1b1AUI13rphNTkBQiDwR
         hDiYvweFPjNaxPWwdNoaFtvm0kVLk2MmKpDjc91KeL+4G6gcpaxW0Ap3uX3bWkxPofUs
         IYm+AJ3Bn8jvcTDvCDtEwrTSXFbNRt1uHqjEOEFyCPmYjwfwyPXwHEvn2HvQUoElGUnD
         PxzL2jpKnOSVVzEATqj6ySKErzKF1gpecGuomOijhixGXMTWzOhYYdn+/+6j6w9I2UOS
         jWVjX/5ha5dz4XwQAhS2Ra9/zm0Z8H52KrCwNie0RU546B/Tlqd+/vtZZ80OlSRrNwnM
         WY2A==
X-Gm-Message-State: AOAM532+kRhbq83agZQz5MQJbwOfatdEvpZAlT+AOtOGGBBuF3oXqgkM
        QUNoMdufF61fe3X971oAw0s=
X-Google-Smtp-Source: ABdhPJxWbSwqsoRLmmhzpK3JmfQ7atmha/MGg4W9VIU4e/whsX6MJrO4pV4tEXhRaKT96K+BSIQMgQ==
X-Received: by 2002:ae9:e8cc:: with SMTP id a195mr9819577qkg.408.1592097617772;
        Sat, 13 Jun 2020 18:20:17 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:8024:443:2d4f:1b98])
        by smtp.googlemail.com with ESMTPSA id 124sm7966356qkm.115.2020.06.13.18.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2020 18:20:16 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Alex Dewar <alex.dewar@gmx.co.uk>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        linux-um@lists.infradead.org (open list:USER-MODE LINUX (UML)),
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools))
Subject: [PATCH] Fix null pointer dereference in vector_user_bpf
Date:   Sat, 13 Jun 2020 21:19:40 -0400
Message-Id: <20200614012001.18468-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_prog is being checked for !NULL after uml_kmalloc
but later its used directly for example: 
bpf_prog->filter = bpf and is also later returned upon
success. Fix this, do a NULL check and return right away.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 arch/um/drivers/vector_user.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/vector_user.c b/arch/um/drivers/vector_user.c
index c4a0f26b2824..0e6d6717bf73 100644
--- a/arch/um/drivers/vector_user.c
+++ b/arch/um/drivers/vector_user.c
@@ -789,10 +789,12 @@ void *uml_vector_user_bpf(char *filename)
 		return false;
 	}
 	bpf_prog = uml_kmalloc(sizeof(struct sock_fprog), UM_GFP_KERNEL);
-	if (bpf_prog != NULL) {
-		bpf_prog->len = statbuf.st_size / sizeof(struct sock_filter);
-		bpf_prog->filter = NULL;
+	if (bpf_prog == NULL) {
+		printk(KERN_ERR "Failed to allocate bpf prog buffer");
+		return NULL;
 	}
+	bpf_prog->len = statbuf.st_size / sizeof(struct sock_filter);
+	bpf_prog->filter = NULL;
 	ffd = os_open_file(filename, of_read(OPENFLAGS()), 0);
 	if (ffd < 0) {
 		printk(KERN_ERR "Error %d opening bpf file", -errno);
-- 
2.17.1

