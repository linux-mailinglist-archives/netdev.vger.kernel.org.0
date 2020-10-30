Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B17A2A0127
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 10:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgJ3JVn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Oct 2020 05:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgJ3JVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 05:21:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DCBC0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 02:21:42 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kYQbL-0003W5-Kd; Fri, 30 Oct 2020 10:21:39 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kYQbH-0001kb-Sz; Fri, 30 Oct 2020 10:21:35 +0100
Date:   Fri, 30 Oct 2020 10:21:35 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Per Forlin <per.forlin@axis.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH v2 net-next 12/12] net: dsa: tag_ar9331: let DSA core
 deal with TX reallocation
Message-ID: <20201030092135.564abundlcpm43lj@pengutronix.de>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
 <20201030014910.2738809-13-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20201030014910.2738809-13-vladimir.oltean@nxp.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:20:47 up 350 days, 39 min, 372 users,  load average: 0.13, 0.07,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 03:49:10AM +0200, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> Cc: Per Forlin <per.forlin@axis.com>
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Oleksij Rempel <linux@rempel-privat.de>

> ---
> Changes in v2:
> None.
> 
>  net/dsa/tag_ar9331.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
> index 55b00694cdba..002cf7f952e2 100644
> --- a/net/dsa/tag_ar9331.c
> +++ b/net/dsa/tag_ar9331.c
> @@ -31,9 +31,6 @@ static struct sk_buff *ar9331_tag_xmit(struct sk_buff *skb,
>  	__le16 *phdr;
>  	u16 hdr;
>  
> -	if (skb_cow_head(skb, AR9331_HDR_LEN) < 0)
> -		return NULL;
> -
>  	phdr = skb_push(skb, AR9331_HDR_LEN);
>  
>  	hdr = FIELD_PREP(AR9331_HDR_VERSION_MASK, AR9331_HDR_VERSION);
> -- 
> 2.25.1
> 

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
