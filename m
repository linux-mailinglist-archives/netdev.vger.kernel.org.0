Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF1146549C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352255AbhLASDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352217AbhLASDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:03:35 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EA9C061757;
        Wed,  1 Dec 2021 10:00:09 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id v203so65941798ybe.6;
        Wed, 01 Dec 2021 10:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HqmiQnDRTjj/jEX9dCcjQmmJFmf4eT5WJK3sC9iS/1U=;
        b=b25MRS025CkdbGsudPrm5ePOwOP3Ej2cgctY29rzprzVbIXuToUk6/I6OnVd2zQAWr
         XN16mBQmEbzU1IMczWLTlrhtXe1xJuSkJe4I+PPdUJcgELAMsMzPbv5U62K26qpJzBEk
         I2l90aqQ6xu6ulnsCsaS4sRoON1CeP5IVUEWlqK0FTUN8VCV9GO8zVvsevG07f2lfsJO
         1JyxqjbPzbPngZQCpVrXmzTr2flgnQ9grdGM6KBqSGn4Hdbqorcp4d4Gy5TBb3fEueah
         lwEVoNH3u1N+piuK65drK3sZQ619EWg2Wh2XrOhr7zksuipF0YqEk+tAJA3f0zTu5f6w
         08tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HqmiQnDRTjj/jEX9dCcjQmmJFmf4eT5WJK3sC9iS/1U=;
        b=VFR6Z4H4V8LOTbP6OHBzInPl0rDSmFDEKkhGL4U2OppROlMCQ7/P7q/VFtNMuE4Lq5
         px0EdCJCxZ3DZVwse3CpkF4t90q+YjHuTYuymVSsjDKGzpBVVQsfshx9e/SaFZcSh0Fa
         t2YUgepEJIC3M0HpZcK6qgVLEi9IwbVB9Y/GrwsGr2Tc7ZNatspnzt80CNU0R5rxBh8k
         PzgzSX+aLN5SKjQfVqUP+8WtYli0Bkdfx5vbXPpCkgAAGVAuEhjr/el6cMXchjyhINZT
         Zp7Z+RDAOW71yccSKuRxarAhwcnI0lRdzha2xpq5Qu+biYUmKX1tNrjD1dI7SXXfFM1s
         W3lw==
X-Gm-Message-State: AOAM531o1OjkfCLQrPuq7szv3OYpgAVeQAsuSYi7JKxIOKoLneN1tGQX
        6g4pyIEizXqEVMcnHGcwmPYDiOQcITYHojU19dU=
X-Google-Smtp-Source: ABdhPJyggSwGuRRc6sc9wL5n4bByxZeHYKQWeYMY48A70Zuhc0n1G+2RI61BXXI9VGbRu8GM9kj0oF/yRGQRLW0m0A8=
X-Received: by 2002:a25:2c92:: with SMTP id s140mr8849957ybs.308.1638381608888;
 Wed, 01 Dec 2021 10:00:08 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
 <YaPFEpAqIREeUMU7@krava> <CAEf4BzbauHaDDJvGpx4oCRddd4KWpb4PkxUiUJvx-CXqEN2sdQ@mail.gmail.com>
 <CAADnVQ+6iMkRh3YLjJpyoLtqgzU2Fwhdhbv3ue7ObWWoZTmFmw@mail.gmail.com>
In-Reply-To: <CAADnVQ+6iMkRh3YLjJpyoLtqgzU2Fwhdhbv3ue7ObWWoZTmFmw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Dec 2021 09:59:57 -0800
Message-ID: <CAEf4BzabQ9YU=d-F0ypA6W73YD534cAb2SkAkwYuyD6dk71LSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers for
 tracing programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 9:37 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Nov 30, 2021 at 11:13 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > Hm... I'd actually try to keep kprobe BTF-free. We have fentry for
> > cases where BTF is present and the function is simple enough (like <=6
> > args, etc). Kprobe is an escape hatch mechanism when all the BTF
> > fanciness just gets in the way (retsnoop being a primary example from
> > my side). What I meant here was that bpf_get_arg(int n) would read
> > correct fields from pt_regs that map to first N arguments passed in
> > the registers. What we currently have with PT_REGS_PARM macros in
> > bpf_tracing.h, but with a proper unified BPF helper.
>
> and these macros are arch specific.
> which means that it won't be a trivial patch to add bpf_get_arg()
> support for kprobes.

no one suggested it would be trivial :) things worth doing are usually
non-trivial, as can be evidenced by Jiri's patch set

> Plenty of things to consider. Like should it return an error
> at run-time or verification time when a particular arch is not supported.

See my other replies to Jiri, I'm more and more convinced that dynamic
is the way to go for things like this, where the safety of the kernel
or BPF program are not compromised.

But you emphasized an important point, that it's probably good to
allow users to distinguish errors from reading actual value 0. There
are and will be situations where argument isn't available or some
combination of conditions are not supported. So I think, while it's a
bit more verbose, these forms are generally better:

int bpf_get_func_arg(int n, u64 *value);
int bpf_get_func_ret(u64 *value);

WDYT?

> Or argument 6 might be available on one arch, but not on the other.
> 32-bit CPU regs vs 64-bit regs of BPF, etc.
> I wouldn't attempt to mix this work with current patches.

Oh, I didn't suggest doing it as part of this already huge and
complicated set. But I think it's good to think a bit ahead and design
the helper API appropriately, at the very least.

And again, I think bpf_get_func_arg/bpf_get_func_ret deserve their own
patch set where we can discuss all this independently from
multi-attach.
