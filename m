Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45BD38D2FB
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 04:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhEVCWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 22:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbhEVCWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 22:22:23 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F251CC06138B
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 19:20:57 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id l1so33105632ejb.6
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 19:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AyDr1y/RwJoeqN22oXWBSWyEDma390VYzmRzYEs5lCg=;
        b=Lu0qQ1XZTBH8t2J0p/fhFAVkq1MZg33JOTinmTXfMebyUQuijZLlB7BQUQZVjoVGRo
         XNYXlp28jxndHy0kaHyUg3Vzxr5hqkCVLAKplIgebwyICZVy8ihRZvgsbGtM4IFFjSqs
         8Y/VMARbkoFcTZGMawK9goky0n6N6Z4SuEyeTL7+siu08yC8KFIUu01+i41cSADjo4Y2
         97pn98cLGkH6MeGG18rMtvAkBFnKsZkeOWo2RFL5F7wA7dk+fXMhsg91ZM4h7jPYzBz2
         WAVTR7tyLovlaWKbeY0kOGKUZjieOWcesDr1wVGBmBrCfWt5GTIUvaPOwSSZcRnd3HoS
         INYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AyDr1y/RwJoeqN22oXWBSWyEDma390VYzmRzYEs5lCg=;
        b=OLt18YTwUUIDRADQAsb3pnJ9Ub8CtMdXoeVGV+XDY+Wq+DH2kPtzToAgniumjhdFm+
         UwLR1n8uH1nPfBSfrkh80SD00GBL4Z/h/qzNkbCJHJyuWpEnSTHIsPaRybH7NMJUBv7c
         zqanKusmvKi7S2BkQXgwz/GQeAbzoiUmwSoAvU+TzijNNYx3wqTkm1W/1BrgPtQNyiVI
         dTUFa2ssmxHe5DreEi6tzJcGCqJeNPSswKgQLBY7UQHlWkldAL6FvhF+My2oHckIatC9
         GOouuRCOwMOCgzq7MmM/bhlKYO4gj3MHk3z8dWt7dF3c8NGtRSyfqgEl8z37pQaSNl6u
         aS/Q==
X-Gm-Message-State: AOAM5329KaZ4M69SVM13OWyy2edbyujtLbdBPkZoBnGG9gPG4QbCuVw7
        mnM+T2cHQajCekcNw0K7FTpMqvsULgNKZXBWRHZ4
X-Google-Smtp-Source: ABdhPJxtWsmcVYWOokYryWNIlC9jPQ5n8GMH6qfVU5ht4UMydIgEcs4bWq07Vr1o3LSIKBusJxMLXzOZ+aChS3mtfes=
X-Received: by 2002:a17:907:1749:: with SMTP id lf9mr13320714ejc.178.1621650055910;
 Fri, 21 May 2021 19:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210513200807.15910-1-casey@schaufler-ca.com>
 <20210513200807.15910-23-casey@schaufler-ca.com> <CAHC9VhSdFVuZvThMsqWT-L9wcHevA-0yAX+kxqXN0iMmqRc10g@mail.gmail.com>
 <d753115f-6cbd-0886-473c-b10485cb7c52@schaufler-ca.com>
In-Reply-To: <d753115f-6cbd-0886-473c-b10485cb7c52@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 May 2021 22:20:44 -0400
Message-ID: <CAHC9VhR9OPbNCLaKpCEt9mES8yWXpNoTBrgnKW2ER+vEkuNQwQ@mail.gmail.com>
Subject: Re: [PATCH v26 22/25] Audit: Add new record for multiple process LSM attributes
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

On Fri, May 21, 2021 at 6:05 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 5/21/2021 1:19 PM, Paul Moore wrote:
> > On Thu, May 13, 2021 at 4:32 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> Create a new audit record type to contain the subject information
> >> when there are multiple security modules that require such data.
> >> This record is linked with the same timestamp and serial number
> >> using the audit_alloc_local() mechanism.
> > The record is linked with the other associated records into a single
> > event, it doesn't matter if it gets the timestamp/serial from
> > audit_alloc_local() or an existing audit event, e.g. ongoing syscall.
> >
> >> The record is produced only in cases where there is more than one
> >> security module with a process "context".
> >> In cases where this record is produced the subj= fields of
> >> other records in the audit event will be set to "subj=?".
> >>
> >> An example of the MAC_TASK_CONTEXTS (1420) record is:
> >>
> >>         type=UNKNOWN[1420]
> >>         msg=audit(1600880931.832:113)
> >>         subj_apparmor==unconfined
> > It should be just a single "=" in the line above.
>
> AppArmor provides the 2nd "=" as part of the subject context.
> What's here is correct. I won't argue that it won't case confusion
> or worse.

