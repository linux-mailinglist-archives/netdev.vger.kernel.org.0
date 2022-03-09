Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26F24D34A0
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiCIQZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238165AbiCIQVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:30 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5AE148939
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:19:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y12so3518755edt.9
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 08:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xarBi1XhfY16N9uAFolHefr+AAf0IuLe/yvLpa9PjbU=;
        b=HcFyAIaKQPa0UROUvyGeXIIGBLtUfwnsv0CaLZevaLknxrRMrwLsxK5G3/b46rKP/f
         VfMAMIax2hbPGV0Be6MTnLFF5vA9hlcz5HIgG4JocpMfNYjvHMNpC6y4geXaBlIVvQEx
         PNvml9v4fmFLR11MMUAbMJloGDxVnT5tj7Rd9Pc2aOrW3wRC4ZW9BAT4aQw+BbsN1U62
         iEYOtaKUj2uL7vtQ9pJ+sfeMzuYappewlv7gRk5HEU1liBjEL1o8DjqSoW7ckLD6vK6k
         IvfFI5AcDZWB9kvSZj38gnKs2cTd7FlDgjfMhB7oK68inas1A5kfUcm5SpqrU4u8LEOo
         Ldwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xarBi1XhfY16N9uAFolHefr+AAf0IuLe/yvLpa9PjbU=;
        b=uJwEIMH0RWvT2o3VvOxmxAw1gIX5mADOeIZwIXBok/zpovXt0FIal/3vMKfbw/Xrds
         PAaptIa27daiT1V5qOFtFGfxC4CLf1wBanE3OctvSTglpCXvedSXZMsw3xhjOi64sr0t
         TL8alWT6/KP6NEnLApVDaznO8R9THm7VXChVd7vqhbOaZs6uXYd+rQ74F9TX3Yk2FPUS
         t0FiYgeGNKkDlKYwXXWvG5H3AlHxJNvK8SJrdoIGdQL1fl75ZvA+lMnZKnqPH2SCmyW+
         1dl9G8IDre0YaXyM4WxbCs0vHKph+DAa4969/4nG2+V9bu94PxsTqE26np4R+kQMUwan
         whIw==
X-Gm-Message-State: AOAM532dgzODvD0CPdrlL80UcgtZOwnAW6AUbqCTaUcXdQoU05dcy/41
        9jdpAWNEktKkPWfc+6IRx4U=
X-Google-Smtp-Source: ABdhPJyt6bs/YJ0b1tEzYpHJG5CplDYsqElMSJSnPH2QfKmbtcmfJWEHearh64P+hyIRAw6Yaz8b4w==
X-Received: by 2002:a05:6402:26cf:b0:416:a2bd:de1 with SMTP id x15-20020a05640226cf00b00416a2bd0de1mr217189edd.306.1646842790600;
        Wed, 09 Mar 2022 08:19:50 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id z16-20020a05640240d000b004165f6ce23bsm997227edb.24.2022.03.09.08.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 08:19:50 -0800 (PST)
Date:   Wed, 9 Mar 2022 18:19:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net] net: dsa: silence fdb errors when unsupported
Message-ID: <20220309161949.ycdpsv7xtndoa32b@skbuf>
References: <E1nRtfI-00EnmD-I8@rmk-PC.armlinux.org.uk>
 <20220309104143.gmoks5aceq3dtmci@skbuf>
 <Yii3SH7/mF7QmXO1@shell.armlinux.org.uk>
 <20220309155147.mdg34azyst4wwvfj@skbuf>
 <YijQcD3B1Hetq+pZ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YijQcD3B1Hetq+pZ@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 09, 2022 at 04:06:08PM +0000, Russell King (Oracle) wrote:
