Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB267629BD4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiKOOSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiKOOSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:18:52 -0500
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750021A7;
        Tue, 15 Nov 2022 06:18:48 -0800 (PST)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 92A20188373F;
        Tue, 15 Nov 2022 14:18:45 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 8C29B25002DE;
        Tue, 15 Nov 2022 14:18:45 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 8076291201E4; Tue, 15 Nov 2022 14:18:45 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Tue, 15 Nov 2022 15:18:45 +0100
From:   netdev@kapio-technology.com
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
In-Reply-To: <Y3OSbZs6Ho07D6Yx@lunn.ch>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <Y3OSbZs6Ho07D6Yx@lunn.ch>
User-Agent: Gigahost Webmail
Message-ID: <ed15483fc80a3513c6b41ff412a7aad7@kapio-technology.com>
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

On 2022-11-15 14:21, Andrew Lunn wrote:
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:00] driver 
>> [Generic
>> PHY] (irq=POLL)
> 
> It is interesting it is using the generic PHY driver, not the Marvell
> PHY driver.
> 
>> mv88e6085 1002b000.ethernet-1:04 eth6 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:01] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth9 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:02] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth5 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:03] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth8 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:04] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth4 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:05] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth7 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:06] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth3 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdio:07] driver 
>> [Generic
>> PHY] (irq=POLL)
>> mv88e6085 1002b000.ethernet-1:04 eth2 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:08] driver
>> [Marvell 88E1112] (irq=174)
>> mv88e6085 1002b000.ethernet-1:04 eth1 (uninitialized): PHY
>> [!soc!aipi@10020000!ethernet@1002b000!mdio!switch@4!mdioe:09] driver
>> [Marvell 88E1112] (irq=175)
> 
> And here it does use the Marvell PHY driver. Are ports 8 and 9
> external, where as the others are internal?
> 
>     Andrew

It is an 8 port switch, so the two (8+9) are for internal use, I guess, 
as I
have not had any part in the system design etc of this device.

I have it for test and development purposes, incl. upstreaming.
