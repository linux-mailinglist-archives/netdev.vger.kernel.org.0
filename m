Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25F82000F4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgFSDv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSDv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:51:56 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1A6C06174E;
        Thu, 18 Jun 2020 20:51:56 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id e2so3854944qvw.7;
        Thu, 18 Jun 2020 20:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMBo3G+fmVyD1uDm/RL5nZBkwfG5Xa5tl1BNY/tSJOg=;
        b=tob4hEbVkRPWTYDIB9zvlw+9ubKhS2z2GXRJCoX8k6b/JwCVlizCkhmr767fCt4A68
         z2PP8uTzop2dAVaQ7anbKPL8el1tJKA+o01IHh8kR3X8RqCCU4eAo3nfgGVcgz3xk3Bp
         0igUq3eDoQH87ybi0+3uN4LXimKe2d1MZ/HB0d8t4NMxbCx3Q4Zkykv7o56rWAlg1czl
         IttJp/8OYsvBXRVV2TlF0C+ohWV7sWWNuB08X0MxbnB2zU5MTeQno3dK5GDSVALjyXpo
         NHqk5Z+sMqOWavR2kNMj61PHVY/cHOvSg3GCJ6oCpTn8qSbDOUFNE6lNOxtyj8KTA4mX
         shnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMBo3G+fmVyD1uDm/RL5nZBkwfG5Xa5tl1BNY/tSJOg=;
        b=A9y+qAyvBjL8wCvLTPkc33qxtmKzZT83ZAg8tewfeEbgancm9kU9BPQcTXPPsg56uc
         NiMN28PHD1TBSxE3/gv0u3gmkKY1FKvfcq7Ohe1IEwXMSCbHLP6OPdHAxWdAcbyyYerI
         77nAr23IilCQzqIcg6zoR7LpjfDToP4zzzy4ZDbMell6zEa92kjytU0/pXXALZXnuwxN
         4ysBXTG/ppB2f2K94lniPdvmMLqwlcbTGRpj6YvwLj8NqVObKt//9j8ciS73f7ThNUGy
         uY8+c6d5fsV7F1oM6KDzfDfNe/QaeV/s+HOx/AdM4JpmJ64iZfVsrgRqG5lZ+xVh2bFq
         wVoQ==
X-Gm-Message-State: AOAM532cMsT+fICWmblywalnLSqc3nul7dS70y9pi6OHwjES58j+IMk2
        A6zM9SvNzKhKLz8OxVtXH1O3xLTfjc474MoVHzg=
X-Google-Smtp-Source: ABdhPJzAzcLQuPmYvnFqmY+r5Q66qxXA2IBl1Jc9Xj1d2wbJNqpjLBKmLamY0Kum/3KeSsdNmz471doH6BfhwcZdcrc=
X-Received: by 2002:a0c:f388:: with SMTP id i8mr6927765qvk.224.1592538715351;
 Thu, 18 Jun 2020 20:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-3-jolsa@kernel.org>
 <CAEf4BzaL3bc8Hmm20Y-qEqfr7kZS2s8-KeE8M6Mz9ni81CSu4w@mail.gmail.com>
 <F126D92D-E9D8-4895-AA4E-717B553AC45A@gmail.com> <CAADnVQKWfRCLSUYSnnMRR6jQhF1MFCE+Xhcp30E_7uJd_Jr2sg@mail.gmail.com>
In-Reply-To: <CAADnVQKWfRCLSUYSnnMRR6jQhF1MFCE+Xhcp30E_7uJd_Jr2sg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 20:51:44 -0700
Message-ID: <CAEf4BzYLrp7HHZF47iCz2kQgeaqsQ+KjHS5pzoNPV8ekCTLsDQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 7:08 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jun 18, 2020 at 5:47 PM Arnaldo Carvalho de Melo
> <arnaldo.melo@gmail.com> wrote:
> >
> >
> >
> > On June 18, 2020 9:40:32 PM GMT-03:00, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> > >On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >>
> > >> The btfid tool will be used during the vmlinux linking,
> > >> so it's necessary it's ready for it.
> > >>
> > >
> > >Seeing troubles John runs into, I wonder if it maybe would be better
> > >to add it to pahole instead? It's already a dependency for anything
> > >BTF-related in the kernel. It has libelf, libbpf linked and set up.
> > >WDYT? I've cc'ed Arnaldo as well for an opinion.
> >
> > I was reading this thread with a low prio, but my gut feeling was that yeah, since pahole is already there, why not have it do this?
> >
> > I'll try to look at this tomorrow and see if this is more than just a hunch.
>
> I think it's better to keep it separate like Jiri did.
> It is really vmlinux specific as far as I can see and can change in the future.

Yeah, I actually agree, on the second though, no real reason to put it
in pahole.
