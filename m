Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3DB129F37
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 09:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLXIjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 03:39:36 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:50493 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726068AbfLXIjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 03:39:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D0EA21402;
        Tue, 24 Dec 2019 03:39:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 24 Dec 2019 03:39:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JoakoR
        JUiXLytt7T2J6lPg5rE2xjtQanuVUPHwwC+3I=; b=kBut5iYeN+9XqkLtyGxxAs
        ouL2mVjBC9V7Yw9cWWyamt8U1kn/ejcDLWmicJj9FZdrrGcjgGroSgs70p0zWWlV
        BJWhyJSDBAXkT080nDsPWtMNUIGmWSQkX1jVlRGb/d/eOHzjLYpnErsAb8JmzoLp
        LNTn2jlrNQVZgdD6QPn52FX6Wq0MFEPC9NZdPjknu4K0Y4XPAfJxfG60OR9Pa82x
        iTTIll3WIh7nhiFWSD+Ggl4nyAhFWkc0Navnctc3SGDKg3sYRIwHLQ7T95I/sUav
        wbouNOlUiHGYeeWJtIwWWgg6t1ZuVeRcH8s9fUMC+SmJ1o5EHxWvBb/K5T47zu2g
        ==
X-ME-Sender: <xms:xc4BXlE7Sc9XHcyB2S3bLNOcivkpJI9ZrzjVbkqZUgPlg0yT0eVSng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:xc4BXp7x394bapR5Ap9fehkIQS3zqobPMQOHWDQVTfbHfzKy4RgbKg>
    <xmx:xc4BXghYYVbki7T0eBA5F1cQZONSwXTKdQ7BHCBdeg4ag56vJwPSZw>
    <xmx:xc4BXj4TT4B9WS1KDq3SrUMG2K_7-O3FYO7rnksWJePAqNCNJC4pNw>
    <xmx:x84BXlYRC9P8mJZG5h8PVHr875-WIkE-EPv-LxwBG22vk_K-ja_IsA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD28280059;
        Tue, 24 Dec 2019 03:39:32 -0500 (EST)
Date:   Tue, 24 Dec 2019 10:39:31 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC 1/3] net: switchdev: do not propagate bridge updates across
 bridges
Message-ID: <20191224083931.GB895380@splinter>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <E1ij6pf-00083v-Sl@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ij6pf-00083v-Sl@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 22, 2019 at 07:24:03PM +0000, Russell King wrote:
> When configuring a tree of independent bridges, propagating changes
> from the upper bridge across a bridge master to the lower bridge
> ports brings surprises.
> 
> For example, a lower bridge may have vlan filtering enabled.  It
> may have a vlan interface attached to the bridge master, which may
> then be incorporated into another bridge.  As soon as the lower
> bridge vlan interface is attached to the upper bridge, the lower
> bridge has vlan filtering disabled.

Interesting topology :) The change looks OK to me. I'll add the patch to
our internal tree and let it go through regression to make sure I didn't
miss anything. Will report the results tomorrow.

> 
> This occurs because switchdev recursively applies its changes to
> all lower devices no matter what.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  net/switchdev/switchdev.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
> index 3a1d428c1336..d881e5e4a889 100644
> --- a/net/switchdev/switchdev.c
> +++ b/net/switchdev/switchdev.c
> @@ -475,6 +475,9 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
>  	 * necessary to go through this helper.
>  	 */
>  	netdev_for_each_lower_dev(dev, lower_dev, iter) {
> +		if (netif_is_bridge_master(lower_dev))
> +			continue;
> +
>  		err = __switchdev_handle_port_obj_add(lower_dev, port_obj_info,
>  						      check_cb, add_cb);
>  		if (err && err != -EOPNOTSUPP)
> @@ -526,6 +529,9 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
>  	 * necessary to go through this helper.
>  	 */
>  	netdev_for_each_lower_dev(dev, lower_dev, iter) {
> +		if (netif_is_bridge_master(lower_dev))
> +			continue;
> +
>  		err = __switchdev_handle_port_obj_del(lower_dev, port_obj_info,
>  						      check_cb, del_cb);
>  		if (err && err != -EOPNOTSUPP)
> @@ -576,6 +582,9 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
>  	 * necessary to go through this helper.
>  	 */
>  	netdev_for_each_lower_dev(dev, lower_dev, iter) {
> +		if (netif_is_bridge_master(lower_dev))
> +			continue;
> +
>  		err = __switchdev_handle_port_attr_set(lower_dev, port_attr_info,
>  						       check_cb, set_cb);
>  		if (err && err != -EOPNOTSUPP)
> -- 
> 2.20.1
> 
