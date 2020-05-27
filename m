Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AD71E4D4F
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgE0Srg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726459AbgE0Srg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:47:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC39C008636
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:41:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 227C3128B3543;
        Wed, 27 May 2020 11:41:29 -0700 (PDT)
Date:   Wed, 27 May 2020 11:41:28 -0700 (PDT)
Message-Id: <20200527.114128.968056476015528435.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: felix: send VLANs on CPU port as
 egress-tagged
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527164803.1083420-1-olteanv@gmail.com>
References: <20200527164803.1083420-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:41:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 27 May 2020 19:48:03 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in other commits before (b9cd75e66895 and 87b0f983f66f),
> ocelot switches have a single egress-untagged VLAN per port, and the
> driver would deny adding a second one while an egress-untagged VLAN
> already exists.
> 
> But on the CPU port (where the VLAN configuration is implicit, because
> there is no net device for the bridge to control), the DSA core attempts
> to add a VLAN using the same flags as were used for the front-panel
> port. This would make adding any untagged VLAN fail due to the CPU port
> rejecting the configuration:
> 
> bridge vlan add dev swp0 vid 100 pvid untagged
> [ 1865.854253] mscc_felix 0000:00:00.5: Port already has a native VLAN: 1
> [ 1865.860824] mscc_felix 0000:00:00.5: Failed to add VLAN 100 to port 5: -16
> 
> (note that port 5 is the CPU port and not the front-panel swp0).
> 
> So this hardware will send all VLANs as tagged towards the CPU.
> 
> Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied and queued up for -stable, thanks.
