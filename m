Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC594116A9
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhITORr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240226AbhITORa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A88C061574;
        Mon, 20 Sep 2021 07:16:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so65679pjv.1;
        Mon, 20 Sep 2021 07:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K7x3S/edhEU5r9uoGNmxaTm92F+PqX19nR/7ykkGglg=;
        b=fuBp9jv+JURwurvOUDLwA6o0GxFgYDIsN/etNRgmgpT3o7Q/SirN7VhfVFhNChY21T
         CI1QpLOG768JVmGiCeXo6eSmxqrAT0EWzOjPLVWwBSBb8vAv8KUbQaHV69rb3yy0MOTF
         it9nezDRNz40Pku7F8n2ScwWwvdvTaTZH/wfsl4Al1gWW8Nl2HI8cekQHnIUP/vh4yOB
         Z0Hja+TSZsptGElJrTYwI0fuYIPirnkAHqdOSORMMOUmbCuSV826daOYrqR65cRd7VLX
         JBI6CxI7YI/7OekDhy7Ml9b9dOfXeQ9z3VDm1kWcducZSpD1L2S7YxNj1pFXVZp3Vzw6
         spsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K7x3S/edhEU5r9uoGNmxaTm92F+PqX19nR/7ykkGglg=;
        b=CDPz32DIRG/IaTFZhIc6eXQPUvIPjt5aATgNFK43xYSE0zA7o8SW3B0RUwgh4J9a9C
         NTW1RGCnTHfUGONhBgq13TskGt+foTrt3Oj52U2ojfYbuQfqBvUFCpbT8ACBMOZ/zv5d
         iNDL5UMRereM1rqK/3OXWi2UfVXXic6oGKc+yLqwrGTeyfdTizlFsaqTc6x41Ok3WDLx
         TAtiZv2UrlaqF+AYfxJeW9FK7lObMh6jPC/Mbg0ymhDmSw33ECHD9D2hTS4Hs2f/X5fp
         WiFrD8bRSMg3dznMz4d0PpqgnKOQOdQQvTqCtDX9RSxmuVpY15baZCDOnzho9SWF37Bc
         IQLQ==
X-Gm-Message-State: AOAM531I22Avtp/Sml9xoyy2l1PAhz1F+X03iD5xG0KyYmG+XClIPKtb
        uiOA/YtxybEEPGaXC7fnfjqnB1zsej/GSw==
X-Google-Smtp-Source: ABdhPJyM2hs5Hzmn5hvwanP1i7pK+bbF9qROsfAGsMji35mKpoHc9L+KupD4ADwnbz0Kca63DVpaCA==
X-Received: by 2002:a17:902:bb17:b0:13b:963f:1461 with SMTP id im23-20020a170902bb1700b0013b963f1461mr22767827plb.1.1632147363111;
        Mon, 20 Sep 2021 07:16:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id x10sm18586622pjv.57.2021.09.20.07.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:16:02 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 10/11] libbpf: Fix skel_internal.h to set errno on loader retval < 0
Date:   Mon, 20 Sep 2021 19:45:25 +0530
Message-Id: <20210920141526.3940002-11-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1647; h=from:subject; bh=XTsRc9MfA1L0L3BTBN2MpE1xShjQT7waFGJZvT5D87k=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaEu3/m7R2K7Iat77LPkHL7ZMvQAdSGhwZduHkF eIDwXkaJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8RyhPxEA DBbNmCBBeAgV+ye+66dbRjP9TUTIbEKhZ6wPUpon4zQF3+yNjHahfG0z4j1ai+FSx1XHZ9mbHphmth 3lX2kZE48WHdbAlEtMiHo0G3tkaOTBZUToY/d92OMZdvIkOECLAQ8wPmHt16UjYMcuC+wLmGWqp4bU /qGZDl1BcCZafxIxwVbF7560EYZfVpY7r7kEbOG29Gmwn4VIrTBN78xIj8Sk/5HGgSd55lXlQReEzZ HmT5nSm1AhqPmOe65KBKWPl2JWAroXQHDW+f1cNGHlFDTNUtXPAIDrXNpn3u/LU3u+MMx4F6m2wr6I DkTIAjfFUiPCQMi/t1si4cSS9qiSl6OEAYbFKnVJeg9MmltGIrl2Wx3gmm3uO6ZS8zlLACNevf4t38 Ljsa40ADBmw67qryKZMZWnUkGQtm6x+hhsu2Trx2VEWM9irydPgS4JAWKmqEbXF83CisBVNnebdESl PtIkLWXE0Hj5AOTkGD6UWbwSmtHnF/CUmXYiYbQWFc+oV3x2lM7J5fGXice4sv5EMYOaE9cMZjKms/ q79CDZWiew58jzwHOg2/a7ZWEe7pgJBFd36W0OzX3oTupUPl8LL1rXNwNPPkA/x4NvfSkKQ8Mkuoep aeqJsbGoC28mnpaAhqhtznzYLfI3sTHk1H+3I1Mf9z6NdzlZ72eIoKnIAHXA==
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
index 6c0f0adfd42f..c7eb88040d6b 100644
--- a/tools/lib/bpf/skel_internal.h
+++ b/tools/lib/bpf/skel_internal.h
@@ -116,10 +116,12 @@ static inline int bpf_load_and_run(struct bpf_load_and_run_opts *opts)
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

