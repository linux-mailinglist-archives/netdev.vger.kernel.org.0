Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1D146B369
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 03:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbfGQBar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 21:30:47 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46958 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfGQBaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 21:30:46 -0400
Received: by mail-pf1-f193.google.com with SMTP id c73so9963638pfb.13;
        Tue, 16 Jul 2019 18:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=neITER+zvrYjuYhibRCAZ2mUIZDBc7bmWlN6HB6gcKI=;
        b=TyR3sxcqDcPBUFP6dAEFu9mdfp2q7bo/1ysGD6URAEn7Ok+LEneWbbq2jIFJ7jO6xr
         E80POzx+7wBoYrK+X/onpGbJxavYHEluy/+nuA6UekMJncvOnLcGGk7xJXM85z3VdET/
         M1l/sNuRZeipKzRNofXoiBhKLviWcFlNhyxXyXm2JrIMNmyYT++TDaBqft9CQBEOcLe1
         7bbMoqeJ1uxJ9X6yyW4NmhpoAC9pMBfqCM2wRUK+3Dr2l6sLk9CzFJQIAddJuZ7Dz017
         EGcQf3BHBW6sy/c6ubaAvYZMmP2mYdmmRdQ0Ux5XUF0wSQ0mhDAVP2EKJqnvZMFzOe9z
         K+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=neITER+zvrYjuYhibRCAZ2mUIZDBc7bmWlN6HB6gcKI=;
        b=DxqM7HdcrHTf7+UlvfXs4oMwYg/8H6gFD7b8ecCDG5A6d7Fi7PWKECF6mCCj1KSUGU
         idi0tLV3ssgHSANClX2ccy2VTiii3jtTkcICaTVf4ydFD2N11UL5MNWJILXWuEnreutZ
         qjvAXxQuJGLhbVSdSt0WHyTVZzlMbgyaVJpVjS94/Tc4pMEXChxfjT6wVADblZiZ//HI
         BUhETGvzD9j9IoL/w+rNx5UJ4yLZD+OyJhlrp5Ag2mIO573d8isWNSA4s97lpg2eq81/
         xszX4ZkwP969UeMA/pSb7z7iBiOjCuUeRrO1H/H2NsHF1M57VnG6Oh9gsh+1EPsG1z4O
         NMuw==
X-Gm-Message-State: APjAAAVMcS3ztg9/3VqV3Pk53Gej1vMw0z2B1eKmdLcVTPvqxd/4z+qg
        9AuYzaCXRY078XjLufYs+f4=
X-Google-Smtp-Source: APXvYqxteJxMDlwlCNvvq4SuGqWoZbP7NjOqGn0uk70RZ1WP54WvJSTMSu99Enj+T2+HriAe3TQQ9Q==
X-Received: by 2002:a63:5964:: with SMTP id j36mr37012010pgm.428.1563327046011;
        Tue, 16 Jul 2019 18:30:46 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::b82a])
        by smtp.gmail.com with ESMTPSA id a3sm23436067pfi.63.2019.07.16.18.30.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 18:30:44 -0700 (PDT)
Date:   Tue, 16 Jul 2019 18:30:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        linux-kernel@vger.kernel.org,
        Adrian Ratiu <adrian.ratiu@collabora.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, connoro@google.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        duyuchao <yuchao.du@unisoc.com>, Ingo Molnar <mingo@redhat.com>,
        jeffv@google.com, Karim Yaghmour <karim.yaghmour@opersys.com>,
        kernel-team@android.com, linux-kselftest@vger.kernel.org,
        Manali Shukla <manalishukla14@gmail.com>,
        Manjo Raja Rao <linux@manojrajarao.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Matt Mullins <mmullins@fb.com>,
        Michal Gregorczyk <michalgr@fb.com>,
        Michal Gregorczyk <michalgr@live.com>,
        Mohammad Husain <russoue@gmail.com>, namhyung@google.com,
        namhyung@kernel.org, netdev@vger.kernel.org,
        paul.chaignon@gmail.com, primiano@google.com,
        Qais Yousef <qais.yousef@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Srinivas Ramana <sramana@codeaurora.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190717013041.53sbn3tgfhtxgyb3@ast-mbp.dhcp.thefacebook.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
 <20190716183117.77b3ed49@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716183117.77b3ed49@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 06:31:17PM -0400, Steven Rostedt wrote:
> On Tue, 16 Jul 2019 17:30:50 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > I don't see why a new bpf node for a trace event is a bad idea, really.
> > tracefs is how we deal with trace events on Android. We do it in production
> > systems. This is a natural extension to that and fits with the security model
> > well.
> 
> What I would like to see is a way to have BPF inject data into the
> ftrace ring buffer directly. There's a bpf_trace_printk() that I find a
> bit of a hack (especially since it hooks into trace_printk() which is
> only for debugging purposes). Have a dedicated bpf ftrace ring
> buffer event that can be triggered is what I am looking for. Then comes
> the issue of what ring buffer to place it in, as ftrace can have
> multiple ring buffer instances. But these instances are defined by the
> tracefs instances directory. Having a way to associate a bpf program to
> a specific event in a specific tracefs directory could allow for ways to
> trigger writing into the correct ftrace buffer.

bpf can write anything (including full skb) into perf ring buffer.
I don't think there is a use case yet to write into ftrace ring buffer.
But I can be convinced otherwise :)

> But looking over the patches, I see what Alexei means that there's no
> overlap with ftrace and these patches except for the tracefs directory
> itself (which is part of the ftrace infrastructure). And the trace
> events are technically part of the ftrace infrastructure too. I see the
> tracefs interface being used, but I don't see how the bpf programs
> being added affect the ftrace ring buffer or other parts of ftrace. And
> I'm guessing that's what is confusing Alexei.

yep.
What I really like to see some day is proper integration of real ftrace
and bpf. So that bpf progs can be invoked from some of the ftrace machinery.
And the other way around.
Like I'd love to be able to start ftracing all functions from bpf
and stop it from bpf.
The use case is kernel debugging. I'd like to examine a bunch of condition
and start ftracing the execution. Then later decide wether this collection
of ip addresses is interesting to analyze and post process it quickly
while still inside bpf program.
