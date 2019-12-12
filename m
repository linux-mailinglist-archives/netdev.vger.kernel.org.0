Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A483511D8F8
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 23:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731269AbfLLWAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 17:00:03 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42444 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731265AbfLLWAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 17:00:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so92752pfz.9
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 14:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=eXtHpJiSJg/9/jwCXXHyz4QnHW3p4m3tmPKqXv4Q3JE=;
        b=dhwzw1wZBzp+s1092ddhqC+owajACV6UNC+ewplg0XmeIadQL9Q2tBXgv38VT+bjHn
         hi7S0tLXuKEMahgR8NYCTuA0zJ2NVnjr9X8JzuJtf38ZyyB+dCJ3IxYDkZUrd5SRbLhF
         X3ZL+kOBK48Y0ynokhghL761Pm3Ec68LA1dYnfXEBhWL8xA1qQdtzrWiqR3oYSe2tsVr
         5t9cEzuupG/iodz1xU38GCFy2ktQqLWDUzZsdy9fNw3uBGIrsvsy+SN9SXavrG8iU2pw
         STVChoWdWWpI6KT++PIYksG8UZrUiU2x0UL/i5NWMUzFNirPeT0yiKqRiZgKxejvmaWf
         oqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=eXtHpJiSJg/9/jwCXXHyz4QnHW3p4m3tmPKqXv4Q3JE=;
        b=W5JIxbq2fUXVhp92HUetcQsDwkO8nXD7klMj23JScDuykDcHub/RJqnWb2utZpnXRb
         RlRypDaHxhlMGn+ViU5FuamPJ9VRyLtTNfHF0SIjBynAmb58nBKE2jQDzpp9Gd5V4zQ2
         oa+YCSQBqT5XXWZW733zVgzPH23nfj0qRjLeq2teymvQgytAx1kPqe3VvVo+sICer8qs
         gqVZ16OB0+aZWAa5oRq8xMh1zwrO2H0htRGoi0XfnaSJCP/UrvhEumURplrELtCgtQGN
         LwuLj/WgV0pij06RNUsb+8cwv/9uJLrIV1GvGL43azMQePSlZ7HF9aa/a3Z40D6zC+L1
         1S0Q==
X-Gm-Message-State: APjAAAWc1p8ULn7QForGLH0MTgBnSY6MIE5ecbAS09GUY9IU+29vvm81
        jMhmwp+MAoMdrG5P2/MlEDO57i2aMP8=
X-Google-Smtp-Source: APXvYqwk0NcZ0t/BrYKLnyGvjeMXhCyG35EKksRxuhSEtPiXZM3VURxiPC0j7O9YZhTqcfB2I+boig==
X-Received: by 2002:a63:31cf:: with SMTP id x198mr12855135pgx.272.1576188001988;
        Thu, 12 Dec 2019 14:00:01 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e6sm8525411pfh.32.2019.12.12.14.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 14:00:01 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:59:58 -0800
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
Message-ID: <20191212135958.2970f188@cakuba.netronome.com>
In-Reply-To: <20191212212759.mhzrlqj5brcyfwgb@ast-mbp.dhcp.thefacebook.com>
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
        <20191212212759.mhzrlqj5brcyfwgb@ast-mbp.dhcp.thefacebook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 13:28:00 -0800, Alexei Starovoitov wrote:
> On Thu, Dec 12, 2019 at 12:21:15PM -0800, Jakub Kicinski wrote:
> > > > It can be a separate tool like
> > > >   libbpf-skel-gen or libbpf-c-skel or something, distributed with libbpf.
> > > >   That way you can actually soften the backward compat. In case people
> > > >   become dependent on it they can carry that little tool on their own.    
> > > 
> > > Jakub,
> > > 
> > > Could you please consider Andrii's reply to your comment from two days ago:
> > > https://lore.kernel.org/bpf/CAEf4BzbeZbmCTOOo2uQXjm0GL0WDu7aLN6fdUk18Nv2g0kfwVg@mail.gmail.com/
> > > "we are trying to make users lives easier by having major distributions
> > > distribute bpftool and libbpf properly. Adding extra binaries to
> > > distribute around doesn't seem to be easing any of users pains."  
> > 
> > Last time we argued I heard how GH makes libbpf packaging easier.
> > Only to have that dis-proven once the people in Europe who do distro
> > packaging woke up:
> > 
> > https://lkml.org/lkml/2019/12/5/101
> > https://lkml.org/lkml/2019/12/5/312  
> 
> I think you missed the point of these two comments. It was about packaging
> bpftool and libbpf together. Regardless how bpftool is packaged. I still
> strongly suggest to use github/libbpf to package libbpf. It's something that is
> actually tested whereas libbpf in the kernel tree has unit test coverage only.

I disagree.

> > > My opinion is the following.
> > > bpftool is necessary to write bpf programs already. It's necessary to produce
> > > vmlinux.h for bpf programs to include it. It's part of build process. I can
> > > relate to Stan's complains that he needs to update clang and pahole. He missed
> > > the fact that he needs to update bpftool too if he wants to use all features of
> > > CO-RE. Same thing for skeleton generation. If people need to run the latest
> > > selftest/bpf on the latest kernel they need to upgrade to the latest clang,
> > > pahole, libbpf, bpftool. Nothing new here.  
> > 
> > They have to update libbpf, so why can't the code gen tool be part of
> > libbpf?   
> 
> I'm not sure why two answers were not enough.
> No idea how to answer this question differently for the third time.

I'm just presenting what I consider to be a cleaner solution.

> > > Backwards compat is the same concern for skeleton generation and for vmlinux.h
> > > generation. Obviously no one wants to introduce something that will keep
> > > changing. Is vmlinux.h generation stable? I like to believe so. Same with
> > > skeleton. I wouldn't want to see it changing, but in both cases such chance
> > > exists.   
> > 
> > vmlinux.h is pretty stable, there isn't much wiggle room there.  
> 
> Do you have experience working with vmlinux.h? I bet the answer is no.
> While we have and identified few things that needs improvement.
> They require vmlinux.h to be generated differently.
> 
> > It's more of a conversion tool, if you will.
> > 
> > Skeleton OTOH is supposed to make people's lives easier, so it's a
> > completely different beast. It should be malleable so that users can
> > improve and hack on it. Baking it into as system tool is counter
> > productive. Users should be able to grab the skel tool single-file
> > source and adjust for their project's needs. Distributing your own copy
> > of bpftool because you want to adjust skel is a heavy lift.  
> 
> Adjust generator for their custom needs? essentially fork it for
> private use? I'd rather prevent such possibility.
> When people start using it I'd prefer they come back to this mailing
> list with patches than do 'easy fork'.
> 
> > > Now consider if vmlinux.h and skeleton generation is split out of bpftool into
> > > new tool. Effectively it would mean a fork of bpftool. Two binaries doing bpf
> > > elf file processing without clear distinction between them is going to be very
> > > confusing.  
> > 
> > To be clear I'm suggesting skel gen is a separate tool, vmlinux and
> > Quentin's header gen work on the running system, they are not pure
> > build env tools.  
> 
> You meant to say Andrii's header generator that is based on Quentin's man page
> generator. Its output bpf_helper_defs.h makes sense as a part of libbpf
> package. The generator script itself doesn't need to be included with any package.
> bpftool vmlinux gen consumes vmlinux elf files and is a part of the build.
> bpftool skeleton gen consumes bpf elf files and is a part of the same build.

I said what I meant to say tools/bpf/bpftool/feature.c
