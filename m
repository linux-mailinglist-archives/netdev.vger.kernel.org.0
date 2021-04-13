Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F3735E475
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346967AbhDMQ6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:58:31 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:43700 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345673AbhDMQ6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:58:30 -0400
Received: by mail-lf1-f45.google.com with SMTP id r8so28335362lfp.10;
        Tue, 13 Apr 2021 09:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v4TjHCXfhg5d3LryO0dAvVeknac0k2NZ/3RM2aA8938=;
        b=f3UEPkvUinbjyZ+3ysqA1LgBZJfqb7CMeN8m/FHDsqK4+L/XHEHaZ9lLz2oK+ONlCS
         HihjonPwPXsmjPs9sF1B7GXmgLb7H9+ZgiKLVKpDA4Jq0aZUu0BG24wBn0k0r9FggK65
         13U7tx8DvcEQ9THUnUSo4RYy61bQiiVcpVlvL6SRIm+RRvlgQWacL9BfITPamvnGUTM3
         KKMyncRsIzgx+LjrKGLZxecHzLxolt/Xovfj4Ky29b0AhKRYZc4Oqm6Yq1ze3CXorMS8
         DoE6zWiCdVznpYeQQj+wWdwDbk4GlyEjThpGgIOWTXhbLYSvHAhVEI4pnUl6Ro0EbIAw
         s9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v4TjHCXfhg5d3LryO0dAvVeknac0k2NZ/3RM2aA8938=;
        b=W3mqWip97jAffsfMkMgBGOJ4WfcgvqQTWSu/eRVLAM6JYkOU10aaKxVlrhyK8eyLE3
         VqNjyFLegZC1mfu7e799II92zUib1qGuobTPhtGZbPVc8HP18o48t2RuC+x3NzlVHLPA
         bXXFBSdq2SqW1SyPE//PE7jNafqCGBVDh761qMNgNsBFpNB+LV61S0lfwzs4yEzZQ8jP
         4atWZ53cR60xFj4sstvrebJF+sgXzy1Va+gaAmG0F8v1Qh3MPQZB7R31p/DUQZ4/8Sgf
         k1atsqs0ktKTgl5z0r4e3R7dax3gJy83xK1PmAVW4i+0P1tA/v3ub38wdHQdJfmvYBKa
         tSLA==
X-Gm-Message-State: AOAM530PapGckSdxd16NJeq84Z8Um2CQ+RqMQw5w4U2Xkf8AjJc88iW9
        GG9XTnfztizi8k5MICvza3e5BG0R3s1HgikTigk=
X-Google-Smtp-Source: ABdhPJz4ZYKeSz0KzfjB/w6RSk76BvVX4LTIVHLs0Vqhf8mOKgbueanMN6S743dv4qvskZUZH3vW/UCo3BRM1J/3xfM=
X-Received: by 2002:a19:c1d4:: with SMTP id r203mr23420280lff.182.1618333028915;
 Tue, 13 Apr 2021 09:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
 <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com>
 <BN7PR13MB2499152182E86AD94A3B0E22FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQKjVDLBCLMzXoAQhJ5a+rZ1EKqc3dyYqpeG9M2KzGREMA@mail.gmail.com> <BN7PR13MB2499EF2A7B6F043FE4E62D51FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
In-Reply-To: <BN7PR13MB2499EF2A7B6F043FE4E62D51FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 13 Apr 2021 09:56:57 -0700
Message-ID: <CAADnVQJ1+EmGD3CAc4N8Jq7ACYZvbzkxZrhz8hVf4dJHGamoXw@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: use !E instead of comparing with NULL
To:     "Bird, Tim" <Tim.Bird@sony.com>
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 9:32 AM <Tim.Bird@sony.com> wrote:
>
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> >
> > On Tue, Apr 13, 2021 at 9:19 AM <Tim.Bird@sony.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > >
> > > > On Tue, Apr 13, 2021 at 9:10 AM <Tim.Bird@sony.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > > > >
> > > > > > On Tue, Apr 13, 2021 at 2:52 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
> > > > > > >
> > > > > > > Fix the following coccicheck warnings:
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:189:7-11: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:361:7-11: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:386:14-18: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:402:14-18: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:433:7-11: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:534:14-18: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:625:7-11: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > > ./tools/testing/selftests/bpf/progs/profiler.inc.h:767:7-11: WARNING
> > > > > > > comparing pointer to 0, suggest !E
> > > > > > >
> > > > > > > Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> > > > > > > Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> > > > > > > ---
> > > > > > >  tools/testing/selftests/bpf/progs/profiler.inc.h | 22 +++++++++++-----------
> > > > > > >  1 file changed, 11 insertions(+), 11 deletions(-)
> > > > > > >
> > > > > > > diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > > > > > index 4896fdf8..a33066c 100644
> > > > > > > --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > > > > > +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> > > > > > > @@ -189,7 +189,7 @@ static INLINE void populate_ancestors(struct task_struct* task,
> > > > > > >  #endif
> > > > > > >         for (num_ancestors = 0; num_ancestors < MAX_ANCESTORS; num_ancestors++) {
> > > > > > >                 parent = BPF_CORE_READ(parent, real_parent);
> > > > > > > -               if (parent == NULL)
> > > > > > > +               if (!parent)
> > > > > >
> > > > > > Sorry, but I'd like the progs to stay as close as possible to the way
> > > > > > they were written.
> > > > > Why?
> > > > >
> > > > > > They might not adhere to kernel coding style in some cases.
> > > > > > The code could be grossly inefficient and even buggy.
> > > > > There would have to be a really good reason to accept
> > > > > grossly inefficient and even buggy code into the kernel.
> > > > >
> > > > > Can you please explain what that reason is?
> > > >
> > > > It's not the kernel. It's a test of bpf program.
> > > That doesn't answer the question of why you don't want any changes.
> > >
> > > Why would we not use kernel coding style guidelines and quality thresholds for
> > > testing code?  This *is* going into the kernel source tree, where it will be
> > > maintained and used by other developers.
> >
> > because the way the C code is written makes llvm generate a particular
> > code pattern that may not be seen otherwise.
> > Like removing 'if' because it's useless to humans, but not to the compiler
> > will change generated code which may or may not trigger the behavior
> > the prog intends to cover.
> > In particular this profiler.inc.h test is compiled three different ways to
> > maximize code generation differences.
> > It may not be checking error paths in some cases which can be considered
> > a bug, but that's the intended behavior of the C code as it was written.
> > So it has nothing to do with "quality of kernel code".
> > and it should not be used by developers. It's neither sample nor example.
>
> Ok - in this case it looks like a program, but it is essentially test data (for testing
> the compiler).  Thanks for the explanation.

yes. That's a good way of saying it.
Of course not all tests are like this.
Majority of bpf progs in selftests/bpf/progs/ are carefully written,
short and designed
as a unit test. While few are "test data" for llvm.
