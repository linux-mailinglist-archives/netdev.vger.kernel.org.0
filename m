Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA6FA7A0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfKMDxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:53:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbfKMDxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 22:53:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UbomPZ/cdhIHFL3pRSaxl/jnZn5brFylQEK6Jb6pvyw=; b=sw9G9qsjOlpBwKdbOGkjYaz7HX
        7f1GNkLEHrW+UDRQbR2wYc+X3SYvk0tqXpikIJs6U+D0G+iT3+WE/8s6QB8Mjd6m7YLqoMNsbLXB9
        6AoVqaLO3vdLb5ctdj4b7bvKc7oIV2B+WNM3VLXHM7gXZGlg/L32FXz7a/G25gfaoRso=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUjib-00054i-I6; Wed, 13 Nov 2019 04:53:21 +0100
Date:   Wed, 13 Nov 2019 04:53:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: Print the reset reason
Message-ID: <20191113035321.GC16688@lunn.ch>
References: <20191112212200.5572-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112212200.5572-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 11:22:00PM +0200, Vladimir Oltean wrote:
> Sometimes it can be quite opaque even for me why the driver decided to
> reset the switch. So instead of adding dump_stack() calls each time for
> debugging, just add a reset reason to sja1105_static_config_reload
> calls which gets printed to the console.

> +int sja1105_static_config_reload(struct sja1105_private *priv,
> +				 enum sja1105_reset_reason reason)
>  {
>  	struct ptp_system_timestamp ptp_sts_before;
>  	struct ptp_system_timestamp ptp_sts_after;
> @@ -1405,6 +1413,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
>  out_unlock_ptp:
>  	mutex_unlock(&priv->ptp_data.lock);
>  
> +	dev_info(priv->ds->dev,
> +		 "Reset switch and programmed static config. Reason: %s\n",
> +		 sja1105_reset_reasons[reason]);

If this is for debugging, maybe dev_dbg() would be better?

   Andrew
