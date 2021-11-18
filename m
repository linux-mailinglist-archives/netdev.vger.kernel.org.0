Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B902745603F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhKRQRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbhKRQRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 11:17:36 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF04C061574;
        Thu, 18 Nov 2021 08:14:35 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id g14so29393403edz.2;
        Thu, 18 Nov 2021 08:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vVkdhLYZ2yghvtsnBfZx6aX0rdaLftB2qrWz+Mjn2N4=;
        b=oxrMvtf7Ey8hzWQwNMB6/6bW7mFP3QERmTbgfftiUP3eHaqMIltdavOJTOQJI5/ehL
         KxMBRasz0uCx3+dwDLHkZ93Nck7q5W7fBdJUQGxu0f9IT9oev5+tHSL69heIj4pFMrZO
         S7mItovjhdXQJ+cBq2Fzgu1ekRgvgUSyaUnZCyLg+LgcqIrbmztmrPgBXGE0poua1s73
         uvGbX/ehxNJCjIwcG5q6tQ1V68V39LTRPtEWL2zdMj25Lugb/u3dTBaFqT/Ol0RG4Py5
         RsDsuKyrrnCXjWg0phgB2ixl/5FwhNRA7PPoXThSFmJ9+4if9pB/nR+cEoFEmokLGyWV
         x9tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vVkdhLYZ2yghvtsnBfZx6aX0rdaLftB2qrWz+Mjn2N4=;
        b=Ft2nB7GSkU10/Kcro0ZcaZcI5zKrCfj12kElZZAmWsi3qgH0qLCdofIF3JElWcP1qM
         fJ83bRakvGtD/J4jOZ75WRjXX6CfVSvEXPkMhXyE6j6RUWR8H+troZbc52e1CZOjpTr/
         NJZNxFsseazmcsLJTO4V/CEX5oyM9y8YxV6cz7p/1duzmIEcYmZ+VQz5rSob7TI8nSCR
         PCtySIWSyGdO4kwI6FjN4jfFuTVJL3iEsiHL1iZQFyxxA+2pHAW+GlD7bbML0v5Ge8Y+
         WuTREYFCN9tlF5lKm95x+QXXu+DRJ8o6TtSakZSqg/LNUKwBu6+IZJv+kqmOh7knZ3Tf
         Lgzg==
X-Gm-Message-State: AOAM532MwF2OFH5EYHU5kzpBC8+w0JEJh+yilsyr//D0WQLPzRcAeSAf
        DAR0OSx6I8Rsv0Ocx6RKnSIVNpKKPEmmFwnlTNE=
X-Google-Smtp-Source: ABdhPJygbDY2ytW54uSb3bg9nnG5ICbHH/9W96c67TGZ90zluvUpU01RLAswsPq7zXbBk1v4b2NIzRT4YKwHcXpRjhk=
X-Received: by 2002:aa7:c347:: with SMTP id j7mr13173830edr.272.1637252073533;
 Thu, 18 Nov 2021 08:14:33 -0800 (PST)
