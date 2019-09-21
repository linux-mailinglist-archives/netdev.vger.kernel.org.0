Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E16CB9D90
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 13:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407557AbfIULSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 07:18:10 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38280 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407499AbfIULSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 07:18:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so11733216qta.5
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 04:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AYyrUhZFvvzZ9cTYOp8RE7OCq4yyOf1wS9RpQX5uRGE=;
        b=F0Lu7wtRAbJ1LjJ31dG06GNUZC6e/424LpVR2AKv3MiSPKnDqEVYZJV2ltvrzdnTqn
         KDpxomvytgqfLL8K/Bp0LB6Hvq2/Ox7P8Evs1H9k790zOLDuyW3HFIH2glaIKE85mx2j
         AlARVaigTEgPcbcq/xSiHnrZ5RVDCDjxLE4qtYHl+l3iPhVlivTOyA9YXi2ItSJvWv6V
         sUWoaOe4iBuzND69Zow2Wmj/9g++WXpzd8BbL7Mw1xb/cj4LKmCYRCy6MG4dVKCXJ2SJ
         BhLVA+eipr0A93hYYCSuNfuYRlWROjDmqVIee3xCNG+W2KQWv9GPsETqONCwuBwUeabn
         beYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AYyrUhZFvvzZ9cTYOp8RE7OCq4yyOf1wS9RpQX5uRGE=;
        b=hBK//lj+NWbmDUSr/k5QE4gagL9bouLJCvJw2fQFEGi942MOKIUfTO9qY/vdz84VXx
         FSA07wmkJmAf+/4nJYXDfztCXpeTzKXil2dpjRC13eF8HdxHh/nATY8bIptIf2KyUc2T
         tEc51VZAim8vY74D5U9zYxhQ3BzQEzZ08+KmX0lNdc1plxwEt1neU/5CYcH0tSXqvE3D
         HPZQvmyIwa7P7e2a5ygMqP4PsRBrZ78ZqCOuZsAdpim2qLS175OaEnk2bIEquC57MQJx
         lnbKTpms4LMj6K9l5qnjIYg8mmObpFBYoxO0kzfVBwgcespbNTPvXncoBoBAdOgncSWW
         fwoA==
X-Gm-Message-State: APjAAAVR7S1b+GXziz1+FomTp32DVQpyh5lqaM9c8ov/A3/zBsG7glJZ
        PDRWGXRQ7z9yXbexz24nCdUfTWlhjrTGEvDLXmdrmQ==
X-Google-Smtp-Source: APXvYqzSuXhVfKBO5HzLmUDyk5sxpTyZ+3r7o9oDRnF0G/cx74/jFCsndf+hmPjVQ55jJfUivBclldhsicIgJGr+kHI=
X-Received: by 2002:ac8:538b:: with SMTP id x11mr7787184qtp.200.1569064688726;
 Sat, 21 Sep 2019 04:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx>
 <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
 <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com>
 <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
 <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
 <10497.1569049560@nyx>
In-Reply-To: <10497.1569049560@nyx>
From:   =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI=?= 
        <zaharov@selectel.ru>
Date:   Sat, 21 Sep 2019 14:17:57 +0300
Message-ID: <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=81=D0=B1, 21 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 10:06, Jay V=
osburgh <jay.vosburgh@canonical.com>:
>
> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=97=D0=B0=D1=85=D0=B0=D1=80=
=D0=BE=D0=B2 wrote:
>
> >>
> >> Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >> [...]
> >> >       In any event, I think I see what the failure is, I'm working u=
p
> >> >a patch to test and will post it when I have it ready.
> >>
> >>         Aleksei,
> >>
> >>         Would you be able to test the following patch and see if it
> >> resolves the issue in your testing?  This is against current net-next,
> >> but applies to current net as well.  Your kernel appears to be a bit
> >> older (as the message formats differ), so hopefully it will apply ther=
e
> >> as well.  I've tested this a bit (but not the ARP mon portion), and it
> >> seems to do the right thing, but I can't reproduce the original issue
> >> locally.
> >We're testing on ubuntu-bionic 4.15 kernel.
>
>         I believe the following will apply for the Ubuntu 4.15 kernels;
> this is against 4.15.0-60, so you may have some fuzz if your version is
> far removed.  I've not tested this as I'm travelling at the moment, but
> the only real difference is the netdev_err vs. slave_err changes in
> bonding that aren't relevant to the fix itself.
Thanks! But I've already applied previous patch. Changed slave_err to
netdev_err.
As I mentioned in the previous email, we have another issue now.
With this patch one slave is in broken state right after boot.

