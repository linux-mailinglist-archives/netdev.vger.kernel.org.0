Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8367629CB6
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKOO46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiKOO44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:56:56 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F21F00E;
        Tue, 15 Nov 2022 06:56:54 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id f18so3642832ejz.5;
        Tue, 15 Nov 2022 06:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DlzzPcy/+uz7uznt0+QuosuB45nHYsq4aPkJiTLBo6M=;
        b=IHAoIZAMKO0yqhbyPvWKraTuyki/fgz6mKMcqCi0OfSb0hoA7ttTYykr79whFhqxcY
         Xw/zuSZpkt2rqmCgQGDRCdPxkKKaP8mUQv+fKnDTaerLdfGb20J5f5K7iSdsC2FFUpg/
         1POz7DVCFNWJuJoEQOLzlrbJfNysSYmRJEq94GyJjbClOtlwDKKlcC4Y6o7kXVrw7oTS
         7VfHctHAM9rwcXBpRZROfj5QAZa8nQrFk7+fNNWTHjsWI8wNh6vFZk0GiQvBCxv+iQFr
         nwg58uDkhmoG3De5fidZQn8V+K/N5oZpKVZmT6G3aKD71u+4YSMEca7ZG2/VZ/hNTfMJ
         LY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlzzPcy/+uz7uznt0+QuosuB45nHYsq4aPkJiTLBo6M=;
        b=ry5C4yDsEZxwhE4++2fiwB4ATJsKb/+oAMybtV7acczc1ny0QXgo+RCjx34cgLLMo3
         HWK9vioSxz9ApG97abtN1hklMa0P3qhbiayO8Hfyarqz99lwnwZcOEKzqiV97nlD3meA
         nyrV6of+LYQLarb5u0Jqb2FAplqdGee6YltZvoM7lKHerFoQ6pOMgTSUn2j0V82DQRZE
         +m5a8LtPJmx21B3ZdZMukm2062V7T6nHdYrNymJIcSQeDBLh1qOWzBk/0XH9btZfP957
         3ZPuJ7k1mssyY1uOODDih+TdR/ISPzjrrDLeJfhLeBBbm0KvthBDTbfY7ELMg68xtyO6
         okuQ==
X-Gm-Message-State: ANoB5pmYTNhOitrN57gbWUTV3vER8zTVlllsTuKZMvsr35qWx1dz1oWA
        /Qkv+nfqajN6LzMalvNxdCC7a7hs9z7uYw==
X-Google-Smtp-Source: AA0mqf5vcIIb5ugglqhWUOMJ1xkktCbwdcXjAEG0H/XPUsgfc6oEs8Kfeq2Et7mdfU55OaiB54GbNg==
X-Received: by 2002:a17:906:1250:b0:7ad:d0e3:1f59 with SMTP id u16-20020a170906125000b007add0e31f59mr13856003eja.714.1668524212818;
        Tue, 15 Nov 2022 06:56:52 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id h11-20020a170906854b00b007b27aefc578sm332292ejy.126.2022.11.15.06.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 06:56:52 -0800 (PST)
Date:   Tue, 15 Nov 2022 16:56:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115145650.gs7crhkidbq5ko6v@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 02:25:13PM +0100, netdev@kapio-technology.com wrote:
> On 2022-11-15 13:22, Vladimir Oltean wrote:
> > Do you have a timeline for when the regression was introduced?
> > Commit 35da1dfd9484 reverts cleanly, so I suppose giving it a go with
> > that reverted might be worth a shot. Otherwise, a bisect from a known
> > working version only takes a couple of hours, and shouldn't require
> > other changes to the setup.
> 
> Wow! Reverting 35da1dfd9484 and the problem has disappeared. :-)

See? That wasn't very painful, was it.

Now, why doesn't that commit work for you? that's the real question.
I'm going to say there's a big assumption made there. The old code used
to poll up to 16 times with sleeps of up to 2 ms in between.
The new code polls until at least 50 ms have elapsed.
I can imagine the thought process being something like "hmm, 16*2=32ms,
let's round that up to 50 just to be sure". But the effective timeout
was not really increased. Rather said, in the old code there was never
really an effective timeout, since the polling code could have been
preempted many times, and these preemptions would not be accounted
against the msleep(2) calls. Whereas the new code really tracks
something approximating 50 ms now.

Could you please add the reverted patch back to your git tree, and see
by how much do you need to increase the timeout for your system to get
reliable results?

> The bridge_locked_port.sh tests all succeeded... as expected... ;-)

Yeah, I confirm this works on a 6390 over here. But I still don't like
the log spam from the IRQ handlers.

