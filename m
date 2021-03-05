Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99A1B32E0DB
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 05:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhCEEuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 23:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEEuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 23:50:19 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91683C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 20:50:17 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id g46so128315ooi.9
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 20:50:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8gZFK/MCp86c/CU+l2Xboz2B3cDeGXKmmq4OMXpPMX4=;
        b=aNesNPrJw30x7G8sypE0hKFWHIkHlLS34sUhJcZdjp7EtKif+a/1aEfu+e7tpfeT5A
         Dw6oc3GGX1Y9mI4eaLQ1GHw1C8GPuNjyQVrP86F8h2h5MqhMCc0HAazNXwCbF/CZ5C3V
         akJta6IpUtcAcPoa9wsVTIhemWH+wkchSUqDvAx5Snu4fSRiMuJyMvdQv0klI0vniQO/
         9QIMK7Iyo/NjAWjyTuyjmjxpHyb0Gi5slSZM/0i/ob0bLsNgIIAaYIw6hzEkD1f5Tyan
         AfD1FIiSBzAhBid8O3WqwLdBsOece1qKkp0332H2kN4t8WiYb9V8QIaOfaUxBzNlQpml
         yaYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8gZFK/MCp86c/CU+l2Xboz2B3cDeGXKmmq4OMXpPMX4=;
        b=t3kx+FJ7ocB9eBrNkOVn0hyIGf7mQplNnDtOEHA0PEnzoe1LeSRf9S5WBqvgPlgEOi
         MTk/7wFdNp18hUJTzNConpHKD+J3SXq7fiAqcNckkJ1uStnFGUvHwm4Bc2NFJz8JfURw
         bVltdaLmte9i6bEcaIqdMZBwfbT+tv7NtQpsGqqx0B1Ihomp0F1xhnp7//qIEHAjq/zr
         AKwbwOCY+t3KF6qWYyOh5cMe9l04CaljGkbZtdVhWvSjpng12I5DY7qiVjJ3tcJjrqdT
         DiQZqe0K0l6XVoav3JCPJqrrlOpOvwg9bRFHdm6d9oPyp6vpgtR7CYu9/fWYMGe6KaOr
         m/lg==
X-Gm-Message-State: AOAM533FC4AlpauvuHuZKUPg+9SwaCupD8kGyQMkjC/fCrl1YPVD2317
        D3v0fRJP5R3rjXUbQCkvcXXULA==
X-Google-Smtp-Source: ABdhPJweD47jtZ7C4DfSsWHrfiELUVAB9WAWGh9pXeq+N2t+MfhasJD52Aw5jA8du4zecbkXexzilQ==
X-Received: by 2002:a4a:d1da:: with SMTP id a26mr6301882oos.58.1614919816883;
        Thu, 04 Mar 2021 20:50:16 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id w22sm382145otm.73.2021.03.04.20.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:50:16 -0800 (PST)
Date:   Thu, 4 Mar 2021 22:50:14 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: qualcomm: rmnet: use field masks
 instead of C bit-fields
Message-ID: <YEG4hmm4azZkbPUw@builder.lan>
References: <20210304223431.15045-1-elder@linaro.org>
 <20210304223431.15045-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304223431.15045-5-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 04 Mar 16:34 CST 2021, Alex Elder wrote:

> The actual layout of bits defined in C bit-fields (e.g. int foo : 3)
> is implementation-defined.  Structures defined in <linux/if_rmnet.h>
> address this by specifying all bit-fields twice, to cover two
> possible layouts.
> 
> I think this pattern is repetitive and noisy, and I find the whole
> notion of compiler "bitfield endianness" to be non-intuitive.
> 
> Stop using C bit-fields for the command/data flag and the pad length
> fields in the rmnet_map structure.  Instead, define a single-byte
> flags field, and use the functions defined in <linux/bitfield.h>,
> along with field mask constants to extract or assign values within
> that field.
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  5 ++--
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  4 +++-
>  include/linux/if_rmnet.h                      | 23 ++++++++-----------
>  3 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 2a6b2a609884c..30f8e2f02696b 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -4,6 +4,7 @@
>   * RMNET Data ingress/egress handler
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/netdevice.h>
>  #include <linux/netdev_features.h>
>  #include <linux/if_arp.h>
> @@ -61,7 +62,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
>  	u16 len, pad;
>  	u8 mux_id;
>  
> -	if (map_header->cd_bit) {
> +	if (u8_get_bits(map_header->flags, MAP_CMD_FMASK)) {
>  		/* Packet contains a MAP command (not data) */
>  		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
>  			return rmnet_map_command(skb, port);
> @@ -70,7 +71,7 @@ __rmnet_map_ingress_handler(struct sk_buff *skb,
>  	}
>  
>  	mux_id = map_header->mux_id;
> -	pad = map_header->pad_len;
> +	pad = u8_get_bits(map_header->flags, MAP_PAD_LEN_FMASK);
>  	len = ntohs(map_header->pkt_len) - pad;
>  
>  	if (mux_id >= RMNET_MAX_LOGICAL_EP)
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index fd55269c2ce3c..3291f252d81b0 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -4,6 +4,7 @@
>   * RMNET Data MAP protocol
>   */
>  
> +#include <linux/bitfield.h>
>  #include <linux/netdevice.h>
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
> @@ -299,7 +300,8 @@ struct rmnet_map_header *rmnet_map_add_map_header(struct sk_buff *skb,
>  
>  done:
>  	map_header->pkt_len = htons(map_datalen + padding);
> -	map_header->pad_len = padding & 0x3F;
> +	/* This is a data packet, so the CMD bit is 0 */
> +	map_header->flags = u8_encode_bits(padding, MAP_PAD_LEN_FMASK);
>  
>  	return map_header;
>  }
> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
> index 8c7845baf3837..4824c6328a82c 100644
> --- a/include/linux/if_rmnet.h
> +++ b/include/linux/if_rmnet.h
> @@ -6,21 +6,18 @@
>  #define _LINUX_IF_RMNET_H_
>  
>  struct rmnet_map_header {
> -#if defined(__LITTLE_ENDIAN_BITFIELD)
> -	u8  pad_len:6;
> -	u8  reserved_bit:1;
> -	u8  cd_bit:1;
> -#elif defined (__BIG_ENDIAN_BITFIELD)
> -	u8  cd_bit:1;
> -	u8  reserved_bit:1;
> -	u8  pad_len:6;
> -#else
> -#error	"Please fix <asm/byteorder.h>"
> -#endif
> -	u8  mux_id;
> -	__be16 pkt_len;
> +	u8 flags;			/* MAP_*_FMASK */
> +	u8 mux_id;
> +	__be16 pkt_len;			/* Length of packet, including pad */
>  }  __aligned(1);
>  
> +/* rmnet_map_header flags field:
> + *  CMD:	1 = packet contains a MAP command; 0 = packet contains data
> + *  PAD_LEN:	number of pad bytes following packet data
> + */
> +#define MAP_CMD_FMASK			GENMASK(7, 7)
> +#define MAP_PAD_LEN_FMASK		GENMASK(5, 0)
> +
>  struct rmnet_map_dl_csum_trailer {
>  	u8  reserved1;
>  #if defined(__LITTLE_ENDIAN_BITFIELD)
> -- 
> 2.20.1
> 
