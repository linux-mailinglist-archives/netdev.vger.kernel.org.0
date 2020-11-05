Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0542A8849
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgKEUpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgKEUpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:45:51 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F162AC0613CF;
        Thu,  5 Nov 2020 12:45:50 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id n142so2516211ybf.7;
        Thu, 05 Nov 2020 12:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6CEh+0J98Fkzt7UeMdIhIAOhHdj3u3uN62X4uSRO/I=;
        b=OlmA4dewOpfBjG0SqEIAVbQgNyO0WYFU9vHwTzZgQf9rr36m1ryUXeHvPJ+aMFu5SB
         xOv8wDiOpt7A4DMuCDHyebZMM8XGlgr05ytc/Lngr5OKufs4f5C0n6ynRdCpOCR1pYiD
         mLoFrYA9bhfDXP2JMt17PqPuDuMS+mf2TWpr0UU56tgM20TDx/2wpVZYC6BgZow/fc7i
         qZYAVGg2r0YyuaP99GKGlvhc2i5DMuolmwruMy05NKveyvfaTnevwlKC4aaxYXEkF9iD
         r2zytLQmn2oi6y6D/8K0DTqe2eLQhYrQb9M4acuUOdXao6roTfQQHGCa04ceWLc9C6kR
         oJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6CEh+0J98Fkzt7UeMdIhIAOhHdj3u3uN62X4uSRO/I=;
        b=n2Q2RAnL7DnbZk97Lxj3cbGP/Ed+kt6TfZUJRsJaN0QHfk0SDXv4s6yF8VQ5kS42hM
         fTpiKT6XOUpr+vY24xBxo+Ld9ivr2Y06ev2Fq90nyt4MhLBWI3VFonPrOj+oPHh0vDdB
         ohvbS7LJgbW8ZjFzwkW0mK2GnplXuVLp3sWt0O6q4xeXDHt+noNKdKDJ8t60fRWCNMd/
         C007k2U6JRQ6igh3c0HdGlPtkl+sUalRiuz/pml4+efk18NWifpZP0AV93zIl6uCGnRs
         OwhfnshhI7wB7k7HpK//VEG4KHwQ+Ci3r/8vxHp3pRc6jbPbeNGmPU9ouwCzmD3oM4ZD
         KMGA==
X-Gm-Message-State: AOAM532iQ/IsCjrRaLUWOIoKpMr6nBDwi//wXY6rK6pEVL424HDg8sQd
        tMrkfw/8BWWwnHZS1bgWFEdQy9kMI49OQAaV69Y=
X-Google-Smtp-Source: ABdhPJxbi38l/6cfFmMw0D4VfYjuNPjnJhQ5Y6mBDjBrG3j6TS9liwFoITwEu9r5opsbk3TyTXVjpQACkqQS4kED/jA=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr6283355ybe.403.1604609150204;
 Thu, 05 Nov 2020 12:45:50 -0800 (PST)
MIME-Version: 1.0
References: <20201028132529.3763875-1-haliu@redhat.com> <20201029151146.3810859-1-haliu@redhat.com>
 <646cdfd9-5d6a-730d-7b46-f2b13f9e9a41@gmail.com> <CAEf4BzYupkUqfgRx62uq3gk86dHTfB00ZtLS7eyW0kKzBGxmKQ@mail.gmail.com>
 <edf565cf-f75e-87a1-157b-39af6ea84f76@iogearbox.net> <3306d19c-346d-fcbc-bd48-f141db26a2aa@gmail.com>
 <CAADnVQ+EWmmjec08Y6JZGnan=H8=X60LVtwjtvjO5C6M-jcfpg@mail.gmail.com>
 <71af5d23-2303-d507-39b5-833dd6ea6a10@gmail.com> <20201103225554.pjyuuhdklj5idk3u@ast-mbp.dhcp.thefacebook.com>
 <20201104021730.GK2408@dhcp-12-153.nay.redhat.com> <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <2e8ba0be-51bf-9060-e1f7-2148fbaf0f1d@iogearbox.net> <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
