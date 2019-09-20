Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 102F0B94C3
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbfITQAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 12:00:30 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39711 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfITQAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 12:00:30 -0400
Received: by mail-qt1-f194.google.com with SMTP id n7so9232885qtb.6
        for <netdev@vger.kernel.org>; Fri, 20 Sep 2019 09:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FV9di+tIdVEnUlr5eIwqtD7ohtP9kPAJYGWB6b5Vwsc=;
        b=vu7Wk646vEv/nHjomvmHoV8mqUjPuMSE3laKAEeTAlRHcZiKaB2fQCZmqkyl5jkocV
         ixZ4qsFNfbTPEcuIHTEtaywull51zass7MZRBARvWzuFwN6B/G6e+DyOZ3ysTr0kZHFU
         v5C9+W0Q4TOn2Qwseq7h+0tfitiy8VtiswxJWbvEIUw9i3JlSB45PY5bceMsuDg3IMFp
         8k6wM5Pecw4udI8VkGqelUnu+8heogZ1YDQSleY27HoP6j7FciJ/aTajGIgnkzrh9tpG
         DRqKxoP0EHs18OVQN5l8fNQHqRz0NKudDtdxMzEWch8dJPRrhIc8UpTLA/SUvomWFgIm
         vJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FV9di+tIdVEnUlr5eIwqtD7ohtP9kPAJYGWB6b5Vwsc=;
        b=gvU7qYSW+It2vd9xJ5DFYatZATl2fCiOnDJwLULRj9NE65qtcRI6qf1Y2n56Gs7Pc2
         JoF1GbSnWvKGkBsiyCNfsPW56m0uJH6wbVUT4qh/IjAGGq79ayyiCT+tGaXe44HIe8ob
         BQUgvAGgQQdtopLJfA4pEPPK3dMLKwGh5zWCuEGf0unDewExO4kYBoouNgg8qoZqC9dm
         OOtRhYDoqT1EjCo33qVOtECXjd8E4t+Zjqr6JbtdMbevomWRhGjItxuKz7EG4MH3lSAl
         M7thHpKdjiqycWxpwW4qi2L9qFkQfMRE/HQDLfecMKaMlEHyEPZpp7O7CZoCRkhnbvS3
         ctig==
X-Gm-Message-State: APjAAAW5PjCw36+ie+LvJpek0lmIQfOKR0bYlXKV6lxGIiF+ofP2yWm3
        dwXNW+eNn7ZmKTAVby4pqyO3EAnaL7HGEwLpGvctGx3BxOvUWw==
X-Google-Smtp-Source: APXvYqx2guLMGJK+l5gQGqOUa0xHXgDDsWxsxDVh86OfNcdj6vVQbTVEJz/zgqVPKqqmI+MgkB2sJAe3XOMMTQEVQWI=
X-Received: by 2002:ac8:6d03:: with SMTP id o3mr3853330qtt.97.1568995228657;
 Fri, 20 Sep 2019 09:00:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx>
 <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
 <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com>
 <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
 <7236.1568906827@nyx> <7154.1568987531@nyx>
In-Reply-To: <7154.1568987531@nyx>
From:   =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JfQsNGF0LDRgNC+0LI=?= 
        <zaharov@selectel.ru>
Date:   Fri, 20 Sep 2019 19:00:17 +0300
Message-ID: <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> [...]
> >       In any event, I think I see what the failure is, I'm working up
> >a patch to test and will post it when I have it ready.
>
>         Aleksei,
>
>         Would you be able to test the following patch and see if it
> resolves the issue in your testing?  This is against current net-next,
> but applies to current net as well.  Your kernel appears to be a bit
> older (as the message formats differ), so hopefully it will apply there
> as well.  I've tested this a bit (but not the ARP mon portion), and it
> seems to do the right thing, but I can't reproduce the original issue
> locally.
We're testing on ubuntu-bionic 4.15 kernel.

