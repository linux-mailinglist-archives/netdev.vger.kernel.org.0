Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EB5B807B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 19:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391211AbfISRyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 13:54:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43522 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389717AbfISRyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 13:54:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id c3so5307006qtv.10;
        Thu, 19 Sep 2019 10:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhjn8qyJcwUfBjY1N3P+y5aRQQfw1E5mf/LtWXDIb7I=;
        b=dDqdCLKvRNnKNp57sJxOb1B7tco0FEvav4u5SXb0PyIMdZGKomwxE60hmX6bODO/be
         2RUwUJ2CaVlpAEZLKzTVc+iEaTpF/fxmGpt2UXK1odgysVQHaLRtFN6RdAkQda86IZCg
         SaBwLHgrT4x+zuE0FdL0ZVOs4CNFSj7KzMUdBTHo/YS7B8AOpOzaen4K1LQqZC13aND/
         W2qh2OIXWxr9mImTXHRdoNtZh6M/dxDXWAiOH+m2XQv4lNmn9konaNkTjLLYPv42Nqby
         oz8bO9xeS6piKL/oR8HHRz0FflKwI0frQyI8KHSLU4ZEB7QTiEFuaNRMHu2tJs9lFhmz
         fxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhjn8qyJcwUfBjY1N3P+y5aRQQfw1E5mf/LtWXDIb7I=;
        b=jiZZLrDFEvd5QhD8E6/YqFJcaGr26d9NcuhAlEkkeHQRfSegWZn5tsft0skS9nik56
         9KAeOOx8ZyNy2JNSF7uTVkHE2Vlmhztgu0jU7nTrGiNtYTUkNRHKSGHxkbfRtv7oRuMK
         V2a7xObL3V/XtGKprzzgPQOz1vwr1tVExGC115Yz3FF5elncfyVE2dJUNZIyy/2CIV1y
         rfDgaDgtnKkrm2I8QekGfbn64TxoNIPSrORjs6pXqPqYrRmnObGDiMr4VbBbUaYewHHG
         9EaFSpcNDcXoNWuUE6qJGLAPHN2DNhyfGLUpK8ME91Hsu6iUPmes0C7Gy3dxOZLjzt8R
         PJCw==
X-Gm-Message-State: APjAAAW7ba5tzGIRNNpSUJ1+Cx1NXFjqzYyQuzV9sitqZnkI1KpkcHcY
        eUhTqpOihg7MlLIvETpQl/Z3s9/sDFnDICrv78U=
X-Google-Smtp-Source: APXvYqySMGE9FQ3NKlK5aMuYtzri2leqgoI/V/pw2qlSldLW0loyhGWYeK/GZOi2frfzKsEOl1zObzann3PRUdjIT/Y=
X-Received: by 2002:a05:6214:582:: with SMTP id bx2mr8789123qvb.60.1568915657312;
 Thu, 19 Sep 2019 10:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-10-ivan.khoronzhuk@linaro.org> <CAEf4BzbuPnxAs0A=w60q0jTCy5pb2R-h0uEuT2tmvjsaj4DH4A@mail.gmail.com>
 <20190918103508.GC2908@khorivan> <CAEf4BzYCNrkaMf-LFHYDi78m9jgMDOswh8VYXGcbttJV-3D21w@mail.gmail.com>
 <20190919141848.GA8870@khorivan>
