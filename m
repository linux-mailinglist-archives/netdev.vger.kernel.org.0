Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17603522D06
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbiEKHTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiEKHTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:19:53 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A0D1B7740
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:19:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id x18so1680197wrc.0
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 00:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=QNdwt0NdxCv1Dly1YYM/Cz5H8DA0BxRoShFJqPNL0dE=;
        b=Fq1h6Jk5Ta08WpHv44UYq69Z6LIkWCjAAsOMLeEwXqQ9tKxN/W3stHKnErSuXa5aFX
         9nOmZjYvQcpsucH/C2Vxe5dh9zstTnaSeQ4DoBwjNnMFykudvmYBEW6/+mqz+bTYgxtU
         gLKSE5bmFCA1oaOfGoMKL4TPrsxcOp677EKwgigSMcMu5YTDXpkJuuSo+TPdomYtl+Oy
         IkhSgWtjSlQsItnCD0Nakb6IdNGUQN/7XapSY6jsxpa1PrSlnzfEwObBlZOPKsXE9ZPw
         swVQCKBLhx43ozZJLUXTJezptPPSIfYxKnjHWWsNn314X6xQMUo/pOIxh28vZeTMaHlc
         52Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=QNdwt0NdxCv1Dly1YYM/Cz5H8DA0BxRoShFJqPNL0dE=;
        b=pRyIslh6Awp7m3xLJ/XDilpfF1T4ijr5CIG5P6DD3xOfbtktzL+bMLERsyNSLv2oJ8
         kgV7ACQqjUlMUgMSMLxIMxz66hA2vK6ZDUqFoRsq83FJA/KhBzBlcs5k1LM1nuGgMxpi
         8d1E6GVOhU9+dXo0LaNwlOK+DuMOb3rQRikMKC2kKSu/CSECv25d7LnuuCR37o16d6/n
         Su0erpLWLcmfqmgiG+P3+JKxWUQVdPwIwMiawrWIwWyaFJRweSd3HwFM+O4qiVt2B1Oo
         3LRHlRoyLO8+JO2WcWpJM8iD8NVi6YhWmqG6ihsUdnvZ0T68psHEdLszIDxZJrhz7npD
         TB2A==
X-Gm-Message-State: AOAM532Wax55kj7IGUfehddeOHO4Q24c0D0qH3YLa4X9pdEZIHe2CcLQ
        veqoPSsC9m4BXasCMjcgtpg=
X-Google-Smtp-Source: ABdhPJxFO7/SGfSM8SqpswdYVB5TPK5CtYvs+LasZ806fnChPpz7TViOCcQa1JMZkYOkZHiywBYOMg==
X-Received: by 2002:a5d:5954:0:b0:20c:4d55:1388 with SMTP id e20-20020a5d5954000000b0020c4d551388mr21454933wri.90.1652253588771;
        Wed, 11 May 2022 00:19:48 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id d10-20020a5d6dca000000b0020cd0762f37sm869802wrz.107.2022.05.11.00.19.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 May 2022 00:19:48 -0700 (PDT)
Date:   Wed, 11 May 2022 08:19:45 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, ap420073@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dinang@xilinx.com, pabloc@xilinx.com
Subject: Re: [PATCH net-next 1/5] sfc: add new helper macros to iterate
 channels by type
Message-ID: <20220511071945.46o3hlfnhppkqoro@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, ap420073@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, dinang@xilinx.com, pabloc@xilinx.com
References: <20220510084443.14473-1-ihuguet@redhat.com>
 <20220510084443.14473-2-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510084443.14473-2-ihuguet@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Íñigo,

On Tue, May 10, 2022 at 10:44:39AM +0200, Íñigo Huguet wrote:
> Sometimes in the driver it's needed to iterate a subset of the channels
> depending on whether it is an rx, tx or xdp channel. Now it's done
> iterating over all channels and checking if it's of the desired type,
> leading to too much nested and a bit complex to understand code.
> 
> Add new iterator macros to allow iterating only over a single type of
> channel.

We have similar code we'll be upstreaming soon, once we've managed to
split off Siena. The crucial part of that seems to have been done
today.

> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/net_driver.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 318db906a154..7f665ba6a082 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1501,6 +1501,27 @@ efx_get_channel(struct efx_nic *efx, unsigned index)
>  	     _channel = (_channel->channel + 1 < (_efx)->n_channels) ?	\
>  		     (_efx)->channel[_channel->channel + 1] : NULL)
>  
> +#define efx_for_each_rx_channel(_channel, _efx)				    \
> +	for (_channel = (_efx)->channel[0];				    \
> +	     _channel;							    \
> +	     _channel = (_channel->channel + 1 < (_efx)->n_rx_channels) ?   \
> +		     (_efx)->channel[_channel->channel + 1] : NULL)
> +#define efx_for_each_tx_channel(_channel, _efx)				    \
> +	for (_channel = (_efx)->channel[efx->tx_channel_offset];	    \
> +	     _channel;							    \
> +	     _channel = (_channel->channel + 1 <			    \
> +		     (_efx)->tx_channel_offset + (_efx)->n_tx_channels) ?   \
> +		     (_efx)->channel[_channel->channel + 1] : NULL)

We've chosen a different naming conventions here, and we're also removing
the channel array.
Also not every channel has RX queues and not every channel has TX queues.

Sounds like it's time we have another call.
Martin

> +#define efx_for_each_xdp_channel(_channel, _efx)			    \
> +	for (_channel = ((_efx)->n_xdp_channels > 0) ?			    \
> +		     (_efx)->channel[efx->xdp_channel_offset] : NULL;	    \
> +	     _channel;							    \
> +	     _channel = (_channel->channel + 1 <			    \
> +		     (_efx)->xdp_channel_offset + (_efx)->n_xdp_channels) ? \
> +		     (_efx)->channel[_channel->channel + 1] : NULL)
> +
>  /* Iterate over all used channels in reverse */
>  #define efx_for_each_channel_rev(_channel, _efx)			\
>  	for (_channel = (_efx)->channel[(_efx)->n_channels - 1];	\
> -- 
> 2.34.1
