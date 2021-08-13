Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6C03EB94F
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 17:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbhHMPcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 11:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241182AbhHMPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 11:32:09 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2478C0613A4
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:31:42 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id b15so18942767ejg.10
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 08:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ve/K1nImq2PU8YYguMvzsx7Eg1JRHGri3AQYtcGqZkk=;
        b=yjWfsCJmpRHMdECvxoy1+wh34Po30t6I/oXCEbyWS7BIbbCfOoQBeza1HXZ0175Q5h
         wd4bKtWo2DFHC9PCzykH3CtPAmt/SR7UQFBo6SYODOkMSmnvrifQO8eHm1LCgwf+TcPn
         ZzelAgq9MTK1WKvXsjO+Ix4yP/XTss7pxVSH7qo6SJagZ3/JVrj2r+A2q3CIunJwHa3x
         8ULfp5ipsJJUoua+Dl0npdMrKyShecbC2R8dGcNtsCTocRawRkczyvKJ+InutgmVXVeq
         zDtEzg3Gs7Q5/mR8O7X+N5SMmTOD2fZ/yD7Y2rnUJsmP/C4k1+AkrHJem/4tB1cuA4Ne
         w9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ve/K1nImq2PU8YYguMvzsx7Eg1JRHGri3AQYtcGqZkk=;
        b=DjtPzoZ2Y19ZykDUqy9Ii2ko5NDAsWQW3YhtP9g1+Fq32dGEAMmcs0I8/d+E92jCRx
         sbzTS5Btq/79hLsV3w6B2Q12hzHDClkXMT7xS0yJEvRbSEvdD+boCb8JuHCYgfdP/apv
         0MU5zw4d85WW+bAvXmcg5Psi3+Thgl84BYFTnKMNgSxUC+oAizxtHXWahQXnTd7sppDE
         FagzDDy52ijcVA53HhmsrG747cGdHzKoYbyXsgwFAn7841VPU4/SJsek3LbHw4+BFOCn
         5clMxzrLktv7JPzeGUpKz26pSav5Wf6WSkJLIgW5gn2P6pYsXOZwyFATpuXI1oOJKm2h
         z/+Q==
X-Gm-Message-State: AOAM533FzHx+qrSDTAP07wEAVf0zgGmbsRe8q0VmvIjejnV03LrKmTWY
        M5nnGoN03Vt89AOr8tDYwmg64RG5Ptd2uuLxQuk9
X-Google-Smtp-Source: ABdhPJzfrHtFxvKIOhIj5PBhYgIqJ6sQ5tzuGe8s7VbPSm9n5/yDFmEYvaONAeu2nk3S1lzGZWCurubpcxiodux0rLw=
X-Received: by 2002:a17:906:779a:: with SMTP id s26mr3083213ejm.106.1628868701160;
 Fri, 13 Aug 2021 08:31:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210722004758.12371-1-casey@schaufler-ca.com>
 <20210722004758.12371-23-casey@schaufler-ca.com> <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
 <ace9d273-3560-3631-33fa-7421a165b038@schaufler-ca.com>
In-Reply-To: <ace9d273-3560-3631-33fa-7421a165b038@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 13 Aug 2021 11:31:30 -0400
Message-ID: <CAHC9VhSSASAL1mVwDo1VS3HcEF7Yb3LTTaoajEtq1HsA-8R+xQ@mail.gmail.com>
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

On Thu, Aug 12, 2021 at 6:38 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 8/12/2021 1:59 PM, Paul Moore wrote:
> > On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> Create a new audit record type to contain the subject information
> >> when there are multiple security modules that require such data.

...

> > The local
> > audit context is a hack that is made necessary by the fact that we
> > have to audit things which happen outside the scope of an executing
> > task, e.g. the netfilter audit hooks, it should *never* be used when
> > there is a valid task_struct.
>
> In the existing audit code a "current context" is only needed for
> syscall events, so that's the only case where it's allocated. Would
> you suggest that I track down the non-syscall events that include
> subj= fields and add allocate a "current context" for them? I looked
> into doing that, and it wouldn't be simple.

This is why the "local context" was created.  Prior to these stacking
additions, and the audit container ID work, we never needed to group
multiple audit records outside of a syscall context into a single
audit event so passing a NULL context into audit_log_start() was
reasonable.  The local context was designed as a way to generate a
context for use in a local function scope to group multiple records,
however, for reasons I'll get to below I'm now wondering if the local
context approach is really workable ...

> > Hopefully that makes sense?
>
> Yes, it makes sense. Methinks you may believe that the current context
> is available more regularly than it actually is.
>
> I instrumented the audit event functions with:
>
>         WARN_ONCE(audit_context, "%s has context\n", __func__);
>         WARN_ONCE(!audit_context, "%s lacks context\n", __func__);
>
> I only used local contexts where the 2nd WARN_ONCE was hit.

What does your audit config look like?  Both the kernel command line
and the output of 'auditctl -l' would be helpful.

I'm beginning to suspect that you have the default
we-build-audit-into-the-kernel-because-product-management-said-we-have-to-but-we-don't-actually-enable-it-at-runtime
audit configuration that is de rigueur for many distros these days.
If that is the case, there are many cases where you would not see a
NULL current->audit_context simply because the config never allocated
one, see kernel/auditsc.c:audit_alloc().  If that is the case, I'm
honestly a little surprised we didn't realize that earlier, especially
given all the work/testing that Richard has done with the audit
container ID bits, but then again he surely had a proper audit config
during his testing so it wouldn't have appeared.

Good times.

Regardless, assuming that is the case we probably need to find an
alternative to the local context approach as it currently works.  For
reasons we already talked about, we don't want to use a local
audit_context if there is the possibility for a proper
current->audit_context, but we need to do *something* so that we can
group these multiple events into a single record.

Since this is just occurring to me now I need a bit more time to think
on possible solutions - all good ideas are welcome - but the first
thing that pops into my head is that we need to augment
audit_log_end() to potentially generated additional, associated
records similar to what we do on syscall exit in audit_log_exit().  Of
course the audit_log_end() changes would be much more limited than
audit_log_exit(), just the LSM subject and audit container ID info,
and even then we might want to limit that to cases where the ab->ctx
value is NULL and let audit_log_exit() handle it otherwise.  We may
need to store the event type in the audit_buffer during
audit_log_start() so that we can later use that in audit_log_end() to
determine what additional records are needed.

Regardless, let's figure out why all your current->audit_context
values are NULL first (report back on your audit config please), I may
be worrying about a hypothetical that isn't real.

-- 
paul moore
www.paul-moore.com
