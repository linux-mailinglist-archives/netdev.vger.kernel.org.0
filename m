Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3DD63037E
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE3Upn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:45:43 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42533 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfE3Upm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:45:42 -0400
Received: by mail-lf1-f67.google.com with SMTP id y13so6082547lfh.9
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 13:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EhDqOLrNL+Ls6g+jJlH1kHSTN+6mKWoVpwhK7g7g/0o=;
        b=xlyV3ThJjdhKcZhreP5PbaxjF4yCg2iuc+K7UzQP6tLJWwrREj0I5yVvPo3B3jh7iK
         jh1rsg4jyI3plqbkkIs9e7MgP53igOczr5L4MydDQ87MWflfgTeiR7tPUVxTFoKpmcm4
         6sepnRi8IUd5YcXQYTYWT9BEkanR1k/eUovXIZ4CYEx4LttHAIlePcabZEyckUcOfwA+
         ld4cKn0kM4Vfx29ADhSIicvea8BSndd/KrqWITOd8GFDTydQiWEJoSMQKugjZoDNrglv
         RFE65J9Z1q+k0M/9D9082A8PAYYyDpKeO4/3eIRTiQyhsN5cVxluVIS5g72M/cFmB4vp
         uEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EhDqOLrNL+Ls6g+jJlH1kHSTN+6mKWoVpwhK7g7g/0o=;
        b=MpfQnZ5z5wgVv9iderdiBob6IzsndVjRX4oXJxdbbZT9b4Ww3xuU5Gp5AadiYc8pYU
         5SRR4u5saw0FP4C7OKzShZc7pzAM8hhyme+sSpPM+vxibccVEEHKT226hXALLp1Z0GIi
         kDuwmWoFzYuf98Sytubh1rgxH471S9Sp/zksaHE/ZUcutaNDuUFuu9DIPranrQJhL8sC
         m+8R39bRO8Uf3kn7MmOp0d7anJ8BbEyiqRsam4OsKxTiZ9fLggqD8bezYSdWKIx1YQUm
         Qq+h02tZewFOf3B0aWoYdMDKEIDS5EuSZ5clbnTr3KXpTHRgz+S9HfMgYGigvGrMRKxV
         QsKg==
X-Gm-Message-State: APjAAAWprVTm9Ixqlqc7fVx7S98QPkl+DwNO3KNgdRRjOi6SZVFycdcZ
        kykVw6Vv/IRPEA5wzv+3zPZo0QiSFJoDGvIQ0pAu
X-Google-Smtp-Source: APXvYqxCLcpJGQ9X7hllnM/E88Y7wiOxHiqGV+F77SwcvQq/KmkEMFzXAp+UwedDTn7SR4CSxAW2AxSMb9dduBaWcmQ=
X-Received: by 2002:ac2:410a:: with SMTP id b10mr3157662lfi.175.1559249140261;
 Thu, 30 May 2019 13:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <0785ee2644804f3ec6af1243cc0dcf89709c1fd4.1554732921.git.rgb@redhat.com>
 <CAHC9VhRV-0LSEcRvPO1uXtKdpEQsaLZnBV3T=zcMTZPN5ugz5w@mail.gmail.com>
 <20190530141951.iofimovrndap4npq@madcap2.tricolour.ca> <CAHC9VhQhkzCtVOXhPL7BzaqvF0y+8gBQwhOo1EQDS2OUyZbV5g@mail.gmail.com>
 <20190530203702.fibsrazabbiifjvf@madcap2.tricolour.ca>
In-Reply-To: <20190530203702.fibsrazabbiifjvf@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 16:45:28 -0400
Message-ID: <CAHC9VhR6oqKer_p6Xsu6oO2j3bMZGPXWHnGchZOqUoMx9yJFwQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 08/10] audit: add containerid filtering
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 4:37 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-05-30 10:34, Paul Moore wrote:
> > On Thu, May 30, 2019 at 10:20 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > On 2019-05-29 18:16, Paul Moore wrote:
> > > > On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > >
> > > > > Implement audit container identifier filtering using the AUDIT_CONTID
> > > > > field name to send an 8-character string representing a u64 since the
> > > > > value field is only u32.
> > > > >
> > > > > Sending it as two u32 was considered, but gathering and comparing two
> > > > > fields was more complex.
> > > > >
> > > > > The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID.
> > > > >
> > > > > Please see the github audit kernel issue for the contid filter feature:
> > > > >   https://github.com/linux-audit/audit-kernel/issues/91
> > > > > Please see the github audit userspace issue for filter additions:
> > > > >   https://github.com/linux-audit/audit-userspace/issues/40
> > > > > Please see the github audit testsuiite issue for the test case:
> > > > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > > > Please see the github audit wiki for the feature overview:
> > > > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > > > ---
> > > > >  include/linux/audit.h      |  1 +
> > > > >  include/uapi/linux/audit.h |  5 ++++-
> > > > >  kernel/audit.h             |  1 +
> > > > >  kernel/auditfilter.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >  kernel/auditsc.c           |  4 ++++
> > > > >  5 files changed, 57 insertions(+), 1 deletion(-)
> > > >
> > > > ...
> > > >
> > > > > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > > > > index 63f8b3f26fab..407b5bb3b4c6 100644
> > > > > --- a/kernel/auditfilter.c
> > > > > +++ b/kernel/auditfilter.c
> > > > > @@ -1206,6 +1224,31 @@ int audit_comparator(u32 left, u32 op, u32 right)
> > > > >         }
> > > > >  }
> > > > >
> > > > > +int audit_comparator64(u64 left, u32 op, u64 right)
> > > > > +{
> > > > > +       switch (op) {
> > > > > +       case Audit_equal:
> > > > > +               return (left == right);
> > > > > +       case Audit_not_equal:
> > > > > +               return (left != right);
> > > > > +       case Audit_lt:
> > > > > +               return (left < right);
> > > > > +       case Audit_le:
> > > > > +               return (left <= right);
> > > > > +       case Audit_gt:
> > > > > +               return (left > right);
> > > > > +       case Audit_ge:
> > > > > +               return (left >= right);
> > > > > +       case Audit_bitmask:
> > > > > +               return (left & right);
> > > > > +       case Audit_bittest:
> > > > > +               return ((left & right) == right);
> > > > > +       default:
> > > > > +               BUG();
> > > >
> > > > A little birdy mentioned the BUG() here as a potential issue and while
> > > > I had ignored it in earlier patches because this is likely a
> > > > cut-n-paste from another audit comparator function, I took a closer
> > > > look this time.  It appears as though we will never have an invalid op
> > > > value as audit_data_to_entry()/audit_to_op() ensure that the op value
> > > > is a a known good value.  Removing the BUG() from all the audit
> > > > comparators is a separate issue, but I think it would be good to
> > > > remove it from this newly added comparator; keeping it so that we
> > > > return "0" in the default case seems reasoanble.
> > >
> > > Fair enough.  That BUG(); can be removed.
> >
> > Please send a fixup patch for this.
>
> The fixup patch is trivial.

Yes, I know.

> The rebase to v5.2-rc1 audit/next had merge
> conflicts with four recent patchsets.  It may be simpler to submit a new
> patchset and look at a diff of the two sets.  I'm testing the rebase
> now.

Great thanks.  Although you might want to hold off a bit on posting
the next revision until we sort out the discussion which is happening
in patch 02/10; unfortunately I fear we may need to change some of the
logic.

--
paul moore
www.paul-moore.com
