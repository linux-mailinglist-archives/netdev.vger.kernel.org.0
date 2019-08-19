Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC1994BAC
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfHSR1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:27:25 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43689 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727459AbfHSR1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 13:27:25 -0400
Received: by mail-pf1-f194.google.com with SMTP id v12so1543649pfn.10;
        Mon, 19 Aug 2019 10:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pHtKRE/j0R9EYexP4Ct260+ZlqktQWeWlzyIShlpY20=;
        b=n1xRQ15KKa4d64xjiDmaHUJCQEdA9TcQb3+CwxFsTQ8tUzI0VcAZUwRzet8Lm9hzIx
         nXdy2+i2Y3jigmcmliIVnRvakBTk2TJXhY2t1ZXbGEjuHpr+NDPyM7tnCsmpLFikHeM4
         CZS/ZtNAUxc1SxdIxzu7uvdrMqeEicfk06psNfKGXzCdF7FXG8kOh+NyZNZ/Mg1bfMve
         XcqTmJqMI0m3p8T0Aw4Pxp+jdQdVngfmcwmkADV0GB4NR+QVK0vCvqDpKuffOqiF7mER
         FvgAnLbnrh9BnZL9zBtZdLiEXTIBb4oDVWM5ecyXUV9me9cwgb/0IkhUGspJ+OifOYqK
         MI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pHtKRE/j0R9EYexP4Ct260+ZlqktQWeWlzyIShlpY20=;
        b=IHcY7o18EI/idoIOwMtSs8LUs8yJZ1ai9L8o9Yr4axtEW6S/wLZWSkTcuQmV581C8F
         I9V+GzQy0iKNKSmHyu0FrkYkwifZ8OMfG21m3XdOsUlgyN3VVSjFIhl3CELmaj8G192g
         w5DvMRpMm6RJOUaZ6uQIp7eHYXB5m7quUcjbcRsAlowxnIweRt8Rk/IFliCQsLPWwr86
         px6HqiYW3DSouLWU4UwW2HnQClDEOjWMTz53opg+4RMMEyAAF8BlJGrjH5Vhv1+WeJyq
         9jembjPSgLCuzQ6SMBmOT/tKzjHsTCpffDSb9Hi4KGxTSU3FSpVL1nfM9J5akmZDrpZz
         91qQ==
X-Gm-Message-State: APjAAAV3A6stGY6zJPqRdtNoODhI46t3uWlB908DsP4g+MvcpqKQizV+
        4nuusxl1GbRCEgockA81K58=
X-Google-Smtp-Source: APXvYqwDd/WmJR1G4wWzYzG/o6pc9FR9zZxEBe5GBqLktaP+H320JEEpvfBSP2RiRv8sIvUBsR8dUw==
X-Received: by 2002:a63:4562:: with SMTP id u34mr20675357pgk.288.1566235644201;
        Mon, 19 Aug 2019 10:27:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::e55e])
        by smtp.gmail.com with ESMTPSA id k6sm16233157pfi.12.2019.08.19.10.27.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 10:27:23 -0700 (PDT)
Date:   Mon, 19 Aug 2019 10:27:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jordan Glover <Golden_Miller83@protonmail.ch>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <20190819172718.jwnvvotssxwhc7m6@ast-mbp.dhcp.thefacebook.com>
References: <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
 <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
 <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
 <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com>
 <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de>
 <20190817150245.xxzxqjpvgqsxmloe@ast-mbp>
 <alpine.DEB.2.21.1908191103130.1923@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908191103130.1923@nanos.tec.linutronix.de>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 19, 2019 at 11:15:11AM +0200, Thomas Gleixner wrote:
