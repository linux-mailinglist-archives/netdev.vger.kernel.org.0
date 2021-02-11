Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5C931902B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbhBKQjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbhBKQhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:37:11 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DEAC061574;
        Thu, 11 Feb 2021 08:36:28 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id q9so5626640ilo.1;
        Thu, 11 Feb 2021 08:36:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=T7IfdITc2G6l0UJ7iQZqMpmWkPqCDFFsuFOokca/bRM=;
        b=cjq3KD1hLVOE4Z4oipVeSCZcoTVL7rRhkLe4RpF0JH2DchV72aEcZbmMUPeFO1Rle8
         8TafWSIe9Y4m54B1ZZJK1Zu6v2ruOCD444JuVAv1MvIQNYgFennWS3HK7eqPdcOj39Dj
         eBT2pv5NQOr88GkYvgp4nB7nyKN/zLDeb8UMcRSCAogus8BVIubbok8bIRNWGtqhLRzw
         fKcU+dw79NMAbB4q7jzEwi1MTlNVqaWV8SPRwMIQLN0FpDpflGqnnrVolEH8KX9iQXuC
         xKIv1u1q6u5SMrGC+TQ5gHyivvWrhMiCOfqRp3+fX4nE/dH/qJG8xqaB3JJsZudIwwZ3
         6Nmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=T7IfdITc2G6l0UJ7iQZqMpmWkPqCDFFsuFOokca/bRM=;
        b=pp8Ksu/xgkpaYqb6pgs7rYr1tidc1qmrGyc5nFGy55fiJiGKZujuplGxmEFj00zif/
         JerIIuptTx5Pcd5DF5Cc0dl9ZtCFM+CX2V/BX3vsMot32Df1ksN4/CY16jG/KLAdROD7
         E7SWqtrRDm7SR5IQsERSvwD10TxxEYehl63gJ/eSAd4A0SGSkfFOCInzXIYpsNEtx4IW
         Mvn5MIOHYEtsIDggLXXMvEgA4BfvBSvKLuRR7MADL5oLrQkFmo+soR7x3THQrmoME39Y
         GoLUO8Ffw40zUtO9JfjA4c3J4/b29oH38W/gY8pxgZXe1fm+Z2Sn25kuLgAvUKJcHasX
         EkkQ==
X-Gm-Message-State: AOAM530ZtHVH82JLRwf1CCWjZnPghuw/KpsckyDFZNN/08OrlIHt+o+j
        ogyu24Og3jlvirnbH1kOXhsLTr74KerLZ/7pwWk=
X-Google-Smtp-Source: ABdhPJyXlPHHikWMAqYlGx83bSVgiHeZwPihSI7pebcew5wDt2j5rxDGaSuaSi2j5shZWrFi0HNwWlrFIkmg8RTAqQw=
X-Received: by 2002:a05:6e02:4ca:: with SMTP id f10mr2993363ils.112.1613061387730;
 Thu, 11 Feb 2021 08:36:27 -0800 (PST)
MIME-Version: 1.0
References: <YCKB1TF5wz93EIBK@krava> <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava> <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava> <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava> <YCVIWzq0quDQm6bn@krava> <CA+icZUXdWHrNh-KoHtX2jC-4yjnMTtA0CjwzsjaXfCUpHgYJtg@mail.gmail.com>
 <YCVWONQEBLfO/i2z@krava>
In-Reply-To: <YCVWONQEBLfO/i2z@krava>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Thu, 11 Feb 2021 17:36:16 +0100
Message-ID: <CA+icZUU5rQ2da_MpKBCngZZR5mHTj5r6Pn_WovMu_C1PXd=1BQ@mail.gmail.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 5:07 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Feb 11, 2021 at 04:43:48PM +0100, Sedat Dilek wrote:
>
> SNIP
>
> > > > filled with elf functions start/end values, right?
> > > >
> > > > >                         /*
> > > > >                          * We iterate over sorted array, so we can easily skip
> > > > >                          * not valid item and move following valid field into
> > > > >
> > > > >
> > > > > So the idea is to use address segments and check whether there is a
> > > > > segment that overlaps with a given address by first binary searching
> > > > > for a segment with the largest starting address that is <= addr. And
> > > > > then just confirming that segment does overlap with the requested
> > > > > address.
> > > > >
> > > > > WDYT?
> > >
> > > heya,
> > > with your approach I ended up with change below, it gives me same
> > > results as with the previous change
> > >
> > > I think I'll separate the kmod bool address computation later on,
> > > but I did not want to confuse this change for now
> > >
> >
> > I have applied your diff on top of pahole-v1.20 with Yonghong Son's
> > "btf_encoder: sanitize non-regular int base type" applied.
> > This is on x86-64 with LLVM-12, so I am not directly affected.
> > If it is out of interest I can offer vmlinux (or .*btf* files) w/ and
> > w/o your diff.
>
> if you could run your tests/workloads and check the new change does not
> break your stuff, that'd be great
>
> we need soem testsuite ;-) I have some stupid test script which runs over
> few vmlinux binaries and check the diff in BTF data.. problem is that these
> vmlinux binaries are ~300M each, so it's not great for sharing
>
> also I was checking if we could use BPF_BTF_LOAD syscall and load BTF in
> kernel and back at the end of pahole processing to check it's valid ;-)
>

Just finished a new build.

What I did:

cd /path/to/linux/git
rm -v .*btf* vmlinux*
<re-run my build-script with modified pahole>

I collected some commands in CBL issue #1297.

$ /usr/sbin/bpftool btf dump file vmlinux | rg 'vfs_truncate|bpf_d_path'
[22259] TYPEDEF 'btf_bpf_d_path' type_id=22260
[29970] FUNC 'vfs_truncate' type_id=29969 linkage=static

Tests?

$MAKE $MAKE_OPTS -C tools/testing/selftests/bpf/

^^^ ???

- Sedat -

[1] https://github.com/ClangBuiltLinux/linux/issues/1297

> thanks,
> jirka
>
