Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C58E339934
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhCLVoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbhCLVnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 16:43:53 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70F6C061574;
        Fri, 12 Mar 2021 13:43:52 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id t18so5784201pjs.3;
        Fri, 12 Mar 2021 13:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=THf+Q27rCE5bAqT61RxqjUfzIMw5JhYn8NNtx0p14fg=;
        b=WiHXeodK/wol85oDmp7yWl+34nzWFLLznfcL4ts+vBP6cg2Py3p4BieaEbNbDTe6om
         xkRVMLslLYumR2uzSl78EdTI8MsgzfYtMNPrOXE/SWeFNA4zcrufbk5yk3ZK/uytmFfk
         wq4sgh5mkTgrYox0bpP+WB3IvJKnTO+AzctCuG9GzUbfdrwBgd3K+wLtZ4sWMjvZssa6
         /xsIvLMuWh9TUa4OGYX6GQJx4UB3I2NJ1Ksajt1xjKmPTSMcldIl7IDIz+ZkwoVqhXAn
         2X0O6w79P2l3F5KxyrbWoZWrXcfpRYIz7RJFUIEcJXwdBoBi0g4ZaHeHowiy4re1GO8H
         PvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=THf+Q27rCE5bAqT61RxqjUfzIMw5JhYn8NNtx0p14fg=;
        b=LxY92C9cir5N9cLtm+aNVVwOCG+BFmbq1BrtwxzWi6qKQJ/uPvhR2KfZmMS+rwNOKA
         M+gfZ2b8sQotAz9padBDfrdF0Y8KW0VW+nAZl88xcMgRT/StMnkwUHMpeCvOG/g9GQFB
         tTLZvcHrA6f4V9yahRGbQulf7/JRiaCO4NK+l5SJEEUYsfcpczHa0ndaJX5lZ9eEoH7N
         uPE3Frq2sDXr+6Gbq5dDmrwb+nRtSZIm1tp9hkgwrYrba07RAlPzIZMQUTFiYPc5lX42
         7H41s8/srGUD6JwJseb1QOHxf2qFthicU88LYHHNXl39xtpPsB2SeFnNXSMkTeZdbHGl
         jfcA==
X-Gm-Message-State: AOAM531mhg0c9fEJVWiMytH+YdVnoOcD+9NiKkl3EyQgxQtaRz9cUu3f
        GQBXI4oUufJJ4czJeWPOseVT0XkJPWZLRw==
X-Google-Smtp-Source: ABdhPJz6w93PgiD066C/BiK3t9o/2rLknMqYdxlQkTKKQWq+fqnlBPZd4bUmpUG9Ddoh9NsZbtsVvA==
X-Received: by 2002:a17:902:bd96:b029:e6:3d73:f90e with SMTP id q22-20020a170902bd96b02900e63d73f90emr480048pls.63.1615585432536;
        Fri, 12 Mar 2021 13:43:52 -0800 (PST)
Received: from sultan-box.localdomain (static-198-54-131-119.cust.tzulo.com. [198.54.131.119])
        by smtp.gmail.com with ESMTPSA id e63sm6276094pfe.208.2021.03.12.13.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:43:52 -0800 (PST)
Sender: Sultan Alsawaf <sultan.kerneltoast@gmail.com>
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libbpf: Use the correct fd when attaching to perf events
Date:   Fri, 12 Mar 2021 13:43:15 -0800
Message-Id: <20210312214316.132993-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

We should be using the program fd here, not the perf event fd.

Fixes: 63f2f5ee856ba ("libbpf: add ability to attach/detach BPF program to perf event")
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d43cc3f29dae..3d20d57d4af5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9538,7 +9538,7 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 	if (!link)
 		return ERR_PTR(-ENOMEM);
 	link->detach = &bpf_link__detach_perf_event;
-	link->fd = pfd;
+	link->fd = prog_fd;
 
 	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
 		err = -errno;
-- 
2.30.2

