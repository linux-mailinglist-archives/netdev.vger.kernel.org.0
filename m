Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBBE1FFF27
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgFSAJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgFSAJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:09:53 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B30C06174E;
        Thu, 18 Jun 2020 17:09:51 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id f18so7464754qkh.1;
        Thu, 18 Jun 2020 17:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=goKnSJ9Yl+PkTpEVqaK8ariT/zkQ6gQTfe/iZV40tgc=;
        b=fFwOv5EYvwiOcTptsxqlxZDyDhrTtGzKVvVAh6N7hoGJOmUoiqx7GjjJHI2Caku8cP
         F4or2dOHfMlR284c/bxuIr1G1t1OsaN6SAiz/ro9lMRV2LoCk860A0eAv7rr0+30cfC9
         lfdIKjOLHAzgvu5c6YsLtZQOBDHFyXRhdy02Xbsx6vBiNAuLMpMkwLKmrMbGlo/uy98l
         j7BaCUq3xyYfyTeT6xO1s/nfHVk67OC4a3I9gEPe3x98aqJjGNpcf7+5B3n28r20zF/h
         pDtrEgzubfkCUviZHl5BZCuFRCWzAYu09j/gLKcCl2KyJhpyqAirtYfnULp4GmTut1ed
         Lf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=goKnSJ9Yl+PkTpEVqaK8ariT/zkQ6gQTfe/iZV40tgc=;
        b=AF7f97Y/ipo2RitJZus+S5BGnnh1F7EEywp7Jxu28mPlmeaoj3PtUn92rFysfmVhwd
         GrbWRTV8WJo7S75xl7R77sIciAVoI8nSWGFOf3jWaO17aegFGwI0nya2EM6ugyptSenB
         Q5Sd7D+Zenp+5jCess3ZjmE+sS1GOtLiabF761FZiIJTrR3xEaaVXcqRj8KBp2p5qSMI
         1ZPZV2zmoBi7+8OsfzWSg7ygMKdKPXIU3ct3l9utSvAbW3AUbj34Fr70DbS5J6gXnQbN
         j+kSGk8i+ZoMOth/afKTgYx4q4RsXA1ZhrsIlg4mtOJBYLaMe/96jUARx2jgkYv6/jEW
         f00A==
X-Gm-Message-State: AOAM531ma82cIXCa/6QBHcVh7wZVizhnCznQks6ZpDzoMyDAhSLDSBIX
        An7anhykZ9iAMyMwE80kFHTUDxA9Vs+vObaf8Z8=
X-Google-Smtp-Source: ABdhPJx2g6BdseJXSaZ35AlifprvBM0XYJUALV5hIgGbvNJnT+Kd7ogVcC3CQzoK01zr2lB7SP1OI/tX7AsOaU/xKPw=
X-Received: by 2002:a37:d0b:: with SMTP id 11mr1097036qkn.449.1592525389666;
 Thu, 18 Jun 2020 17:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200616050432.1902042-1-andriin@fb.com> <20200616050432.1902042-2-andriin@fb.com>
 <5eebbbef8f904_6d292ad5e7a285b883@john-XPS-13-9370.notmuch>
 <CAEf4BzYNFddhDxLAkOC+q_ZWAet42aHybDiJT9odrzF8n5BBig@mail.gmail.com> <5eebfd54ec54f_27ce2adb0816a5b876@john-XPS-13-9370.notmuch>
