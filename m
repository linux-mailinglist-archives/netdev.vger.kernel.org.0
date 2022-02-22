Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D298C4BF93E
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiBVN27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiBVN26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:28:58 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEE9939E0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:28:32 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id w10-20020a4ae08a000000b0031bdf7a6d76so17429496oos.10
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fzMBwP75WQQgoD+zNIkqsOij+cNlqusgTrcCGxZOev8=;
        b=1Zped++JnCEHwnYfX2O6NeRvtPl1uSLkpHL/XdtZ2BtbYPwwJKLZTLbyJROHatwydz
         X8mW2vKD0i+rNC4HrUcTvcYsWWw6efa5jJoeQakp3pssD3FSctKo035W5jiN1G6qy4TM
         khdg5QrtZju4yBQ6bIbP+/WIg5KLXZQNrbGr4pqTtwezw9lo/eWBWlQFblWgkObZ5iTE
         bDe40ygooFQ63R4MdfpeTOXMbNg3vxFFCCfROjlOepX7FuOVVOxE6c+RlLEcqbJ3KfD2
         dJXdAgvdvPM6SASeFThANPgHEhovlCXfhK4Ajh1nebgYhhM/CFwAXem8WB9YK/43yZZT
         8qUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fzMBwP75WQQgoD+zNIkqsOij+cNlqusgTrcCGxZOev8=;
        b=Zbv4zKSELWn7F5Mr9YOE2b4dLm8tqYJHBIN6+nG8/mx7Bq0haU0G4GReLbir5cR7Tx
         Z7Aq0U4/8e729AI1a73sgQTOYLqLmPvXuF3tByqM4SbD/xnyOGBzHe+G7lJk1v43vGoM
         Rut8INgTzyEWgLxRMhiPkWK7CvqXLwmxiOMoo/Mf3ptQ+/01pd/mj9UgNniZRg2lRFjw
         /7e68KfS51hxq4PAJnUzZi3VvJoLeXEOdKmZs3Sti8jP/koBzhFLfCDV1YgO/DKS1EHM
         Fw+H1w5HMBI75c170LU1+WLnpqm/rtvZP9+q2IC1dDS9WGTb4E+zgXUA13JKod8mFF0F
         URLw==
X-Gm-Message-State: AOAM53398cxby+VvL+UiZH4EQ23mBpJaYoib9fBvLAHB9OXtcPo65XIX
        3TK8tgldV5x3J+0q0/6UN8dBAAESTrzXgNsf3EIgObUixvs=
X-Google-Smtp-Source: ABdhPJzpBI0jL+29WueaOH07hF9lKt7ALfVIVHQ0laYJag6jVfXaNSqDIdsneAL5jOnrzJurx1xvKLrTy82D8UIjqTA=
X-Received: by 2002:a05:6870:aa85:b0:d2:e462:7371 with SMTP id
 gr5-20020a056870aa8500b000d2e4627371mr1550136oab.29.1645536512289; Tue, 22
 Feb 2022 05:28:32 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <20220125084702.3636253-2-andrew@daynix.com>
 <06a90de0-57ae-9315-dc2c-03cc74b4ae0c@redhat.com>
In-Reply-To: <06a90de0-57ae-9315-dc2c-03cc74b4ae0c@redhat.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Tue, 22 Feb 2022 15:28:21 +0200
Message-ID: <CABcq3pH7HnH_-nCHcX7eet_ouqocQEptp6A9GCbs3=9guArhPA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/5] uapi/linux/if_tun.h: Added new ioctl for tun/tap.
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Wed, Feb 9, 2022 at 6:26 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/1/25 =E4=B8=8B=E5=8D=884:46, Andrew Melnychenko =E5=86=99=
=E9=81=93:
> > Added TUNGETSUPPORTEDOFFLOADS that should allow
> > to get bits of supported offloads.
>
>
> So we don't use dedicated ioctls in the past, instead, we just probing
> by checking the return value of TUNSETOFFLOADS.
>
> E.g qemu has the following codes:
>
> int tap_probe_has_ufo(int fd)
> {
>      unsigned offload;
>
>      offload =3D TUN_F_CSUM | TUN_F_UFO;
>
>      if (ioctl(fd, TUNSETOFFLOAD, offload) < 0)
>          return 0;
>
>      return 1;
> }
>
> Any reason we can't keep using that?
>
> Thanks
>

Well, even in this example. To check the ufo feature, we trying to set it.
What if we don't need to "enable" UFO and/or do not change its state?
I think it's a good idea to have the ability to get supported offloads
without changing device behavior.

>
> > Added 2 additional offlloads for USO(IPv4 & IPv6).
> > Separate offloads are required for Windows VM guests,
> > g.e. Windows may set USO rx only for IPv4.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >   include/uapi/linux/if_tun.h | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
> > index 454ae31b93c7..07680fae6e18 100644
> > --- a/include/uapi/linux/if_tun.h
> > +++ b/include/uapi/linux/if_tun.h
> > @@ -61,6 +61,7 @@
> >   #define TUNSETFILTEREBPF _IOR('T', 225, int)
> >   #define TUNSETCARRIER _IOW('T', 226, int)
> >   #define TUNGETDEVNETNS _IO('T', 227)
> > +#define TUNGETSUPPORTEDOFFLOADS _IOR('T', 228, unsigned int)
> >
> >   /* TUNSETIFF ifr flags */
> >   #define IFF_TUN             0x0001
> > @@ -88,6 +89,8 @@
> >   #define TUN_F_TSO6  0x04    /* I can handle TSO for IPv6 packets */
> >   #define TUN_F_TSO_ECN       0x08    /* I can handle TSO with ECN bits=
. */
> >   #define TUN_F_UFO   0x10    /* I can handle UFO packets */
> > +#define TUN_F_USO4   0x20    /* I can handle USO for IPv4 packets */
> > +#define TUN_F_USO6   0x40    /* I can handle USO for IPv6 packets */
> >
> >   /* Protocol info prepended to the packets (when IFF_NO_PI is not set)=
 */
> >   #define TUN_PKT_STRIP       0x0001
>
