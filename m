Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669D7466DE2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 00:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377569AbhLBXio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 18:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377541AbhLBXin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 18:38:43 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D64C061758
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 15:35:20 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id z7so2147827lfi.11
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 15:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kWf2l9B2+kfDuUhK2YxNWO7Djat8XxrblFb/8AoFWag=;
        b=v6TIjBPXNNJwhcoOS1Hr7NlWZLPl8Z4ZHJJHKE5QkjwizTEPmVTo6wFGAZjXCtaL7W
         n6Vwbvuju/kxOAdtz73hphD2NarONBU7Ph1ddnJeXe1QxiOQCxgY2PbTySinwthFM94q
         hJLOqwswlTTv6Cb5tbfiJKX611dyXf6EdDTTTIgRsdvT6a1F4caMaBRZMiMAgQVneDi6
         Pytf8AhsUcXXT43LQDvgs2lfiv16HfS9+bPRHxUBTAdZcKQcjTEmmxBF3qAYnsP4D/Yi
         Oi0RHP3+lIx4wjYlVs3QdJg6ngdy71gyi/MyQsp0rL6HcFIxVf7StR2XtNILBbDuH+Qa
         1OGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kWf2l9B2+kfDuUhK2YxNWO7Djat8XxrblFb/8AoFWag=;
        b=qoZhbFjyGSSKi4DnwW5abGwgjpDu5RgN54Kv8BKRMcfH4rj7xdF2uNxHhShV6zytM/
         jVwEiTMMOHNqM6wgusY1p3fMoFGmpIj+XYD6SU2rtKwJwardRi0oBtHcle5JfMg1az4T
         WVK56hNBZIjSGOW3caMjm+vySNUmmqWCPfIDeshcuzeQacIyQsKvgzI1fSTCzmv0XSg6
         BwBU0yuhzb841X6hTczu5ToR7cAgC8YFsYXJ7bMKJCnWBZyvEN0CmxgCumal1Hk9fgc2
         vq0+jS2wvee1KomsBDoKvVnt3QOUPwVXOyi/nxK0VhuZGLuy/LMx6gpAaT4mS7f+4ky7
         sxqA==
X-Gm-Message-State: AOAM533qxJboZ9pWf+hnPYjReLri1praD1vvstPzU/NchcgPgJpM13vD
        e+oeJdfjbe9Q96S91AkMM15n4w==
X-Google-Smtp-Source: ABdhPJy1U6q3KRm/G2xq0FDPGM8dl2Xzk0JTd1GsgJIBzG3W53oYswe+N/nhwsAaQ+reoMYDvWxT8w==
X-Received: by 2002:a05:6512:11c5:: with SMTP id h5mr14718537lfr.431.1638488118169;
        Thu, 02 Dec 2021 15:35:18 -0800 (PST)
