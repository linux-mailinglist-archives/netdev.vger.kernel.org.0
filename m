Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A251F4BD9
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 05:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgFJDn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 23:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgFJDn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 23:43:28 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE5BC05BD1E;
        Tue,  9 Jun 2020 20:43:27 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id dp10so419660qvb.10;
        Tue, 09 Jun 2020 20:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=qm+oX+JQzV56QUtwpMbMoKGf+j/HM4yHTB8cqsstqTg=;
        b=bpUMlBXZEXALee+IT7Ke3lzVjM9eFpSHKJPQ7jWtW1ZCSh9fYvzftShwYgAZMP4+gm
         72QVGyOnorRDtEdS2pC6xNakGk4m/D1H73P8jO8cJKQslHxveHNTxoqEdaY2E81TTbNF
         MdB2DWbL/Xctu4oLqLLHa4gjPJT/01rh3q24cPTZuzh5mRamlh9Mmkvn/QewFY1MYRjS
         PgA2Yk31L5u6bW6HniD3sLa+UE1FnkYNrnLJVFYZ2gq+mOaAXsjbnwvDF71CwSY70hzl
         Bx0o9ZGqFMVqpNrM6PskLgIh5uDZ5I6UJW2+ZF4DEP8uXqUMK3P7mqz/efZEufNPteWJ
         Rsdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=qm+oX+JQzV56QUtwpMbMoKGf+j/HM4yHTB8cqsstqTg=;
        b=DWcrOFVmYggAjr3h96i6lUX6auT7aTUaiVmfAxj3xQ07+dTwcSC9wuUxRgxXFNNjdM
         vHLwFjcTP0483cCQ93Q4nTZdDXs15RXkEk37Q8YnSQdMH+hT43QrEav4RQWokEyV8B1q
         gusFAQMf0KuKXAve03TJSD16f0FyQQS7+XK7nC9PCRCXbSj5He8sDrhsDGq4mNuUWJLE
         O6G4U17qlG1e2rfJ/Bal4RVLLXhHJ4znLfw2SlNr1V+Gwj9AQTZHqJV/kx4xfPiXxqOJ
         FqGiKP+Y71w12rexf58Ee9x/miieyvOcGSnJAwoZj1/CPq/sVl/w2wLuN9qsYpHAtB+I
         fizQ==
X-Gm-Message-State: AOAM532VtRLaLwxZLBsl5RK03+/70WatKS5WiBfu8X3lqiYqLLQSC7x+
        oDdpo3jTekiXIYDBGUo1NWQ=
X-Google-Smtp-Source: ABdhPJxTJl/mAPYn1Zj+USIzItK0bT9+uv/88xJzEVVK2p+GeSYUecA0nOyh7z47J+f44eSXz1U2GA==
X-Received: by 2002:ad4:4725:: with SMTP id l5mr1394050qvz.120.1591760605788;
        Tue, 09 Jun 2020 20:43:25 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:29ac:7979:1e2e:c67b])
        by smtp.googlemail.com with ESMTPSA id p13sm11195403qke.135.2020.06.09.20.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 20:43:25 -0700 (PDT)
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
Date:   Tue,  9 Jun 2020 23:43:00 -0400
Message-Id: <20200610034314.9290-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

The bpf_prog is being checked for !NULL after uml_kmalloc but
later its used directly for example: 
bpf_prog->filter = bpf and is also later returned upon success.
Fix this, do a NULL check and return right away.

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

