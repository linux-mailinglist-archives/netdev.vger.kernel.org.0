Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC09354736
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhDETtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhDETtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 15:49:20 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486B2C061756;
        Mon,  5 Apr 2021 12:49:12 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so76685wmq.1;
        Mon, 05 Apr 2021 12:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4Yv5TTCQDxO5XD01tjK/2+OvbO6WA2NVomW+QKng34w=;
        b=dHjd0c2UwLoBATwVjRwkWNMnX/N6X/N5145A6kqBvvAoX3Be80Gv9Wr9TyONgx519K
         WjqRY6fcgdV/MfZOC8plPwcjivO2BoSc2zIgYG93YuZa+rb7Yn2w4ToaQvAd7YUEO0F1
         UbEUaZrjk74Fqd19QEVPzuWxsFNX4VdaVfNrVU1s/achNPqZhtOMxbQiaKRjZiS8QQHq
         kXGZVHOVS1E5ZvC8OkBEJemE6h8NtrVO6Oa7Fy/cNcCAiAcXI+kzh8lqei+Uhj61OphF
         CwzKp0lJuYug89uu0uLJkDZwwfA6MMjAOQY2sEriE24Anyf8CzFlJ5reS1obc8B1+jZT
         ongA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4Yv5TTCQDxO5XD01tjK/2+OvbO6WA2NVomW+QKng34w=;
        b=AENxgkiWw9sPmOF2AaJyJtpLCFBVJmEDGbMZ2/DFW5gvuCknckKSadoRQ0CAv1wq8v
         YYpth7CQjjyj6fW9NKisNdG88bB+e76td17J82Zd+hKLJKetCQrbfmW3nC2FITUTmj6s
         lQJzopTcycnBtZjb0MfhFfQP2lX2Z6TK8OxSyqDYQ8HklvoK0kj8WgkN9o10D9cR9Mlg
         Meut+aIeXZ9qInrEHY1icvk6OcEzmt2ZOJpsIXF9O7J6Qt5rx9RE/HfXQ4pL5PNEvmpY
         2/sk8CFwqyuqwvgna/cAk6LvAGlv2EcIhuPIRgb3bfdsC7kBwghGF79UHohRqujMmpV9
         NcRg==
X-Gm-Message-State: AOAM530hkx6CWV230mifohmk7w30xmquBsysryOSdIcscCMudiMXQJZK
        gd+uemy1Gcm9oA/3sUhRLL4=
X-Google-Smtp-Source: ABdhPJzZWiZGvFQ/OPU40ZbIlle2chvzd7qE3EkIxEutAvLwP7WB9xN6dmRcgMO/TqAFHmPqZNlT7A==
X-Received: by 2002:a05:600c:22d9:: with SMTP id 25mr615978wmg.108.1617652151084;
        Mon, 05 Apr 2021 12:49:11 -0700 (PDT)
Received: from LEGION ([39.46.7.73])
        by smtp.gmail.com with ESMTPSA id n7sm29474267wrv.71.2021.04.05.12.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 12:49:10 -0700 (PDT)
Date:   Tue, 6 Apr 2021 00:49:04 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        zhengyongjun3@huawei.com, dan.carpenter@oracle.com
Cc:     musamaanjum@gmail.com
Subject: [PATCH] inode: Remove second initialization of the bpf_preload_lock
Message-ID: <20210405194904.GA148013@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_preload_lock is already defined with DEFINE_MUTEX. There is no need
to initialize it again. Remove the extraneous initialization.

Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
 kernel/bpf/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 1576ff331ee4..f441d521ef77 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -816,8 +816,6 @@ static int __init bpf_init(void)
 {
 	int ret;
 
-	mutex_init(&bpf_preload_lock);
-
 	ret = sysfs_create_mount_point(fs_kobj, "bpf");
 	if (ret)
 		return ret;
-- 
2.25.1