> On Wed, Mar 09, 2022 at 05:51:47PM +0200, Vladimir Oltean wrote:
> > On Wed, Mar 09, 2022 at 02:18:48PM +0000, Russell King (Oracle) wrote:
> > > On Wed, Mar 09, 2022 at 12:41:43PM +0200, Vladimir Oltean wrote:
> > > > Hello Russell,
> > > > 
> > > > On Wed, Mar 09, 2022 at 10:35:32AM +0000, Russell King (Oracle) wrote:
> > > > > When booting with a Marvell 88e6xxx switch, the kernel spits out a
> > > > > load of:
> > > > > 
> > > > > [    7.820996] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > > [    7.835717] mv88e6085 f1072004.mdio-mii:04: port 2 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > > [    7.851090] mv88e6085 f1072004.mdio-mii:04: port 1 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > > [    7.968594] mv88e6085 f1072004.mdio-mii:04: port 0 failed to add aa:bb:cc:dd:ee:ff vid XYZ1 to fdb: -95
> > > > > [    8.035408] mv88e6085 f1072004.mdio-mii:04: port 3 failed to add aa:bb:cc:dd:ee:ff vid XYZ3 to fdb: -95
> > > > > 
> > > > > while the switch is being setup. Comments in the Marvell DSA driver
> > > > > indicate that "switchdev expects -EOPNOTSUPP to honor software VLANs"
> > > > > in mv88e6xxx_port_db_load_purge() so this error code should not be
> > > > > treated as an error.
> > > > > 
> > > > > Fixes: 3dc80afc5098 ("net: dsa: introduce a separate cross-chip notifier type for host FDBs")
> > > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > > ---
> > > > > Hi,
> > > > > 
> > > > > I noticed these errors booting 5.16 on my Clearfog platforms with a
> > > > > Marvell DSA switch. It appears that the switch continues to work
> > > > > even though these errors are logged in the kernel log, so this patch
> > > > > merely silences the errors, but I'm unsure this is the right thing
> > > > > to do.
> > > > 
> > > > Can you please confirm that these errors have disappeared on net-next?
> > > 
> > > net-next: no warnings
> > > v5.17-rc7: warnings
> > > v5.16: warnings
> > 
> > Thanks. This means it was solved by this patch set, which had the exact
> > same symptoms:
> > https://patchwork.kernel.org/project/netdevbpf/cover/20220215170218.2032432-1-vladimir.oltean@nxp.com/
> > The cover letter and commit messages provide a full description of what
> > was wrong, has been wrong/a limitation for years, and give a sense of
> > why that work cannot be backported to v5.16, since it implies a
> > non-trivial amount of changes to the bridge driver, to switchdev and to
> > DSA.
> > 
> > > So, it looks like we need a patch for 5.17-rc7 and 5.16-stable to fix
> > > this. Do you have a better suggestion than my patch?
> > 
> > So to answer the question first, then to explain.
> > 
> > My better suggestion, taking into consideration more factors, is to
> > drop this patch and leave the code as it is.
> > 
> > The comment in the Marvell DSA driver, which you cited:
> > 
> > mv88e6xxx_port_db_load_purge:
> > 	/* switchdev expects -EOPNOTSUPP to honor software VLANs */
> > 	if (!vlan.valid)
> > 		return -EOPNOTSUPP;
> > 
> > is a logical fallacy.
> > 
> > Fact: the bridge does _not_ check errors from br_switchdev_fdb_notify().
> > Not only that, but there isn't even any mechanism in place today such
> > that this would be possible. Otherwise, myself, Nikolay and Ido wouldn't
> > have been unsuccessfully scrambling for several months to address that
> > limitation (actually mostly me, but they were the direct victims of
> > trying to review my attempts):
> > https://patchwork.kernel.org/project/netdevbpf/cover/20211025222415.983883-1-vladimir.oltean@nxp.com/
> > 
> > So if switchdev is not aware of mv88e6xxx returning -EOPNOTSUPP from a
> > work item that is scheduled from the SWITCHDEV_FDB_ADD_TO_DEVICE atomic
> > handler, then logically, switchdev cannot anything from -EOPNOTSUPP.
> > This error code has no special meaning.
> > 
> > Note that there was a second call path to drivers' ds->ops->port_fdb_add(),
> > from the DSA slave's ndo_fdb_add, and that did propagate errors. But
> > that is "bridge bypass", not switchdev, and for doing more harm than
> > good, support for it was removed in commit b117e1e8a86d ("net: dsa:
> > delete dsa_legacy_fdb_add and dsa_legacy_fdb_del"). Not only is this
> > call path no longer present today, but -EOPNOTSUPP isn't a special error
> > code there, either.
> > 
> > Having said this, the initiator of the call path which fails with
> > -EOPNOTSUPP in mv88e6xxx_port_db_load_purge() is the bridge driver,
> > via switchdev.
> > 
> > The mv88e6xxx driver, via that check, essentially expects that the VID
> > from the FDB entry has been previously mapped in the VTU.
> > 
> > The bridge driver already ensures that the VLAN structure has been
> > created, before any FDB entries can be added in that VLAN. This is
> > proven by the attempt below to add an FDB entry in VLAN 5, in bridge
> > port swp0:
> > 
> > root@debian:~# bridge fdb add dev swp0 static master 00:01:02:03:04:05 vlan 5
> > [109407.613593] bridge: RTM_NEWNEIGH with unconfigured vlan 5 on swp0
> > RTNETLINK answers: Invalid argument
> > root@debian:~# bridge vlan
> > port    vlan ids
> > swp0     1 PVID Egress Untagged
> > 
> > br0      1 PVID Egress Untagged
> > 
> > root@debian:~# bridge link
> > 9: swp0@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 4
> > 
> > So the sanity check captures what is essentially an invalid condition.
> > If the bridge notifies an FDB entry in a VLAN that isn't present in the
> > VTU, this is a bug.
> > 
> > Now on to my point. There is a trade-off to be made between things
> > running apparently smoothly and running correctly.
> > 
> > Since the DSA switchdev work item is the final entity that sees error
> > codes propagated from the driver, I find it valuable that these error
> > codes are not hidden in any way. I do not have access to all hardware,
> > I cannot foresee all code paths, but yet, users who notice errors in the
> > kernel log report these problems, we look into them and we fix them.
> > In fact, this is exactly the way in which Rafael pointed out to me the
> > mv88e6xxx issue, and this led to the aforementioned bridge/switchdev/DSA
> > rework. It is a process that works, and I would like it to not be
> > disrupted.
> > 
> > This isn't to say that there is no argument to be made for hiding these
> > error messages. There is a possibility that I might agree with silencing
> > some errors in some cases, but I have not heard a compelling argument
> > for that. Also, with mv88e6xxx and systemd-networkd, it isn't even the
> > first warning/error of its kind that gets printed by this driver out of
> > the blue. The driver also warns when systemd-networkd reinitializes
> > bridge VLANs on ports, stating that "port X already a member of VLAN y".
> > So I believe that mv88e6xxx users already have some tolerance for
> > non-fatal warnings. These latter warnings, by the way, have also
> > disappeared as a result of the patch set I linked in the beginning.
> > 
> > Therefore, I think it is in the best interest of the code base for users
> > to report the problems they see, instead of masking them. This means
> > walking through potentially known and already fixed problems/limitations,
> > debugging, explaining, testing, writing long emails etc, but I prefer
> > this to the alternative of cutting myself from a potentially valid
> > source of information.
> 
> So, to summarise your very verbose email.
> 
> 5.13 didn't spit out these errors.
> 
> Changes happened between 5.13 and 5.16 that exposed these errors and
> the errors continue to be exposed in 5.17, leading users to panic
> believing that something is wrong.
> 
> You don't want to hide the errors.
> 
> It will be fixed in 5.18.

The summary is more or less correct.

> Thanks, but I think I'll keep my patch in my tree so I don't have to
> look at a meaningless error that doesn't appear to affect operation.

Ok, cool!
