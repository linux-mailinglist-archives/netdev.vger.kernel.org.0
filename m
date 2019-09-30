Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77062C28CF
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfI3VaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:30:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33284 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfI3VaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 17:30:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so6338823pfl.0
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 14:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=T2TY6NGUwIvtdhDebNN+p+NWVfl2R9w7WL/YAsVOyZk=;
        b=i5xaSt1y22h381i+VEX8rdtcahF4pzXousOyH7UTBOqSlWxJsNRx3U1w+jky6T7wpJ
         JSJ6TFnZUA+axWRpru7iWLaLNNNkszVK8pLgceyVlm4v3jnDQHKIKagXDKC+wY3J2x9c
         Cw953v3oTPadf0FQSP0LrhvtDBiUZVmGP+u4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=T2TY6NGUwIvtdhDebNN+p+NWVfl2R9w7WL/YAsVOyZk=;
        b=TRFZhqE0+hfKWzEkZhMEhWH5MlzW/IWmhvXRwo+KgxhajGJdYsPyaROO1hmb+6OR0Y
         JlmLSc8NFAA3IZpLDp1EdVMwQZK0pwCfyjtxUEvQmakeipgKWHsC61sQwCNqWOiR1cjG
         MzIEek5gmavO8kk8GyBFweVfaHjdT/5M73zv+ITntoMMy5sXTPL1lveqMspkjyCVE9jx
         r3x73d5reO2M4N4oReEz6yNlxC5/2/UJP71xvIWmpSurgY40bSmLeSe6x79+MZ6TbhLc
         0P0URTQ59lAm7U/+ecDfxQaabBUNXM6sgRZf2CQqRfyxD1V0O3k1ySn8S0lqmwFGnNct
         wARA==
X-Gm-Message-State: APjAAAXytnjTr0GxSrLJ7+6tXJvu6BotRt+D0dqrq6UJ5LbIAKdY6RMD
        qMGONwMSzTDigRL7ic6n0fx6/dZbP5M=
X-Google-Smtp-Source: APXvYqzUWfgikZuehcyb1ebNrGpxs7GPx/fz1aqBg6pNhhtsuL3oDtjyS/9y2h54yyg97lG3WBg15w==
X-Received: by 2002:a17:90a:6509:: with SMTP id i9mr665793pjj.82.1569868291886;
        Mon, 30 Sep 2019 11:31:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b5sm14866917pfp.38.2019.09.30.11.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 11:31:30 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:31:29 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <201909301129.5A1129C@keescook>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190928193727.1769e90c@oasis.local.home>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 28, 2019 at 07:37:27PM -0400, Steven Rostedt wrote:
> On Wed, 28 Aug 2019 21:07:24 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > 
> > > This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> > > 
> > > 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> > > 
> > > 2. Improve it a bit do all the privileged ops are wrapped by capset().
> > > 
> > > Does this make sense?  I’m a security person on occasion. I find
> > > vulnerabilities and exploit them deliberately and I break things by
> > > accident on a regular basis. In my considered opinion, CAP_TRACING
> > > alone, even extended to cover part of BPF as I’ve described, is
> > > decently safe. Getting root with just CAP_TRACING will be decently
> > > challenging, especially if I don’t get to read things like sshd’s
> > > memory, and improvements to mitigate even that could be added.  I
> > > am quite confident that attacks starting with CAP_TRACING will have
> > > clear audit signatures if auditing is on.  I am also confident that
> > > CAP_BPF *will* allow DoS and likely privilege escalation, and this
> > > will only get more likely as BPF gets more widely used. And, if
> > > BPF-based auditing ever becomes a thing, writing to the audit
> > > daemon’s maps will be a great way to cover one’s tracks.  
> > 
> > CAP_TRACING, as I'm proposing it, will allow full tracefs access.
> > I think Steven and Massami prefer that as well.
> > That includes kprobe with probe_kernel_read.
> > That also means mini-DoS by installing kprobes everywhere or running
> > too much ftrace.
> 
> I was talking with Kees at Plumbers about this, and we were talking
> about just using simple file permissions. I started playing with some
> patches to allow the tracefs be visible but by default it would only be
> visible by root.
> 
>  rwx------
> 
> Then a start up script (or perhaps mount options) could change the
> group owner, and change this to:
> 
>  rwxrwx---
> 
> Where anyone in the group assigned (say "tracing") gets full access to
> the file system.
> 
> The more I was playing with this, the less I see the need for
> CAP_TRACING for ftrace and reading the format files.

Nice! Thanks for playing with this. I like it because it gives us a way
to push policy into userspace (group membership, etc), and provides a
clean way (hopefully) do separate "read" (kernel memory confidentiality)
from "write" (kernel memory integrity), which wouldn't have been possible
with a single new CAP_...

-Kees

-- 
Kees Cook
