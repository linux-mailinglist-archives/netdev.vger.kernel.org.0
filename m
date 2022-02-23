Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2179F4C1433
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236064AbiBWNcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbiBWNcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:32:22 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F09ADB2
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:31:54 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id v28so17208485ljv.9
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 05:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7dnyHmrO36rrHyXARPRiGQlAPqAL/RPhHWzq7NmeXFU=;
        b=DCpZuBYw1K5GBm3Yf8oboPq/eMpixfVzGH8pD4UEALwU6Piq0DHgYQgOt/7CAvI306
         Dcz50R2TMDksWKMuLwdtBmupzNUlRGkvZEr3wrUGXHDsry2cMM5zBquEuUE/lGQio3cy
         dQioRFt9XmtopGgUlNHRhYJyo7M9qv/QhTJs7H/sBz6Y+d0QTU8BHf6TQuNWtwwlfHVy
         CsK3Xgbm2ngEooxg6hRKNJbBTvfjYRUDLlL01JPPYENYx80hxKuFn8POj2bETak/AHLu
         Za/hbi5Gqnd8nDCavCmWhSt5NPE4zh7m8WDnAJZpqs6lI7TkKUByTA7ZENXTV7ySlrYX
         jQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7dnyHmrO36rrHyXARPRiGQlAPqAL/RPhHWzq7NmeXFU=;
        b=Ekrk9Rhp2i3Uk7xlDWwK0QrBCxoAAND4UDUAeflAvDf18e2V0u6QaBSLNlSiWG+49h
         4mHoNUtCqq00vfeJACvZOQ2a6qWT2Lc2R3bppRlihyjyUE5YzrZE8acQh7ty9i2jFMhg
         Q4KT5JIRLH2CS5O2YB2cEuSbUBh3pwbFjWygectgR5ePA0wU80R09/Btx9gj6V+MOnQT
         1JdvQ+RJVIFqpdCenbeCcuimXLZ3+4IoJ4A+Xlvbdb0aHE3YiwRa3OgCUb9VozluAs0V
         D+KC9iR7e9eyvNKrSC+LewxBSIUg4v+dtJx+TrnNBQjI6CkRHmOj/b/x1jweLqhb6NX0
         KXOA==
X-Gm-Message-State: AOAM533Yz71+l+SU0ONnoFCsYgc5HtIPXbMXQjQFqdcJisyZsIIpzFmO
        aNpEVWYZzymEofu/N+OvmZt75SVih2XGO/oEWe8fcA==
X-Google-Smtp-Source: ABdhPJwJY+a32PVbCbOr6F7WLpIRa1HJ6cmeP7R7LTqqu3aAVT2hhZelkzr7J95bPvGGBDkYywmSkJE5OgieO0xkm/Q=
X-Received: by 2002:a05:651c:1509:b0:246:5f82:eed2 with SMTP id
 e9-20020a05651c150900b002465f82eed2mr1509589ljf.271.1645623113097; Wed, 23
 Feb 2022 05:31:53 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <20220125084702.3636253-2-andrew@daynix.com>
 <06a90de0-57ae-9315-dc2c-03cc74b4ae0c@redhat.com> <CABcq3pH7HnH_-nCHcX7eet_ouqocQEptp6A9GCbs3=9guArhPA@mail.gmail.com>
 <CACGkMEu3biQ+BM29nDu82jP8y+p4iiL4K=GzM6px+yktU5Zqjw@mail.gmail.com>
In-Reply-To: <CACGkMEu3biQ+BM29nDu82jP8y+p4iiL4K=GzM6px+yktU5Zqjw@mail.gmail.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Wed, 23 Feb 2022 15:31:41 +0200
Message-ID: <CAOEp5OeGNezTasp7zsvpFHGfjkM4bWRbbFY7WEWc7hRYVDSxdA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] uapi/linux/if_tun.h: Added new ioctl for tun/tap.
To:     Jason Wang <jasowang@redhat.com>
Cc:     Andrew Melnichenko <andrew@daynix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,
We agree that the same can be done also using the old way, i.e. try to
set specific offload - if failed, probably it is not supported.
We think this is a little not scalable and we suggest adding the ioctl
that will allow us to query allo the supported features in a single
call.
We think this will make QEMU code more simple also in future.
Do I understand correctly that you suggest to skip this new ioctl and
use the old way of query for this (USO) feature and all future
extensions?

