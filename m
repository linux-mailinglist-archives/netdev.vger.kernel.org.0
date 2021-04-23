Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA1368AB8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbhDWBto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbhDWBtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:49:09 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27439C061342
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 18:48:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s20so8631691plr.13
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 18:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=XajKNy6aoIfR9fbxhkyLjiEoAllUlrFjsDiP5vSV8KI=;
        b=16Qh8D3ZW09f+o41dGeMuO8jYxQStQWUf8WQAcJBxyGephSQEm1pixjYLvHT7hx7uG
         B5IH70i7Vf5dN6C+dPps5sR73nPC7Z0WiasfMoumBSvW9Zpxv1+t+4w6Uo+P5AgwvX3v
         aevwalaXJpmnDNJTZv/QFm88qjzZW+cy+mmV6iU/ZU4LCJYg/nlKj3zvLUmL1X9NOcyA
         6KtO60xIcclIYBfhI4w/sN0j0fSsysXPJ5AB4PujGRXM2AObwsQudjLbhC0adIsHd5wO
         UnRvSk8Ii4bDHs/uYn5p9VHH94bGc5KWzLlhtlf9JptbVH/tc0vo/wFJnK/YyA/UOXwv
         HOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=XajKNy6aoIfR9fbxhkyLjiEoAllUlrFjsDiP5vSV8KI=;
        b=gxS0kCaMs5zGRUovF305MOUNMbCb1YwgH2KL4IWczFhyNXrBzupRo1qPvPgvmwYE/R
         +2DdwswiP8VWBvQOc00hEwCU/ERLs3j+RPTs93X6jMhP94Ej2rC3PbnoEqbLpvVcCO92
         gEzXQnYUEOtAWotM7/0FSMRCCjIrMsSuCWzTWwR8HDgI9HCRzqxPOQPfjuPP4q24Dcvs
         GHvsrVblZS8SidaK8u3sZ3h7pMdTr1PX5gNTJ3o4ZI1DwxqRo6SQkgHrTEiA3Fc7R/wa
         NNEesjfC1ZygZS6wUSk9W+JSNPe6b/BR6OK93sgdbHZavp+ipzjRR9VWa3Fd3x4sqF+F
         vR1w==
X-Gm-Message-State: AOAM531hNEXSWQja3B71fdT+Nevd5J25McKFuPc+v8S3cM/7s3dkfkqh
        7Z8VjsI/rYODg8A97ybhbYa+/Q==
X-Google-Smtp-Source: ABdhPJwe7Y0d6/UnJxQlMZahTCa3FPgMdPek0KQGrK4wDzL21FZNrfZYihgBPY83nUxvyLVUn921Iw==
X-Received: by 2002:a17:90a:c3:: with SMTP id v3mr3158756pjd.55.1619142511541;
        Thu, 22 Apr 2021 18:48:31 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id w123sm3004405pfb.109.2021.04.22.18.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:48:30 -0700 (PDT)
Date:   Thu, 22 Apr 2021 18:48:30 -0700 (PDT)
X-Google-Original-Date: Thu, 22 Apr 2021 18:48:29 PDT (-0700)
Subject:     Re: [PATCH 0/9] riscv: improve self-protection
In-Reply-To: <20210330022144.150edc6e@xhacker>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
        dvyukov@google.com, bjorn@kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     jszhang3@mail.ustc.edu.cn
Message-ID: <mhng-c1b60b87-7dd7-43e7-91eb-1f54528384f8@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Mar 2021 11:21:44 PDT (-0700), jszhang3@mail.ustc.edu.cn wrote:
> From: Jisheng Zhang <jszhang@kernel.org>
>
> patch1 is a trivial improvement patch to move some functions to .init
> section
>
> Then following patches improve self-protection by:
>
> Marking some variables __ro_after_init
> Constifing some variables
> Enabling ARCH_HAS_STRICT_MODULE_RWX
>
> Jisheng Zhang (9):
>   riscv: add __init section marker to some functions
>   riscv: Mark some global variables __ro_after_init
>   riscv: Constify sys_call_table
>   riscv: Constify sbi_ipi_ops
>   riscv: kprobes: Implement alloc_insn_page()
>   riscv: bpf: Move bpf_jit_alloc_exec() and bpf_jit_free_exec() to core
>   riscv: bpf: Avoid breaking W^X
>   riscv: module: Create module allocations without exec permissions
>   riscv: Set ARCH_HAS_STRICT_MODULE_RWX if MMU
>
>  arch/riscv/Kconfig                 |  1 +
>  arch/riscv/include/asm/smp.h       |  4 ++--
>  arch/riscv/include/asm/syscall.h   |  2 +-
>  arch/riscv/kernel/module.c         |  2 +-
>  arch/riscv/kernel/probes/kprobes.c |  8 ++++++++
>  arch/riscv/kernel/sbi.c            | 10 +++++-----
>  arch/riscv/kernel/smp.c            |  6 +++---
>  arch/riscv/kernel/syscall_table.c  |  2 +-
>  arch/riscv/kernel/time.c           |  2 +-
>  arch/riscv/kernel/traps.c          |  2 +-
>  arch/riscv/kernel/vdso.c           |  4 ++--
>  arch/riscv/mm/init.c               | 12 ++++++------
>  arch/riscv/mm/kasan_init.c         |  6 +++---
>  arch/riscv/mm/ptdump.c             |  2 +-
>  arch/riscv/net/bpf_jit_comp64.c    | 13 -------------
>  arch/riscv/net/bpf_jit_core.c      | 14 ++++++++++++++
>  16 files changed, 50 insertions(+), 40 deletions(-)

Thanks.  These are on for-next.  I had to fix up a handful of merge 
conflicts, so LMK if I made any mistakes.