Oh, wow, okay.  That needs to change at some point but I agree it's
out of scope for this patchset.  In the meantime I might suggest using
something other than AppArmor as an example here.

> >>         subj_smack=_
> >>
> >> There will be a subj_$LSM= entry for each security module
> >> LSM that supports the secid_to_secctx and secctx_to_secid
> >> hooks. The BPF security module implements secid/secctx
> >> translation hooks, so it has to be considered to provide a
> >> secctx even though it may not actually do so.
> >>
> >> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> >> To: paul@paul-moore.com
> >> To: linux-audit@redhat.com
> >> To: rgb@redhat.com
> >> Cc: netdev@vger.kernel.org
> >> ---
> >>  drivers/android/binder.c                |  2 +-
> >>  include/linux/audit.h                   | 24 ++++++++
> >>  include/linux/security.h                | 16 ++++-
> >>  include/net/netlabel.h                  |  3 +-
> >>  include/net/scm.h                       |  2 +-
> >>  include/net/xfrm.h                      | 13 +++-
> >>  include/uapi/linux/audit.h              |  1 +
> >>  kernel/audit.c                          | 80 ++++++++++++++++++-------
> >>  kernel/audit.h                          |  3 +
> >>  kernel/auditfilter.c                    |  6 +-
> >>  kernel/auditsc.c                        | 75 ++++++++++++++++++++---
> >>  net/ipv4/ip_sockglue.c                  |  2 +-
> >>  net/netfilter/nf_conntrack_netlink.c    |  4 +-
> >>  net/netfilter/nf_conntrack_standalone.c |  2 +-
> >>  net/netfilter/nfnetlink_queue.c         |  2 +-
> >>  net/netlabel/netlabel_domainhash.c      |  4 +-
> >>  net/netlabel/netlabel_unlabeled.c       | 24 ++++----
> >>  net/netlabel/netlabel_user.c            | 20 ++++---
> >>  net/netlabel/netlabel_user.h            |  6 +-
> >>  net/xfrm/xfrm_policy.c                  | 10 ++--
> >>  net/xfrm/xfrm_state.c                   | 20 ++++---
> >>  security/integrity/ima/ima_api.c        |  7 ++-
> >>  security/integrity/integrity_audit.c    |  6 +-
> >>  security/security.c                     | 46 +++++++++-----
> >>  security/smack/smackfs.c                |  3 +-
> >>  25 files changed, 274 insertions(+), 107 deletions(-)
> > ...
> >
> >> diff --git a/include/linux/audit.h b/include/linux/audit.h
> >> index 97cd7471e572..229cd71fbf09 100644
> >> --- a/include/linux/audit.h
> >> +++ b/include/linux/audit.h
> >> @@ -386,6 +395,19 @@ static inline void audit_ptrace(struct task_struct *t)
> >>                 __audit_ptrace(t);
> >>  }
> >>
> >> +static inline struct audit_context *audit_alloc_for_lsm(gfp_t gfp)
> >> +{
> >> +       struct audit_context *context = audit_context();
> >> +
> >> +       if (context)
> >> +               return context;
> >> +
> >> +       if (lsm_multiple_contexts())
> >> +               return audit_alloc_local(gfp);
> >> +
> >> +       return NULL;
> >> +}
> > See my other comments, but this seems wrong at face value.  The
> > additional LSM record should happen as part of the existing audit log
> > functions.
>
> I'm good with that. But if you defer calling audit_alloc_local()
> until you know you need it you may be in a place where you can't
> associate the new context with the event. I think. I will have
> another go at it.

I can't think of a case where you would ever not know if you need to
allocate a local context at the start.  If you are unsure, get in
touch and we can work it out.

> > I think I was distracted with the local context issue and I've lost
> > track of the details here, perhaps it's best to fix the local context
> > issue first (that should be a big change to this patch) and then we
> > can take another look.
>
> I really need to move forward. I'll give allocation of local contexts
> as necessary in audit_log_task_context() another shot.

I appreciate the desire to move forward, and while I can't speak for
everyone, I'll do my best to work with you to find a good solution.
If you get stuck or aren't sure you know how to reach me :)

As a start, I might suggest looking at some of the recent audit
container ID patchsets from Richard; while they have had some issues,
they should serve as a basic example of what we mean when we talk
about "local contexts" and how they should be used.

-- 
paul moore
www.paul-moore.com
