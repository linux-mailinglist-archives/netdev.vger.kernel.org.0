Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BEF27BA7F
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbgI2BvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 21:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2BvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 21:51:05 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF2BC061755;
        Mon, 28 Sep 2020 18:51:05 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id u25so2988136otq.6;
        Mon, 28 Sep 2020 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=tM8zjJsAghQJ98yc22ypIrMNj2htX80FZZ2dOxMvvH0=;
        b=Ld/uOrBTPbEM5hjbgzUO5VstYd/oYuQHQpbsDUInCCyQ64VhAVCTpXHKstBCQy61EU
         D1ga/l63sORsia9A3yxJwmg8y1JQnrOsxZtnVWRt8mkgaREA7CjtzaYVHBZWphrRoj7w
         xC1kCQZQQMuBMCSug2HbNVXjPRRZItVgZLXHogwS1iMfW/fFq3K6oiKim2DLsP0XsTHd
         uAjcuvBremRwvub/ktOTMiRukiKF+8jW9lglLCCKG1HF3XhDIY/ETXhIB1SoxXMGqHZX
         st3TWyFYK0q+DeufETies0cZGdwheSi4rc+vVCBj8L6eGJBF8nbMoU3VZurdR+FXA9KA
         9Nyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=tM8zjJsAghQJ98yc22ypIrMNj2htX80FZZ2dOxMvvH0=;
        b=I7SiaCzkGhPxQUrIyU7Sv/kFE9WBNZzo03IGSwlmjQwCxblfriKsNu1/UOhsCaaxZy
         LILLjHQPUW0aD4KjrbpBk2uLZKam4phUdsauFw2WRd6tRwGORLifyIXOXecM5qqxlVXF
         lNF+or9Cxg90nJiXUv4+cf+keKihv5Xt7IQkWJc2TPjTOcSyC70bVCVZSOFqTDPMct4d
         cQjxHyfGu+YJcrnZMHEAFF15kcd1oU+AGgSPNE7v9G+5qVq2rIIlaeELFOLE8X5E1oEw
         jOzHW4oqmJ7ZymFa2QUEbHBuw1Qytg6+1FkHdEplwjz0QpOy2C6g/Jeudpp/X9VkwLH2
         sCsQ==
X-Gm-Message-State: AOAM533+SiCp9abqTXQeVAh+K5hB8FpLmg4prHS4DfvjhzWjUnIrmMtv
        svEyt9Sha3fALQSNuMHmMaU=
X-Google-Smtp-Source: ABdhPJyOHIb9Rx7btwYjPAOFfMbOKL/BqxQKVwchUZiBCo/5toBNt+t015kubxnxMecgXns0syDvDw==
X-Received: by 2002:a05:6830:10ca:: with SMTP id z10mr1263665oto.208.1601344264624;
        Mon, 28 Sep 2020 18:51:04 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id k3sm2548360oof.6.2020.09.28.18.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 18:51:03 -0700 (PDT)
Subject: [bpf-next PATCH] bpf,
 selftests: Fix cast to smaller integer type 'int' warning in raw_tp
From:   John Fastabend <john.fastabend@gmail.com>
To:     songliubraving@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 28 Sep 2020 18:50:47 -0700
Message-ID: <160134424745.11199.13841922833336698133.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix warning in bpf selftests,

progs/test_raw_tp_test_run.c:18:10: warning: cast to smaller integer type 'int' from 'struct task_struct *' [-Wpointer-to-int-cast]

Change int type cast to long to fix. Discovered with gcc-9 and llvm-11+
where llvm was recent main branch.

Fixes: 09d8ad16885ee ("selftests/bpf: Add raw_tp_test_run")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/progs/test_raw_tp_test_run.c     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c b/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
index 1521853597d7..4c63cc87b9d0 100644
--- a/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
+++ b/tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
@@ -15,7 +15,7 @@ int BPF_PROG(rename, struct task_struct *task, char *comm)
 	count++;
 	if ((__u64) task == 0x1234ULL && (__u64) comm == 0x5678ULL) {
 		on_cpu = bpf_get_smp_processor_id();
-		return (int)task + (int)comm;
+		return (long)task + (long)comm;
 	}
 
 	return 0;

