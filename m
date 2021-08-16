Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDF33EDD72
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhHPS5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHPS5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 14:57:52 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4BEC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 11:57:20 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id dj8so20083641edb.2
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 11:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a7ECraBkwCFiPkr0hFOEUiDEhGRF1HGg2NynZZR26r0=;
        b=1cH3PF0bgyOapqIzhkQDy/yuYUghkYFp3Xv0bsFz/p5R3Jg49CELDbyhGif+6iZ5vR
         +VMb6GcR/ew8us1qjScyKpF5AF11wv6VPMldyYQFGLcEnMF62Z4x5p9xxuKaYmmBTKVP
         MBh+VSVh0VJMcuzuOhg635MJrfA9icPiD1sIgNJ1b13X84u7muDyt7zpKe3VzRFHwCHz
         6/+2hzmSOkLk4GD/aooecAc0FuzjGu3+I1qki4z6xvBpMgReVzbAS3KAnVWIpU1m9ley
         rs4oebep32bB31B0ViUvECiz8UK2Cs+cIDfxLsD8M/BIcLJw87dFnmIaFHfuzmSgt1Jn
         BoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a7ECraBkwCFiPkr0hFOEUiDEhGRF1HGg2NynZZR26r0=;
        b=q9lAE4Kqu3Kl6GO4WuJxQsyPKwQyQcfZirPCff6uHHZs46e2p1IeJ6M9CNgmVZlN9/
         HxF/a4z0X/0v4fKfMaPaQZwofjGnC3cujLKlhTXk/HvVcUbgTOT0AcFHQ1B0dZcIeeO3
         t8sj6npp5atgli1O9rBRpSnXyNAmjne3iwBMpfJv7JYIGqxr84lcAngo+l7g6PDGgEH4
         E2TgLPqd6rkV1hNKrLdta7Vi5BF306TcwbsP7RlHy1eR1xRAQhaLdTJqYcmmLRsv6DPC
         XqbcwTxQCcxBaJAcZM376RiZFxyRgWYhBJ3xig4QkYSP1ZfkeqTSaUnV0Gk1MBPe2CDS
         dajQ==
X-Gm-Message-State: AOAM530tAAruRk/ZklQai4UNUKK5qXPO4X+91cWFtysjri/9x8+9C/RY
        Wh7ctjfJTg6aR46O5rbo9AMPZuTN5qjYiiyHbITh
X-Google-Smtp-Source: ABdhPJx0SdTFntxZUuZ5r581q1m85teCQ0nHihV/k5Y2aQb4XAbtmt48WwzHzqw0igGV4mQuMPOfSLw7zqEZzOAoJfc=
X-Received: by 2002:a05:6402:384:: with SMTP id o4mr57602edv.128.1629140238869;
 Mon, 16 Aug 2021 11:57:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210722004758.12371-1-casey@schaufler-ca.com>
 <20210722004758.12371-23-casey@schaufler-ca.com> <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
 <ace9d273-3560-3631-33fa-7421a165b038@schaufler-ca.com> <CAHC9VhSSASAL1mVwDo1VS3HcEF7Yb3LTTaoajEtq1HsA-8R+xQ@mail.gmail.com>
 <fba1a123-d6e5-dcb0-3d49-f60b26f65b29@schaufler-ca.com> <CAHC9VhQxG+LXxgtczhH=yVdeh9mTO+Xhe=TeQ4eihjtkQ2=3Fw@mail.gmail.com>
 <3ebad75f-1887-bb31-db23-353bfc9c0b4a@schaufler-ca.com>
In-Reply-To: <3ebad75f-1887-bb31-db23-353bfc9c0b4a@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 16 Aug 2021 14:57:07 -0400
Message-ID: <CAHC9VhQCN2_MsCoXfU7Z-syYHj2o8HaSECf5E62ZFcNZd9_4QA@mail.gmail.com>
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

