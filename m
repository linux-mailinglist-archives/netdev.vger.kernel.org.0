Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B78643E7F7
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhJ1SJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhJ1SJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:09:23 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2561AC061570;
        Thu, 28 Oct 2021 11:06:56 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id d10so6611174ybe.3;
        Thu, 28 Oct 2021 11:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sh/g4CoEIsz6tuQeflx/5ddmD34YVD3NefLka+HCvu0=;
        b=qxdVtFesCNdVPtc2zD4xVzpruQihxTdt3WnCno/urs0A0Gsgbs/lPxi9zaur0veIzd
         5rcLz8Mri5sslPmnu4PmDhGqR59FdzAm3FgsHFRiZ5rSXBHkL++KasziefuEO6Z7zzfn
         xtPgXdR7MtOPQBxrohLjpYqHIUeEATk1ZPeVHBcaGFbeiRuyGvTncg2sJAU8EDqgx0gc
         d9OEyGORPBd374+HwaJ/ZjRW1gPjRMU6fKeIzIHm4f+gxGzf7OuJQUBEjDhR/UmLV222
         Bs2zxNgYr9/8WJHsjKUY6IYovxM2fP6eV/jrxnjoEEzO6n22BzB8glBgRzA1k/6ucs+V
         MTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sh/g4CoEIsz6tuQeflx/5ddmD34YVD3NefLka+HCvu0=;
        b=QtlsYqUbfbdjw7Di7I6Xaf+smUo8CbNkjWXL0zHteeWwVQyB0TDr9RKfOyDl/tLQo+
         ZpC19nd/Rdp97SYlr2UdhpRNQhHFUXCgsWmfQca9lNRKacdxSnlvPJts+d90fZZ7W6zG
         M8yI7v2K3zkjoeK1lKe2rdj95Bthva0vritM0LJgczWcwa940R64s7taVpagdAiZekTu
         rV2r0NB4zLoAT9Vdnp34jYdy1Ewwxjv6OSjy/+IYNbqw3dRamIrlRdqM9xhtrHcq+2O2
         LLx5qS+g0WlGqKy7BzCkAByJZBMuty8V+p7Ct7OHdnWHNiP8PXwHWg0Bd58nFiIhueCW
         VSVg==
X-Gm-Message-State: AOAM530rD/FfUOlYRJH+f6jtwluAngsJGl8OZJXikWwMplo/P/hcmc7n
        CRbrNlgn52ep5UHJ22xlyU9hkOv0PG/TzJvesRw=
X-Google-Smtp-Source: ABdhPJy3+2Ts9odc4moKIH96uR1pn1JDF36gq1nj+iwM3DQWt61PuoISxTNVpzJNUi29yL6jgH7pxky2qn2AptK+nlA=
X-Received: by 2002:a25:b19b:: with SMTP id h27mr6691539ybj.225.1635444415389;
 Thu, 28 Oct 2021 11:06:55 -0700 (PDT)
MIME-Version: 1.0
References: <20211028063501.2239335-1-memxor@gmail.com> <20211028063501.2239335-7-memxor@gmail.com>
In-Reply-To: <20211028063501.2239335-7-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 11:06:43 -0700
Message-ID: <CAEf4BzZm_R6JuV3pyN3qMJqPxZDZWJ_5kYTaX4BgbYB7Lk=t6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/8] selftests/bpf: Add weak/typeless ksym
 test for light skeleton
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:35 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> Also, avoid using CO-RE features, as lskel doesn't support CO-RE, yet.
> Include both light and libbpf skeleton in same file to test both of them
> together.
>
> In c48e51c8b07a ("bpf: selftests: Add selftests for module kfunc support"),
> I added support for generating both lskel and libbpf skel for a BPF
> object, however the name parameter for bpftool caused collisions when
> included in same file together. This meant that every test needed a
> separate file for a libbpf/light skeleton separation instead of
> subtests.
>
> Change that by appending a "_lskel" suffix to the name for files using
> light skeleton, and convert all existing users.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

I like the simplicity, thanks.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/testing/selftests/bpf/Makefile          |  4 +-
>  .../selftests/bpf/prog_tests/atomics.c        | 34 ++++++++--------
>  .../selftests/bpf/prog_tests/fentry_fexit.c   | 16 ++++----
>  .../selftests/bpf/prog_tests/fentry_test.c    | 14 +++----
>  .../selftests/bpf/prog_tests/fexit_sleep.c    | 12 +++---
>  .../selftests/bpf/prog_tests/fexit_test.c     | 14 +++----
>  .../selftests/bpf/prog_tests/kfunc_call.c     |  6 +--
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 35 +++++++++++++++-
>  .../selftests/bpf/prog_tests/ksyms_module.c   | 40 +++++++++++++++++--
>  .../bpf/prog_tests/ksyms_module_libbpf.c      | 28 -------------
>  .../selftests/bpf/prog_tests/ringbuf.c        | 12 +++---
>  .../selftests/bpf/prog_tests/trace_printk.c   | 14 +++----
>  .../selftests/bpf/prog_tests/trace_vprintk.c  | 12 +++---
>  .../selftests/bpf/prog_tests/verif_stats.c    |  6 +--
>  .../selftests/bpf/progs/test_ksyms_weak.c     |  2 +-
>  15 files changed, 142 insertions(+), 107 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c
>

[...]
