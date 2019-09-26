Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331C6BF503
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 16:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfIZOZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 10:25:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41978 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfIZOZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 10:25:49 -0400
Received: by mail-qt1-f196.google.com with SMTP id n1so3066109qtp.8
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 07:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qqTNtAjoZumTGtKkhzYoF1SY4vhdNRooc6DB9HFFkmE=;
        b=aSncYJVn9NYEDNBhyn4Mr8l5xJKTdjagE5h8TO3rSwUBdK3NWzF6znxWkUVMF3mUYe
         HilTXg3OI1nLFq/RXzey0pSCapIaOlhYZeRCOztFtOY+8Sn3eMtpmpmXa7mOOdvYY/ly
         gCLbxD2rv0ejq1dVGcbcV1Cjs8C+/ojcwbYrDKAzp1allqhyrI+kbcaGPuLqCLwcEZJt
         KoTXw0ssuQnnGiMoEUkOak6oUm4qe3LLSngkthranwn4vbc9JmLGhqFZlycqNEBr9/vD
         fjstTxd+BiPn4RaBsXNbWOFJSpt6V+uonAJ4Q4mV+wF0Kb7hAt96UufpZ/KbltAQWuEP
         B8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qqTNtAjoZumTGtKkhzYoF1SY4vhdNRooc6DB9HFFkmE=;
        b=se6Joszx3HK2EWQ9tz2VzR6bRbSrbWVOf2xvnJR10DBEO0BLgQMDFHtrQ+mnkpRJKT
         f9EmcPm2O3PnqeyChHYow5I5BiXKebeNqVR4hoHZ0IQmPPhrx9+ZnO3J2IUkm4sZLaID
         Guocw5wWo7hHtZn0mOendu3US/cDl4ZuWykhlVZbAkGaUTXMRppfmTG2LDR8l5zrh/4s
         7OTDYUa45LTRcmsouGn9vAHTjSteFFge0TFcrN5sqf02MUThd6GfpdKjUW04ZQiAIjxO
         P4MFgHJS9W+ZFrAaGJC45jVTJu7ggq7BP4kdPlPNPxZtwXlcdCpnhX3dSw2PXieI5Acc
         eAlA==
X-Gm-Message-State: APjAAAUVDIuppO1BV2jOdYbJH9XbiRHeI0BWqKUKt9MBbpNe8WdZRzJC
        jNUm5x4MMY3Vtvo3coBCfmr3WqpsviR3MaMTOq/xmg==
X-Google-Smtp-Source: APXvYqw92NztJF9tHhI2B2hrwlfuo/unHDTtjehrCUw/3flSvFGyKgfupc2WsYehXayqVeFge7uUPj1YwcyMxYZNAko=
X-Received: by 2002:ac8:e09:: with SMTP id a9mr4160975qti.88.1569507947736;
 Thu, 26 Sep 2019 07:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx>
 <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
 <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com>
 <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
 <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
 <10497.1569049560@nyx> <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com>
 <16538.1569371467@famine> <CAJYOGF9TY8WtUscsfJ=qduAw7_1BwU+4iE+eL6cidM=LBL9w+A@mail.gmail.com>
 <15507.1569472734@nyx>
