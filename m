Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6F324EC43
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 10:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHWIxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 04:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgHWIxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 04:53:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B566EC061573;
        Sun, 23 Aug 2020 01:53:50 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 17so3245157pfw.9;
        Sun, 23 Aug 2020 01:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+MeUX/8ocAwZp5miKCb4cpi7yIN7blyxF5dTPDawJk=;
        b=jmNrCoRFhledB7aQfUq8fYDn/Dc69PPRWzGMGDwvty+01L6jRGhbwa75OuMeV9i0+8
         /cUWtLjFXEvyO+jGLWct5bF8Z8RAFHttiIsExFQ3bTbPAo/6tQ2MHalU17Sf46OSPOoZ
         VmEy76DV5FXxrmquCn6wAfV/4dAfKxt3AzqOIkP7R5cMYaoFFWxf5DcQpOMcp7H4XWBg
         DPw7oJ+x29U5GgzA8KhrG0q3Lbcvp2Te8Ncm8w1NSvz3OEEkcynOOrlNAtacRxL0owJW
         euA3qBvvIT3E5pBZs84sx3NUCns1n5Be+z8WiToHf7AE2FGNS7Y/xEDxL6PRlpROzft5
         nH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h+MeUX/8ocAwZp5miKCb4cpi7yIN7blyxF5dTPDawJk=;
        b=jweP0EsyGFOQeY/kSjNg2u9d9bwc/404T2YzLaDMBLN9RLKSfwU32ak6tvKHCc01h8
         neTg1TFka0nHAzponKWDWcZWXk1PhM8LrXvGBZsrUDIaxko0TSRUSePQvuQi8G4mrOlU
         fb+LLi1KmCMDeYutPjySYDQ00mC0DVhH+UcPSU6Mm0PYmSBAyzukBTdx8zKlqegrpDdA
         684zkpi+Z2paSlprSOSS9HHFqgWjtqkC63iE0KUquwSqfzoG5FeVGs+k8AE2WVR+dF2u
         7MCXEK8UVnDz49+cstqemQRFWkPuiyVX8fyfsczoGmcjNqTiEj0jMThtMHQffAdvvnry
         v6/A==
X-Gm-Message-State: AOAM532CNHsDkyUq+wKHJWnZ+FkOWXtv5AylnMolyWlY0OiFZLlT65dL
        hS/jeh9lHtn9bHrO0o0utQ==
X-Google-Smtp-Source: ABdhPJx6LLPuOSnjwF12Aqksthptbid7+RCW+aN/qEkDbg4ki0nccGNBZzE313CdRdTsCWWi9v26eQ==
X-Received: by 2002:a62:15:: with SMTP id 21mr194934pfa.41.1598172827200;
        Sun, 23 Aug 2020 01:53:47 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b15sm6128446pgk.14.2020.08.23.01.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2020 01:53:46 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/3] samples: bpf: cleanup bpf_load.o from Makefile
Date:   Sun, 23 Aug 2020 17:53:32 +0900
Message-Id: <20200823085334.9413-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200823085334.9413-1-danieltimlee@gmail.com>
References: <20200823085334.9413-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit cc7f641d637b ("samples: bpf: Refactor BPF map performance
test with libbpf") has ommited the removal of bpf_load.o from Makefile,
this commit removes the bpf_load.o rule for targets where bpf_load.o is
not used.

Fixes: cc7f641d637b ("samples: bpf: Refactor BPF map performance test with libbpf")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f87ee02073ba..0cac89230c6d 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -76,7 +76,7 @@ trace_output-objs := bpf_load.o trace_output_user.o $(TRACE_HELPERS)
 lathist-objs := bpf_load.o lathist_user.o
 offwaketime-objs := bpf_load.o offwaketime_user.o $(TRACE_HELPERS)
 spintest-objs := bpf_load.o spintest_user.o $(TRACE_HELPERS)
-map_perf_test-objs := bpf_load.o map_perf_test_user.o
+map_perf_test-objs := map_perf_test_user.o
 test_overhead-objs := bpf_load.o test_overhead_user.o
 test_cgrp2_array_pin-objs := test_cgrp2_array_pin.o
 test_cgrp2_attach-objs := test_cgrp2_attach.o
-- 
2.25.1

