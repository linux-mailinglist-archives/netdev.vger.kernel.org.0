Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC5ACF13B3
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfKFKQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:16:16 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40965 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730019AbfKFKQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:16:16 -0500
Received: by mail-pf1-f196.google.com with SMTP id p26so18492910pfq.8
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 02:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=LWhaWOk3qJ6PhGYnB7tu0nDt84GiXSttuOOylRuzwNc=;
        b=ObNh5sfXqEx18MUAaYvkcPImWOLTjuhO7VKVPtL2nZEQG+EET68NKQivKeOwF6Dm4g
         FGQDbUs1KTCi3/lY8t5Ij25W0NdnN6/CYRsQAMYKOsHYM5yhWFQ+A7x1Z+fYLo/UeL+r
         rId5mISetQvkVdgiBepwWG09mM8m0nqrmzFrE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=LWhaWOk3qJ6PhGYnB7tu0nDt84GiXSttuOOylRuzwNc=;
        b=FAUl7LuXNTAysGawhUb/zTHRYhFVZe6eQ9srCPDxKmMUxm7m3e7QlA464tBjlGvQ1y
         3I5Uq8NQQ/bj7zTpImcEzireXKft2mToGv6I/UhTww1OcPsdTtWLoMk3L/u170B3ttm8
         RkXpgp0yvkkWw3cDTY49JfDXkiOfQYpKHZ5iBW7zGUr8fFMrQp/TvjiP3Nz2mu/vR9cU
         aV7X7qH/aN4tLjWrS4o/oHOBEjZaOzYjwZ9n3ykIKh02qyODJXs/O8n9L/Zz963nJJWM
         XJknrrBo72ebDfDilDst9q7rV+yQwg9TTmpZOkdwEhTFCotyTseTm/QEiOcGpZ+v/4nY
         XlRQ==
X-Gm-Message-State: APjAAAU2XrRjsfrrCRLO8G9K98tfI5nqcKrgVceAKJy6EawIWyeKYkDQ
        WCNwvLAgt/5h1e/11do833riEA==
X-Google-Smtp-Source: APXvYqwxV7gDGYqEbtfgNl/MhyaITnpP/bBp/7zKAiqa0AArpIsZ6CMrCVE9eZTO2YbYXGUFpP/66Q==
X-Received: by 2002:a17:90a:901:: with SMTP id n1mr2761705pjn.113.1573035375469;
        Wed, 06 Nov 2019 02:16:15 -0800 (PST)
Received: from chromium.org ([122.173.128.252])
        by smtp.gmail.com with ESMTPSA id y36sm21074021pgk.66.2019.11.06.02.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 02:16:14 -0800 (PST)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Wed, 6 Nov 2019 15:45:58 +0530
To:     =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        Florent Revest <revest@chromium.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
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
Message-ID: <20191106101558.GA19467@chromium.org>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
 <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23acf523-dbc4-855b-ca49-2bbfa5e7117e@digikod.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05-Nov 19:01, Mickaël Salaün wrote:
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
> 
> > 
> > I think the only way bpf-based LSM can land is both landlock and KRSI
> > developers work together on a design that solves all use cases.
> 
> As I said in a previous cover letter [1], that would be great. I think
> that the current Landlock bases (almost everything from this series
> except the seccomp interface) should meet both needs, but I would like
> to have the point of view of the KRSI developers.

As I mentioned we are willing to collaborate but the current landlock
patches does not meet the needs for KRSI:

* One program type per use-case (eg. LANDLOCK_PROG_PTRACE) as opposed to
  a single program type. This is something that KRSI proposed in it's
  initial design [1] and the new common "eBPF + LSM" based approach
  [2] would maintain as well.

* Landlock chooses to have multiple LSM hooks per landlock hook which is
  more restrictive. It's not easy to write precise MAC and Audit
  policies for a privileged LSM based on this and this ends up bloating
  the context that needs to be maintained and requires avoidable
  boilerplate work in the kernel.

[1] https://lore.kernel.org/patchwork/project/lkml/list/?series=410101
[2] https://lore.kernel.org/bpf/20191106100655.GA18815@chromium.org/T/#u

- KP Singh

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
