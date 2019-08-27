Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5539DAB5
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 02:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfH0Aec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 20:34:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36069 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbfH0Aec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 20:34:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id w2so12909826pfi.3;
        Mon, 26 Aug 2019 17:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9Z9ZpdNHcBGyUVSvsMnO5/9hIN2hnnSkhV9BOJaFPCQ=;
        b=PJ60iU40NfJKr8gs35JCe0XjpiGTGNudc+PExMPUiDVWeAwXl9KwUn2F5iupt07l6e
         6NY8UjNvchEfy+bj+Ts72dOCY2Zccqkln4veoX40SWcoKW2w2hNrboaxdlK8AfPklQ6m
         5siULEiiuporwVXgjWNZhq6pRbe44+fSqOVxE6by/X8a3siwgQCtN1E3jhkp5oAu6tuC
         V84GFwf14MtvFoypMlm9mGbcZUBbuyZeua9Om3FRGvnH55DxfqsJWq4lIC9SQQSQGtXG
         hgg2w11cYw4/K2D8aumRA/bjhWVodUNV067qvyqItmH7t2kP1AzBGFceWY00MzMjuWaq
         BGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9Z9ZpdNHcBGyUVSvsMnO5/9hIN2hnnSkhV9BOJaFPCQ=;
        b=K347t0wIGumTrGab+AkssVYOzaLmlMNqRHULJCQIEnD5I0VXO8Rb4TXB0ITL6QJQ4U
         1hv4UGrwyC7w0954DqQG4qnruqNvwKEd4+dW4kCVyLuVHfvB9egbf4hCvNapg9Xzs7lN
         mx+FVCyRU2xPDoTkFp8Lr2UnsGSnWrqJZJ3YXZ4wklG2BTefxE5HB6cP5+3k97vIAy6N
         J2pNMwnUxhhkUND0CQBp2Z19l88c3gxsiP0JvYiIvHfiH6iITGF+eP+aH5RKd/fWMKFb
         ichxGFxdoCa0PkaG9PVR5M4Plsly6lhFWsNbvYkrViiHoedtx0buJh/SzfhUSV8zU7hv
         PlQw==
X-Gm-Message-State: APjAAAWu3WnDSLwFeCHoz/y49/8BjAvNuDA2D13umMfsXesPRYManVLW
        JRr8Xwc4LhPkuogdCOslj/Y=
X-Google-Smtp-Source: APXvYqzITkJGpoAKvnwcdaKEmtym/xYMkPKi8ZpnB+aH1GlqnecKePOiHOi47Yn9rLQR7DI2x8z80A==
X-Received: by 2002:aa7:8808:: with SMTP id c8mr22395501pfo.67.1566866071542;
        Mon, 26 Aug 2019 17:34:31 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:200::f983])
        by smtp.gmail.com with ESMTPSA id q13sm21310334pfl.124.2019.08.26.17.34.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 17:34:30 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:34:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Chenbo Feng <chenbofeng.kernel@gmail.com>
Subject: Re: RFC: very rough draft of a bpf permission model
Message-ID: <20190827003427.hcvrobr23uhqwmq5@ast-mbp>
References: <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <98fee747-795a-ff10-fa98-10ddb5afcc03@iogearbox.net>
 <CALCETrUWQbPK3Pc6P5i_UqHPXJmZVyvuYXfq+VRtD6A3emaRhw@mail.gmail.com>
 <CALCETrWU4xJh4UBg0BboCwdGrgj+dUShsH5ETpiRgEpXJTEfQA@mail.gmail.com>
 <20190822232620.p5tql4rrlzlk35z7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUhXrZaJy8omX_DsH0rAY98YEqR64VuisQSz2Rru8Dqpg@mail.gmail.com>
 <20190826223558.6torq6keplniif6w@ast-mbp>
 <CALCETrUARqcn8EmjcgMc8KP=4O5nZDMh=tcruEYvUgSzMKJUBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUARqcn8EmjcgMc8KP=4O5nZDMh=tcruEYvUgSzMKJUBw@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 05:05:58PM -0700, Andy Lutomirski wrote:
> >>
> >> The BPF verifier and interpreter, taken in isolation, may be extremely
> >> safe, but attaching BPF programs to various hooks can easily take down
> >> the system, deliberately or by accident.  A handler, especially if it
> >> can access user memory or otherwise fault, will explode if attached to
> >> an inappropriate kprobe, hw_breakpoint, or function entry trace event.
> >
> > absolutely not true.
> 
> This is not a constructive way to have a conversation.  When you get
> an email that contains a statement you disagree with, perhaps you
> could try to give some argument as to why you disagree rather than
> just saying "absolutely not true".  Especially when you are talking to
> one of the maintainers of the affected system who has a
> not-yet-finished branch that addresses some of the bugs that you claim
> absolutely don't exist.  If it's really truly necessary, I can go and
> write an example that will crash an x86 kernel, but I feel like it
> would be a waste of everyone's time.

Please do write an example and prove your earlier sensational statement
that "can _easily_ take down the system" by attaching bpf to kprobe.

Most of the functions where kprobes are not allowed are already
marked by 'nokprobe'. All of them marked? Probably not.
There could be places where kprobe will blow the system, but
1. it's not easy to do. unlike your claim
2. that issue has nothing to do with bpf safety guarantees.

> How confident are you that the BPF program that calls bpf_probe_read()
> on an MMIO address has well-defined semantics?  How confident are you
> that the system will still work if such a program runs?

bpf_probe_read is a wrapper of probe_read. Nothing more.
I'm confident that probe_read maintainers are doing good job.

All of the bpf tracing is relying on existing kernel mechanisms
like kprobe, uprobe, perf, probe_read, etc.
bpf verifier cannot make them safer.
If reading mmio via bpf_probe_read will trigger undesired
hw behavior there is nothing bpf verifier can do about it.