> Alexei,
> 
> On Sat, 17 Aug 2019, Alexei Starovoitov wrote:
> > On Fri, Aug 16, 2019 at 10:28:29PM +0200, Thomas Gleixner wrote:
> > > On Fri, 16 Aug 2019, Alexei Starovoitov wrote:
> > > While real usecases are helpful to understand a design decision, the design
> > > needs to be usecase independent.
> > > 
> > > The kernel provides mechanisms, not policies. My impression of this whole
> > > discussion is that it is policy driven. That's the wrong approach.
> > 
> > not sure what you mean by 'policy driven'.
> > Proposed CAP_BPF is a policy?
> 
> I was referring to the discussion as a whole.
>  
> > Can kernel.unprivileged_bpf_disabled=1 be used now?
> > Yes, but it will weaken overall system security because things that
> > use unpriv to load bpf and CAP_NET_ADMIN to attach bpf would need
> > to move to stronger CAP_SYS_ADMIN.
> > 
> > With CAP_BPF both load and attach would happen under CAP_BPF
> > instead of CAP_SYS_ADMIN.
> 
> I'm not arguing against that.
> 
> > > So let's look at the mechanisms which we have at hand:
> > > 
> > >  1) Capabilities
> > >  
> > >  2) SUID and dropping priviledges
> > > 
> > >  3) Seccomp and LSM
> > > 
> > > Now the real interesting questions are:
> > > 
> > >  A) What kind of restrictions does BPF allow? Is it a binary on/off or is
> > >     there a more finegrained control of BPF functionality?
> > > 
> > >     TBH, I can't tell.
> > > 
> > >  B) Depending on the answer to #A what is the control possibility for
> > >     #1/#2/#3 ?
> > 
> > Can any of the mechanisms 1/2/3 address the concern in mds.rst?
> 
> Well, that depends. As with any other security policy which is implemented
> via these mechanisms, the policy can be strict enough to prevent it by not
> allowing certain operations. The more fine-grained the control is, it
> allows the administrator who implements the policy to remove the
> 'dangerous' parts from an untrusted user.
> 
> So really question #A is important for this. Is BPF just providing a binary
> ON/OFF knob or does it allow to disable/enable certain aspects of BPF
> functionality in a more fine grained way? If the latter, then it might be
> possible to control functionality which might be abused for exploits of
> some sorts (including MDS) in a way which allows other parts of BBF to be
> exposed to less priviledged contexts.

I see. So the kernel.unprivileged_bpf_disabled knob is binary and I think it's
the right mechanism to expose to users.
Having N knobs for every map/prog type won't decrease attack surface.
In the other email Andy's quoting seccomp man page...
Today seccomp cannot really look into bpf_attr syscall args, but even
if it could it won't secure the system.
Examples:
1.
spectre v2 is using bpf in-kernel interpreter in speculative way.
The mere presence of interpreter as part of kernel .text makes the exploit
easier to do. That was the reason to do CONFIG_BPF_JIT_ALWAYS_ON.
For this case even kernel.unprivileged_bpf_disabled=1 was hopeless.

2.
var4 doing store hazard. It doesn't matter which program type is used.
load/store instructions are the same across program types.

3.
prog_array was used as part of var1. I guess it was simply more
convenient for Jann to do it this way :) All other map types
have the same out-of-bounds speculation issue.

In general side channels are cpu bugs that are exploited via sequences
of cpu instructions. In that sense bpf infra provides these instructions.
So all program types and all maps have the same level of 'side channel risk'.

> > I believe Andy wants to expand the attack surface when
> > kernel.unprivileged_bpf_disabled=0
> > Before that happens I'd like the community to work on addressing the text above.
> 
> Well, that text above can be removed when the BPF wizards are entirely sure
> that BPF cannot be abused to exploit stuff. 

Myself and Daniel looked at it in detail. I think we understood
MDS mechanism well enough. Right now we're fairly confident that
combination of existing mechanisms we did for var4 and
verifier speculative analysis protect us from MDS.
The thing is that every new cpu bug is looked at through the bpf lenses.
Can it be exploited through bpf? Complexity of side channels
is growing. Can the most recent swapgs be exploited ?
What if we kprobe+bpf somewhere ?
I don't think there is an issue, but we will never be 'entirely sure'.
Even if myself and Daniel are sure the concern will stay.
Unprivileged bpf as a whole is the concern due to side channels.
The number of them are not yet disclosed. Who is going to analyze them?
imo the only answer to that is kernel.unprivileged_bpf_disabled=1
which together with CONFIG_BPF_JIT_ALWAYS_ON is secure enough.
The other option is to sprinkle every bpf load/store with lfence
which will make execution so slow that it will be unusable.
Which is effectively the same as unprivileged_bpf_disabled=1.

There are other things we can do. Like kasan-style shadow memory
for bpf execution. Auto re-JITing the code after it's running.
We can do lfences everywhere for some time then re-JIT
when kasan-ed shadow memory shows only clean memory accesses.
The beauty of BPF that it is analyze-able and JIT-able instruction set.
The verifier speculative analysis is an example that the kernel
can analyze the speculative execution path that cpu will
take before the code starts executing.
Unprivileged bpf can made absolutely secure. It can be
made more secure than the rest of the kernel.
But today we should just go with unprivileged_bpf_disabled=1
and CAP_BPF.

