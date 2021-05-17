Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5D2382722
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhEQIfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:35:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235656AbhEQIfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 04:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621240467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0rIkLZVSWvcw5d0SRX5kn9M8zHvErYPyZMfehLrUnc=;
        b=hQJu/Q9DiIwDZsPigFsECdGZgI7dhLjR8o5xX89/y1TC1IZINiym/UUegzE+cTRD3GG0ol
        l5keOYQNMBqPJiGpSoxICfmnsvkyfuOpV0pEuZoKIXMoAm0nou/uRfyLt8+UPCIgDvn8iH
        5SvCP6MyCUSGpL35pJQ38LbggjfzmUQ=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-V6xpRPfAM2WPyPzuHdzwYA-1; Mon, 17 May 2021 04:34:25 -0400
X-MC-Unique: V6xpRPfAM2WPyPzuHdzwYA-1
Received: by mail-yb1-f199.google.com with SMTP id p140-20020a25d8920000b0290508c3296a35so6648221ybg.8
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 01:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H0rIkLZVSWvcw5d0SRX5kn9M8zHvErYPyZMfehLrUnc=;
        b=Cu7G/xunB/ruCkE1l4pQr6idPecZbP/K1sf4+Cx+aWvikyrZYffkVq+QirvqhL3CMQ
         H6ZmToId4LsAbNbkeySq7bwtVm0IowGs7y0DphNhanQMc8W7lfC+mAd2xhg4Ll20smiZ
         K0+wm1PFBZl80y41ngTjvuR1/Ym2S/FrtFqTjaBeFkT62XeQhIs+J6gbw3vg4YMZniYI
         cmEL7qQq+7BxpxPVkbeEXYa0C4vK3GTgGxBUs5vstnOCNMmBeNGNtjPBgyY2VULcctwj
         2FqqKhN6XPizf0HTUoSpY4FFKkLyRtNLuORqkY6PbRoBN3Kt5RbuDoV+i4uz7+I454YB
         hH2A==
X-Gm-Message-State: AOAM532DXgMXhbThdUDJYAIoW78PVYJgo/B6wt6ZULHl9hp4eyMNCvdn
        w0egJxX5tlDmcYjhDof6Rq1vBg/B1ybSc+w5VrbxZ8OXZQvgI8mXwguJ4NnTwd2gD83EYx+R2xS
        Za2PgMxU0VTihPdFjQisW8LH1/DP4u7gX
X-Received: by 2002:a25:7451:: with SMTP id p78mr10684341ybc.227.1621240465227;
        Mon, 17 May 2021 01:34:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG+xOt2sI6iuR2d62PUilNKaHp2d8mDgxkq88vNwwlef+ekCp0Xow3HwXFMFBuMiPNKcW/vJ9jupOWJKiZWFg=
X-Received: by 2002:a25:7451:: with SMTP id p78mr10684322ybc.227.1621240465001;
 Mon, 17 May 2021 01:34:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210507114048.138933-1-omosnace@redhat.com> <a8d138a6-1d34-1457-9266-4abeddb6fdba@schaufler-ca.com>
 <CAFqZXNtr1YjzRg7fTm+j=0oZF+7C5xEu5J0mCZynP-dgEzvyUg@mail.gmail.com>
 <24a61ff1-e415-adf8-17e8-d212364d4b97@schaufler-ca.com> <CAFqZXNvB-EyPz1Qz3cCRTr1u1+D+xT-dp7cUxFocYM1AOYSuxw@mail.gmail.com>
 <e8d60664-c7ad-61de-bece-8ab3316f77bc@schaufler-ca.com> <CAFqZXNu_DW1FgnVvtA+CnBMtdRDrzYo5B3_=SzKV7-o1CaV0RA@mail.gmail.com>
 <94486043-322f-74bd-dc33-83e43b531068@schaufler-ca.com>