Right after reboot one of the slaves hangs with actor port state 71
and partner port state 1.
It doesn't send lacpdu and seems to be broken.
Setting link down and up again fixes slave state.
Dmesg after boot:
[Fri Sep 20 17:56:53 2019] bond-san: Enslaving eth3 as a backup
interface with an up link
[Fri Sep 20 17:56:53 2019] bond-san: Enslaving eth2 as a backup
interface with an up link
[Fri Sep 20 17:56:54 2019] bond-san: Warning: No 802.3ad response from
the link partner for any adapters in the bond
[Fri Sep 20 17:56:54 2019] IPv6: ADDRCONF(NETDEV_UP): bond-san: link
is not ready
[Fri Sep 20 17:56:54 2019] 8021q: adding VLAN 0 to HW filter on device bond=
-san
[Fri Sep 20 17:56:54 2019] IPv6: ADDRCONF(NETDEV_CHANGE): bond-san:
link becomes ready
[Fri Sep 20 17:56:54 2019] bond-san: link status definitely up for
interface eth3, 10000 Mbps full duplex
[Fri Sep 20 17:56:54 2019] bond-san: first active interface up!

Broken link here is eth2. After set it down and up:
[Fri Sep 20 18:02:04 2019] mlx4_en: eth2: Link Up
[Fri Sep 20 18:02:04 2019] bond-san: link status up again after -200
ms for interface eth2
[Fri Sep 20 18:02:04 2019] bond-san: link status definitely up for
interface eth2, 10000 Mbps full duplex

If I'm trying to reproduce previous behavior, I get different messages
from time to time:
[Fri Sep 20 18:04:48 2019] mlx4_en: eth2: Link Up
[Fri Sep 20 18:04:48 2019] bond-san: link status up for interface
eth2, enabling it in 500 ms
[Fri Sep 20 18:04:48 2019] bond-san: invalid new link 3 on slave eth2
[Fri Sep 20 18:04:49 2019] bond-san: link status definitely up for
interface eth2, 10000 Mbps full duplex
or:
[Fri Sep 20 18:05:48 2019] mlx4_en: eth2: Link Up
[Fri Sep 20 18:05:49 2019] bond-san: link status up again after 0 ms
for interface eth2
[Fri Sep 20 18:05:49 2019] bond-san: link status definitely up for
interface eth2, 10000 Mbps full duplex

In both cases this slave works after up.

