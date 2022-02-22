Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582204BF926
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiBVNWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiBVNWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:22:38 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99452E0AA
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:22:12 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id l25so8760893oic.13
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FbEG8VNWfAxsexRWaVP+3+Z7bPItdQUVdT+PMVmJerk=;
        b=2DUgPhrNuz1pS7heHL7qiS+n14t06NuqIh9c+513mbJEMnRr0OZ4lyybjX20n8UJEp
         a7Otk6bK+LBdmRFHp84bRyxoTSQcNmQh9Up3pSzs4Dw/BKXmxxBR65GZMecOuGndDUa6
         T1QnzTo9IIOycIaK2usIpIIE77OYOA0b2l9g0INDbWuDDhNBwK33DKdxV6U99cAZ7d1u
         8qaWgQZLxZ22uOAKdKlFq289oeahwbOmPITKaif7LWlbbBhfyO5+V2ZNJK5IZ/k3tyI7
         pex0KZ7fnoG/SNzr+RnxRr/+NjXqk6EA7DJlYfwduD2LGk3hHQ3hGU//k9w/ECUS77CA
         Prnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FbEG8VNWfAxsexRWaVP+3+Z7bPItdQUVdT+PMVmJerk=;
        b=67iJY0pReLQKHRJTi0x4kMPshnoKS/OxYvLCP/zLcX6vr81V+FNv4TVyoZ9UChUH6v
         WPv82n9XljotbW6p8YEgkocM5xRTTlu42nbWh7IUDeBTfLDH13mCVjkVXSOjkNmuuptv
         b4z0VCI/Kv6gCuDEPMMpv+QIXRMopnfmrscQNEjyjQE7MlMGwBLuAHpYeUVKIX2+1m+c
         rRQVvOGRx4DZ/JPCB5jghYbh6k/xVMVa/9S/b4oYfpq4/XAI43p6HEaNt0eE0hkLCV+G
         luMovNm4VwwPk5OE719M7AVX0PIeuci7Zue4Sb9rGiYaF1fy3/2DTYmmALwSN1ULJ3od
         /w+Q==
X-Gm-Message-State: AOAM532j2BpMfgb+b4LYJxxaR9FoR9pZ6nNczA6oMg2VpqoYs4dnwcQc
        cL4Ff3GEHNQyZySvCCdpMYDgBXIGPmhMj6DGRRL77g==
X-Google-Smtp-Source: ABdhPJyOrHlBwgGx5qZTXhnCehHekXCBaR6rENqCa6E8lAtJ/4gDv9e9nBODLwxy3eXzpO5VbNRSxYON80doqy+Yi68=
X-Received: by 2002:a05:6808:2128:b0:2d3:3ce1:6e12 with SMTP id
 r40-20020a056808212800b002d33ce16e12mr1891947oiw.279.1645536132034; Tue, 22
 Feb 2022 05:22:12 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <20220125084702.3636253-3-andrew@daynix.com>
 <5ac96035-2448-2a25-5bc9-677a7eb0a271@redhat.com>
In-Reply-To: <5ac96035-2448-2a25-5bc9-677a7eb0a271@redhat.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Tue, 22 Feb 2022 15:22:00 +0200
Message-ID: <CABcq3pH-md7oTLZYTGvnhi0uhYcZifdWn_D2bAZVafT5d+YZcg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/5] driver/net/tun: Added features for USO.
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
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 6:39 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/1/25 =E4=B8=8B=E5=8D=884:46, Andrew Melnychenko =E5=86=99=
=E9=81=93:
> > Added support for USO4 and USO6, also added code for new ioctl TUNGETSU=
PPORTEDOFFLOADS.
> > For now, to "enable" USO, it's required to set both USO4 and USO6 simul=
taneously.
> > USO enables NETIF_F_GSO_UDP_L4.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >   drivers/net/tap.c | 18 ++++++++++++++++--
> >   drivers/net/tun.c | 15 ++++++++++++++-
> >   2 files changed, 30 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> > index 8e3a28ba6b28..82d742ba78b1 100644
> > --- a/drivers/net/tap.c
> > +++ b/drivers/net/tap.c
> > @@ -940,6 +940,10 @@ static int set_offload(struct tap_queue *q, unsign=
ed long arg)
> >                       if (arg & TUN_F_TSO6)
> >                               feature_mask |=3D NETIF_F_TSO6;
> >               }
> > +
> > +             /* TODO: for now USO4 and USO6 should work simultaneously=
 */
> > +             if (arg & (TUN_F_USO4 | TUN_F_USO6) =3D=3D (TUN_F_USO4 | =
TUN_F_USO6))
> > +                     features |=3D NETIF_F_GSO_UDP_L4;
>
>
> If kernel doesn't want to split the GSO_UDP features, I wonder how much
> value to keep separated features for TUN and virtio.
>
> Thanks
>

