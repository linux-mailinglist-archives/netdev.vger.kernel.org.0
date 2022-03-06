Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1EE4CEA5F
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 10:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiCFJs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 04:48:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiCFJsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 04:48:25 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2F46265;
        Sun,  6 Mar 2022 01:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1646560031;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=RoYXG1foArqAIi9p7RoX5ecVJMlMY6MlmJEXhXKeC9Q=;
    b=r2W4qetnffJejcQI5v4IptvTmpYx/nYkX7nMB/iICggjAAc9aFggW4TqqVx4Zlm6EE
    x6M3gzntVpSmxCCiKtot8keupwCTFNYBdCjjXAE963vY1KE5GsIc47BK6d7q4B3+WfFh
    nx8fn7s6ZnVAv8Oc7/xQ0gY6UM+p9VwNxs+Ouq+N8hwy33lcvpvJhv9xPzdlHq49pxFU
    SfygKZ2X2DbYgf6cek0GPKebp1powhFYY5WtX4PKwQkmybobyZWZXSgnMGdBwSaDEUgY
    Qk1SYDL+jwKH+PhBC+ODtaJLHytvu7hvtZOWwLwEOEI11v7sxdroPeNz26Sc83ASOl4t
    JDEw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.40.1 AUTH)
    with ESMTPSA id 6c57e6y269lA4oU
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 6 Mar 2022 10:47:10 +0100 (CET)
Message-ID: <86b4131e-f70c-dfc9-60e1-e91643bb6ed4@hartkopp.net>
Date:   Sun, 6 Mar 2022 10:47:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next 2/8] can: Use netif_rx().
Content-Language: en-US
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org
References: <20220305221252.3063812-1-bigeasy@linutronix.de>
 <20220305221252.3063812-3-bigeasy@linutronix.de>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220305221252.3063812-3-bigeasy@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.03.22 23:12, Sebastian Andrzej Siewior wrote:
> Since commit
>     baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any context.")
> 
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
> 
> Use netif_rx().
> 
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks for the effort Sebastian!

So git blame would not find me anymore for introducing netif_rx_ni() in 
commit 481a8199142c0 from 2009 ;-)

Best regards,
Oliver

> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: linux-can@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   drivers/net/can/dev/dev.c     | 2 +-
>   drivers/net/can/slcan.c       | 2 +-
>   drivers/net/can/spi/hi311x.c  | 6 +++---
>   drivers/net/can/spi/mcp251x.c | 4 ++--
>   drivers/net/can/vcan.c        | 2 +-
>   drivers/net/can/vxcan.c       | 2 +-
>   net/can/af_can.c              | 2 +-
>   7 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
> index c192f25f96956..e7ab45f1c43b2 100644
> --- a/drivers/net/can/dev/dev.c
> +++ b/drivers/net/can/dev/dev.c
> @@ -154,7 +154,7 @@ static void can_restart(struct net_device *dev)
>   
>   	cf->can_id |= CAN_ERR_RESTARTED;
>   
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>   
>   restart:
>   	netdev_dbg(dev, "restarted\n");
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 27783fbf011fc..ec294d0c5722c 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -221,7 +221,7 @@ static void slc_bump(struct slcan *sl)
>   	if (!(cf.can_id & CAN_RTR_FLAG))
>   		sl->dev->stats.rx_bytes += cf.len;
>   
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>   }
>   
>   /* parse tty input stream */
> diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
> index 664b8f14d7b05..a5b2952b8d0ff 100644
> --- a/drivers/net/can/spi/hi311x.c
> +++ b/drivers/net/can/spi/hi311x.c
> @@ -356,7 +356,7 @@ static void hi3110_hw_rx(struct spi_device *spi)
>   
>   	can_led_event(priv->net, CAN_LED_EVENT_RX);
>   
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>   }
>   
>   static void hi3110_hw_sleep(struct spi_device *spi)
> @@ -677,7 +677,7 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
>   			tx_state = txerr >= rxerr ? new_state : 0;
>   			rx_state = txerr <= rxerr ? new_state : 0;
>   			can_change_state(net, cf, tx_state, rx_state);
> -			netif_rx_ni(skb);
> +			netif_rx(skb);
>   
>   			if (new_state == CAN_STATE_BUS_OFF) {
>   				can_bus_off(net);
> @@ -718,7 +718,7 @@ static irqreturn_t hi3110_can_ist(int irq, void *dev_id)
>   				cf->data[6] = hi3110_read(spi, HI3110_READ_TEC);
>   				cf->data[7] = hi3110_read(spi, HI3110_READ_REC);
>   				netdev_dbg(priv->net, "Bus Error\n");
> -				netif_rx_ni(skb);
> +				netif_rx(skb);
>   			}
>   		}
>   
> diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
> index d23edaf224204..fc747bff5eeb2 100644
> --- a/drivers/net/can/spi/mcp251x.c
> +++ b/drivers/net/can/spi/mcp251x.c
> @@ -740,7 +740,7 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
>   
>   	can_led_event(priv->net, CAN_LED_EVENT_RX);
>   
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>   }
>   
>   static void mcp251x_hw_sleep(struct spi_device *spi)
> @@ -987,7 +987,7 @@ static void mcp251x_error_skb(struct net_device *net, int can_id, int data1)
>   	if (skb) {
>   		frame->can_id |= can_id;
>   		frame->data[1] = data1;
> -		netif_rx_ni(skb);
> +		netif_rx(skb);
>   	} else {
>   		netdev_err(net, "cannot allocate error skb\n");
>   	}
> diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
> index c42f18845b02a..a15619d883ec2 100644
> --- a/drivers/net/can/vcan.c
> +++ b/drivers/net/can/vcan.c
> @@ -80,7 +80,7 @@ static void vcan_rx(struct sk_buff *skb, struct net_device *dev)
>   	skb->dev       = dev;
>   	skb->ip_summed = CHECKSUM_UNNECESSARY;
>   
> -	netif_rx_ni(skb);
> +	netif_rx(skb);
>   }
>   
>   static netdev_tx_t vcan_tx(struct sk_buff *skb, struct net_device *dev)
> diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
> index 47ccc15a3486b..556f1a12ec9a0 100644
> --- a/drivers/net/can/vxcan.c
> +++ b/drivers/net/can/vxcan.c
> @@ -63,7 +63,7 @@ static netdev_tx_t vxcan_xmit(struct sk_buff *skb, struct net_device *dev)
>   	skb->ip_summed  = CHECKSUM_UNNECESSARY;
>   
>   	len = cfd->can_id & CAN_RTR_FLAG ? 0 : cfd->len;
> -	if (netif_rx_ni(skb) == NET_RX_SUCCESS) {
> +	if (netif_rx(skb) == NET_RX_SUCCESS) {
>   		srcstats->tx_packets++;
>   		srcstats->tx_bytes += len;
>   		peerstats = &peer->stats;
> diff --git a/net/can/af_can.c b/net/can/af_can.c
> index cce2af10eb3ea..1fb49d51b25d6 100644
> --- a/net/can/af_can.c
> +++ b/net/can/af_can.c
> @@ -284,7 +284,7 @@ int can_send(struct sk_buff *skb, int loop)
>   	}
>   
>   	if (newskb)
> -		netif_rx_ni(newskb);
> +		netif_rx(newskb);
>   
>   	/* update statistics */
>   	pkg_stats->tx_frames++;