>
>         -J
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
> index 8cd25eb26a9a..b159a6595e11 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2057,8 +2057,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>         ignore_updelay =3D !rcu_dereference(bond->curr_active_slave);
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link =3D BOND_LINK_NOCHANGE;
> -               slave->link_new_state =3D slave->link;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 link_state =3D bond_check_dev_link(bond, slave->dev, 0);
>
> @@ -2094,7 +2093,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>                         }
>
>                         if (slave->delay <=3D 0) {
> -                               slave->new_link =3D BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_=
DOWN);
>                                 commit++;
>                                 continue;
>                         }
> @@ -2133,7 +2132,7 @@ static int bond_miimon_inspect(struct bonding *bond=
)
>                                 slave->delay =3D 0;
>
>                         if (slave->delay <=3D 0) {
> -                               slave->new_link =3D BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_=
UP);
>                                 commit++;
>                                 ignore_updelay =3D false;
>                                 continue;
> @@ -2153,7 +2152,7 @@ static void bond_miimon_commit(struct bonding *bond=
)
>         struct slave *slave, *primary;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         continue;
>
> @@ -2237,8 +2236,8 @@ static void bond_miimon_commit(struct bonding *bond=
)
>
>                 default:
>                         netdev_err(bond->dev, "invalid new link %d on sla=
ve %s\n",
> -                                  slave->new_link, slave->dev->name);
> -                       slave->new_link =3D BOND_LINK_NOCHANGE;
> +                                  slave->link_new_state, slave->dev->nam=
e);
> +                       bond_propose_link_state(slave, BOND_LINK_NOCHANGE=
);
>
>                         continue;
>                 }
> @@ -2638,13 +2637,13 @@ static void bond_loadbalance_arp_mon(struct bondi=
ng *bond)
>         bond_for_each_slave_rcu(bond, slave, iter) {
>                 unsigned long trans_start =3D dev_trans_start(slave->dev)=
;
>
> -               slave->new_link =3D BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 if (slave->link !=3D BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, trans_start, 1) &=
&
>                             bond_time_in_interval(bond, slave->last_rx, 1=
)) {
>
> -                               slave->new_link =3D BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_=
UP);
>                                 slave_state_changed =3D 1;
>
>                                 /* primary_slave has no meaning in round-=
robin
> @@ -2671,7 +2670,7 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
>                         if (!bond_time_in_interval(bond, trans_start, 2) =
||
>                             !bond_time_in_interval(bond, slave->last_rx, =
2)) {
>
> -                               slave->new_link =3D BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_=
DOWN);
>                                 slave_state_changed =3D 1;
>
>                                 if (slave->link_failure_count < UINT_MAX)
> @@ -2703,8 +2702,8 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
>                         goto re_arm;
>
>                 bond_for_each_slave(bond, slave, iter) {
> -                       if (slave->new_link !=3D BOND_LINK_NOCHANGE)
> -                               slave->link =3D slave->new_link;
> +                       if (slave->link_new_state !=3D BOND_LINK_NOCHANGE=
)
> +                               slave->link =3D slave->link_new_state;
>                 }
>
>                 if (slave_state_changed) {
> @@ -2727,9 +2726,9 @@ static void bond_loadbalance_arp_mon(struct bonding=
 *bond)
>  }
>
>  /* Called to inspect slaves for active-backup mode ARP monitor link stat=
e
> - * changes.  Sets new_link in slaves to specify what action should take
> - * place for the slave.  Returns 0 if no changes are found, >0 if change=
s
> - * to link states must be committed.
> + * changes.  Sets proposed link state in slaves to specify what action
> + * should take place for the slave.  Returns 0 if no changes are found, =
>0
> + * if changes to link states must be committed.
>   *
>   * Called with rcu_read_lock held.
>   */
> @@ -2741,12 +2740,12 @@ static int bond_ab_arp_inspect(struct bonding *bo=
nd)
>         int commit =3D 0;
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link =3D BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>                 last_rx =3D slave_last_rx(bond, slave);
>
>                 if (slave->link !=3D BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, last_rx, 1)) {
> -                               slave->new_link =3D BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_=
UP);
>                                 commit++;
>                         }
>                         continue;
> @@ -2774,7 +2773,7 @@ static int bond_ab_arp_inspect(struct bonding *bond=
)
>                 if (!bond_is_active_slave(slave) &&
>                     !rcu_access_pointer(bond->current_arp_slave) &&
>                     !bond_time_in_interval(bond, last_rx, 3)) {
> -                       slave->new_link =3D BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>
> @@ -2787,7 +2786,7 @@ static int bond_ab_arp_inspect(struct bonding *bond=
)
>                 if (bond_is_active_slave(slave) &&
>                     (!bond_time_in_interval(bond, trans_start, 2) ||
>                      !bond_time_in_interval(bond, last_rx, 2))) {
> -                       slave->new_link =3D BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>         }
> @@ -2807,7 +2806,7 @@ static void bond_ab_arp_commit(struct bonding *bond=
)
>         struct slave *slave;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         continue;
>
> @@ -2859,8 +2858,8 @@ static void bond_ab_arp_commit(struct bonding *bond=
)
>                         continue;
>
>                 default:
> -                       netdev_err(bond->dev, "impossible: new_link %d on=
 slave %s\n",
> -                                  slave->new_link, slave->dev->name);
> +                       netdev_err(bond->dev, "impossible: link_new_state=
 %d on slave %s\n",
> +                                  slave->link_new_state, slave->dev->nam=
e);
>                         continue;
>                 }
>
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index af927d97c1c1..65361d56109e 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -149,7 +149,6 @@ struct slave {
>         unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
>         s8     link;            /* one of BOND_LINK_XXXX */
>         s8     link_new_state;  /* one of BOND_LINK_XXXX */
> -       s8     new_link;
>         u8     backup:1,   /* indicates backup slave. Value corresponds w=
ith
>                               BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
>                inactive:1, /* indicates inactive slave */
> @@ -519,7 +518,7 @@ static inline void bond_propose_link_state(struct sla=
ve *slave, int state)
>
>  static inline void bond_commit_link_state(struct slave *slave, bool noti=
fy)
>  {
> -       if (slave->link =3D=3D slave->link_new_state)
> +       if (slave->link_new_state =3D=3D BOND_LINK_NOCHANGE)
>                 return;
>
>         slave->link =3D slave->link_new_state;
> --
> 2.23.0
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com



--=20
Best Regards,
Aleksei Zakharov
System administrator
