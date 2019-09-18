Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA7B68F9
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 19:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbfIRRVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 13:21:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730652AbfIRRVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 13:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=t0p8DMx4a+O9FwZ99pZSsg0M4i1kOMfQyAHGuGysuvs=; b=0REIy+73DQKdb5SHSz2yDLhuVw
        5J0nLX/QrbGrFaKRqZNZLTHzVz2DaA327h/O/7XluV3JSlMpQmBk+yXyU2iVz8R54nX5Ii63jWLO7
        bNeKS+TKzrxfn346dwev3r19m2PjTH524Nz7u/3hZSYc7/4QCSEgtm7ACNySDGoxStB8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAdda-0000mP-3q; Wed, 18 Sep 2019 19:21:06 +0200
Date:   Wed, 18 Sep 2019 19:21:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: sja1105: prevent leaking memory
Message-ID: <20190918172106.GN9591@lunn.ch>
References: <20190918171020.5745-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918171020.5745-1-navid.emamdoost@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:10:19PM -0500, Navid Emamdoost wrote:
> In sja1105_static_config_upload, in two cases memory is leaked: when
> static_config_buf_prepare_for_upload fails and when sja1105_inhibit_tx
> fails. In both cases config_buf should be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Hi Navid

Please could you provide a Fixes: tag for where this memory leak was
introduced.

> ---
>  drivers/net/dsa/sja1105/sja1105_spi.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
> index 84dc603138cf..80e86c714efb 100644
> --- a/drivers/net/dsa/sja1105/sja1105_spi.c
> +++ b/drivers/net/dsa/sja1105/sja1105_spi.c
> @@ -408,8 +408,9 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
>  
>  	rc = static_config_buf_prepare_for_upload(priv, config_buf, buf_len);
>  	if (rc < 0) {
> -		dev_err(dev, "Invalid config, cannot upload\n");
> -		return -EINVAL;
> +		dev_err(dev, "Invalid config, cannot upload\n");

What changed in this dev_err() call?

Thanks
	Andrew
