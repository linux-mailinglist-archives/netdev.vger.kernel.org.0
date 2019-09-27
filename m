Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0408C03DF
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 13:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfI0LOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 07:14:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:47047 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfI0LOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 07:14:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id u22so6685052qtq.13
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 04:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=selectel-ru.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yofo8G+8whGfF2drnRBH429blAZxPz6+/IHrpaWevyo=;
        b=fBNs0wyjvqeHPXWIqQz1k4iRtsiwGlFzQEDMdoDtfEGdlsjVtVKXJfEqmSjBJL/XFP
         1iZwt/BeGh3vv++ggBYw3TWL1NaEHkICSPtakhcMcSjT5/49kp9+RWI3IMQy/9Q7e+oH
         Vi1jDXKH2hwZEVVCdbvXivqUgvBVl1YIbHWYLog1fjXq8DNt6yEMq1sewkv2h/Temf+u
         ITn7M/0lNUhFA42dbp07BD2tPu1SvUgK93uKvNFs9K56ZcTna4qwiLJ8wyPOfjMrve7Y
         vuFNRqa3T/mXBTFktnvNBqZ20OyRpY+UPG8ZA2M6Iozzb+AwSAPreSFZJ68fsRHPT1hF
         dlRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yofo8G+8whGfF2drnRBH429blAZxPz6+/IHrpaWevyo=;
        b=QZ6UkZ/804I8UyqSYNIA2pakTmYjCiY7Tz6EmGOZSqk4s3sTadsawFdG66/LnVflnl
         mNWfztPIIlwRp8tkamTllBzFJ9QH5hcK5m6gVyEaGLJgSCYuMMHdK5SRRLmnSWQdvDnO
         gXQir+ppzrhCV7UsSUm+R5x8+42lTDQ7HTTnoZNWQH7hCpgGOHqV6I6vooabvSVLKMm8
         FRG4QMIlQdfuX4HW4+qliOXOJsozKsIA3ahB83pfGnSiHqBQ3LaiFiBXaRXlBR2cimYD
         3n42wEbZwO61dlI0WP2x6kI8QUTQOM7DlqCojH/Mm0r0BDAHg5ANocR6+bDqsWitViwS
         3v3Q==
X-Gm-Message-State: APjAAAXD1dlbXEd70kvUwS/uRwavBchQ/dyM16Zl9nSTy9PtBZJH1oVo
        Ij9qEosh8G1F+u6cP0lZn3W2DKoZkMONfypsGrO4FBHFTS+5og==
X-Google-Smtp-Source: APXvYqz0ZA4GSXEwkDOLifM/tWbcSw20Mvx+oztighAHK0oMXMie39vTs7ABPCeWdME0fDBGSsGT/IFFF7OuNrrxejs=
X-Received: by 2002:ac8:6d03:: with SMTP id o3mr8861069qtt.97.1569582873532;
 Fri, 27 Sep 2019 04:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190918130545.GA11133@yandex.ru> <31893.1568817274@nyx>
 <CAJYOGF9KZdouvmTxQcTOQgsi-uBxbvW50K3ufW1=8neeW98QVA@mail.gmail.com>
 <CAJYOGF8LDwbZXXeEioKAtx=0rq9eZBxFYuRfF3jdFCDUGnJ-Rg@mail.gmail.com>
 <9357.1568880036@nyx> <CAJYOGF87z-o9=a20dC2mZRtfMU58uL0yxZkQJ-bxe5skVvi2rA@mail.gmail.com>
 <7236.1568906827@nyx> <7154.1568987531@nyx> <CAJYOGF-L0bEF_BqbyeKqv4xmLV=e2VKUvo5zPx4rULWdwt8e0Q@mail.gmail.com>
 <10497.1569049560@nyx> <CAJYOGF_XStpFRkp0jN0um9d9WR1bqGpK2V=UgdnnX2m4YC=5pw@mail.gmail.com>
 <16538.1569371467@famine> <CAJYOGF9TY8WtUscsfJ=qduAw7_1BwU+4iE+eL6cidM=LBL9w+A@mail.gmail.com>
 <15507.1569472734@nyx> <CAJYOGF-84BfK8DvAnam9+tgfo4=oBs04zF-ETWRfhz7CE_9oBA@mail.gmail.com>
 <23353.1569528114@nyx>
In-Reply-To: <23353.1569528114@nyx>
From:   Aleksei Zakharov <zaharov@selectel.ru>
Date:   Fri, 27 Sep 2019 14:14:22 +0300
Message-ID: <CAJYOGF_jq8b=FS6+8gCkbELw-A-2WtjkdjHU3-Rt+L1YBFtGgQ@mail.gmail.com>
Subject: Re: Fwd: [PATCH] bonding/802.3ad: fix slave initialization states race
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "zhangsha (A)" <zhangsha.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 23:01, Jay V=
osburgh <jay.vosburgh@canonical.com>:
>
> Aleksei Zakharov <zaharov@selectel.ru> wrote:
>
> >=D1=87=D1=82, 26 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 07:38, Ja=
y Vosburgh <jay.vosburgh@canonical.com>:
> >>
> >> Aleksei Zakharov <zaharov@selectel.ru> wrote:
> >>
> >> >=D1=81=D1=80, 25 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 03:31,=
 Jay Vosburgh <jay.vosburgh@canonical.com>:
