Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68C1F11D886
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 22:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbfLLV2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 16:28:05 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35184 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731040AbfLLV2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 16:28:05 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so228454pgk.2;
        Thu, 12 Dec 2019 13:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D/gv7eytCwvP7hIyDmJBH2pwd4vDwIqS68/F/jtBrbU=;
        b=eFknJIJNiil5F7PUR+gHKjhDpm10AC+X7Qnb0xCyWsoJRpWKmQsQpFMmP9xgr7Ce9J
         A61tfE2oPwHitKCYXIHXbPfcUYOMZslJ8+hGb+SCYnsLu96xPawRQeHMAdG0jE+qycBj
         dpNjyYSftQYwEFFCPhR9dGo9tnkQOA9QhgDkyrKyqkRbAkkTmq/kKKon2FKbgL0Zgntl
         qAZlGWEozUHMlu6jFdIeD0uAGzfXg6saraQuhaHiu+EtCXsfx0GQ6+x4WE5F06i9FxvJ
         c0zu/Vbb8QrW5Zh017NXJTT0elYiaH2BmKI0i5icQkPJr8ewpL4oHBtgGziHuTEv6a4G
         MnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D/gv7eytCwvP7hIyDmJBH2pwd4vDwIqS68/F/jtBrbU=;
        b=oBG9TNdRrexC/BXRqgtIJ0uc0d8U34bNYVERLU2/eE4yU/p+352iczRMRsMys3kYxy
         NIEz70hi3DEXRYhFbVtErH68DLk66WQDi9vqAOXcMjzaQKiPzz3gocf2Rim6kDGJ3J83
         Sokel4Wal4EmMlLLKFsFOgCRZ1o3O0ooz8I5RNWZkCvvUFM7qHPxyR8CJCFJjy2ul8FP
         3j3Q19mWWQ+PsyYcXYbD9hwAqx7Ku5VqvRwJGBxgVmDtCc/twqT5KM2Mk2Si7OeUvppr
         r/Lwj0yT1QNbnGo3VO5PYHoppg37m8TwRKOVQbBbHHGsbq8atVYlN4tNYWYXomfbwlPt
         FiPA==
X-Gm-Message-State: APjAAAWWISps4hfeZrkwgszda7U0HxTDhbvqCPvIiAm567JZjUAhMxt3
        A2aZtuN9XTdGtzlSmQFfGjY=
X-Google-Smtp-Source: APXvYqwiF1zBZxfO3KLzlfcFvL6W+z5uHLsDMIHhT3FRbyLkJ+LG0Gd0hZgzNESr4nwKGacBAkKpgw==
X-Received: by 2002:a62:e519:: with SMTP id n25mr12079467pff.220.1576186084062;
        Thu, 12 Dec 2019 13:28:04 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::b509])
        by smtp.gmail.com with ESMTPSA id 20sm7844486pgw.71.2019.12.12.13.28.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 13:28:03 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:28:00 -0800
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
Message-ID: <20191212212759.mhzrlqj5brcyfwgb@ast-mbp.dhcp.thefacebook.com>
References: <CAEf4BzYofFFjSAO3O-G37qyeVHE6FACex=yermt8bF8mXksh8g@mail.gmail.com>
 <20191211200924.GE3105713@mini-arch>
 <CAEf4BzaE0Q7LnPOa90p1RX9qSbOA_8hkT=6=7peP9C88ErRumQ@mail.gmail.com>
 <20191212025735.GK3105713@mini-arch>
 <CAEf4BzY2KHK4h5e40QgGt4GzJ6c+rm-vtbyEdM41vUSqcs=txA@mail.gmail.com>
 <20191212162953.GM3105713@mini-arch>
 <CAEf4BzYJHvuFbBM-xvCCsEa+Pg-bG1tprGMbCDtsbGHdv7KspA@mail.gmail.com>
 <20191212104334.222552a1@cakuba.netronome.com>
 <20191212195415.ubnuypco536rp6mu@ast-mbp.dhcp.thefacebook.com>
 <20191212122115.612bb13b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212122115.612bb13b@cakuba.netronome.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 12:21:15PM -0800, Jakub Kicinski wrote:
> > > 
> > >   There absolutely nothing this tool needs from [bpftool], no
> > >   JSON needed, no bpffs etc.   
> > 
> > To generate vmlinux.h bpftool doesn't need json and doesn't need bpffs.
> 
> At least for header generation it pertains to the running system.
> And bpftool was (and still is AFAICT) about interacting with the BPF
> state on the running system.

