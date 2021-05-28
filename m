Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE1B39437B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhE1NoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:44:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232146AbhE1Nn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 09:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622209343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U2IqSZIHmJs1U626ov1801TPHqiAMQZgW3aXqcOf9ok=;
        b=aZjWNNFpyQHmN4fJRFe2e1L+qm+2GVOLTllFx5KP0SBVVo9oBsx5uX+ndH5Q9Svr313pvP
        Gsm9NeqK5jvoDMhBiHJePpVoXMV+mN/NpApf1f9trz6pzFYzh437ZPufESchFrRSSL+65c
        aFaDfcLOQKs2XWnSzXhtjyfpH8JLdbE=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-J1kQUcqZO_qUQUdBSD3Jzg-1; Fri, 28 May 2021 09:42:22 -0400
X-MC-Unique: J1kQUcqZO_qUQUdBSD3Jzg-1
Received: by mail-yb1-f200.google.com with SMTP id m205-20020a25d4d60000b029052a8de1fe41so4356834ybf.23
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 06:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U2IqSZIHmJs1U626ov1801TPHqiAMQZgW3aXqcOf9ok=;
        b=EyhLS8t6+w8+gL72PbvGWy+5Z9+YtrtnlM0SarQSvUkavZRc7ZIytBG8fih1yUscP6
         GbgY0Jqk9WhQRAe4jPJzbKPzdtunzL3VcIFHLIlC/Edy0eQkMfO1tMAr566EDYs140cz
         Em2PbCcJM90Gmog50B136/++Uf2bojB738qb99RKfU6ei1aO6WuxrX1f0P7HYWndv4lU
         5lRErC86479Vaznr/OpvCE9W4Xy0hjhXDon+OEl6oFP3H4Cm1+V1Qm/UPi974R7JZSvd
         UwXA23InZDZCje9fA4qoFnspTvcbQ7UPS4QGgAg71hJPAjGHbrlfFJLOAWujBlbzJIL8
         pLMQ==
X-Gm-Message-State: AOAM531Xxwz+OwCAgVhXATI26XaySO7+fPYPdkE1uBcBaexPttC7+w4x
        1Ztor8Lm6iZ+g8kxdE7uvC/lz3emsCX5Ae6zc01unyTFIgR9saO23+FxoMwxHiV8oQHwEKfJWXv
        ohv3IMOqoTZ8CQnufPE763hT581+o1iJv
X-Received: by 2002:a25:f208:: with SMTP id i8mr12505983ybe.340.1622209341653;
        Fri, 28 May 2021 06:42:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzY+Q3lAZD5z2I0qCaLzE8vPZbw30C0qe9jw96SwP96ICqH8giHKwWORUSXlm+cwx1tCc/b+Qf60iJexuKP47M=
X-Received: by 2002:a25:f208:: with SMTP id i8mr12505951ybe.340.1622209341353;
 Fri, 28 May 2021 06:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
