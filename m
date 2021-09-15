Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C976C40CC4F
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 20:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhIOSHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbhIOSHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 14:07:11 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE254C061574;
        Wed, 15 Sep 2021 11:05:52 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id y13so7489145ybi.6;
        Wed, 15 Sep 2021 11:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ov8/gNgRYFGqyH7D/qN8e2xk1BHNdowQMf7HgvG+Y5Q=;
        b=I2jytPoBofhwSJgmsi90yjfeflB3HQoQ1Kj9vhXukJYRfeMJ7mUPgpaMwNDvdHbTCt
         zazbXk5Za7soVDvjSXGNLmz+7oh08Jr+ZR6ZNn97cVQXv8N0PbXdPo+6tFDCoZ7VXjop
         wWcw8O4AjaAuM734cGIXeXYH+F4OL8PW+R+0/ufZf0tvf+xLDelXROSA+zB1Ov0PTUcA
         n+aLj/KajzUgpevTTPhxz+XDRQTy5KMAf1IEQpYft7zY+u5IM/cpwzwvH0F4TbqwrZaG
         jkDzqYVYTKJNhEl+vTRkvAMCD1jGAwRnfr7mzR8vXdnbpwnPH6yneXq7WCQX9whlcULw
         jqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ov8/gNgRYFGqyH7D/qN8e2xk1BHNdowQMf7HgvG+Y5Q=;
        b=jqWwUvcyh+I0K1oDVe2p57fvE8behwznZRMNkMl7PuA+ms8wICACIfZK2qaRBRcqee
         i4CPN61VFoLKYKetx1kLI66n7daBQ6tZeBluORAZQEOG68oF15QZeHMuIlZ4JuIVOBkw
         1tt4+is8xkD43EIDPPHI+dfAc9qMxIu9G0ajxle0nGaloseCmmeZaYZs2sUPnSIr/H1I
         Gr2FdednLDcDCsXkgyzvAO8WEeQP9bLmFQlJA5uaM4AYbJqaXbGacCL65MO8TKfk1Sv5
         Iw1NQ9eKkGHDNxisqaNxDfEKWDbV7sVE6xJeDpOmq1P7UQ88Oq3VlxTiy4nQvbL28zFL
         sdYg==
X-Gm-Message-State: AOAM531J9udnPHuHdB/Ma/0yH9XcND+Sn2eYQhN4YCzFNhhAgcWDdHbT
        zMEVmRD8s5ZJriOMXAugRP6LXFynpz5TQnFGgvc=
X-Google-Smtp-Source: ABdhPJyZ7Rtj84YdHTuYSMqOV3jP9Q4qhweXzPDOOQvuCN34de7o2vCHExUnlm5vVAlVVv1XmDkBz5cHnzsREvS3rpM=
X-Received: by 2002:a5b:408:: with SMTP id m8mr1629698ybp.2.1631729151905;
 Wed, 15 Sep 2021 11:05:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210915050943.679062-1-memxor@gmail.com> <CAEf4BzYwredoHa6Wv3AEMCfnqOXKcxk2yW3bSu3t6s_TmRmE5Q@mail.gmail.com>
 <20210915180301.cm3o6yolrnirh4sg@apollo.localdomain>
In-Reply-To: <20210915180301.cm3o6yolrnirh4sg@apollo.localdomain>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Sep 2021 11:05:40 -0700
Message-ID: <CAEf4BzYtUwLWRVkdjN6tQZakKyZoKqj84k3M_BoEYsBoeXWiDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 00/10] Support kernel module function calls
 from eBPF
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

On Wed, Sep 15, 2021 at 11:03 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Wed, Sep 15, 2021 at 09:34:21PM IST, Andrii Nakryiko wrote:
> > On Tue, Sep 14, 2021 at 10:09 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This set enables kernel module function calls, and also modifies verifier logic
> > > to permit invalid kernel function calls as long as they are pruned as part of
> > > dead code elimination. This is done to provide better runtime portability for
> > > BPF objects, which can conditionally disable parts of code that are pruned later
> > > by the verifier (e.g. const volatile vars, kconfig options). libbpf
> > > modifications are made along with kernel changes to support module function
> > > calls. The set includes gen_loader support for emitting kfunc relocations.
> > >
> > > It also converts TCP congestion control objects to use the module kfunc support
> > > instead of relying on IS_BUILTIN ifdef.
> > >
> > > Changelog:
> > > ----------
> > > v2 -> v3:
> > > v2: https://lore.kernel.org/bpf/20210914123750.460750-1-memxor@gmail.com
> > >
> > >  * Fix issues pointed out by Kernel Test Robot
> > >  * Fix find_kfunc_desc to also take offset into consideration when comparing
> >
> > See [0]:
> >
> >
> >   [  444.075332] mod kfunc i=42
> >   [  444.075383] mod kfunc i=42
> >   [  444.075522] mod kfunc i=42
> >   [  444.075578] mod kfunc i=42
> >   [  444.075631] mod kfunc i=42
> >   [  444.075683] mod kfunc i=42
> >   [  444.075735] mod kfunc i=42
> >   [  444.0
> > This step has been truncated due to its large size. Download the full
> > logs from the
> > menu once the workflow run has completed.
> >
> >   [0] https://github.com/kernel-patches/bpf/runs/3606513281?check_suite_focus=true
> >
>
> I'll change it to not use printk in the next spin (maybe just set a variable).
> This probably blew up because of parallel test_progs stuff, since it would be
> called for each sys_enter as long the raw_tp prog is attached.

We should always be filtering by pid for cases where we use raw_tp/tp
on sys_enter*.

>
> --
> Kartikeya
