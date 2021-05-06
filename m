Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E106E3752FD
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhEFL0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234675AbhEFLZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:25:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A36BC061574;
        Thu,  6 May 2021 04:25:01 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id v12so5196835wrq.6;
        Thu, 06 May 2021 04:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HxnqpNt6mcYg+tpVO7/VIuYyoF/XTeRz4KcEC8rcBIU=;
        b=qgQpFcrKCuEv3kku5bcrlB/6jGtGWkUTXJ64cCChAhteGhcYFl4EmU+MDBmel1MXvl
         yXbrPy3oCeqfbZMYyQ7uHduWjhFNhIP1xALPp3kVm+qGuWecczZNqPT/ouLmz5SYP4gT
         TGMMcVSWWP68NdS9G2EErM8tqgdyEzk1J2AIXtljVlIK0U7oqVXl72HRxefrK0XBsjEH
         jWAabxt3ndxrnlcB/5zmZaTNUxh3iHBxBSBsER8xlaMkML6zguDb7mX4CH5QxSaR2/vw
         OJu8hzamHgc6w6Xdwg9f6qZXAtOOPwO3vtte4U/cOo33pDeoi5ec8gGs9B+xZFkS/osW
         buvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HxnqpNt6mcYg+tpVO7/VIuYyoF/XTeRz4KcEC8rcBIU=;
        b=fy5yuEn3sk+fLz154YfAojvku/AZVy0yC4zCHwb6hgg9URRPYTkfGSFCPx0juIJ3UJ
         YZ4acqB8VJcUx5RvoENtO8uOCkqyA51Zs1JZD7Nw3mXWgMrYUeSGLKO+efX1lkTo+oS7
         ntHDmIXo8bDJnM7AGlFdrlWDOwLdRSEoM+JZR6n9oAL9flZKQIc8Q4BPkZ1BJjGJUTnT
         9xyEu8zyh4WSjD3JG7xPkjZxvXEqxE5V1AO16P6qAxNCtrVMkE4u1YTlp/Io6gtBFgq4
         rFGlaAv47XFe8oqCuN8wq93aA/lWJi2l3uYzcI9fFPWracU2VAv7GTJbdGnkXkBmN1YR
         p60Q==
X-Gm-Message-State: AOAM5317H8Rahwga2417dgTs8F3iF/Vuth49xeixeDcxD1xZACXE5uq/
        zsX5rsuNfmXGQJZHstYdYQo=
X-Google-Smtp-Source: ABdhPJyWGNtsyGTB6YDQ0H3zkQ3hRmApt1oi8C1ykbwMELhDidG71jw6V5eNNDJ47Apn7a7JUIDbPA==
X-Received: by 2002:adf:ef47:: with SMTP id c7mr4435013wrp.297.1620300300191;
        Thu, 06 May 2021 04:25:00 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id s10sm3736138wru.55.2021.05.06.04.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:24:59 -0700 (PDT)
Date:   Thu, 6 May 2021 14:24:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass
 switch_revision info to phy dev_flags
Message-ID: <20210506112458.yhgbpifebusc2eal@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-19-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-19-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 12:29:13AM +0200, Ansuel Smith wrote:
> Define get_phy_flags to pass switch_Revision needed to tweak the
> internal PHY with debug values based on the revision.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index b4cd891ad35d..237e09bb1425 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1654,6 +1654,24 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
>  	return ret;
>  }
>  
> +static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +
> +	pr_info("revision from phy %d", priv->switch_revision);

Log spam.

> +	/* Communicate to the phy internal driver the switch revision.
> +	 * Based on the switch revision different values needs to be
> +	 * set to the dbg and mmd reg on the phy.
> +	 * The first 2 bit are used to communicate the switch revision
> +	 * to the phy driver.
> +	 */
> +	if (port > 0 && port < 6)
> +		return priv->switch_revision;
> +
> +	return 0;
> +}
> +
>  static enum dsa_tag_protocol
>  qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
>  		       enum dsa_tag_protocol mp)
> @@ -1687,6 +1705,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
>  	.phylink_mac_config	= qca8k_phylink_mac_config,
>  	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
>  	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
> +	.get_phy_flags		= qca8k_get_phy_flags,
>  };
>  
>  static int qca8k_read_switch_id(struct qca8k_priv *priv)
> -- 
> 2.30.2
> 

Florian, I think at one point you said that a correct user of
phydev->dev_flags should first check the PHY revision and not apply
dev_flags in blind, since they are namespaced to each PHY driver?
It sounds a bit circular to pass the PHY revision to the PHY through
phydev->dev_flags, either that or I'm missing some piece.
