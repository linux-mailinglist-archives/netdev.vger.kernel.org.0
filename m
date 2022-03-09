Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6ABE4D3371
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbiCIQKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiCIQI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:08:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BD31405D9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xy18XAXlCHR9x7oMBVka0YO00HEZM0Vq+q0SchljFhQ=; b=Lc9MUq2AgQ2uIH9wG9ddEfaSuf
        5IsIn3gjrvqKPC8Qe60Isdc4c04glt7dR6VTwaakVPcXx5pHO5Li8Mpvl8fwqcbASl7RI1CW4Xqcz
        y5oNRKBhk2mzBUC3fWn07d+6h/vxdxrt9ShiXJ6R2snfzpVKnuo9vI9arTyHFlI7qFTWE5U4mN9rR
        phT/EW6xVocY2xKPhxATrm1eQ3V3LF42JWnbCGnMCot1J9CSuAey1plVGlrsciS9C+NA0i6qSx6YE
        tfrYL7eZKXJgHU0MeI5sjgRgKjqTymJB8nsvpPdpNxB7ZbcX5yTn2czPgsCiHFFc6VMDh77Lp6GcO
        KRyfOfsw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57746)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nRypF-00024j-Ni; Wed, 09 Mar 2022 16:06:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nRypE-00084L-20; Wed, 09 Mar 2022 16:06:08 +0000
Date:   Wed, 9 Mar 2022 16:06:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: silence fdb errors when unsupported
Message-ID: <YijQcD3B1Hetq+pZ@shell.armlinux.org.uk>
References: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
 <20220309104143.gmoks5aceq3dtmci@skbuf>
 <Yii3SH7/mF7QmXO1@shell.armlinux.org.uk>
 <20220309155147.mdg34azyst4wwvfj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309155147.mdg34azyst4wwvfj@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 05:51:47PM +0200, Vladimir Oltean wrote:
