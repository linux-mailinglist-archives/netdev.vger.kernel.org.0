Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F071751CC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 03:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCBCaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 21:30:55 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:40008 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgCBCaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 21:30:55 -0500
Received: by mail-vs1-f67.google.com with SMTP id c18so5560592vsq.7;
        Sun, 01 Mar 2020 18:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E5izDK+ngTpxKB1eZlc5Bj7076Z0jg6Dz5NVL5cyc4Q=;
        b=fd6faAnGV6OhSlJ5ayDDMImjvxfA5IoSETnMfdzNVu2vkMjOmv39gAgWgYGAqAK4BT
         9SA9Q8f8MBHxLF8aoXaNs4/Um40ycdponp+GL+31CmgpcnufX0BWYLdjMndwuRqieGd/
         aXWSaEkLLSCJVMXQ2V7A3YkQEreI0zQo22a4fAQX3iRJ2bH3q2w+ndS5iKH156DrtAHJ
         lN75iqIJQzjWQkffEuO2leCN1+ZlsAQICJYDrtBrPH6/sRttjrj0ewdPgtlKBdyM/Y5A
         Ar96uIIycaOawKIUZ4E/JRPe5CgCOXQDIjZzIkHDyC70/Cl76GpnsjCwm0VYMphL9lAB
         FQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E5izDK+ngTpxKB1eZlc5Bj7076Z0jg6Dz5NVL5cyc4Q=;
        b=K1Ik7YMJOVMTIsMBtRrJ9fWLobgg8XDV8ozFDrnobz4VlyHRyetJm+lGOxPErcd+qy
         keQifAH9+FOW9P6aOoIxUDIW+NrTdAwpYNFXSW++vyWkPy9Tvp0HXbgS3nDsgufaqYm2
         +RKRknR98gXt7ELmuTX1gFNXFff1yzbfvxpSprksQ9XfxfuU4G7CUWGpQap42hZOAkfj
         3inw+/c81vhYitKm04CGzuIF2/gYTZRTz5yGJfmGDjvAjS4D+cev34UbjwpDkgYJx6Fa
         goka89AfPKHG+VDqZivSFP310Ml/0vO6SZrtlcL5KdWrHcmZQ/YW0TvK3sezyVYjlXCp
         30tQ==
X-Gm-Message-State: ANhLgQ0lF4JleezDTOMK+bTW8Kt5pRRpfinalu+Yn6aRct7i0dWAOe75
        DKw+WjE9ASsWIG5KJJXJfaEPyD/VeO7700XnoqY=
X-Google-Smtp-Source: ADFU+vt12FaHT8Yae6lu5GUHnSThmSMUv+EVvSHdPQpR1BpZ+X2tFDWNyeyj251p0jfKZZf5Nxw6Y+77BolOXwD28HQ=
X-Received: by 2002:a05:6102:103:: with SMTP id z3mr8360212vsq.23.1583116253401;
 Sun, 01 Mar 2020 18:30:53 -0800 (PST)
MIME-Version: 1.0
References: <20200228044518.20314-1-gmayyyha@gmail.com> <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
 <CAB9OAC0dURDHgqGDVCg_Gd+EhH-9_n4-mycgsqfxS64GRgd4Og@mail.gmail.com> <CAOi1vP_opdc=OP70T2eiamMWa-o71nU8t_LYyTCytqT5BT8gdQ@mail.gmail.com>
In-Reply-To: <CAOi1vP_opdc=OP70T2eiamMWa-o71nU8t_LYyTCytqT5BT8gdQ@mail.gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Mon, 2 Mar 2020 10:30:42 +0800
Message-ID: <CAB9OAC08TGgXGFJsZCNpMzqnorn=jw1S_i8Ux2euaG=4-=JGwg@mail.gmail.com>
Subject: Re: [PATCH] ceph: using POOL FULL flag instead of OSDMAP FULL flag
To:     Ilya Dryomov <idryomov@gmail.com>
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

On Fri, Feb 28, 2020 at 10:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, Feb 28, 2020 at 12:41 PM Yanhu Cao <gmayyyha@gmail.com> wrote:
> >
> > On Fri, Feb 28, 2020 at 6:23 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Fri, Feb 28, 2020 at 5:45 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > > >
> > > > OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.
> > > >
> > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > ---
> > > >  fs/ceph/file.c                  |  6 ++++--
> > > >  include/linux/ceph/osd_client.h |  2 ++
> > > >  include/linux/ceph/osdmap.h     |  3 ++-
> > > >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> > > >  4 files changed, 21 insertions(+), 13 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 7e0190b1f821..60ea1eed1b84 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > >         }
> > > >
> > > >         /* FIXME: not complete since it doesn't account for being at quota */
> > > > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > > > +       if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > +                               CEPH_POOL_FLAG_FULL)) {
> > > >                 err = -ENOSPC;
> > > >                 goto out;
> > > >         }
> > > > @@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > >         }
> > > >
> > > >         if (written >= 0) {
> > > > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > > > +               if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > +                                       CEPH_POOL_FLAG_NEARFULL))
> > >
> > > Hi Yanhu,
> > >
> > > Have you considered pre-mimic clusters here?  They are still supported
> > > (and will continue to be supported for the foreseeable future).
> > >
> > > Thanks,
> > >
> > >                 Ilya
> >
> > I have tested it work on Luminous, I think it work too since
> > ceph-v0.80(https://github.com/ceph/ceph/blob/b78644e7dee100e48dfeca32c9270a6b210d3003/src/osd/osd_types.h#L815)
> > alread have pool FLAG_FULL.
>
> But not FLAG_NEARFULL, which appeared in mimic.
FLAG_NEARFULL appeared in Luminous.

>
> >
> > CephFS doesn't write synchronously even if CEPH_OSDMAP_NEARFULL is
> > used, then should fixed by CEPH_POOL_FLAG_NEARFULL.
>
> I'm not sure I follow.
>
> -    if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> +    if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> +                            CEPH_POOL_FLAG_NEARFULL))
>
> AFAICT this change would effectively disable this branch for pre-mimic
> clusters.  Are you saying this branch is already broken?
>
> Thanks,
>
>                 Ilya
CEPH_OSDMAP_NEARFULL is not set in Jewel, so it has no effect. And in
Luminous version, this flag is cleared as a legacy and has no effect
too.
