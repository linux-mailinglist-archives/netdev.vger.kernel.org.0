Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEA08F7B8
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfHOXq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:46:27 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44058 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfHOXq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:46:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so1987189pgl.11;
        Thu, 15 Aug 2019 16:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8GUnlQq7sKH6YO7Fvf/HTqB1Q4SkgeH4IDU1h+ExxLo=;
        b=Mmtmm8Q4VIDJLlr/kOqAqoc75h4zD4kQQ9Jq94zavSTSqU99jrSLGMrOAhR+ROBUaz
         CKmJ4V78qEuQ9PHcL9oAcsbps7lQSJePMtEdJgEKgnxkF6ueXF41q/RnB3vkyNnhpVYy
         8BcZk30FFwPzrd6EyN25ylaSDPK2aG9KGLlVe4bWu8FqJFiKUUC6bIs0EO0lRKj94LLd
         NCZe0CF2ZTGQ+E8Lg66xwcIzUnL2lQbnEWjZDwb1bbtTgwQk7ztOMfCVBHAOrr0PAasv
         slYhUCBvN6ugr4BGQWg8i/PfzwqlEeZhCzrrybwVywjw5Y39cGiSm3wgE86TPBZRk29j
         HNTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8GUnlQq7sKH6YO7Fvf/HTqB1Q4SkgeH4IDU1h+ExxLo=;
        b=VNzPJHheDJPIHFviPtmG8GSjIcB6uHF5OWRh/YF/F6vBJw7p1cshrPQnS4mxsagkZp
         T1aAR+j8gdFpk8kUd7/X7b/A1+esq1O0a3Q40rD+sp4lfa6+7ob5c120hglz+DaBJemh
         6bdM8jGhGA6orZ4kZMxaZ4LFGsUKCEzqs3u64ORi1VWepCPvgcu7k04Mw40EQSY5CiVJ
         itHPTWpZS4rgSLOUpvI7np22ZOlBHaN2fzYmtReSmsKxd+OtLvmEZiFcO/0d9c/N6VLu
         AuP0siVwtUGG7wprT0jpVb+l/UP0c2prpSUMpSSdvQHDWtOeOMPWydK0gc4yjBfj1rSG
         oKOQ==
X-Gm-Message-State: APjAAAXO/frmsSXoBi91xJ1VHcl1Z59Kw9UwGB27ts6pC/9pauTS7TZs
        ScB2hNU0WT/EURUIwUJI7LU=
X-Google-Smtp-Source: APXvYqw+TyRqIJqEz0VpP1OYRH6xNFHUFVDLVyRM4LnSjcrFeFYcOG7soz0M8pT0kPEDicuBpjgn7w==
X-Received: by 2002:a63:36cc:: with SMTP id d195mr5308624pga.157.1565912785467;
        Thu, 15 Aug 2019 16:46:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::e9c1])
        by smtp.gmail.com with ESMTPSA id k25sm3465076pgt.53.2019.08.15.16.46.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 16:46:24 -0700 (PDT)
Date:   Thu, 15 Aug 2019 16:46:23 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Song Liu <songliubraving@fb.com>,
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
Message-ID: <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
References: <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <201908151203.FE87970@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908151203.FE87970@keescook>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 12:46:41PM -0700, Kees Cook wrote:
> On Tue, Aug 13, 2019 at 02:58:25PM -0700, Alexei Starovoitov wrote:
> > agree that containers (namespaces) reduce amount of trust necessary
> > for apps to run, but the end goal is not security though.
> 
> Unsurprisingly, I totally disagree: this is the very definition of
> improved "security": reduced attack surface, confined trust, etc.

there are different ways to define the meaning of the word "security".
Of course containers reduce attack surface, etc.
The 'attack surface' as a mitigation from malicious users is not always the goal
of running containers. Ask yourself why containers are used in the datacenters
where only root can ssh into a server, only signed packages can
ever be installed, no browsers running, and no remote code is ever downloaded?

