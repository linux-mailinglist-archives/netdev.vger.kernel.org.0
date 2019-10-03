Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879A6CAA28
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389888AbfJCQUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:20:22 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44934 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389858AbfJCQUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:20:21 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so1735753pll.11;
        Thu, 03 Oct 2019 09:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=MG/uLz4SZESf1T6JsOhjytWUwwylG/7dnOv+CW4DjNk=;
        b=oGNLjsrcGkDwmNGN6jFGRgrg8PebuBK4+SzFVVNJ39DEk6EbR6+EDsuzazqitQe5KT
         vjkwLIHZoYuLJOWirv43T80diWz1JpD3OCVyWkHKZ6YMU9Kh6p2a9TD2gyKNeM0Dt+V2
         PQp2xVxZa9xJXHja1d/Y4+5OpW1Z9GPoDR3bfVoEyMOkO0tsJ26gMy4VJvGrkF8Xq11l
         Rt0wxADAC1vZZfCX7K+Fz6N2YCSvYBglNUtXyGq/KYWq/6RPZm48VtqTssGoE/c3p30Q
         sUJChgn4k4foLFYqQ01B1xtq4b7GxPUDDfXh31B2z/3ZgXqDqBZZce2J8oKwFTqv2XCe
         oHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=MG/uLz4SZESf1T6JsOhjytWUwwylG/7dnOv+CW4DjNk=;
        b=YGSP+sN5A9V8CCHYTdb2toDm6+5JgV+QjK5NXpV/aUQTh9+0QPb7uhwpF1YMtePYK1
         FvCzrWEC9c5IraBkpzSrCaEH2skm0ibZvZk+xdycpKD3XrT7WDJvV3I0hG2gwuuhgBkX
         vQu1/4hT1oCSZfZqfMRgdJ7dp7p+sWqxpkqK6Ysl4MFOFqeEHw82IIekqxG2KwHlC5Bg
         qa6BYj2a64JEP5y9nWwvifpvDrHDiVjorsaVl9Wzucwt5j0jbKV+/OlidQE5uQ0J2ayd
         ivsLry+E0ZOuxhjqhGm2M2qxQr54xTohP4JpTRHFfndSVUKfgM/tv7ip0Rq9UHamZRtw
         rPQg==
X-Gm-Message-State: APjAAAVSDQVAZ7R+8FkoqYiQDu+IavzWaSQVU0mdXCl6Y62M7CNKx/m7
        N4DaiiGlnNZmzokTbKLMLp4mR3V5
X-Google-Smtp-Source: APXvYqwo0fuKkijfAeUsnw6Bgl7uNYpjzbrqdZXJGut8Zbmi7u1dEjGhAYPti48JxqcpLH5wegjvWQ==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr10099118plb.163.1570119620166;
        Thu, 03 Oct 2019 09:20:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:535c])
        by smtp.gmail.com with ESMTPSA id f89sm5436846pje.20.2019.10.03.09.20.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 09:20:19 -0700 (PDT)
Date:   Thu, 3 Oct 2019 09:20:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-ID: <20191003162015.7bpyik3z5zulpqon@ast-mbp.dhcp.thefacebook.com>
References: <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home>
 <201909301129.5A1129C@keescook>
 <20191003151204.5857bb24245f9c3355f27e0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191003151204.5857bb24245f9c3355f27e0d@kernel.org>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 03:12:04PM +0900, Masami Hiramatsu wrote:
> On Mon, 30 Sep 2019 11:31:29 -0700
> Kees Cook <keescook@chromium.org> wrote:
> 
> > On Sat, Sep 28, 2019 at 07:37:27PM -0400, Steven Rostedt wrote:
> > > On Wed, 28 Aug 2019 21:07:24 -0700
> > > Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > > > > 
> > > > > This won’t make me much more comfortable, since CAP_BPF lets it do an ever-growing set of nasty things. I’d much rather one or both of two things happen:
> > > > > 
> > > > > 1. Give it CAP_TRACING only. It can leak my data, but it’s rather hard for it to crash my laptop, lose data, or cause other shenanigans.
> > > > > 
> > > > > 2. Improve it a bit do all the privileged ops are wrapped by capset().
> > > > > 
> > > > > Does this make sense?  I’m a security person on occasion. I find
> > > > > vulnerabilities and exploit them deliberately and I break things by
> > > > > accident on a regular basis. In my considered opinion, CAP_TRACING
> > > > > alone, even extended to cover part of BPF as I’ve described, is
> > > > > decently safe. Getting root with just CAP_TRACING will be decently
> > > > > challenging, especially if I don’t get to read things like sshd’s
> > > > > memory, and improvements to mitigate even that could be added.  I
> > > > > am quite confident that attacks starting with CAP_TRACING will have
> > > > > clear audit signatures if auditing is on.  I am also confident that
> > > > > CAP_BPF *will* allow DoS and likely privilege escalation, and this
> > > > > will only get more likely as BPF gets more widely used. And, if
> > > > > BPF-based auditing ever becomes a thing, writing to the audit
> > > > > daemon’s maps will be a great way to cover one’s tracks.  
> > > > 
> > > > CAP_TRACING, as I'm proposing it, will allow full tracefs access.
> > > > I think Steven and Massami prefer that as well.
> > > > That includes kprobe with probe_kernel_read.
> > > > That also means mini-DoS by installing kprobes everywhere or running
> > > > too much ftrace.
> > > 
> > > I was talking with Kees at Plumbers about this, and we were talking
> > > about just using simple file permissions. I started playing with some
> > > patches to allow the tracefs be visible but by default it would only be
> > > visible by root.
> > > 
> > >  rwx------
> > > 
> > > Then a start up script (or perhaps mount options) could change the
> > > group owner, and change this to:
> > > 
> > >  rwxrwx---
> > > 
> > > Where anyone in the group assigned (say "tracing") gets full access to
> > > the file system.
> 
> Does it for "all" files under tracefs?
> 
> > > 
> > > The more I was playing with this, the less I see the need for
> > > CAP_TRACING for ftrace and reading the format files.
> > 
> > Nice! Thanks for playing with this. I like it because it gives us a way
> > to push policy into userspace (group membership, etc), and provides a
> > clean way (hopefully) do separate "read" (kernel memory confidentiality)
> > from "write" (kernel memory integrity), which wouldn't have been possible
> > with a single new CAP_...
> 
>  From the confidentiality point of view, if tracefs exposes traced data,
> it might include in-kernel pointer and symbols, but the user still can't
> see /proc/kallsyms. This means we still have several different confidentiality
> for each interface.
> 
> Anyway, adding a tracefs mount option for allowing a user group to access
> event format data will be a good idea. But even though, I  think we still
> need the CAP_TRACING for allowing control of intrusive tracing, like kprobes
> and bpf etc. (Or, do we keep those for CAP_SYS_ADMIN??)

No doubt. This thread is only about tracefs wanting to do its own fs based controls.

