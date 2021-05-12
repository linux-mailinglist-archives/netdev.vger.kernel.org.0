Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C2337B571
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 07:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhELFZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 01:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhELFZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 01:25:53 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF56BC061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 22:24:45 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id k25so21260243oic.4
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 22:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZeJYl1+SkmdxkoBaspquNgXaarFia8TUxupmsd/+gVY=;
        b=vSKokEZ0qBlDZ8rMW/UFs7iLnVRflh5NB5KSfw8/+oz5/uYilhkmom4C8op6R/S4RM
         lwnZILjuXTKGDZo7DRUwEGneUq97o1WR49Z43p/oa9a++jbckLL0v4idWzPmq+V+75Bk
         jjPrdFqAEBzi7QnKjSbfSJZOu53czSSZTsBB7FE7a8aNfxS6ULsyQ00E2wrwewSR2Wke
         Lh5KFpd0Es3mwmYaHvNXWZMfjEOrHHNTrLTVxkqOjsTVRZ/SJbdegn2Xls6mYbF8otDJ
         yv+z35Ly+KybVA9UMM/B+RSk8IzUXoipGLkIH1T+MlZpH6gQAx+qYb8qQA29pk8bJzFZ
         rbQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZeJYl1+SkmdxkoBaspquNgXaarFia8TUxupmsd/+gVY=;
        b=NPhNEyX9IReZQTb2HPORGRERrYDKfK+wJgJhQ6aQaDYKMRf/7KaZLk0C1ndzW3Xp39
         yhDDgmpP55J78sqzEi6X/f4zPc8rhLt4H8zf1QRempHSe7Av7H7mFxcTR4O5/F7TwmMK
         LGfNqE4r2XLc7JictLN/jOfl3HohDia7BvMt2i6xwOBn5Muus1Chum63CmP4ndrvK1HZ
         m2RDocvRCW7AD15f7Ue5kOlzrpUJBDh9fb24TPblLvDVfY3D2KIe18ZX8/sSibip+QY8
         zzaMUvH5EOmvNmehRTF+5plw/O/nMHVlWCcrQhAtUbopwL6AJNHyvetL4ioUZjevI5IO
         ry4g==
X-Gm-Message-State: AOAM532Lx+Frr3VU35nL/hL8qos0F/6dZ9dlI7Xq/qTQHua3NAWXeacw
        rsB4bQF3sdRP+bL9jA0Mxl+5wKNbKGwXNWy6ttbL5g==
X-Google-Smtp-Source: ABdhPJw6BZ1VhOhVPS0LkL38VPvvrWeVNG5WgUiq59oyadcpfJGC5zw/TctLV44J44xfy5EW/DD6ucJaGG7+iMGciUA=
X-Received: by 2002:aca:ad06:: with SMTP id w6mr6316750oie.54.1620797085238;
 Tue, 11 May 2021 22:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com> <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
 <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com> <89759261-3a72-df6c-7a81-b7a48abfad44@redhat.com>
In-Reply-To: <89759261-3a72-df6c-7a81-b7a48abfad44@redhat.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Wed, 12 May 2021 08:24:33 +0300
Message-ID: <CAOEp5Ocm9Q69Fv=oeyCs01F9J4nCTPiOPpw9_BRZ0WnF+LtEFQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 4:33 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=884:33, Yuri Benditovich =E5=86=99=E9=
=81=93:
> > On Tue, May 11, 2021 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=
=99=E9=81=93:
> >>> Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> >>> ---
> >>>    drivers/net/tun.c | 2 +-
> >>>    1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>> index 84f832806313..a35054f9d941 100644
> >>> --- a/drivers/net/tun.c
> >>> +++ b/drivers/net/tun.c
> >>> @@ -2812,7 +2812,7 @@ static int set_offload(struct tun_struct *tun, =
unsigned long arg)
> >>>                        arg &=3D ~(TUN_F_TSO4|TUN_F_TSO6);
> >>>                }
> >>>
> >>> -             arg &=3D ~TUN_F_UFO;
> >>> +             arg &=3D ~(TUN_F_UFO|TUN_F_USO);
> >>
> >> It looks to me kernel doesn't use "USO", so TUN_F_UDP_GSO_L4 is a bett=
er
> >> name for this
> > No problem, I can change it in v2
> >
> >   and I guess we should toggle NETIF_F_UDP_GSO_l4 here?
> >
> > No, we do not, because this indicates only the fact that the guest can
> > send large UDP packets and have them splitted to UDP segments.
>
>
> Actually the reverse. The set_offload() controls the tuntap TX path
> (guest RX path).

The set_offloads does 2 things:
1. At the initialization time qemu probes set_offload(something) to
check which features are supported by TAP/TUN.
2. Later it configures the guest RX path according to guest's needs/capabil=
ities
Typical initialization sequence is (in case the QEMU supports USO feature):
TAP/TUN set offload 11 (probe for UFO support)
TAP/TUN set offload 21 (probe for USO support)
TAP/TUN set offload 0
...
TAP/TUN set offload 7 (configuration of offloads according to GUEST feature=
s)

This series of patches is for VIRTIO_NET_F_HOST_USO only, virtio-net
features like VIRTIO_NET_F_GUEST_USO_(4/6/whatever) are not defined in
the spec yet.

>
> When VIRTIO_NET_F_GUEST_XXX was not negotiated, the corresponding netdev
> features needs to be disabled. When host tries to send those packets to
> guest, it needs to do software segmentation.
>
> See virtio_net_apply_guest_offloads().
>
> There's currently no way (or not need) to prevent tuntap from receiving
> GSO packets.
>
> Thanks
>
>
> >
> >> And how about macvtap?
> > We will check how to do that for macvtap. We will send a separate
> > patch for macvtap or ask for advice.
> >
> >> Thanks
> >>
> >>
> >>>        }
> >>>
> >>>        /* This gives the user a way to test for new features in futur=
e by
>
