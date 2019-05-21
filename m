Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5284124D9E
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 13:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfEULIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 07:08:47 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:32852 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727743AbfEULIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 07:08:47 -0400
Received: by mail-ot1-f41.google.com with SMTP id 66so15978234otq.0
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 04:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FseZCCgNVHS8/IVjLlkAO/IZV6IaTuWANWfE9OA02ag=;
        b=bK1jbSFU4ONhnbbD1OwNcpyO3dPDzyVIBFZvB/5u1rFyho0FEySnSExF8VlyAnalEv
         d0zDW4YDzQUsrCyNmLbpzLK+8iOYUbLfyswYx0+zd36DAZaGDyPr5xMBWfdknNoWUDl6
         /tCvINkXpbGmeIYktIl7ALoXr+zRScF8O9APLP5WXPPCbLbeJXmu3W2x6Iu0hyHeH4Iv
         VgT3I1IUFmjHsFQoTewwdDMHdTrsZvY524BF4i/auRG0IV7VH9B2G3hgPOt/6LMb0w1l
         j03wCX0SKaJb0FU5xcoDF/LmfbTXbBJ+dKWEFOtqs/1s0u12pi2m/Lm8AxEinB46t6JX
         VxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FseZCCgNVHS8/IVjLlkAO/IZV6IaTuWANWfE9OA02ag=;
        b=jN4UsNOZoYeEHFbnuovmpzzpzQ5FvEb/vl/0/X9bu3UKqMP0y5PvTz3EBQ9gYDNOr9
         Ke66lxhr1zN2M07vK0WH7g/8u1+H1GuoaI6Qqxlv/1/dxQxd4C8uANraSPt4zAWA/YuQ
         XBV8+mdP40gIVsv9hCSs+VeFJeJjN7hK/GvtLRALbltSj7uL62dtN1LxPStKQ9MbaOn3
         hM8lsgy6MrztI+MArvneaHThAbe9WZrsVWxc71e2twAZm7yC0o+S6kH5gVd7e7zGSBgQ
         WJcKa/8DSvkCWNoMVNSSRhkVsLrt3jwC+A28fintbmXGdt/hTInLIF4wOzf1H/nlxmvN
         viDw==
X-Gm-Message-State: APjAAAUcDZ/81yYSdxMajXKZ5YU0Nd8EJLN6xHSUqOqXGi6hN+psxx2s
        CqUUbraHNncfI/VJoAtBcCeiMf2vqArPkibTQeFblA==
X-Google-Smtp-Source: APXvYqzoFRmqH01idiwpKxE5aAAg/eqddI7dteylUW7RLKXk6AJ0QJ2IFrVLd2FD/8cxjJFxekvTCc/qKBsmsoz7i1g=
X-Received: by 2002:a9d:470d:: with SMTP id a13mr189095otf.162.1558436926846;
 Tue, 21 May 2019 04:08:46 -0700 (PDT)
MIME-Version: 1.0
References: <1558147343-93724-1-git-send-email-xiangxia.m.yue@gmail.com>
 <20190520.195319.201742803310676769.davem@davemloft.net> <CAMDZJNWpv89beaNvVvycJ5YqwcKYiFNuP_gYKz_QmsQ2roiRGw@mail.gmail.com>
 <2dc1646c-ac58-f633-0c28-0c3197574cf3@6wind.com>
In-Reply-To: <2dc1646c-ac58-f633-0c28-0c3197574cf3@6wind.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 21 May 2019 19:08:10 +0800
Message-ID: <CAMDZJNUdnt4o+eT6Vjtt6h6=_wpiZGQfUK6qpyKPCg3RLoAmUA@mail.gmail.com>
Subject: Re: [PATCH] net: vxlan: disallow removing to other namespace
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 5:28 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 21/05/2019 =C3=A0 07:53, Tonghao Zhang a =C3=A9crit :
> [snip]
> > The problem is that we create one vxlan netdevice(e.g dstport 4789 and
> > external), and move it to
> > one net-namespace, and then we hope create one again(dstport 4789 and
> > external) and move it to other net-namespace, but we can't create it.
> >
> > $ ip netns add ns100
> > $ ip link add vxlan100 type vxlan dstport 4789 external
> > $ ip link set dev vxlan100 netns ns100
> > $ ip link add vxlan200 type vxlan dstport 4789 external
> > RTNETLINK answers: File exists
> Why is this a problem? This error is correct, the interface already exist=
s.
>
> >
> > The better way is that we should create directly it in the
> > net-namespace. To avoid confuse user, disallow moving it to other
> > net-namespace.
> There is no confusion, this is a feature. This link part of the vxlan is =
in
> another namespace:
>
> $ ip -d -n ns100 link ls vxlan100
> 15: vxlan100: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode D=
EFAULT
> group default qlen 1000
>     link/ether d6:54:ea:b4:46:a5 brd ff:ff:ff:ff:ff:ff link-netnsid 0
> promiscuity 0 minmtu 68 maxmtu 65535
>     vxlan externaladdrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_s=
ize
> 65536 gso_max_segs 65535
>
> =3D> "link-netnsid 0" means that the link part is in the nsid 0, ie init_=
net in my
> case.
I got it, thanks
>
> Regards,
> Nicolas
