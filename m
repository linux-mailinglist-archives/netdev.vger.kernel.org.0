Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C608173645
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgB1Ll4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:41:56 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39011 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Ll4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:41:56 -0500
Received: by mail-ua1-f68.google.com with SMTP id c21so849651uam.6;
        Fri, 28 Feb 2020 03:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qgRBXu3UXujfUu/YLJD5NKUPvJ1HubicGzZMJLwxdxg=;
        b=IAEW3CVv+KdBq/tsDmXVgbaGMpkVLw+nS6/uh+feLTX2l/1du9WV8lusAvjmcEmOIV
         bNu2OCsnBP45jQuDGoCKbt9l5pmQE8rHCL3QyU0kWtTKlSWNdfw8NzPLglFuHqGjA4of
         eWRId6NmuKmUVV4FBVpvpsKuH2jKQMyqVoYkZ792Gn63fWXY7177B2UB469VAukJ3/Yn
         zGHrRZBilpo6WHVZtm465Eth9XVfMRS/9d7NjqyIVBoKtXA9qvyAKaWaYw7isPvoHRNW
         jzU1nMB430hd4068R/xsTj59X4e47eyMJOsC3Vf51CwwRs+P8z7eqRL4NawHSJPXYN8Z
         yigg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qgRBXu3UXujfUu/YLJD5NKUPvJ1HubicGzZMJLwxdxg=;
        b=CidnHKZXUjNIDdsJbKGsHViptlw2bO+921uqoo5JgE66zGNVPsveB3qRyROUH36O07
         rjS+Qg4mD78O1dDIJ2m/rD9ricykbUlIRlethFE99VzKZea7/C0lm6o6dhwE7W8Bsb8f
         ys0yKNVNgdRCWTdjroJyDzRYLoPTi2KZg2G9x9yRAoGOEYBthgOXtD8j+EHHWRs2aSX6
         /p5yc1R/2Wx6I+pEMYtdg4rwTgdTMMkHpv7kHiFB2DWMH5p32rvjHFiRQam3qvIdAVsa
         vQ2l5x4tPE+q/h2Jajl84PciNimbQTBNCKdsPmbsm6A4NXIMUDMlYVDDF2mYwBJ8YR9g
         1G9A==
X-Gm-Message-State: ANhLgQ2iXziaWLLLYnNCHOBbG75iZBgFvQJtAMXNwMCzUVAvK99IDRxe
        +UltbXMauKF8Q6Ur/AU+wa2jLZVN0r4urAY7qeDlzdOtsw4=
X-Google-Smtp-Source: ADFU+vviIyKdulGmcFSh6KBXyhcte0zMAWs0zR8cPkGD3oMYMNar1XHGJ2FhVykv3IvpNgamMnEP8S9KxVjPWCkDT7I=
X-Received: by 2002:a9f:3b02:: with SMTP id i2mr1670019uah.33.1582890115091;
 Fri, 28 Feb 2020 03:41:55 -0800 (PST)
MIME-Version: 1.0
References: <20200228044518.20314-1-gmayyyha@gmail.com> <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
In-Reply-To: <CAOi1vP-K+e0N26qpthLcst8HLE-FAMGSE9XwBhj1dPBiLyN-iA@mail.gmail.com>
From:   Yanhu Cao <gmayyyha@gmail.com>
Date:   Fri, 28 Feb 2020 19:41:44 +0800
Message-ID: <CAB9OAC0dURDHgqGDVCg_Gd+EhH-9_n4-mycgsqfxS64GRgd4Og@mail.gmail.com>
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

On Fri, Feb 28, 2020 at 6:23 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, Feb 28, 2020 at 5:45 AM Yanhu Cao <gmayyyha@gmail.com> wrote:
> >
> > OSDMAP_FULL and OSDMAP_NEARFULL are deprecated since mimic.
> >
> > Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
> > ---
> >  fs/ceph/file.c                  |  6 ++++--
> >  include/linux/ceph/osd_client.h |  2 ++
> >  include/linux/ceph/osdmap.h     |  3 ++-
> >  net/ceph/osd_client.c           | 23 +++++++++++++----------
> >  4 files changed, 21 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 7e0190b1f821..60ea1eed1b84 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1482,7 +1482,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         }
> >
> >         /* FIXME: not complete since it doesn't account for being at quota */
> > -       if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_FULL)) {
> > +       if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > +                               CEPH_POOL_FLAG_FULL)) {
> >                 err = -ENOSPC;
> >                 goto out;
> >         }
> > @@ -1575,7 +1576,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >         }
> >
> >         if (written >= 0) {
> > -               if (ceph_osdmap_flag(&fsc->client->osdc, CEPH_OSDMAP_NEARFULL))
> > +               if (pool_flag(&fsc->client->osdc, ci->i_layout.pool_id,
> > +                                       CEPH_POOL_FLAG_NEARFULL))
>
> Hi Yanhu,
>
> Have you considered pre-mimic clusters here?  They are still supported
> (and will continue to be supported for the foreseeable future).
>
> Thanks,
>
>                 Ilya

I have tested it work on Luminous, I think it work too since
ceph-v0.80(https://github.com/ceph/ceph/blob/b78644e7dee100e48dfeca32c9270a6b210d3003/src/osd/osd_types.h#L815)
alread have pool FLAG_FULL.

CephFS doesn't write synchronously even if CEPH_OSDMAP_NEARFULL is
used, then should fixed by CEPH_POOL_FLAG_NEARFULL.