> >> >>
> >> >> =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 =D0=97=D0=B0=D1=85=D0=B0=
=D1=80=D0=BE=D0=B2 wrote:
> >> >> [...]
> >> >> >Right after reboot one of the slaves hangs with actor port state 7=
1
> >> >> >and partner port state 1.
> >> >> >It doesn't send lacpdu and seems to be broken.
> >> >> >Setting link down and up again fixes slave state.
> >> >> [...]
> >> >>
> >> >>         I think I see what failed in the first patch, could you tes=
t the
> >> >> following patch?  This one is for net-next, so you'd need to again =
swap
> >> >> slave_err / netdev_err for the Ubuntu 4.15 kernel.
> >> >>
> >> >I've tested new patch. It seems to work. I can't reproduce the bug
> >> >with this patch.
> >> >There are two types of messages when link becomes up:
> >> >First:
> >> >bond-san: EVENT 1 llu 4294895911 slave eth2
> >> >8021q: adding VLAN 0 to HW filter on device eth2
> >> >bond-san: link status definitely down for interface eth2, disabling i=
t
> >> >mlx4_en: eth2: Link Up
> >> >bond-san: EVENT 4 llu 4294895911 slave eth2
> >> >bond-san: link status up for interface eth2, enabling it in 500 ms
> >> >bond-san: invalid new link 3 on slave eth2
> >> >bond-san: link status definitely up for interface eth2, 10000 Mbps fu=
ll duplex
> >> >Second:
> >> >bond-san: EVENT 1 llu 4295147594 slave eth2
> >> >8021q: adding VLAN 0 to HW filter on device eth2
> >> >mlx4_en: eth2: Link Up
> >> >bond-san: EVENT 4 llu 4295147594 slave eth2
> >> >bond-san: link status up again after 0 ms for interface eth2
> >> >bond-san: link status definitely up for interface eth2, 10000 Mbps fu=
ll duplex
> >> > [...]
> >>
> >>         The "invalid new link" is appearing because bond_miimon_commit
> >> is being asked to commit a new state that isn't UP or DOWN (3 is
> >> BOND_LINK_BACK).  I looked through the patched code today, and I don't
> >> see a way to get to that message with the new link set to 3, so I'll a=
dd
> >> some instrumentation and send out another patch to figure out what's
> >> going on, as that shouldn't happen.
> >>
> >>         I don't see the "invalid" message testing locally, I think
> >> because my network device doesn't transition to carrier up as quickly =
as
> >> yours.  I thought you were getting BOND_LINK_BACK passed through from
> >> bond_enslave (which calls bond_set_slave_link_state, which will set
> >> link_new_link to BOND_LINK_BACK and leave it there), but the
> >> link_new_link is reset first thing in bond_miimon_inspect, so I'm not
> >> sure how it gets into bond_miimon_commit (I'm thinking perhaps a
> >> concurrent commit triggered by another slave, which then picks up this
> >> proposed link state change by happenstance).
> >I assume that "invalid new link" happens in this way:
> >Interface goes up
> >NETDEV_CHANGE event occurs
> >bond_update_speed_duplex fails
> >and slave->last_link_up returns true
> >slave->link becomes BOND_LINK_FAIL
> >bond_check_dev_link returns 0
> >miimon proposes slave->link_new_state BOND_LINK_DOWN
> >NETDEV_UP event occurs
> >miimon sets commit++
> >miimon proposes slave->link_new_state BOND_LINK_BACK
> >miimon sets slave->link to BOND_LINK_BACK
>
>         I removed the "proposes link_new_state BOND_LINK_BACK" from the
> second test patch and replaced it with the slave->link =3D BOND_LINK_BACK=
.
> This particular place in the code also does not do commit++.  If you
> have both of those in the code you're running, then perhaps you have a
> merge error or some such.
You are right, it was a merge issue.
I re-applied the patch and now it works without any error messages.
As usual, there are two types of messages.
This one is less often:
bond-san: EVENT 1 llu 4295238188 slave eth2
8021q: adding VLAN 0 to HW filter on device eth2
mlx4_en: eth2: Link Up
bond-san: EVENT 4 llu 4295238188 slave eth2
bond-san: link status up again after 0 ms for interface eth2
bond-san: link status definitely up for interface eth2, 10000 Mbps full dup=
lex

And this one is more often:
bond-san: EVENT 1 llu 4295242465 slave eth2
8021q: adding VLAN 0 to HW filter on device eth2
bond-san: link status definitely down for interface eth2, disabling it
mlx4_en: eth2: Link Up
bond-san: EVENT 4 llu 4295242465 slave eth2
bond-san: link status up for interface eth2, enabling it in 500 ms
bond-san: link status definitely up for interface eth2, 10000 Mbps full dup=
lex

Bonding works as expected in both cases.

>
> [...]
> >
> >I don't understand a few things here:
> >How could a link be in a different state from time to time during the
> >first NETDEV_* event?
>
>         I'm not sure; possibly a race between the events in the kernel
> and how long it takes for the hardware to establish Ethernet link up.
>
> >And why slave->last_link_up is set when the first NETDEV event occurs?
>
>         slave->last_link_up can be set at enslave time if the carrier
> state of the slave (and thus the initial slave->link) is in a not-down
> state.  There are some paths as well for modes that have an "active"
> slave, but 802.3ad is not one of those.
Thanks for the explanation!

--=20
Best Regards,
Aleksei Zakharov
System administrator
