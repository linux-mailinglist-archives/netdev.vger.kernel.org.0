Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427C56D2708
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjCaRv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCaRvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:51:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E1622222
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 10:51:18 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u20so15304398pfk.12
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 10:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680285078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/ThWXQs65Je3Tnlyih1v1pg+hNsSPdvKYJylV5J3GI=;
        b=ASJHsLIatFi0F4uiLdmj/FQbthWDdzdY722AEcUWqG0vKKoZWZ29q1mdR8K3UOBL7k
         2hgn95mvi7SDVhFvrKF/OTfsrtWc3YMgVRB1imjqN1j/ShKSEDpnIJZGbTCAGOXCw67F
         hHrh1xEb65IB2Ruz68ZV2F6Yf9g2uYLCSBh4htohbmysrxFkNqEm3rlNF2fRfSu/N6vc
         LJoJ3cEGZ3Va/eHNhscfGaTfTXdQpGuY7dC0r9PmN9FETFzhNsCRLtkOUkRafWyf10vk
         oyckiS9If6t9i8EV0igpKIzd1ophIlIsMItdtCl63HakeLjgfWssSX++UB56u2jwMogS
         nJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680285078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/ThWXQs65Je3Tnlyih1v1pg+hNsSPdvKYJylV5J3GI=;
        b=T7bKbPxppq037ySZZgvZbuIcdZNxRUPQuAmf1m7lQhnAkVCbszl4k45Bw1M03HslAr
         P2pVDuMgl9aQ6nRJwxPcJo3ytoCXaeo/I4KFtffmgnFxeEYuqL+i/G7kVvHB6y2PFHi2
         FenNiL8rmtjvTzTD+zS9NRzLMMabDc9bgq0VIj1lJ9wQ1F+RB6uidasR5Ri90lzH9cCv
         /t7uSpXjGHOj8TNECOWVu+xj7EvChdWafKUEObwXhMYQ2U4fcPw6v39xz1piYxFoYynr
         Xy0Dmu6N6+qFsPcSjhdL9WaduW0sF79nsCffeEKFvGrn6k3knkxgaosN0YYISaFsjFIm
         SFpQ==
X-Gm-Message-State: AAQBX9elVK0D7lD1/TGm7rF1Qn27WzgUt5J0W89bOhfSkBcJdZV5+YrJ
        +fGECZmkKKhfgbiOMsMHIS3o9vf3okuAOI/GF7g=
X-Google-Smtp-Source: AKy350ZAVDgec1LE+4E355MjaJOfSnIfEzZ6q05kiDwq5wg0bvTy/h+4N86X/AovcmLJ1fl0Bw4gUwdYc1ZQ0BZT2I8=
X-Received: by 2002:a05:6a00:1781:b0:593:fcfb:208b with SMTP id
 s1-20020a056a00178100b00593fcfb208bmr14377873pfg.3.1680285077692; Fri, 31 Mar
 2023 10:51:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230331045619.40256-1-glipus@gmail.com> <20230330223519.36ce7d23@kernel.org>
In-Reply-To: <20230330223519.36ce7d23@kernel.org>
From:   Max Georgiev <glipus@gmail.com>
Date:   Fri, 31 Mar 2023 11:51:06 -0600
Message-ID: <CAP5jrPHzQN25gWmNCXYdCO0U7Fxx_wB0WdbKRNd8Owqp1Gftsg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] Add NDOs for hardware timestamp get/set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kory.maincent@bootlin.com, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub, thank you for taking a look!

