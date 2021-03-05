Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DBC32E060
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 05:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCEEHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 23:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 23:07:18 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C85C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 20:07:16 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id d9so527555ote.12
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 20:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g2X3AuyS9pE7ney+yblpjXrUEFgN6B0LhuiKB+8C6j0=;
        b=l/+cAui14+nB7D+m/sfh68LTZXT+BoYCuLhsKYjhD9JfvmIHQ4b011TqbRm2jmscQc
         +80zUf7mAUDIp4jLhWh6/Tg/IzM+bv3LGMJaZXXd89ExVF+Gf9NqcGK+3RZi9+O1znDx
         xry+M51zEbftdbh9+SVLEimRUkNDyVKN9lZBUYxdAgjv5NXTdCpz75nDCo2ZWonwx7h7
         TGFWYnvlgSzVQIIfBd1fefoROaKgfE20+bcPRwx4Lhd01nFY7QJt+CIFUd7DSi6j+7xB
         dWTlwYDUN+gQm8+5wUREFB55o8VFKjXnY+QDEaUp3zZtqsnPx6gvV8GwoPhbHB+a09VI
         Oh5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g2X3AuyS9pE7ney+yblpjXrUEFgN6B0LhuiKB+8C6j0=;
        b=CSHGbffx8Tb6uKesk3RtdMFphBVBmdHZEonzVgO1KIVNrWn0kUnl+TakxwMihelvWK
         H1KJtU5IZkustFXy/8IAuZ8EhIu2HxjTDET+S63ExBdUUGpf9PM3eoO79VYKidK2XyER
         /vcrbBSVT8i2Rar6wdmsGu/vjWRcJ4hvlwvQ4tqKDKzh5jzhZtWxlnxHHjDQVpt9wjCg
         WyTceoY26dZbS0sBM/VZw2U7k2MGSybxHdKiD19CN19dqHUNPu2E2kDGNet1UA9cKKww
         qEXrCVwBj5M+8uUYWXHLMick9oGGY2TgvQ4ZXL0VsoEjTqxVf+UXvN9BKMet6SO7tEUR
         6HFw==
X-Gm-Message-State: AOAM533cdeRGgNiNBJnQqLGVyUil8+m+qZ5ott2EGQ/UYPaLULTHV5GP
        cJ+nq978QqKqZI2THHEAQT22PA==
X-Google-Smtp-Source: ABdhPJzwBPs6wvWsm27RwtgAjbWHeKN4hGUqDR46f7Eiu0YSpf+/VPwLOfH75cJImSiyaO3EBcuJ4g==
X-Received: by 2002:a05:6830:2119:: with SMTP id i25mr6086111otc.249.1614917235811;
        Thu, 04 Mar 2021 20:07:15 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id s21sm339104oos.5.2021.03.04.20.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:07:15 -0800 (PST)
Date:   Thu, 4 Mar 2021 22:07:13 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/6] net: qualcomm: rmnet: simplify some byte
 order logic
Message-ID: <YEGucXIUQ59UcLrJ@builder.lan>
References: <20210304223431.15045-1-elder@linaro.org>
 <20210304223431.15045-3-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304223431.15045-3-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 04 Mar 16:34 CST 2021, Alex Elder wrote:

> In rmnet_map_ipv4_ul_csum_header() and rmnet_map_ipv6_ul_csum_header()
> the offset within a packet at which checksumming should commence is
> calculated.  This calculation involves byte swapping and a forced type
> conversion that makes it hard to understand.
> 
> Simplify this by computing the offset in host byte order, then
> converting the result when assigning it into the header field.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 22 ++++++++++---------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> index 21d38167f9618..bd1aa11c9ce59 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
> @@ -197,12 +197,13 @@ rmnet_map_ipv4_ul_csum_header(void *iphdr,
>  			      struct rmnet_map_ul_csum_header *ul_header,
>  			      struct sk_buff *skb)
>  {
> -	struct iphdr *ip4h = (struct iphdr *)iphdr;
> -	__be16 *hdr = (__be16 *)ul_header, offset;
> +	__be16 *hdr = (__be16 *)ul_header;
> +	struct iphdr *ip4h = iphdr;
> +	u16 offset;
> +
> +	offset = skb_transport_header(skb) - (unsigned char *)iphdr;
> +	ul_header->csum_start_offset = htons(offset);
>  
> -	offset = htons((__force u16)(skb_transport_header(skb) -

Just curious, why does this require a __force, or even a cast?


Regardless, your proposed way of writing it is easier to read.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> -				     (unsigned char *)iphdr));
> -	ul_header->csum_start_offset = offset;
>  	ul_header->csum_insert_offset = skb->csum_offset;
>  	ul_header->csum_enabled = 1;
>  	if (ip4h->protocol == IPPROTO_UDP)
> @@ -239,12 +240,13 @@ rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
>  			      struct rmnet_map_ul_csum_header *ul_header,
>  			      struct sk_buff *skb)
>  {
> -	struct ipv6hdr *ip6h = (struct ipv6hdr *)ip6hdr;
> -	__be16 *hdr = (__be16 *)ul_header, offset;
> +	__be16 *hdr = (__be16 *)ul_header;
> +	struct ipv6hdr *ip6h = ip6hdr;
> +	u16 offset;
> +
> +	offset = skb_transport_header(skb) - (unsigned char *)ip6hdr;
> +	ul_header->csum_start_offset = htons(offset);
>  
> -	offset = htons((__force u16)(skb_transport_header(skb) -
> -				     (unsigned char *)ip6hdr));
> -	ul_header->csum_start_offset = offset;
>  	ul_header->csum_insert_offset = skb->csum_offset;
>  	ul_header->csum_enabled = 1;
>  
> -- 
> 2.20.1
> 
