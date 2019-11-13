Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F01EFAB9E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 09:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKMID4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 03:03:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40519 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKMID4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 03:03:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id i10so1172786wrs.7
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 00:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7TQHGsN3mozrWFIJwAEDpbojgUjtHC/Hf8HJqYnnYPE=;
        b=sf/xpIwonLjUmRgpNpsvWQWuucv7CBFGwgLGp9i7Od3UCF4uIEp5XlNIgKGKxVlaO9
         9duxaim1tjG/coKaFAXeARAgY9ggYS0+vi6i/aSgJAmWJHFi0bgenlyy/684DJv1KYnH
         OYZ5g3CnzTHeFE8x39LNyYHdsFM/i8V1N4PRci/EDo8gJYcq2XT5Mhcw4aoq7BBiv0mu
         Y7C3cLpEV68FzRJ2mIiucc4Vzi0NeDHTLT7xZgGFAO7AE+8v9iabiT78cyLDF3gS9cCO
         irl2SjOXBEGwvTNZdb3//ovWGI1pvNI013ulACq6L41QMwB5gHv7AA65ImGSrtsBb4Ck
         +3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7TQHGsN3mozrWFIJwAEDpbojgUjtHC/Hf8HJqYnnYPE=;
        b=qb/KwcsX1vO1jNYzkTN9IChVfXAdcxIvVaZLSr/etq79ivbaw4XLvYZ/rnv08N23rk
         epR7EWYjccjO/URi+/RIsUbYZ9Gk4fJZS7xuC85pfIZB2lw2sUlvLOILMy80vq1qOEDy
         yJiD3wFsMBJUI3D5O+szSvBu+cpmzuA9UngTieWcQRq5I/VnjK3RyzLGTruCdB1TMEfn
         7YpfErZM74b4YTHHbOEUQwkXGH+gr5OrjQUXDZImgzXaSPNSxZRAEAz1bSx25BtL6pQs
         oRd7KiFrZQvYfrb74XrKS8DycYlehenEVC3qCWG22mIERNwAlVvgfgtHmaclhvfClu7m
         9yrw==
X-Gm-Message-State: APjAAAUsxwxfJm/urGwU8GYUnOMIOuzQq26cKaCJWpgl/PgVJmhDAx59
        pARyRa+zSARVJm88CG08RBwhLER4Gsg=
X-Google-Smtp-Source: APXvYqz19ITCrhNm12KQaRjjuBS6cV3qt+ZwY+fHWtfYVHoSjqBmjJp0ZuZV63CNjOGEUR2aM1IMMQ==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr1562400wrr.287.1573632234649;
        Wed, 13 Nov 2019 00:03:54 -0800 (PST)
Received: from netronome.com ([2001:982:756:703:d63d:7eff:fe99:ac9d])
        by smtp.gmail.com with ESMTPSA id v9sm1760709wrs.95.2019.11.13.00.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Nov 2019 00:03:54 -0800 (PST)
Date:   Wed, 13 Nov 2019 09:03:53 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v3] dpaa2-eth: free already allocated channels on
 probe defer
Message-ID: <20191113080352.55gde2wvsrccf2rp@netronome.com>
References: <1573575712-1366-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573575712-1366-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 06:21:52PM +0200, Ioana Ciornei wrote:
> The setup_dpio() function tries to allocate a number of channels equal
> to the number of CPUs online. When there are not enough DPCON objects
> already probed, the function will return EPROBE_DEFER. When this
> happens, the already allocated channels are not freed. This results in
> the incapacity of properly probing the next time around.
> Fix this by freeing the channels on the error path.
> 
> Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks for the update,

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
> Changes in v2:
>  - add the proper Fixes tag
> Changes in v3:
>  - cleanup should be done only on EPROBE_DEFER
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 19379bae0144..bf5add954181 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -2232,8 +2232,16 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
>  err_service_reg:
>  	free_channel(priv, channel);
>  err_alloc_ch:
> -	if (err == -EPROBE_DEFER)
> +	if (err == -EPROBE_DEFER) {
> +		for (i = 0; i < priv->num_channels; i++) {
> +			channel = priv->channel[i];
> +			nctx = &channel->nctx;
> +			dpaa2_io_service_deregister(channel->dpio, nctx, dev);
> +			free_channel(priv, channel);
> +		}
> +		priv->num_channels = 0;
>  		return err;
> +	}
>  
>  	if (cpumask_empty(&priv->dpio_cpumask)) {
>  		dev_err(dev, "No cpu with an affine DPIO/DPCON\n");
> -- 
> 1.9.1
> 
