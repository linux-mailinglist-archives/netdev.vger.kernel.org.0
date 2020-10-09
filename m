Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5337F2891E6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403766AbgJITmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390731AbgJITmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 15:42:09 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323ACC0613D2;
        Fri,  9 Oct 2020 12:42:09 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id j13so6332553ilc.4;
        Fri, 09 Oct 2020 12:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+ZlpofFt4FGuf6pqKLM7pCFIvbamneYk0OHXC7HGUTE=;
        b=lRybGZuL+BUkJwqk0OJM6993WXlkrgplAPpNV7u64JccXg3ukSBwwSdoChdVnoc4LO
         R3hXVpeCYtq6phqMlkMsq1dung45duMkw1SJ6h3xYmHwj/aHE45x7hynvn20R3GKNIed
         eu/CXHW+OA+Yfvwa0kPGqRhxpEOEQZr62698kio2Xcu8e9h2+ZrJQdCmjsoEd7Q/tCWx
         USAnHX1C7WFEDEH1MCxzZqA9nmNc8PYc4ywLiGkRjmUM2XNAHP9m2j8BjgnS/PNTEG8a
         PzNf4THH/rJdZk+Hy5uC1u5ATt+dkYC2lD8etGPmNY5Sju4xdX+tjVACkWf3MSWmX9mH
         zXcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+ZlpofFt4FGuf6pqKLM7pCFIvbamneYk0OHXC7HGUTE=;
        b=ol89EEVQxjmSp+thWn9woXpDtHD6Tb1UZETfZEGAR7imCCzeR+nUf61IE7hMdJtxax
         9VXT2dNXrVnLmh7hjyfVBW1QlLHDmonaAHsQSSqGHBmYNBGgKuo+9YUvTfeewFF6Q6iJ
         YHiP6NbIe2awJrI3ooe+piMC2ixSnE/JOQe1fHeixuM4RN2GUz5iyfd0gNXMdK2wz6p0
         akhNuL43tUITw7itL5NPja/Zxz4Du5Fzw4gzNOtaTs1cZQH10dT42xjGohLU7dPmtKE8
         h5zZfUT4C0QQFH+GLsm8SCBUIod5uP4X6g2+BjEOY4zZEVXfL7WNx+j421+xP42GM6GR
         C9Iw==
X-Gm-Message-State: AOAM532kBS22+2YybxVCSM3YCFurJA99Ti7lVkwsU329lqG9Ex4ncpSB
        Ua0gULNWVrxNN4p6BJMmuCI=
X-Google-Smtp-Source: ABdhPJz2eAeaSB+vfHX0ltEh1u9oUwUnJkBW6xU5bWieFF25WV7ZGUWu+9u34coBYkaYvFZlpsQLVQ==
X-Received: by 2002:a05:6e02:f44:: with SMTP id y4mr409753ilj.226.1602272528069;
        Fri, 09 Oct 2020 12:42:08 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f2sm4509979ilr.13.2020.10.09.12.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 12:42:07 -0700 (PDT)
Date:   Fri, 09 Oct 2020 12:42:00 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Message-ID: <5f80bd081008f_ed742083e@john-XPS-13-9370.notmuch>
In-Reply-To: <20201009011240.48506-2-alexei.starovoitov@gmail.com>
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-2-alexei.starovoitov@gmail.com>
Subject: RE: [PATCH v2 bpf-next 1/4] bpf: Propagate scalar ranges through
 register assignments.
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The llvm register allocator may use two different registers representing the
> same virtual register. In such case the following pattern can be observed:
> 1047: (bf) r9 = r6
> 1048: (a5) if r6 < 0x1000 goto pc+1
> 1050: ...
> 1051: (a5) if r9 < 0x2 goto pc+66
> 1052: ...
> 1053: (bf) r2 = r9 /* r2 needs to have upper and lower bounds */
> 
> This is normal behavior of greedy register allocator.
> The slides 137+ explain why regalloc introduces such register copy:
> http://llvm.org/devmtg/2018-04/slides/Yatsina-LLVM%20Greedy%20Register%20Allocator.pdf
> There is no way to tell llvm 'not to do this'.
> Hence the verifier has to recognize such patterns.
> 
> In order to track this information without backtracking allocate ID
> for scalars in a similar way as it's done for find_good_pkt_pointers().
> 
> When the verifier encounters r9 = r6 assignment it will assign the same ID
> to both registers. Later if either register range is narrowed via conditional
> jump propagate the register state into the other register.
> 
> Clear register ID in adjust_reg_min_max_vals() for any alu instruction. The
> register ID is ignored for scalars in regsafe() and doesn't affect state
> pruning. mark_reg_unknown() clears the ID. It's used to process call, endian
> and other instructions. Hence ID is explicitly cleared only in
> adjust_reg_min_max_vals() and in 32-bit mov.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  kernel/bpf/verifier.c                         | 50 +++++++++++++++++++
>  .../testing/selftests/bpf/prog_tests/align.c  | 16 +++---
>  .../bpf/verifier/direct_packet_access.c       |  2 +-
>  3 files changed, 59 insertions(+), 9 deletions(-)
> 

I also walked through the stack read case and I don't see any issues
there either. We will run check_mem_access on the ld with src_reg->type set
to PTR_TO_STACK. So we run through check_stack_read() with a value_regno
set to the dst_reg (>=0). The case I was thinking of was if we had a
size != BPF_REG_SIZE. But, this case is handled by marking the dst reg
unknown and never copying over the stack[spi]. If size == BPF_REG_SIZE
its a full read and we also ensure all stype[] are STACK_SPILL. Then
everything looks safe to do state->regs[value_reno] = *reg e.g. assign
register state from stack complete with reg.id. 

Looking the other way at stack writes. We only allow SCALAR type bounds to
be saved on the stack if they are constant and size = BPF_REG_SIZE so no
problems there.

LGTM!

Acked-by: John Fastabend <john.fastabend@gmail.com>
