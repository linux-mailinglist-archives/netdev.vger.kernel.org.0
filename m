Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45C221E04C
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgGMS7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:59:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726321AbgGMS7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 14:59:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jv3fr-004uUl-WB; Mon, 13 Jul 2020 20:59:35 +0200
Date:   Mon, 13 Jul 2020 20:59:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, xiyou.wangcong@gmail.com,
        ap420073@gmail.com
Subject: Re: [PATCH net] net: dsa: link interfaces with the DSA master to get
 rid of lockdep warnings
Message-ID: <20200713185935.GL1078057@lunn.ch>
References: <20200713162443.2510682-1-olteanv@gmail.com>
 <20200713164728.GH1078057@lunn.ch>
 <20200713173049.wzo7e2rpbtfbwdxd@skbuf>
 <20200713173319.zjmqjzqmjcxw6gyf@skbuf>
 <20200713174227.p6owrtgyccxfbuj5@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713174227.p6owrtgyccxfbuj5@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> One difference from VLAN is that in that case, the entire
> register_vlan_device() function runs under RTNL.
> When those bugs that you talk about are found, who starts using the
> network interface too early? User space or someone else? Would RTNL be
> enough to avoid that?

NFS root. Registering the interface causes autoconfig to start,
sending a DHCP request, or if the IP addresses are fixed, it could
send an ARP for the NFS server.

It is just nice to have if it is before register_netdev(). I don't
think there is an actual issues in this case, being able to
send/receive packets should not depend on the upper/lower linkage for
DSA.

	Andrew
