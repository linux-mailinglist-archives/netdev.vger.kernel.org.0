Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68547419700
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbhI0PCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234996AbhI0PCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:02:02 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DBEC061740;
        Mon, 27 Sep 2021 08:00:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id s75so1540117pgs.5;
        Mon, 27 Sep 2021 08:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HAo200QE9/huK+nWNKe5juvI7U/KIFLH0A3znfnQYDM=;
        b=G4uzPoyz5U7he4rqhKyzV9PdfXoNM1wZUs9RQGDfCHDLwAzq/vYuMWIBC39lPiDEzY
         GfA2kFxAnm2afuHzfq19koDb0fCItoQ9fdYdixMtSBnkW1d0UW0xB+NzUpolJbMQx2DI
         oYi03lP7Trn0sMQBjao+lbE6Ro9rG+5HnsAyU6UUqoaF96FNddLEWS85DGzPrxsA0Hzz
         GiQa7ZXaOBDd0mSibtEvYgQok9OKVX4ZFjxRa1uSYvaqb8wY/pUrR3Eus3XzvN0cgY85
         dJAEYlba6JhZ/TywAcziGWSZT7lA3BoVgMUqbt0xLJHQDBv4WO3xWYhFppNhv7lFtDky
         xLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HAo200QE9/huK+nWNKe5juvI7U/KIFLH0A3znfnQYDM=;
        b=olBX06XC+eZxmTc3Ty6UqAwX2gYZFMpWDlKYcbgHi4hZQ3lAfGvJI6WCvwvkSycpGF
         AsP6At5t2oxzcapyM+pJ7wAOvosRUYrkYhDJRkARwnLqIkQWJlZI6PkdrPKjJzihLSkO
         LdyUxbdmnPb5DCLVpMxu/ET3pxk2Ds1YBFn4fknwdZQd+5wvwQ5eobnUUkksHu2rh9IJ
         PdfK1z3mpI4OwpTkcZnImpt1ZLo+CGaW4s2YDxkcSjkKHvY0N69iAMneOkteYVmf/9pY
         RYbs1cPmdz4N9TA3ki9MV90khLdpwbKQfY42mIwEUPAgr81FUOGuOr0MEe28WRlke1ms
         H89Q==
X-Gm-Message-State: AOAM533zna6GetSJh8gRNvkXO5aCDyEZmUrYwOuUBfOl7kNguuRlsRO6
        hlrppR7p8KYvhYSWlGu9nzOpc45GYRo=
X-Google-Smtp-Source: ABdhPJyqk7wr4DiStlyvCNzbEhOxLauKxA0qxSBVRSKDs33S0cxej4mdoOkpEvKpy6Ril6TGG/cksA==
X-Received: by 2002:a62:2587:0:b0:44b:2d81:8520 with SMTP id l129-20020a622587000000b0044b2d818520mr100916pfl.43.1632754817176;
        Mon, 27 Sep 2021 08:00:17 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id x13sm17450357pfp.133.2021.09.27.08.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 08:00:16 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 10/12] libbpf: Fix skel_internal.h to set errno on loader retval < 0
Date:   Mon, 27 Sep 2021 20:29:39 +0530
Message-Id: <20210927145941.1383001-11-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1647; h=from:subject; bh=PVTKS+rfPpxdSU9d74iSymeJVwfhEWVxpXAvuJFJ9qs=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxPrACVEi7CiY1lhZ+7KHtZuFVP74ebqAo6CHjW 2E6erlWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTwAKCRBM4MiGSL8RyvLkD/ 44fEfgf6NG+0oe9IJLBj4cCxNZ5Zsfu2h0U4i2h24cw6PYDoSzrGjwvnMRsEDfUQliloPhwU5zT/zI J+U6jFNkxQ1WfCKksOHKbDaiGdWHxFAr9OzqQuIs6JD5Dvla9FntOa/aCPP2eAl54gd2E0NOt9li+J g2phHQhrofK690XQJRmb5302zDf/fHa6LX+nefl8bxVRWQuYx4zSOsEy7lHYqtXyHwTEPYrEBf43Wt +IoRpkWeEM88z2ciLkeQhMhghXtI4kvCX4+uMwgpNDQ5mthpV1Ch+PaPZAmYcMqlD5x2c3938ZIRdA YC5Sf2iTpN++d9CC239Io112EAW0cahlQw9GlI9uFJR9bITdb5BrYeisJveOOphy8JAbEd7zCHDkDa iiu8Ue3uKDvJry6VY2baeOzYYOnNfH3PtjIwqgywDoPfVATRyp3FskJFLgYvNcx9LW5b+yGHyqOf9P Dy/te3xFSEeMEb28PcM7DJBuJ7TuUz+V8c9qDSziXB2WbwO3cbpiXmiOjPxZpLp/vmGAgsw5ebUzAP /7sMP49qhEmUwI175tqWGG86CrmA7Lg15Yl3pf9FUQYNf63AtaR/JdoX74UOpQOeqmejyKL6s547+o yTNpLlfMic+rl43Fuuvp0Drk0rPhKm6xi6oRUs31gLlfX4VlEc+IpazALcqg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the loader indicates an internal error (result of a checked bpf
system call), it returns the result in attr.test.retval. However, tests
that rely on ASSERT_OK_PTR on NULL (returned from light skeleton) may
miss that NULL denotes an error if errno is set to 0. This would result
in skel pointer being NULL, while ASSERT_OK_PTR returning 1, leading to
a SEGV on dereference of skel, because libbpf_get_error relies on the
assumption that errno is always set in case of error for ptr == NULL.

In particular, this was observed for the ksyms_module test. When
executed using `./test_progs -t ksyms`, prior tests manipulated errno
and the test didn't crash when it failed at ksyms_module load, while
using `./test_progs -t ksyms_module` crashed due to errno being
untouched.

Fixes: 67234743736a (libbpf: Generate loader program out of BPF ELF file.)
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/skel_internal.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
index b22b50c1b173..9cf66702fa8d 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -105,10 +105,12 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
 	err = skel_sys_bpf(BPF_PROG_RUN, &attr, sizeof(attr));
 	if (err < 0 || (int)attr.test.retval < 0) {
 		opts->errstr = "failed to execute loader prog";
-		if (err < 0)
+		if (err < 0) {
 			err = -errno;
-		else
+		} else {
 			err = (int)attr.test.retval;
+			errno = -err;
+		}
 		goto out;
 	}
 	err = 0;
-- 
2.33.0

