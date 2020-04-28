Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA421BB4E6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgD1EEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgD1EEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:04:31 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD74C03C1A9;
        Mon, 27 Apr 2020 21:04:30 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f8so7835105plt.2;
        Mon, 27 Apr 2020 21:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xeZ6XRGhdVLJBf2MOUWLboAnGDFLTVXr9LuKT86MR08=;
        b=dF6j6HqUX6s0P1mzYxSLznzkVNNucQtjnGOPgQj/XMREs67TG8S+H0Dg+IZN7ivB0Z
         NVXFfm7mX30UU0rdWf+uZPfJk/4DOf82O7ASJLC5Xtt+CGYu64jfLn32FLMYdR1gnKIX
         h0aL1COrMySSK89LnDh3usoytdXv+8lOkr4fiwMtJH8mSAVXawsdcBD6UBktHYMSGgVq
         3WRkTa76yMtSNQDFBJWi36ozQ2J5OWcR8+CxeXF5PUpmez0mRUyLqLCFRZGLCaiu1MAB
         6M/26XMmNnywJhoFM74W5tQgp6MqrzL0JrCzPskNQ6rNnZ/jjsx1GDEVxD3yjnECYM30
         pRSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xeZ6XRGhdVLJBf2MOUWLboAnGDFLTVXr9LuKT86MR08=;
        b=rTReyWTBwMmJfQt+NeQ3a3Fu47z3BG9NlEAYTy8+WoDW8L7bf0mMUwgve7hR7tWFyb
         hk43kD2qonv+SMXFwFgyVDLvRGZ/9iorrQSkFjqVv5nlsQKoIm5Zcm/W31AnmJJx9/Oq
         wgSVS8YwQIecKjCao7BIdqSbZm0hxjewErrvJa5C61olP9OK3x7OU3CfSLmO4V7/cUD+
         AeYz/yzdmQuMfBHimLipjqHGT4HfXyuY9g71e99BzRG8Bs5+Ie1dUxIa8I6gPU4N48Ay
         M600RpDS77OYw9Pbrl3yv5Pxqipy/R4bQXhrTuMZZX3yX4V/xQ4QwII2fwou94foJuxl
         Nfzw==
X-Gm-Message-State: AGi0Pub6tq/4ZcG6Q1h0f2A8qSk9s28runVztW0No1si8ki2zBXy4bnF
        5+4Z5PZ10eaZMTBhAf4ldxw=
X-Google-Smtp-Source: APiQypJI5vdqtrd41a9SrSaLxYLYj5lmZ4EQGgG6AJ+pUhN82V4F8ssA3x4tSS7E3/Xe4cw7bfCr2A==
X-Received: by 2002:a17:90a:fb4e:: with SMTP id iq14mr2572901pjb.146.1588046668333;
        Mon, 27 Apr 2020 21:04:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9f56])
        by smtp.gmail.com with ESMTPSA id a200sm13497163pfa.201.2020.04.27.21.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 21:04:27 -0700 (PDT)
Date:   Mon, 27 Apr 2020 21:04:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
Message-ID: <20200428040424.wvozrsy6uviz33ha@ast-mbp.dhcp.thefacebook.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
 <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
 <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
 <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
 <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 02:29:56PM +0200, Eelco Chaudron wrote:
> 
> > Not working with JIT-ed code is imo red flag for the approach as well.
> 
> How would this be an issue, this is for the debug path only, and if the
> jitted code behaves differently than the interpreter there is a bigger
> issue.

They are different already. Like tail_calls cannot mix and match interpreter
and JITed. Similar with bpf2bpf calls.
And that difference will be growing further.
At that time of doing bpf trampoline I considering dropping support for
interpreter, but then figured out a relatively cheap way of keeping it alive.
I expect next feature to not support interpreter.

> > When every insn is spamming the logs the only use case I can see
> > is to feed the test program with one packet and read thousand lines
> > dump.
> > Even that is quite user unfriendly.
> 
> The log was for the POC only, the idea is to dump this in a user buffer, and
> with the right tooling (bpftool prog run ... {trace}?) it can be stored in
> an ELF file together with the program, and input/output. Then it would be
> easy to dump the C and eBPF program interleaved as bpftool does. If GDB
> would support eBPF, the format I envision would be good enough to support
> the GDB record/replay functionality.

For the case you have in mind no kernel changes are necessary.
Just run the interpreter in user space.
It can be embedded in gdb binary, for example.

Especially if you don't want to affect production server you definitely
don't want to run anything on that machine.
As support person just grab the prog, capture the traffic and debug
on their own server.

> 
> > How about enabling kprobe in JITed code instead?
> > Then if you really need to trap and print regs for every instruction you
> > can
> > still do so by placing kprobe on every JITed insn.
> 
> This would even be harder as you need to understand the ASM(PPC/ARM/x86) to
> eBPF mapping (registers/code), where all you are interested in is eBPF (to
> C).

Not really. gdb-like tool will hide all that from users.

> This kprobe would also affect all the instances of the program running in
> the system, i.e. for XDP, it could be assigned to all interfaces in the
> system.

There are plenty of ways to solve that.
Such kprobe in a prog can be gated by test_run cmd only.
Or the prog .text can be cloned into new one and kprobed there.

> And for this purpose, you are only interested in the results of a run for a
> specific packet (in the XDP use case) using the BPF_RUN_API so you are not
> affecting any live traffic.

The only way to not affect live traffic is to provide support on
a different machine.

> > But in reality I think few kprobes in the prog will be enough
> > to debug the program and XDP prog may still process millions of packets
> > because your kprobe could be in error path and the user may want to
> > capture only specific things when it triggers.
> > kprobe bpf prog will execute in such case and it can capture necessary
> > state from xdp prog, from packet or from maps that xdp prog is using.
> > Some sort of bpf-gdb would be needed in user space.
> > Obviously people shouldn't be writing such kprob-bpf progs that debug
> > other bpf progs by hand. bpf-gdb should be able to generate them
> > automatically.
> 
> See my opening comment. What you're describing here is more when the right
> developer has access to the specific system. But this might not even be
> possible in some environments.

All I'm saying that kprobe is a way to trace kernel.
The same facility should be used to trace bpf progs.

> 
> Let me know if your opinion on this idea changes after reading this, or what
> else is needed to convince you of the need ;)

I'm very much against hacking in-kernel interpreter into register
dumping facility.
Either use kprobe+bpf for programmatic tracing or intel's pt for pure
instruction trace.
