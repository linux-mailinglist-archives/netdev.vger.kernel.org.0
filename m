Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E6C466DEC
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 00:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349609AbhLBXjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 18:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349580AbhLBXjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 18:39:17 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF0CC061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 15:35:54 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id z7so2150203lfi.11
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 15:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mLeHEcXsaetmUx2obFkmfZLklRo9fWRr0Rr3D0Mxua8=;
        b=FnmOsqYQp32nqYJfoTazrkSj+w2JwTRm0fzxaZPuEjSvGsDXT1QRT99MHd0Hs86Gkx
         70DVKt0FIJpXfwRjGqRcPxQ7QDTKxfVVvzD5sGAiCtJ2QBQxPHO9GSsySMDDMIeOSUx8
         eQHbMcvLN1PVnfpuMr4kJs51ejDYfFm/ZMy6GZiIzZNbt5fmeO/lRC5NgI6LbTJBzB5e
         0bXEjY65svQyMMOX1VWatg1aMKW5tMwc0W1xMbTKHhWEGUWLnGtDESGuyz8ZuHNamePq
         ulIJvtX5lZkHUXjyFWSgopdaVGtW8JtXYl1p5y2Jp/3HqCfQxYsRUShB08jYxRoTld2s
         slfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mLeHEcXsaetmUx2obFkmfZLklRo9fWRr0Rr3D0Mxua8=;
        b=A0Jw7lULOEEjmpHL4GHsyjXOe0VXXHya0zAjZ8wLrS+IyQcxGT312DTsmQBC4YF5Z9
         vambnMgY7Bvs4svpLC8YRHLIhDxYeXpN0GJF62fDpbUiJsWpGVdpDmKDoCDQJmS7jvA8
         AmBbvifFfKwvb9XBNSTDbrU/WNqoGun4obil5kSboqCeCpBKZtPU7q8EZCVO/1/q8hzN
         X56ZvCOgGkgeavFwkolDQwAwGS6jKd68txK+RLMVmLK9bqCT7avQuEAWXvAUozN0Lxu3
         DwQWbOc/D2UUbhBruiffPPp39Q55Bp/z0e3A2smQMQtWBkI9Cr0IUlqcM/TEoASjKAWG
         W9vw==
X-Gm-Message-State: AOAM530tBrujcbWy9LcICV4pBvfsq85mE7DhP/rRPV0zPPJ2+Z5jd/8w
        QxlnC/GuHV56/79mvRJcpTS43w==
X-Google-Smtp-Source: ABdhPJxDef5luuOf4nSohZ0qxaL9kR48M70SQegAbQh/Ev5u+O7rmys8uE7MXRaysplM2gxgWX58+w==
X-Received: by 2002:a05:6512:2eb:: with SMTP id m11mr14173161lfq.326.1638488152319;
        Thu, 02 Dec 2021 15:35:52 -0800 (PST)
