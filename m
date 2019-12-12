Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3148E11D781
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 20:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730712AbfLLTyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 14:54:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35281 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730284AbfLLTyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 14:54:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id s10so1113744plp.2;
        Thu, 12 Dec 2019 11:54:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AYTQzwmCtyGCeqizYrg2mM/HZ/u7PZU1cYAmygilZ0k=;
        b=cX8lgTvUAXu99X786QsC9HqG6LE3Uns60bB8Mg24Pi1whV6rqYeIyozLk5TEBScQnH
         vEX2ErYtIiYbH5/uVCE2MhsBsy6QBqT9ev7MDeMj/JaiVVBkKggFYq/s4iWumpVK09rX
         kWKCIfyRSRZd+fKRSw8KZpaGloz+XIJAbPvjVi13JuXsx7MDDCYDqTIYKR5FwWM1juRl
         2iKdQmzQoN1k8saGUF4yG6jolU3TaublpQtHwwlWHNAbb8UEEm2mbpAuTiD8Gd+amJZd
         gphXNJw56GshdruhQFfqyB+rWIF04VXVQ4wrRWPonUmHHbkBbxkzxIrEMRuvTpruFHX3
         hH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AYTQzwmCtyGCeqizYrg2mM/HZ/u7PZU1cYAmygilZ0k=;
        b=SMZzOelBpd9r4Pv5PAsdRSm+MfpVxQujptD0kGdiNyaWwN8NTZLQimlzPczeALPuMj
         fappLkBkijZigQuicTEXVYo3p+9PLkgSNybYCvzDbHRYyVnivnYYOIGH2F7coI4Bl9QY
         JdY9wCW9eGyOV0EO5J9i6WIjAg6Mrad9hcpluMGWJpmXLG1eqw46W/p0eXED7dcJyhmw
         jqp46Fokj0cugUT+vVAhJ/ySzthj+RzN6FC9bYMggI5G02ZYtGv7UBWbOswPAgSV1uwt
         zMqnhIm39xKlHDdQJh7BM5WZQWNyV50xW80GldWs+LzSQFihOgWAqwPU+PhUnO45aHih
         fyqw==
X-Gm-Message-State: APjAAAUVXFfsiVTIVtt3CyfVLCqYa/AlJsexM3mKJqopTw2PUNe171g2
        JNOKHRnXs6zsVQrWs/4LbLo=
X-Google-Smtp-Source: APXvYqyjha5pHlTMRAFaVfr0dMmvm/8Osbko8EWvK1HuJpN3iPuEJapQ5TwebGZ62Vmm4wm1WJvJXA==
X-Received: by 2002:a17:90a:5d04:: with SMTP id s4mr11680747pji.120.1576180459011;
        Thu, 12 Dec 2019 11:54:19 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::b509])
        by smtp.gmail.com with ESMTPSA id q41sm6646036pja.20.2019.12.12.11.54.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 11:54:18 -0800 (PST)
Date:   Thu, 12 Dec 2019 11:54:16 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4Bzb+3b-ypP8YJVA=ogQgp1KXx2xPConOswA0EiGXsmfJow@mail.gmail.com>
 <20191211191518.GD3105713@mini-arch>
 <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
 <20191211200924.GE3105713@mini-arch>
 <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
 <20191212025735.GK3105713@mini-arch>
 <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
 <20191212162953.GM3105713@mini-arch>
 <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
 <20191212104334.222552a1@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212104334.222552a1@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 10:43:34AM -0800, Jakub Kicinski wrote:
> On Thu, 12 Dec 2019 08:53:22 -0800, Andrii Nakryiko wrote:
> > > > > Btw, how hard it would be to do this generation with a new python
> > > > > script instead of bpftool? Something along the lines of
> > > > > scripts/bpf_helpers_doc.py that parses BTF and spits out this C header
> > > > > (shouldn't be that hard to write custom BTF parser in python, right)?
> > > > >  
> > > >
> > > > Not impossible, but harder than I'd care to deal with. I certainly
> > > > don't want to re-implement a good chunk of ELF and BTF parsing (maps,
> > > > progs, in addition to datasec stuff). But "it's hard to use bpftool in
> > > > our build system" doesn't seem like good enough reason to do all that.  
> > > You can replace "our build system" with some other project you care about,
> > > like systemd. They'd have the same problem with vendoring in recent enough
> > > bpftool or waiting for every distro to do it. And all this work is
> > > because you think that doing:
> > >
> > >         my_obj->rodata->my_var = 123;
> > >
> > > Is easier / more type safe than doing:
> > >         int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> > >         *my_var = 123;  
> > 
> > Your arguments are confusing me. Did I say that we shouldn't add this
> > type of "dynamic" interface to variables? Or did I say that every
> > single BPF application has to adopt skeleton and bpftool? I made no
> > such claims and it seems like discussion is just based around where I
> > have to apply my time and efforts... You think it's not useful - don't
> > integrate bpftool into your build system, simple as that. Skeleton is
> > used for selftests, but it's up to maintainers to decide whether to
> > keep this, similar to all the BTF decisions.
> 
> Since we have two people suggesting this functionality to be a separate
> tool could you please reconsider my arguments from two days ago?
> 
>   There absolutely nothing this tool needs from [bpftool], no
>   JSON needed, no bpffs etc. 

