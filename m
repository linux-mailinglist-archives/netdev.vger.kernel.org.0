Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB9CA1029
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 06:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbfH2EH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 00:07:28 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45472 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfH2EH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 00:07:28 -0400
Received: by mail-pf1-f177.google.com with SMTP id w26so1125252pfq.12;
        Wed, 28 Aug 2019 21:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=w0kt/ZUsbjTm2T8fFDi3JgxkmlUidJXSFufUbXNNKCE=;
        b=qhzOR9cJ6L7DZn1HkdBMFCRqg/z+yoqvDqSweHrPdaz6+PZL2QPpWblX0pPUHjMZTQ
         7zbIceM7lFnWxlqr+lWpgCbe2rr95iHOall7VH87dj235uRsoOwSJoe4rJJbxu8YlvSw
         WjC7vA+pgTOfKsH9gIO1IieiiEP4xTJiq0Zts4hsbevNxP2dsN5xioHuUDJpzI3vRXJS
         0qfKFjI6M2VS/85HEw1Gjcb2I9FSxvRQ5RC1iikYapMkGmjsg3j+THXf0kf3gLkY338M
         +zaSyJ/mrt7+IWekig9GofhMHjfGa3uHIAWiwDt3w/5Y1u+thX+aJykyMf5KBUlMLVWR
         dbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=w0kt/ZUsbjTm2T8fFDi3JgxkmlUidJXSFufUbXNNKCE=;
        b=QnoardO0SPx6fOb+hrEynIoVdT001907JeCN0ZDnV9i42Zl9vqdh9CG5W0P1nz9HNz
         vgUFBzLsAlYH1bMAhUVK1K2jwRltcp2+nrkjTT5pShplNKAQN6bnZHBp2I9cWL0gGMI3
         2txMs6NAvE7+/tXWvNkZuOgCLxapTLtegTNfwrfxbgLV2NVhX9LtA6J9xxvAVmn4nH75
         SB9ACsgZKgzIzNgSLv93DaAjuvi7PsPEAm1FGAQIqeoqzM730ktMOZjUyGrot9F2ETRd
         qVjwm9ah1ztXgEvfvzSLM79gYt6Uoej3Iu8+g6WuTcaRoO4obpznnyMXWUq7+Yqd19fU
         cQ6g==
X-Gm-Message-State: APjAAAXfUouDLhxDROmwOxxQJYwX/NlULbOHqv+WATTk3xTTnxRsutv1
        n3t+sSzRlBlO4655JKIjnUE=
X-Google-Smtp-Source: APXvYqyPHkJAYhQSNPZHuxydg9VayItwubA4Zdtoip62p7IyAUioHvt20v/oeofIyrsg/afivZqLcw==
X-Received: by 2002:a63:10a:: with SMTP id 10mr6495671pgb.281.1567051646997;
        Wed, 28 Aug 2019 21:07:26 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::1e41])
        by smtp.gmail.com with ESMTPSA id a186sm679089pge.0.2019.08.28.21.07.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 21:07:26 -0700 (PDT)
Date:   Wed, 28 Aug 2019 21:07:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
References: <20190827205213.456318-1-ast@kernel.org>
 <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 05:45:47PM -0700, Andy Lutomirski wrote:
> > 
> >> It seems like you are specifically trying to add a new switch to turn
> >> as much of BPF as possible on and off.  Why?
> > 
> > Didn't I explain it several times already with multiple examples
> > from systemd, daemons, bpftrace ?
> > 
> > Let's try again.
> > Take your laptop with linux distro.
> > You're the only user there. I'm assuming you're not sharing it with
> > partner and kids. This is my definition of 'single user system'.
> > You can sudo on it at any time, but obviously prefer to run as many
> > apps as possible without cap_sys_admin.
> > Now you found some awesome open source app on the web that monitors
> > the health of the kernel and will pop a nice message on a screen if
> > something is wrong. Currently this app needs root. You hesitate,
> > but the apps is so useful and it has strong upstream code review process
> > that you keep running it 24/7.
> > This is open source app. New versions come. You upgrade.
> > You have enough trust in that app that you keep running it as root.
> > But there is always a chance that new version doing accidentaly
> > something stupid as 'kill -9 -1'. It's an open source app at the end.
> > 
> > Now I come with this CAP* proposal to make this app safer.
> > I'm not making your system more secure and not making this app
> > more secure. I can only make your laptop safer for day to day work
> > by limiting the operations this app can do.
> > This particular app monitros the kernel via bpf and tracing.
> > Hence you can give it CAP_TRACING and CAP_BPF and drop the rest.
> 
> This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> 
> 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> 
> 2. Improve it a bit do all the privileged ops are wrapped by capset().
> 
> Does this make sense?  I’m a security person on occasion. I find vulnerabilities and exploit them deliberately and I break things by accident on a regular basis. In my considered opinion, CAP_TRACING alone, even extended to cover part of BPF as I’ve described, is decently safe. Getting root with just CAP_TRACING will be decently challenging, especially if I don’t get to read things like sshd’s memory, and improvements to mitigate even that could be added.  I am quite confident that attacks starting with CAP_TRACING will have clear audit signatures if auditing is on.  I am also confident that CAP_BPF *will* allow DoS and likely privilege escalation, and this will only get more likely as BPF gets more widely used. And, if BPF-based auditing ever becomes a thing, writing to the audit daemon’s maps will be a great way to cover one’s tracks.

CAP_TRACING, as I'm proposing it, will allow full tracefs access.
I think Steven and Massami prefer that as well.
That includes kprobe with probe_kernel_read.
That also means mini-DoS by installing kprobes everywhere or running too much ftrace.

CAP_TRACING will allow perf_event_open() too.
Which also means mini-DoS with too many events.

CAP_TRACING with or without CAP_BPF is safe, but it's not secure.
And that's what I need to make above 'open source kernel health app' to be safe.

In real world we have tens of such apps and they use all of the things that
I'm allowing via CAP_BPF + CAP_NET_ADMIN + CAP_TRACING.
Some apps will need only two out of three.
I don't see any further possibility to shrink the scope of the proposal.

> I’m trying to convince you that bpf’s security model can be made better
> than what you’re proposing. I’m genuinely not trying to get in your way.
> I’m trying to help you improve bpf.

If you really want to help please don't reject the real use cases
just because they don't fit into your proposal.

There is not a single feature in BPF land that we did because we simply
wanted to. For every feature we drilled into use cases to make sure
there is a real user behind it.
Same thing with CAP_BPF. I'm defining it to include GET_FD_BY_ID because
apps use it and they need to made safer.

Anyway the v2 version of the patch with CAP_TRACING and CAP_BPF is on the way.
Hopefully later tonight or tomorrow.

