Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF67F9370
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKLO5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:57:18 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35946 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLO5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 09:57:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so18896644wrx.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 06:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RkWjKVRNQNfzGHSWOT8z4Fy/9T8r5WD/gADF2K5BA/Q=;
        b=gthua7DLU5n0wWPbNEzPcrQ92MzUuTXa80zw8BATTPrDwQVcuhkg4LkiqVhi/DZUOS
         F+aL0QIkinxTORpkQT9xGBPNeV6kGUFTrsiff5TWNT3cvobB1lde5cFgSYWQV7CABAhz
         f0qNUN0OrQVag0uo3wp6Hs002LUAy5IqfVFXUD76mPGghbJav22Myzatr0WYxO+FABUB
         HLKIJdxTNLr6c/vrRPpCMFtrNRskBYTn5YFuInE1RVJzrZ1jOTzKb89PvuX3ZrDH2yTC
         aDrdNtPZYihC5de0rzO5C3ZR7YC0Xx3HacOJXUhChSZrHNIeFlvk/6w+Wcgb5Ijau0oh
         CTdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RkWjKVRNQNfzGHSWOT8z4Fy/9T8r5WD/gADF2K5BA/Q=;
        b=ezMdJQ/SF8+ZUjpBXSNenDlrOg0BxEYFt9EbOmw1JArfRL8f5uB366M9cezP4pbtjq
         qaEoYxPRpLTB71fmTULj5WoT4NCf+DCNpvixfj45qJlR2hCTf6B8z5EKNmkxinKBBwYJ
         6Gk9CTKTPdzIV2AsOg3bI7WcUkBoIuB/Ar83iPp4MtP7zy7MLvFA7cN2OTmMvg+XFKKq
         F2l34Mnxi00MSc0ZXCLxdWfj03dtBP1WRCydwcfEEAZAilVay1nf0003Fe0IzECNhfp5
         CVI3eQb2edQPX+e046CCbjrq7DpJD8k4BCUgZ/syOziPvvgSvBpiLtSOD7MTyyYNnF+D
         s5lQ==
X-Gm-Message-State: APjAAAWQy/NRd/gzXH8gpufapIzhOP3/1uca9+UyKw1Hl5vO8qvXJ129
        vASMwqD+ft932xo8WdMDA2BAoQ==
X-Google-Smtp-Source: APXvYqzto+8CZw/bC5LG2vG0lsb1p/SKDdyikSjqiZ3nIVgcM8E149q7bmpTIi+W9Y4h3wSl+md1CA==
X-Received: by 2002:adf:d18b:: with SMTP id v11mr27582629wrc.308.1573570635963;
        Tue, 12 Nov 2019 06:57:15 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id u1sm1324935wmc.3.2019.11.12.06.57.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 06:57:15 -0800 (PST)
Date:   Tue, 12 Nov 2019 15:57:15 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] dpaa2-eth: free already allocated channels on
 probe defer
Message-ID: <20191112145714.ohlnx6pmpkqxs5qs@netronome.com>
References: <1573568693-18642-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573568693-18642-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 04:24:53PM +0200, Ioana Ciornei wrote:
> The setup_dpio() function tries to allocate a number of channels equal
> to the number of CPUs online. When there are not enough DPCON objects
> already probed, the function will return EPROBE_DEFER. When this
> happens, the already allocated channels are not freed. This results in
> the incapacity of properly probing the next time around.
> Fix this by freeing the channels on the error path.
> 
> Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")

Its not clear to me that this clean-up problem was added by
the defer change. But rather, looking at the git logs, it seems
likely to have been present since the driver was added by:

6e2387e8f19e ("staging: fsl-dpaa2/eth: Add Freescale DPAA2 Ethernet driver")

> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - add the proper Fixes tag
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 19379bae0144..22e9519f65bb 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -2232,6 +2232,14 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
>  err_service_reg:
>  	free_channel(priv, channel);
>  err_alloc_ch:
> +	for (i = 0; i < priv->num_channels; i++) {
> +		channel = priv->channel[i];
> +		nctx = &channel->nctx;
> +		dpaa2_io_service_deregister(channel->dpio, nctx, dev);
> +		free_channel(priv, channel);
> +	}
> +	priv->num_channels = 0;
> +
>  	if (err == -EPROBE_DEFER)
>  		return err;

This function goes on to return 0 unless cpumask_empty(&priv->dpio_cpumask)
is zero. Given this is an errorr path and the clean-up above, is that correct?

>  
> -- 
> 1.9.1
> 
