Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7C528568E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 04:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgJGCEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 22:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGCEH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 22:04:07 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E467C061755;
        Tue,  6 Oct 2020 19:04:05 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e10so449624pfj.1;
        Tue, 06 Oct 2020 19:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YVgLx9s8FS6ZnB/Q1x0oH2itI4S+Z8rpG77clg3XEYU=;
        b=vNiheKN/RmY3/A5S0iCEm1yKt9sTv5ZeAEJWP2GJHlcOvKxJPm0Wt0YMfhbbxhp1Hy
         1yXwIsyQHquXZRR0PBXYti5THI1hgV53kDS1Pj7pxjxipIpZn1QMyJg/4RU4V3yhKK97
         TXPl/4lhS6UY/KMdCWaA4KTHl5yaoawpAL774q8STnmFETrlj1hHgX4I7mD/pAM+i/BI
         r+OTh7DfIs6B0T+44fwavIl0yMsBUd2o3gmDcBipA5uDfSksbFwkTH3FPpYf1Y4v40sV
         YzXBzYa5oFvaH339iGZNGRqrI84b1XccTjz/7N6G8NNYCnyqIpGsq2lafZGgsQNsw1JK
         Nhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YVgLx9s8FS6ZnB/Q1x0oH2itI4S+Z8rpG77clg3XEYU=;
        b=gJhXW+GZHglEZdYP6F7BMcqsJvkvXfS/vz785E8pzlZpfydJ7WW+T5AZjOJ/MaBo1D
         DidYg3PBZT4CvbVD/dAHwpit8M6Qwjw+bWEZKad8t8E+yO33Rv5SC7vVElq+/zv/hrOx
         G34FvTGqHej4zwIV/ew3IzMMiBAUENJLkB6U0HiW5MedJgCTh7BNo4jfcEqiCfiEQMnO
         WoTDTtd8Uw8KvNDphUJhKeYGs87D8a1tVge5ogZTEvGZ5TggXqkhWxyIzMkUmw7qJ+OK
         7PY29xSUgZa3IIfM6HRxDKYEobmat+5V19RvAFN2lZ8VCHiS/F6lfjUQG7g3ugaNTmXh
         6kfw==
X-Gm-Message-State: AOAM5324BJlkZtAlt53dtWyJFAPUmZ+NNAFV4tHojHiuGYrxBPkGQ6uf
        BCMH6806AuKvXh2MgR2B5LRSOCLxOok=
X-Google-Smtp-Source: ABdhPJz/L1QE7e266HoohCyqgpZgAEN0fgdOUqR8LRkMwNPYdCRwb3cgbIjWxtnO+c2K4ZygYnMRCg==
X-Received: by 2002:a63:1849:: with SMTP id 9mr919662pgy.393.1602036244852;
        Tue, 06 Oct 2020 19:04:04 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9c77])
        by smtp.gmail.com with ESMTPSA id q8sm529616pfu.173.2020.10.06.19.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 19:04:04 -0700 (PDT)
Date:   Tue, 6 Oct 2020 19:04:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hao Luo <haoluo@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2] selftests/bpf: Fix test_verifier after introducing
 resolve_pseudo_ldimm64
Message-ID: <20201007020401.wsbeli3dbz7fumal@ast-mbp>
References: <20201007012313.2778426-1-haoluo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007012313.2778426-1-haoluo@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 06:23:13PM -0700, Hao Luo wrote:
> Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
> the order of check_subprogs() and resolve_pseudo_ldimm() in
> the verifier. Now an empty prog expects to see the error "last
> insn is not an the prog of a single invalid ldimm exit or jmp"
> instead, because the check for subprogs comes first. It's now
> pointless to validate that half of ldimm64 won't be the last
> instruction.
> 
> Tested:
>  # ./test_verifier
>  Summary: 1129 PASSED, 537 SKIPPED, 0 FAILED
>  and the full set of bpf selftests.
> 
> Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
> Changelog in v2:
>  - Remove the original test_verifier ld_imm64 test4
>  - Updated commit message.
> 
>  tools/testing/selftests/bpf/verifier/basic.c  |  2 +-
>  .../testing/selftests/bpf/verifier/ld_imm64.c | 24 +++++++------------
>  2 files changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/verifier/basic.c b/tools/testing/selftests/bpf/verifier/basic.c
> index b8d18642653a..de84f0d57082 100644
> --- a/tools/testing/selftests/bpf/verifier/basic.c
> +++ b/tools/testing/selftests/bpf/verifier/basic.c
> @@ -2,7 +2,7 @@
>  	"empty prog",
>  	.insns = {
>  	},
> -	.errstr = "unknown opcode 00",
> +	.errstr = "last insn is not an exit or jmp",
>  	.result = REJECT,
>  },
>  {
> diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> index 3856dba733e9..ed6a34991216 100644
> --- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
> +++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> @@ -54,21 +54,13 @@
>  	"test5 ld_imm64",
>  	.insns = {
>  	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
> -	},
> -	.errstr = "invalid bpf_ld_imm64 insn",
> -	.result = REJECT,
> -},
> -{
> -	"test6 ld_imm64",
> -	.insns = {
> -	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
>  	BPF_RAW_INSN(0, 0, 0, 0, 0),
>  	BPF_EXIT_INSN(),
>  	},
>  	.result = ACCEPT,
>  },
>  {
> -	"test7 ld_imm64",
> +	"test6 ld_imm64",
>  	.insns = {
>  	BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 1),
>  	BPF_RAW_INSN(0, 0, 0, 0, 1),
> @@ -78,7 +70,7 @@
>  	.retval = 1,
>  },
>  {
> -	"test8 ld_imm64",
> +	"test7 ld_imm64",

imo that's too much churn to rename all of them.
Just delete one.