No. Reality is different. vmlinux.h generation doesn't need to touch
kernel on the running system. Part of its job is to generate multiple
vmlinux.h from a set of vmlinux elf files. Different .h for different kernels.
It can generate vmlinux.h from running kernel too, but its less relevant
to make use of CO-RE.
In the future bpftool will be used to merge such multiple .h-s.
Likely it will first merge BTFs from vmlinuxes and then will produce
merged vmlinux_4_x_and_5_x.h

> > > It can be a separate tool like
> > >   libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
> > >   That way you can actually soften the backward compat. In case people
> > >   become dependent on it they can carry that little tool on their own.  
> > 
> > Jakub,
> > 
> > Could you please consider Andrii's reply to your comment from two days ago:
> > https://lore.kernel.org/bpf/CAEf4BzbeZbmCTOOo2uQXjm0GL0WDu7aLN6fdUk18Nv2g0kfwVg@mail.gmail.com/
> > "we are trying to make users lives easier by having major distributions
> > distribute bpftool and libbpf properly. Adding extra binaries to
> > distribute around doesn't seem to be easing any of users pains."
> 
> Last time we argued I heard how GH makes libbpf packaging easier.
> Only to have that dis-proven once the people in Europe who do distro
> packaging woke up:
> 
> https://lkml.org/lkml/2019/12/5/101
> https://lkml.org/lkml/2019/12/5/312

I think you missed the point of these two comments. It was about packaging
bpftool and libbpf together. Regardless how bpftool is packaged. I still
strongly suggest to use github/libbpf to package libbpf. It's something that is
actually tested whereas libbpf in the kernel tree has unit test coverage only.

> 
> > My opinion is the following.
> > bpftool is necessary to write bpf programs already. It's necessary to produce
> > vmlinux.h for bpf programs to include it. It's part of build process. I can
> > relate to Stan's complains that he needs to update clang and pahole. He missed
> > the fact that he needs to update bpftool too if he wants to use all features of
> > CO-RE. Same thing for skeleton generation. If people need to run the latest
> > selftest/bpf on the latest kernel they need to upgrade to the latest clang,
> > pahole, libbpf, bpftool. Nothing new here.
> 
> They have to update libbpf, so why can't the code gen tool be part of
> libbpf? 

I'm not sure why two answers were not enough.
No idea how to answer this question differently for the third time.

> > Backwards compat is the same concern for skeleton generation and for vmlinux.h
> > generation. Obviously no one wants to introduce something that will keep
> > changing. Is vmlinux.h generation stable? I like to believe so. Same with
> > skeleton. I wouldn't want to see it changing, but in both cases such chance
> > exists. 
> 
> vmlinux.h is pretty stable, there isn't much wiggle room there.

Do you have experience working with vmlinux.h? I bet the answer is no.
While we have and identified few things that needs improvement.
They require vmlinux.h to be generated differently.

> It's more of a conversion tool, if you will.
> 
> Skeleton OTOH is supposed to make people's lives easier, so it's a
> completely different beast. It should be malleable so that users can
> improve and hack on it. Baking it into as system tool is counter
> productive. Users should be able to grab the skel tool single-file
> source and adjust for their project's needs. Distributing your own copy
> of bpftool because you want to adjust skel is a heavy lift.

Adjust generator for their custom needs? essentially fork it for
private use? I'd rather prevent such possibility.
When people start using it I'd prefer they come back to this mailing
list with patches than do 'easy fork'.

> > Now consider if vmlinux.h and skeleton generation is split out of bpftool into
> > new tool. Effectively it would mean a fork of bpftool. Two binaries doing bpf
> > elf file processing without clear distinction between them is going to be very
> > confusing.
> 
> To be clear I'm suggesting skel gen is a separate tool, vmlinux and
> Quentin's header gen work on the running system, they are not pure
> build env tools.

You meant to say Andrii's header generator that is based on Quentin's man page
generator. Its output bpf_helper_defs.h makes sense as a part of libbpf
package. The generator script itself doesn't need to be included with any package.
bpftool vmlinux gen consumes vmlinux elf files and is a part of the build.
bpftool skeleton gen consumes bpf elf files and is a part of the same build.