[root@mox:~/.../drivers/net/dsa] # ./bridge_locked_port.sh lan1 lan2 lan3 lan4
[ 1298.218224] mv88e6085 d0032004.mdio-mii:10 lan1: configuring for phy/gmii link mode
[ 1299.150249] mv88e6085 d0032004.mdio-mii:10 lan4: configuring for phy/gmii link mode
[ 1299.791778] br0: port 1(lan2) entered blocking state
[ 1299.800824] br0: port 1(lan2) entered disabled state
[ 1300.419596] br0: port 2(lan3) entered blocking state
[ 1300.425016] br0: port 2(lan3) entered disabled state
[ 1300.527959] device lan3 entered promiscuous mode
[ 1300.538124] device lan2 entered promiscuous mode
[ 1300.733679] mv88e6085 d0032004.mdio-mii:10 lan2: configuring for phy/gmii link mode
[ 1300.765642] 8021q: adding VLAN 0 to HW filter on device lan2
[ 1300.818540] mv88e6085 d0032004.mdio-mii:10 lan3: configuring for phy/gmii link mode
[ 1300.855003] 8021q: adding VLAN 0 to HW filter on device lan3
[ 1303.903840] mv88e6085 d0032004.mdio-mii:10 lan3: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1303.912939] IPv6: ADDRCONF(NETDEV_CHANGE): lan3: link becomes ready
[ 1303.928313] br0: port 2(lan3) entered blocking state
[ 1303.933685] br0: port 2(lan3) entered forwarding state
[ 1303.948607] mv88e6085 d0032004.mdio-mii:10 lan4: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1303.985784] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[ 1303.999962] IPv6: ADDRCONF(NETDEV_CHANGE): lan4: link becomes ready
[ 1304.003780] mv88e6085 d0032004.mdio-mii:10 lan2: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1304.017407] IPv6: ADDRCONF(NETDEV_CHANGE): lan2: link becomes ready
[ 1304.027922] br0: port 1(lan2) entered blocking state
[ 1304.033157] br0: port 1(lan2) entered forwarding state
[ 1304.043508] mv88e6085 d0032004.mdio-mii:10 lan1: Link is Up - 1Gbps/Full - flow control rx/tx
[ 1304.052601] IPv6: ADDRCONF(NETDEV_CHANGE): lan4.100: link becomes ready
[ 1304.158404] IPv6: ADDRCONF(NETDEV_CHANGE): lan1: link becomes ready
[ 1304.167574] IPv6: ADDRCONF(NETDEV_CHANGE): lan1.100: link becomes ready
TEST: Locked port ipv4                                              [ OK ]
TEST: Locked port ipv6                                              [ OK ]
[ 1337.627010] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 1 callbacks suppressed
[ 1337.627042] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1337.644822] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1337.727920] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1337.862053] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1337.956972] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1338.065996] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1338.136905] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1338.238182] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1338.339244] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1338.440106] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1342.655520] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 33 callbacks suppressed
[ 1342.655568] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1342.763619] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1342.835264] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1342.847464] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1342.865387] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1342.971661] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1343.075774] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1343.179562] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1343.283426] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1343.387409] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1348.758296] mv88e6xxx_g1_vtu_prob_irq_thread_fn: 24 callbacks suppressed
[ 1348.758328] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1348.858879] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1348.990492] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.063977] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.165979] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.268187] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.373827] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.472601] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.573752] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
[ 1349.585837] mv88e6085 d0032004.mdio-mii:10: VTU member violation for vid 100, source port 9
TEST: Locked port vlan                                              [ OK ]
[ 1352.550194] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1352.659486] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1352.792941] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1352.888959] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1352.968150] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1353.072434] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1353.182844] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1353.280595] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1353.384755] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1353.488602] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1358.704139] mv88e6xxx_g1_atu_prob_irq_thread_fn: 39 callbacks suppressed
[ 1358.704172] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.280930] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.388609] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.524500] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.620272] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.696597] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.727872] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.801563] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1359.908665] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1360.012063] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1363.858627] mv88e6xxx_g1_atu_prob_irq_thread_fn: 29 callbacks suppressed
[ 1363.858674] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1364.879407] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
TEST: Locked port MAB                                               [ OK ]
[ 1369.837089] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for a0:b0:c0:c0:b0:a0 portvec 4 spid 2
[ 1369.971489] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for a0:b0:c0:c0:b0:a0 portvec 4 spid 2
[ 1370.070444] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for a0:b0:c0:c0:b0:a0 portvec 4 spid 2
[ 1370.143784] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for a0:b0:c0:c0:b0:a0 portvec 4 spid 2
[ 1370.245843] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for a0:b0:c0:c0:b0:a0 portvec 4 spid 2
[ 1371.465429] mv88e6085 d0032004.mdio-mii:10: ATU member violation for a0:b0:c0:c0:b0:a0 portvec 8 spid 2
[ 1371.599084] mv88e6085 d0032004.mdio-mii:10: ATU member violation for a0:b0:c0:c0:b0:a0 portvec 8 spid 2
[ 1371.703341] mv88e6085 d0032004.mdio-mii:10: ATU member violation for a0:b0:c0:c0:b0:a0 portvec 8 spid 2
[ 1371.794905] mv88e6085 d0032004.mdio-mii:10: ATU member violation for a0:b0:c0:c0:b0:a0 portvec 8 spid 2
[ 1371.873307] mv88e6085 d0032004.mdio-mii:10: ATU member violation for a0:b0:c0:c0:b0:a0 portvec 8 spid 2
[ 1372.022403] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
TEST: Locked port MAB roam                                          [ OK ]
TEST: Locked port MAB configuration                                 [ OK ]
[ 1373.039089] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:01 portvec 4 spid 2
[ 1373.060995] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:05 portvec 4 spid 2
[ 1373.167964] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:05 portvec 4 spid 2
[ 1373.296506] mv88e6085 d0032004.mdio-mii:10: ATU miss violation for 00:01:02:03:04:05 portvec 4 spid 2
TEST: Locked port MAB FDB flush                                     [ OK ]
[ 1375.330376] mv88e6085 d0032004.mdio-mii:10 lan3: Link is Down
[ 1375.341372] br0: port 2(lan3) entered disabled state
[ 1375.461136] mv88e6085 d0032004.mdio-mii:10 lan2: Link is Down
[ 1375.489476] br0: port 1(lan2) entered disabled state
[ 1375.611159] device lan3 left promiscuous mode
[ 1375.618253] br0: port 2(lan3) entered disabled state
[ 1375.737909] device lan2 left promiscuous mode
[ 1375.745305] br0: port 1(lan2) entered disabled state