> On Wed, Mar 09, 2022 at 02:18:48PM +0000, Russell King (Oracle) wrote:
> > On Wed, Mar 09, 2022 at 12:41:43PM +0200, Vladimir Oltean wrote:
> > > Hello Russell,
> > > 
> > > On Wed, Mar 09, 2022 at 10:35:32AM +0000, Russell King (Oracle) wrote:
> > > > When booting with a Marvell 88e6xxx switch, the kernel spits out a
> > > > load of:
> > > > 
> > > > [    7.820996] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > [    7.835717] mv88e6085 f1072004.mdio-mii:04: port 2 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > [    7.851090] mv88e6085 f1072004.mdio-mii:04: port 1 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > [    7.968594] mv88e6085 f1072004.mdio-mii:04: port 0 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > [    8.035408] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ3 to fdb: -95
> > > > 
> > > > while the switch is being setup. Comments in the Marvell DSA driver
> > > > indicate that "switchdev expects -EOPNOTSUPP to honor software VLANs"
> > > > in mv88e6xxx_port_db_load_purge() so this error code should not be
> > > > treated as an error.
> > > > 
> > > > Fixes: 3dc80afc5098 ("net: dsa: introduce a separate cross-chip notifier type for host FDBs")
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > > > Hi,
> > > > 
> > > > I noticed these errors booting 5.16 on my Clearfog platforms with a
> > > > Marvell DSA switch. It appears that the switch continues to work
> > > > even though these errors are logged in the kernel log, so this patch
> > > > merely silences the errors, but I'm unsure this is the right thing
> > > > to do.
> > > 
> > > Can you please confirm that these errors have disappeared on net-next?
> > 
> > net-next: no warnings
> > v5.17-rc7: warnings
> > v5.16: warnings
> 
> Thanks. This means it was solved by this patch set, which had the exact
> same symptoms:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220215170218.2032432-1-vladimir.oltean@nxp.com/
> The cover letter and commit messages provide a full description of what
> was wrong, has been wrong/a limitation for years, and give a sense of
> why that work cannot be backported to v5.16, since it implies a
> non-trivial amount of changes to the bridge driver, to switchdev and to
> DSA.
> 
> > So, it looks like we need a patch for 5.17-rc7 and 5.16-stable to fix
> > this. Do you have a better suggestion than my patch?
> 
> So to answer the question first, then to explain.
> 
> My better suggestion, taking into consideration more factors, is to
> drop this patch and leave the code as it is.
> 
> The comment in the Marvell DSA driver, which you cited:
> 
> mv88e6xxx_port_db_load_purge:
> 	/* switchdev expects -EOPNOTSUPP to honor software VLANs */
> 	if (!vlan.valid)
> 		return -EOPNOTSUPP;
> 
> is a logical fallacy.
> 
> Fact: the bridge does _not_ check errors from br_switchdev_fdb_notify().
> Not only that, but there isn't even any mechanism in place today such
> that this would be possible. Otherwise, myself, Nikolay and Ido wouldn't
> have been unsuccessfully scrambling for several months to address that
> limitation (actually mostly me, but they were the direct victims of
> trying to review my attempts):
> https://patchwork.kernel.org/project/netdevbpf/cover/20211025222415.983883-1-vladimir.oltean@nxp.com/
> 
> So if switchdev is not aware of mv88e6xxx returning -EOPNOTSUPP from a
> work item that is scheduled from the SWITCHDEV_FDB_ADD_TO_DEVICE atomic
> handler, then logically, switchdev cannot anything from -EOPNOTSUPP.
> This error code has no special meaning.
> 
> Note that there was a second call path to drivers' ds->ops->port_fdb_add(),
> from the DSA slave's ndo_fdb_add, and that did propagate errors. But
> that is "bridge bypass", not switchdev, and for doing more harm than
> good, support for it was removed in commit b117e1e8a86d ("net: dsa:
> delete dsa_legacy_fdb_add and dsa_legacy_fdb_del"). Not only is this
> call path no longer present today, but -EOPNOTSUPP isn't a special error
> code there, either.
> 
> Having said this, the initiator of the call path which fails with
> -EOPNOTSUPP in mv88e6xxx_port_db_load_purge() is the bridge driver,
> via switchdev.
> 
> The mv88e6xxx driver, via that check, essentially expects that the VID
> from the FDB entry has been previously mapped in the VTU.
> 
> The bridge driver already ensures that the VLAN structure has been
> created, before any FDB entries can be added in that VLAN. This is
> proven by the attempt below to add an FDB entry in VLAN 5, in bridge
> port swp0:
> 
> root@debian:~# bridge fdb add dev swp0 static master 00:01:02:03:04:05 vlan 5
> [109407.613593] bridge: RTM_NEWNEIGH with unconfigured vlan 5 on swp0
> RTNETLINK answers: Invalid argument
> root@debian:~# bridge vlan
> port    vlan ids
> swp0     1 PVID Egress Untagged
> 
> br0      1 PVID Egress Untagged
> 
> root@debian:~# bridge link
> 9: swp0@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 4
> 
> So the sanity check captures what is essentially an invalid condition.
> If the bridge notifies an FDB entry in a VLAN that isn't present in the
> VTU, this is a bug.
> 
> Now on to my point. There is a trade-off to be made between things
> running apparently smoothly and running correctly.
> 
> Since the DSA switchdev work item is the final entity that sees error
> codes propagated from the driver, I find it valuable that these error
> codes are not hidden in any way. I do not have access to all hardware,
> I cannot foresee all code paths, but yet, users who notice errors in the
> kernel log report these problems, we look into them and we fix them.
> In fact, this is exactly the way in which Rafael pointed out to me the
> mv88e6xxx issue, and this led to the aforementioned bridge/switchdev/DSA
> rework. It is a process that works, and I would like it to not be
> disrupted.
> 
> This isn't to say that there is no argument to be made for hiding these
> error messages. There is a possibility that I might agree with silencing
> some errors in some cases, but I have not heard a compelling argument
> for that. Also, with mv88e6xxx and systemd-networkd, it isn't even the
> first warning/error of its kind that gets printed by this driver out of
> the blue. The driver also warns when systemd-networkd reinitializes
> bridge VLANs on ports, stating that "port X already a member of VLAN y".
> So I believe that mv88e6xxx users already have some tolerance for
> non-fatal warnings. These latter warnings, by the way, have also
> disappeared as a result of the patch set I linked in the beginning.
> 
> Therefore, I think it is in the best interest of the code base for users
> to report the problems they see, instead of masking them. This means
> walking through potentially known and already fixed problems/limitations,
> debugging, explaining, testing, writing long emails etc, but I prefer
> this to the alternative of cutting myself from a potentially valid
> source of information.

So, to summarise your very verbose email.

5.13 didn't spit out these errors.

Changes happened between 5.13 and 5.16 that exposed these errors and
the errors continue to be exposed in 5.17, leading users to panic
believing that something is wrong.

You don't want to hide the errors.

It will be fixed in 5.18.

Thanks, but I think I'll keep my patch in my tree so I don't have to
look at a meaningless error that doesn't appear to affect operation.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