In-Reply-To: <5eebfd54ec54f_27ce2adb0816a5b876@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 17:09:38 -0700
Message-ID: <CAEf4Bzbt4=Cvm4Gj0_OnxqYQsyrtLxcMO5EoZntquS3WFqihCg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 4:48 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Thu, Jun 18, 2020 at 12:09 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Andrii Nakryiko wrote:
> > > > Add selftest that validates variable-length data reading and concatentation
> > > > with one big shared data array. This is a common pattern in production use for
> > > > monitoring and tracing applications, that potentially can read a lot of data,
> > > > but usually reads much less. Such pattern allows to determine precisely what
> > > > amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> > > >
> > > > This is the first BPF selftest that at all looks at and tests
> > > > bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
> > > > testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
> > > > 0 on success, instead of amount of bytes successfully read.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > > ---
> > >
> > > [...]
> > >
> > > > +/* .data */
> > > > +int payload2_len1 = -1;
> > > > +int payload2_len2 = -1;
> > > > +int total2 = -1;
> > > > +char payload2[MAX_LEN + MAX_LEN] = { 1 };
> > > > +
> > > > +SEC("raw_tp/sys_enter")
> > > > +int handler64(void *regs)
> > > > +{
> > > > +     int pid = bpf_get_current_pid_tgid() >> 32;
> > > > +     void *payload = payload1;
> > > > +     u64 len;
> > > > +
> > > > +     /* ignore irrelevant invocations */
> > > > +     if (test_pid != pid || !capture)
> > > > +             return 0;
> > > > +
> > > > +     len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> > > > +     if (len <= MAX_LEN) {
> > >
> > > Took me a bit grok this. You are relying on the fact that in errors,
> > > such as a page fault, will encode to a large u64 value and so you
> > > verifier is happy. But most of my programs actually want to distinguish
> > > between legitimate errors on the probe vs buffer overrun cases.
> >
> > What buffer overrun? bpf_probe_read_str() family cannot return higher
> > value than MAX_LEN. If you want to detect truncated strings, then you
> > can attempt reading MAX_LEN + 1 and then check that the return result
> > is MAX_LEN exactly. But still, that would be something like:
> > u64 len;
> >
> > len = bpf_probe_read_str(payload, MAX_LEN + 1, &buf);
> > if (len > MAX_LEN)
> >   return -1;
> > if (len == MAX_LEN) {
> >   /* truncated */
> > } else {
> >   /* full string */
> > }
>
> +1
>
> >
> > >
> > > Can we make these tests do explicit check for errors. For example,
> > >
> > >   if (len < 0) goto abort;
> > >
> > > But this also breaks your types here. This is what I was trying to
> > > point out in the 1/2 patch thread. Wanted to make the point here as
> > > well in case it wasn't clear. Not sure I did the best job explaining.
> > >
> >
> > I can write *a correct* C code in a lot of ways such that it will not
> > pass verifier verification, not sure what that will prove, though.
> >
> > Have you tried using the pattern with two ifs with no-ALU32? Does it work?
>
> Ran our CI on both mcpu=v2 and mcpu=v3 and the pattern with multiple
> ifs exists in those tests. They both passed so everything seems OK.
> In the real progs though things are a bit more complicated I didn't
> check the exact generate code. Some how I missed the case below.
> I put a compiler barrier in a few spots so I think this is blocking
> the optimization below causing no-alu32 failures. I'll remove the
> barriers after I wrap a few things reviews.. my own bug fixes ;) and
> see if I can trigger the case below.
>
> >
> > Also you are cheating in your example (in patch #1 thread). You are
> > exiting on the first error and do not attempt to read any more data
> > after that. In practice, you want to get as much info as possible,
> > even if some of string reads fail (e.g., because argv might not be
> > paged in, but env is, or vice versa). So you'll end up doing this:
>
> Sure.
>
> >
> > len = bpf_probe_read_str(...);
> > if (len >= 0 && len <= MAX_LEN) {
> >     payload += len;
> > }
> > ...
> >
> > ... and of course it spectacularly fails in no-ALU32.
> >
> > To be completely fair, this is a result of Clang optimization and
> > Yonghong is trying to deal with it as we speak. Switching int to long
> > for helpers doesn't help it either. But there are better code patterns
> > (unsigned len + single if check) that do work with both ALU32 and
> > no-ALU32.
>
> Great.
>
> >
> > And I just double-checked, this pattern keeps working for ALU32 with
> > both int and long types, so maybe there are unnecessary bit shifts,
> > but at least code is still verifiable.
> >
> > So my point stands. int -> long helps in some cases and doesn't hurt
> > in others, so I argue that it's a good thing to do :)
>
> Convinced me as well. I Acked the other patch thanks.

Awesome :) Thanks for extra testing and validation on your side!