In-Reply-To: <94486043-322f-74bd-dc33-83e43b531068@schaufler-ca.com>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Mon, 17 May 2021 10:34:12 +0200
Message-ID: <CAFqZXNucQhcYTZPGmi0MeHOvwCTsxxBSwzZ+W_MODX0_5WgcPg@mail.gmail.com>
Subject: Re: [PATCH] lockdown,selinux: fix bogus SELinux lockdown permission checks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 15, 2021 at 2:57 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 5/14/2021 8:12 AM, Ondrej Mosnacek wrote:
> > On Wed, May 12, 2021 at 7:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >> On 5/12/2021 9:44 AM, Ondrej Mosnacek wrote:
> >>> On Wed, May 12, 2021 at 6:18 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>> On 5/12/2021 6:21 AM, Ondrej Mosnacek wrote:
> >>>>> On Sat, May 8, 2021 at 12:17 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
> >>>>>> On 5/7/2021 4:40 AM, Ondrej Mosnacek wrote:
> >>>>>>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
> >>>>>>> lockdown") added an implementation of the locked_down LSM hook to
> >>>>>>> SELinux, with the aim to restrict which domains are allowed to perform
> >>>>>>> operations that would breach lockdown.
> >>>>>>>
> >>>>>>> However, in several places the security_locked_down() hook is called in
> >>>>>>> situations where the current task isn't doing any action that would
> >>>>>>> directly breach lockdown, leading to SELinux checks that are basically
> >>>>>>> bogus.
> >>>>>>>
> >>>>>>> Since in most of these situations converting the callers such that
> >>>>>>> security_locked_down() is called in a context where the current task
> >>>>>>> would be meaningful for SELinux is impossible or very non-trivial (and
> >>>>>>> could lead to TOCTOU issues for the classic Lockdown LSM
> >>>>>>> implementation), fix this by adding a separate hook
> >>>>>>> security_locked_down_globally()
> >>>>>> This is a poor solution to the stated problem. Rather than adding
> >>>>>> a new hook you should add the task as a parameter to the existing hook
> >>>>>> and let the security modules do as they will based on its value.
> >>>>>> If the caller does not have an appropriate task it should pass NULL.
> >>>>>> The lockdown LSM can ignore the task value and SELinux can make its
> >>>>>> own decision based on the task value passed.
> >>>>> The problem with that approach is that all callers would then need to
> >>>>> be updated and I intended to keep the patch small as I'd like it to go
> >>>>> to stable kernels as well.
> >>>>>
> >>>>> But it does seem to be a better long-term solution - would it work for
> >>>>> you (and whichever maintainer would be taking the patch(es)) if I just
> >>>>> added another patch that refactors it to use the task parameter?
> >>>> I can't figure out what you're suggesting. Are you saying that you
> >>>> want to add a new hook *and* add the task parameter?
> >>> No, just to keep this patch as-is (and let it go to stable in this
> >>> form) and post another (non-stable) patch on top of it that undoes the
> >>> new hook and re-implements the fix using your suggestion. (Yeah, it'll
> >>> look weird, but I'm not sure how better to handle such situation - I'm
> >>> open to doing it whatever different way the maintainers prefer.)
> >> James gets to make the call on this one. If it was my call I would
> >> tell you to make the task parameter change and accept the backport
> >> pain. I think that as a security developer community we spend way too
> >> much time and effort trying to avoid being noticed in source trees.
> > Hm... actually, what about this attached patch? It switches to a
> > single hook with a cred argument (I figured cred makes more sense than
> > task_struct, since the rest of task_struct should be irrelevant for
> > the LSM, anyway...) right from the start and keeps the original
> > security_locked_down() function only as a simple wrapper around the
> > main hook.
> >
> > At that point I think converting the other callers to call
> > security_cred_locked_down() directly isn't really worth it, since the
> > resulting calls would just be more verbose without much benefit. So
> > I'm tempted to just leave the security_locked_down() helper as is, so
> > that the more common pattern can be still achieved with a simpler
> > call.
> >
> > What do you think?
>
> It's still a bit kludgy, but a big improvement over the previous version.
> I wouldn't object to this approach.

Ok, thanks. I'll post it as a v2 then.

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

