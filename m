Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686251B1A61
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 02:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgDUAFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 20:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725550AbgDUAFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 20:05:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA41AC061A0E;
        Mon, 20 Apr 2020 17:05:44 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x26so5903232pgc.10;
        Mon, 20 Apr 2020 17:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FjahJdZE9iR86DIDyS218xJCHW4+V8kayFdotsKoA28=;
        b=aglb5ltIMj4UO6SKafF0trbox2c/ip2J3fFlV/gxQsxTLjfloGUJdSCxdk05at2Uca
         pukmQ4V5IecSr55c4+sMABQzwPYUrFvcEagQxl4g4p+xf99JvTkphe/ghun9BjADdirq
         D5yMv9tv2n6IR+9WmEt1Ld3rJ8eYGNvG2pj/LEPqN+saGdUHVD1RjWUui5vnPIc9biNP
         gjQALzum+3jBSz49oXfckL3glLI/b5XcI8a6s9XS/jlJM0EvYoNdysKH2nAhbo0MqbOS
         sLF+c21TFcFmhr9qY0YYIgCl7oO13H54sFexCupPZdeTIL2p5ceLtn78OPezZEiWFFnP
         1zrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FjahJdZE9iR86DIDyS218xJCHW4+V8kayFdotsKoA28=;
        b=oaWrrNj3vhd2F0cGeBOR9z/7//3aC/UXkAiLqOyCEmMf0+BXrx9eRPBMgWyKD9B902
         dXMurO9bOh1pAsk6rOkScRUlfcGT56Qa+7dA8oaUZZbLnphYwv1fQ+qoGDmhW6LHaqyx
         om3BEGWxPraO0T6Onq+qr9SpHIGKgpa9qxwTiV5dsvVNaQI/n+RE/xtNxplzQOEs2nO4
         PGL84GeOhNlP5p2uA6q5Nf4U2dH+RwFb7+h6PdVMj3U6XkuiXF4r2LF6Tlb3DqbLxN9L
         FfS5vtMFjEuf04PoZPymwRodTwt77+AAzZXrz+bi4kmXODwLP5afKNP8wvvXjSKtpz+G
         FhSg==
X-Gm-Message-State: AGi0PuZgNSGWQ6EN+6SsbGvYEB8Lh2ChAsZwY0xI8lliFM6MRp0y0CUI
        XUAwhvlYs7iK+bXS8iyP+IY=
X-Google-Smtp-Source: APiQypJUp9fRRicYjOq3/SjTYKGSNIHhZG3Ccn0nnEat9igP8Z3FshczI32fU2OHdXwz80o4dFWgkg==
X-Received: by 2002:a63:f13:: with SMTP id e19mr18240230pgl.135.1587427544262;
        Mon, 20 Apr 2020 17:05:44 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id n30sm639508pfq.88.2020.04.20.17.05.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2020 17:05:43 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next] bpf_helpers.h: Add note for building with vmlinux.h or linux/types.h
Date:   Tue, 21 Apr 2020 09:05:27 +0900
Message-Id: <1587427527-29399-1-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following error was shown when a bpf program was compiled without
vmlinux.h auto-generated from BTF:

 # clang -I./linux/tools/lib/ -I/lib/modules/$(uname -r)/build/include/ \
   -O2 -Wall -target bpf -emit-llvm -c bpf_prog.c -o bpf_prog.bc
 ...
 In file included from linux/tools/lib/bpf/bpf_helpers.h:5:
 linux/tools/lib/bpf/bpf_helper_defs.h:56:82: error: unknown type name '__u64'
 ...

It seems that bpf programs are intended for being built together with
the vmlinux.h (which will have all the __u64 and other typedefs). But
users may mistakenly think "include <linux/types.h>" is missing
because the vmlinux.h is not common for non-bpf developers. IMO, an
explicit comment therefore should be added to bpf_helpers.h as this
patch shows.

Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 tools/lib/bpf/bpf_helpers.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
index f69cc208778a..60aad054eea1 100644
--- a/tools/lib/bpf/bpf_helpers.h
+++ b/tools/lib/bpf/bpf_helpers.h
@@ -2,6 +2,12 @@
 #ifndef __BPF_HELPERS__
 #define __BPF_HELPERS__
 
+/*
+ * Note that bpf programs need to include either
+ * vmlinux.h (auto-generated from BTF) or linux/types.h
+ * in advance since bpf_helper_defs.h uses such types
+ * as __u64.
+ */
 #include "bpf_helper_defs.h"
 
 #define __uint(name, val) int (*name)[val]
-- 
2.24.1

