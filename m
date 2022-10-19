Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160DA604DE1
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 18:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiJSQz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 12:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiJSQzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 12:55:22 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E3B16E290
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:55:20 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id k2so41448173ejr.2
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 09:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0nbxATf0Pslupnp9w8B/MC+W/4txjYvCbMfD5jVOLs=;
        b=T17THd1SYZZpofG5f3BofsBxODH0gSs5VHdNDAXujrt0ZNYKKtFc+VyNKoBE8GGYRU
         /afV0HXDNkAuhJqzWvMtbY3VVMS4wEKCQmH0Hu58YNhPJURfe4OiTvPCepteyFpIgRnY
         ImPh2HKiuqlzh4EApTXrsihcXCK2wwz3/rEFCPxtfhMMc22GJziZ6wmQ2DlpnjfkpSxD
         OVNUTc0QDKxO3elGdjrmQ9WCYq958o8J8TEfcPI+1MJU05lrDmg4WYqaG1ItjU5h2yxC
         mp8lcfNUn9BSWuTRlctkczv1xjW6c4ZnrDEq6e7YFx8Ls5VUkMeII5wB3QgDE/1Uxcsa
         fIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z0nbxATf0Pslupnp9w8B/MC+W/4txjYvCbMfD5jVOLs=;
        b=EFVoLj+GSe1IEbHqr4EbWhbl7Px9YfOJGIo9q5UYwqp5gJTZjDkPD6bnS/8wjd5AHb
         79PqkG2K1Wz+kA1hFnAzIvA4/9yV4x1hGnsoO4y/mvJlmuyECgAXPl41dhx8rvDWa5nI
         5mIUoBPmuseIWu9WLTE7ZYm32JBvmfXayiDzrhpjhrl8QSp12GRni+2o63KB12LhCbg2
         CbRHJqXFU75GR5rjM+htOZGLFZnhn44ckwVdBSuEPFaXnhFJrdF21ABcirBxe5CyZR8K
         pvbuOL+2Gy9yueptOdwRcc9oK97jwrbDQVwDUA2YW6iLHISNJuH0CAZbPWIBPu626DA9
         gUNQ==
X-Gm-Message-State: ACrzQf1aZKmFRwti34/+PHceiIogHTa52h4zOuXXC5WCGj4xtw+MRniV
        rkw2VITiLHQgGhxzzzWlFTg=
X-Google-Smtp-Source: AMsMyM57jcz71EwLaAHK7FmMdcCmZIx18b4qg2r3hxDhtjwupJzfYrgx5k01/qyy7WGxZMOmTLhQfg==
X-Received: by 2002:a17:906:7193:b0:78d:b87e:6aa5 with SMTP id h19-20020a170906719300b0078db87e6aa5mr7607763ejk.580.1666198519008;
        Wed, 19 Oct 2022 09:55:19 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id gw22-20020a170906f15600b0073d7ab84375sm9301547ejb.92.2022.10.19.09.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 09:55:18 -0700 (PDT)
Date:   Wed, 19 Oct 2022 19:55:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch
Subject: Re: [PATCH v4 net-next] net: ftmac100: support mtu > 1500
Message-ID: <20221019165516.sgoddwmdx6srmh5e@skbuf>
References: <20221019162058.289712-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019162058.289712-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 07:20:58PM +0300, Sergei Antonov wrote:
> The ftmac100 controller considers some packets FTL (frame
> too long) and drops them. An example of a dropped packet:
> 6 bytes - dst MAC
> 6 bytes - src MAC
> 2 bytes - EtherType IPv4 (0800)
> 1504 bytes - IPv4 packet

Why do you insist writing these confusing messages?

It's pretty straightforward. If the FTMAC100 is used as a DSA master,
then it is expected that frames which are MTU sized on the wire facing
the external switch port (1500 octets in L2 payload, plus L2 header)
also get a DSA tag when seen by the host port.

This extra tag increases the length of the packet as the host port sees
it, and the FTMAC100 is not prepared to handle frames whose length
exceeds 1518 octets (including FCS) at all.

Only a minimal rework is needed to support this configuration. Since
MTU-sized DSA-tagged frames still fit within a single buffer (RX_BUF_SIZE),
we just need to optimize the resource management rather than implement
multi buffer RX.

