Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1153E42DB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbhHIJfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234570AbhHIJf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 05:35:29 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132D0C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 02:35:09 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x90so23562016ede.8
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 02:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zwAAZtoe5JzXwMl3BpwlMJNUPbe45ZpYwTmRl3QO43w=;
        b=zSx2RwzNsht4f2/bo6VzWdIj65matsW9qhjPPJO3ptc/WjUMzFzad9pwS74bs8z/Mp
         OhhEkmbLQeK5okI4BmVTCWcL53vpJ936O9hAh7aS4qVo7QWsy5BQ9da+gju7Vab2MB4h
         5PDAP8t1qehCi1ZYuBJ2nbn9BG6AdMVmrSF20afGRnwr8EshJqQkynsnyiqy/0mRgSMw
         NODT7sKY4WEjQtwV9UUyASMN+eFtLAQ/MVhIHbKpBTmDMfu1pL0cCg3hapx7otqCpEbB
         Mkq1GKvayRMAbDts5/7MPm+NvD1lS3h1Vby1rGnzxCOVxBS0VG7QfWw3xpp5jOQmKmHM
         eWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zwAAZtoe5JzXwMl3BpwlMJNUPbe45ZpYwTmRl3QO43w=;
        b=cFLru1fStFL7cO9yUDFbN8l5U/0gzzqEcaMhN7Hp1lsQUQ3TY6g5HN5/VxfZydTRXD
         ZyW0FX/ldN6LNxdb6xBlXRqy1XtvolOQiVRLcobFf70g6W3iLcztATjU6jJeeZmDNw1y
         8Eg45psL+oWM2D/6QA9AGr/A0b1wEH/0nX8ONDrP5qX1FoRv7RkUpCQSM0jbJEltPzaA
         agRTPilbm8lj34hkgD6KzdqoBFoXP4MijZRDWuLuUhjq54UnAoda88K1yBnmOFM9zfHj
         TLwz3YXxQ7iHV1KdU6/wKdR5drtzJL7KEplGeixoUE5TaTgmtZyM8NdvMY05BRGL6STL
         Ym+w==
X-Gm-Message-State: AOAM5317Ui2zpdOXe5AMoR0IeP4hTWRe7uI7khazcHCszk8RMTW4HXkI
        VfYTGKlaqPn0MpAFcIP80vBhRw==
X-Google-Smtp-Source: ABdhPJyVQTbfG9RhsYLnIylFbyKXtxpwHw5fl0AlD3S8iXZsHrnAongcdTGdp4UUnPg/Reiwo5lAUQ==
X-Received: by 2002:a05:6402:440e:: with SMTP id y14mr28963676eda.38.1628501707726;
        Mon, 09 Aug 2021 02:35:07 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id c8sm1989732ejp.124.2021.08.09.02.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 02:35:07 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        illusionist.neo@gmail.com, zlim.lnx@gmail.com,
        paulburton@kernel.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, luke.r.nels@gmail.com, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        davem@davemloft.net, udknight@gmail.com,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next 0/7] Fix MAX_TAIL_CALL_CNT handling in eBPF JITs
Date:   Mon,  9 Aug 2021 11:34:30 +0200
Message-Id: <20210809093437.876558-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new test of tail call count limiting revealed that the interpreter
did in fact allow up to MAX_TAIL_CALL_CNT + 1 tail calls, whereas the
x86 JITs stopped at the intended MAX_TAIL_CALL_CNT. The interpreter was
fixed in commit b61a28cf11d61f512172e673b8f8c4a6c789b425 ("bpf: Fix
off-by-one in tail call count limiting"). This patch set fixes all
arch-specific JITs except for RISC-V.

For each of the affected JITs, the incorrect behaviour was verified
by running the test_bpf test suite in QEMU. After the fixes, the JITs
pass the tail call count limiting test.

I have not been able to test the RISC-V JITs due to the lack of a
working toolchain and QEMU setup. It is likely that the RISC-V JITs
have the off-by-one behaviour too. I have not verfied any of the NIC JITs.

Link: https://lore.kernel.org/bpf/20210728164741.350370-1-johan.almbladh@anyfinetworks.com/

Johan Almbladh (7):
  arm: bpf: Fix off-by-one in tail call count limiting
  arm64: bpf: Fix off-by-one in tail call count limiting
  powerpc: bpf: Fix off-by-one in tail call count limiting
  s390: bpf: Fix off-by-one in tail call count limiting
  sparc: bpf: Fix off-by-one in tail call count limiting
  mips: bpf: Fix off-by-one in tail call count limiting
  x86: bpf: Fix comments on tail call count limiting

 arch/arm/net/bpf_jit_32.c         | 6 +++---
 arch/arm64/net/bpf_jit_comp.c     | 4 ++--
 arch/mips/net/ebpf_jit.c          | 4 ++--
 arch/powerpc/net/bpf_jit_comp32.c | 4 ++--
 arch/powerpc/net/bpf_jit_comp64.c | 4 ++--
 arch/s390/net/bpf_jit_comp.c      | 6 +++---
 arch/sparc/net/bpf_jit_comp_64.c  | 2 +-
 arch/x86/net/bpf_jit_comp32.c     | 6 +++---
 8 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.25.1

