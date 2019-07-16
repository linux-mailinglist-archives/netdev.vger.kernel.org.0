Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7696B11B
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbfGPVaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:30:55 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44679 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfGPVaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:30:55 -0400
Received: by mail-pf1-f195.google.com with SMTP id t16so9712399pfe.11
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6kokd9urqLvw9xwd+5O0M4O8FIkMVqne6oLchOnowAo=;
        b=ibh8wssZe0klgvCEqtGL5SQYOhiDO0uXhSwtj8BIDydBS/3FWbCP2DMLOIemRLeltT
         6QDu7NnPUf1dtPT4XHSPqhDA6hcF4aXFo11wvy1b8U6H/wvgF+hSctwPbOQhSv0jpsbp
         fhcGESGlAlBkev0SBC+CEsGGSRfNnL1GJ8ZlQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6kokd9urqLvw9xwd+5O0M4O8FIkMVqne6oLchOnowAo=;
        b=ULhZ881nSWxo3OxxgKq1um6r7liNtGlD6Uiho/9PLOA9LaryUngKOoHQFZbKaGkjcD
         z1uPjb6wXqDz7cTor2TSHAv4+F7r/14bw6SaA3oKGfOsKAS9321uDp0nug304l7JUBXi
         MIAhS2dxxEH93FkMa9sN1Wm9bGAt1YPuJ+xqv6Dl+ykBi447Wg6CoGlMWpzznNIiu4Mr
         WcqGRdQdt0H0CDyL+PeX19shEIFyG8JF0nxiKVlHdB2Y5pnVBYlhoUcrhxAiyhmOLwEh
         qikGTBg7IgTJkpFXV1sClzeSxnnzSEsP2vxYDo4mvC0v/BP5MHLtRbVSksMcz0ueIxtJ
         8qWg==
X-Gm-Message-State: APjAAAUuWs828gekoKbCwH5MZYn2HkGn9s3bLQP9R34DLJ72BcopZy2Q
        Cb7A7qm3qoZi3U/6z2jd3Ig=
X-Google-Smtp-Source: APXvYqzP8aGlzyfvDVIxVivD9Z3lMgtTzbpkjETtCBTYCZiV8fxcj98GUhamPPzgUeCiezYOCwcypg==
X-Received: by 2002:a63:4612:: with SMTP id t18mr27566053pga.85.1563312653706;
        Tue, 16 Jul 2019 14:30:53 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id 21sm10450343pfj.76.2019.07.16.14.30.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 14:30:52 -0700 (PDT)
Date:   Tue, 16 Jul 2019 17:30:50 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Message-ID: <20190716213050.GA161922@google.com>
References: <20190710141548.132193-1-joel@joelfernandes.org>
 <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 01:54:57PM -0700, Alexei Starovoitov wrote:
> On Wed, Jul 10, 2019 at 10:15:44AM -0400, Joel Fernandes (Google) wrote:
> > Hi,
> 
> why are you cc-ing the whole world for this patch set?

Well, the whole world happens to be interested in BPF on Android.

> I'll reply to all as well, but I suspect a bunch of folks consider it spam.
> Please read Documentation/bpf/bpf_devel_QA.rst

Ok, I'll read it.

> Also, I think, netdev@vger rejects emails with 80+ characters in cc as spam,
> so I'm not sure this set reached public mailing lists.

Certainly the CC list here is not added to folks who consider it spam. All
the folks added have been interested in BPF on Android at various points of
time. Is this CC list really that large? It has around 24 email addresses or
so. I can trim it a bit if needed. Also, you sound like as if people are
screaming at me to stop emailing them, certainly that's not the case and no
one has told me it is spam.

And, it did reach the public archive btw:
https://lore.kernel.org/netdev/20190716205455.iimn3pqpvsc3k4ry@ast-mbp.dhcp.thefacebook.com/T/#m1460ba463b78312e38b68b8c118f673d2ead9446

