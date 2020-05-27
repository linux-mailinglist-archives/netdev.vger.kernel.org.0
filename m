Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139B51E4D43
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgE0Srh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgE0Srg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:47:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0EAC008632
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 11:40:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2525128B353F;
        Wed, 27 May 2020 11:40:15 -0700 (PDT)
Date:   Wed, 27 May 2020 11:40:15 -0700 (PDT)
Message-Id: <20200527.114015.716932213460280765.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        rmk+kernel@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: felix: accept VLAN config
 regardless of bridge VLAN awareness state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527164538.1082478-1-olteanv@gmail.com>
References: <20200527164538.1082478-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 May 2020 11:40:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 27 May 2020 19:45:38 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot core library is written with the idea in mind that the VLAN
> table is populated by the bridge. Otherwise, not even a sane default
> pvid is provided: in standalone mode, the default pvid is 0, and the
> core expects the bridge layer to change it to 1.
> 
> So without this patch, the VLAN table is completely empty at the end of
> the commands below, and traffic is broken as a result:
> 
> ip link add dev br0 type bridge vlan_filtering 0 && ip link set dev br0 up
> for eth in $(ls /sys/bus/pci/devices/0000\:00\:00.5/net/); do
> 	ip link set dev $eth master br0
> 	ip link set dev $eth up
> done
> ip link set dev br0 type bridge vlan_filtering 1
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