MIME-Version: 1.0
References: <DM6PR12MB45165BFF3AB84602238FA595D89B9@DM6PR12MB4516.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB45165BFF3AB84602238FA595D89B9@DM6PR12MB4516.namprd12.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 18 Nov 2021 08:14:22 -0800
Message-ID: <CAKgT0UfGvcGXAC5VBjXRpR5Y5uAPEPPCsYWjQR8RmW_1kw8TMQ@mail.gmail.com>
Subject: Re: [igb] netconsole triggers warning in netpoll_poll_dev
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 7:30 AM Danielle Ratson <danieller@nvidia.com> wrote:
>
> > On Thu, May 6, 2021 at 4:32 PM Jesse Brandeburg
> > <jesse.brandeburg@intel.com> wrote:
> > >
> > > Alexander Duyck wrote:
> > >
> > > > On Sun, Apr 25, 2021 at 11:47 PM Oleksandr Natalenko
> > > > <oleksandr@natalenko.name> wrote:
> > > > >
> > > > > Hello.
> > > > >
> > > > > On Fri, Apr 23, 2021 at 03:58:36PM -0700, Jakub Kicinski wrote:
> > > > > > On Fri, 23 Apr 2021 10:19:44 +0200 Oleksandr Natalenko wrote:
> > > > > > > On Wed, Apr 07, 2021 at 04:06:29PM -0700, Alexander Duyck wrote:
> > > > > > > > On Wed, Apr 7, 2021 at 11:07 AM Jakub Kicinski
> > <kuba@kernel.org> wrote:
> > > > > > > > > Sure, that's simplest. I wasn't sure something is supposed
> > > > > > > > > to prevent this condition or if it's okay to cover it up.
> > > > > > > >
> > > > > > > > I'm pretty sure it is okay to cover it up. In this case the
> > > > > > > > "budget - 1" is supposed to be the upper limit on what can
> > > > > > > > be reported. I think it was assuming an unsigned value anyway.
> > > > > > > >
> > > > > > > > Another alternative would be to default clean_complete to
> > !!budget.
> > > > > > > > Then if budget is 0 clean_complete would always return false.
> > > > > > >
> > > > > > > So, among all the variants, which one to try? Or there was a
> > > > > > > separate patch sent to address this?
> > > > > >
> > > > > > Alex's suggestion is probably best.
> > > > > >
> > > > > > I'm not aware of the fix being posted. Perhaps you could take
> > > > > > over and post the patch if Intel doesn't chime in?
> > > > >
> > > > > So, IIUC, Alex suggests this:
> > > > >
> > > > > ```
> > > > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > index a45cd2b416c8..7503d5bf168a 100644
> > > > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > > > @@ -7981,7 +7981,7 @@ static int igb_poll(struct napi_struct *napi, int
> > budget)
> > > > >                                                      struct igb_q_vector,
> > > > >                                                      napi);
> > > > >         bool clean_complete = true;
> > > > > -       int work_done = 0;
> > > > > +       unsigned int work_done = 0;
> > > > >
> > > > >  #ifdef CONFIG_IGB_DCA
> > > > >         if (q_vector->adapter->flags & IGB_FLAG_DCA_ENABLED) @@
> > > > > -8008,7 +8008,7 @@ static int igb_poll(struct napi_struct *napi, int
> > budget)
> > > > >         if (likely(napi_complete_done(napi, work_done)))
> > > > >                 igb_ring_irq_enable(q_vector);
> > > > >
> > > > > -       return min(work_done, budget - 1);
> > > > > +       return min_t(unsigned int, work_done, budget - 1);
> > > > >  }
> > > > >
> > > > >  /**
> > > > > ```
> > > > >
> > > > > Am I right?
> > > > >
> > > > > Thanks.
> > > >
> > > > Actually a better way to go would be to probably just initialize
> > > > "clean_complete = !!budget". With that we don't have it messing with
> > > > the interrupt enables which would probably be a better behavior.
> > >
> > >
> > > Thanks guys for the suggestions here! Finally got some time for this,
> > > so here is the patch I'm going to queue shortly.
> > >
> > > From ffd24e90d688ee347ab051266bfc7fca00324a68 Mon Sep 17 00:00:00
> > 2001
> > > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > > Date: Thu, 6 May 2021 14:41:11 -0700
> > > Subject: [PATCH net] igb: fix netpoll exit with traffic
> > > To: netdev,
> > >     Oleksandr Natalenko <oleksandr@natalenko.name>
> > > Cc: Jakub Kicinski <kuba@kernel.org>, LKML
> > > <linux-kernel@vger.kernel.org>, "Brandeburg, Jesse"
> > > <jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
> > > <anthony.l.nguyen@intel.com>, "David S. Miller"
> > <davem@davemloft.net>,
> > > intel-wired-lan <intel-wired-lan@lists.osuosl.org>, Alexander Duyck
> > > <alexander.duyck@gmail.com>
> > >
> > > Oleksandr brought a bug report where netpoll causes trace messages in
> > > the log on igb.
> > >
> > > [22038.710800] ------------[ cut here ]------------ [22038.710801]
> > > igb_poll+0x0/0x1440 [igb] exceeded budget in poll [22038.710802]
> > > WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155
> > > netpoll_poll_dev+0x18a/0x1a0
> > >
> > > After some discussion and debug from the list, it was deemed that the
> > > right thing to do is initialize the clean_complete variable to false
> > > when the "netpoll mode" of passing a zero budget is used.
> > >
> > > This logic should be sane and not risky because the only time budget
> > > should be zero on entry is netpoll.  Change includes a small refactor
> > > of local variable assignments to clean up the look.
> > >
> > > Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead
> > > and improve performance")
> > > Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> > > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > > ---
> > >
> > > Compile tested ONLY, but functionally it should be exactly the same
> > > for all cases except when budget is zero on entry, which will
> > > hopefully fix the bug.
> > > ---
> > >  drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > > b/drivers/net/ethernet/intel/igb/igb_main.c
> > > index 0cd37ad81b4e..b0a9bed14071 100644
> > > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > > @@ -7991,12 +7991,16 @@ static void igb_ring_irq_enable(struct
> > igb_q_vector *q_vector)
> > >   **/
> > >  static int igb_poll(struct napi_struct *napi, int budget)  {
> > > -       struct igb_q_vector *q_vector = container_of(napi,
> > > -                                                    struct igb_q_vector,
> > > -                                                    napi);
> > > -       bool clean_complete = true;
> > > +       struct igb_q_vector *q_vector;
> > > +       bool clean_complete;
> > >         int work_done = 0;
> > >
> > > +       /* if budget is zero, we have a special case for netconsole, so
> > > +        * make sure to set clean_complete to false in that case.
> > > +        */
> > > +       clean_complete = !!budget;
> > > +
> > > +       q_vector = container_of(napi, struct igb_q_vector, napi);
> > >  #ifdef CONFIG_IGB_DCA
> > >         if (q_vector->adapter->flags & IGB_FLAG_DCA_ENABLED)
> > >                 igb_update_dca(q_vector);
> >
> > I'm not a big fan of moving the q_vector init as a part of this patch since it
> > just means more backport work.
> >
> > That said the change itself should be harmless so I am good with it either
> > way.
> >
> > Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>
> Hi,
>
> I have lately added the netconsole module, and since then we see the same warning constantly in the logs.
> I have tried to apply Jesse's patch but it didn't seem to solve the issue.
>
> Did anyone managed to solve the issue and can share with us?
>
> Thanks,
> Danielle

The one issue I can see is that it basically leaves the igb_poll call
stuck in polling mode.

The easiest fix for all of this in the in-kernel driver is to just get
rid of the "min" at the end and instead just "return work_done;". The
extra complication is only needed if you were to be polling multiple
queues and that isn't the case here so we should simplify it and get
rid of the buggy "budget - 1" return value.
