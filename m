Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0746F0613
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 20:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403759AbfKETev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 14:34:51 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33476 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390873AbfKETev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 14:34:51 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay6so3028225plb.0;
        Tue, 05 Nov 2019 11:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1N/htqrARk7XFY047OGh+oThXywZUGM5Z5FnUPMGMqg=;
        b=mAp2B7C92CaYNdyezgOABPgYdozzzrKQCwyFgzPU45P0lrmWE65Wa74/IxcIEM0gse
         +plntHXcLv2PxlSQKLvNi0xe3bycX/S12xUcEGas8UJUEHmGcagNCeAD81YQjWpMjA0Y
         D5SGZ+NTpst0N9XnSXlaIcC2EledyufG7jq5oeDkseOWdZg1HqGSS2I0P9b5V2P8wb8i
         Kme5OMLEAGw4pfsV9VxXE4knLtXuRVMAr8EA3gGiRKtOnQeE7gfQ+XFh1YL+3MfkDoig
         8TV3iAOxt2ScqHNqgu3AkxoAYRn3LamYtvhgzp0bMtWdOPEZEk349NM8yV9mgFeF7UyQ
         Az2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1N/htqrARk7XFY047OGh+oThXywZUGM5Z5FnUPMGMqg=;
        b=Tb6VoASHRs7ifmYbjNKGQX1+sER3QhB/wLym0LUc+xsA0L1RMP00vYJkERHWZt3vkp
         9/6enICEFakCJluvCMViVg11e07BwZFdZ/sMK4F1HXafykKrjlTyRA0le3s6knkH4ZJA
         cMo2ZgPSlwFmGM4Y3NVMd9oYD7R5NealQicvq6ZV5U5H+ha31HlioWhXQda5cbbfSzXG
         WIh78Co590WxKKJY8aTcFa6cCcD42YlvLVuUPeCcy8OMDiPFNWXi0q2h94t9beWUnmQl
         RS4rwqDwXD7qinHzEylZ33qjBAUd8310XMDIAayAGNvqjNMQJpVgFNBMyfSdsdnQ287Z
         uivA==
X-Gm-Message-State: APjAAAUscY9FK96HW7PlUbstR6m7mzsqABrUKqKFeV/wqGSBUgX32zQY
        Q0cAIwT3sFPHphSds3PnMFw=
X-Google-Smtp-Source: APXvYqxzogIVELW0ABnjq8MFoi/lLyCMWmiDef4qJvDicutDSIOJZuxZL1k8H+rEui8zMJT0shvHwA==
X-Received: by 2002:a17:902:362:: with SMTP id 89mr34042123pld.71.1572982489721;
        Tue, 05 Nov 2019 11:34:49 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id n23sm18928061pff.137.2019.11.05.11.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 11:34:48 -0800 (PST)
Date:   Tue, 5 Nov 2019 11:34:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
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
Message-ID: <20191105193446.s4pswwwhrmgk6hcx@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 05, 2019 at 07:01:41PM +0100, Mickaël Salaün wrote:
> 
> On 05/11/2019 18:18, Alexei Starovoitov wrote:
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
> > 
> > So you're passing two kernel pointers obfuscated as u64 into bpf program
> > yet claiming that the end goal is to make landlock unprivileged?!
> > The most basic security hole in the tool that is aiming to provide security.
> 
> How could you used these pointers without dedicated BPF helpers? This
> context items are typed as PTR_TO_TASK and can't be used without a
> dedicated helper able to deal with ARG_PTR_TO_TASK. Moreover, pointer
> arithmetic is explicitly forbidden (and I added tests for that). Did I
> miss something?

It's a pointer leak.

> 
> > 
> > I think the only way bpf-based LSM can land is both landlock and KRSI
> > developers work together on a design that solves all use cases.
> 
> As I said in a previous cover letter [1], that would be great. I think
> that the current Landlock bases (almost everything from this series
> except the seccomp interface) should meet both needs, but I would like
> to have the point of view of the KRSI developers.
> 
> [1] https://lore.kernel.org/lkml/20191029171505.6650-1-mic@digikod.net/
> 
> > BPF is capable
> > to be a superset of all existing LSMs whereas landlock and KRSI propsals today
> > are custom solutions to specific security concerns. BPF subsystem was extended
> > with custom things in the past. In networking we have lwt, skb, tc, xdp, sk
> > program types with a lot of overlapping functionality. We couldn't figure out
> > how to generalize them into single 'networking' program. Now we can and we
> > should. Accepting two partially overlapping bpf-based LSMs would be repeating
> > the same mistake again.
> 
> I'll let the LSM maintainers comment on whether BPF could be a superset
> of all LSM, but given the complexity of an access-control system, I have
> some doubts though. Anyway, we need to start somewhere and then iterate.
> This patch series is a first step.

I would like KRSI folks to speak up. So far I don't see any sharing happening
between landlock and KRSI. You're claiming this set is a first step. They're
claiming the same about their patches. I'd like to set a patchset that was
jointly developed.

