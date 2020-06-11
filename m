Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C8A1F6015
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 04:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgFKClF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 22:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgFKClF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 22:41:05 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BF8C08C5C1;
        Wed, 10 Jun 2020 19:41:05 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id w9so3557998qtv.3;
        Wed, 10 Jun 2020 19:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=wTiC49GnZ5ZEBNWsG/S2XbISpIYn0F/SWZwBLcW/d2A=;
        b=mLJu4gXzzMsz/IBbFLkr4QLmm3M3YXOfBvk576ubygCcnlm8I9VMZUgkm2nTfQ9ZSD
         ONnGYD4+rO7gGeX7gzYNjf9AJlKUREeRHxupmKvL6xy8G2MJo5+MSg2AJJvHm7PBeNzz
         IeQeL7DREZbwLWShJNRz7GZPUGTpCxrGwKej+sZXZXbZzUOIMtY6mPW47SP4TqXFc+4C
         L6YgVDRl4nKgQw+VztXXtmdyrCv/RRaLDrzANJNs4rx5/Pj2skxlQfTUAX+QTCXmC2IT
         YOf1XhQG2bPB6GmnYDQ6WwVJ/hLFCD2lVJykV0mYtGmjUNfZY24OwGBVQ2l1DwmoeUr5
         bdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=wTiC49GnZ5ZEBNWsG/S2XbISpIYn0F/SWZwBLcW/d2A=;
        b=Z1xtnRsdWiiBf7OnZQAuOtZEZK1qWFtGoqDm4x63aXQwvEKd26Ns8ODyu4qOLJth5E
         Shm8Wx2as5F5pWTugdRsd63u8dVJJ9msmQLFbR2mYkFIq23avKG/iY1LYU22y/phgDXb
         wzhD32MvmYUkRJXddhnqN8bgUSK18fY3mRVjggNAn175JFlMMM7Ep5FT124+rayc89hv
         a/NGI3Rq2pNvVRmFndk3rzfbe7ZGNK83OycSj0mJEvWCyGmd2d+dIEkFa/+JQNkc8rml
         o0mQOg3n9Qto83FkrLuwitKQHkRGxMDAUIiIoXqcS0qzGv88gZF2UNhb0fWxiT8uPYWa
         lcuQ==
X-Gm-Message-State: AOAM530IkyxBMbJSkMhG6VKnd7918D8N8bY8Jitoa5mMnoM/cxdNnu4p
        b+ylcyWliFrXaa/mWZ+2C3StGxsMjw5YtQ==
X-Google-Smtp-Source: ABdhPJwkRdDdS5KBsTGSggDXQTHMfO9ECWm+ZUkwd4fu9vppbYNA0a5kdhFJ44GPc6tARd98iiOkiw==
X-Received: by 2002:ac8:6bc6:: with SMTP id b6mr6537003qtt.101.1591843264037;
        Wed, 10 Jun 2020 19:41:04 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:61ac:316c:1207:3fa6])
        by smtp.googlemail.com with ESMTPSA id z194sm1265023qkb.73.2020.06.10.19.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 19:41:03 -0700 (PDT)
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
        linux-um@lists.infradead.org (open list:USER-MODE LINUX (UML)),
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools))
Subject: [PATCH] Fix null pointer dereference in vector_user_bpf
Date:   Wed, 10 Jun 2020 22:40:36 -0400
Message-Id: <20200611024053.10429-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_prog is being checked for !NULL after uml_kmalloc but
later its used directly for example:
bpf_prog->filter = bpf and is also later returned upon success.
Fix this, do a NULL check and return right away.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 arch/um/drivers/vector_user.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/um/drivers/vector_user.c b/arch/um/drivers/vector_user.c
index aa28e9eecb7b..71d043ae306f 100644
--- a/arch/um/drivers/vector_user.c
+++ b/arch/um/drivers/vector_user.c
@@ -730,10 +730,12 @@ void *uml_vector_user_bpf(char *filename)
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

