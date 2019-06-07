Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E53382CE
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 04:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfFGCjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 22:39:36 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:36088 "EHLO
        omr2.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726305AbfFGCjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 22:39:36 -0400
Received: from mr6.cc.vt.edu (mr6.cc.vt.edu [IPv6:2607:b400:92:8500:0:af:2d00:4488])
        by omr2.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x572dY1Q004417
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 22:39:34 -0400
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
        by mr6.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x572dTBD002800
        for <netdev@vger.kernel.org>; Thu, 6 Jun 2019 22:39:34 -0400
Received: by mail-qk1-f198.google.com with SMTP id n77so392025qke.17
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 19:39:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=MIgX3bW8bMehQLcxyRePAGOb6AOeg7AcYjxnuIEF0bs=;
        b=MapxufFBsIVaKBaQOGTQ23/IEAq3DdbrZUZxJPBxp8vcG8aaPxQqj/I+Mem0KFutVU
         ncwRX0MI8nnJbM5NOb05i11d2d4IosWcnSJPFIgo1sF8Lm8t/0tpP2TRAJO2C/vygUR5
         PW84raB6q+oRQOQspdCWtVREm5QL1ygXiHAkmtPsj0fYRqd6OLMbzfCw8xd9yNk686s7
         eCddKSMziutp356UP32jHt/zjmX0SckP38O6V2UedxrRISHTCMCoSJUAIFxkVrHnCiri
         UIdDLcBe+/wI7jPBQ+slTYe7szRHcKZq1UvHtDGhZ2T7Kw2Alnulw7Bgk6/GPqRdh3DC
         slcg==
X-Gm-Message-State: APjAAAUnwwRPUPoCMoypO1FPF3fMpT3walE8y9iLsq5/V7XhEPfqEqnw
        iOaDJT4Ks/t9TM+X9yGrLkrF3vUlRJWp9uZjw0UQxHn6+oVTbUL02WGDScmqXPbN7RcQMogZLdL
        s9BZlIatO9QMVDlFMId48Mc0u0ZE=
X-Received: by 2002:a0c:9305:: with SMTP id d5mr26392265qvd.83.1559875169632;
        Thu, 06 Jun 2019 19:39:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwWt5rtISN5eq/35zw3oL3ccJvCnXG3axMY3hRZkTPYNYF6J0BYXWGfZsmKjzD+XmnQ6xV89g==
X-Received: by 2002:a0c:9305:: with SMTP id d5mr26392255qvd.83.1559875169441;
        Thu, 06 Jun 2019 19:39:29 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::936])
        by smtp.gmail.com with ESMTPSA id c7sm350432qth.53.2019.06.06.19.39.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 19:39:28 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf/core.c - silence warning messages
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Thu, 06 Jun 2019 22:39:27 -0400
Message-ID: <29466.1559875167@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Compiling kernel/bpf/core.c with W=1 causes a flood of warnings:

kernel/bpf/core.c:1198:65: warning: initialized field overwritten [-Woverride-init]
 1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
      |                                                                 ^~~~
kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
 1087 |  INSN_3(ALU, ADD,  X),   \
      |  ^~~~~~
kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
 1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
      |   ^~~~~~~~~~~~
kernel/bpf/core.c:1198:65: note: (near initialization for 'public_insntable[12]')
 1198 | #define BPF_INSN_3_TBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = true
      |                                                                 ^~~~
kernel/bpf/core.c:1087:2: note: in expansion of macro 'BPF_INSN_3_TBL'
 1087 |  INSN_3(ALU, ADD,  X),   \
      |  ^~~~~~
kernel/bpf/core.c:1202:3: note: in expansion of macro 'BPF_INSN_MAP'
 1202 |   BPF_INSN_MAP(BPF_INSN_2_TBL, BPF_INSN_3_TBL),
      |   ^~~~~~~~~~~~

98 copies of the above.

The attached patch silences the warnings, because we *know* we're overwriting
the default initializer. That leaves bpf/core.c with only 6 other warnings,
which become more visible in comparison.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 4c2fa3ac56f6..2606665f2cb5 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -21,3 +21,4 @@ obj-$(CONFIG_CGROUP_BPF) += cgroup.o
 ifeq ($(CONFIG_INET),y)
 obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
 endif
+CFLAGS_core.o          += $(call cc-disable-warning, override-init)


