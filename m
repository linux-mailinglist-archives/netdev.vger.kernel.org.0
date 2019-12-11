Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D661711BDAF
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfLKULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:11:01 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38929 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfLKULB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 15:11:01 -0500
Received: by mail-yw1-f66.google.com with SMTP id h126so9455959ywc.6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 12:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cCfoBb4p0rMq6aMO+6a1gck2EuzT/hDrha2okw7lyUI=;
        b=NM7o4Ej3LM4FcnHl6ScviyvryVMCR2HSapNqgK0eYxJpIUxLJJmaYxBL6K+IsM+PpX
         Dp4/XEGhrTbY5i3Z0bCgANgIjaDovb8aPFBNuYsnzLT+5d249wdQUEUu6KVv7scdM0Mr
         n59pd1ljv51yoRlrlP2t0yhTcy4+j/vsCkftQH4T4RCeu0kevccJsza1vHtwmlwGcFkL
         s+KnkHvo85tC4AFwGnutYMxdssncOqqsLzPF/pT0/DeJ5lA8y1WC1QJPGYbSC1DHrl77
         tVeu/AsNzz+bRNgfxRJaE/56AX3mebLJO0Rs6xFzg9LQjkkTo3rOj9e61yJeMM8tbVQy
         xbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cCfoBb4p0rMq6aMO+6a1gck2EuzT/hDrha2okw7lyUI=;
        b=M6vodZ1EdHPfj2HFkkxmumbywZ6zXU80MyppxAzCHeaSjSgrGpH9LFOewbTYaTFfG+
         lZ5W7VpOz+TJLvPNsdezNsXmn+dRTLopVtIp4SFexjKQJz6fsKz3ripC53DqR+QAFE7v
         Q11mANXYfJNqBIDU1ZP6uCTsd9yNLdwgGv7fiOA5O3G48TAnVJaEgbhsIdtQ9/PgRPn9
         agjfCHoxSNZZwD5fDF7Vi1Gykevob7U0Czj8X+HQcsbbtjy18egIBiQilLQDVguc1Mky
         cs+gKdYjUbrHk32vuJhbvO41+/Uaaam1NHXvL2h6Jkl05be7CHW89vv/6vQj9qWegunE
         V7Bw==
X-Gm-Message-State: APjAAAWGRWsr/RM6XMAKCkBMiqHszVOXz14eJFkyZxBzq3smbusxlLsB
        JmCoDMh/GbWMFxuJP/iqK//cUV6Emlv4qqspa2a1wg==
X-Google-Smtp-Source: APXvYqzomibnKcQG3mGf87oZ8780L4ewhWiLiWORzwWaTubFRi3QM+c41fOOpo3Rq/dADpp6xkb7Tf7ouns8vNFKPH0=
X-Received: by 2002:a81:4846:: with SMTP id v67mr1190008ywa.459.1576095059889;
 Wed, 11 Dec 2019 12:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20191206234455.213159-1-maheshb@google.com> <10902.1575756592@famine>
 <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
In-Reply-To: <CAF2d9jgjeky0eMgwFZKHO_RLTBNstH1gCq4hn1FfO=TtrMP1ow@mail.gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Wed, 11 Dec 2019 12:10:43 -0800
Message-ID: <CAF2d9jhg1jb1=AKzYNDC2bu43zx8Ob-exDxk6190LKZnPBDaqQ@mail.gmail.com>
Subject: Re: [PATCH net] bonding: fix active-backup transition after link failure
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 10:41 AM Mahesh Bandewar (=E0=A4=AE=E0=A4=B9=E0=A5=
=87=E0=A4=B6 =E0=A4=AC=E0=A4=82=E0=A4=A1=E0=A5=87=E0=A4=B5=E0=A4=BE=E0=A4=
=B0)
<maheshb@google.com> wrote:
>
> On Sat, Dec 7, 2019 at 2:09 PM Jay Vosburgh <jay.vosburgh@canonical.com> =
wrote:
> >
> > Mahesh Bandewar <maheshb@google.com> wrote:
> >
> > >After the recent fix 1899bb325149 ("bonding: fix state transition
> > >issue in link monitoring"), the active-backup mode with miimon
> > >initially come-up fine but after a link-failure, both members
> > >transition into backup state.
> > >
> > >Following steps to reproduce the scenario (eth1 and eth2 are the
> > >slaves of the bond):
> > >
> > >    ip link set eth1 up
> > >    ip link set eth2 down
> > >    sleep 1
> > >    ip link set eth2 up
> > >    ip link set eth1 down
> > >    cat /sys/class/net/eth1/bonding_slave/state
> > >    cat /sys/class/net/eth2/bonding_slave/state
> > >
> > >Fixes: 1899bb325149 ("bonding: fix state transition issue in link moni=
toring")
> > >CC: Jay Vosburgh <jay.vosburgh@canonical.com>
> > >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > >---
> > > drivers/net/bonding/bond_main.c | 3 ---
> > > 1 file changed, 3 deletions(-)
> > >
> > >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bon=
d_main.c
> > >index fcb7c2f7f001..ad9906c102b4 100644
> > >--- a/drivers/net/bonding/bond_main.c
> > >+++ b/drivers/net/bonding/bond_main.c
> > >@@ -2272,9 +2272,6 @@ static void bond_miimon_commit(struct bonding *b=
ond)
> > >                       } else if (BOND_MODE(bond) !=3D BOND_MODE_ACTIV=
EBACKUP) {
> > >                               /* make it immediately active */
> > >                               bond_set_active_slave(slave);
> > >-                      } else if (slave !=3D primary) {
> > >-                              /* prevent it from being the active one=
 */
> > >-                              bond_set_backup_slave(slave);
> >
> >         How does this fix things?  Doesn't bond_select_active_slave() -=
>
> > bond_change_active_slave() set the backup flag correctly via a call to
> > bond_set_slave_active_flags() when it sets a slave to be the active
> > slave?  If this change resolves the problem, I'm not sure how this ever
> > worked correctly, even prior to 1899bb325149.
> >
> Hi Jay, I used kprobes to figure out the brokenness this patch fixes.
> Prior to your patch this call would not happen but with the patch,
> this extra call will put the master into the backup mode erroneously
> (in fact both members would be in backup state). The mechanics you
> have mentioned works correctly except that in the prior case, the
> switch statement was using new_link which was not same as
> link_new_state. The miimon_inspect will update new_link which is what
> was used in miimon_commit code. The link_new_state was used only to
> mitigate the rtnl-lock issue which would update the "link". Hence in
> the prior code, this path would never get executed.
>
> The steps to reproduce this issue is straightforward and happens 100%
> of the time (I used two mlx interfaces but that shouldn't matter).
>
A friendly ping.

> thanks,
> --mahesh..
> >         -J
> >
> > >                       }
> > >
> > >                       slave_info(bond->dev, slave->dev, "link status =
definitely up, %u Mbps %s duplex\n",
> > >--
> > >2.24.0.393.g34dc348eaf-goog
> > >
> >
> > ---
> >         -Jay Vosburgh, jay.vosburgh@canonical.com