In-Reply-To: <4fee8c12-194f-3f85-e28b-f7f24ab03c91@iogearbox.net>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Fri, 28 May 2021 15:42:06 +0200
Message-ID: <CAFqZXNsKf5wSGmspEVEDrm4Ywar-F4kJWbBPBE+_hd1CGQ3jhg@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Jiri Olsa <jolsa@redhat.com>, andrii.nakryiko@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(I'm off work today and plan to reply also to Paul's comments next
week, but for now let me at least share a couple quick thoughts on
Daniel's patch.)

On Fri, May 28, 2021 at 11:56 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 5/28/21 9:09 AM, Daniel Borkmann wrote:
> > On 5/28/21 3:37 AM, Paul Moore wrote:
> >> On Mon, May 17, 2021 at 5:22 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >>>
> >>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> >>> lockdown") added an implementation of the locked_down LSM hook to
> >>> SELinux, with the aim to restrict which domains are allowed to perform
> >>> operations that would breach lockdown.
> >>>
> >>> However, in several places the security_locked_down() hook is called in
> >>> situations where the current task isn't doing any action that would
> >>> directly breach lockdown, leading to SELinux checks that are basically
> >>> bogus.
> >>>
> >>> Since in most of these situations converting the callers such that
> >>> security_locked_down() is called in a context where the current task
> >>> would be meaningful for SELinux is impossible or very non-trivial (and
> >>> could lead to TOCTOU issues for the classic Lockdown LSM
> >>> implementation), fix this by modifying the hook to accept a struct cred
> >>> pointer as argument, where NULL will be interpreted as a request for a
> >>> "global", task-independent lockdown decision only. Then modify SELinux
> >>> to ignore calls with cred == NULL.
> >>
> >> I'm not overly excited about skipping the access check when cred is
> >> NULL.  Based on the description and the little bit that I've dug into
> >> thus far it looks like using SECINITSID_KERNEL as the subject would be
> >> much more appropriate.  *Something* (the kernel in most of the
> >> relevant cases it looks like) is requesting that a potentially
> >> sensitive disclosure be made, and ignoring it seems like the wrong
> >> thing to do.  Leaving the access control intact also provides a nice
> >> avenue to audit these requests should users want to do that.
> >
> > I think the rationale/workaround for ignoring calls with cred == NULL (or the previous
> > patch with the unimplemented hook) from Ondrej was two-fold, at least speaking for his
> > seen tracing cases:
> >
> >    i) The audit events that are triggered due to calls to security_locked_down()
> >       can OOM kill a machine, see below details [0].
> >
> >   ii) It seems to be causing a deadlock via slow_avc_audit() -> audit_log_end()
> >       when presumingly trying to wake up kauditd [1].

Actually, I wasn't aware of the deadlock... But calling an LSM hook
[that is backed by a SELinux access check] from within a BPF helper is
calling for all kinds of trouble, so I'm not surprised :)

> Ondrej / Paul / Jiri: at least for the BPF tracing case specifically (I haven't looked
> at the rest but it's also kind of independent), the attached fix should address both
> reported issues, please take a look & test.

Thanks, I like this solution, although there are a few gotchas:

1. This patch creates a slight "regression" in that if someone flips
the Lockdown LSM into lockdown mode on runtime, existing (already
loaded) BPF programs will still be able to call the
confidentiality-breaching helpers, while before the lockdown would
apply also to them. Personally, I don't think it's a big deal (and I
bet there are other existing cases where some handle kept from before
lockdown could leak data), but I wanted to mention it in case someone
thinks the opposite.

2. IIUC. when a BPF program is rejected due to lockdown/SELinux, the
kernel will return -EINVAL to userspace (looking at
check_helper_call() in kernel/bpf/verifier.c; didn't have time to look
at other callers...). It would be nicer if the error code from the
security_locked_down() call would be passed through the call chain and
eventually returned to the caller. It should be relatively
straightforward to convert bpf_base_func_proto() to return a PTR_ERR()
instead of NULL on error, but it looks like this would result in quite
a big patch updating all the callers (and callers of callers, etc.)
with a not-so-small chance of missing some NULL check and introducing
a bug... I guess we could live with EINVAL-on-denied in stable kernels
and only have the error path refactoring in -next; I'm not sure...

3. This is a bit of a shot-in-the-dark, but I suppose there might be
some BPF programs that would be able to do something useful also when
the read_kernel helpers return an error, yet the kernel will now
outright refuse to load them (when the lockdown hook returns nonzero).
I have no idea if such BPF programs realistically exist in practice,
but perhaps it would be worth returning some dummy
always-error-returning helper function instead of NULL from
bpf_base_func_proto() when security_locked_down() returns an error.
That would also resolve (2.), basically. (Then there is the question
of what error code to use (because Lockdown LSM uses -EPERM, while
SELinux -EACCESS), but I think always returning -EPERM from such stub
helpers would be a viable choice.)

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

