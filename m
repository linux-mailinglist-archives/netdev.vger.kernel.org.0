Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB003162145
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 08:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgBRHCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 02:02:25 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54178 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgBRHCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 02:02:25 -0500
Received: by mail-wm1-f68.google.com with SMTP id s10so1585289wmh.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 23:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OgJg0AGsr2PJfDSLvrALGHqw8zuWtmuWukr9lQ/DVmA=;
        b=KmOPl1k602SHcLODUn+VjkRBGdBxIPUKqn0MdnHVCkLa2Ht/S14WLw12HxiuUSDP6U
         H18qUWFR704hk3X6qOAnhZ1xjokmk4cdQTdg2ZxWIUoDsg3OSAFRopbPkpA+KLOnx/Jr
         j0UWhthS24Gc3Z0YCi7mqBb/uPHMugeOl+6oSiz9BAt/NpxesjEzkGuEMwJ0n8mAYCbv
         7/0IQLD+nPBhyVXOYBNqMfa95mbB0MOqvgv8DUlUK4ldquLu02Vau2gJulAaqcP2mypT
         NVVbyhMLANw5hk8wDJl2ivX+ijf9DydR6NOf+/8JEwWyCAvPYY/nI0vaI1fVWmzNVl4X
         Laaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OgJg0AGsr2PJfDSLvrALGHqw8zuWtmuWukr9lQ/DVmA=;
        b=MtiSpFZWeG5F3ASGyky00joGqXUR0xmV5YXOSNEqHvx8n0lbdrXC/5QOl8SvLbPyVd
         IEV06HI7/H4rrUFTWKNShmqp5SHo2AioLnpZbKOutuSvbHGoqovIGfx7o7PCW2HqFIuG
         Su+ur326FUojMcaSzj8YIGrVTiY/y0cXVQywXAfC8Sj0WCfwUObi4eLyr6YoVPt10Yxd
         ZGVk2mrurNaQgujs7Afv3vAJG9odrYQTTCDvhSTHPxMwS9+K1iSinUXXJty5yNpG4Tnw
         i+aa+QhE7G31c7O5AXgMO/fLoUy1NJzGjBPQSrdzx4VxtvB6HZdW5nsFNiVE7cBz0/09
         OXDA==
X-Gm-Message-State: APjAAAXvxd0hfUTQN2aYnrcQty8MTdHKiyH9U0uzVY6Jb1ryQKR6L2PB
        VwxYPq3Gg74VnOYrZ/wmkFY=
X-Google-Smtp-Source: APXvYqxo58iK4M9Czpc4gP1jPgxydCDC08bsspiyNny+rx0nVluj+5pBtLijTRmgaPymWhPisE/o/A==
X-Received: by 2002:a1c:6246:: with SMTP id w67mr1196644wmb.141.1582009344166;
        Mon, 17 Feb 2020 23:02:24 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:7473:de2c:4563:d28f? ([2003:ea:8f29:6000:7473:de2c:4563:d28f])
        by smtp.googlemail.com with ESMTPSA id f207sm2305791wme.9.2020.02.17.23.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 23:02:23 -0800 (PST)
Subject: Re: [PATCH 3/3] ag71xx: Run ag71xx_link_adjust() only when needed
To:     Hauke Mehrtens <hauke@hauke-m.de>, davem@davemloft.net,
        linux@rempel-privat.de
Cc:     netdev@vger.kernel.org, jcliburn@gmail.com, chris.snook@gmail.com
References: <20200217233518.3159-1-hauke@hauke-m.de>
 <20200217233518.3159-3-hauke@hauke-m.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b980f225-66ca-1ae1-23cf-eff06810b050@gmail.com>
Date:   Tue, 18 Feb 2020 08:02:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200217233518.3159-3-hauke@hauke-m.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 00:35, Hauke Mehrtens wrote:
> My system printed this line every second:
>   ag71xx 19000000.eth eth0: Link is Up - 1Gbps/Full - flow control off
> The function ag71xx_phy_link_adjust() was called by the PHY layer every
> second even when nothing changed.
> 
With current phylib code this shouldn't happen, see phy_check_link_status().
On which kernel version do you observe this behavior?

> With this patch the old status is stored and the real the
> ag71xx_link_adjust() function is only called when something really
> changed. This way the update and also this print is only done once any
> more.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
> ---
>  drivers/net/ethernet/atheros/ag71xx.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
> index 7d3fec009030..12eaf6d2518d 100644
> --- a/drivers/net/ethernet/atheros/ag71xx.c
> +++ b/drivers/net/ethernet/atheros/ag71xx.c
> @@ -307,6 +307,10 @@ struct ag71xx {
>  	u32 msg_enable;
>  	const struct ag71xx_dcfg *dcfg;
>  
> +	unsigned int		link;
> +	unsigned int		speed;
> +	int			duplex;
> +
>  	/* From this point onwards we're not looking at per-packet fields. */
>  	void __iomem *mac_base;
>  
> @@ -854,6 +858,7 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  
>  	if (!phydev->link && update) {
>  		ag71xx_hw_stop(ag);
> +		phy_print_status(phydev);
>  		return;
>  	}
>  
> @@ -907,8 +912,25 @@ static void ag71xx_link_adjust(struct ag71xx *ag, bool update)
>  static void ag71xx_phy_link_adjust(struct net_device *ndev)
>  {
>  	struct ag71xx *ag = netdev_priv(ndev);
> +	struct phy_device *phydev = ndev->phydev;
> +	int status_change = 0;
> +
> +	if (phydev->link) {
> +		if (ag->duplex != phydev->duplex ||
> +		    ag->speed != phydev->speed) {
> +			status_change = 1;
> +		}
> +	}
> +
> +	if (phydev->link != ag->link)
> +		status_change = 1;
> +
> +	ag->link = phydev->link;
> +	ag->duplex = phydev->duplex;
> +	ag->speed = phydev->speed;
>  
> -	ag71xx_link_adjust(ag, true);
> +	if (status_change)
> +		ag71xx_link_adjust(ag, true);
>  }
>  
>  static int ag71xx_phy_connect(struct ag71xx *ag)
> 

