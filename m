Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588DB432374
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 18:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhJRQGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 12:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhJRQGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 12:06:14 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4846C06161C;
        Mon, 18 Oct 2021 09:04:02 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id w11so15424744ilv.6;
        Mon, 18 Oct 2021 09:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Q1jQac4n49djWrff6Bh//LGqXr7z1OINwDAbzlQN4Fw=;
        b=DS01b2L+lVb9MpZ0whoognyKsLaoHT2MrqG/9WeyBEyK+8m1dwG8O6tJfAkkjB1GJ9
         wBPCDxybzvs+WaGwo5ZUU20v9H8eDkooa9xmOzfN3b1JLZpbsRc1ULIoIukbNVHoNzNN
         /THUebEfgdSN2tZLsNFSHGf+TOlF8QDK7P7hWQn5MUr4VDorlK+H5CeLMPSr1Vxn+AdY
         ZXvuhknKjQXAIAYORf2vzjEpfErlzUKNsUbzqhHP4jP+SF5RPGLnDwEK22wXGxuB4xc0
         ujd65jEPCtINWr7rHQi4OeXur9l5S10EXurgN9L5KQi1j12T9/8sHDoRabFuPaKM1M+3
         5MWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Q1jQac4n49djWrff6Bh//LGqXr7z1OINwDAbzlQN4Fw=;
        b=Tbzmz+SL0avSFkY7voCZsmhYkeRu8gkPk5lBXbTut7weTW3PvB6yL2wyZ0FvI5EnLW
         cAYwkMol96JOZHVBJzqp5uHGEbLzJt0TxovitTWrnjmOAlJG6jVUKEnL6OIoPCsNPKf4
         b5PXVwiZ5LnIPwcnv/ngMGpwajXkW9ePAeAGDpk6T+giZwvGMD+IfeQOcHbm8aRofUop
         tc1mhkiuYFJGAy0xWYmpamo43UVaovosnRbiagArGup1ocUE2duDRI9AQxJ9eJCw4MqB
         +tGpGLPI3qEbY82bcKQwKny/D/xNyVcp1fKdWpTY5XzNVjPMfdGMlyNNT1u+NxzAfW+s
         NHyg==
X-Gm-Message-State: AOAM530Nt2rcIpaiJ6mIdXnwk97bMaFSChleemQEKOxfEdVh1AzuiY64
        muc55xb27+Rat83i/gYzJ98=
X-Google-Smtp-Source: ABdhPJzuiMkL1qc1LT8ZMkA35cZ9u+UdvdUa6gTF46+MzqXGby/fXnqax4UO7z4GlA6Uv9EwkdPWWA==
X-Received: by 2002:a05:6e02:17cf:: with SMTP id z15mr14811400ilu.161.1634573042071;
        Mon, 18 Oct 2021 09:04:02 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id t10sm7065417ile.29.2021.10.18.09.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 09:04:01 -0700 (PDT)
Date:   Mon, 18 Oct 2021 09:03:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Dave Marchevsky <davemarchevsky@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Message-ID: <616d9ae958a68_1eb120856@john-XPS-13-9370.notmuch>
In-Reply-To: <20211011205415.234479-1-davemarchevsky@fb.com>
References: <20211011205415.234479-1-davemarchevsky@fb.com>
Subject: RE: [PATCH v2 bpf-next 0/2] bpf: keep track of verifier
 insn_processed
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dave Marchevsky wrote:
> This is a followup to discussion around RFC patchset "bpf: keep track of
> prog verification stats" [0]. The RFC elaborates on my usecase, but to
> summarize: keeping track of verifier stats for programs as they - and
> the kernels they run on - change over time can help developers of
> individual programs and BPF kernel folks.
> 
> The RFC added a verif_stats to the uapi which contained most of the info
> which verifier prints currently. Feedback here was to avoid polluting
> uapi with stats that might be meaningless after major changes to the
> verifier, but that insn_processed or conceptually similar number would
> exist in the long term and was safe to expose.
> 
> So let's expose just insn_processed via bpf_prog_info and fdinfo for now
> and explore good ways of getting more complicated stats in the future.
> 
> [0] https://lore.kernel.org/bpf/20210920151112.3770991-1-davemarchevsky@fb.com/
> 
> v1->v2:
>   * Rename uapi field from insn_processed to verified_insns [Daniel]
>   * use 31 bits of existing bitfield space in bpf_prog_info [Daniel]
>   * change underlying type from 64-> 32 bits [Daniel]
> 
> Dave Marchevsky (2):
>   bpf: add verified_insns to bpf_prog_info and fdinfo
>   selftests/bpf: add verif_stats test
> 
>  include/linux/bpf.h                           |  1 +
>  include/uapi/linux/bpf.h                      |  2 +-
>  kernel/bpf/syscall.c                          |  8 +++--
>  kernel/bpf/verifier.c                         |  1 +
>  tools/include/uapi/linux/bpf.h                |  2 +-
>  .../selftests/bpf/prog_tests/verif_stats.c    | 31 +++++++++++++++++++
>  6 files changed, 41 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c
> 
> -- 
> 2.30.2
> 

For the series.

Acked-by: John Fastabend <john.fastabend@gmail.com>
