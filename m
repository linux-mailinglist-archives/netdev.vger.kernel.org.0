Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63714D3236
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 16:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiCIPxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 10:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbiCIPwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 10:52:51 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B02C1385AF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 07:51:52 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id kt27so6150457ejb.0
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 07:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5WYatX5BcDS34L+5NFVGpEMCUHoTGtqJerpjSHgiIHU=;
        b=jjaVCuCGs1RjjrHnA2MsMdvcFNVj32nRMW0Jvua0upgxIGE9zlzRrciwRMcai//EVT
         Y3QLkx+IRlVkIj+NiTSGNNtkEDWyguh8CBENRMBHODvB/N1NS3yj8wAPVphHBE5CXD2Q
         iSoHrRvMM7qBalxoGWFevfWUbTah/hMTTB4KXFnZ1C7X3bt0mWQIRE2Xs+0T21Gk+/iQ
         68ToUAvZgRbj8qYBF3tDFi/ZDYRjeoczAo47sYnodIRo0V/81x975ckxBHclXREZUPNM
         ZvbHW2v+rWA7rFGWa/0LBhz89IrRvZwzfWtYES94+kzuFmHVPorRX1i4E1WakLjpjg31
         FsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5WYatX5BcDS34L+5NFVGpEMCUHoTGtqJerpjSHgiIHU=;
        b=JVQJBNSyonUbpmUNzxBi3+M0WlO63vPWpiiNw70v9Wt7WK4529dN6xLbsN3GYLIKWH
         lZwp3QRxGZZvYB7QNZa13qUc2kgg7d0unC5taLHGRITwDAMchftrPbxEeH+bsWqTnOW0
         qHIuTylHKb72pkDT83QQxGtU87Tpok3FE81c9IKAWIbXGHm6ImDA24pq6UFHRpTdA2+E
         7uesXnbv5naXg2qgutZtm8ilPRAqn97Qnt/GQCDiId/d4r3ipWXTkA1hnhFT8xuHHbiY
         MaskvSo1IfhZfH6g8WGYY8STyh96mmOJ6AGIvgmQlxgi1Ljldwrh/Sofjuk7OZgU9TUF
         UcuA==
X-Gm-Message-State: AOAM532Dwwhf8bQl2vVITovkrXqdEek3/tbxCcniwHbAnUI9VHLNxLpr
        63/qFbK4JcWkt7z7icP2l7sK8zvWm6w=
X-Google-Smtp-Source: ABdhPJypYhWwVdfuegKJFpOyNSIK5uKIOkpZrqWUhZ/G6B63HYoww3XCRBDvbY2Ckq1neyYJZXszWg==
X-Received: by 2002:a17:907:7da5:b0:6db:344:f5b3 with SMTP id oz37-20020a1709077da500b006db0344f5b3mr337771ejc.385.1646841110572;
        Wed, 09 Mar 2022 07:51:50 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm884218ejb.194.2022.03.09.07.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 07:51:49 -0800 (PST)
Date:   Wed, 9 Mar 2022 17:51:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: silence fdb errors when unsupported
Message-ID: <20220309155147.mdg34azyst4wwvfj@skbuf>
References: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
 <20220309104143.gmoks5aceq3dtmci@skbuf>
 <Yii3SH7/mF7QmXO1@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yii3SH7/mF7QmXO1@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 02:18:48PM +0000, Russell King (Oracle) wrote:
> On Wed, Mar 09, 2022 at 12:41:43PM +0200, Vladimir Oltean wrote:
> > Hello Russell,
> > 
> > On Wed, Mar 09, 2022 at 10:35:32AM +0000, Russell King (Oracle) wrote:
> > > When booting with a Marvell 88e6xxx switch, the kernel spits out a
> > > load of:
> > > 
> > > [    7.820996] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > [    7.835717] mv88e6085 f1072004.mdio-mii:04: port 2 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > [    7.851090] mv88e6085 f1072004.mdio-mii:04: port 1 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > [    7.968594] mv88e6085 f1072004.mdio-mii:04: port 0 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > [    8.035408] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ3 to fdb: -95
> > > 
> > > while the switch is being setup. Comments in the Marvell DSA driver
> > > indicate that "switchdev expects -EOPNOTSUPP to honor software VLANs"
> > > in mv88e6xxx_port_db_load_purge() so this error code should not be
> > > treated as an error.
> > > 
> > > Fixes: 3dc80afc5098 ("net: dsa: introduce a separate cross-chip notifier type for host FDBs")
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > ---
> > > Hi,
> > > 
> > > I noticed these errors booting 5.16 on my Clearfog platforms with a
> > > Marvell DSA switch. It appears that the switch continues to work
> > > even though these errors are logged in the kernel log, so this patch
> > > merely silences the errors, but I'm unsure this is the right thing
> > > to do.
> > 
> > Can you please confirm that these errors have disappeared on net-next?
> 
> net-next: no warnings
> v5.17-rc7: warnings
> v5.16: warnings