> > Linux has become a single user system.
> 
> I hope this is just hyperbole, because it's not true in reality. I agree
> that the vast majority of Linux devices are single-user-at-a-time
> systems now (rather than the "shell servers" of yore), but the system
> still has to be expected to confine users from each other, root, and the
> hardware. Switching users on Chrome OS or a distro laptop, etc is still
> very much expected to _mean_ something.

of course.

> 
> > If user can ssh into the host they can become root.
> > If arbitrary code can run on the host it will be break out of any sandbox.
> > Containers are not providing the level of security that is enough
> > to run arbitrary code. VMs can do it better, but cpu bugs don't make it easy.
> 
> I'm not sure why you draw the line for VMs -- they're just as buggy
> as anything else. Regardless, I reject this line of thinking: yes,
> all software is buggy, but that isn't a reason to give up.

hmm. are you saying you want kernel community to work towards
making containers (namespaces) being able to run arbitrary code
downloaded from the internet?
In other words the problems solved by user space sandboxing, gvisor, etc
should be solved by the kernel?
I really don't think it's a good idea.

> If you look at software safety as a binary, you will always be
> disappointed. If you look at it as it manifests in the real world,
> then there is some perspective to be had. Reachability of flaws becomes
> a major factor; exploit chain length becomes a factor. There are very
> real impacts to be had from security hardening, sandboxing, etc. Of
> course nothing is perfect, but the current state of the world isn't
> as you describe. (And I say this with the knowledge of how long
> the lifetime of bugs are in the kernel.)

No arguing here. Security today is mainly the number of layers.
Hardening at all levels, sanboxing do help.
namespaces is one of the layers provided by the kernel.
The point that the kernel did its job already.
All other security layers are in user space.
Looking for bugs at every layer is still must have.
In the kernel, systemd, qemu, OS, browsers, etc.
Containers provide one level of security. VMs have another.

> > Some people call it more 'secure', but it's clearly not secure for
> > arbitrary code
> 
> Perhaps it's just a language issue. "More secure" and "safer" mean
> mostly the same thing to me. I tend to think "safer" is actually
> a superset that includes things that wreck the user experience but
> aren't actually in the privilege manipulation realm. In the traditional
> "security" triad of confidentiality, integrity, and availability, I tend
> to weigh availability less highly, but a bug that stops someone from
> doing their work but doesn't wreck data, let them switch users, etc,
> is still considered a "security" issue by many folks. The fewer bugs
> someone is exposed to improves their security, safety, whatever. The
> easiest way to do that is confinement and its associated attack surface
> reduction. tl;dr: security and safety are very use-case-specific
> continuum, not a binary state.

yep

> 
> > When we say 'unprivileged bpf' we really mean arbitrary malicious bpf program.
> > It's been a constant source of pain. The constant blinding, randomization,
> > verifier speculative analysis, all spectre v1, v2, v4 mitigations
> > are simply not worth it. It's a lot of complex kernel code without users.
> > There is not a single use case to allow arbitrary malicious bpf
> > program to be loaded and executed.
> 
> The world isn't binary (safe code/malicious code), and we need to build
> systems that can be used safely even when things go wrong. Yes, probably
> no one has a system that _intentionally_ feeds eBPF into the kernel from
> a web form. But there is probably someone who does it unintentionally,
> or has a user login exposed on a system where unpriv BPF is enabled. The
> point is to create primitives as safely as possible so when things DO
> go wrong, they fail safe instead of making things worse.
> 
> I'm all for a "less privileged than root" API for eBPF, but I get worried
> when I see "security" being treated as a binary state. Especially when
> it is considered an always-failed state. :)

'security as always failed state' ? hmm.
not sure where this impression came from.
One of the goals here is to do sysctl kernel.unprivileged_bpf_disabled=1
which will make the system overall _more_ secure.
I hope we can agree on that.

