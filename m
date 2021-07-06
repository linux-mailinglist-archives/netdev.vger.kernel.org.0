Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DAD3BC483
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 03:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhGFBOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 21:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhGFBOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 21:14:36 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF51C061574;
        Mon,  5 Jul 2021 18:11:58 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso896708pjp.5;
        Mon, 05 Jul 2021 18:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NwQaLt08jBec11KMF4e1SB6lInafR9MTNHkp/3GAlCs=;
        b=GrH7hbBZRjhmUoQzTYxVhnvJrgTf6HEZuivxzAFryLBr+X+CbRKtUf0W4ybY+myvtc
         sh+IvumMoC8jOMd/iaFUBaJj2JK5QJqd2nHYthE2Mbj0XQ2lZdyg5UoYliOT+gC064at
         FJtsxcQk3V6in/tiOY36+CqYpQS1ngOkdobFQwX2NdPRBtXY66JWP4nAHnv+9qlIzFVu
         jntzgNiRwql5L6++9YGAsjdPpwb9vb02QEuu8d09qpY2LZ53Z8cnRGo5Qkanr5K8a2bb
         Btf3/rp5VzC7jgC7ZxU02+TYGUaGdtKZY62GnqjxIez6rxevnD2fPW04Xpy5F7QBGcjO
         QD5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NwQaLt08jBec11KMF4e1SB6lInafR9MTNHkp/3GAlCs=;
        b=iijGrmtJBo0efwHYYfGV1BxN9eRbndGvGTi0nfa1b+LjCy4Da7PdcW0SULcXF+v3/6
         NUFISz94WAoWE1cwmrfKRlGue7CFdta6k/wXBh8fK6wwVUd4mb9t/7mdLKzz8Mul8W7o
         1HlflDl2f8/YdB4V/RKrfElqLBUXzZidp5z5ghx04+EnWSqcPSg8GRGoSWqIDkOaDWrW
         55F5wAEeJg9fnEZxLWLjnzth7Y8R5hwPIgj4XdrxZOg80CTXaCPYVielZjaRZ7lEVOzx
         o905zeVSKh6jzfqnUqplCODCvdMWUFVwT/ZwUWOhKFgzhhTXnKkyQQEjQC4kLSyNwNBZ
         VqZA==
X-Gm-Message-State: AOAM533seO2fEOYvzy2MDzB7F5YqOc01xhABRccs3tVdb+rqRc8yyAM8
        BxK9D4cJ8fNLVRIToG5Tzps=
X-Google-Smtp-Source: ABdhPJxyVBLkpgGVc/tcOrtl50EC8uoGSyLEDjcPeC7u5xbnkGWbldxhnRLLRWu2eDHWgIkL8CZNiA==
X-Received: by 2002:a17:903:2341:b029:129:33d3:60ee with SMTP id c1-20020a1709032341b029012933d360eemr14771858plh.66.1625533918176;
        Mon, 05 Jul 2021 18:11:58 -0700 (PDT)
Received: from ubuntu.localdomain ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id o16sm9017810pjw.51.2021.07.05.18.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 18:11:57 -0700 (PDT)
From:   gushengxian <gushengxian507419@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>
Subject: [PATCH v2] tools: bpftool: close va_list 'ap' by va_end()
Date:   Mon,  5 Jul 2021 18:11:50 -0700
Message-Id: <20210706011150.670544-1-gushengxian507419@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

va_list 'ap' was opened but not closed by va_end(). It should be
closed by va_end() before return.

According to suggestion of Daniel Borkmann <daniel@iogearbox.net>.
Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 tools/bpf/bpftool/jit_disasm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index e7e7eee9f172..24734f2249d6 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -43,11 +43,13 @@ static int fprintf_json(void *out, const char *fmt, ...)
 {
 	va_list ap;
 	char *s;
+	int err;
 
 	va_start(ap, fmt);
-	if (vasprintf(&s, fmt, ap) < 0)
-		return -1;
+	err = vasprintf(&s, fmt, ap);
 	va_end(ap);
+	if (err < 0)
+		return -1;
 
 	if (!oper_count) {
 		int i;
-- 
2.25.1

