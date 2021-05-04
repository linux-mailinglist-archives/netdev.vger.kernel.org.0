Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD7137252C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 06:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhEDEnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 00:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhEDEnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 00:43:02 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC65CC061574;
        Mon,  3 May 2021 21:42:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id p12so5624866pgj.10;
        Mon, 03 May 2021 21:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KW+fRCA3KF3M2uynkFKhiTgzVKXGI2fDAmROBsgOsPo=;
        b=cTZW4NU7wHKUxWOHXurIVemWzCJ1mQa7Yvb3DkpdWtGL8gEMrOnVLMyXOHg6m8td7N
         TdJR4J2l7bBv3v+rdhPT+w72ebLNuwsaVMlF7/frMSoriIYprZHRNa4ARIUCkxgorKOX
         DkggLV7OvW37xegGSDfJmCdLr+nJ+sCmZ6F1mu+uM8ccFyNoxAcCRg8o8EDOzhRHJaSF
         mXfjuwFvVESVERx8NRTs19RRxauyw/AalvuNPqZUznMFiByKN8qwK9c65UcUHHM98GH6
         toCA3Q0ylFNNOIkbqFG/Z2BFpgu/AOFQZJM0ePMHsKVkxr5IMGFIQzVO7BA175ohxSo1
         uICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KW+fRCA3KF3M2uynkFKhiTgzVKXGI2fDAmROBsgOsPo=;
        b=ni1ODhf15uUkUKrJtwLKaUGyGsyKdLtN8B7AhlMTevKfQCgasfMjIPJfDRGysUZI84
         20CQJjKwc1vx1yVLo6lsls8bNfx/CDzeNNhee2Br5I9VRmUB7No76AwcR0JinCBW5Jjn
         NSn1rE1+AxUSFZFJE9TzRsg1M+7fXMrRyS9k9YJvY+M/FFWIarHiInBBNuXQh1zbsxdh
         uiZ4JysL4BmdfWeNBfjmCJmY70lG4mpFQ5q2y2pDtLN5BS7o+i1nYf+JBuCwli02ITuZ
         +ehDHXyKovCmEv7o6lm3OgKHbnnkdoEMWwE43+LBXX/5Ff9orU++IxWcmn6V1Qoqb8S9
         5Uwg==
X-Gm-Message-State: AOAM53225EE/MKYc7PPNYK901jvrPRm/Q1nsFnCjNvM+xZh5rSoer6Zt
        Lm7ngpUqRxuvgE/dvzHiq7c=
X-Google-Smtp-Source: ABdhPJzSX6auQGtgL+iG86nB3dJtMcePmetW+eFimTAhMv3HYS0rafv0wNtaCFH9khrRbjhVk1WMVQ==
X-Received: by 2002:a17:90b:e07:: with SMTP id ge7mr24967944pjb.204.1620103327121;
        Mon, 03 May 2021 21:42:07 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c859])
        by smtp.gmail.com with ESMTPSA id v18sm1514508pgl.94.2021.05.03.21.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 21:42:06 -0700 (PDT)
Date:   Mon, 3 May 2021 21:42:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, lmb@cloudflare.com,
        john.fastabend@gmail.com
Subject: bpf libraries and static variables. Was: [PATCH v2 bpf-next 2/6]
 libbpf: rename static variables during linking
Message-ID: <20210504044204.kpt6t5kaomj7oivq@ast-mbp>
References: <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
 <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZo7_r-hsNvJt3w3kyrmmBJj7ghGY8+k4nvKF0KLjma=w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 12:33:36PM -0700, Andrii Nakryiko wrote:
> > At least I'm only starting to grasp the complexity of the problem.
> 
> I did and didn't find anything satisfactory. But I think we are coming
> at this from two different angles, which is why we can't agree on
> anything. So just a reminder, static is about two properties:
>     1) access protection
>     2) naming collisions.
> 
> I'm trying to let name collisions on BPF side happen and be allowed
> *while* also allowing access to those same name-collisioned entities
> (maps and vars, both) from user-space in some non-random fashion. That
> inevitably requires some compromises/conventions on the user-space
> side. Such an approach preserves both 1) and 2).
> 
> You are trying to enforce unique names (or at least aliases) for
> static variables, if I understand correctly, which preserves 1) at the
> expense of 2). It seems to be a similar idea with custom SEC(), though
> you ignored my request to elaborate on how you see that used, so I'm
> guessing here a bit.
> 
> But I think we can get just 1) with global variables with custom
> visibilities. E.g., just marking map/variable as __hidden would
> disallow extern'ing it from other files. That's obviously limiting for
> extern'ing within the library, so we can keep digging deeper and
> define __internal (STV_INTERNAL) that would be "upgraded" to
> STV_HIDDEN after the initial linking pass. So you'd compile your BPF
> library with __internal, but your lib.bpf.o will have those global
> variables as STV_HIDDEN and thus inaccessible from other libraries and
> BPF app itself.
> 
> So if we are ok breaking existing static variable users, then just
> dropping statics from BPF skeleton and supporting extra __hidden and
> __internal semantics for variables and maps would bypass these issues.
> I wanted statics mostly for property 2), but if I can't get it, then
> I'd drop statics from skeletons altogether.
> 
> If I could drop statics for skeletons that were statically linked,
> that wouldn't be a regression. It's impossible to do right now, but we
> can also add a new SHT_NOTE section, which we can use to detect
> statically linked vs Clang-generated .bpf.o. Certainly more ELF
> fussing around than I'd like, but not the end of the world either.
> 
> Thoughts? Did that summarize the issue well enough?

