Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73468175902
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 12:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgCBLCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 06:02:13 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:33272 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgCBLCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 06:02:02 -0500
Received: by mail-vs1-f68.google.com with SMTP id n27so6244239vsa.0;
        Mon, 02 Mar 2020 03:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiLVVEgOv/yWSyzsAsZcqqgg4gpttODi3DYFtXqkAjo=;
        b=TbHipUDVJPCUkL6OWGrq/Bh6rNJKP7w0p0u8qw1QtLTcXZSJbZedeT+v1Eh/Nr5/7j
         pkQZbKK8xolJgGJ+AHhFFlrHiFZUhnPOFMp3A/ATvzJL2cEwIedZshnkmpUUTFDSWvGX
         xIvIwXk3InvGwTmVd/l9Z+He8Mgv491TfwAjTSBLkkYLdrhLW4xb8Wj9YDUmFSi1sVez
         7jkkmEK97WaLgJo6YYlpzeJi0s+qG+AliSWbjlrJe5in0ExMJzgMofs+hhDH3R5Hfby0
         8+6ik9NF5q6oAb3kvzNFg5C5WnljXV5GjntWQeKq3OtFJO5HHKmp9Lr7tX9W/32FxHYD
         VgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiLVVEgOv/yWSyzsAsZcqqgg4gpttODi3DYFtXqkAjo=;
        b=ilz6P5PwbhomxmXi7pGroWcKlqcuYssHluOiUxPz+jCsA+Y6m8aptlUAYmtwIiK9tt
         oSywu3pbv4Y7TG05JY+CePg/ri6dTAaBQX3o1HPx+4K4qFyw5MhyR+Qep/feNecr0QSE
         sXI8M1TmNzVPOa1LguD1AwLNL+OlUqzuIXqbw0XMnXf1gEvGHQXfBPjN2ZOP+psMbTSM
         zDcIm6zzRXtTSVcQQMxxUfgYFLz2lJh0eTVJBrqiMpv674kDoFkYu1oItgd7PQBocMwM
         PeH/U8FAsly3vuYRZv4rXpGMPw+MzTxs3OFKGpq3sdh+6ittzCXYSAok5pGLaP09xqvi
         Qz3Q==
X-Gm-Message-State: ANhLgQ21gR9a5aHMZAdMgvVMPY71OSCUfJVvQweIhverHX+WFWV5MEq2
        rp5sXChyUeWsR1I8qzQF7mMNzW/vqwi+HW9HIU8=
X-Google-Smtp-Source: ADFU+vvCJ/Yxg1+vYTAju/2SKizStBKsnGBpo7V/1Gc40TnRT4cOAdRgDQ+Z+JD4vfhF1T88/IWp4iFPtrmAETYTcZs=
X-Received: by 2002:a67:f253:: with SMTP id y19mr8674421vsm.158.1583146920851;
 Mon, 02 Mar 2020 03:02:00 -0800 (PST)
MIME-Version: 1.0
References: <20200228044518.20314-1-gmayyyha@gmail.com> <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
 <CAB9OAC0dURDHgqGDVCg_Gd+EhH-9_n4-mycgsqfxS64GRgd4Og@mail.gmail.com>
 <CAOi1vP_opdc=OP70T2eiamMWa-o71nU8t_LYyTCytqT5BT8gdQ@mail.gmail.com>
 <CAB9OAC08TGgXGFJsZCNpMzqnorn=jw1S_i8Ux2euaG=4-=JGwg@mail.gmail.com> <CAOi1vP-BKfaL-d2GMWDHf7tD=LpDLEug0-NY9dgT=qEi00gpLQ@mail.gmail.com>
In-Reply-To: <CAOi1vP-BKfaL-d2GMWDHf7tD=LpDLEug0-NY9dgT=qEi00gpLQ@mail.gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Mon, 2 Mar 2020 19:01:48 +0800
Message-ID: <CAB9OAC2YtvbmKAnPS83eCO+vZxwnMrBQP=9X2dTKywyM87PZvw@mail.gmail.com>
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