Thanks. This means it was solved by this patch set, which had the exact
same symptoms:
https://patchwork.kernel.org/project/netdevbpf/cover/20220215170218.2032432-1-vladimir.oltean@nxp.com/
The cover letter and commit messages provide a full description of what
was wrong, has been wrong/a limitation for years, and give a sense of
why that work cannot be backported to v5.16, since it implies a
non-trivial amount of changes to the bridge driver, to switchdev and to
DSA.

> So, it looks like we need a patch for 5.17-rc7 and 5.16-stable to fix
> this. Do you have a better suggestion than my patch?

So to answer the question first, then to explain.

My better suggestion, taking into consideration more factors, is to
drop this patch and leave the code as it is.

The comment in the Marvell DSA driver, which you cited:

mv88e6xxx_port_db_load_purge:
	/* switchdev expects -EOPNOTSUPP to honor software VLANs */
	if (!vlan.valid)
		return -EOPNOTSUPP;

is a logical fallacy.

Fact: the bridge does _not_ check errors from br_switchdev_fdb_notify().
Not only that, but there isn't even any mechanism in place today such
that this would be possible. Otherwise, myself, Nikolay and Ido wouldn't
have been unsuccessfully scrambling for several months to address that
limitation (actually mostly me, but they were the direct victims of
trying to review my attempts):
https://patchwork.kernel.org/project/netdevbpf/cover/20211025222415.983883-1-vladimir.oltean@nxp.com/

So if switchdev is not aware of mv88e6xxx returning -EOPNOTSUPP from a
work item that is scheduled from the SWITCHDEV_FDB_ADD_TO_DEVICE atomic
handler, then logically, switchdev cannot anything from -EOPNOTSUPP.
This error code has no special meaning.

Note that there was a second call path to drivers' ds->ops->port_fdb_add(),
from the DSA slave's ndo_fdb_add, and that did propagate errors. But
that is "bridge bypass", not switchdev, and for doing more harm than
good, support for it was removed in commit b117e1e8a86d ("net: dsa:
delete dsa_legacy_fdb_add and dsa_legacy_fdb_del"). Not only is this
call path no longer present today, but -EOPNOTSUPP isn't a special error
code there, either.

Having said this, the initiator of the call path which fails with
-EOPNOTSUPP in mv88e6xxx_port_db_load_purge() is the bridge driver,
via switchdev.

The mv88e6xxx driver, via that check, essentially expects that the VID
from the FDB entry has been previously mapped in the VTU.

The bridge driver already ensures that the VLAN structure has been
created, before any FDB entries can be added in that VLAN. This is
proven by the attempt below to add an FDB entry in VLAN 5, in bridge
port swp0:

root@debian:~# bridge fdb add dev swp0 static master 00:01:02:03:04:05 vlan 5
[109407.613593] bridge: RTM_NEWNEIGH with unconfigured vlan 5 on swp0
RTNETLINK answers: Invalid argument
root@debian:~# bridge vlan
port    vlan ids
swp0     1 PVID Egress Untagged

br0      1 PVID Egress Untagged

root@debian:~# bridge link
9: swp0@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 4

So the sanity check captures what is essentially an invalid condition.
If the bridge notifies an FDB entry in a VLAN that isn't present in the
VTU, this is a bug.

Now on to my point. There is a trade-off to be made between things
running apparently smoothly and running correctly.

Since the DSA switchdev work item is the final entity that sees error
codes propagated from the driver, I find it valuable that these error
codes are not hidden in any way. I do not have access to all hardware,
I cannot foresee all code paths, but yet, users who notice errors in the
kernel log report these problems, we look into them and we fix them.
In fact, this is exactly the way in which Rafael pointed out to me the
mv88e6xxx issue, and this led to the aforementioned bridge/switchdev/DSA
rework. It is a process that works, and I would like it to not be
disrupted.

This isn't to say that there is no argument to be made for hiding these
error messages. There is a possibility that I might agree with silencing
some errors in some cases, but I have not heard a compelling argument
for that. Also, with mv88e6xxx and systemd-networkd, it isn't even the
first warning/error of its kind that gets printed by this driver out of
the blue. The driver also warns when systemd-networkd reinitializes
bridge VLANs on ports, stating that "port X already a member of VLAN y".
So I believe that mv88e6xxx users already have some tolerance for
non-fatal warnings. These latter warnings, by the way, have also
disappeared as a result of the patch set I linked in the beginning.

Therefore, I think it is in the best interest of the code base for users
to report the problems they see, instead of masking them. This means
walking through potentially known and already fixed problems/limitations,
debugging, explaining, testing, writing long emails etc, but I prefer
this to the alternative of cutting myself from a potentially valid
source of information.
