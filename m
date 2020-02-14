Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4891415D0F1
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 05:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgBNESb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 23:18:31 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33553 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgBNESb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 23:18:31 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so5860114lfl.0
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 20:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3NhIIpP1Pwuhb7GnJC5XeO680ejN9foraUwFYCdozeE=;
        b=iV9rHdCpwYWbfAemI4gE3gIe9DFme2KmZh9Wxh/RbIAVZR6vCGWOXRrPsdDKTO/0iI
         FTQUK3BQ+Cv1YUKkd58K0Z+81FYMsSpgAndrhbHVo2pir98jcK7zwZSN3c/OEybVx4LS
         MHz1V51b9tBiws7WbPRKukJNRVyUfsUaEYDH9zx8DiG2c5okkm97u9PggTQqUF3Due5T
         LpLMwrCKHezzDQayBDJEb+WGJpSh33tHIjkSGO/FuHVsAYi65OtEEWaJeEz41agA7PNl
         v/1vYgKH8VvAHYKujWQ0c8thW7qaAySmeLKqbl6NI6lxv0i19c3VlHYM+/vT+glagogs
         NaXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3NhIIpP1Pwuhb7GnJC5XeO680ejN9foraUwFYCdozeE=;
        b=TNtpMf7e9np/W85l3vZoAxG8jR8BcsYSC7wuuW9OZJkbODxFyiIjUWQd8OZFSnOqKx
         y+O/cJ4Rr+KGX3EuS4KhoDJOK5n/ygDwNO0UuvvOmfGazi4wEVMPxGpTkI2P+LHXuvf+
         m4+I5Jv5Xvr+975CJeicG4/S3aFMHJKG46eoUE85u08NfmGbuPEamYup6VWMGi+fbi6O
         p5HkJvr++FpcMn4EYmli1C67pVU7wbgdBTe9B39i86BsTBJZ2+L6+mZBSm3RHnLCaEqn
         /8GMY+zL0hqld5WSU/UHrTck5WR5L6r9yJcGeGMqUhKgRx4sB/C1YLL4eNix1JF6wNtr
         y5ig==
X-Gm-Message-State: APjAAAUyF/7qex5wNTAJ6VMTPmzdBhg3tRey55nmaOgDA6INLjHO8CdQ
        zRK91zEGWG0JI13i2oz49QVJTGbnC9uN8H2OrUE=
X-Google-Smtp-Source: APXvYqx657chJDOEt8hJJLYkERJ5mjGwTvMK+KOJKvV1SDxgET5BKuJ2NG8LDpjkSKL75KzGnP3684lsVk5hKMZA2wQ=
X-Received: by 2002:a19:f811:: with SMTP id a17mr627119lff.182.1581653908594;
 Thu, 13 Feb 2020 20:18:28 -0800 (PST)
MIME-Version: 1.0
References: <20200213192129.16104-1-ap420073@gmail.com> <a86bb353-f20c-115e-27f1-568773360496@gmail.com>
In-Reply-To: <a86bb353-f20c-115e-27f1-568773360496@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Fri, 14 Feb 2020 13:18:17 +0900
Message-ID: <CAMArcTX4DuSGeBBjWquDWgdxejdEN1s2gJ92-Nwp6_wkFTGU4Q@mail.gmail.com>
Subject: Re: [PATCH net 2/2] bonding: do not collect slave's stats
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Feb 2020 at 04:34, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>

Hi Eric,
Thank you for the review!

