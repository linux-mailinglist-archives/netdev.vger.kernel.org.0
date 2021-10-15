Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F442FF07
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 01:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbhJOXxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 19:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhJOXxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 19:53:40 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B39DC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 16:51:33 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g10so44186042edj.1
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 16:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=auh0r3Hbz6WsKwFJA8OGqC7TGshUVV/dSrmryraFoyQ=;
        b=Z7W9fG9bPhrYgiyozpNRcYJWEt9MnOAGIrp/nEeu2lzyvVmQ/0huJ1kUBnl8AZSUZZ
         aruTqWtRyDhJLlrJJveMdaqZjjusR15lz+orj+20RCxi3xBUBJzh+/8pHl3fOZlT/P/P
         gVpkqk/ImvNk6c3E56/R9/vXJLU0M/9VBqJWq9pli+A8N0t1jM7tzv1NYFHCSX5BogOr
         /rhqaO3WrNBuMt8NDlmAoxPYyOPV4jeaSYBe8a/iXIGUquPYKqRc2t0TOS0K+ZlgV8fN
         DV06WkhHNAyAC+yOFY0ZXWgU2Ku40qeXZGQ4esBCXQ94y4KvGvfD4bmRo5H4wrJypXV3
         83dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=auh0r3Hbz6WsKwFJA8OGqC7TGshUVV/dSrmryraFoyQ=;
        b=stpR4UVrhRGYCpGHlg+T9q2r7fOs1v1HPZortMhS+0Z+xt8bqKvaivst56LbQwTlu+
         Pgls8xGUIwjQZ/oyNL5QJ7zZrhvJJfb5+jvwn0rY+WKjOj4b63fDjHfl681qcAd6aYHA
         8hrfXGpUqPpBJ2RYmYAIdFpIH1dMPGjqYN3RLk9SNlb1dUAWKtuE6+Hm1JVvohNnFd8o
         j00rvgAfI0S2QkxoUynaq6fSFJExOB9Wr6O0W02TIiD0CA7KF/4Yi+wtst/MaYhhr32h
         XQUWQaNTPlpGmXOYmUehAOGB56yMfltJ0H3IKByxeWaioSAdhtS5zCYlj55AqJK7dbfH
         6KXA==
X-Gm-Message-State: AOAM530N6ZaiFzyMOg3ZCZqi81DLphlI1ALZPeya/zi+NATH6fjGTUZu
        JrZZU3E8mTxL2rs411FVAbI=
X-Google-Smtp-Source: ABdhPJxCtAwtqg0LdGnV/XkkG7dHTZpLKJKA/BVBCpXwq3ANESdEsBUo0tpuK07yMaorpQFWiLGdFQ==
X-Received: by 2002:a05:6402:84a:: with SMTP id b10mr21995754edz.121.1634341892093;
        Fri, 15 Oct 2021 16:51:32 -0700 (PDT)
Received: from skbuf ([188.26.184.231])
        by smtp.gmail.com with ESMTPSA id o15sm5101947ejj.10.2021.10.15.16.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:51:31 -0700 (PDT)
Date:   Sat, 16 Oct 2021 02:51:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, idosch@idosch.org,
        f.fainelli@gmail.com, vkochan@marvell.com, tchornyi@marvell.com
Subject: Re: [RFC net-next 3/6] ethernet: prestera: use eth_hw_addr_set_port()
Message-ID: <20211015235130.6sulfh2ouqt3dgfh@skbuf>
References: <20211015193848.779420-1-kuba@kernel.org>
 <20211015193848.779420-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015193848.779420-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 12:38:45PM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> We need to make sure the last byte is zeroed.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: vkochan@marvell.com
> CC: tchornyi@marvell.com
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index b667f560b931..7d179927dabe 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -290,6 +290,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>  {
>  	struct prestera_port *port;
>  	struct net_device *dev;
> +	u8 addr[ETH_ALEN] = {};
>  	int err;
>  
>  	dev = alloc_etherdev(sizeof(*port));
> @@ -341,8 +342,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>  	/* firmware requires that port's MAC address consist of the first
>  	 * 5 bytes of the base MAC address
>  	 */
> -	memcpy(dev->dev_addr, sw->base_mac, dev->addr_len - 1);
> -	dev->dev_addr[dev->addr_len - 1] = port->fp_id;
> +	memcpy(addr, sw->base_mac, dev->addr_len - 1);
> +	eth_hw_addr_set_port(dev, addr, port->fp_id);

Instead of having yet another temporary copy, can't we zero out
sw->base_mac[ETH_ALEN - 1] in prestera_switch_set_base_mac_addr()?

>  
>  	err = prestera_hw_port_mac_set(port, dev->dev_addr);
>  	if (err) {
> -- 
> 2.31.1
> 
