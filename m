Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DB836AF6C
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhDZIGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhDZIGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 04:06:42 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21703C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:06:01 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id z13so5915266lft.1
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5EPR6FJWwby9HvwVkLna5U6xvh/KC+GlCAEpq3ICLqQ=;
        b=B8TXweSUJcJ3LGPO3r5XLaEb1RwTe390lEae1qCOLlR8R0F4Lvvig4ekMstlGnx5Tf
         YnsFMoHuU2U4Wr7CJbNbSOHEERFPIPDig04fu9Tympa+bFaPtJ4uQj8QKkSoAAV1KrIW
         NhWCvyf/Nc5AU4n+h/548YRoE8DTc0Z3taOAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5EPR6FJWwby9HvwVkLna5U6xvh/KC+GlCAEpq3ICLqQ=;
        b=kyTIFxqRMmrwLiaraoCX+05ar5OTZ6aJrexuU1Zu6l1HnzBfOTUvBfs1T5oKeUjkQC
         dDPKHhXdjcH/nIlwR7yLPSO8z8FXvbaXOpmH83c8EBWdHy+2DhV1NxIti2sOsQx/NmTG
         gcgtlpxD2sYWIBlHBmCdcQjJ4XYFypHA4o3d8uc2y5L67bv8PdL9XdH3gM7UnrPWIGAI
         l6lDhcwktUDqP0O3nHgAGngpEH5PuIb8la+1vNvaQFPEYjwVMH+74k27MG2LcLXJBoaL
         c+SufrARlSP+5cyuFz9zBnf+eytLKWV5ic61UoJrqRAhwmcDCGOvyLT3b4i95Dq1kYDw
         tY5A==
X-Gm-Message-State: AOAM531Rv50j9ajL1mvNjDP1TuCSLn2dNlSEn+tmYIKPUnqCD7wQOtj/
        dlw2rfbKgQiGFJjA5x1HKfsNOHseEqgFY/4wgcSV7w==
X-Google-Smtp-Source: ABdhPJxjJF2xGNaRUKrWbeK1ZhuodiPepKH5ShSrYlNILN/Xe9T6vCWuXbUQMTxlU4NQrpucsAWkLZ36Q6Nsuz6u5p4=
X-Received: by 2002:a05:6512:c02:: with SMTP id z2mr12371037lfu.325.1619424359623;
 Mon, 26 Apr 2021 01:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210423233058.3386115-1-andrii@kernel.org> <20210423233058.3386115-2-andrii@kernel.org>
In-Reply-To: <20210423233058.3386115-2-andrii@kernel.org>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 26 Apr 2021 09:05:48 +0100
Message-ID: <CACAyw985JaDmA6n3c_sLDn3Ltwndc_zkNWu84b-cMh2NqjVeNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] selftests/bpf: add remaining ASSERT_xxx() variants
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Add ASSERT_TRUE/ASSERT_FALSE for conditions calculated with custom logic to
> true/false. Also add remaining arithmetical assertions:
>   - ASSERT_LE -- less than or equal;
>   - ASSERT_GT -- greater than;
>   - ASSERT_GE -- greater than or equal.
> This should cover most scenarios where people fall back to error-prone
> CHECK()s.
>
> Also extend ASSERT_ERR() to print out errno, in addition to direct error.
>
> Also convert few CHECK() instances to ensure new ASSERT_xxx() variants work as
> expected. Subsequent patch will also use ASSERT_TRUE/ASSERT_FALSE more
> extensively.
>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
>  .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
>  .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
>  .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
>  .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
>  .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
>  tools/testing/selftests/bpf/test_progs.h      | 50 ++++++++++++++++++-
>  7 files changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> index c60091ee8a21..5e129dc2073c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> @@ -77,7 +77,7 @@ static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
>
>         snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX", t->file);
>         fd = mkstemp(out_file);
> -       if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n", fd)) {
> +       if (!ASSERT_GE(fd, 0, "create_tmp")) {

Nit: I would find ASSERT_LE easier to read here. Inverting boolean
conditions is easy to get wrong.

>                 err = fd;
>                 goto done;
>         }
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_endian.c b/tools/testing/selftests/bpf/prog_tests/btf_endian.c
> index 8c52d72c876e..8ab5d3e358dd 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_endian.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_endian.c
> @@ -6,8 +6,6 @@
>  #include <test_progs.h>
>  #include <bpf/btf.h>
>
> -static int duration = 0;

Good to see this go.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
