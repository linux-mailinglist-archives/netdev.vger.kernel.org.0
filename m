Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14C5369D69
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244240AbhDWXhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244150AbhDWXgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:36:08 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241E1C06134D;
        Fri, 23 Apr 2021 16:35:22 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id d15so6128073ljo.12;
        Fri, 23 Apr 2021 16:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2IUznd0mYk8kC1Jesg1aocZ7WbkNXz/RH7a1/sZko0=;
        b=R6L7T57JgSvuvqH/hdrwUg2JKAaZg3WYW7mtd3pcAif5IX8NYiFUa8BprsN4jYlll7
         LIG/jO18VUpfUmXjXRcX0U7D3Yz8zPv0WNgIu8B2goJx4ANEeCSjZyedlAsobT5wt9wD
         6L5keEr9GQp73rLWPT79LZWSrkZfAPwCTZUrhZhQ37QLpv3632A23R3VujnR3XNNXrUA
         pRkC5bge8bcaSaE96aDM5s/3c382dfuXS8n5O22x/3OfLVuEhIgDr2dJFhR0Wf9o3+5Y
         6VFzJdNeyyLtLYcdCSluhWWGuOo/bbQtZGgC6byidPisH4FPVd2bQVWPGebgeVR/0hua
         B+PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2IUznd0mYk8kC1Jesg1aocZ7WbkNXz/RH7a1/sZko0=;
        b=RHTr+q1UcL3S/hPTox/bfIIoCSaiYoQHCOhVq07GSn5x2drHd8iexKbbL893gW7yxI
         HkAlzANanukx9moiOpmfGCUK0O84Js8zaA0rHq2DcG1xrJYF9l3rX4MzwojtgLIkwSPe
         T5z9Eg+9rb+rANT9cTSAEx7F//jU9zwvn5bj6GSUA7xyJdrCgwn930YgjbA2YKKAcIaQ
         vu+LEOx4zey/D2O4raCvBBpscpxb9C3T7WERqe+XMjfCXCnO9pG4Gd+TPS7Ru+rnI16m
         /mMgC+H7D0JjjhvBnkDjjZYG9pSZ9EVFGZV8xiSTntNc6kf/Q4dj0C16XwMA44yiRN+/
         lxVQ==
X-Gm-Message-State: AOAM533lI5lkRggWoM9jDY0oJOIYuW4FXSv5X2tkEXoMRraW1Viy8kkj
        wEDlg/JhIUt3vlDhNBSxoFSnnj/mmxdCh6JQf4w=
X-Google-Smtp-Source: ABdhPJy4P2tFYtf2NcLEn1Jwl+s0eAC4YUactBjE7sBsmOLTLLVFySQf2lLeMtMrGgoXaYe5HRTlkJxeH4Md+tciizE=
X-Received: by 2002:a2e:a491:: with SMTP id h17mr1224070lji.236.1619220920508;
 Fri, 23 Apr 2021 16:35:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210423185357.1992756-1-andrii@kernel.org> <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com> <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com> <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <588c763f-1383-d92b-116a-c6826ffa1418@fb.com>
In-Reply-To: <588c763f-1383-d92b-116a-c6826ffa1418@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 16:35:09 -0700
Message-ID: <CAADnVQLBaG9Q+xEcDqLDa2prn-7Fs2gqAiYsnQTz9CRBsE6uHw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during linking
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/23/21 4:05 PM, Alexei Starovoitov wrote:
> > On Fri, Apr 23, 2021 at 2:56 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>>
> >>>>> -static volatile const __u32 print_len;
> >>>>> -static volatile const __u32 ret1;
> >>>>> +volatile const __u32 print_len = 0;
> >>>>> +volatile const __u32 ret1 = 0;
> >>>>
> >>>> I am little bit puzzled why bpf_iter_test_kern4.c is impacted. I think
> >>>> this is not in a static link test, right? The same for a few tests below.
> >>>
> >>> All the selftests are passed through a static linker, so it will
> >>> append obj_name to each static variable. So I just minimized use of
> >>> static variables to avoid too much code churn. If this variable was
> >>> static, it would have to be accessed as
> >>> skel->rodata->bpf_iter_test_kern4__print_len, for example.
> >>
> >> Okay this should be fine. selftests/bpf specific. I just feel that
> >> some people may get confused if they write/see a single program in
> >> selftest and they have to use obj_varname format and thinking this
> >> is a new standard, but actually it is due to static linking buried
> >> in Makefile. Maybe add a note in selftests/README.rst so we
> >> can point to people if there is confusion.
> >
> > I'm not sure I understand.
> > Are you saying that
> > bpftool gen object out_file.o in_file.o
> > is no longer equivalent to llvm-strip ?
>
> This is more about BTF and ELF.
> Give a simple example,
> $ cat t1.c
> volatile static int aa = 10;
> int foo() { return aa; }
> $ clang -O2 -g -c -target bpf t1.c
>
> Using bpftool compiled with this patch:
> $ bpftool gen object output.o t1.o
> $ llvm-readelf -s t1.o | grep aa
>       3: 0000000000000000     4 OBJECT  LOCAL  DEFAULT     4 aa
> $ llvm-readelf -s output.o | grep aa
>       3: 0000000000000000     4 OBJECT  LOCAL  DEFAULT     4 aa
>
> $ bpftool btf dump file t1.o | grep aa
> [5] VAR 'aa' type_id=4, linkage=static
> $ bpftool btf dump file output.o | grep aa
> [5] VAR 't1..aa' type_id=4, linkage=static

Right. That's how I understood it.

> So yes you are right, this will affect skeleton user
> if you use static linker with single file.
>
> > Since during that step static vars will get their names mangled?
> > So a good chunk of code that uses skeleton right now should either
> > 1. don't do the linking step
> > or
> > 2. adjust their code to use global vars
> > or
> > 3. adjust the usage of skel.h in their corresponding user code
> >    to accommodate mangled static names?
> > Did it get it right?

It feels that the strategy of mangling every static name is too harsh.
Maybe sub-skeleton is an answer?
Something that would do a sub-skeleton for each file?
Mainly to keep "bpftool gen object output.o t1.o" from messing with btf names.
Maybe linking of btf-s from multiple .o should somehow scope them?
I don't have a concrete suggestion yet.