In-Reply-To: <15507.1569472734@nyx>
From:   Aleksei Zakharov <zaharov@selectel.ru>
Date:   Thu, 26 Sep 2019 17:25:36 +0300
Message-ID: <CAJYOGF-84BfK8DvAnam9+tgfo4=oBs04zF-ETWRfhz7CE_9oBA@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "zhangsha (A)" <zhangsha.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 07:38, Jay V=
osburgh <jay.vosburgh@canonical.com>:
>
> Aleksei Zakharov <zaharov@selectel.ru> wrote:
>
> >=D1=81=D1=80, 25 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 03:31, Ja=
y Vosburgh <jay.vosburgh@canonical.com>:
> >>
> >> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=97=D0=B0=D1=85=D0=B0=D1=
=80=D0=BE=D0=B2 wrote:
> >> [...]
> >> >Right after reboot one of the slaves hangs with actor port state 71
> >> >and partner port state 1.
> >> >It doesn't send lacpdu and seems to be broken.
> >> >Setting link down and up again fixes slave state.
> >> [...]
> >>
> >>         I think I see what failed in the first patch, could you test t=
he
> >> following patch?  This one is for net-next, so you'd need to again swa=
p
> >> slave_err / netdev_err for the Ubuntu 4.15 kernel.
> >>
> >I've tested new patch. It seems to work. I can't reproduce the bug
> >with this patch.
> >There are two types of messages when link becomes up:
> >First:
> >bond-san: EVENT 1 llu 4294895911 slave eth2
> >8021q: adding VLAN 0 to HW filter on device eth2
> >bond-san: link status definitely down for interface eth2, disabling it
> >mlx4_en: eth2: Link Up
> >bond-san: EVENT 4 llu 4294895911 slave eth2
> >bond-san: link status up for interface eth2, enabling it in 500 ms
> >bond-san: invalid new link 3 on slave eth2
> >bond-san: link status definitely up for interface eth2, 10000 Mbps full =
duplex
> >Second:
> >bond-san: EVENT 1 llu 4295147594 slave eth2
> >8021q: adding VLAN 0 to HW filter on device eth2
> >mlx4_en: eth2: Link Up
> >bond-san: EVENT 4 llu 4295147594 slave eth2
> >bond-san: link status up again after 0 ms for interface eth2
> >bond-san: link status definitely up for interface eth2, 10000 Mbps full =
duplex
> > [...]
>
>         The "invalid new link" is appearing because bond_miimon_commit
> is being asked to commit a new state that isn't UP or DOWN (3 is
> BOND_LINK_BACK).  I looked through the patched code today, and I don't
> see a way to get to that message with the new link set to 3, so I'll add
> some instrumentation and send out another patch to figure out what's
> going on, as that shouldn't happen.
>
>         I don't see the "invalid" message testing locally, I think
> because my network device doesn't transition to carrier up as quickly as
> yours.  I thought you were getting BOND_LINK_BACK passed through from
> bond_enslave (which calls bond_set_slave_link_state, which will set
> link_new_link to BOND_LINK_BACK and leave it there), but the
> link_new_link is reset first thing in bond_miimon_inspect, so I'm not
> sure how it gets into bond_miimon_commit (I'm thinking perhaps a
> concurrent commit triggered by another slave, which then picks up this
> proposed link state change by happenstance).
I assume that "invalid new link" happens in this way:
Interface goes up
NETDEV_CHANGE event occurs
bond_update_speed_duplex fails
and slave->last_link_up returns true
slave->link becomes BOND_LINK_FAIL
bond_check_dev_link returns 0
miimon proposes slave->link_new_state BOND_LINK_DOWN
NETDEV_UP event occurs
miimon sets commit++
miimon proposes slave->link_new_state BOND_LINK_BACK
miimon sets slave->link to BOND_LINK_BACK
we have updelay configured, so it doesn't set BOND_LINK_UP in the next
case section
miimon says "Invalid new link" and sets link state UP during next
inspection(after updelay, i suppose)

For the second type of messages it looks like this:
Interface goes up
NETDEV_CHANGE event occurs
bond_update_speed_duplex fails
and slave->last_link_up returns true
slave->link becomes BOND_LINK_FAIL
NETDEV_UP event occurs
bond_check_dev_link returns 1
miimon proposes slave->link_new_state BOND_LINK_UP and says "link
status up again"

My first patch changed slave->last_link_up check to (slave->link =3D=3D
BOND_LINK_UP).
This check looks more consistent for me, but I might be wrong here.
As a result if link was in BOND_LINK_FAIL or BOND_LINK_BACK when
CHANGE or UP event,
it became BOND_LINK_DOWN.
But if it was initially UP and bond_update_speed_duplex was unable to
get speed/duplex,
link became BOND_LINK_FAIL.

I don't understand a few things here:
How could a link be in a different state from time to time during the
first NETDEV_* event?
And why slave->last_link_up is set when the first NETDEV event occurs?

I hope I didn't messed things up too much here.

--=20
Best Regards,
Aleksei Zakharov
