Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE123EBD8D
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 22:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbhHMUoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 16:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234313AbhHMUn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 16:43:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DEAC0617AE
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 13:43:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id n12so17173954edx.8
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 13:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iRAplBayhxWymKoWiC0WoyTJpbQvWuYgJ79F91VPsGY=;
        b=AJXHxf6mdypCa42/YwFeu+0Ff51vNI2hZQLJOtmI36BZuel/csiDOA2aXeD2vXyi4d
         6wdAaPLATieACVpkBz03DOgyyTecO6kBA7tpnJTW/LkLzIp1sfh/lF1uPjVIsPi9xL/E
         FzDEW8/RWzt4/ZHPAWIuS/V6U8kAIWsTC38r+MmecIj0MH979uAJtFb3YcvA+rzD1dH+
         nJddGcY6JX41yknjZUr05q5UpIPjre1WgcrpR8WfsxLoPsHKk5cAXEz7tauV2QDDGvd6
         U99fcfAJmKH3Ay8LkYJYjICks+rZlKX6e7Eef0N1THfeGYfNNxQ5aK7Qo3dWHqHr9eod
         JWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iRAplBayhxWymKoWiC0WoyTJpbQvWuYgJ79F91VPsGY=;
        b=ljOPK+5AjeLzuErWjjqovwAidJa66GCClSRJ9fzf1rBqO4Lo1EO1g8tEcMOseomY4U
         76G0q/QO8LzNpe3G425pbFcdIess61HeQl3cIG113bmVZDPApNZLAj4b/YOwRgL/drV5
         tsNSsZyQ8aNLyG0Xu8d5YvqJ9kzNrrpz69+zNz76q57M+g8oyyJwOa2yX55f2y4T7Hh4
         9+s9mA0klf1KC5z4zDVb0iuuKD5PWeX5Gl7GJ9uU6qnytyV5bbBrom0ngF18Xe6gtsk/
         7TLp7hybxEnYTrfaBYVWiNJCX4aDB5j+s39Mg76JLphIn9CTNzRMSiLrbmnZlrmKVAdS
         k+Pg==
X-Gm-Message-State: AOAM5300VU7nKCT233v5idBT7h5lvwy+OHBBDEkCb4KOJ+BpcuNPIniw
        fh165+AqdoyBVMqIPkOaFkhCimqiWxsrOzKkjqdJ
X-Google-Smtp-Source: ABdhPJzuZlbMX/SZdVH8AI8TEUryb01jMYyYASTBqkbdK5gus1OBuQz4ggC/DrTs2bokQflB8Rq6ia+jQ/0sJBH4L2c=
X-Received: by 2002:aa7:d982:: with SMTP id u2mr5423505eds.164.1628887409671;
 Fri, 13 Aug 2021 13:43:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210722004758.12371-1-casey@schaufler-ca.com>
 <20210722004758.12371-23-casey@schaufler-ca.com> <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
 <ace9d273-3560-3631-33fa-7421a165b038@schaufler-ca.com> <CAHC9VhSSASAL1mVwDo1VS3HcEF7Yb3LTTaoajEtq1HsA-8R+xQ@mail.gmail.com>
 <fba1a123-d6e5-dcb0-3d49-f60b26f65b29@schaufler-ca.com>
In-Reply-To: <fba1a123-d6e5-dcb0-3d49-f60b26f65b29@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Aug 2021 16:43:18 -0400
Message-ID: <CAHC9VhQxG+LXxgtczhH=yVdeh9mTO+Xhe=TeQ4eihjtkQ2=3Fw@mail.gmail.com>
Subject: Re: [PATCH v28 22/25] Audit: Add record for multiple process LSM attributes
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 2:48 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/13/2021 8:31 AM, Paul Moore wrote:
> > On Thu, Aug 12, 2021 at 6:38 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> On 8/12/2021 1:59 PM, Paul Moore wrote:
> >>> On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>> Create a new audit record type to contain the subject information
> >>>> when there are multiple security modules that require such data.
> > ...
> >
> >>> The local
> >>> audit context is a hack that is made necessary by the fact that we
> >>> have to audit things which happen outside the scope of an executing
> >>> task, e.g. the netfilter audit hooks, it should *never* be used when
> >>> there is a valid task_struct.
> >> In the existing audit code a "current context" is only needed for
> >> syscall events, so that's the only case where it's allocated. Would
> >> you suggest that I track down the non-syscall events that include
> >> subj= fields and add allocate a "current context" for them? I looked
> >> into doing that, and it wouldn't be simple.
> >
> > This is why the "local context" was created.  Prior to these stacking
> > additions, and the audit container ID work, we never needed to group
> > multiple audit records outside of a syscall context into a single
> > audit event so passing a NULL context into audit_log_start() was
> > reasonable.  The local context was designed as a way to generate a
> > context for use in a local function scope to group multiple records,
> > however, for reasons I'll get to below I'm now wondering if the local
> > context approach is really workable ...
>
> I haven't found a place where it didn't work. What is the concern?