Background for all:

Until Nov 2019 libbpf didn't support global variables, so bpf programs
contained code like 'static volatile const int var = 1;'
Then the skeleton was introduced which went through BTF of a given
datasec and emitted all variables from that section into .skel.h.
It didn't bother filtering static vs global variables, so
static vars in *.bpf.c world became visible into user space *.c world.
While libbpf supported single bpf.o file such extern-ing of statics
was fine, but with support of linking multiple *.bpf.o there
is a question of what to do with static variables with the same names
in different files.

Consider the following scenario:
One bpf developer creates a library conntrack. It has
impl.bpf.c
ct_api.bpf.c
and corresponding user space ct.c that uses skel.h to access
data in these two bpf files.

Another bpf developer creates a library for lru. It has
impl.bpf.c
lru_api.bpf.c
and corresponding user space lru.c.

Now the 3rd developer is writing its main.bpf.c and wants to use these libs.

The libs should be usable in pre-compiled form. The availability of
the source code is nice, but it shouldn't be mandatory.

So there is libct.a (with user space) and libct.bpf.a (with bpf code)
and liblru.a (user) and liblru.bpf.a (bpf code).

The developer should be able to link
main.bpf.o liblru.bpf.a libct.bpf.a
into final_main.bpf.o
And link main.o liblru.a libct.a with user space bits into a.out.

The lru.skel.h and ct.skel.h used by these libs were generated
out of corresponding *.bpf.o and independent of each other.
There should be no need to recompile user space lru.c and ct.c after
linking of final_main.bpf.o and generating final skeleton.

I think all three developers should be able to use static variables
in their .bpf.c files without worrying about conflicts across three
projects.
They can use global vars with __attribute__("hidden"),
but it's not equivalent to static. The linker will complain of
redefinition if the same name is used across multiple files
or multiple libs.
So doing 'int var __attribute__("hidden");' in libct.bpf.a and
in liblru.bpf.a will prevent linking together.
That's traditional static linking semantics.

Using file name as a prefix for static vars doesn't work in general,
since file names can be the same.
What can work is the library name. The library name is guaranteed to be
unique in the final linking phase.
I think we can use it to namespace static variables across
three sets of bpf programs.
Also I think it's ok to require a single developer to enforce
uniqueness of static vars within a project.

In other words 'static int a;' in impl.bpf.c will conflict
with 'static int a;' in ct_api.bpf.c
But the static variable in ct_api.bpf.c will not conflict
with the same variable in lru_api.bpf.c and will not conflict
with such var in main.bpf.c because they're in a different namespaces.

Here are few ways for the programmer to indicate the library namespaces:

- similar to 'char license[]' use 'char library[]="lru";' in *.bpf.c
The static linker will handle this reserved name specially just like
it does 'license' and 'version'.

- #pragma clang attribute push (__attribute__((annotate("lib=lru"))), apply_to = variable)

- #pragma comment(lib, "lru")

I think it's important to define namespaces within *.bpf.c.
Defining them outside on linker command line or linker script is cumbersome.

I think combining *.o into .a can happen with traditional 'ar'. No need for
extra checks for now.
The linking of main.bpf.o liblru.bpf.a libct.bpf.a
will fail if static vars with the same name are present within the same library.
The library namespaces will prevent name conflicts across libs and main.bpf.o
If namespace is not specified it means it's empty, so the existing
hacks of 'static volatile const int var;' will continue working.

The skeleton can have library name as anon struct in skel.h.
All vars can be prefixed too, but scoping them into single struct is cleaner.

I think it doesn't hurt if final_main.skel.h includes all bpf vars from lru and
ct libraries, but I think it's cleaner to omit them.

It's not clear to me yet how final_main__open() and final_main__load() skeleton
methods will work since lru and ct libs might need their specific initialization
that is done by user space lru.c and ct.c.
Also the whole scheme should work with upcoming light skeleton too.
The design for bpf libraries should accommodate signed libraries.

All of the above is up for discussion. I'd love to hear what golang folks
are thinking, since above proposal is C centric.
