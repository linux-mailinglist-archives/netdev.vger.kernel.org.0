Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B89650CFBB
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 07:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbiDXFNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 01:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiDXFNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 01:13:39 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB21B1E;
        Sat, 23 Apr 2022 22:10:37 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8C0EBC01A; Sun, 24 Apr 2022 07:10:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777034; bh=LLWCC7WYuc6QDCihxJg+qi+SvAKlXff7ZkyG7gXmmC4=;
        h=From:To:Cc:Subject:Date:From;
        b=FKucETnaLFQ1y4Io2OEMNtmm03HuY1w92HY0irCCxIQlPZaAzQ1k7WT++4yAIRvO2
         LOtLMoSrecAy0ioCNkJ5TxvSOTuzhxC7PGJLI4p+8wEshyPeQ7Wq7GpJMOjouHvn7/
         s5hzpYJiD2Lq3/yj+yz7SA2tMOYEDvrdhc50+qT7IL6OC//is3TFTPAzUGVy8E2u/L
         rMw0rdojMeNHOiJnmzhhsCRTAVNimMBcrHqe4kb+DkRnXEgpwc4s6wI59JTCGDK1fP
         BzNO7ER2LfdgIRX61vD0QjZ5ZFV/rlsWyHNRcBuJdK+6fHpQoOZOxtIlzKyR5czEAg
         E3H2QvXhk/EUw==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 0697FC009;
        Sun, 24 Apr 2022 07:10:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1650777033; bh=LLWCC7WYuc6QDCihxJg+qi+SvAKlXff7ZkyG7gXmmC4=;
        h=From:To:Cc:Subject:Date:From;
        b=o5kaXK+1FEfIfjT+iu2fsDzBCTRzczeLNehGEzZ6IRXGHU/ZdkA5EG31Mq7MRWFb/
         TfTeSvJ66H3IGe7Qo7kZMsHA1kWZfNC8lCU8PpOtwUHGaj03K6Yg3CcJWgcdgl4nPO
         0NPlagxo0BqZROFC/03WkET03yfycWSbWpaI8wh74neIdZ/dIvG/VrDGc5I9KVGw6p
         X5TOY51ma15SaG6pdE3TQ0SWRWjZ02OLC1QWWYKKlPmCjREuFx6rZRYWE6+yrmjZde
         XznbaJzWqi/mNqyJCKMGsHQDUYll/2kTDkOfsiFS9ToKNOOyetXuQahYW0lcqG4QZx
         JsSDn/9y8D8jA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id c2394087;
        Sun, 24 Apr 2022 05:10:26 +0000 (UTC)
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 0/4] tools/bpf: allow building with musl
Date:   Sun, 24 Apr 2022 14:10:18 +0900
Message-Id: <20220424051022.2619648-1-asmadeus@codewreck.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'd like to build bpftool on alpine linux, which is musl based.

There are a few incompatibilities with it, I've commented on each patch
when I could think of alternative solutions.

I've tested the patch on an x86_64 debian testing with no problem, so
didn't obviously break glibc builds, and the binaries built for alpine
seem to work on aarch64 as well.


Dominique Martinet (4):
  tools/runqslower: musl compat: explicitly link with libargp if found
  tools/bpf: musl compat: do not use DEFFILEMODE
  tools/bpf: musl compat: replace nftw with FTW_ACTIONRETVAL
  tools/bpf: replace sys/fcntl.h by fcntl.h

 tools/bpf/bpf_jit_disasm.c         |   2 +-
 tools/bpf/bpftool/perf.c           | 115 +++++++++++++++--------------
 tools/bpf/bpftool/tracelog.c       |   2 +-
 tools/bpf/runqslower/Makefile      |  30 +++++++-
 tools/build/feature/Makefile       |   4 +
 tools/build/feature/test-all.c     |   4 +
 tools/build/feature/test-libargp.c |  14 ++++
 7 files changed, 111 insertions(+), 60 deletions(-)
 create mode 100644 tools/build/feature/test-libargp.c

-- 
2.35.1

