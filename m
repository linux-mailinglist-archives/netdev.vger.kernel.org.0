Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E59111D7CB
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 21:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbfLLUVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 15:21:21 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37416 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbfLLUVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 15:21:20 -0500
Received: by mail-pl1-f194.google.com with SMTP id c23so25000plz.4
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 12:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GkrshFgovIOz5mKHPOOI1fytetL3PFoxDCjB2phi65c=;
        b=s2Rjlz97JKzP6Or018d6McywMH1i3xB4nXOgwqzFOyXCyJ6BdM2/KCf73JfYdbC3xw
         aVMYWcxHfXaKCmhW1EOmmj8j7SisETFrRn5vzxzSvUzixyHjz5ZkYafpjbikAeqaT8Kf
         LkFL0vLczUaP7tchLl9uongSkC+Egma4nPGe+Ccni1zWILPQnxe4uj5nXXXlAkuMOyxJ
         2IS3MfZ5QibpKPxjUXEMU9lATdWoGSGnA/z6UoaI5ZbtFB0JAZR3st0NkTmOY1usGDcI
         O0kMXDiKs73AYa31Q4SiHUKdEYnEcdoUN1QzSTnXgIkoOviwsog+Jk6QjnB0pwzoXtvf
         A45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GkrshFgovIOz5mKHPOOI1fytetL3PFoxDCjB2phi65c=;
        b=Z3BIzm2Nft2T4LXmRCwaok7nmKFKbSl54j9IfiI8ZGkPcaL9xLtAM47gMN9GM8X0cA
         Ot5Inp9wMlp0gRwATBB7SPFw8IpovO9XhJrqfDfDKcgGvvxkjPHEI7Wmk9C0M6MyddOn
         wvM90Mn6lqVSGIGgJFHE8Csk6YQaQAjJFxs9Z0ENNzHwoURQY/Wza/gmP6dlA7lVO2xO
         QIRxlGMwyRSz2LZMukLllPJ+Q+pwDc8ZobAudYuixrsyZDSmvLM5MFr+UU+ZDj5JaL6G
         uKHSZj7v7y6KUm6jpJSCCqpgET1UC+Gd7UBhG2aa/FpL90Ysk0IuGo949Tk1ycZNkS7G
         a2Ew==
X-Gm-Message-State: APjAAAXnusZcSql0rdT+R5nuL3WBWk5Y/Pj/4S7IyRhDI0HkmDlW7J9u
        hJskAJxcXfOwEw8ghh/x+9zleQ==
X-Google-Smtp-Source: APXvYqyOkFfbyp5oeVbKzquUexA3TJ/wfgjPxlHeRKynDRUjQesTEsD9x2xj2HQGVzCzbkiGHoNoOg==
X-Received: by 2002:a17:90a:3663:: with SMTP id s90mr12110462pjb.1.1576182079941;
        Thu, 12 Dec 2019 12:21:19 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y17sm8157194pfn.86.2019.12.12.12.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 12:21:19 -0800 (PST)
Date:   Thu, 12 Dec 2019 12:21:15 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191212122115.612bb13b@cakuba.netronome.com>
In-Reply-To: <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
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
        <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 11:54:16 -0800, Alexei Starovoitov wrote:
