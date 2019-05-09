Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C99184A6
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 06:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfEIEr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 00:47:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39080 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbfEIEr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 00:47:26 -0400
Received: by mail-pg1-f195.google.com with SMTP id w22so532469pgi.6;
        Wed, 08 May 2019 21:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Pjs6VzqQNMUZ72aHk2/E5DqfjycX6mBSIAqq4hTXs1U=;
        b=ksM4/kSgCM1PadG+6R/vDit058pFCL9BwgzRYQ8PiRz9MNywdTQOqf8ToIkA+L2WrG
         rqa4Gllk30XDuHLKIal5ahlcPmPSAk/Zf7jLNBwlQ+ASPiRwGFeyNCmjrN+ozGR4CtGF
         pqiaEsA6YTDXw2CfDB9dkpl1Q5+0gPZ9OqfvOuSJhQEUYWQtFcvYS4b7rjuY24b1/6bv
         /huYqDUMQE28q/fdo2BHBr0D+oGlQ93jgFv+BS5NM1hrVjYxR8pip8D4Yjwlj/8vXPM1
         YJIr1vHkVY1kgD4q8QNbBOCTDQvN30bgAr1clMxWoP2j0WlQOvszMH4cnXqhl9Z1QohN
         VWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Pjs6VzqQNMUZ72aHk2/E5DqfjycX6mBSIAqq4hTXs1U=;
        b=uVboU1N6h++Vs+JPF4bShv8Dmh6b/9i5mC1/J1CRMRs9t8wd4bhnhkpYyKFXa7y2tx
         8k8Mfqz/D9sAdBZoVWg3QVSq+rGtdcIWWlY1niBdsXU3X4RLc017Cs0dF14JbOoPjtGv
         zXAXzoanZRh/djNoyX0X5BJzNguRHro2LqWG6Bjh45vKTkzELQtkwJoUJHlrjT5lCKxp
         g/nOimDd5Cj1v5nz5tka5jqdsg109EL9lkmET9lIh0aHwckKtceUq+50b2oKcWy5CpMt
         j8M7/q7RVySrRTBAqH7VxNNxBM99X5Hprk5zVDhh37A8iq6FhqKsNxvowEPOZHSJyhf3
         82BQ==
X-Gm-Message-State: APjAAAXdkmMEEKotjRac6G5J/afcU8+ZW69hvDZwfMN8o1HKe9zaQl8u
        G55wViS7koG3+DcV+tgRkbw=
X-Google-Smtp-Source: APXvYqx39I3H+GpjnS2iByK5MXnGcCMKyqmA6n9KBE4wbDP/W7SgvGZD39CS4k2BnTjK+innsqHuAA==
X-Received: by 2002:a62:4697:: with SMTP id o23mr2281834pfi.224.1557377245101;
        Wed, 08 May 2019 21:47:25 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::ce1c])
        by smtp.gmail.com with ESMTPSA id h16sm1479783pfj.114.2019.05.08.21.47.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 21:47:24 -0700 (PDT)
Date:   Wed, 8 May 2019 21:47:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@google.com>, luto@amacapital.net,
        jannh@google.com
Subject: Re: Question about seccomp / bpf
Message-ID: <20190509044720.fxlcldi74atev5id@ast-mbp>
References: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
 <20190508230941.6rqccgijqzkxmz4t@ast-mbp>
 <CANn89iL_1n8Lb5yCEk3ZrBsUtPPWPZ=0BiELUo+jyBWfLfaAzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iL_1n8Lb5yCEk3ZrBsUtPPWPZ=0BiELUo+jyBWfLfaAzg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 04:17:29PM -0700, Eric Dumazet wrote:
> On Wed, May 8, 2019 at 4:09 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, May 08, 2019 at 02:21:52PM -0700, Eric Dumazet wrote:
> > > Hi Alexei and Daniel
> > >
> > > I have a question about seccomp.
> > >
> > > It seems that after this patch, seccomp no longer needs a helper
> > > (seccomp_bpf_load())
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd4cf0ed331a275e9bf5a49e6d0fd55dffc551b8
> > >
> > > Are we detecting that a particular JIT code needs to call at least one
> > > function from the kernel at all ?
> >
> > Currently we don't track such things and trying very hard to avoid
> > any special cases for classic vs extended.
> >
> > > If the filter contains self-contained code (no call, just inline
> > > code), then we could use any room in whole vmalloc space,
> > > not only from the modules (which is something like 2GB total on x86_64)
> >
> > I believe there was an effort to make bpf progs and other executable things
> > to be everywhere too, but I lost the track of it.
> > It's not that hard to tweak x64 jit to emit 64-bit calls to helpers
> > when delta between call insn and a helper is more than 32-bit that fits
> > into call insn. iirc there was even such patch floating around.
> >
> > but what motivated you question? do you see 2GB space being full?!
> 
> 
> A customer seems to hit the limit, with about 75,000 threads,
> each one having a seccomp filter with 6 pages (plus one guard page
> given by vmalloc)

Since cbpf doesn't have "fd as a program" concept I suspect
the same program was loaded 75k times. What a waste of kernel memory.
And, no, we're not going to extend or fix cbpf for this.
cbpf is frozen. seccomp needs to start using ebpf.
It can have one program to secure all threads.
If necessary single program can be customized via bpf maps
for each thread.

