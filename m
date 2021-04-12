Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE14735B9ED
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 07:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhDLFs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 01:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbhDLFs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 01:48:56 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F0DC061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 22:48:38 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id z1so13762224ybf.6
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 22:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JRnzerCgoE748LrLlvuvy1JwT/kDMrrNlvl2hRtSOPE=;
        b=DSWk6GGHxuC0MWzAF+kcyHo7w1OdTbgABYuqvwAHlxhWdrn90ef1Lj2cKjOLicoJ1j
         bstmOleAXuhKWuQ5I45+Z14HKzGGJJfoyV5D93LPdrwYMEooQ1SFpdVkl0uyKxJrV9El
         u6DTg9Vn14ozmP3OzPN40k+shm9BVCJj5eyl7yNUtUKaUC+HsbuxtSj4AArtaVDOocio
         oWxor6wWQpojxWCdl9xHkscXJaa7ZvaICp7YefyxccPifFDuoW60hf82YGce0RixMWkF
         zD7Zs1xv42Zj3bZ7Zo1MLNg5f3QfAhX3a55uO2toKPctfaovSe1Zljvw3Fzb3Gg3b7UG
         aZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JRnzerCgoE748LrLlvuvy1JwT/kDMrrNlvl2hRtSOPE=;
        b=kHxO4mVXrgyck05tKGwxIfrlz6B7lkrgCP8PEzmBOH78E9+He+YEHIFta7nQ91kVte
         RSpc64uQbBRGMnXjTSq5Dq7+l2ajoMvA+vtWn9UDd4JQT4UM++VMR2oQY+plKBnTN9pf
         UEH9BSwc8coOYLfSOLUx07PKtifKFtmjpMGmdZgE6B5nnOpPAiy29uuiCdP8WqOMae9Q
         VsGeRY/zGxSqzpAvL5Npi5/EnM3jMliEy/4ckdArUf5Bq/I1nd/mIOiy3SMfoEgD38BN
         x+8aTeWbd/QflIdXeQhufkeia7ZxlOjw2kNzKuumHgdoNq5GkqQfVg2/ErnutcVg0hO6
         5sKA==
X-Gm-Message-State: AOAM531C+wVNj6mHAg+BLzpJUCQw8AedcfJ08jMsFq22riXgUucprfsU
        Ons4KUSyNB6exi7TGKh8bSRIYLLeVzn0UKRoMXg4lA==
X-Google-Smtp-Source: ABdhPJz5xe2rl6JL7GaXTd/ZgXdUpvHcVIe4qrPkjGqACtcov/6rsfmn1sG3+JofM5IjPodRf6yjVCQWzgFdpUkCvUc=
X-Received: by 2002:a25:e89:: with SMTP id 131mr12783868ybo.132.1618206517457;
 Sun, 11 Apr 2021 22:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
 <20210411134329.GA132317@roeck-us.net> <CANn89iJ+RjYPY11zUtvmMkOp1E2DKLuAk2q0LHUbcJpbcZVSjw@mail.gmail.com>
 <0f63dc52-ea72-16b6-7dcd-efb24de0c852@roeck-us.net> <CANn89iJa8KAnfWvUB8Jr8hsG5x_Amg90DbpoAHiuNZigv75MEA@mail.gmail.com>
 <c1d15bd0-8b62-f7c0-0f2e-1d527827f451@roeck-us.net> <CANn89iK-AO4MpWQzh_VkMjUgdcsP4ibaV4RhsDF9RHcuC+_=-g@mail.gmail.com>
 <ad232021-d30a-da25-c1d5-0bd79628b5e1@roeck-us.net>