> On Thu, Dec 12, 2019 at 10:43:34AM -0800, Jakub Kicinski wrote:
> > On Thu, 12 Dec 2019 08:53:22 -0800, Andrii Nakryiko wrote:  
> > > > > > Btw, how hard it would be to do this generation with a new python
> > > > > > script instead of bpftool? Something along the lines of
> > > > > > scripts/bpf_helpers_doc.py that parses BTF and spits out this C header
> > > > > > (shouldn't be that hard to write custom BTF parser in python, right)?
> > > > > >    
> > > > >
> > > > > Not impossible, but harder than I'd care to deal with. I certainly
> > > > > don't want to re-implement a good chunk of ELF and BTF parsing (maps,
> > > > > progs, in addition to datasec stuff). But "it's hard to use bpftool in
> > > > > our build system" doesn't seem like good enough reason to do all that.    
> > > > You can replace "our build system" with some other project you care about,
> > > > like systemd. They'd have the same problem with vendoring in recent enough
> > > > bpftool or waiting for every distro to do it. And all this work is
> > > > because you think that doing:
> > > >
> > > >         my_obj->rodata->my_var = 123;
> > > >
> > > > Is easier / more type safe than doing:
> > > >         int *my_var = bpf_object__rodata_lookup(obj, "my_var");
> > > >         *my_var = 123;    
> > > 
> > > Your arguments are confusing me. Did I say that we shouldn't add this
> > > type of "dynamic" interface to variables? Or did I say that every
> > > single BPF application has to adopt skeleton and bpftool? I made no
> > > such claims and it seems like discussion is just based around where I
> > > have to apply my time and efforts... You think it's not useful - don't
> > > integrate bpftool into your build system, simple as that. Skeleton is
> > > used for selftests, but it's up to maintainers to decide whether to
> > > keep this, similar to all the BTF decisions.  
> > 
> > Since we have two people suggesting this functionality to be a separate
> > tool could you please reconsider my arguments from two days ago?
> > 
> >   There absolutely nothing this tool needs from [bpftool], no
> >   JSON needed, no bpffs etc.   
> 
> To generate vmlinux.h bpftool doesn't need json and doesn't need bpffs.

At least for header generation it pertains to the running system.
And bpftool was (and still is AFAICT) about interacting with the BPF
state on the running system.

> > It can be a separate tool like
> >   libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
> >   That way you can actually soften the backward compat. In case people
> >   become dependent on it they can carry that little tool on their own.  
> 
> Jakub,
> 
> Could you please consider Andrii's reply to your comment from two days ago:
> https://lore.kernel.org/bpf/CAEf4BzbeZbmCTOOo2uQXjm0GL0WDu7aLN6fdUk18Nv2g0kfwVg@mail.gmail.com/
> "we are trying to make users lives easier by having major distributions
> distribute bpftool and libbpf properly. Adding extra binaries to
> distribute around doesn't seem to be easing any of users pains."

Last time we argued I heard how GH makes libbpf packaging easier.
Only to have that dis-proven once the people in Europe who do distro
packaging woke up:

https://lkml.org/lkml/2019/12/5/101
https://lkml.org/lkml/2019/12/5/312

I feel I'm justified not to take your opinion on this as fact.

> My opinion is the following.
> bpftool is necessary to write bpf programs already. It's necessary to produce
> vmlinux.h for bpf programs to include it. It's part of build process. I can
> relate to Stan's complains that he needs to update clang and pahole. He missed
> the fact that he needs to update bpftool too if he wants to use all features of
> CO-RE. Same thing for skeleton generation. If people need to run the latest
> selftest/bpf on the latest kernel they need to upgrade to the latest clang,
> pahole, libbpf, bpftool. Nothing new here.

They have to update libbpf, so why can't the code gen tool be part of
libbpf? We don't need to build all BPF user space into one binary.

> Backwards compat is the same concern for skeleton generation and for vmlinux.h
> generation. Obviously no one wants to introduce something that will keep
> changing. Is vmlinux.h generation stable? I like to believe so. Same with
> skeleton. I wouldn't want to see it changing, but in both cases such chance
> exists. 

vmlinux.h is pretty stable, there isn't much wiggle room there.
It's more of a conversion tool, if you will.

Skeleton OTOH is supposed to make people's lives easier, so it's a
completely different beast. It should be malleable so that users can
improve and hack on it. Baking it into as system tool is counter
productive. Users should be able to grab the skel tool single-file
source and adjust for their project's needs. Distributing your own copy
of bpftool because you want to adjust skel is a heavy lift.

And maybe one day we do have Python/Go/whatever bindings, and we can
convert the skel tool to a higher level language with modern templating.

> We cannot and should not adopt kernel-like ABI guarantees to user space
> code. It will paralyze the development.

Discussion for another time :)

> Now consider if vmlinux.h and skeleton generation is split out of bpftool into
> new tool. Effectively it would mean a fork of bpftool. Two binaries doing bpf
> elf file processing without clear distinction between them is going to be very
> confusing.

To be clear I'm suggesting skel gen is a separate tool, vmlinux and
Quentin's header gen work on the running system, they are not pure
build env tools.