The concern is that use of a local context can destroy any hopes of
linking with other related records, e.g. SYSCALL and PATH records, to
form a single cohesive event.  If the current task_struct is valid for
a given function invocation then we *really* should be using current's
audit_context.

However, based on our discussion here it would seem that we may have
some issues where current->audit_context is not being managed
correctly.  I'm not surprised, but I will admit to being disappointed.

> > What does your audit config look like?  Both the kernel command line
> > and the output of 'auditctl -l' would be helpful.
>
> On the fedora system:
>
> BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.14.0-rc5stack+
> root=/dev/mapper/fedora-root ro resume=/dev/mapper/fedora-swap
> rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap lsm.debug
>
> -a always,exit -F arch=b64 -S bpf -F key=testsuite-1628714321-EtlWIphW
>
> On the Ubuntu system:
>
> BOOT_IMAGE=/boot/vmlinuz-5.14.0-rc1stack+
> root=UUID=39c25777-d413-4c2e-948c-dfa2bf259049 ro lsm.debug
>
> No rules

The Fedora system looks to have some audit-testsuite leftovers, but
that shouldn't have an impact on what we are discussing; in both cases
I would expect current->audit_context to be allocated and non-NULL.

> > I'm beginning to suspect that you have the default
> > we-build-audit-into-the-kernel-because-product-management-said-we-have-to-but-we-don't-actually-enable-it-at-runtime
> > audit configuration that is de rigueur for many distros these days.
>
> Yes, but I've also fiddled about with it so as to get better event coverage.
> I've run the audit-testsuite, which has got to fiddle about with the audit
> configuration.

Yes, it looks like my hunch was wrong.

> > If that is the case, there are many cases where you would not see a
> > NULL current->audit_context simply because the config never allocated
> > one, see kernel/auditsc.c:audit_alloc().
>
> I assume you mean that I *would* see a NULL current->audit_context
> in the "event not enabled" case.

Yep, typo.

> > Regardless, assuming that is the case we probably need to find an
> > alternative to the local context approach as it currently works.  For
> > reasons we already talked about, we don't want to use a local
> > audit_context if there is the possibility for a proper
> > current->audit_context, but we need to do *something* so that we can
> > group these multiple events into a single record.
>
> I tried a couple things, but neither was satisfactory.
>
> > Since this is just occurring to me now I need a bit more time to think
> > on possible solutions - all good ideas are welcome - but the first
> > thing that pops into my head is that we need to augment
> > audit_log_end() to potentially generated additional, associated
> > records similar to what we do on syscall exit in audit_log_exit().
>
> I looked into that. You need a place to save the timestamp
> that doesn't disappear. That's the role the audit_context plays
> now.

Yes, I've spent a few hours staring at the poorly planned struct that
is audit_context ;)

Regardless, the obvious place for such a thing is audit_buffer; we can
stash whatever we need in there.

> >  Of
> > course the audit_log_end() changes would be much more limited than
> > audit_log_exit(), just the LSM subject and audit container ID info,
> > and even then we might want to limit that to cases where the ab->ctx
> > value is NULL and let audit_log_exit() handle it otherwise.  We may
> > need to store the event type in the audit_buffer during
> > audit_log_start() so that we can later use that in audit_log_end() to
> > determine what additional records are needed.
> >
> > Regardless, let's figure out why all your current->audit_context
> > values are NULL
>
> That's what's maddening, and why I implemented audit_alloc_for_lsm().
> They aren't all NULL. Sometimes current->audit_context is NULL,
> sometimes it isn't, for the same event. I thought it might be a
> question of the netlink interface being treated specially, but
> that doesn't explain all the cases.

Your netlink changes are exactly what made me think, "this is
obviously wrong", but now I'm wondering if a previously held
assumption of "current is valid and points to the calling process" in
the case of the kernel servicing netlink messages sent from userspace.
Or rather, perhaps that assumption is still true but something is
causing current->audit_context to be NULL in that case.

Friday the 13th indeed.

-- 
paul moore
www.paul-moore.com
