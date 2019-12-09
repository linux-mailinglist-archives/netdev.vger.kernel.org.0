Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41998117477
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfLISlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:41:46 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:33938 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfLISlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:41:46 -0500
Received: by mail-yb1-f194.google.com with SMTP id k17so6537272ybp.1
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 10:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQ3aMk+oK75ql5g/SjLbPqsxxFSBaQXOeD7LuZbE4Gc=;
        b=JPGKUXeyFqKvK8qf6hee9JW0NIc2KxScSRdtRPwWxanOBNa5QaYvU5uRVJr5b2/T9P
         yDmXrS5iEUrZEWOo3ECWN81HIeZBWeTHEVavYVTGqYhS59IKzy80FZOJREK4HShAr2r7
         qrE1QrtNfewp66csddgduB9z+xU4XcMY6zE1K4HsQ15PPnh4oNcHft0VYVdnkTADXaqT
         YDMh+W5F1kmXklWvwiz0k8bO1wpVyWibs1aKSg021cJBFvC8o1wMHfSBhTC7i9/Bw3tZ
         3mTEQsBpHeVA7Wquz27SYSf9j3xPedMezzVLYAMEEFbHJcJXq48sRPm6RthBjrphXBkL
         mdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQ3aMk+oK75ql5g/SjLbPqsxxFSBaQXOeD7LuZbE4Gc=;
        b=I4bZMtIuI+qxcxpvd8wl3u0hJMUqEUfP5MVTrbLg/k9sim4rmf2LvabcbBI6KoNCKZ
         8I06nOyP476mGjQxPpWUn2rjwDTA3dDZXMWW3MZDlPDQU/iYEy5KCerRboe3oDVUUD/7
         QDraHtpnEJ9Yc0PXVnYpYkgCZDJiqStlBqReb/65qbMab8QNBUKKpSbtCsW4WWvjAn1G
         vpkQ2rQ6XZQCZ/khflt3r29qyEZcofn6+Om8BP2ZP18UIBhhSEfUd0M6d+Rsue6WZFN2
         X/qEbMqdrPQTyKaLzP3xR8xbgCYWyjG+AFlcALEPLPMwMqt7p2YogZe2gCANt/UqpFOm
         DEug==
X-Gm-Message-State: APjAAAXb8jYk+ougYxPJyJPhq+dL8YfdaJgeZrd4cV8k4siDTNeVgBYx
        ATtovLX/r5MpmpMSL4KnC+k6eBCRHi300GymMoEtRQ==
X-Google-Smtp-Source: APXvYqwc3HbTOPq2aozpp25ccRCbf4ILZqRQ5haw0uMV0vlfB2/z7Jgb+yy3xO/moFYS16Ap1F/WbBhciyG7oCX3U6Y=
X-Received: by 2002:a25:c887:: with SMTP id y129mr22417785ybf.335.1575916904201;
 Mon, 09 Dec 2019 10:41:44 -0800 (PST)
MIME-Version: 1.0
References: <20191206234455.213159-1-maheshb@google.com> <10902.1575756592@famine>
In-Reply-To: <10902.1575756592@famine>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 9 Dec 2019 10:41:28 -0800
Message-ID: <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link failure
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 7, 2019 at 2:09 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
>
> Mahesh Bandewar <maheshb@google.com> wrote:
>
> >After the recent fix 1899bb325149 ("bonding: fix state transition
> >issue in link monitoring"), the active-backup mode with miimon
> >initially come-up fine but after a link-failure, both members
> >transition into backup state.
> >
> >Following steps to reproduce the scenario (eth1 and eth2 are the
> >slaves of the bond):
> >
> >    ip link set eth1 up
> >    ip link set eth2 down
> >    sleep 1
> >    ip link set eth2 up
> >    ip link set eth1 down
> >    cat /sys/class/net/eth1/bonding_slave/state
> >    cat /sys/class/net/eth2/bonding_slave/state
> >
> >Fixes: 1899bb325149 ("bonding: fix state transition issue in link monitoring")
> >CC: Jay Vosburgh <jay.vosburgh@canonical.com>
> >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> >---
> > drivers/net/bonding/bond_main.c | 3 ---
> > 1 file changed, 3 deletions(-)
> >
> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index fcb7c2f7f001..ad9906c102b4 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -2272,9 +2272,6 @@ static void bond_miimon_commit(struct bonding *bond)
> >                       } else if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
> >                               /* make it immediately active */
> >                               bond_set_active_slave(slave);
> >-                      } else if (slave != primary) {
> >-                              /* prevent it from being the active one */
> >-                              bond_set_backup_slave(slave);
>
>         How does this fix things?  Doesn't bond_select_active_slave() ->
> bond_change_active_slave() set the backup flag correctly via a call to
> bond_set_slave_active_flags() when it sets a slave to be the active
> slave?  If this change resolves the problem, I'm not sure how this ever
> worked correctly, even prior to 1899bb325149.
>
Hi Jay, I used kprobes to figure out the brokenness this patch fixes.
Prior to your patch this call would not happen but with the patch,
this extra call will put the master into the backup mode erroneously
(in fact both members would be in backup state). The mechanics you
have mentioned works correctly except that in the prior case, the
switch statement was using new_link which was not same as
link_new_state. The miimon_inspect will update new_link which is what
was used in miimon_commit code. The link_new_state was used only to
mitigate the rtnl-lock issue which would update the "link". Hence in
the prior code, this path would never get executed.

The steps to reproduce this issue is straightforward and happens 100%
of the time (I used two mlx interfaces but that shouldn't matter).

thanks,
--mahesh..
>         -J
>
> >                       }
> >
> >                       slave_info(bond->dev, slave->dev, "link status definitely up, %u Mbps %s duplex\n",
> >--
> >2.24.0.393.g34dc348eaf-goog
> >
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