>
>         Thanks,
>
>         -J
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 931d9d935686..38042399717b 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2086,8 +2086,7 @@ static int bond_miimon_inspect(struct bonding *bond)
>         ignore_updelay = !rcu_dereference(bond->curr_active_slave);
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link = BOND_LINK_NOCHANGE;
> -               slave->link_new_state = slave->link;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 link_state = bond_check_dev_link(bond, slave->dev, 0);
>
> @@ -2121,7 +2120,7 @@ static int bond_miimon_inspect(struct bonding *bond)
>                         }
>
>                         if (slave->delay <= 0) {
> -                               slave->new_link = BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_DOWN);
>                                 commit++;
>                                 continue;
>                         }
> @@ -2158,7 +2157,7 @@ static int bond_miimon_inspect(struct bonding *bond)
>                                 slave->delay = 0;
>
>                         if (slave->delay <= 0) {
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 commit++;
>                                 ignore_updelay = false;
>                                 continue;
> @@ -2196,7 +2195,7 @@ static void bond_miimon_commit(struct bonding *bond)
>         struct slave *slave, *primary;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         /* For 802.3ad mode, check current slave speed and
>                          * duplex again in case its port was disabled after
> @@ -2268,8 +2267,8 @@ static void bond_miimon_commit(struct bonding *bond)
>
>                 default:
>                         slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
> -                                 slave->new_link);
> -                       slave->new_link = BOND_LINK_NOCHANGE;
> +                                 slave->link_new_state);
> +                       bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                         continue;
>                 }
> @@ -2677,13 +2676,13 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
>         bond_for_each_slave_rcu(bond, slave, iter) {
>                 unsigned long trans_start = dev_trans_start(slave->dev);
>
> -               slave->new_link = BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 if (slave->link != BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, trans_start, 1) &&
>                             bond_time_in_interval(bond, slave->last_rx, 1)) {
>
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 slave_state_changed = 1;
>
>                                 /* primary_slave has no meaning in round-robin
> @@ -2708,7 +2707,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
>                         if (!bond_time_in_interval(bond, trans_start, 2) ||
>                             !bond_time_in_interval(bond, slave->last_rx, 2)) {
>
> -                               slave->new_link = BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_DOWN);
>                                 slave_state_changed = 1;
>
>                                 if (slave->link_failure_count < UINT_MAX)
> @@ -2739,8 +2738,8 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
>                         goto re_arm;
>
>                 bond_for_each_slave(bond, slave, iter) {
> -                       if (slave->new_link != BOND_LINK_NOCHANGE)
> -                               slave->link = slave->new_link;
> +                       if (slave->link_new_state != BOND_LINK_NOCHANGE)
> +                               slave->link = slave->link_new_state;
>                 }
>
>                 if (slave_state_changed) {
> @@ -2763,9 +2762,9 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
>  }
>
>  /* Called to inspect slaves for active-backup mode ARP monitor link state
> - * changes.  Sets new_link in slaves to specify what action should take
> - * place for the slave.  Returns 0 if no changes are found, >0 if changes
> - * to link states must be committed.
> + * changes.  Sets proposed link state in slaves to specify what action
> + * should take place for the slave.  Returns 0 if no changes are found, >0
> + * if changes to link states must be committed.
>   *
>   * Called with rcu_read_lock held.
>   */
> @@ -2777,12 +2776,12 @@ static int bond_ab_arp_inspect(struct bonding *bond)
>         int commit = 0;
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link = BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>                 last_rx = slave_last_rx(bond, slave);
>
>                 if (slave->link != BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, last_rx, 1)) {
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 commit++;
>                         }
>                         continue;
> @@ -2810,7 +2809,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
>                 if (!bond_is_active_slave(slave) &&
>                     !rcu_access_pointer(bond->current_arp_slave) &&
>                     !bond_time_in_interval(bond, last_rx, 3)) {
> -                       slave->new_link = BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>
> @@ -2823,7 +2822,7 @@ static int bond_ab_arp_inspect(struct bonding *bond)
>                 if (bond_is_active_slave(slave) &&
>                     (!bond_time_in_interval(bond, trans_start, 2) ||
>                      !bond_time_in_interval(bond, last_rx, 2))) {
> -                       slave->new_link = BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>         }
> @@ -2843,7 +2842,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
>         struct slave *slave;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         continue;
>
> @@ -2893,8 +2892,9 @@ static void bond_ab_arp_commit(struct bonding *bond)
>                         continue;
>
>                 default:
> -                       slave_err(bond->dev, slave->dev, "impossible: new_link %d on slave\n",
> -                                 slave->new_link);
> +                       slave_err(bond->dev, slave->dev,
> +                                 "impossible: link_new_state %d on slave\n",
> +                                 slave->link_new_state);
>                         continue;
>                 }
>
> diff --git a/include/net/bonding.h b/include/net/bonding.h
> index f7fe45689142..d416af72404b 100644
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -159,7 +159,6 @@ struct slave {
>         unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
>         s8     link;            /* one of BOND_LINK_XXXX */
>         s8     link_new_state;  /* one of BOND_LINK_XXXX */
> -       s8     new_link;
>         u8     backup:1,   /* indicates backup slave. Value corresponds with
>                               BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
>                inactive:1, /* indicates inactive slave */
> @@ -549,7 +548,7 @@ static inline void bond_propose_link_state(struct slave *slave, int state)
>
>  static inline void bond_commit_link_state(struct slave *slave, bool notify)
>  {
> -       if (slave->link == slave->link_new_state)
> +       if (slave->link_new_state == BOND_LINK_NOCHANGE)
>                 return;
>
>         slave->link = slave->link_new_state;
>
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
I had to change slave_err to netdev_err, because there's no slave_err
macro in 4.15.
I did some fast testing, things become a bit more weird for me.
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
[Fri Sep 20 17:56:54 2019] 8021q: adding VLAN 0 to HW filter on device bond-san
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

-- 
Best Regards,
Aleksei Zakharov
System administrator