Received: from [192.168.16.30] (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id d2sm145358lfj.73.2021.12.02.15.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 15:35:17 -0800 (PST)
Subject: Re: [PATCH v3 4/5] can: do not increase rx_bytes statistics for RTR
 frames
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Yasushi SHOJI <yashi@spacecubics.com>,
        Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>
References: <20211128123734.1049786-1-mailhol.vincent@wanadoo.fr>
 <20211128123734.1049786-5-mailhol.vincent@wanadoo.fr>
From:   Jimmy Assarsson <extja@kvaser.com>
Message-ID: <17afeb5f-d977-c176-30b3-d87747e18060@kvaser.com>
Date:   Fri, 3 Dec 2021 00:35:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211128123734.1049786-5-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-28 13:37, Vincent Mailhol wrote:
> The actual payload length of the CAN Remote Transmission Request (RTR)
> frames is always 0, i.e. nothing is transmitted on the wire. However,
> those RTR frames still use the DLC to indicate the length of the
> requested frame.
> 
> As such, net_device_stats:rx_bytes should not be increased for the RTR
> frames.
> 
> This patch fixes all the CAN drivers.

Hi Vincent!

Thanks for the patch!
I've reviewed and tested the changes affecting kvaser_{pciefd,usb}.
Looks good to me!

Best regards,
jimmy

> CC: Jimmy Assarsson <extja@kvaser.com>
> CC: Marc Kleine-Budde <mkl@pengutronix.de>
> CC: Nicolas Ferre <nicolas.ferre@microchip.com>
> CC: Alexandre Belloni <alexandre.belloni@bootlin.com>
> CC: Ludovic Desroches <ludovic.desroches@microchip.com>
> CC: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
> CC: Maxime Ripard <mripard@kernel.org>
> CC: Chen-Yu Tsai <wens@csie.org>
> CC: Jernej Skrabec <jernej.skrabec@gmail.com>
> CC: Yasushi SHOJI <yashi@spacecubics.com>
> CC: Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>
> CC: Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>
> CC: Michal Simek <michal.simek@xilinx.com>
> CC: Stephane Grosjean <s.grosjean@peak-system.com>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
>   drivers/net/can/at91_can.c                       |  4 +++-
>   drivers/net/can/c_can/c_can_main.c               |  4 ++--
>   drivers/net/can/cc770/cc770.c                    |  5 +++--
>   drivers/net/can/dev/rx-offload.c                 |  3 ++-
>   drivers/net/can/grcan.c                          |  6 +++---
>   drivers/net/can/ifi_canfd/ifi_canfd.c            |  6 +++---
>   drivers/net/can/janz-ican3.c                     |  3 ++-
>   drivers/net/can/kvaser_pciefd.c                  | 11 ++++++-----
>   drivers/net/can/m_can/m_can.c                    |  6 +++---
>   drivers/net/can/mscan/mscan.c                    |  3 ++-
>   drivers/net/can/pch_can.c                        |  6 +++---
>   drivers/net/can/peak_canfd/peak_canfd.c          |  7 ++++---
>   drivers/net/can/rcar/rcar_can.c                  |  5 +++--
>   drivers/net/can/rcar/rcar_canfd.c                |  3 ++-
>   drivers/net/can/sja1000/sja1000.c                |  5 +++--
>   drivers/net/can/slcan.c                          |  4 +++-
>   drivers/net/can/spi/hi311x.c                     |  7 ++++---
>   drivers/net/can/spi/mcp251x.c                    |  5 +++--
>   drivers/net/can/sun4i_can.c                      | 10 ++++++----
>   drivers/net/can/usb/ems_usb.c                    |  5 +++--
>   drivers/net/can/usb/esd_usb2.c                   |  5 +++--
>   .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c    | 16 ++++++++++------
>   drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |  3 ++-
>   drivers/net/can/usb/mcba_usb.c                   |  7 ++++---
>   drivers/net/can/usb/peak_usb/pcan_usb.c          |  7 ++++---
>   drivers/net/can/usb/peak_usb/pcan_usb_fd.c       |  8 ++++----
>   drivers/net/can/usb/peak_usb/pcan_usb_pro.c      | 10 ++++++----
>   drivers/net/can/usb/ucan.c                       |  3 ++-
>   drivers/net/can/usb/usb_8dev.c                   |  9 +++++----
>   drivers/net/can/xilinx_can.c                     | 10 +++++++---
>   30 files changed, 110 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
> index 3cd872cf9be6..97f1d08b4133 100644
> --- a/drivers/net/can/at91_can.c
> +++ b/drivers/net/can/at91_can.c
> @@ -617,7 +617,9 @@ static void at91_read_msg(struct net_device *dev, unsigned int mb)
>   	at91_read_mb(dev, mb, cf);
>   
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +	if (!(cf->can_id & CAN_RTR_FLAG))
> +		stats->rx_bytes += cf->len;
> +
>   	netif_receive_skb(skb);
>   
>   	can_led_event(dev, CAN_LED_EVENT_RX);
> diff --git a/drivers/net/can/c_can/c_can_main.c b/drivers/net/can/c_can/c_can_main.c
> index 670754a12984..29e91804d81c 100644
> --- a/drivers/net/can/c_can/c_can_main.c
> +++ b/drivers/net/can/c_can/c_can_main.c
> @@ -403,10 +403,10 @@ static int c_can_read_msg_object(struct net_device *dev, int iface, u32 ctrl)
>   				frame->data[i + 1] = data >> 8;
>   			}
>   		}
> -	}
>   
> +		stats->rx_bytes += frame->len;
> +	}
>   	stats->rx_packets++;
> -	stats->rx_bytes += frame->len;
>   
>   	netif_receive_skb(skb);
>   	return 0;
> diff --git a/drivers/net/can/cc770/cc770.c b/drivers/net/can/cc770/cc770.c
> index a5fd8ccedec2..994073c0a2f6 100644
> --- a/drivers/net/can/cc770/cc770.c
> +++ b/drivers/net/can/cc770/cc770.c
> @@ -489,10 +489,11 @@ static void cc770_rx(struct net_device *dev, unsigned int mo, u8 ctrl1)
>   		cf->len = can_cc_dlc2len((config & 0xf0) >> 4);
>   		for (i = 0; i < cf->len; i++)
>   			cf->data[i] = cc770_read_reg(priv, msgobj[mo].data[i]);
> -	}
>   
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +
>   	netif_rx(skb);
>   }
>   
> diff --git a/drivers/net/can/dev/rx-offload.c b/drivers/net/can/dev/rx-offload.c
> index 7dbf46b9ca5d..7f80d8e1e750 100644
> --- a/drivers/net/can/dev/rx-offload.c
> +++ b/drivers/net/can/dev/rx-offload.c
> @@ -56,7 +56,8 @@ static int can_rx_offload_napi_poll(struct napi_struct *napi, int quota)
>   		work_done++;
>   		if (!(cf->can_id & CAN_ERR_FLAG)) {
>   			stats->rx_packets++;
> -			stats->rx_bytes += cf->len;
> +			if (!(cf->can_id & CAN_RTR_FLAG))
> +				stats->rx_bytes += cf->len;
>   		}
>   		netif_receive_skb(skb);
>   	}
> diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
> index 78e27940b2af..1b8ef97e4139 100644
> --- a/drivers/net/can/grcan.c
> +++ b/drivers/net/can/grcan.c
> @@ -1211,11 +1211,11 @@ static int grcan_receive(struct net_device *dev, int budget)
>   				shift = GRCAN_MSG_DATA_SHIFT(i);
>   				cf->data[i] = (u8)(slot[j] >> shift);
>   			}
> -		}
>   
> -		/* Update statistics and read pointer */
> +			stats->rx_bytes += cf->len;
> +		}
>   		stats->rx_packets++;
> -		stats->rx_bytes += cf->len;
> +
>   		netif_receive_skb(skb);
>   
>   		rd = grcan_ring_add(rd, GRCAN_MSG_SIZE, dma->rx.size);
> diff --git a/drivers/net/can/ifi_canfd/ifi_canfd.c b/drivers/net/can/ifi_canfd/ifi_canfd.c
> index e8318e984bf2..b0a3473f211d 100644
> --- a/drivers/net/can/ifi_canfd/ifi_canfd.c
> +++ b/drivers/net/can/ifi_canfd/ifi_canfd.c
> @@ -309,15 +309,15 @@ static void ifi_canfd_read_fifo(struct net_device *ndev)
>   			*(u32 *)(cf->data + i) =
>   				readl(priv->base + IFI_CANFD_RXFIFO_DATA + i);
>   		}
> +
> +		stats->rx_bytes += cf->len;
>   	}
> +	stats->rx_packets++;
>   
>   	/* Remove the packet from FIFO */
>   	writel(IFI_CANFD_RXSTCMD_REMOVE_MSG, priv->base + IFI_CANFD_RXSTCMD);
>   	writel(rx_irq_mask, priv->base + IFI_CANFD_INTERRUPT);
>   
> -	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> -
>   	netif_receive_skb(skb);
>   }
>   
> diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
> index 32006dbf5abd..5c589aa9dff8 100644
> --- a/drivers/net/can/janz-ican3.c
> +++ b/drivers/net/can/janz-ican3.c
> @@ -1421,7 +1421,8 @@ static int ican3_recv_skb(struct ican3_dev *mod)
>   
>   	/* update statistics, receive the skb */
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +	if (!(cf->can_id & CAN_RTR_FLAG))
> +		stats->rx_bytes += cf->len;
>   	netif_receive_skb(skb);
>   
>   err_noalloc:
> diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
> index 483fbd9e6952..6fd6bed04577 100644
> --- a/drivers/net/can/kvaser_pciefd.c
> +++ b/drivers/net/can/kvaser_pciefd.c
> @@ -1182,20 +1182,21 @@ static int kvaser_pciefd_handle_data_packet(struct kvaser_pciefd *pcie,
>   
>   	cf->len = can_fd_dlc2len(p->header[1] >> KVASER_PCIEFD_RPACKET_DLC_SHIFT);
>   
> -	if (p->header[0] & KVASER_PCIEFD_RPACKET_RTR)
> +	if (p->header[0] & KVASER_PCIEFD_RPACKET_RTR) {
>   		cf->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(cf->data, data, cf->len);
>   
> +		stats->rx_bytes += cf->len;
> +	}
> +	stats->rx_packets++;
> +
>   	shhwtstamps = skb_hwtstamps(skb);
>   
>   	shhwtstamps->hwtstamp =
>   		ns_to_ktime(div_u64(p->timestamp * 1000,
>   				    pcie->freq_to_ticks_div));
>   
> -	stats->rx_bytes += cf->len;
> -	stats->rx_packets++;
> -
>   	return netif_rx(skb);
>   }
>   
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index c33035e706bc..5dae51212390 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -518,14 +518,14 @@ static int m_can_read_fifo(struct net_device *dev, u32 rxfs)
>   				      cf->data, DIV_ROUND_UP(cf->len, 4));
>   		if (err)
>   			goto out_free_skb;
> +
> +		stats->rx_bytes += cf->len;
>   	}
> +	stats->rx_packets++;
>   
>   	/* acknowledge rx fifo 0 */
>   	m_can_write(cdev, M_CAN_RXF0A, fgi);
>   
> -	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> -
>   	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
>   
>   	m_can_receive_skb(cdev, skb, timestamp);
> diff --git a/drivers/net/can/mscan/mscan.c b/drivers/net/can/mscan/mscan.c
> index 9e1cce0260da..59b8284d00e5 100644
> --- a/drivers/net/can/mscan/mscan.c
> +++ b/drivers/net/can/mscan/mscan.c
> @@ -404,7 +404,8 @@ static int mscan_rx_poll(struct napi_struct *napi, int quota)
>   		if (canrflg & MSCAN_RXF) {
>   			mscan_get_rx_frame(dev, frame);
>   			stats->rx_packets++;
> -			stats->rx_bytes += frame->len;
> +			if (!(frame->can_id & CAN_RTR_FLAG))
> +				stats->rx_bytes += frame->len;
>   		} else if (canrflg & MSCAN_ERR_IF) {
>   			mscan_get_err_frame(dev, frame, canrflg);
>   		}
> diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> index 4bf9bfc4de72..b46f9cfb9e0a 100644
> --- a/drivers/net/can/pch_can.c
> +++ b/drivers/net/can/pch_can.c
> @@ -688,12 +688,12 @@ static int pch_can_rx_normal(struct net_device *ndev, u32 obj_num, int quota)
>   				cf->data[i] = data_reg;
>   				cf->data[i + 1] = data_reg >> 8;
>   			}
> -		}
>   
> -		rcv_pkts++;
> +			stats->rx_bytes += cf->len;
> +		}
>   		stats->rx_packets++;
> +		rcv_pkts++;
>   		quota--;
> -		stats->rx_bytes += cf->len;
>   		netif_receive_skb(skb);
>   
>   		pch_fifo_thresh(priv, obj_num);
> diff --git a/drivers/net/can/peak_canfd/peak_canfd.c b/drivers/net/can/peak_canfd/peak_canfd.c
> index d5b8bc6d2980..216609198eac 100644
> --- a/drivers/net/can/peak_canfd/peak_canfd.c
> +++ b/drivers/net/can/peak_canfd/peak_canfd.c
> @@ -310,12 +310,13 @@ static int pucan_handle_can_rx(struct peak_canfd_priv *priv,
>   	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
>   		cf->can_id |= CAN_EFF_FLAG;
>   
> -	if (rx_msg_flags & PUCAN_MSG_RTR)
> +	if (rx_msg_flags & PUCAN_MSG_RTR) {
>   		cf->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(cf->data, msg->d, cf->len);
>   
> -	stats->rx_bytes += cf->len;
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
>   
>   	pucan_netif_rx(skb, msg->ts_low, msg->ts_high);
> diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
> index f408ed9a6ccd..62bbd58bfef8 100644
> --- a/drivers/net/can/rcar/rcar_can.c
> +++ b/drivers/net/can/rcar/rcar_can.c
> @@ -662,12 +662,13 @@ static void rcar_can_rx_pkt(struct rcar_can_priv *priv)
>   		for (dlc = 0; dlc < cf->len; dlc++)
>   			cf->data[dlc] =
>   			readb(&priv->regs->mb[RCAR_CAN_RX_FIFO_MBX].data[dlc]);
> +
> +		stats->rx_bytes += cf->len;
>   	}
> +	stats->rx_packets++;
>   
>   	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
>   
> -	stats->rx_bytes += cf->len;
> -	stats->rx_packets++;
>   	netif_receive_skb(skb);
>   }
>   
> diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
> index db9d62874e15..b1eded2f2c5d 100644
> --- a/drivers/net/can/rcar/rcar_canfd.c
> +++ b/drivers/net/can/rcar/rcar_canfd.c
> @@ -1550,7 +1550,8 @@ static void rcar_canfd_rx_pkt(struct rcar_canfd_channel *priv)
>   
>   	can_led_event(priv->ndev, CAN_LED_EVENT_RX);
>   
> -	stats->rx_bytes += cf->len;
> +	if (!(cf->can_id & CAN_RTR_FLAG))
> +		stats->rx_bytes += cf->len;
>   	stats->rx_packets++;
>   	netif_receive_skb(skb);
>   }
> diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
> index a65546ca9461..4bf44d449987 100644
> --- a/drivers/net/can/sja1000/sja1000.c
> +++ b/drivers/net/can/sja1000/sja1000.c
> @@ -372,15 +372,16 @@ static void sja1000_rx(struct net_device *dev)
>   	} else {
>   		for (i = 0; i < cf->len; i++)
>   			cf->data[i] = priv->read_reg(priv, dreg++);
> +
> +		stats->rx_bytes += cf->len;
>   	}
> +	stats->rx_packets++;
>   
>   	cf->can_id = id;
>   
>   	/* release receive buffer */
>   	sja1000_write_cmdreg(priv, CMD_RRB);
>   
> -	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
>   	netif_rx(skb);
>   
>   	can_led_event(dev, CAN_LED_EVENT_RX);
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 9a4ebda30510..5cf03458e948 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -218,7 +218,9 @@ static void slc_bump(struct slcan *sl)
>   	skb_put_data(skb, &cf, sizeof(struct can_frame));
>   
>   	sl->dev->stats.rx_packets++;
> -	sl->dev->stats.rx_bytes += cf.len;
> +	if (!(cf.can_id & CAN_RTR_FLAG))
> +		sl->dev->stats.rx_bytes += cf.len;
> +
>   	netif_rx_ni(skb);
>   }
>   
> diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
> index 89d9c986a229..771a13945032 100644
> --- a/drivers/net/can/spi/hi311x.c
> +++ b/drivers/net/can/spi/hi311x.c
> @@ -343,14 +343,15 @@ static void hi3110_hw_rx(struct spi_device *spi)
>   	/* Data length */
>   	frame->len = can_cc_dlc2len(buf[HI3110_FIFO_WOTIME_DLC_OFF] & 0x0F);
>   
> -	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR)
> +	if (buf[HI3110_FIFO_WOTIME_ID_OFF + 3] & HI3110_FIFO_WOTIME_ID_RTR) {
>   		frame->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(frame->data, buf + HI3110_FIFO_WOTIME_DAT_OFF,
>   		       frame->len);
>   
> +		priv->net->stats.rx_bytes += frame->len;
> +	}
>   	priv->net->stats.rx_packets++;
> -	priv->net->stats.rx_bytes += frame->len;
>   
>   	can_led_event(priv->net, CAN_LED_EVENT_RX);
>   
> diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
> index db3fa98569c4..b46516b7d39f 100644
> --- a/drivers/net/can/spi/mcp251x.c
> +++ b/drivers/net/can/spi/mcp251x.c
> @@ -733,11 +733,12 @@ static void mcp251x_hw_rx(struct spi_device *spi, int buf_idx)
>   	}
>   	/* Data length */
>   	frame->len = can_cc_dlc2len(buf[RXBDLC_OFF] & RXBDLC_LEN_MASK);
> -	if (!(frame->can_id & CAN_RTR_FLAG))
> +	if (!(frame->can_id & CAN_RTR_FLAG)) {
>   		memcpy(frame->data, buf + RXBDAT_OFF, frame->len);
>   
> +		priv->net->stats.rx_bytes += frame->len;
> +	}
>   	priv->net->stats.rx_packets++;
> -	priv->net->stats.rx_bytes += frame->len;
>   
>   	can_led_event(priv->net, CAN_LED_EVENT_RX);
>   
> diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
> index 599174098883..6a7d89c4648c 100644
> --- a/drivers/net/can/sun4i_can.c
> +++ b/drivers/net/can/sun4i_can.c
> @@ -490,18 +490,20 @@ static void sun4i_can_rx(struct net_device *dev)
>   	}
>   
>   	/* remote frame ? */
> -	if (fi & SUN4I_MSG_RTR_FLAG)
> +	if (fi & SUN4I_MSG_RTR_FLAG) {
>   		id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		for (i = 0; i < cf->len; i++)
>   			cf->data[i] = readl(priv->base + dreg + i * 4);
>   
> +		stats->rx_bytes += cf->len;
> +	}
> +	stats->rx_packets++;
> +
>   	cf->can_id = id;
>   
>   	sun4i_can_write_cmdreg(priv, SUN4I_CMD_RELEASE_RBUF);
>   
> -	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
>   	netif_rx(skb);
>   
>   	can_led_event(dev, CAN_LED_EVENT_RX);
> diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
> index 7cf65936d02e..c9b6adf5c1ec 100644
> --- a/drivers/net/can/usb/ems_usb.c
> +++ b/drivers/net/can/usb/ems_usb.c
> @@ -320,10 +320,11 @@ static void ems_usb_rx_can_msg(struct ems_usb *dev, struct ems_cpc_msg *msg)
>   	} else {
>   		for (i = 0; i < cf->len; i++)
>   			cf->data[i] = msg->msg.can_msg.msg[i];
> -	}
>   
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +
>   	netif_rx(skb);
>   }
>   
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
> index 5f6915a27b3d..9ac7ee44b6e3 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -332,10 +332,11 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
>   		} else {
>   			for (i = 0; i < cf->len; i++)
>   				cf->data[i] = msg->msg.rx.data[i];
> -		}
>   
> +			stats->rx_bytes += cf->len;
> +		}
>   		stats->rx_packets++;
> -		stats->rx_bytes += cf->len;
> +
>   		netif_rx(skb);
>   	}
>   
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> index 32fe352dabeb..17fabd3d0613 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
> @@ -1208,13 +1208,15 @@ static void kvaser_usb_hydra_rx_msg_std(const struct kvaser_usb *dev,
>   
>   	cf->len = can_cc_dlc2len(cmd->rx_can.dlc);
>   
> -	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
> +	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME) {
>   		cf->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(cf->data, cmd->rx_can.data, cf->len);
>   
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +
>   	netif_rx(skb);
>   }
>   
> @@ -1286,13 +1288,15 @@ static void kvaser_usb_hydra_rx_msg_ext(const struct kvaser_usb *dev,
>   		cf->len = can_cc_dlc2len(dlc);
>   	}
>   
> -	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME)
> +	if (flags & KVASER_USB_HYDRA_CF_FLAG_REMOTE_FRAME) {
>   		cf->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(cf->data, cmd->rx_can.kcan_payload, cf->len);
>   
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +
>   	netif_rx(skb);
>   }
>   
> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
> index 4aebaab9ea9c..14b445643554 100644
> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
> @@ -1001,7 +1001,8 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
>   	}
>   
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
> +	if (!(cf->can_id & CAN_RTR_FLAG))
> +		stats->rx_bytes += cf->len;
>   	netif_rx(skb);
>   }
>   
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
> index 162d2e11cadd..4d20ea860ea8 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -452,13 +452,14 @@ static void mcba_usb_process_can(struct mcba_priv *priv,
>   
>   	cf->len = can_cc_dlc2len(msg->dlc & MCBA_DLC_MASK);
>   
> -	if (msg->dlc & MCBA_DLC_RTR_MASK)
> +	if (msg->dlc & MCBA_DLC_RTR_MASK) {
>   		cf->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(cf->data, msg->data, cf->len);
>   
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
> -	stats->rx_bytes += cf->len;
>   
>   	can_led_event(priv->netdev, CAN_LED_EVENT_RX);
>   	netif_rx(skb);
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/usb/peak_usb/pcan_usb.c
> index 21b06a738595..d539319232fa 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
> @@ -676,15 +676,16 @@ static int pcan_usb_decode_data(struct pcan_usb_msg_context *mc, u8 status_len)
>   		/* Ignore next byte (client private id) if SRR bit is set */
>   		if (can_id_flags & PCAN_USB_TX_SRR)
>   			mc->ptr++;
> +
> +		/* update statistics */
> +		mc->netdev->stats.rx_bytes += cf->len;
>   	}
> +	mc->netdev->stats.rx_packets++;
>   
>   	/* convert timestamp into kernel time */
>   	hwts = skb_hwtstamps(skb);
>   	peak_usb_get_ts_time(&mc->pdev->time_ref, mc->ts16, &hwts->hwtstamp);
>   
> -	/* update statistics */
> -	mc->netdev->stats.rx_packets++;
> -	mc->netdev->stats.rx_bytes += cf->len;
>   	/* push the skb */
>   	netif_rx(skb);
>   
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> index 185f5a98d217..65487ec33566 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> @@ -507,13 +507,13 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_usb_fd_if *usb_if,
>   	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
>   		cfd->can_id |= CAN_EFF_FLAG;
>   
> -	if (rx_msg_flags & PUCAN_MSG_RTR)
> +	if (rx_msg_flags & PUCAN_MSG_RTR) {
>   		cfd->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(cfd->data, rm->d, cfd->len);
> -
> +		netdev->stats.rx_bytes += cfd->len;
> +	}
>   	netdev->stats.rx_packets++;
> -	netdev->stats.rx_bytes += cfd->len;
>   
>   	peak_usb_netif_rx_64(skb, le32_to_cpu(rm->ts_low),
>   			     le32_to_cpu(rm->ts_high));
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
> index f6d19879bf40..ebe087f258e3 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.c
> @@ -536,17 +536,19 @@ static int pcan_usb_pro_handle_canmsg(struct pcan_usb_pro_interface *usb_if,
>   	if (rx->flags & PCAN_USBPRO_EXT)
>   		can_frame->can_id |= CAN_EFF_FLAG;
>   
> -	if (rx->flags & PCAN_USBPRO_RTR)
> +	if (rx->flags & PCAN_USBPRO_RTR) {
>   		can_frame->can_id |= CAN_RTR_FLAG;
> -	else
> +	} else {
>   		memcpy(can_frame->data, rx->data, can_frame->len);
>   
> +		netdev->stats.rx_bytes += can_frame->len;
> +	}
> +	netdev->stats.rx_packets++;
> +
>   	hwts = skb_hwtstamps(skb);
>   	peak_usb_get_ts_time(&usb_if->time_ref, le32_to_cpu(rx->ts32),
>   			     &hwts->hwtstamp);
>   
> -	netdev->stats.rx_packets++;
> -	netdev->stats.rx_bytes += can_frame->len;
>   	netif_rx(skb);
>   
>   	return 0;
> diff --git a/drivers/net/can/usb/ucan.c b/drivers/net/can/usb/ucan.c
> index d582c39fc8d0..388899019955 100644
> --- a/drivers/net/can/usb/ucan.c
> +++ b/drivers/net/can/usb/ucan.c
> @@ -623,7 +623,8 @@ static void ucan_rx_can_msg(struct ucan_priv *up, struct ucan_message_in *m)
>   	/* don't count error frames as real packets */
>   	if (!(cf->can_id & CAN_ERR_FLAG)) {
>   		stats->rx_packets++;
> -		stats->rx_bytes += cf->len;
> +		if (!(cf->can_id & CAN_RTR_FLAG))
> +			stats->rx_bytes += cf->len;
>   	}
>   
>   	/* pass it to Linux */
> diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
> index 040324362b26..23cdc92fb007 100644
> --- a/drivers/net/can/usb/usb_8dev.c
> +++ b/drivers/net/can/usb/usb_8dev.c
> @@ -474,13 +474,14 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_priv *priv,
>   		if (msg->flags & USB_8DEV_EXTID)
>   			cf->can_id |= CAN_EFF_FLAG;
>   
> -		if (msg->flags & USB_8DEV_RTR)
> +		if (msg->flags & USB_8DEV_RTR) {
>   			cf->can_id |= CAN_RTR_FLAG;
> -		else
> +		} else {
>   			memcpy(cf->data, msg->data, cf->len);
> -
> +			stats->rx_bytes += cf->len;
> +		}
>   		stats->rx_packets++;
> -		stats->rx_bytes += cf->len;
> +
>   		netif_rx(skb);
>   
>   		can_led_event(priv->netdev, CAN_LED_EVENT_RX);
> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
> index 275e240ab293..ffca1cd3b384 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -787,10 +787,11 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
>   			*(__be32 *)(cf->data) = cpu_to_be32(data[0]);
>   		if (cf->len > 4)
>   			*(__be32 *)(cf->data + 4) = cpu_to_be32(data[1]);
> -	}
>   
> -	stats->rx_bytes += cf->len;
> +		stats->rx_bytes += cf->len;
> +	}
>   	stats->rx_packets++;
> +
>   	netif_receive_skb(skb);
>   
>   	return 1;
> @@ -871,8 +872,11 @@ static int xcanfd_rx(struct net_device *ndev, int frame_base)
>   			*(__be32 *)(cf->data + i) = cpu_to_be32(data[0]);
>   		}
>   	}
> -	stats->rx_bytes += cf->len;
> +
> +	if (!(cf->can_id & CAN_RTR_FLAG))
> +		stats->rx_bytes += cf->len;
>   	stats->rx_packets++;
> +
>   	netif_receive_skb(skb);
>   
>   	return 1;
> 
