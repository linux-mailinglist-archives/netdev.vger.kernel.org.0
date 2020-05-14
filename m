Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23DA1D40BC
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgENWUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728050AbgENWUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:20:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383DDC061A0C;
        Thu, 14 May 2020 15:20:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 744BC13DF4070;
        Thu, 14 May 2020 15:20:24 -0700 (PDT)
Date:   Thu, 14 May 2020 15:20:23 -0700 (PDT)
Message-Id: <20200514.152023.1337480204148521218.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, eric.dumazet@gmail.com, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: disable rxvlan offload for
 the DSA master
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200512234921.25460-1-olteanv@gmail.com>
References: <20200512234921.25460-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 15:20:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 13 May 2020 02:49:21 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> On sja1105 operating in best_effort_vlan_filtering mode (when the TPID
> of the DSA tags is 0x8100), it can be seen that __netif_receive_skb_core
> calls __vlan_hwaccel_clear_tag right before passing the skb to the DSA
> packet_type handler.
> 
> This means that the tagger does not see the VLAN tag in the skb, nor in
> the skb meta data.
> 
> The patch that started zeroing the skb VLAN tag is:
> 
>   commit d4b812dea4a236f729526facf97df1a9d18e191c
>   Author: Eric Dumazet <edumazet@xxxxxxxxxx>
>   Date:   Thu Jul 18 07:19:26 2013 -0700
> 
>       vlan: mask vlan prio bits

Again, Eric, please review.
