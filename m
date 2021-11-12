Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A504A44EB26
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 17:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhKLQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 11:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235346AbhKLQPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 11:15:49 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E80C061203
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:12:58 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id r12so39701257edt.6
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 08:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGSoAWw4aiO0zdfUnLq2WABzsbvQoZ/dvOMhI3656RM=;
        b=iVEcWpm0Uyw6XnEhFFjwjXTSr35KbKgaoqn0AWGRyWePuR6W5Wx/So+7SYXOBbO3Ka
         GMg2IROl6Ztzka1mCn2ZVoK3IlWx0NnhYAF4iuJ4432fJTE0KvWBx9286zWUVH6z2qZ8
         lswQuH49Gk1iaPPxXVaf+BOXIvNi3jYW6nETIku82yAjyaWxCmwgdq9okgkVkBeLIwDD
         l07EanJLBnHdeVrl39DxuawEoWEEusANTzRiZNvwy/4y6UbIba/FPGuubslbqPeArMBA
         +Mt2KHYhGTWvDl01MuGqLy+f9FxhaiyHZQNnDnVLoUi5gCv12xGCSSRBGpO01csX1lRq
         oiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGSoAWw4aiO0zdfUnLq2WABzsbvQoZ/dvOMhI3656RM=;
        b=bImPbOpbCOcz3b5CSeLOwcDnF+p1C1BgwkF1Em174LHIDXjmqTOyRgASno29fsJ7Xd
         0Mms8TQH895BpzgZJ8bkq9sA04K5eKpS8TOJKek4NNPFpBA90BHEWy0stHtrSZ/H15xc
         I34Jf9M4ofdUVevYLdkWlif9JZSShnvkLUbtD1U2sK1PcYZ9CGDYPtRLRjQI2DkVm/mq
         3npv0nwIY3kHYxoKziBU9P8r1geRf20DhLF3asNegnncVL5oS4y7qp0OZZTlyU5Bpu1Y
         ct3APKeUIWHBHyQKXUmE8FEOebSewZSszst8Ggx93IIKY4oJN+OLWURTLzGov5EsfTIJ
         V3xg==
X-Gm-Message-State: AOAM530pkx9OEnm23lFAJ+/apFMyuj1lW6XdQj4JwK2xW1TFY7qB9F/8
        3x8MVLYfs1g69p9zAYBW2sT9/3NuIpqbGXfC+AGU
X-Google-Smtp-Source: ABdhPJx9uhPCZh8h1P3+A+zyESKnFsyMjhz3cCRMgOke68oJAcH5hixVptfE1beXXUsTCSiYrAc3PyX1Z/yrUEz9DK4=
X-Received: by 2002:a17:906:7632:: with SMTP id c18mr20823358ejn.104.1636733577278;
 Fri, 12 Nov 2021 08:12:57 -0800 (PST)
MIME-Version: 1.0
References: <20211104195949.135374-1-omosnace@redhat.com> <20211109062140.2ed84f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHC9VhTVNOUHJp+NbqV5AgtwR6+3V6am0SKGKF0CegsPqjQ8pw@mail.gmail.com>
 <CAFqZXNuct_T-SkvoRg2n7+ye0--OkMJ_gS31V-t3Cm+Yy7FhxQ@mail.gmail.com>
 <CAHC9VhTmkQy1_1xFn9StgrwT2m8nyCwvHCMA+1sRdTW6xWR96A@mail.gmail.com> <CAFqZXNufe_7Nz6zayAGiJh-8xGw2cm=awhmVOp7hLLr5Ph72nQ@mail.gmail.com>
