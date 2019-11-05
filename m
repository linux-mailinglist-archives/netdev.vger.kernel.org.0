Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458CFF0603
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390911AbfKETbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:31:36 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38959 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389691AbfKETbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:31:36 -0500
Received: by mail-pg1-f194.google.com with SMTP id 29so3745019pgm.6;
        Tue, 05 Nov 2019 11:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1SeagsDbeuKXlh/lZkZD0AtJ+ZGsb8zVUjbHRp2z3fk=;
        b=bG3YzgHY/KABC6APZVuTRck1R3V3hiIEonbR4Y6UPz+3BbG8+IUrTEUBpY9wx4cLKU
         WvBehL3A5X9T9a4/MuQkX6lGV1mUzk/M1UAZwNbbvjcCQ+BAEHcUN6NxOb/AwuB1eYuz
         JPwltdrZJbOOFMZWqocUM75vGTaHdfq2YeKxFcLsY4+IV1t4WxTicEXPXg6gA0lJCgMN
         Zg0UeDb9sdgfp0s4VwhDafzWQE6UI3QTlWWZUYuLxLv77dGWb2ON8usVq7+K6cnMAi6j
         f+7cChq65Br+qn9tL8e9tjke7GwNCdD/2L5f6mlggr82Vb0pkvSgaoprE3BxmhoXkHxq
         IZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1SeagsDbeuKXlh/lZkZD0AtJ+ZGsb8zVUjbHRp2z3fk=;
        b=FR1ZrTDeY6AoCbENusD3Mor8vm8PZ1NOrZ3Uk58uA3kXmd/pW1mq9DeBd2l882LIYR
         vVhJrnKSIKgVO302EyC34GKUtcbnTU3Xb63of2l9fRqGqc03QeKleRHwCJRRCes1Ztzq
         L6H1FRLQKFkwmAO1Xuvv1yJ0MbCrqROZr4mAW4qbUJzU7O371MJokZw6f9G55KMvK4tb
         +wlE+wgpKK6CvTmlrTRZ/PNEHdHAvVBeNXe1ej9/bAfUc3ZXpQo0FCLLGd5YCY22w3pL
         pyFIjUrrk8HwfD6mHok+YfsIN/1SpFZl+n3/IMY4mCQ510j7Nk+bb7D75XXmQnrr2/KS
         IFdg==
X-Gm-Message-State: APjAAAUvgQymxkGXgBKFKCfwmOvCznkwdw3ykEErW1uYRDwEjOSwjD/C
        wd0VROX/N6z2yPvJYvSzo1U=
X-Google-Smtp-Source: APXvYqy/IJZanoWg94nn+q8E66Sh0NTLVCbwR9j2nk1uXc92V5rp3fg98PT8TE2KB5Ylf7r6SRzC+w==
X-Received: by 2002:a17:90a:6283:: with SMTP id d3mr895052pjj.27.1572982295051;
        Tue, 05 Nov 2019 11:31:35 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id 21sm22270996pfa.170.2019.11.05.11.31.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 11:31:34 -0800 (PST)
Date:   Tue, 5 Nov 2019 11:31:32 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        Florent Revest <revest@chromium.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        KP Singh <kpsingh@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>, bpf@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
Message-ID: <20191105193130.qam2eafnmgvrvjwk@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 09:55:42AM -0800, Casey Schaufler wrote:
> On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
> > On Mon, Nov 04, 2019 at 06:21:43PM +0100, Mickaël Salaün wrote:
> >> Add a first Landlock hook that can be used to enforce a security policy
> >> or to audit some process activities.  For a sandboxing use-case, it is
> >> needed to inform the kernel if a task can legitimately debug another.
> >> ptrace(2) can also be used by an attacker to impersonate another task
> >> and remain undetected while performing malicious activities.
> >>
> >> Using ptrace(2) and related features on a target process can lead to a
> >> privilege escalation.  A sandboxed task must then be able to tell the
> >> kernel if another task is more privileged, via ptrace_may_access().
> >>
> >> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > ...
> >> +static int check_ptrace(struct landlock_domain *domain,
> >> +		struct task_struct *tracer, struct task_struct *tracee)
> >> +{
> >> +	struct landlock_hook_ctx_ptrace ctx_ptrace = {
> >> +		.prog_ctx = {
> >> +			.tracer = (uintptr_t)tracer,
> >> +			.tracee = (uintptr_t)tracee,
> >> +		},
> >> +	};
> > So you're passing two kernel pointers obfuscated as u64 into bpf program
> > yet claiming that the end goal is to make landlock unprivileged?!
> > The most basic security hole in the tool that is aiming to provide security.
> >
> > I think the only way bpf-based LSM can land is both landlock and KRSI
> > developers work together on a design that solves all use cases. BPF is capable
> > to be a superset of all existing LSMs
> 
> I can't agree with this. Nope. There are many security models
> for which BPF introduces excessive complexity. You don't need
> or want the generality of a general purpose programming language
> to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
> that matter. SELinux? I can't imagine anyone trying to do that
> in eBPF, although I'm willing to be surprised. Being able to
> enforce a policy isn't the only criteria for an LSM. 

what are the other criteria?

> It's got
> to perform well and integrate with the rest of the system. 

what do you mean by that?

> I see many issues with a BPF <-> vfs interface.

There is no such interface today. What do you have in mind?

> the mechanisms needed for the concerns of the day. Ideally,
> we should be able to drop mechanisms when we decide that they
> no longer add value.

Exactly. bpf-based lsm must not add to kernel abi.

