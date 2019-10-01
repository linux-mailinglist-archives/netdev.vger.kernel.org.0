Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4FDC2B9D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 03:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729224AbfJABWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 21:22:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40925 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbfJABWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 21:22:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id d26so2981545pgl.7;
        Mon, 30 Sep 2019 18:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MXvCTFZX8iSPk2vvATyDXImBAz+PzNSrzftt/mv+u6c=;
        b=LJCmptb/PRN7KCppGIVot1/c6ujLs+Bv+s45nPpSBvLW8foWP3xkwRWkh7YIozy9xH
         4PAGfeJP5YfvOAT3Ryg1rhBCFlfw/a7731y+X+uV3JOOOaQ2yEjZTiW40govJEiAJCCq
         +qqqBOAqMw9PKfr3mmkIhkrD5WT8BYo75kVAACZmoNVhnoCiqoLUEf5RFQaKk17sMZ89
         N70xlrIAvMPM6AS5y1AyGkaLFTDJvnU19K5vMdeEtq7WEga2QR+7xzTUWkMmyPLe/X8a
         0xa1LP1ox3YwHtOj1331wj68oSyEcxymY0Z5xFPkqAhINkBKU8SHXt117lYpUsbxHiPH
         fjwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MXvCTFZX8iSPk2vvATyDXImBAz+PzNSrzftt/mv+u6c=;
        b=ko8cD6iyU0vhwIYmBb+yHdZCms9NnewrK831Q1WLPVpDLNeSJXUJcmg2Ll3IX6NO1Z
         xHfs7vB95OnPbZuWO60MIwCrPlkGZTzIOYmzGyjiZOIm8/t7WrLBV8448P185H4vGBtE
         M6hQHBShQckRxLa6OK9jm79Q/Fq4rrQPTlSg3mtlwAayXKPzWKhqD+ZeDb1FAYjkvJND
         a6vcXYFbqbHJrC+xEWQlJaIrLTDHEq8qS7o97cZStqAvWBp5Wvonm8nceXeIPkxk//xk
         A3WduOOKILjTXnIpPNx3S8eN3ftmIbon3bSIq/c7pqhqhTD2RJGQXSo+wj9GA1gi1vwi
         uD5w==
X-Gm-Message-State: APjAAAXGTTWKevDJTKyG1R1vjDvmMNWxd231+2PIYlMcwrcNf71vsKpQ
        7OL26bjnNHH/bj0iU2Zv7XY=
X-Google-Smtp-Source: APXvYqxngZaWfzy18fBCjfA06mYyRHg2DLXhmKrXXZ0DpoarRB5Vh1Kc1rcVHetbIvO3llzJ/cy9BA==
X-Received: by 2002:a63:d20f:: with SMTP id a15mr27254294pgg.130.1569892951294;
        Mon, 30 Sep 2019 18:22:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f760])
        by smtp.gmail.com with ESMTPSA id b11sm15330078pgr.20.2019.09.30.18.22.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 18:22:30 -0700 (PDT)
Date:   Mon, 30 Sep 2019 18:22:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
 <201909301129.5A1129C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201909301129.5A1129C@keescook>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 11:31:29AM -0700, Kees Cook wrote:
> On Sat, Sep 28, 2019 at 07:37:27PM -0400, Steven Rostedt wrote:
> > On Wed, 28 Aug 2019 21:07:24 -0700
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > 
> > > > This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> > > > 
> > > > 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> > > > 
> > > > 2. Improve it a bit do all the privileged ops are wrapped by capset().
> > > > 
> > > > Does this make sense?  I’m a security person on occasion. I find
> > > > vulnerabilities and exploit them deliberately and I break things by
> > > > accident on a regular basis. In my considered opinion, CAP_TRACING
> > > > alone, even extended to cover part of BPF as I’ve described, is
> > > > decently safe. Getting root with just CAP_TRACING will be decently
> > > > challenging, especially if I don’t get to read things like sshd’s
> > > > memory, and improvements to mitigate even that could be added.  I
> > > > am quite confident that attacks starting with CAP_TRACING will have
> > > > clear audit signatures if auditing is on.  I am also confident that
> > > > CAP_BPF *will* allow DoS and likely privilege escalation, and this
> > > > will only get more likely as BPF gets more widely used. And, if
> > > > BPF-based auditing ever becomes a thing, writing to the audit
> > > > daemon’s maps will be a great way to cover one’s tracks.  
> > > 
> > > CAP_TRACING, as I'm proposing it, will allow full tracefs access.
> > > I think Steven and Massami prefer that as well.
> > > That includes kprobe with probe_kernel_read.
> > > That also means mini-DoS by installing kprobes everywhere or running
> > > too much ftrace.
> > 
> > I was talking with Kees at Plumbers about this, and we were talking
> > about just using simple file permissions. I started playing with some
> > patches to allow the tracefs be visible but by default it would only be
> > visible by root.
> > 
> >  rwx------
> > 
> > Then a start up script (or perhaps mount options) could change the
> > group owner, and change this to:
> > 
> >  rwxrwx---
> > 
> > Where anyone in the group assigned (say "tracing") gets full access to
> > the file system.
> > 
> > The more I was playing with this, the less I see the need for
> > CAP_TRACING for ftrace and reading the format files.
> 
> Nice! Thanks for playing with this. I like it because it gives us a way
> to push policy into userspace (group membership, etc), and provides a
> clean way (hopefully) do separate "read" (kernel memory confidentiality)
> from "write" (kernel memory integrity), which wouldn't have been possible
> with a single new CAP_...

tracefs is a file system, so clearly file based acls are much better fit
for all tracefs operations.
But that is not the case for ftrace overall.
bpf_trace_printk() calls trace_printk() that dumps into trace pipe.
Technically it's ftrace operation, but it cannot be controlled by tracefs
and by file permissions. That's the motivation to guard bpf_trace_printk()
usage from bpf program with CAP_TRACING.

Both 'trace' and 'trace_pipe' have quirky side effects.
Like opening 'trace' file will make all parallel trace_printk() to be ignored.
While reading 'trace_pipe' file will clear it.
The point that traditional 'read' and 'write' ACLs don't map as-is
to tracefs, so I would be careful categorizing things into
confidentiality vs integrity only based on access type.

