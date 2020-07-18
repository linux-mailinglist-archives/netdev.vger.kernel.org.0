Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BBE224B39
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 14:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgGRMxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 08:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgGRMxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 08:53:40 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9B0C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:53:40 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t27so9542509ill.9
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N7Y4Xrvu7irkxDYBMHDrg2r2Y/fH3wSmFpuLVi7VWos=;
        b=P5SF+ERTVCp2hMFXLh0yVgE4tqKcjk40TavF3G1oehCrud7Wp1iJTpzwRnn9idrur/
         Zy4Pm0Xnzcr7x8ZXnesMnwX18V3Brvx6PHaUBEGjd3OIYfIwtFrPIe3pLuRsw1lh9yqB
         KIJjT3kQRdTGfQoE+jGSGWliMnuEbNdN0nJ8ycg8/Qxmy4iN70k3nRneaW1jlYyj3LH/
         +L2UyJ+25OIOd2Ok7l/y6XfVjtAGGB7Qg3kaArhqyn9TxSZUxjVN/+WoaO8RDIhKkLv3
         wlH5XB7neo2NWRrZg5Y+swFxSMKRLQFMzkjRcqpWay34q78qtpt7dzGzhXBnS/XXstgU
         w2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N7Y4Xrvu7irkxDYBMHDrg2r2Y/fH3wSmFpuLVi7VWos=;
        b=l5wYGipg5i48Z/BEWg+YKAD6XXII05yxgW09th01Z5Haph5mrM9DKtb3/c4Ud/EZUB
         t7ZsKbImsP1yzxlfl3k+WSqD3Xjpi+oqXtJP8Rd1ZPrRBJqPvks2mZLUhaneJx7IzRIL
         rtVJ3aaNb/8gMVlSBULIkxWDjaAAywlTVOmfjX92yqYb49N4q859WKmtgGF8f0xaZH7i
         Pp0CHyQIFFtzwxrlmZU/r2z8QiDyY+6adsiUnWFouybV0lyJ7g+oN9EC5LIlX7dm6wi0
         8iCjG4/iKrGMLW9QRwCAwjlx3bYVi8o7c+9cllkRoFO4SYBCcunI8OzfdO9ZOwOFKLnl
         V18g==
X-Gm-Message-State: AOAM532bGpeiFtUIHefwrdOGT9c6Ly1IqB1DiCJa+U26oQF+K7EvKgAF
        jZBmbYqFp7OMrMKbE2dLk3diBm3WHbusjAo+PMI=
X-Google-Smtp-Source: ABdhPJyjOjeFsGzWU9uZIcIYqGxD+66HWbUmfbe+6Sd1QQwdvPGLLt82dU1kMpq7Fv65kf9KNLmvMJFIzhdkTLGxr2Y=
X-Received: by 2002:a92:bb98:: with SMTP id x24mr14187821ilk.270.1595076819897;
 Sat, 18 Jul 2020 05:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <1594816689-5935-1-git-send-email-sbhatta@marvell.com>
 <1594816689-5935-4-git-send-email-sbhatta@marvell.com> <20200716171109.7d8c6d17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupxX5Cbvb03s-xxA7gobjwo8cM7n4_-U6oGysU3R18-Bw@mail.gmail.com> <20200717104812.1a92abcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200717104812.1a92abcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Sat, 18 Jul 2020 18:23:27 +0530
Message-ID: <CALHRZuqwAhfLhxUs4SUk8uPN=rpmstOcHewtPm35g6+ktk6F9A@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Jul 17, 2020 at 11:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 17 Jul 2020 10:41:49 +0530 sundeep subbaraya wrote:
> > On Fri, Jul 17, 2020 at 5:41 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 15 Jul 2020 18:08:09 +0530 Subbaraya Sundeep wrote:
> > > > @@ -1730,10 +1745,149 @@ static void otx2_reset_task(struct work_struct *work)
> > > >       if (!netif_running(pf->netdev))
> > > >               return;
> > > >
> > > > +     rtnl_lock();
> > > >       otx2_stop(pf->netdev);
> > > >       pf->reset_count++;
> > > >       otx2_open(pf->netdev);
> > > >       netif_trans_update(pf->netdev);
> > > > +     rtnl_unlock();
> > > > +}
> > >
> > > This looks unrelated, otherwise for the patches:
> >
> > You mean the lock/unlock logic with this patch?
>
> Looks very much like a bug independent of the PTP support.
>
> Also
> $ git grep reset_task drivers/net/ethernet/marvell/octeontx2/
> Doesn't reveal any place where you would flush or cancel that work.
>
> > I can separate this out and put in another patch #4 if you insist.
>
> Does someone need to insist for you to fix your bugs in the current
> release cycle? That's a basic part of the kernel release process :/

My confusion was whether it is okay to modify patches after
Acked-by because reviewers have to review again.
It is clear now.

Thanks,
Sundeep