In-Reply-To: <CAFqZXNufe_7Nz6zayAGiJh-8xGw2cm=awhmVOp7hLLr5Ph72nQ@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 12 Nov 2021 11:12:45 -0500
Message-ID: <CAHC9VhTC8sF32sRYfiNn--uA6W9viPxwkx8uMYov8XWWcNGKqQ@mail.gmail.com>
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 4:53 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Thu, Nov 11, 2021 at 4:44 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Thu, Nov 11, 2021 at 7:59 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > On Tue, Nov 9, 2021 at 4:00 PM Paul Moore <paul@paul-moore.com> wrote:
> > > > On Tue, Nov 9, 2021 at 9:21 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > On Thu,  4 Nov 2021 20:59:49 +0100 Ondrej Mosnacek wrote:
> > > > > > As agreed with Xin Long, I'm posting this fix up instead of him. I am
> > > > > > now fairly convinced that this is the right way to deal with the
> > > > > > immediate problem of client peeloff socket labeling. I'll work on
> > > > > > addressing the side problem regarding selinux_socket_post_create()
> > > > > > being called on the peeloff sockets separately.
> > > > >
> > > > > IIUC Paul would like to see this part to come up in the same series.
> > > >
> > > > Just to reaffirm the IIUC part - yes, your understanding is correct.
> > >
> > > The more I'm reading these threads, the more I'm getting confused...
> > > Do you insist on resending the whole original series with
> > > modifications? Or actual revert patches + the new patches? Or is it
> > > enough to revert/resend only the patches that need changes? Do you
> > > also insist on the selinux_socket_post_create() thing to be fixed in
> > > the same series? Note that the original patches are still in the
> > > net.git tree and it doesn't seem like Dave will want to rebase them
> > > away, so it seems explicit reverting is the only way to "respin" the
> > > series...
> >
> > DaveM is stubbornly rejecting the revert requests so for now I would
> > continue to base any patches on top of the netdev tree.  If that
> > changes we can reconcile any changes as necessary, that should not be
> > a major issue.
> >
> > As far as what I would like to see from the patches, ignoring the
> > commit description vs cover letter discussion, I would like to see
> > patches that fix all of the known LSM/SELinux/SCTP problems as have
> > been discussed over the past couple of weeks.  Even beyond this
> > particular issue I generally disapprove of partial fixes to known
> > problems; I would rather see us sort out all of the issues in a single
> > patchset so that we can review everything in a sane manner.  In this
> > particular case things are a bit more complicated because of the
> > current state of the patches in the netdev tree, but as mentioned
> > above just treat the netdev tree as broken and base your patches on
> > that with all of the necessary "Fixes:" metadata and the like.
>
> Hm, okay, that isn't what I was branch-predicting from your other
> responses, but works for me.

If the past few years has shown us anything it is that branch
prediction is ... problematic :)

In an attempt to make my thinking a bit more clear, I see this as two
issues: the first, and most important, is ultimately getting the
SCTP/LSM/SELinux controls working properly, e.g. all the fixes you are
currently working on; the second issue is the current state of the
various kernel trees.  Regardless of what happens with the second
issue, I don't want it to detract from efforts on the first; making
sure we fix the bugs is paramount.

As you work on the patches to fix things, my suggestion is to take Xin
Long's patches and drop them on top of some known-good kernel and use
that as a base for your development.  Earlier when I was looking at
them I applied Xin Long's patches to the selinux/stable-5.16 branch
via the selinux-pr-20211101 tag and they applied cleanly, I suspect
you could do the same with the v5.15 tag from Linus tree.  Focus on
your patches, I'll help resolve any (re)base/merging issues they may
arise once you have things sorted out.

Unfortunately, I was greeted by an email notification this morning
that Xin Long's patches have made their way into Linus tree.  I
thought these patches were going to stay in -next for the v5.16-rcX
timeframe, I didn't realize the netdev folks were planning to submit
these for v5.16.  I wasn't happy with the patches in linux-next, I'm
definitely not happy with them in Linus tree; this is something we
will need to deal with, but to be clear, regardless of what happens in
Linus' tree please keep working on the fixes.

> > > Regardless of the answers, this thing has rabbithole'd too much and
> > > I'm already past my free cycles to dedicate to this, so I think it
> > > will take me (and Xin) some time to prepare the corrected and
> > > re-documented patches. Moreover, I think I realized how to to deal
> > > with the peer_secid-vs.-multiple-assocs-on-one-socket problem that Xin
> > > mentions in patch 4/4, fixing which can't really be split out into a
> > > separate patch and will need some test coverage, so I don't think I
> > > can rush this up at this point...
> >
> > It's not clear to me from your comments above if this is something you
> > are currently working on, planning to work on soon, or giving up on in
> > the near term.  Are we able to rely on you for a patchset to fix this
> > or are you unable to see this through at this time?
>
> I'm still working on it, but I'll need to juggle it with other things
> now and I might need to defer it completely at some point. I don't
> think I'll have all the patches ready sooner than two weeks from now.
> My point was to explain that I'm unable to provide a proper fix in the
> short term ...

Thanks for the clarification and your continued work on this.  If
something happens and you are not able to continue to make progress on
this please let me know so I can pick this up.  As you know, we need
to get this fixed.

> ... and don't want to block the netdev maintainers in case they
> were waiting for this to get resolved before e.g. sending a PR to
> Linus.

It's a bit of a moot point now (see above), but I *definitely* want to
block the patches that are in the netdev tree from hitting Linus tree.
I can see a middle ground that you described for keeping patches 1/4
and 2/4, but I see the remaining two patches as problematic and not
something we want in a released kernel from Linus.  If we had
guarantees that we could have this fixed before v5.16 is released I
might be inclined to let this slide, but considering your estimate of
a minimum of two weeks of additional development, the potential need
for further respins depending on review, the holiday season, etc. it
seems like we need to appeal to Linus to do at least a partial revert
for now.  I'll send some email on this to Linus and the relevant
mailing lists, but I need to do the revert and do some testing on it
to make sure it's sane.

-- 
paul moore
www.paul-moore.com
