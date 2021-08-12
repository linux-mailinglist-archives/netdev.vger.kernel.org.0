Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025CD3E9D49
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 06:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhHLEZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 00:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhHLEZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 00:25:08 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3BAC061765;
        Wed, 11 Aug 2021 21:24:43 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id e186so9114191ybf.5;
        Wed, 11 Aug 2021 21:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ges0KIsMbFo3yjUC/W5dFj3LN995z80bweixDSDeZAM=;
        b=oxfbkYmoWb3w++DkPkmjiCbDIWyjd/exSfqyDN9Mk9NZNVdYNLih2CIxyDj9jfmNVw
         4l9offdaJ7qrHNLq6wmx8JppBahMncvQeB4RVsu9oNiTpGkLsHS9IE45Z5yShj07lIYx
         K/mJR7ZEcfafHqhlz6dhOCRN/VKMCxS/OtiW8FVSwq5jagRT61lqcafp/eqbuFlwQ1Rn
         oHK6ayle+fUoPwl9jw7qjugFfFo2IC9gIOQFErHfS/tFIZsXPmN8Upo1Kvwl8rS9/aN9
         YUl3HCu0IXngxB1CvxA5UQMraxdMmwnHPUREBR0fyNuR7lfSdXG+ogxxBzURParICOMT
         VODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ges0KIsMbFo3yjUC/W5dFj3LN995z80bweixDSDeZAM=;
        b=qGZ+t4SXglwaHKQiTShQxlOKzWWU3LMamI89vsnCzBKNkBxu+4geh4QPcns9mS+ldf
         COUDkvl2P3fwKO9YTZG9kV+QHc/8eB1X9blMncijqZayjiuLpwi2WKZpDZc394/SyZ5l
         PTq22ietM9IZI2EmUU6inae/XxIyvUfkkks6GDuqcWZ8blG5Dg27OOpQX0B/dXop5VxM
         TGhYMtY0j2T57Bc6J+i1bpgCgev2Tm+4W33eGorj1sF2tH5Xl/gOstd22X2UACSf24MB
         hJMXS5LrUNYTc51OBahcX52hywbi4j59emv4h85OKS2S0CH4PPs4mxb0Ujl9ufYE1BdL
         O19w==
X-Gm-Message-State: AOAM530wWiTzoAIW6+6wQ+rEEkrSmnl6AQHpncw2RIM8+AUqqaW3hizm
        5i2OduvaMYDlMMwAQswILPa8O6tCsD01m2NuT1g=
X-Google-Smtp-Source: ABdhPJzQGcXG/On0VezvXDq9CpA+Pb9dkVB/D4VPq/S0KwzfCoGvEX4TyDbGQx7giqavaR8K/pxmP5UTu8ID0EEkQHg=
X-Received: by 2002:a25:b21f:: with SMTP id i31mr1865993ybj.403.1628742282805;
 Wed, 11 Aug 2021 21:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZBxA2+nNtbOVEyMXDG9i_3zfxm78=--ssjrX4ESC_ixA@mail.gmail.com>
 <20210812021521.91494-1-kuniyu@amazon.co.jp>
In-Reply-To: <20210812021521.91494-1-kuniyu@amazon.co.jp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Aug 2021 21:24:31 -0700
Message-ID: <CAEf4BzbA-k+SrvbiYQt8OBAxEHNwkTdaqxM=Pqn6udgPRBbF4g@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/3] bpf: Support "%c" in bpf_bprintf_prepare().
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        john fastabend <john.fastabend@gmail.com>,
        Martin Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 7:15 PM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Date:   Wed, 11 Aug 2021 14:15:50 -0700
> > On Tue, Aug 10, 2021 at 2:29 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> > >
> > > /proc/net/unix uses "%c" to print a single-byte character to escape '\0' in
> > > the name of the abstract UNIX domain socket.  The following selftest uses
> > > it, so this patch adds support for "%c".  Note that it does not support
> > > wide character ("%lc" and "%llc") for simplicity.
> > >
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > > ---
> > >  kernel/bpf/helpers.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > >
> > > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > > index 15746f779fe1..6d3aaf94e9ac 100644
> > > --- a/kernel/bpf/helpers.c
> > > +++ b/kernel/bpf/helpers.c
> > > @@ -907,6 +907,20 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
> > >                         tmp_buf += err;
> > >                         num_spec++;
> > >
> > > +                       continue;
> > > +               } else if (fmt[i] == 'c') {
> >
> > you are adding new features to printk-like helpers, please add
> > corresponding tests as well. I'm particularly curious how something
> > like "% 9c" (which is now allowed, along with a few other unusual
> > combinations) will work.
>
> I see. I'll add a test.
> I'm now thinking of test like:
>   1. pin the bpf prog that outputs "% 9c" and other format strings.
>   2. read and validate it

Simpler. Use bpf_snprintf() to test all this logic.
bpf_trace_printk(), bpf_snprintf() and bpf_seq_printf() share the same
"backend" in kernel. No need to use bpf_iter program for testing this.
Look for other snprintf() tests and just extend them.

>
> Is there any related test ?
> and is there other complicated fomat strings to test ?
>
> Also, "% 9c" worked as is :)
>
> ---8<---
> $ sudo ./tools/bpftool/bpftool iter pin ./bpf_iter_unix.o /sys/fs/bpf/unix
> $ sudo cat /sys/fs/bpf/unix | head -n 1
>         a
> $ git diff
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> index ad397e2962cf..8a7d5aa4c054 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_unix.c
> @@ -34,8 +34,10 @@ int dump_unix(struct bpf_iter__unix *ctx)
>
>         seq = ctx->meta->seq;
>         seq_num = ctx->meta->seq_num;
> -       if (seq_num == 0)
> +       if (seq_num == 0) {
> +               BPF_SEQ_PRINTF(seq, "% 9c\n", 'a');
>                 BPF_SEQ_PRINTF(seq, "Num               RefCount Protocol Flags    Type St Inode    Path\n");
> +       }
>
>         BPF_SEQ_PRINTF(seq, "%pK: %08X %08X %08X %04X %02X %8lu",
>                        unix_sk,
> ---8<---
>
>
>
> >
> > > +                       if (!tmp_buf)
> > > +                               goto nocopy_fmt;
> > > +
> > > +                       if (tmp_buf_end == tmp_buf) {
> > > +                               err = -ENOSPC;
> > > +                               goto out;
> > > +                       }
> > > +
> > > +                       *tmp_buf = raw_args[num_spec];
> > > +                       tmp_buf++;
> > > +                       num_spec++;
> > > +
> > >                         continue;
> > >                 }
> > >
> > > --
> > > 2.30.2
