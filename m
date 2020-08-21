Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9A24DFBC
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgHUSfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgHUSfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:35:12 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A640C06179B
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:35:10 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id t10so3435518ejs.8
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q4frqIW9I+72sr79+gm0FlxLWfHVNqfXNa3Q85/YG38=;
        b=FFvdCi9F5IYZnNSXXIYkdNN6KgOiWn2gpkkna/pVmWNnIBtYPB/REc3lR/fIaVeCW9
         xcSIWYk5iEt0s3PqyD4BZtBeNRnNdMU5hgRft3ZaAVYAasCNtgX2d6rzDzZJkEmWns8Q
         DMouWMb6Wi3acrbp58tg1muQxWsOySA71Li1F/+ycwrhf8v2Y0nl3puJD3YvwQfnHUGb
         nrBMScR8wjFGLnAUtO3JiGu8kd20y0FCbHOw69GnkVA4KDSkAF+r8hp2olMacxwqoxVg
         jl1pnhCY2uVZkYVQNb9N1obAwGLTlc2+T6DsKYp19SXlykAO66qL+BjzJ7BOFir1WKli
         sEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q4frqIW9I+72sr79+gm0FlxLWfHVNqfXNa3Q85/YG38=;
        b=MpDySCXhn3tBBe9DNCgYSfagUodIC3kvnQFsa0sYUCeIb3cdasAVmygvJWiDdc2+Ls
         mRkqQxC+aytXJ2OE8P9+In+neQtf0EcjoBKpmg0OTZsOkayYK2NZ0wZ6drUuu/hUQAZL
         w1Sl2clDhRujb5SX7kFbMa2G45YfWJhdfYCMO6dwTWN52za1wXsUK8Hzh0w2vBFqPesP
         4yoIWbxuHz+edmY82CcWgOBtM+0VZidz2c/lU/9eNUbU+g6ifi0lgYPA70rNOxqHJpHW
         1GM/GWsVn+KQwZArODmtfrv2bx31ubUOGSRmxqk1N3XvVqbFCZlLy5+dBTeNYPt54bf4
         +uLQ==
X-Gm-Message-State: AOAM531Qm67heoeHDnXjWlfdG/GKHuh36PfjNhz+e1iPDYN/BaDrkMGD
        fRfOamsLaMrdoN1iZHrFZaU74IAvmzjZOZdM4K83
X-Google-Smtp-Source: ABdhPJxfrGP14Je3zh0ICJTpECzCcS4IA89+zoHjdAPERXK51mLX3W5gqb4xv4Taij+96NOlohguUZetQbWOQvF7dOs=
X-Received: by 2002:a17:906:43c9:: with SMTP id j9mr4143785ejn.542.1598034909369;
 Fri, 21 Aug 2020 11:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <4a5019ed3cfab416aeb6549b791ac6d8cc9fb8b7.1593198710.git.rgb@redhat.com>
 <CAHC9VhSwMEZrq0dnaXmPi=bu0NgUtWPuw-2UGDrQa6TwxWkZtw@mail.gmail.com> <20200718004341.ruyre5xhlu3ps2tr@madcap2.tricolour.ca>
In-Reply-To: <20200718004341.ruyre5xhlu3ps2tr@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 Aug 2020 14:34:57 -0400
Message-ID: <CAHC9VhSDLF3W4LNqdgz-56m8wXLZLpDhMd8S-DxFcrKvsgCreg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 08/13] audit: add containerid support for user records
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 8:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-07-05 11:11, Paul Moore wrote:
> > On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Add audit container identifier auxiliary record to user event standalone
> > > records.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > ---
> > >  kernel/audit.c | 19 ++++++++++++-------
> > >  1 file changed, 12 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index 54dd2cb69402..997c34178ee8 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -1507,6 +1504,14 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> > >                                 audit_log_n_untrustedstring(ab, str, data_len);
> > >                         }
> > >                         audit_log_end(ab);
> > > +                       rcu_read_lock();
> > > +                       cont = _audit_contobj_get(current);
> > > +                       rcu_read_unlock();
> > > +                       audit_log_container_id(context, cont);
> > > +                       rcu_read_lock();
> > > +                       _audit_contobj_put(cont);
> > > +                       rcu_read_unlock();
> > > +                       audit_free_context(context);
> >
> > I haven't searched the entire patchset, but it seems like the pattern
> > above happens a couple of times in this patchset, yes?  If so would it
> > make sense to wrap the above get/log/put in a helper function?
>
> I've redone the locking with an rcu lock around the get and a spinlock
> around the put.  It occurs to me that putting an rcu lock around the
> whole thing and doing a get without the refcount increment would save
> us the spinlock and put and be fine since we'd be fine with stale but
> consistent information traversing the contobj list from this point to
> report it.  Problem with that is needing to use GFP_ATOMIC due to the
> rcu lock.  If I stick with the spinlock around the put then I can use
> GFP_KERNEL and just grab the spinlock while traversing the contobj list.
>
> > Not a big deal either way, I'm pretty neutral on it at this point in
> > the patchset but thought it might be worth mentioning in case you
> > noticed the same and were on the fence.
>
> There is only one other place this is used, in audit_log_exit in
> auditsc.c.  I had noted the pattern but wasn't sure it was worth it.
> Inline or not?  Should we just let the compiler decide?

I'm generally not a fan of explicit inlines unless it has been shown
to be a real problem.

-- 
paul moore
www.paul-moore.com
