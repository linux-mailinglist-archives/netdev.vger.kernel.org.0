Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7F462990E
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbiKOMkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiKOMkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:40:47 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4061FF97;
        Tue, 15 Nov 2022 04:40:45 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 332BA1883FF1;
        Tue, 15 Nov 2022 12:40:43 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 2A46725002DE;
        Tue, 15 Nov 2022 12:40:43 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 20A5891201E4; Tue, 15 Nov 2022 12:40:43 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 13:40:43 +0100
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <20221115122237.jfa5aqv6hauqid6l@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <61810a4b3afb7bb6de1bcbaa52080e01@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-11-15 13:22, Vladimir Oltean wrote:
> On Tue, Nov 15, 2022 at 12:31:59PM +0100, netdev@kapio-technology.com 
> wrote:
>> It happens on upstart, so I would then have to hack the system upstart 
>> to
>> add trace.
> 
> Hack upstart or disable the service that brings the switch ports up, 
> and
> bring them up manually...
> 
>> I also have:
>> mv88e6085 1002b000.ethernet-1:04: switch 0x990 detected: Marvell 
>> 88E6097/88E6097F, revision 2
>> mv88e6085 1002b000.ethernet-1:04: configuring for fixed/rgmii-id link 
>> mode
>> mv88e6085 1002b000.ethernet-1:04: Link is Up - 100Mbps/Full - flow 
>> control off
>> mv88e6085 1002b000.ethernet-1:04 eth10 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:00] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth6 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:01] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth9 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:02] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth5 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:03] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth8 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:04] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth4 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:05] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth7 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:06] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth3 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:07] driver 
>> [Generic PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth2 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:08] driver 
>> [Marvell 88E1112] (irq=174)
>> mv88e6085 1002b000.ethernet-1:04 eth1 (uninitialized): PHY 
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:09] driver 
>> [Marvell 88E1112] (irq=175)
>> 
>> after this and adding the ifaces to the bridge, it continues like:
>> 
>> br0: port 1(eth10) entered blocking state
>> br0: port 1(eth10) entered disabled state
>> br0: port 2(eth6) entered blocking state
>> br0: port 2(eth6) entered disabled state
>> device eth6 entered promiscuous mode
>> device eth10 entered promiscuous mode
>> br0: port 3(eth9) entered blocking state
>> br0: port 3(eth9) entered disabled state
>> device eth9 entered promiscuous mode
>> br0: port 4(eth5) entered blocking state
>> br0: port 4(eth5) entered disabled state
>> device eth5 entered promiscuous mode
>> br0: port 5(eth8) entered blocking state
>> br0: port 5(eth8) entered disabled state
>> device eth8 entered promiscuous mode
>> br0: port 6(eth4) entered blocking state
>> br0: port 6(eth4) entered disabled state
>> mv88e6085 1002b000.ethernet-1:04: Timeout while waiting for switch
>> mv88e6085 1002b000.ethernet-1:04: port 0 failed to add 
>> 9a:af:03:f1:bd:0a vid 1 to fdb: -110
> 
> Dumb question, but if you get errors like this, how can you test 
> anything at all
> in the patches that you submit?

The answer is that I don't always get these errors... once in a while 
(maaany resets) it does
not happen, and all is fine.

The error code is... well of course -110 (timed out).

> 
>> device eth4 entered promiscuous mode
>> br0: port 7(eth7) entered blocking state
>> br0: port 7(eth7) entered disabled state
>> 
>> I don't know if that gives ay clues...?
> 
> Not really. That error might be related - something indicating a 
> breakage
> in the top-level (fec IIUC) MDIO controller, or not. There was "recent"
> rework almost everywhere.  For example commit 35da1dfd9484 ("net: dsa:
> mv88e6xxx: Improve performance of busy bit polling"). That also hooks
> into the mv88e6xxx cascaded MDIO controller 
> (mv88e6xxx_g2_smi_phy_wait),
> so there might be something there.
> 

I can check that out, but I remember that net-next has not worked on 
this device for quite some
time...

>> 
>> Otherwise I have to take more time to see what I can dig out. The 
>> easiest
>> for me is then to add some printk statements giving targeted 
>> information if told what and
>> where...
> 
> Do you have a timeline for when the regression was introduced?
> Commit 35da1dfd9484 reverts cleanly, so I suppose giving it a go with
> that reverted might be worth a shot. Otherwise, a bisect from a known
> working version only takes a couple of hours, and shouldn't require
> other changes to the setup.

I can't say when the regression was introduced as I used modified 
kernels, but something
between 5.16 and 5.17, I know there was something phy related, but it's 
a bit more complicated,
so it is only a guess...

I would have to get the whole locked port patch set etc. on a 5.16 to 
see if that works.