In-Reply-To: <ad232021-d30a-da25-c1d5-0bd79628b5e1@roeck-us.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 12 Apr 2021 07:48:25 +0200
Message-ID: <CANn89iLZyvjE-wUxfJ1FtAqZdD3OroObBdR9-bXR=GGb1ZASOw@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 12:07 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 4/11/21 2:43 PM, Eric Dumazet wrote:
> > On Sun, Apr 11, 2021 at 11:32 PM Guenter Roeck <linux@roeck-us.net> wro=
te:
> >>
> >> On 4/11/21 2:23 PM, Eric Dumazet wrote:
> >>> On Sun, Apr 11, 2021 at 10:37 PM Guenter Roeck <linux@roeck-us.net> w=
rote:
> >>>>
> >>>> On 4/11/21 8:06 AM, Eric Dumazet wrote:
> >>>>> On Sun, Apr 11, 2021 at 3:43 PM Guenter Roeck <linux@roeck-us.net> =
wrote:
> >>>>>
> >>>>>> This patch causes a virtio-net interface failure when booting sh4 =
images
> >>>>>> in qemu. The test case is nothing special: Just try to get an IP a=
ddress
> >>>>>> using udhcpc. If it fails, udhcpc reports:
> >>>>>>
> >>>>>> udhcpc: started, v1.33.0
> >>>>>> udhcpc: sending discover
> >>>>>> FAIL
> >>>>>>
> >>>>>
> >>>>> Can you investigate where the incoming packet is dropped ?
> >>>>>
> >>>>
> >>>> Unless I am missing something, packets are not dropped. It looks mor=
e
> >>>> like udhcpc gets bad indigestion in the receive path and exits immed=
iately.
> >>>> Plus, it doesn't happen all the time; sometimes it receives the disc=
over
> >>>> response and is able to obtain an IP address.
> >>>>
> >>>> Overall this is quite puzzling since udhcpc exits immediately when t=
he problem
> >>>> is seen, no matter which option I give it on the command line; it sh=
ould not
> >>>> really do that.
> >>>
> >>>
> >>> Could you strace both cases and report differences you can spot ?
> >>>
> >>> strace -o STRACE -f -s 1000 udhcpc
> >>>
> >>
> >> I'll give it a try. It will take a while; I'll need to add strace to m=
y root
> >> file systems first.
> >>
> >> As a quick hack, I added some debugging into the kernel; it looks like
> >> the data part of the dhcp discover response may get lost with your pat=
ch
> >> in place.
> >
> > Data is not lost, the payload is whole contained in skb frags, which
> > was expected from my patch.
> >
> > Maybe this sh arch does something wrong in this case.
> >
> > This could be checksuming...
> >
> > Please check
> >
> > nstat -n
> > <run udhcpc>
> > nstat
> >
>
> Another tool to install.
>
> While that builds, output from strace:
>
> # strace -o /tmp/STRACE  -f -s 1000 udhcpc -n -q
> udhcpc: started, v1.33.0
> udhcpc: sending discover
> udhcpc: received SIGTERM
>
> and:
>
> ...
> 136   socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP)) =3D 5
> 136   bind(5, {sa_family=3DAF_PACKET, sll_protocol=3Dhtons(ETH_P_IP), sll=
_ifindex=3Dif_nametoindex("eth0"), sll_hatype=3DARPHRD_NETROM, sll_pkttype=
=3DPACKET_HOST, sll_halen=3D0}, 20) =3D 0
> 136   setsockopt(5, SOL_PACKET, PACKET_AUXDATA, [1], 4) =3D 0
> 136   fcntl64(5, F_SETFD, FD_CLOEXEC)   =3D 0
> 136   socket(AF_INET, SOCK_RAW, IPPROTO_RAW) =3D 6
> 136   ioctl(6, SIOCGIFINDEX, {ifr_name=3D"eth0", }) =3D 0
> 136   ioctl(6, SIOCGIFHWADDR, {ifr_name=3D"eth0", ifr_hwaddr=3D{sa_family=
=3DARPHRD_ETHER, sa_data=3D52:54:00:12:34:56}}) =3D 0
> 136   close(6)                          =3D 0
> 136   clock_gettime64(CLOCK_MONOTONIC, {tv_sec=3D161, tv_nsec=3D2180242})=
 =3D 0
> 136   write(2, "udhcpc: sending discover\n", 25) =3D 25
> 136   socket(AF_PACKET, SOCK_DGRAM, htons(ETH_P_IP)) =3D 6
> 136   bind(6, {sa_family=3DAF_PACKET, sll_protocol=3Dhtons(ETH_P_IP), sll=
_ifindex=3Dif_nametoindex("eth0"), sll_hatype=3DARPHRD_NETROM, sll_pkttype=
=3DPACKET_HOST, sll_halen=3D6, sll_addr=3D[0xff, 0xff, 0xff, 0xff, 0xff, 0x=
ff]}, 20) =3D 0
> 136   sendto(6, "E\0\1H\0\0\0\0@\21y\246\0\0\0\0\377\377\377\377\0D\0C\00=
14\200\256\1\1\6\0\257\321\212P\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0RT\0=
\0224V\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0c\202Sc5\1\1=3D\7\1RT\0\0224V9\2\2@7\7\1=
\3\6\f\17\34*<\fudhcp 1.33.0\377\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", =
328, 0, {sa_family=3DAF_PACKET, sll_protocol=3Dhtons(ETH_P_IP), sll_ifindex=
=3Dif_nametoindex("eth0"), sll_hatype=3DARPHRD_NETROM, sll_pkttype=3DPACKET=
_HOST, sll_halen=3D6, sll_addr=3D[0xff, 0xff, 0xff, 0xff, 0xff, 0xff]}, 20

This does not make sense really. You cut the thing so it is hard to
give a verdict.

Please post the whole strace output.

Thanks.

>
> Guenter
