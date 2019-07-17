Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3CB26B325
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 03:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfGQBYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 21:24:12 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44913 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfGQBYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 21:24:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so11010911plr.11;
        Tue, 16 Jul 2019 18:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6M9uF5bstPPN0pYSwASOOs//F+sr/bjg9ukHy0L2y4g=;
        b=sGHO2hRx3t2OIYOt5aLQicz0Q57voCcLIYaRKX6aoUVl/8NBDi3LCYeMIBWnf3ThDm
         oT+ABzqYVQRq12jHvsh6nbNk/PfZEWqVVkurYXVJgkFChccWT573+BBkzm+CE5OwLOIX
         MJgqoIJ8j8W8enXLLE9MNUIN7UF3J6It1n6A/RPOlwVknVBX3beF+DYTgtSzE5bo9dt7
         tcUEdpdMzjno1vY0+zvssEONN2lES/32gBdjV3YSS8pLnZY+DMXGNcR1141YOV+f/ART
         r2UxG960fHxVifgbuA0RA/KLHMTKNMswRS5eRDSHt3d4y55qrcLNqvL+ZZgVY1dGZOoh
         t94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6M9uF5bstPPN0pYSwASOOs//F+sr/bjg9ukHy0L2y4g=;
        b=RGmTYNYBl0cJyvnUB5nqz2sRIgaobD2YxmuwTuznTh4E9HwVlEsFnczNnC96defVZr
         0AKJbPyBkLk+1rcfwK1WnEejfmbB2mXgOoqkFRrG8cER8sUIVEhKkBh3SaBrp6s9m4W9
         fh8J8vYfBtNmrvklVr/lzBW4xHB7k+n8mQfkVXlqtOGiUBA5BC3Ym9gQHx7kfMDna86U
         GmyBG8xXMc1LPUP4tDORWfL5HwvFGR6dvGCntKON1xrWbcXtx0ztw0T9Da/dwLTBIFlq
         T+tSwfjmMmTUZ4GlUK0LingvdUwxyn4smfXlRNpqvgrSHUQcGrMBTZl9vwVnYbM8SnRF
         C+UA==
X-Gm-Message-State: APjAAAVEGfF4Pt+W6Knc4qCW0+2556oUn9llmjXQYrb6fgGbwVi9dP6h
        G9lMuxzm5am/m10BK3rrTfyR0a8Qpuo=
X-Google-Smtp-Source: APXvYqxZAeP0010wWGd4gGZMai5AEonP7WPfRkoTP5x6U+IRFYKYd4rrMPkVjcong96gN6ITvRUnfQ==
X-Received: by 2002:a17:902:9f8e:: with SMTP id g14mr39388892plq.67.1563326650873;
        Tue, 16 Jul 2019 18:24:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::b82a])
        by smtp.gmail.com with ESMTPSA id v138sm23218547pfc.15.2019.07.16.18.24.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 18:24:10 -0700 (PDT)
Date:   Tue, 16 Jul 2019 18:24:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org,
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
        Steven Rostedt <rostedt@goodmis.org>,
        Tamir Carmeli <carmeli.tamir@gmail.com>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH RFC 0/4] Add support to directly attach BPF program to
 ftrace
Message-ID: <20190717012406.lugqemvubixfdd6v@ast-mbp.dhcp.thefacebook.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
 <20190716213050.GA161922@google.com>
 <20190716222650.tk2coihjtsxszarf@ast-mbp.dhcp.thefacebook.com>
 <20190716224150.GC172157@google.com>
 <20190716235500.GA199237@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716235500.GA199237@google.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 07:55:00PM -0400, Joel Fernandes wrote:
> On Tue, Jul 16, 2019 at 06:41:50PM -0400, Joel Fernandes wrote:
> > On Tue, Jul 16, 2019 at 03:26:52PM -0700, Alexei Starovoitov wrote:
> > > On Tue, Jul 16, 2019 at 05:30:50PM -0400, Joel Fernandes wrote:
> > > > 
> > > > I also thought about the pinning idea before, but we also want to add support
> > > > for not just raw tracepoints, but also regular tracepoints (events if you
> > > > will). I am hesitant to add a new BPF API just for creating regular
> > > > tracepoints and then pinning those as well.
> > > 
> > > and they should be done through the pinning as well.
> > 
> > Hmm ok, I will give it some more thought.
> 
> I think I can make the new BPF API + pinning approach work, I will try to
> work on something like this and post it soon.
> 
> Also, I had a question below if you don't mind taking a look:
> 
> thanks Alexei!
> 
> > > > I don't see why a new bpf node for a trace event is a bad idea, really.
> > > 
> > > See the patches for kprobe/uprobe FD-based api and the reasons behind it.
> > > tldr: text is racy, doesn't scale, poor security, etc.
> > 
> > Is it possible to use perf without CAP_SYS_ADMIN and control security at the
> > per-event level? We are selective about who can access which event, using
> > selinux. That's how our ftrace-based tracers work. Its fine grained per-event
> > control. That's where I was going with the tracefs approach since we get that
> > granularity using the file system.

android's choice of selinux is not a factor in deciding kernel apis.
It's completely separate discusion wether disallowing particular tracepoints
for given user make sense at all.
Just because you can hack it in via selinux blocking particular
/sys/debug/tracing/ directory and convince yourself that it's somehow
makes android more secure. It doesn't mean that all new api should fit
into this model.
I think allowing one tracepoint and disallowing another is pointless
from security point of view. Tracing bpf program can do bpf_probe_read
of anything.