In ndo_mtu_change, we toggle the FTMAC100_MACCR_RX_FTL bit to tell the
hardware to drop (or not) frames with an L2 payload length larger than
1500. And since setting this bit, and accepting frames with the FTL bit
in the BD status, exposes us to the danger of receiving multi-buffer
frames (which we still do not support), we need to replace the BUG_ON()
with a proper call to ftmac100_rx_drop_packet(). We need to replicate
the MACCR configuration in ftmac100_start_hw() as well, since there is a
hardware reset there which clears previous settings.

The advantage of dynamically changing FTMAC100_MACCR_RX_FTL is that when
dev->mtu is at the default value of 1500, large frames are automatically
dropped in hardware and we do not spend CPU cycles dropping them.

> Do the following to let the driver receive these packets.
> Set FTMAC100_MACCR_RX_FTL when mtu>1500 in the MAC Control Register.
> For received packets marked with FTMAC100_RXDES0_FTL check if packet
> length (with FCS excluded) is within expected limits, that is not
> greater than netdev->mtu + 14 (Ethernet headers). Otherwise trigger
> an error.
> 
> Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")

Please drop the Fixes: tag, I thought we agreed this patch wouldn't get
backported, since it does not fix any bug in this driver.

> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>

You essentially did nothing from what I suggested. Please remove this
tag, it is misleading.

> ---
>  drivers/net/ethernet/faraday/ftmac100.c | 29 ++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftmac100.c b/drivers/net/ethernet/faraday/ftmac100.c
> index d95d78230828..f89b53845f21 100644
> --- a/drivers/net/ethernet/faraday/ftmac100.c
> +++ b/drivers/net/ethernet/faraday/ftmac100.c
> @@ -159,6 +159,7 @@ static void ftmac100_set_mac(struct ftmac100 *priv, const unsigned char *mac)
>  static int ftmac100_start_hw(struct ftmac100 *priv)
>  {
>  	struct net_device *netdev = priv->netdev;
> +	unsigned int maccr;
>  
>  	if (ftmac100_reset(priv))
>  		return -EIO;
> @@ -175,7 +176,20 @@ static int ftmac100_start_hw(struct ftmac100 *priv)
>  
>  	ftmac100_set_mac(priv, netdev->dev_addr);
>  
> -	iowrite32(MACCR_ENABLE_ALL, priv->base + FTMAC100_OFFSET_MACCR);
> +	maccr = MACCR_ENABLE_ALL;
> +
> +	/* We have to set FTMAC100_MACCR_RX_FTL in case MTU > 1500
> +	 * and do extra length check in ftmac100_rx_packet_error().
> +	 * Otherwise the controller silently drops these packets.
> +	 *
> +	 * When the MTU of the interface is standard 1500, rely on
> +	 * the controller's functionality to drop too long packets
> +	 * and save some CPU time.
> +	 */
> +	if (netdev->mtu > 1500)
> +		maccr |= FTMAC100_MACCR_RX_FTL;

It is expected that ndo_change_mtu() handles this as well, so that the
MTU change takes effect right away even if the device is open.

> +
> +	iowrite32(maccr, priv->base + FTMAC100_OFFSET_MACCR);
>  	return 0;
>  }
>  
> @@ -337,9 +351,18 @@ static bool ftmac100_rx_packet_error(struct ftmac100 *priv,
>  		error = true;
>  	}
>  
> -	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes))) {
> +	/* If the frame-too-long flag FTMAC100_RXDES0_FTL is set, check
> +	 * if ftmac100_rxdes_frame_length(rxdes) exceeds the currently
> +	 * set MTU plus ETH_HLEN.
> +	 * The controller would set FTMAC100_RXDES0_FTL for all incoming
> +	 * frames longer than 1518 (includeing FCS) in the presense of
> +	 * FTMAC100_MACCR_RX_FTL in the MAC Control Register.
> +	 */
> +	if (unlikely(ftmac100_rxdes_frame_too_long(rxdes) &&
> +		     ftmac100_rxdes_frame_length(rxdes) > netdev->mtu + ETH_HLEN)) {

You didn't explain why you can't drop this altogether?

>  		if (net_ratelimit())
> -			netdev_info(netdev, "rx frame too long\n");
> +			netdev_info(netdev, "rx frame too long (%u)\n",
> +				    ftmac100_rxdes_frame_length(rxdes));
>  
>  		netdev->stats.rx_length_errors++;
>  		error = true;
> -- 
> 2.34.1
> 
