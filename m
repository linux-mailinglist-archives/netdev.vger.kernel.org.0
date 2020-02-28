Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1563E173961
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 15:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgB1OCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 09:02:04 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:46457 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgB1OCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 09:02:04 -0500
Received: by mail-il1-f194.google.com with SMTP id t17so2735507ilm.13;
        Fri, 28 Feb 2020 06:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pWC6hUGSYTvKGmvspilEVbUqriHozG3huRtnRptYN7k=;
        b=CL9iaiJX4jVWm0t6py+rKHh6pdcu5gyKwJRrMtGHpgMZi145sJNBYXihHNDyac/03g
         e1z6KcUyjk9Z8d3GKt2Gjyy9MWP/SUXcRsqxZjK92/Mmur3u11EOQIACt8dCqe8wQF07
         mhvTm9Txebr5p4rSvd4A1JInMNFuU8cdTcvt24bWYxRs1Cgw2a40s6WHz9sOwUTAfk4S
         LgcNqXkeS2OONibFl5eN+k44de5K15NMenTt+L2efou1krG2rVi8xCEKIa1CzALKr3NH
         YmkR/U4ssm1MxThEza9F+zfv/wh9UW/1nUKf4QNEbkkVUY9nRjn9mdeSUcwmearxAyeO
         dqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pWC6hUGSYTvKGmvspilEVbUqriHozG3huRtnRptYN7k=;
        b=oG5bx8T6W9OQwHn9AYGUYj4oXQFoKlDfmtZ15eRJXSgDSCl9rHZgRIVPDMViihKU/P
         WlnB5cXubHbGiiiSBq91pu3qkPRTIrzBmSt5gmvFjb/809d1FywYbxaQSPcEMkhywQ80
         dOCvpB9HvQIzKZqkfv/iBJs6O3dAeUXvYxsLBAziSZuH0wWgdnn7R1KZ1lu3sHqaUFIo
         gYtp1mDV8Mb+GlVpkctu7ooNm0z5CA2p1X/6J8VplpP/xL4NHrdUYEZEivnxZtRMzSdf
         PkLbqw3O6PZ2a0zunffjaM8ifOWBS6s3mXzcpHOaAFLJUpnTSEjonmCEVDnaQ024lEc1
         UgZg==
X-Gm-Message-State: APjAAAU9uF/P19KsE5S57E7KBk55l2HE/NLc316Xz1uIqskbqXXN9Ynv
        DJ8OwSq/GxKWBEvJnARx8Mgx2l3zm9kNj3/9MkqtohyB+mw=
X-Google-Smtp-Source: APXvYqzpizMXzoB3+5TWvVXyeS0Arlh5AwX7bFUMwjwM78tpaENzJ68sgFyqQcY1mE799R1L7Cnw1e0fq1moKsAd8zU=
X-Received: by 2002:a92:3991:: with SMTP id h17mr4670801ilf.131.1582898523278;
 Fri, 28 Feb 2020 06:02:03 -0800 (PST)
MIME-Version: 1.0
References: <20200228044518.20314-1-gmayyyha@gmail.com> <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
 <CAB9OAC0dURDHgqGDVCg_Gd+EhH-9_n4-mycgsqfxS64GRgd4Og@mail.gmail.com>
In-Reply-To: <CAB9OAC0dURDHgqGDVCg_Gd+EhH-9_n4-mycgsqfxS64GRgd4Og@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 28 Feb 2020 15:01:56 +0100
Message-ID: <CAOi1vP_opdc=OP70T2eiamMWa-o71nU8t_LYyTCytqT5BT8gdQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Yanhu Cao <gmayyyha@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 12:41 PM Yanhu Cao <gmayyyha@gmail.com> wrote:
>
> On Fri, Feb 28, 2020 at 6:23 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> >
> > On Fri, Feb 28, 2020 at 5:45 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > >
> > > OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.
> > >
> > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > ---
> > >  fs/ceph/file.c                  |  6 ++++--
> > >  include/linux/ceph/osd_client.h |  2 ++
> > >  include/linux/ceph/osdmap.h     |  3 ++-
> > >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> > >  4 files changed, 21 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > index 7e0190b1f821..60ea1eed1b84 100644
> > > --- a/fs/ceph/file.c
> > > +++ b/fs/ceph/file.c
> > > @@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > >         }
> > >
> > >         /* FIXME: not complete since it doesn't account for being at quota */
> > > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > > +       if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > +                               CEPH_POOL_FLAG_FULL)) {
> > >                 err = -ENOSPC;
> > >                 goto out;
> > >         }
> > > @@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > >         }
> > >
> > >         if (written >= 0) {
> > > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > > +               if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > +                                       CEPH_POOL_FLAG_NEARFULL))
> >
> > Hi Yanhu,
> >
> > Have you considered pre-mimic clusters here?  They are still supported
> > (and will continue to be supported for the foreseeable future).
> >
> > Thanks,
> >
> >                 Ilya
>
> I have tested it work on Luminous, I think it work too since
> ceph-v0.80(https://github.com/ceph/ceph/blob/b78644e7dee100e48dfeca32c9270a6b210d3003/src/osd/osd_types.h#L815)
> alread have pool FLAG_FULL.

But not FLAG_NEARFULL, which appeared in mimic.

>
> CephFS doesn't write synchronously even if CEPH_OSDMAP_NEARFULL is
> used, then should fixed by CEPH_POOL_FLAG_NEARFULL.

I'm not sure I follow.

-    if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
+    if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
+                            CEPH_POOL_FLAG_NEARFULL))

AFAICT this change would effectively disable this branch for pre-mimic
clusters.  Are you saying this branch is already broken?

Thanks,

                Ilya
