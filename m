Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D791EF03F5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390449AbfKERSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:18:30 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35700 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389659AbfKERSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:18:30 -0500
Received: by mail-pf1-f195.google.com with SMTP id d13so16042938pfq.2;
        Tue, 05 Nov 2019 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=acyehhZ1kInQCOam4ex9rg1irdVyYdAedYo4L8HuhBE=;
        b=XX5HI5fdLsOtra8e6FRnylQV3POlGoUKjN0QnYgWdYOJbhoq4GfEwzEeXeNk2KlNeR
         cVlbwQ56h482SqsmeiyycLjPl/5cQaqbvnnxnAM834DFR1QuK+5nydBQhFrpZjok32Gs
         AR+xXuUBvANEvmAOUphy2n4Zx7YW461y5VxLfF/EtosJl8SnhT+Zr/CsDH5S4y/MHx2S
         ZjxeqFC22NsB4jP94cfp65T/GYZYybPc8LC7uxKNS7jlfkNEFav/I592UcGT0BwJ8FfK
         uA6ngmKqqv2JvvgOcXk+TtukS5gONMHHX01ywSEFKn0OVOWk9FKzUUGoSgwBXWeGoNNH
         I2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=acyehhZ1kInQCOam4ex9rg1irdVyYdAedYo4L8HuhBE=;
        b=n133OZv6dcpjgoC+09kN1c0SCJkvabFSbSJOqZjn8L1Q3J/RjzxpoXyu1DMYKj8ywp
         Dyvu04jiaRifsR97ZAOkSpfmqDCtk0/9OilwLXAmNJqsRT45YgjBAmnejZ9iskEYNhi4
         wOula1OaXbBl+pLlQZbVJK/vGoKDX7Tiw9CVF+QA27iIF0mRFGUmDVv3iRrkwZL94pkR
         kF91hIki6FjkBwKvDGsTRIt4RqNheoilqUHEVSjjyDhcaxxKBbJiKdGYnDj9i6sH2m8b
         AF000BTNXDVevPGw5upOZ6hUJ3QpEEdbrkxx4OdSUzUpQJzHRYcwiaphVHp6FqsqVY58
         FT5A==
X-Gm-Message-State: APjAAAUndn/FGRd3vu/HAW2/xpK2R2PQLRFIXKuPdO60Ye8gXd74bOpT
        YQ5ZiqqO1bswpANoWSQvII8=
X-Google-Smtp-Source: APXvYqxfGfRVQ8tyN+3W2wPHBfjDO9cnkSVobGLtqqzKW+U2w79oK6iebqGh0WK8FAFAk8uwenlUKg==
X-Received: by 2002:a17:90a:2326:: with SMTP id f35mr126860pje.134.1572974309032;
        Tue, 05 Nov 2019 09:18:29 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:47d0])
        by smtp.gmail.com with ESMTPSA id a66sm9765299pfb.166.2019.11.05.09.18.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:18:27 -0800 (PST)
Date:   Tue, 5 Nov 2019 09:18:26 -0800
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
Message-ID: <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191104172146.30797-5-mic@digikod.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 06:21:43PM +0100, Mickaël Salaün wrote:
> Add a first Landlock hook that can be used to enforce a security policy
> or to audit some process activities.  For a sandboxing use-case, it is
> needed to inform the kernel if a task can legitimately debug another.
> ptrace(2) can also be used by an attacker to impersonate another task
> and remain undetected while performing malicious activities.
> 
> Using ptrace(2) and related features on a target process can lead to a
> privilege escalation.  A sandboxed task must then be able to tell the
> kernel if another task is more privileged, via ptrace_may_access().
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
...
> +static int check_ptrace(struct landlock_domain *domain,
> +		struct task_struct *tracer, struct task_struct *tracee)
> +{
> +	struct landlock_hook_ctx_ptrace ctx_ptrace = {
> +		.prog_ctx = {
> +			.tracer = (uintptr_t)tracer,
> +			.tracee = (uintptr_t)tracee,
> +		},
> +	};

So you're passing two kernel pointers obfuscated as u64 into bpf program
yet claiming that the end goal is to make landlock unprivileged?!
The most basic security hole in the tool that is aiming to provide security.

I think the only way bpf-based LSM can land is both landlock and KRSI
developers work together on a design that solves all use cases. BPF is capable
to be a superset of all existing LSMs whereas landlock and KRSI propsals today
are custom solutions to specific security concerns. BPF subsystem was extended
with custom things in the past. In networking we have lwt, skb, tc, xdp, sk
program types with a lot of overlapping functionality. We couldn't figure out
how to generalize them into single 'networking' program. Now we can and we
should. Accepting two partially overlapping bpf-based LSMs would be repeating
the same mistake again.

