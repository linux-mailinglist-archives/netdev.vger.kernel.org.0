Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47D6DC93C
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 18:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjDJQZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 12:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjDJQZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 12:25:20 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9061720
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 09:25:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54bfc4e0330so139081787b3.3
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 09:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681143917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zJZt4cv250ETxOLYWhNXH5O28WLGu+lq/P9MQwXS1vc=;
        b=Q38PWrtfrWbIykKvRvvBdbu2xEQ65qR53Fa294q6h9fTzpEgUOChCN6gZzA6J/2Jrr
         oqqSni32vEWVPYCbg0h6jm4fUOjfjFak24TvaaKhhhzysF17g2T81sIMcNE/NB6iEZfy
         +JAuyYt2ZIkrpatZUEADvUNtPERwhA5h4EJXJKEds3rQ3lUQshZ+PSpMj9wQN087+Ou9
         FPqzzKvhqvM3NpQ0KRI+2RbokVotgwcuON+I3/gS46uHJ5RfnNczmlNKsnPDqRFen6K/
         toC13G+9g8xUr2c5Iins+M2UhJTrM19tEpB1/wsJwf04OBfN3YoQtNyJepOI8VsojJVK
         Mzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681143917;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zJZt4cv250ETxOLYWhNXH5O28WLGu+lq/P9MQwXS1vc=;
        b=QKrTTKiC4npfoApoMQXL6WSC9JSgzLdj3pCSawOQThBzaStfHDscFNY848ekoYrqnk
         8InP3bVC4cGwKHhM+1lJ8AmcQwG+yHc+V3zKgt3l70bWhuQOUZI4fcAE2kZgpC5GXBTC
         s8dC5c+6b6zNwW9Lsr+6D3DURSnbJSI7IhgSneC8j/+ks1TLvZXr73JWYFFFEfzjM5co
         sjzSz9o3PfbTsbXBtEIqGXMXalAfvR9I+s0TGDwn5pRnyanwP4D/dCXEwGuXRMu/IELB
         xyrY2T4f4mbhG12eP9AkX+Ni1e/B1e0xy6nKrO/WJy83bLz9pAYQd0s8MnVAp3Ux4+HC
         AU8Q==
X-Gm-Message-State: AAQBX9eoCqJEJsihASlR/2DrIAHdC9siRi+TskpCOVpw1469GJ9u/il8
        Eg8sZqBP1ssFbX0Sx1v3kJsursY=
X-Google-Smtp-Source: AKy350Yza28bnGsHoOQVOcw77cb7JSctAnu5UcsxyRZ6i3OPX41XxJItWn69Z01NRHFpS7EVaLNUCGM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a25:cb52:0:b0:a02:a3a6:78fa with SMTP id
 b79-20020a25cb52000000b00a02a3a678famr5422814ybg.12.1681143917218; Mon, 10
 Apr 2023 09:25:17 -0700 (PDT)
Date:   Mon, 10 Apr 2023 09:25:15 -0700
In-Reply-To: <20230410100939.331833-4-yoong.siang.song@intel.com>
Mime-Version: 1.0
References: <20230410100939.331833-1-yoong.siang.song@intel.com> <20230410100939.331833-4-yoong.siang.song@intel.com>
Message-ID: <ZDQ4a9UIVysA6hgd@google.com>
Subject: Re: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
From:   Stanislav Fomichev <sdf@google.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10, Song Yoong Siang wrote:
> Add receive hardware timestamp metadata support via kfunc to XDP receive
> packets.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++++++--
>  2 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index ac8ccf851708..760445275da8 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -94,6 +94,7 @@ struct stmmac_rx_buffer {
>  
>  struct stmmac_xdp_buff {
>  	struct xdp_buff xdp;
> +	ktime_t rx_hwts;
>  };
>  
>  struct stmmac_rx_queue {
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index f7bbdf04d20c..ca183fbfde85 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5307,6 +5307,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  			}
>  		}
>  

[..]

> +		stmmac_get_rx_hwtstamp(priv, p, np, &ctx.rx_hwts);

Do we want to pay this cost for every packet?

The preferred alternative is to store enough state in the
stmmac_xdp_buff so we can get to this data from stmmac_xdp_rx_timestamp.

I haven't read this code, but tentatively:
- move priv, p, np into stmmac_xdp_buff, assign them here instead of
  calling stmmac_get_rx_hwtstamp
- call stmmac_get_rx_hwtstamp from stmmac_xdp_rx_timestamp with the
  stored priv, p, np

That would ensure that we won't waste the cycles pulling out the rx
timestamp for every packet if the higher levels / users don't care.

Would something like this work?

> +
>  		if (!skb) {
>  			unsigned int pre_len, sync_len;
>  
> @@ -5315,7 +5317,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  
>  			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>  			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
> -					 buf->page_offset, buf1_len, false);
> +					 buf->page_offset, buf1_len, true);
>  
>  			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
>  				  buf->page_offset;
> @@ -5411,7 +5413,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  
>  		shhwtstamp = skb_hwtstamps(skb);
>  		memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
> -		stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);
> +		shhwtstamp->hwtstamp = ctx.rx_hwts;
>  
>  		stmmac_rx_vlan(priv->dev, skb);
>  		skb->protocol = eth_type_trans(skb, priv->dev);
> @@ -7071,6 +7073,22 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>  	}
>  }
>  
> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
> +{
> +	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
> +
> +	if (ctx->rx_hwts) {
> +		*timestamp = ctx->rx_hwts;
> +		return 0;
> +	}
> +
> +	return -ENODATA;
> +}
> +
> +const struct xdp_metadata_ops stmmac_xdp_metadata_ops = {
> +	.xmo_rx_timestamp		= stmmac_xdp_rx_timestamp,
> +};
> +
>  /**
>   * stmmac_dvr_probe
>   * @device: device pointer
> @@ -7178,6 +7196,8 @@ int stmmac_dvr_probe(struct device *device,
>  
>  	ndev->netdev_ops = &stmmac_netdev_ops;
>  
> +	ndev->xdp_metadata_ops = &stmmac_xdp_metadata_ops;
> +
>  	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
>  			    NETIF_F_RXCSUM;
>  	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
> -- 
> 2.34.1
> 