It's important for Windows guests that may request USO receive only
for IPv4 or IPv6.
Or there is possible to implement one feature and change its
"meanings" when "split" happens.
I think it's a good idea to implement an interface for iUSO4/USO6 and
do it right away.

>
> >       }
> >
> >       /* tun/tap driver inverts the usage for TSO offloads, where
> > @@ -950,7 +954,8 @@ static int set_offload(struct tap_queue *q, unsigne=
d long arg)
> >        * When user space turns off TSO, we turn off GSO/LRO so that
> >        * user-space will not receive TSO frames.
> >        */
> > -     if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
> > +     if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6) ||
> > +         feature_mask & (TUN_F_USO4 | TUN_F_USO6) =3D=3D (TUN_F_USO4 |=
 TUN_F_USO6))
> >               features |=3D RX_OFFLOADS;
> >       else
> >               features &=3D ~RX_OFFLOADS;
> > @@ -979,6 +984,7 @@ static long tap_ioctl(struct file *file, unsigned i=
nt cmd,
> >       unsigned short u;
> >       int __user *sp =3D argp;
> >       struct sockaddr sa;
> > +     unsigned int supported_offloads;
> >       int s;
> >       int ret;
> >
> > @@ -1074,7 +1080,8 @@ static long tap_ioctl(struct file *file, unsigned=
 int cmd,
> >       case TUNSETOFFLOAD:
> >               /* let the user check for future flags */
> >               if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
> > -                         TUN_F_TSO_ECN | TUN_F_UFO))
> > +                         TUN_F_TSO_ECN | TUN_F_UFO |
> > +                         TUN_F_USO4 | TUN_F_USO6))
> >                       return -EINVAL;
> >
> >               rtnl_lock();
> > @@ -1082,6 +1089,13 @@ static long tap_ioctl(struct file *file, unsigne=
d int cmd,
> >               rtnl_unlock();
> >               return ret;
> >
> > +     case TUNGETSUPPORTEDOFFLOADS:
> > +             supported_offloads =3D TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TS=
O6 |
> > +                                             TUN_F_TSO_ECN | TUN_F_UFO=
 | TUN_F_USO4 | TUN_F_USO6;
> > +             if (copy_to_user(&arg, &supported_offloads, sizeof(suppor=
ted_offloads)))
> > +                     return -EFAULT;
> > +             return 0;
> > +
> >       case SIOCGIFHWADDR:
> >               rtnl_lock();
> >               tap =3D tap_get_tap_dev(q);
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index fed85447701a..4f2105d1e6f1 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -185,7 +185,7 @@ struct tun_struct {
> >       struct net_device       *dev;
> >       netdev_features_t       set_features;
> >   #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TS=
O| \
> > -                       NETIF_F_TSO6)
> > +                       NETIF_F_TSO6 | NETIF_F_GSO_UDP_L4)
> >
> >       int                     align;
> >       int                     vnet_hdr_sz;
> > @@ -2821,6 +2821,12 @@ static int set_offload(struct tun_struct *tun, u=
nsigned long arg)
> >               }
> >
> >               arg &=3D ~TUN_F_UFO;
> > +
> > +             /* TODO: for now USO4 and USO6 should work simultaneously=
 */
> > +             if (arg & TUN_F_USO4 && arg & TUN_F_USO6) {
> > +                     features |=3D NETIF_F_GSO_UDP_L4;
> > +                     arg &=3D ~(TUN_F_USO4 | TUN_F_USO6);
> > +             }
> >       }
> >
> >       /* This gives the user a way to test for new features in future b=
y
> > @@ -2991,6 +2997,7 @@ static long __tun_chr_ioctl(struct file *file, un=
signed int cmd,
> >       int sndbuf;
> >       int vnet_hdr_sz;
> >       int le;
> > +     unsigned int supported_offloads;
> >       int ret;
> >       bool do_notify =3D false;
> >
> > @@ -3154,6 +3161,12 @@ static long __tun_chr_ioctl(struct file *file, u=
nsigned int cmd,
> >       case TUNSETOFFLOAD:
> >               ret =3D set_offload(tun, arg);
> >               break;
> > +     case TUNGETSUPPORTEDOFFLOADS:
> > +             supported_offloads =3D TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TS=
O6 |
> > +                             TUN_F_TSO_ECN | TUN_F_UFO | TUN_F_USO4 | =
TUN_F_USO6;
> > +             if (copy_to_user(&arg, &supported_offloads, sizeof(suppor=
ted_offloads)))
> > +                     ret =3D -EFAULT;
> > +             break;
> >
> >       case TUNSETTXFILTER:
> >               /* Can be set only for TAPs */
>