To generate vmlinux.h bpftool doesn't need json and doesn't need bpffs.

> It can be a separate tool like
>   libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
>   That way you can actually soften the backward compat. In case people
>   become dependent on it they can carry that little tool on their own.

Jakub,

Could you please consider Andrii's reply to your comment from two days ago:
https://lore.kernel.org/bpf/CAEf4BzbeZbmCTOOo2uQXjm0GL0WDu7aLN6fdUk18Nv2g0kfwVg@mail.gmail.com/
"we are trying to make users lives easier by having major distributions
distribute bpftool and libbpf properly. Adding extra binaries to
distribute around doesn't seem to be easing any of users pains."

My opinion is the following.
bpftool is necessary to write bpf programs already. It's necessary to produce
vmlinux.h for bpf programs to include it. It's part of build process. I can
relate to Stan's complains that he needs to update clang and pahole. He missed
the fact that he needs to update bpftool too if he wants to use all features of
CO-RE. Same thing for skeleton generation. If people need to run the latest
selftest/bpf on the latest kernel they need to upgrade to the latest clang,
pahole, libbpf, bpftool. Nothing new here.

Backwards compat is the same concern for skeleton generation and for vmlinux.h
generation. Obviously no one wants to introduce something that will keep
changing. Is vmlinux.h generation stable? I like to believe so. Same with
skeleton. I wouldn't want to see it changing, but in both cases such chance
exists. We cannot and should not adopt kernel-like ABI guarantees to user space
code. It will paralyze the development.

Now consider if vmlinux.h and skeleton generation is split out of bpftool into
new tool. Effectively it would mean a fork of bpftool. Two binaries doing bpf
elf file processing without clear distinction between them is going to be very
confusing.

One more point from Stan's email:

> You can replace "our build system" with some other project you care about,
> like systemd. They'd have the same problem with vendoring in recent enough

we've been working with systemd folks for ~8 month to integrate libbpf into
their build that is using meson build system and their CI that is github based.
So we're well aware about systemd requirements for libbpf and friends.

> bpftool or waiting for every distro to do it. And all this work is
> because you think that doing:
>
>        my_obj->rodata->my_var = 123;
>
> Is easier / more type safe than doing:
>        int *my_var = bpf_object__rodata_lookup(obj, "my_var");
>        *my_var = 123;

Stan, you conveniently skipped error checking. It should have been:
    int *my_var = bpf_object__rodata_lookup(obj, "my_var");
    if (IS_ERROR_NULL(my_var))
        goto out_cleanup;
     *my_var = 123;

Now multiply this code by N variables and consider how cleanup code will look like.
Then multiply this lookup plus cleanup code for all maps, all program and all links.
Today this bpf_object__*lookup*("string") for programs, maps, links is a major
chunk of code not all only for all tests, but for all C, python, C++ services
that use BPF. It's error prone and verbose. Generated skeleton moves the tedious
job of writing lookup accessors from humans into bpftool.
Take a look at Andrii's patch 13/15:
5 files changed, 149 insertions(+), 249 deletions(-)
Those are simple selftests, yet code removal is huge. Bigger project benefits
even more.

bcc and bpftrace are successful projects because barrier of entry is low.
Both allow single line 'hello world' to get going with BPF. We're missing
this completely for networking. Some people suggest that bpftrace like
domain specific language needs to be invented for networking. I don't mind. Yet
I'd like C to be the first choice both for networking and for tracing. To
achieve that the barrier of entry need to be drastically reduced. 'Hello world'
in BPF C and corresponding user space C should fit on one slide. The existing
amount of boiler plate code in libbpf is such barrier. Skeleton generation
solves this usability problem. I do expect a lot more tools to be written in C
because skeleton exists. Can we teach skeleton to generate C++, go, rust,
python wrappers? Surely we can. One step at a time. If we make it work well for
"bpf C" plus "user C" it will work well when user side is written in a
different language.
