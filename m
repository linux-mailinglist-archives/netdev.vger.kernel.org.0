Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8679F41A4A2
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 03:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbhI1Bfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 21:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbhI1Bfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 21:35:33 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D5FC061575;
        Mon, 27 Sep 2021 18:33:54 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id h20so21427981ilj.13;
        Mon, 27 Sep 2021 18:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yDdBfVQ3FV8yCaIT01jaciLsPRMByaq1hgjVsAB7Un4=;
        b=qbdJIbnpB/monFmClKiDUcrWzGhPb7IRUxYVUXqEKXzjInf98dUmujpe5QWWJlH9JB
         I7ZtQY2mb3p5GEONEJxQuVHh+Tl/Tfd+BEWE/Mt5zcNl5yNX0cE4/7SWG2hOcgSWQ6tp
         WJYsISLRR9Yur9hm1h5AVGSjvEaFbta1hXK8QLtqvNu8KI7Rsj+OiFMgH3FEuuafTCt5
         3V00ohMViJE1QSQWAz5XHsXx0CHbrxT+ud/QJmu6Iaz+wHHrvrW2iuI42njDspCT6lqz
         iOcGhBfb2aAz7liCcmIFgoE/nOHLwO13oQr1cdn1lk96hKpejk9xqMHM6I82bUk+Rn3x
         YEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yDdBfVQ3FV8yCaIT01jaciLsPRMByaq1hgjVsAB7Un4=;
        b=mMr3nVEPzsLkduZo6DqqoqPDV4Q5lFjvfYTsCBraeXXI57PxO4lPRqln3UpfawF1t/
         pmrHrciwBowSTUDoAZ30M/hGVmNP3cDdh1AN8TIZNP32//4oDsksgxFLi5wQxlt3+qbU
         WTV2r15BzyhhNYjcKXPZjDBLs9nrm3n+8ASqLGl++CevURSExduahtKoP3Prgbcssg4X
         2C5o8su9lo/QEeTTQlSg7T1WguHpuJgVNapNuiPeNifFFaW5HGEdeZ8nECXhr5wP//l1
         s9+qtsPpvXHy/F6tj2XkL4vXfJsLvI/Yip/wrGcdo82FZIMviG/RlPEiUCiYe2SRdtLc
         wLhw==
X-Gm-Message-State: AOAM530QlvoXtPNlQ/Yoa84utLgs6jhe/KcnkzRPeOoiQ/IqMh4aOUIP
        DoaW4IL/uKv1/sMs+MXZObQz4D7c0lU=
X-Google-Smtp-Source: ABdhPJxQZKUpy3npH+6S2iGFK4JpzXS91RE9y/mVv44b4TQ1uEp9GHftjY3njl2wIWCj+29C2wqrUg==
X-Received: by 2002:a05:6e02:1e0d:: with SMTP id g13mr2290063ila.313.1632792833761;
        Mon, 27 Sep 2021 18:33:53 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id j10sm2316235iow.33.2021.09.27.18.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 18:33:53 -0700 (PDT)
Date:   Mon, 27 Sep 2021 18:33:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Message-ID: <615270f889bf9_e24c2083@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzbxYxnQND9JJ4SfQb4kxxkRtk4S4rR2iqkcz6bJ2jdFqw@mail.gmail.com>
References: <20210920151112.3770991-1-davemarchevsky@fb.com>
 <20210923205105.zufadghli5772uma@ast-mbp>
 <35e837fb-ac22-3ea1-4624-2a890f6d0db0@fb.com>
 <CAEf4Bzb+r5Fpu1YzGX01YY6BQb1xnZiMRW3hUF+uft4BsJCPoA@mail.gmail.com>
 <761a02db-ff47-fc2f-b557-eff2b02ec941@fb.com>
 <61520b6224619_397f208d7@john-XPS-13-9370.notmuch>
 <CAEf4BzbxYxnQND9JJ4SfQb4kxxkRtk4S4rR2iqkcz6bJ2jdFqw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification
 stats
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Mon, Sep 27, 2021 at 11:20 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Dave Marchevsky wrote:
> > > On 9/23/21 10:02 PM, Andrii Nakryiko wrote:
> > > > On Thu, Sep 23, 2021 at 6:27 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
> > > >>
> > > >> On 9/23/21 4:51 PM, Alexei Starovoitov wrote:
> > > >>> On Mon, Sep 20, 2021 at 08:11:10AM -0700, Dave Marchevsky wrote:
> > > >>>> The verifier currently logs some useful statistics in
> > > >>>> print_verification_stats. Although the text log is an effective feedback
> > > >>>> tool for an engineer iterating on a single application, it would also be
> > > >>>> useful to enable tracking these stats in a more structured form for
> > > >>>> fleetwide or historical analysis, which this patchset attempts to do.
> > > >>>>

[...] 

> > >
> > > Seems reasonable to me - and attaching a BPF program to the tracepoint to
> > > grab data is delightfully meta :)
> > >
> > > I'll do a pass on alternate implementation with _just_ tracepoint, no
> > > prog_info or fdinfo, can add minimal or full stats to those later if
> > > necessary.
> >
> > We can also use a hook point here to enforce policy on allowing the
> > BPF program to load or not using the stats here. For now basic
> > insn is a good start to allow larger/smaller programs to be loaded,
> > but we might add other info like call bitmask, features, types, etc.
> > If one of the arguments is the bpf_attr struct we can just read
> > lots of useful program info out directly.
> >
> > We would need something different from a tracepoint though to let
> > it return a reject|accept code. How about a new hook type that
> > has something similar to sockops that lets us just return an
> > accept or reject code?
> >
> > By doing this we can check loader signatures here to be sure the
> > loader is signed or otherwise has correct permissions to be loading
> > whatever type of bpf program is here.
> 
> For signing and generally preventing some BPF programs from loading
> (e.g., if there is some malicious BPF program that takes tons of
> memory to be validated), wouldn't you want to check that before BPF
> verifier spent all those resources on verification? So maybe there
> will be another hook before BPF prog is validated for that? Basically,
> if you don't trust any BPF program unless it is signed, I'd expect you
> check signature before BPF verifier does its heavy job.

Agree, for basic sig check or anything that just wants to look at
the task_struct storage for some attributes before we verify is
more efficient. The only reason I suggested after is if we wanted
to start auditing/enforcing on calls or map read/writes, etc. these
we would need the verifier to help tabulate.

When I hacked it in for experimenting I put the hook in the sys
bpf load path before the verifier runs. That seemed to work for
the simpler sig check cases I was running.

OTOH though if we have a system with lots of BPF failed loads this
would indicate a more serious problem that an admin should fix
so might be nicer code-wise to just have a single hook after verifier
vs optimizing to two one in front and one after. 

> 
> >
> > Thanks,
> > John


