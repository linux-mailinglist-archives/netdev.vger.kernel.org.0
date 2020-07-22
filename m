Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B3022A06B
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731927AbgGVUCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgGVUCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 16:02:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB8C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 13:02:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 084B711FFCC21;
        Wed, 22 Jul 2020 12:45:36 -0700 (PDT)
Date:   Wed, 22 Jul 2020 13:02:20 -0700 (PDT)
Message-Id: <20200722.130220.825174238852025216.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        alexandre.belloni@bootlin.com, Bryan.Whitehead@microchip.com,
        Steen.Hegelund@microchip.com, Horatiu.Vultur@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next] net: mscc: ocelot: fix non-initialized CPU
 port on VSC7514
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722080857.2094067-1-olteanv@gmail.com>
References: <20200722080857.2094067-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 12:45:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 22 Jul 2020 11:08:57 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The VSC7514 is marketed as a 10-port switch, however it has 11 physical
> ports (0->10) in the block diagram:
> https://www.microsemi.com/product-directory/ethernet-switches/3992-vsc7514
> (also in the device tree at arch/mips/boot/dts/mscc/ocelot.dtsi)
> 
> Additionally, by architecture it has one more entry in the analyzer
> block, situated right after the physical ports, for the CPU port module.
> This is not a physical port, it only represents a channel for frame
> injection and extraction. That entry for the CPU port is at index 11 in
> the analyzer.
> 
> When the register groups for QSYS_SWITCH_PORT_MODE, SYS_PORT_MODE and
> SYS_PAUSE_CFG are declared to be replicated 11 times, the 11th entry in
> the array of regfields is not initialized, so the CPU port module is not
> initialized either.
> 
> The documentation of QSYS_SWITCH_PORT_MODE for VSC7514 also says that
> this register group is replicated 12 times, so this patch is simply
> reflecting that and not introducing any further inconsistency.
> 
> Fixes: 886e1387c73d ("net: mscc: ocelot: convert QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to regfields")
> Fixes: 541132f0961a ("net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield")
> Reported-by: Bryan Whitehead <bryan.whitehead@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
