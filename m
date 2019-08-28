Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214F3A0D4B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfH1WIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:08:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43365 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfH1WIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:08:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id k3so425044pgb.10;
        Wed, 28 Aug 2019 15:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6X3gVkrOkSh07fF2QBrnXgjAV6GqAqVzRBOyJnnlCsc=;
        b=XMEMXzpjRbv78M/7RIbt6Ker6NLG81lMeXuGSIW2C+kCV2pu6xIUSbsKTuy2XYhfMo
         jyerJBU7KRDahKo2CfaMQI147LOJ+gpSI8SFVxX09nnjsG5amGN0mcZXSWIRiZU04p6r
         nsfyRyNq5lFdcrVRIMGUN30Usrkjl6NCJhK3kMq7knk9zcgFC4Mw8MXTxPhXMIlvaie6
         dyp3Irr6DQWobNpeUp1kuPdEwTP0uB71Ct1XrJ8royu+XKP1Mwy7uqrmJzflSwdy2gs6
         NljsT9HrVxlObxvIHAjpqsDGk3Zhh1LZpxCPXPs8GGp+Uxowd0p0TDZzqym/4n2IZ2Xw
         z+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6X3gVkrOkSh07fF2QBrnXgjAV6GqAqVzRBOyJnnlCsc=;
        b=gM0clnH3Yi8dmp9Ak/cAOJ3Pqd0vjaeATPqFd27hgZHzVk+ldyQ3nEeEV3xvm2kmPZ
         A5zBY8tsn7gfPoXJ9Q0NOF2mvQOAj2vnSQsG5osGI0Z2AkgG5pHG/l9et1FdDopOaU3K
         gp1di4V40q+2x2mKREIPIgoJ68hO40QUfK9UhoRVq+KQspJhOvE/5zeQI0RYNq7sqOWZ
         7h+8wqA9570k4MvUO9ydxAM4pkV+e9nwySTE8ZBZeBdxITnWbt2IlXI08lbxRQ4ozhD1
         wFRpn8dNt7ZTD+EH4/N0YtS5s57MDYuH9mAeiV2qUgUI6JCecv5FGooU835fgJOzN9qB
         NxvA==
X-Gm-Message-State: APjAAAWkV/KJJXC89I2cP8BeLU4oQ4pxA8LclTDqZMVkF+PGqjsoFUt0
        012RxZ3tj2wiwIK8jGBgfto=
X-Google-Smtp-Source: APXvYqy3gGKj8gWziVg4E09JVnbLn6ZOFG4q2CDDKrl/vre359CP3azlfThIpQhzhpykvvKhEdP67g==
X-Received: by 2002:a63:6686:: with SMTP id a128mr5276547pgc.361.1567030111078;
        Wed, 28 Aug 2019 15:08:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::5983])
        by smtp.gmail.com with ESMTPSA id h197sm400102pfe.67.2019.08.28.15.08.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 15:08:30 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:08:28 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828071421.GK2332@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 09:14:21AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 27, 2019 at 04:01:08PM -0700, Andy Lutomirski wrote:
> 
> > > Tracing:
> > >
> > > CAP_BPF and perf_paranoid_tracepoint_raw() (which is kernel.perf_event_paranoid == -1)
> > > are necessary to:
> 
> That's not tracing, that's perf.
> 
> > > +bool cap_bpf_tracing(void)
> > > +{
> > > +       return capable(CAP_SYS_ADMIN) ||
> > > +              (capable(CAP_BPF) && !perf_paranoid_tracepoint_raw());
> > > +}
> 
> A whole long time ago, I proposed we introduce CAP_PERF or something
> along those lines; as a replacement for that horrible crap Android and
> Debian ship. But nobody was ever interested enough.
> 
> The nice thing about that is that you can then disallow perf/tracing in
> general, but tag the perf executable (and similar tools) with the
> capability so that unpriv users can still use it, but only limited
> through the tool, not the syscalls directly.

Exactly.
Similar motivation for CAP_BPF as well.

re: your first comment above.
I'm not sure what difference you see in words 'tracing' and 'perf'.
I really hope we don't partition the overall tracing category
into CAP_PERF and CAP_FTRACE only because these pieces are maintained
by different people.
On one side perf_event_open() isn't really doing tracing (as step by
step ftracing of function sequences), but perf_event_open() opens
an event and the sequence of events (may include IP) becomes a trace.
imo CAP_TRACING is the best name to descibe the privileged space
of operations possible via perf_event_open, ftrace, kprobe, stack traces, etc.

Another reason are kuprobes. They can be crated via perf_event_open
and via tracefs. Are they in CAP_PERF or in CAP_FTRACE ? In both, right?
Should then CAP_KPROBE be used ? that would be an overkill.
It would partition the space even further without obvious need.

Looking from BPF angle... BPF doesn't have integration with ftrace yet.
bpf_trace_printk is using ftrace mechanism, but that's 1% of ftrace.
In the long run I really like to see bpf using all of ftrace.
Whereas bpf is using a lot of 'perf'.
And extending some perf things in bpf specific way.
Take a look at how BPF_F_STACK_BUILD_ID. It's clearly perf/stack_tracing
feature that generic perf can use one day.
Currently it sits in bpf land and accessible via bpf only.
Though its bpf only today I categorize it under CAP_TRACING.

I think CAP_TRACING privilege should allow task to do all of perf_event_open,
kuprobe, stack trace, ftrace, and kallsyms.
We can think of some exceptions that should stay under CAP_SYS_ADMIN,
but most of the functionality available by 'perf' binary should be
usable with CAP_TRACING. 'perf' can do bpf too.
With CAP_BPF it would be all set.