On Mon, Mar 2, 2020 at 6:09 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Mon, Mar 2, 2020 at 3:30 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> >
> > On Fri, Feb 28, 2020 at 10:02 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >
> > > On Fri, Feb 28, 2020 at 12:41 PM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > > >
> > > > On Fri, Feb 28, 2020 at 6:23 PM Ilya Dryomov <idryomov@gmail.com> wrote:
> > > > >
> > > > > On Fri, Feb 28, 2020 at 5:45 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> > > > > >
> > > > > > OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.
> > > > > >
> > > > > > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > > > > > ---
> > > > > >  fs/ceph/file.c                  |  6 ++++--
> > > > > >  include/linux/ceph/osd_client.h |  2 ++
> > > > > >  include/linux/ceph/osdmap.h     |  3 ++-
> > > > > >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> > > > > >  4 files changed, 21 insertions(+), 13 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > > > index 7e0190b1f821..60ea1eed1b84 100644
> > > > > > --- a/fs/ceph/file.c
> > > > > > +++ b/fs/ceph/file.c
> > > > > > @@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > > > >         }
> > > > > >
> > > > > >         /* FIXME: not complete since it doesn't account for being at quota */
> > > > > > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > > > > > +       if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > > > +                               CEPH_POOL_FLAG_FULL)) {
> > > > > >                 err = -ENOSPC;
> > > > > >                 goto out;
> > > > > >         }
> > > > > > @@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> > > > > >         }
> > > > > >
> > > > > >         if (written >= 0) {
> > > > > > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > > > > > +               if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > > > > +                                       CEPH_POOL_FLAG_NEARFULL))
> > > > >
> > > > > Hi Yanhu,
> > > > >
> > > > > Have you considered pre-mimic clusters here?  They are still supported
> > > > > (and will continue to be supported for the foreseeable future).
> > > > >
> > > > > Thanks,
> > > > >
> > > > >                 Ilya
> > > >
> > > > I have tested it work on Luminous, I think it work too since
> > > > ceph-v0.80(https://github.com/ceph/ceph/blob/b78644e7dee100e48dfeca32c9270a6b210d3003/src/osd/osd_types.h#L815)
> > > > alread have pool FLAG_FULL.
> > >
> > > But not FLAG_NEARFULL, which appeared in mimic.
> > FLAG_NEARFULL appeared in Luminous.
>
> Well, it appeared in mimic in v13.0.1 and was backported to luminous
> in v12.2.2.  So technically, some luminous releases don't have it.
>
> >
> > >
> > > >
> > > > CephFS doesn't write synchronously even if CEPH_OSDMAP_NEARFULL is
> > > > used, then should fixed by CEPH_POOL_FLAG_NEARFULL.
> > >
> > > I'm not sure I follow.
> > >
> > > -    if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > > +    if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > > +                            CEPH_POOL_FLAG_NEARFULL))
> > >
> > > AFAICT this change would effectively disable this branch for pre-mimic
> > > clusters.  Are you saying this branch is already broken?
> > >
> > > Thanks,
> > >
> > >                 Ilya
> > CEPH_OSDMAP_NEARFULL is not set in Jewel, so it has no effect. And in
> > Luminous version, this flag is cleared as a legacy and has no effect
> > too.
>
> Are you sure?  What about this code in OSDMonitor::tick() that showed
> up in kraken in v11.0.1 and was backported to jewel in v10.2.4?
>
>   if (!mon->pgmon()->pg_map.nearfull_osds.empty()) {
>     ...
>     add_flag(CEPH_OSDMAP_NEARFULL);
>   } else if (osdmap.test_flag(CEPH_OSDMAP_NEARFULL)){
>     ...
>     remove_flag(CEPH_OSDMAP_NEARFULL);
>   }
>   if (pending_inc.new_flags != -1 &&
>      (pending_inc.new_flags ^ osdmap.flags) & (CEPH_OSDMAP_FULL |
>                                                CEPH_OSDMAP_NEARFULL)) {
>     ...
>     do_propose = true;
>
> It's there in v10.2.11 (the final jewel release).  It's also there
> in hammer since v0.94.10...
>
> Thanks,
>
>                 Ilya

Sorry for not seeing all version changes, I will submit plus
CEPH_OSDMAP_FULL/NEARFULL.
How to check if the feature is backported?