In-Reply-To: <ec50328d-61ab-71fb-f266-5e49e9dbf98e@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 12:45:39 -0800
Message-ID: <CAEf4BzbQz5ZqoB3TEtM-4e=Ndx9WCGN16Be8-JoK+mvUyAGC3w@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
To:     David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 7:19 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/4/20 3:21 AM, Daniel Borkmann wrote:
> >
> >> Then libbpf release process can incorporate proper testing of libbpf
> >> and iproute2 combination.
> >> Or iproute2 should stay as-is with obsolete bpf support.
> >>
> >> Few years from now the situation could be different and shared libbpf
> >> would
> >> be the most appropriate choice. But that day is not today.
> >
> > Yep, for libbpf to be in same situation as libelf or libmnl basically
> > feature
> > development would have to pretty much come to a stop so that even minor
> > or exotic
> > distros get to a point where they ship same libbpf version as major
> > distros where
> > then users can start to rely on the base feature set for developing
> > programs
> > against it.
>
> User experience keeps getting brought up, but I also keep reading the
> stance that BPF users can not expect a consistent experience unless they
> are constantly chasing latest greatest versions of *ALL* S/W related to

That's not true. If you need new functionality like BTF, CO-RE,
function-by-function verification, etc., then yes, you have to update
kernel, compiler, libbpf, sometimes pahole. But if you have an BPF
application that doesn't use and need any of the newer features, it
will keep working just fine with the old kernel, old libbpf, and old
compiler.

Life is a bit more nuanced, of course. Sometimes a Clang update will
cause a shift in code generation patterns and you'd need either kernel
update (to get improved verifier logic) and/or libbpf update (to
compensate for either kernel or Clang change). Or update Clang again
to get a fixed version. That's life, bugs and problems are real.

If you care about using BTF-powered features, yes, you might need to
update pahole to get basic BTF, or get new BTF funcs needed for
fentry/fexit, or soon you'll need v1.19 if you want kernel module
BTFs. If you don't care about BTF, don't set CONFIG_DEBUG_INFO_BTF=y
and you won't even need pahole. For kernel module BTFs, you can't
request module BTF generation, unless you have a recent enough pahole.
I'm not sure how this can be handled better.

But if you have a plain old boring BPF program using
BPF_MAP_ARRAY/BPF_MAP_HASH, no global variables, you attach it to old
and stable BPF hooks like tracepoint, kprobe, etc., then it will work
with pretty much every version of libbpf, clang, and kernel. Don't
pass '-g' to Clang and BTF won't be generated at all, so you won't
even need BTF sanitization at all. And so on.

The problem is that users do want those new features, because those
allow to do new things or do existing things better/easier/faster. So
then we do ask to upgrade regularly to provide adequate support. But
it's like complaining that you need to update Java VM, compiler, Java
standard library, when you do want to use some new functionality.

> BPF. That is not a realistic expectation for users. Distributions exist
> for a reason. They solve real packaging problems.
>
> As libbpf and bpf in general reach a broader audience, the requirements
> to use, deploy and even tryout BPF features needs to be more user
> friendly and that starts with maintainers of the BPF code and how they
> approach extensions and features. Telling libbpf consumers to make
> libbpf a submodule of their project and update the reference point every
> time a new release comes out is not user friendly.

I have all the rights to ask for this, if I believe it's a better way
to go. Users have the right to refuse. But also iproute2 is not
exactly an end user in this situation, it is part of the BPF
ecosystem. So I think it's reasonable to have a healthy discussion
about the best way to facilitate BPF end-users.

>
> Similarly, it is not realistic or user friendly to *require* general
> Linux users to constantly chase latest versions of llvm, clang, dwarves,
> bcc, bpftool, libbpf, (I am sure I am missing more), and, by extension
> of what you want here, iproute2 just to upgrade their production kernel
> to say v5.10, the next LTS, or to see what relevant new ebpf features
> exists in the new kernel. As a specific example BTF extensions are added
> in a way that is all or nothing. Meaning, you want to compile kernel
> version X with CONFIG_DEBUG_INFO_BTF enabled, update your toolchain.
> Sure, you are using the latest LTS of $distro, and it worked fine with
> kernel version X-1 last week, but now compile fails completely unless
> the pahole version is updated. Horrible user experience. Again, just an
> example and one I brought up in July. I am sure there more.
>
> Linux APIs are about stability and consistency. Commands and libraries
> that work on v5.9 should work exactly the same on v5.10, 5.11, 5.12, ...
> *IF* I want a new feature (kernel, bpf or libbpf), then the requirement
> to upgrade is justified. But if I am just updating my kernel, or
> updating my compiler, or updating iproute2 because I want to try out
> some new nexthop feature, I should not be cornered into an all or
> nothing scheme.
