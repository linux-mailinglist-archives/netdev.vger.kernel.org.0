Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FD2B9D2D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgKSVvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgKSVvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 16:51:12 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DA0C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:51:12 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id r9so10471510lfn.11
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 13:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=FqHFdAKYUfYkHxVShEHdSgGy2326k7gJbRPGeQmqbF4=;
        b=ZiE3I+tFcuRpn16OLWsH0ihrq/SsAkP6N2lhfpCb6AOsP4qaj1NOmYHJmDJ4DC0PDp
         XGAAxMhT/Wo7bIYwHFfBqCqUAi3EZVKKCL/P5ypWaTOSTFPcg+yjqmoPjA7dljfcIXuY
         y9tQAGAYPUcIt9PNFszZHBok0kdmAtfkKtet5oPLieXbUsNFmISUAUIpRQtIoejE/C60
         C+iPmkuXwnFTc1LkECa12ceo4oOV4/Kp6BLWyBY6LJdVTffasyYvEq3IitpvbI99SSXe
         gm0s8BEQqTXbuTwcjnF13uieNTQULcO8RmA5yRHpoXvq/1n98G3ANqDR8/9lqydoR1jV
         PurA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=FqHFdAKYUfYkHxVShEHdSgGy2326k7gJbRPGeQmqbF4=;
        b=Ngq2ujIHJ7wHOqj99xJmA/GYrf5PHB7Ut9O0XI/AoHiicXcaKdIwPt+wb+xz3HvK6o
         z2tR2VBncMrPuslredkwpn7REJ0k0O00jD6Ta9PhKnblE7/DbDGSbliCAetvDPyI0HkC
         t/crjKrXORq35C4TMLpclxr30+oWdKOgmrwjkszKemApKKCq9xpIA+fa3cxZ9ev6ERaF
         mEvpsilg6lk887biZqqc+rd755sqLhVrQ3+4hgxe1rIH3pROqJ1vVsc5OFCsuinI/02N
         +cidc1eRImaEsS8qd2LpnOLbOuY9K643ilS/9f+0O9q+wmk7S7Q+UNNnJPWtpuwIfJId
         Sq0w==
X-Gm-Message-State: AOAM532L4pu9p7WdbETb6VTLQzOwIESIxYxge4saxT5J5zYzvx1Ai3sS
        QOvHVUsXF0k6/lOMc4q3Eu9F3w==
X-Google-Smtp-Source: ABdhPJykCZJ640TvBl3x3mmqUyEQtzeQO16eYZuSyOG3LY4smsCoCfsuhyKSkxH00/YgpcEdx/sJqQ==
X-Received: by 2002:ac2:48b2:: with SMTP id u18mr7365952lfg.313.1605822670602;
        Thu, 19 Nov 2020 13:51:10 -0800 (PST)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id m25sm104107lfh.205.2020.11.19.13.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 13:51:09 -0800 (PST)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: bonding: Notify ports about their
 initial state
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Jay Vosburgh" <jay.vosburgh@canonical.com>
Date:   Thu, 19 Nov 2020 22:20:34 +0100
Message-Id: <C77JZ7DZY2HY.2AZ4GY41QWUGY@wkz-x280>
In-Reply-To: <365.1605809882@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Nov 19, 2020 at 11:18 AM CET, Jay Vosburgh wrote:
> Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
> >When creating a static bond (e.g. balance-xor), all ports will always
> >be enabled. This is set, and the corresponding notification is sent
> >out, before the port is linked to the bond upper.
> >
> >In the offloaded case, this ordering is hard to deal with.
> >
> >The lower will first see a notification that it can not associate with
> >any bond. Then the bond is joined. After that point no more
> >notifications are sent, so all ports remain disabled.
>
> Why are the notifications generated in __netdev_upper_dev_link
> (via bond_master_upper_dev_link) not sufficient?

That notification only lets the switchdev driver know that the port is
now a part of the bond; it says nothing about if the port is in the
active transmit set or not.

That notification actually is sent. Unfortunately this happens before
the event your referencing, in the `switch (BOND_MODE(bond))` section
just a few lines above. Essentially the conversation goes like this:

bond0: swp0 has link and is in the active tx set.
dsa:   Cool, but swp0 is not a part of any LAG afaik; ignore.
bond0: swp0 is now a part of bond0.
dsa:   OK, I'll set up the hardware, setting swp0 as inactive initially.

This change just repeats the initial message at the end when the
driver can make sense of it. Without it, modes that default ports to
be inactive (e.g. LACP) still work, as the driver and the bond agree
on the initial state in those cases. But for a static LAG, there will
never be another event (until the link fails).

> >This change simply sends an extra notification once the port has been
> >linked to the upper to synchronize the initial state.
> >
> >Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >---
> > drivers/net/bonding/bond_main.c | 2 ++
> > 1 file changed, 2 insertions(+)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_=
main.c
> >index 71c9677d135f..80c164198dcf 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -1897,6 +1897,8 @@ int bond_enslave(struct net_device *bond_dev, stru=
ct net_device *slave_dev,
> > 		goto err_unregister;
> > 	}
> >=20
> >+	bond_lower_state_changed(new_slave);
> >+
> > 	res =3D bond_sysfs_slave_add(new_slave);
> > 	if (res) {
> > 		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add=
\n", res);
>
> Would it be better to add this call further down, after all
> possible failures have been checked? I.e., if this new call to
> bond_lower_state_changed() completes, and then very soon afterwards the
> upper is unlinked, could that cause any issues?

All the work of configuring the LAG offload is done in the
notification send out by netdev_upper_dev_link. So that will all have
to be torn down in that case no matter where we place this call.

So from the DSA/switchdev point-of-view, I would say no, and I believe
these are the only consumers of the events.

Additionally, I think it makes sense to place the call as early as
possible as that means you have a smaller window of time where the
bond and the switchdev driver may disagree on the port's state.