> > These patches make it possible to attach BPF programs directly to tracepoints
> > using ftrace (/sys/kernel/debug/tracing) without needing the process doing the
> > attach to be alive. This has the following benefits:
> > 
> > 1. Simplified Security: In Android, we have finer-grained security controls to
> > specific ftrace trace events using SELinux labels. We control precisely who is
> > allowed to enable an ftrace event already. By adding a node to ftrace for
> > attaching BPF programs, we can use the same mechanism to further control who is
> > allowed to attach to a trace event.
> > 
> > 2. Process lifetime: In Android we are adding usecases where a tracing program
> > needs to be attached all the time to a tracepoint, for the full life time of
> > the system. Such as to gather statistics where there no need for a detach for
> > the full system lifetime. With perf or bpf(2)'s BPF_RAW_TRACEPOINT_OPEN, this
> > means keeping a process alive all the time.  However, in Android our BPF loader
> > currently (for hardeneded security) involves just starting a process at boot
> > time, doing the BPF program loading, and then pinning them to /sys/fs/bpf.  We
> > don't keep this process alive all the time. It is more suitable to do a
> > one-shot attach of the program using ftrace and not need to have a process
> > alive all the time anymore for this. Such process also needs elevated
> > privileges since tracepoint program loading currently requires CAP_SYS_ADMIN
> > anyway so by design Android's bpfloader runs once at init and exits.
> > 
> > This series add a new bpf file to /sys/kernel/debug/tracing/events/X/Y/bpf
> > The following commands can be written into it:
> > attach:<fd>     Attaches BPF prog fd to tracepoint
> > detach:<fd>     Detaches BPF prog fd to tracepoint
> 
> Looks like, to detach a program the user needs to read a text file,
> parse bpf prog id from text into binary. Then call fd_from_id bpf syscall,
> get a binary FD, convert it back to text and write as a text back into this file.
> I think this is just a single example why text based apis are not accepted
> in bpf anymore.

This can also be considered a tracefs API.

And we can certainly change the detach to accept program ids as well if
that's easier. 'detach:prog:<prog_id>' and 'detach:fd:<fd>'.

By the way, I can also list the set of cumbersome steps needed to attach a
BPF program using perf and I bet it will be longer ;-)

> Through the patch set you call it ftrace. As far as I can see, this set
> has zero overlap with ftrace. There is no ftrace-bpf connection here at all
> that we discussed in the past Steven. It's all quite confusing.

It depends on what you mean by ftrace, may be I can call it 'trace events' or
something if it is less ambiguious. All of this has been collectively called
ftrace before.

I am not sure if you you are making sense actually, trace_events mechanism is
a part of ftrace. See the documentation: Documentation/trace/ftrace.rst. Even
the documentation file name has the word ftrace in it.

I have also spoken to Steven before about this, I don't think he ever told me
there is no connection so again I am a bit lost at your comments.

> I suggest android to solve sticky raw_tracepoint problem with user space deamon.
> The reasons, you point out why user daemon cannot be used, sound weak to me.

I don't think it is weak. It seems overkill to have a daemon for a trace
event that is say supposed to be attached to all the time for the lifetime of
the system. Why should there be a daemon consuming resources if it is active
all the time?

In Android, we are very careful about spawning useless processes and leaving
them alive for the lifetime of the system - for no good reason. Our security
teams also don't like this, and they can comment more.

> Another acceptable solution would be to introduce pinning of raw_tp objects.
> bpf progs and maps can be pinned in bpffs already. Pinning raw_tp would
> be natural extension.

I don't think the pinning solves the security problem, it just solves the
process lifetime problem. Currently, attaching trace events through perf
requires CAP_SYS_ADMIN. However, with ftrace events, we already control
security of events by labeling the nodes in tracefs and granting access to
the labeled context through the selinux policies. Having a 'bpf' node in
tracefs for events, and granting access to the labels is a natural extension.

I also thought about the pinning idea before, but we also want to add support
for not just raw tracepoints, but also regular tracepoints (events if you
will). I am hesitant to add a new BPF API just for creating regular
tracepoints and then pinning those as well.

I don't see why a new bpf node for a trace event is a bad idea, really.
tracefs is how we deal with trace events on Android. We do it in production
systems. This is a natural extension to that and fits with the security model
well.

thanks,

 - Joel