Thanks


On Wed, Feb 23, 2022 at 5:53 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, Feb 22, 2022 at 9:28 PM Andrew Melnichenko <andrew@daynix.com> wr=
ote:
> >
> > Hi all,
> >
> > On Wed, Feb 9, 2022 at 6:26 AM Jason Wang <jasowang@redhat.com> wrote:
> > >
> > >
> > > =E5=9C=A8 2022/1/25 =E4=B8=8B=E5=8D=884:46, Andrew Melnychenko =E5=86=
=99=E9=81=93:
> > > > Added TUNGETSUPPORTEDOFFLOADS that should allow
> > > > to get bits of supported offloads.
> > >
> > >
> > > So we don't use dedicated ioctls in the past, instead, we just probin=
g
> > > by checking the return value of TUNSETOFFLOADS.
> > >
> > > E.g qemu has the following codes:
> > >
> > > int tap_probe_has_ufo(int fd)
> > > {
> > >      unsigned offload;
> > >
> > >      offload =3D TUN_F_CSUM | TUN_F_UFO;
> > >
> > >      if (ioctl(fd, TUNSETOFFLOAD, offload) < 0)
> > >          return 0;
> > >
> > >      return 1;
> > > }
> > >
> > > Any reason we can't keep using that?
> > >
> > > Thanks
> > >
> >
> > Well, even in this example. To check the ufo feature, we trying to set =
it.
> > What if we don't need to "enable" UFO and/or do not change its state?
>
> So at least Qemu doesn't have such a requirement since during the
> probe the virtual networking backend is not even started.
>
> > I think it's a good idea to have the ability to get supported offloads
> > without changing device behavior.
>
> Do you see a real user for this?
>
> Btw, we still need to probe this new ioctl anyway.
>
> Thanks
>
> >
> > >
> > > > Added 2 additional offlloads for USO(IPv4 & IPv6).
> > > > Separate offloads are required for Windows VM guests,
> > > > g.e. Windows may set USO rx only for IPv4.
> > > >
> > > > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > > > ---
> > > >   include/uapi/linux/if_tun.h | 3 +++
> > > >   1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tu=
n.h
> > > > index 454ae31b93c7..07680fae6e18 100644
> > > > --- a/include/uapi/linux/if_tun.h
> > > > +++ b/include/uapi/linux/if_tun.h
> > > > @@ -61,6 +61,7 @@
> > > >   #define TUNSETFILTEREBPF _IOR('T', 225, int)
> > > >   #define TUNSETCARRIER _IOW('T', 226, int)
> > > >   #define TUNGETDEVNETNS _IO('T', 227)
> > > > +#define TUNGETSUPPORTEDOFFLOADS _IOR('T', 228, unsigned int)
> > > >
> > > >   /* TUNSETIFF ifr flags */
> > > >   #define IFF_TUN             0x0001
> > > > @@ -88,6 +89,8 @@
> > > >   #define TUN_F_TSO6  0x04    /* I can handle TSO for IPv6 packets =
*/
> > > >   #define TUN_F_TSO_ECN       0x08    /* I can handle TSO with ECN =
bits. */
> > > >   #define TUN_F_UFO   0x10    /* I can handle UFO packets */
> > > > +#define TUN_F_USO4   0x20    /* I can handle USO for IPv4 packets =
*/
> > > > +#define TUN_F_USO6   0x40    /* I can handle USO for IPv6 packets =
*/
> > > >
> > > >   /* Protocol info prepended to the packets (when IFF_NO_PI is not =
set) */
> > > >   #define TUN_PKT_STRIP       0x0001
> > >
> >
>