On Fri, Aug 13, 2021 at 5:47 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/13/2021 1:43 PM, Paul Moore wrote:
> > On Fri, Aug 13, 2021 at 2:48 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> On 8/13/2021 8:31 AM, Paul Moore wrote:
> >>> On Thu, Aug 12, 2021 at 6:38 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>> On 8/12/2021 1:59 PM, Paul Moore wrote:
> >>>>> On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>>> Create a new audit record type to contain the subject information
> >>>>>> when there are multiple security modules that require such data.
> >>> ...
> >>>
> >>>>> The local
> >>>>> audit context is a hack that is made necessary by the fact that we
> >>>>> have to audit things which happen outside the scope of an executing
> >>>>> task, e.g. the netfilter audit hooks, it should *never* be used when
> >>>>> there is a valid task_struct.
> >>>> In the existing audit code a "current context" is only needed for
> >>>> syscall events, so that's the only case where it's allocated. Would
> >>>> you suggest that I track down the non-syscall events that include
> >>>> subj= fields and add allocate a "current context" for them? I looked
> >>>> into doing that, and it wouldn't be simple.
> >>> This is why the "local context" was created.  Prior to these stacking
> >>> additions, and the audit container ID work, we never needed to group
> >>> multiple audit records outside of a syscall context into a single
> >>> audit event so passing a NULL context into audit_log_start() was
> >>> reasonable.  The local context was designed as a way to generate a
> >>> context for use in a local function scope to group multiple records,
> >>> however, for reasons I'll get to below I'm now wondering if the local
> >>> context approach is really workable ...
> >> I haven't found a place where it didn't work. What is the concern?
> > The concern is that use of a local context can destroy any hopes of
> > linking with other related records, e.g. SYSCALL and PATH records, to
> > form a single cohesive event.  If the current task_struct is valid for
> > a given function invocation then we *really* should be using current's
> > audit_context.
> >
> > However, based on our discussion here it would seem that we may have
> > some issues where current->audit_context is not being managed
> > correctly.  I'm not surprised, but I will admit to being disappointed.
>
> I'd believe that with syscall audit being a special case for other reasons
> the multiple record situation got taken care of on a case-by-case basis
> and no one really paid much attention to generality. It's understandable.
>
> >>> What does your audit config look like?  Both the kernel command line
> >>> and the output of 'auditctl -l' would be helpful.
> >> On the fedora system:
> >>
> >> BOOT_IMAGE=(hd0,gpt2)/vmlinuz-5.14.0-rc5stack+
> >> root=/dev/mapper/fedora-root ro resume=/dev/mapper/fedora-swap
> >> rd.lvm.lv=fedora/root rd.lvm.lv=fedora/swap lsm.debug
> >>
> >> -a always,exit -F arch=b64 -S bpf -F key=testsuite-1628714321-EtlWIphW
> >>
> >> On the Ubuntu system:
> >>
> >> BOOT_IMAGE=/boot/vmlinuz-5.14.0-rc1stack+
> >> root=UUID=39c25777-d413-4c2e-948c-dfa2bf259049 ro lsm.debug
> >>
> >> No rules
> > The Fedora system looks to have some audit-testsuite leftovers, but
> > that shouldn't have an impact on what we are discussing; in both cases
> > I would expect current->audit_context to be allocated and non-NULL.
>
> As would I.
>
>
> >>> I'm beginning to suspect that you have the default
> >>> we-build-audit-into-the-kernel-because-product-management-said-we-have-to-but-we-don't-actually-enable-it-at-runtime
> >>> audit configuration that is de rigueur for many distros these days.
> >> Yes, but I've also fiddled about with it so as to get better event coverage.
> >> I've run the audit-testsuite, which has got to fiddle about with the audit
> >> configuration.
> > Yes, it looks like my hunch was wrong.
> >
> >>> If that is the case, there are many cases where you would not see a
> >>> NULL current->audit_context simply because the config never allocated
> >>> one, see kernel/auditsc.c:audit_alloc().
> >> I assume you mean that I *would* see a NULL current->audit_context
> >> in the "event not enabled" case.
> > Yep, typo.
> >
> >>> Regardless, assuming that is the case we probably need to find an
> >>> alternative to the local context approach as it currently works.  For
> >>> reasons we already talked about, we don't want to use a local
> >>> audit_context if there is the possibility for a proper
> >>> current->audit_context, but we need to do *something* so that we can
> >>> group these multiple events into a single record.
> >> I tried a couple things, but neither was satisfactory.
> >>
> >>> Since this is just occurring to me now I need a bit more time to think
> >>> on possible solutions - all good ideas are welcome - but the first
> >>> thing that pops into my head is that we need to augment
> >>> audit_log_end() to potentially generated additional, associated
> >>> records similar to what we do on syscall exit in audit_log_exit().
> >> I looked into that. You need a place to save the timestamp
> >> that doesn't disappear. That's the role the audit_context plays
> >> now.
> > Yes, I've spent a few hours staring at the poorly planned struct that
> > is audit_context ;)
> >
> > Regardless, the obvious place for such a thing is audit_buffer; we can
> > stash whatever we need in there.
>
> I had considered doing that, but was afraid that moving the timestamp
> out of the audit_context might have dire consequences.