In-Reply-To: <20190919141848.GA8870@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Sep 2019 10:54:06 -0700
Message-ID: <CAEf4BzYukBi6DjiN-_ueFp4=n8S3Qfpq1wM2CnPGS-R8LJ7+KQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 09/14] samples: bpf: makefile: use own flags
 but not host when cross compile
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 7:18 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Wed, Sep 18, 2019 at 02:29:53PM -0700, Andrii Nakryiko wrote:
> >On Wed, Sep 18, 2019 at 3:35 AM Ivan Khoronzhuk
> ><ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> On Tue, Sep 17, 2019 at 04:42:07PM -0700, Andrii Nakryiko wrote:
> >> >On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
> >> ><ivan.khoronzhuk@linaro.org> wrote:
> >> >>
> >> >> While compile natively, the hosts cflags and ldflags are equal to ones
> >> >> used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it should
> >> >> have own, used for target arch. While verification, for arm, arm64 and
> >> >> x86_64 the following flags were used alsways:
> >> >>
> >> >> -Wall
> >> >> -O2
> >> >> -fomit-frame-pointer
> >> >> -Wmissing-prototypes
> >> >> -Wstrict-prototypes
> >> >>
> >> >> So, add them as they were verified and used before adding
> >> >> Makefile.target, but anyway limit it only for cross compile options as
> >> >> for host can be some configurations when another options can be used,
> >> >> So, for host arch samples left all as is, it allows to avoid potential
> >> >> option mistmatches for existent environments.
> >> >>
> >> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> >> ---
> >> >>  samples/bpf/Makefile | 9 +++++++++
> >> >>  1 file changed, 9 insertions(+)
> >> >>
> >> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >> >> index 1579cc16a1c2..b5c87a8b8b51 100644
> >> >> --- a/samples/bpf/Makefile
> >> >> +++ b/samples/bpf/Makefile
> >> >> @@ -178,8 +178,17 @@ CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
> >> >>  TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
> >> >>  endif
> >> >>
> >> >> +ifdef CROSS_COMPILE
> >> >> +TPROGS_CFLAGS += -Wall
> >> >> +TPROGS_CFLAGS += -O2
> >> >
> >> >Specifying one arg per line seems like overkill, put them in one line?
> >> Will combine.
> >>
> >> >
> >> >> +TPROGS_CFLAGS += -fomit-frame-pointer
> >> >
> >> >Why this one?
> >> I've explained in commit msg. The logic is to have as much as close options
> >> to have smiliar binaries. As those options are used before for hosts and kinda
> >> cross builds - better follow same way.
> >
> >I'm just asking why omit frame pointers and make it harder to do stuff
> >like profiling? What performance benefits are we seeking for in BPF
> >samples?
> >
> >>
> >> >
> >> >> +TPROGS_CFLAGS += -Wmissing-prototypes
> >> >> +TPROGS_CFLAGS += -Wstrict-prototypes
> >> >
> >> >Are these in some way special that we want them in cross-compile mode only?
> >> >
> >> >All of those flags seem useful regardless of cross-compilation or not,
> >> >shouldn't they be common? I'm a bit lost about the intent here...
> >> They are common but split is needed to expose it at least. Also host for
> >> different arches can have some own opts already used that shouldn't be present
> >> for cross, better not mix it for safety.
> >
> >We want -Wmissing-prototypes and -Wstrict-prototypes for cross-compile
> >and non-cross-compile cases, right? So let's specify them as common
> >set of options, instead of relying on KBUILD_HOSTCFLAGS or
> >HOST_EXTRACFLAGS to have them. Otherwise we'll be getting extra
> >warnings for just cross-compile case, which is not good. If you are
> >worrying about having duplicate -W flags, seems like it's handled by
> >GCC already, so shouldn't be a problem.
>
> Ok, lets drop omit-frame-pointer.
>
> But then, lets do more radical step and drop
> KBUILD_HOSTCFLAGS & HOST_EXTRACFLAG in this patch:

Yeah, let's do this, if you confirmed that everything still works (and
I don't see a reason why it shouldn't). Thanks.

>
> -ifdef CROSS_COMPILE
> +TPROGS_CFLAGS += -Wall -O2
> +TPROGS_CFLAGS += -Wmissing-prototypes
> +TPROGS_CFLAGS += -Wstrict-prototypes
> -else
> -TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
> -TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
> -endif
>
> At least it allows to use same options always for both, native and cross.
>
> I verified on native x86_64, arm64 and arm and cross for arm and arm64,
> but should work for others, at least it can be tuned explicitly and
> no need to depend on KBUILD and use "cross" fork here.

Yep, I like it.

>
> --
> Regards,
> Ivan Khoronzhuk