Received: from [192.168.16.30] (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id t7sm158632lfl.260.2021.12.02.15.35.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 15:35:52 -0800 (PST)
Subject: Re: [PATCH v3 2/5] can: kvaser_usb: do not increase tx statistics
 when sending error message frames
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
 <20211128123734.1049786-3-mailhol.vincent@wanadoo.fr>
From:   Jimmy Assarsson <extja@kvaser.com>
Message-ID: <82ea8723-a234-0dad-ea9f-1b5ccac0b812@kvaser.com>
Date:   Fri, 3 Dec 2021 00:35:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211128123734.1049786-3-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-28 13:37, Vincent Mailhol wrote:
> The CAN error message frames (i.e. error skb) are an interface
> specific to socket CAN. The payload of the CAN error message frames
> does not correspond to any actual data sent on the wire. Only an error
> flag and a delimiter are transmitted when an error occurs (c.f. ISO
> 11898-1 section 10.4.4.2 "Error flag").
> 
> For this reason, it makes no sense to increment the tx_packets and
> tx_bytes fields of struct net_device_stats when sending an error
> message frame because no actual payload will be transmitted on the
> wire.
> 
> N.B. Sending error message frames is a very specific feature which, at
> the moment, is only supported by the Kvaser Hydra hardware. Please
> refer to [1] for more details on the topic.
> 
> [1] https://lore.kernel.org/linux-can/CAMZ6RqK0rTNg3u3mBpZOoY51jLZ-et-J01tY6-+mWsM4meVw-A@mail.gmail.com/t/#u
> 
> CC: Jimmy Assarsson <extja@kvaser.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Hi Vincent!

Thanks for the patch.
There are flags in the TX ACK package, which makes it possible to
determine if it was an error frame or not. So we don't need to get
the original CAN frame to determine this.
I suggest the following change:

---
  .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 25 ++++++++++++-------
  1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c 
b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 3398da323126..01b076f04e26 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -295,6 +295,7 @@ struct kvaser_cmd {
  #define KVASER_USB_HYDRA_CF_FLAG_OVERRUN	BIT(1)
  #define KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME	BIT(4)
  #define KVASER_USB_HYDRA_CF_FLAG_EXTENDED_ID	BIT(5)
+#define KVASER_USB_HYDRA_CF_FLAG_TX_ACK 	BIT(6)
  /* CAN frame flags. Used in ext_rx_can and ext_tx_can */
  #define KVASER_USB_HYDRA_CF_FLAG_OSM_NACK	BIT(12)
  #define KVASER_USB_HYDRA_CF_FLAG_ABL		BIT(13)
@@ -1112,7 +1113,9 @@ static void kvaser_usb_hydra_tx_acknowledge(const 
struct kvaser_usb *dev,
  	struct kvaser_usb_tx_urb_context *context;
  	struct kvaser_usb_net_priv *priv;
  	unsigned long irq_flags;
+	unsigned int len;
  	bool one_shot_fail = false;
+	bool is_err_frame = false;
  	u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);

  	priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
@@ -1131,24 +1134,28 @@ static void 
kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
  			kvaser_usb_hydra_one_shot_fail(priv, cmd_ext);
  			one_shot_fail = true;
  		}
-	}
-
-	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
-	if (!one_shot_fail) {
-		struct net_device_stats *stats = &priv->netdev->stats;
-
-		stats->tx_packets++;
-		stats->tx_bytes += can_fd_dlc2len(context->dlc);
+		if (flags & KVASER_USB_HYDRA_CF_FLAG_TX_ACK &&
+		    flags & KVASER_USB_HYDRA_CF_FLAG_ERROR_FRAME)
+			 is_err_frame = true;
  	}

  	spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);

-	can_get_echo_skb(priv->netdev, context->echo_index, NULL);
+	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
+	len = can_get_echo_skb(priv->netdev, context->echo_index, NULL);
+
  	context->echo_index = dev->max_tx_urbs;
  	--priv->active_tx_contexts;
  	netif_wake_queue(priv->netdev);

  	spin_unlock_irqrestore(&priv->tx_contexts_lock, irq_flags);
+
+	if (!one_shot_fail && !is_err_frame) {
+		struct net_device_stats *stats = &priv->netdev->stats;
+
+		stats->tx_packets++;
+		stats->tx_bytes += len;
+	}
  }

  static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
-- 
2.31.1

Best regards,
jimmy


> ---
>   .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 22 +++++++++++++------
>   1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> index 3398da323126..32fe352dabeb 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> @@ -1111,8 +1111,10 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>   {
>   	struct kvaser_usb_tx_urb_context *context;
>   	struct kvaser_usb_net_priv *priv;
> +	struct can_frame *cf;
>   	unsigned long irq_flags;
> -	bool one_shot_fail = false;
> +	int len;
> +	bool one_shot_fail = false, is_err_frame = false;
>   	u16 transid = kvaser_usb_hydra_get_cmd_transid(cmd);
>   
>   	priv = kvaser_usb_hydra_net_priv_from_cmd(dev, cmd);
> @@ -1134,21 +1136,27 @@ static void kvaser_usb_hydra_tx_acknowledge(const struct kvaser_usb *dev,
>   	}
>   
>   	context = &priv->tx_contexts[transid % dev->max_tx_urbs];
> -	if (!one_shot_fail) {
> -		struct net_device_stats *stats = &priv->netdev->stats;
> -
> -		stats->tx_packets++;
> -		stats->tx_bytes += can_fd_dlc2len(context->dlc);
> -	}
> +	len = context->dlc;
>   
>   	spin_lock_irqsave(&priv->tx_contexts_lock, irq_flags);
>   
> +	cf = (struct can_frame *)priv->can.echo_skb[context->echo_index]->data;
> +	if (cf)
> +		is_err_frame = !!(cf->can_id & CAN_RTR_FLAG);
> +
>   	can_get_echo_skb(priv->netdev, context->echo_index, NULL);
>   	context->echo_index = dev->max_tx_urbs;
>   	--priv->active_tx_contexts;
>   	netif_wake_queue(priv->netdev);
>   
>   	spin_unlock_irqrestore(&priv->tx_contexts_lock, irq_flags);
> +
> +	if (!one_shot_fail && !is_err_frame) {
> +		struct net_device_stats *stats = &priv->netdev->stats;
> +
> +		stats->tx_packets++;
> +		stats->tx_bytes += len;
> +	}
>   }
>   
>   static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
> 