> On 2/13/20 11:21 AM, Taehee Yoo wrote:
> > When stat query is requested(dev_get_stats()), bonding interfaces
> > collect stats of slave interfaces.
> > Then, it prints delta value, which is "new_stats - old_stats" and
> > updates bond->bond_stats.
> > But, this mechanism has some problems.
> >
> > 1. It needs a lock for protecting "bond->bond_stats".
> > Bonding interfaces would be nested. So this lock would also be nested.
> > So, spin_lock_nested() or dynamic lockdep class key was used.
> > In the case of spin_lock_nested(), it needs correct nested level value
> > and this value will be changed when master/nomaster operations
> > (ip link set bond0 master bond1) are being executed.
> > This value is protected by RTNL mutex lock, but "dev_get_stats()" would
> > be called outside of RTNL mutex.
> > So, imbalance lock/unlock would be happened.
> > Another case, which is to use dynamic lockdep class key has same problem.
> > dynamic lockdep class key is protected by RTNL mutex lock
> > and if master/nomaster operations are executed, updating lockdep class
> > key is needed.
> > But, dev_get_stats() would be called outside of RTNL mutex, so imbalance
> > lock/unlock would be happened too.
> >
> > 2. Couldn't show correct stats value when slave interfaces are used
> > directly.
> >
> > Test commands:
> >     ip netns add nst
> >     ip link add veth0 type veth peer name veth1
> >     ip link set veth1 netns nst
> >     ip link add bond0 type bond
> >     ip link set veth0 master bond0
> >     ip netns exec nst ip link set veth1 up
> >     ip netns exec nst ip a a 192.168.100.2/24 dev veth1
> >     ip a a 192.168.100.1/24 dev bond0
> >     ip link set veth0 up
> >     ip link set bond0 up
> >     ping 192.168.100.2 -I veth0 -c 10
> >     ip -s link show bond0
> >     ip -s link show veth0
> >
> > Before:
> > 26: bond0:
> > RX: bytes  packets  errors  dropped overrun mcast
> > 656        8        0       0       0       0
> > TX: bytes  packets  errors  dropped carrier collsns
> > 1340       22       0       0       0       0
> > ~~~~~~~~~~~~
> >
> > 25: veth0@if24:
> > RX: bytes  packets  errors  dropped overrun mcast
> > 656        8        0       0       0       0
> > TX: bytes  packets  errors  dropped carrier collsns
> > 1340       22       0       0       0       0
> > ~~~~~~~~~~~~
> >
> > After:
> > 19: bond0:
> > RX: bytes  packets  errors  dropped overrun mcast
> > 544        8        0       0       0       8
> > TX: bytes  packets  errors  dropped carrier collsns
> > 746        9        0       0       0       0
> > ~~~~~~~~~~~
> >
> > 18: veth0@if17:
> > link/ether 76:14:ee:f1:7d:8e brd ff:ff:ff:ff:ff:ff link-netns nst
> > RX: bytes  packets  errors  dropped overrun mcast
> > 656        8        0       0       0       0
> > TX: bytes  packets  errors  dropped carrier collsns
> > 1250       21       0       0       0       0
> > ~~~~~~~~~~~~
> >
> > Only veth0 interface is used by ping process directly. bond0 interface
> > isn't used. So, bond0 stats should not be increased.
> > But, bond0 collects stats value of slave interface.
> > So bond0 stats will be increased.
> >
> > In order to fix the above problems, this patch makes bonding interfaces
> > record own stats data like other interfaces.
> > This patch is made based on team interface stats logic.
> >
> > There is another problem.
> > When master/nomaster operations are being executed, updating a dynamic
> > lockdep class key is needed.
> > But, bonding doesn't update dynamic lockdep key.
> > So, lockdep warning message occurs.
> > But, this problem will be disappeared by this patch.
> > Because this patch removes stats_lock and a dynamic lockdep class key
> > for stats_lock, which is stats_lock_key.
> >
> > Test commands:
> >     ip link add bond0 type bond
> >     ip link add bond1 type bond
> >     ip link set bond0 master bond1
> >     ip link set bond0 nomaster
> >     ip link set bond1 master bond0
> >
> > Splat looks like:
>
> This is way too invasive patch IMO for net tree.
>

I agree with this.

> We do not want adding costs in bonding fast path, for stats accounting.
>

Yes, this patch reduces overheads of dev_get_stats(), but it
sadly increases overheads of datapath.
So, I agree with this.

> We do not care of glitches causes by slaves being added/deleted, this usually happens
> when we do not need stats (boot time, and before reboot)
>
> BTW, skb->len in RX path is different than the stats provided by hw usually
> (because of things like GRO)

Thank you for the advice!

> Maybe revert the prior patches instead, they have caused a lot of churn.
>
> Or just fix the lockdep issue, and leave stats being what they are.
>

I think fixing only lockdep issues would be good.
So, I will send a v2 patch, which will fix only lockdep issues.

Thanks a lot!
Taehee Yoo
