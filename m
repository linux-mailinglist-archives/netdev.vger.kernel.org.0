Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930596DFC16
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjDLRAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjDLRAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:00:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7F38A60
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:00:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m20-20020a170902c45400b001a641823abdso4946846plm.18
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681318805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kpKB7SqPD1WEJcm5mP/ZS9AV7kRHrr2cruyzGPdJnmY=;
        b=0dJ9X7z1jh25oYOHdd+ljdJXvOW0dD6zhgL9qARYaY8+1ZTVplJLk+y5Aqe0axj3f7
         rVda5IIvH/u9Mqx1YM4d0qjJrdRXlxwNLJlT3miGS7NcBeAWuFzmKipOZKiFXsHiIL6T
         CaKVTz/SjKtNGnp7avxMqpahnjuoTUT2P5T8gW/+RyXl9cT27GQpQ51fkvGdzeQQl5cD
         +fQ5My91JFTUE3tWCvY92nPuUsiGOO+mEOjRSnKlR/K+ZOhQwo6p0Yt8Zeb3AIof9tx9
         0Pt0VWQRjjZjTU1US/MsJ9d5y5H4C3VMfArkbKJhdzLnma7r7K7IN7gX3VGgvRhe2V/N
         q8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpKB7SqPD1WEJcm5mP/ZS9AV7kRHrr2cruyzGPdJnmY=;
        b=PfY6dIUlPCcqqY2NgeWIjf2ZlH6T+BAo2+XRSa0BPGAnpxLRzUHAqjO7J6PmiFq/8w
         /nhQFZ7CAQXhM9Duc0r/MB2WZhCt/2JSNE3bjA/5+1ZIIeTMDWzFdLIYMYGxnPb+Imya
         YuZoRREiipxoNi5aNG2KwUliIOau0Sasq5uPOg78OZQ6znE6/fXRQMKZwL+WBtPXSDSf
         2WmWdf/sYBMHQC1+3sbAv0GR+pC9qumduXRYaf6YMHES5ZRyI4Zhl9vOMdplzzIBUS5j
         gVY90VO1pWlTPZFL1oXzq3PMdfdlYqDHmxAa6ogTfvglklkPah6YtMyC8wu+f9bUXpP0
         V/bg==
X-Gm-Message-State: AAQBX9cE+RpOOycaYIGkpodTJp8f/Lpt2YUdq1rEo1cWH6syyu61RkME
        hMsGl2j9VzWROA0oWfi6r45/Fzw=
X-Google-Smtp-Source: AKy350bqCRuf2+nw6G4Xo/+RMWx8JZZGxbP78hg7vN5q2J6hphsLxNUKDMeaTSlnL3vx8TUht7eSaik=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a65:60c2:0:b0:51a:52b1:1b70 with SMTP id
 r2-20020a6560c2000000b0051a52b11b70mr775383pgv.10.1681318805239; Wed, 12 Apr
 2023 10:00:05 -0700 (PDT)
Date:   Wed, 12 Apr 2023 10:00:03 -0700
In-Reply-To: <20230412094235.589089-4-yoong.siang.song@intel.com>
Mime-Version: 1.0
References: <20230412094235.589089-1-yoong.siang.song@intel.com> <20230412094235.589089-4-yoong.siang.song@intel.com>
Message-ID: <ZDbjkwGS5L9wdS5h@google.com>
Subject: Re: [PATCH net-next v3 3/4] net: stmmac: add Rx HWTS metadata to XDP
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
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12, Song Yoong Siang wrote:
> Add receive hardware timestamp metadata support via kfunc to XDP receive
> packets.
> 
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 +++
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 ++++++++++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index ac8ccf851708..826ac0ec88c6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
>  
>  struct stmmac_xdp_buff {
>  	struct xdp_buff xdp;
> +	struct stmmac_priv *priv;
> +	struct dma_desc *p;
> +	struct dma_desc *np;
>  };
>  
>  struct stmmac_rx_queue {
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index f7bbdf04d20c..ed660927b628 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5315,10 +5315,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  
>  			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>  			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
> -					 buf->page_offset, buf1_len, false);
> +					 buf->page_offset, buf1_len, true);
>  
>  			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
>  				  buf->page_offset;
> +
> +			ctx.priv = priv;
> +			ctx.p = p;
> +			ctx.np = np;
> +
>  			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
>  			/* Due xdp_adjust_tail: DMA sync for_device
>  			 * cover max len CPU touch
> @@ -7071,6 +7076,23 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>  	}
>  }
>  
> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
> +{
> +	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
> +
> +	*timestamp = 0;
> +	stmmac_get_rx_hwtstamp(ctx->priv, ctx->p, ctx->np, timestamp);
> +

[..]

> +	if (*timestamp)

Nit: does it make sense to change stmmac_get_rx_hwtstamp to return bool
to indicate success/failure? Then you can do:

if (!stmmac_get_rx_hwtstamp())
	reutrn -ENODATA;