On Thu, Mar 30, 2023 at 11:35=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Thu, 30 Mar 2023 22:56:19 -0600 Maxim Georgiev wrote:
> > @@ -1642,6 +1650,10 @@ struct net_device_ops {
> >       ktime_t                 (*ndo_get_tstamp)(struct net_device *dev,
> >                                                 const struct skb_shared=
_hwtstamps *hwtstamps,
> >                                                 bool cycles);
> > +     int                     (*ndo_hwtstamp_get)(struct net_device *de=
v,
> > +                                                 struct hwtstamp_confi=
g *config);
> > +     int                     (*ndo_hwtstamp_set)(struct net_device *de=
v,
> > +                                                 struct hwtstamp_confi=
g *config);
>
> I wonder if we should pass in
>
>         struct netlink_ext_ack *extack
>
> and maybe another structure for future extensions?
> So we don't have to change the drivers again when we extend uAPI.

Would these two extra parameters be ignored by drivers in this initial
version of NDO hw timestamp API implementation?

>
> >  };
> >
> >  struct xdp_metadata_ops {
> > diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> > index 5cdbfbf9a7dc..c90fac9a9b2e 100644
> > --- a/net/core/dev_ioctl.c
> > +++ b/net/core/dev_ioctl.c
> > @@ -277,6 +277,39 @@ static int dev_siocbond(struct net_device *dev,
> >       return -EOPNOTSUPP;
> >  }
> >
> > +static int dev_hwtstamp(struct net_device *dev, struct ifreq *ifr,
> > +                     unsigned int cmd)
> > +{
> > +     const struct net_device_ops *ops =3D dev->netdev_ops;
> > +     int err;
> > +     struct hwtstamp_config config;
>
> nit: reorder int err after config we like lines longest to shortest

Will do. Thank you for pointing it out!

>
> > +
> > +     if ((cmd =3D=3D SIOCGHWTSTAMP && !ops->ndo_hwtstamp_get) ||
> > +         (cmd =3D=3D SIOCSHWTSTAMP && !ops->ndo_hwtstamp_set))
> > +             return dev_eth_ioctl(dev, ifr, cmd);
> > +
> > +     err =3D dsa_ndo_eth_ioctl(dev, ifr, cmd);
> > +     if (err =3D=3D 0 || err !=3D -EOPNOTSUPP)
> > +             return err;
> > +
> > +     if (!netif_device_present(dev))
> > +             return -ENODEV;
> > +
> > +     if (cmd =3D=3D SIOCSHWTSTAMP) {
> > +             if (copy_from_user(&config, ifr->ifr_data, sizeof(config)=
))
> > +                     err =3D -EFAULT;
> > +             else
> > +                     err =3D ops->ndo_hwtstamp_set(dev, &config);
> > +     } else if (cmd =3D=3D SIOCGHWTSTAMP) {
> > +             err =3D ops->ndo_hwtstamp_get(dev, &config);
> > +     }
> > +
> > +     if (err =3D=3D 0)
> > +             err =3D copy_to_user(ifr->ifr_data, &config,
> > +                                sizeof(config)) ? -EFAULT : 0;
>
> nit: just error check each return value, don't try to save LoC

Will do!

>
> > +     return err;
> > +}
> > +
> >  static int dev_siocdevprivate(struct net_device *dev, struct ifreq *if=
r,
> >                             void __user *data, unsigned int cmd)
> >  {
> > @@ -391,11 +424,14 @@ static int dev_ifsioc(struct net *net, struct ifr=
eq *ifr, void __user *data,
> >               rtnl_lock();
> >               return err;
> >
> > +     case SIOCGHWTSTAMP:
> > +             return dev_hwtstamp(dev, ifr, cmd);
> > +
> >       case SIOCSHWTSTAMP:
> >               err =3D net_hwtstamp_validate(ifr);
> >               if (err)
> >                       return err;
> > -             fallthrough;
> > +             return dev_hwtstamp(dev, ifr, cmd);
>
> Let's refactor this differently, we need net_hwtstamp_validate()
> to run on the same in-kernel copy as we'll send down to the driver.
> If we copy_from_user() twice we may validate a different thing
> than the driver will end up seeing (ToCToU).

Got it, that would be a nice optimization for the NDO execution path!
We still will need a version of net_hwtstamp_validate(struct ifreq *ifr)
to do validation for drivers not implementing ndo_hwtstamp_set().
Also we'll need to implement validation for dsa_ndo_eth_ioctl() which
usually has an empty implementation, but can do something
meaningful depending on kernel configuration if I understand
it correctly. I'm not sure where to insert the validation code for
the DSA code path, would greatly appreciate some advice here.

>
> TBH I'm not sure if keeping GET and SET in a common dev_hwtstamp()
> ends up being beneficial. If we fold in the validation check half
> of the code will be under and if (GET) or if (SET)..

I was on a fence about splitting dev_hwtstamp() into GET and SET versions.
If you believe separate implementations will provide a cleaner implementati=
on
I'll be glad to split them.
