Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1473A8285
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 16:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhFOOUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhFOOR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:17:28 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BC3C0613A4
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:14:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k5so11867469pjj.1
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 07:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7lCOA+2uHcoDlHpnAPiyr08qHLnKknrRwhD42bW14c=;
        b=Q98Ihm2Nik3q5vdP0zcSt08K34vWS/rvAoSEN52J/uuTlzvnsiNq88Z5ucJKY0yf4T
         WFJOezngtVgbaHQTYK9IFHEeP7OPorUcohm0GpwG5OPARKnRlnDiuj+ZSJdIkZhENFhP
         Vq0P8aiksUKM/urNGX/K/vS0M5QV+Ai6ruEHeoTG1ZqikOBMRgtepe++5r/KmuRM0Wp7
         fQBL37D40now9tM5jNX9bzTs/tFtUeKXIWuG8uRaMPZOawdA+TREx5a2jmwy7Z5WlYma
         oneZ7pit7q6XulGSMFYPI+9TNvoTTQj76XvP+orlujxi0oRlAXS8GnDtyHjoFs7/bu4w
         pIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7lCOA+2uHcoDlHpnAPiyr08qHLnKknrRwhD42bW14c=;
        b=OMqZG/hm4LyBch9Ov2vtn1VDUTp0pVQmPshmp8WWehyzbtUoDe+5VYXnMyYaIm7rES
         LIcDkABgfqd5ohOzy8ydEeaSu3UFCPHWpTEzd41UYXg/hsvRDSG48xs5qljgBM4cpvcW
         z43M6ho2EMl3xUc/uYBJeSgp8WHc6vumR2LYZIp8bVgjqi6IS09kJ1Hry/6pOtECiBi1
         YOEJsSb/cVoRJyFnuCaXCiSVqu4DiyteY0IPpPNgkxqLNKNo67EoUFH/HfOnGeIcxVwD
         SpAiaE4XX9BfLuHUcmSj6FOFPgySXfmh+jmWZ4kRJNhmmlFavp3j640lurnHa6YiP30Z
         nXFQ==
X-Gm-Message-State: AOAM530SPumhY/WqBNFLoqypPTNwFY5XDIvaNS+4jJ0xNn9ZFgdsN4c/
        j84jkCqlr6xJtTqWVNxcZGen
X-Google-Smtp-Source: ABdhPJyMTsqXCPkyBqwNtnh8NXZihbFI2JopRQ8BKBQqq64DywQJiFaJ/V9M6qRN7G+4EeFFkHyAjg==
X-Received: by 2002:a17:90b:b18:: with SMTP id bf24mr25002261pjb.220.1623766442317;
        Tue, 15 Jun 2021 07:14:02 -0700 (PDT)
Received: from localhost ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id u13sm16031239pga.64.2021.06.15.07.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:14:01 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 02/10] file: Export receive_fd() to modules
Date:   Tue, 15 Jun 2021 22:13:23 +0800
Message-Id: <20210615141331.407-3-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210615141331.407-1-xieyongji@bytedance.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export receive_fd() so that some modules can use
it to pass file descriptor between processes without
missing any security stuffs.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 fs/file.c            | 6 ++++++
 include/linux/file.h | 7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 86dc9956af32..210e540672aa 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1134,6 +1134,12 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
 	return new_fd;
 }
 
+int receive_fd(struct file *file, unsigned int o_flags)
+{
+	return __receive_fd(file, NULL, o_flags);
+}
+EXPORT_SYMBOL_GPL(receive_fd);
+
 static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
diff --git a/include/linux/file.h b/include/linux/file.h
index 2de2e4613d7b..51e830b4fe3a 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
 
 extern int __receive_fd(struct file *file, int __user *ufd,
 			unsigned int o_flags);
+
+extern int receive_fd(struct file *file, unsigned int o_flags);
+
 static inline int receive_fd_user(struct file *file, int __user *ufd,
 				  unsigned int o_flags)
 {
@@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
 		return -EFAULT;
 	return __receive_fd(file, ufd, o_flags);
 }
-static inline int receive_fd(struct file *file, unsigned int o_flags)
-{
-	return __receive_fd(file, NULL, o_flags);
-}
 int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags);
 
 extern void flush_delayed_fput(void);
-- 
2.11.0