Don't move, copy.  If there is a valid context one would stash the
timestamp there, if not, we stash it in the audit_buffer.  However,
before we start messing with that too much I would like to better
understand why we aren't seeing a valid audit_context in the netlink
case at the very least.

> >>>  Of
> >>> course the audit_log_end() changes would be much more limited than
> >>> audit_log_exit(), just the LSM subject and audit container ID info,
> >>> and even then we might want to limit that to cases where the ab->ctx
> >>> value is NULL and let audit_log_exit() handle it otherwise.  We may
> >>> need to store the event type in the audit_buffer during
> >>> audit_log_start() so that we can later use that in audit_log_end() to
> >>> determine what additional records are needed.
> >>>
> >>> Regardless, let's figure out why all your current->audit_context
> >>> values are NULL
> >> That's what's maddening, and why I implemented audit_alloc_for_lsm().
> >> They aren't all NULL. Sometimes current->audit_context is NULL,
> >> sometimes it isn't, for the same event. I thought it might be a
> >> question of the netlink interface being treated specially, but
> >> that doesn't explain all the cases.
> >
> > Your netlink changes are exactly what made me think, "this is
> > obviously wrong", but now I'm wondering if a previously held
> > assumption of "current is valid and points to the calling process" in
> > the case of the kernel servicing netlink messages sent from userspace.
>
> If that's the case the subject data in the audit record is going
> to be bogus. From what I've seen that data appears to be correct.

Yeah, the thought occurred to me, but we are clearly already in the
maybe-the-assumptions-are-wrong stage so I'm not going to rely on that
being 100%.  We definitely need to track this down before we start
making to many more guesses about what is working and what is not.

> > Or rather, perhaps that assumption is still true but something is
> > causing current->audit_context to be NULL in that case.
>
> I can imagine someone deciding not to set up audit_context in
> situations like netlink because they knew that nothing following
> that would be a syscall event.

*If* the user/kernel transition happens as part of the netlink socket
send/write/etc. syscall then it *should* have all of the audit syscall
setup already done ... however, see my earlier comments about
assumptions :/

> I've been looking into the audit
> userspace and there are assumptions like that all over the place.

I've made my feelings about audit's design known quite a bit already
so I'm not going to drag all of that back up, all I'll say is that I
believe the audit design was tragically and inherently flawed in many
ways.  We've been working to resolve some of those issues in the
kernel for a little while now, but the audit userspace remains rooted
in some of those original design decisions.  Of course, these are just
my opinions, others clearly feel differently.

Regardless, and somewhat independent of our discussion here, now that
I am back to being able to dedicate a good chunk of my time to
upstream efforts, one of my priorities is to start repairing audit ...
however, I need to get past the io_uring mess first.

> > Friday the 13th indeed.
>
> I've been banging my head against this for a couple months.
> My biggest fear is that I may have learned enough about the
> audit system to make useful contributions.

As the usual refrain goes, "patches are always welcome" ... and I say
that with equal parts honesty and warning :)

Even if you aren't comfortable putting together a patch, simply
root-causing the missing audit_context setup in the netlink case would
be helpful.

-- 
paul moore
www.paul-moore.com
