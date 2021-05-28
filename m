Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3503A3947A1
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbhE1UCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhE1UCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 16:02:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE40C061760;
        Fri, 28 May 2021 13:00:47 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so3142787pjb.2;
        Fri, 28 May 2021 13:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8W3zm3RiRStrXJZJXTCOkCwj1KgZnGiw4eoiXvnO8gE=;
        b=E/eJs2sjoCRMwpIwp7Y40g3yLi4E71b+EHcYTXkD2fIEV+BTu5qyhVYjZBPThTh4ct
         49YxbOlIKAcNjh/udv7PtzMX35DJd7Qb+HbtOACL7MBzZu+9/Tm+MlZGd+YucAC6Nk0d
         bITrp7ki8EsnhIq0Rb9UhR6LIMAFxjgKs2BFBBl19VTfexQ1aoAuK/766E6YuWKMBx2K
         1bATCEr10CD6p6bQBbYLJvekhmwlz5UfcxYYHhcyW7n1CevzE8JqOQgVnQkuhqNblb/v
         pDBjRgXZwJXeQiLcOPtdgrdvOtvBGK9YNLL0JN/QouIirpo2Nie4j+ZpHBV0frFXfnOF
         O6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8W3zm3RiRStrXJZJXTCOkCwj1KgZnGiw4eoiXvnO8gE=;
        b=RHa9bPffIaDowxMi3PepeXXhZ22tLTU8uMpWd5tKCOjN3Rq42qvzmuJlvNlWkMSDBP
         9L6QhAA0ngHgauoPqcvwkBWsqP6mJY5EYiFwgK5P0GmFVkdw4OUqoqbN1wLb9sLqOpTg
         YRFjFRN4D9sFR0rIJsg/8PmCDFtco74aNhpOuQrDyEa7m5mDn6rQ0YLxmrMeBXuGOfAR
         K+6p04iDlnmIvdcxCDluEo29qLYTzxy9Ox36gYGZbRiICn1iVA5SmRwYeDBDjS9xBJWC
         xEaTb+ItrP3R1awbiimWuBgDs+hrKZRFeJ3i8vElmEdxZ7AWux0wy1nKA4+UzzmhkenG
         Tpvw==
X-Gm-Message-State: AOAM530qgYKUXHPMF6xm1hbwVcAAmUhVEYAy3xTEHDDgF79QGpcNmvg4
        d67krhG5YWiJBq6gKYJ1oXlCiAC2wYE=
X-Google-Smtp-Source: ABdhPJwQukKAQv7GjTb7n9L5Q7wnBH+1CUDoMqdtL1YKYzdy9A1XI8kA+vqESQ2HUSMg2880jj5WnA==
X-Received: by 2002:a17:902:ecc5:b029:ff:82eb:2fb2 with SMTP id a5-20020a170902ecc5b02900ff82eb2fb2mr7162244plh.50.1622232046549;
        Fri, 28 May 2021 13:00:46 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id w197sm4997277pfc.5.2021.05.28.13.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 13:00:46 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 2/7] bpf: export bpf_link functions for modules
Date:   Sat, 29 May 2021 01:29:41 +0530
Message-Id: <20210528195946.2375109-3-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528195946.2375109-1-memxor@gmail.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are required in a subsequent patch to implement the bpf_link
command for cls_bpf. Since the bpf_link object is tied to the
cls_bpf_prog object, it has to be initialized and managed from inside
the module.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 kernel/bpf/syscall.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 50457019da27..e5934b748ced 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2338,6 +2338,7 @@ void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
 	link->ops = ops;
 	link->prog = prog;
 }
+EXPORT_SYMBOL_GPL(bpf_link_init);
 
 static void bpf_link_free_id(int id)
 {
@@ -2363,6 +2364,7 @@ void bpf_link_cleanup(struct bpf_link_primer *primer)
 	fput(primer->file);
 	put_unused_fd(primer->fd);
 }
+EXPORT_SYMBOL_GPL(bpf_link_cleanup);
 
 void bpf_link_inc(struct bpf_link *link)
 {
@@ -2510,6 +2512,7 @@ int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer)
 	primer->id = id;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(bpf_link_prime);
 
 int bpf_link_settle(struct bpf_link_primer *primer)
 {
@@ -2522,6 +2525,7 @@ int bpf_link_settle(struct bpf_link_primer *primer)
 	/* pass through installed FD */
 	return primer->fd;
 }
+EXPORT_SYMBOL_GPL(bpf_link_settle);
 
 int bpf_link_new_fd(struct bpf_link *link)
 {
-- 
2.31.1

