Return-Path: <netdev+bounces-11019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEFF7311A0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C19F32815C5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6CAA4431;
	Thu, 15 Jun 2023 08:01:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B993D53AF
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:01:08 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8430A2D57
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:01:01 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-98281bed6d8so182645266b.3
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686816060; x=1689408060;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9PsL+L5qJwj+XZaoYAVqQMnDKUDwlg0vql93Zuciv9I=;
        b=HqNUNh9oHxmJZuySHbeVg22V9iWZgGnOuGp/4rCCOXzuRllYC9/NvtTemDxZp08yF9
         BNU0ieQHI2nbuSZX/+nTHHlBV0BiC1Lslt3YEUzjM9Vh6NUDjAurNiSorl5/SlmlNg8K
         2MlI0/5GqLr9rreINjFalp2UJa8zuObIwMO5lCBW9+VE3nLehqJJsg1yIB2DEpOpei9H
         YuHMO8cxeitceovJgRIGi0Kvs2SrLtXVKefFEi8n4B42WWTCclD4Cq7GCPx4gfXvHUQJ
         mnobaS2QNFhE1IXTvTTosDdcy9bXJAGla2HxcltS+09QlhqkqrRINv7XvNIvqbVx+gNd
         LP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686816060; x=1689408060;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9PsL+L5qJwj+XZaoYAVqQMnDKUDwlg0vql93Zuciv9I=;
        b=dmcFUrq7KpjSIZqQW+WoHet4aq++7Jo4PQC3M8LNp9BUsowdf3M9CvfuBik8SAyUOn
         e74r8mvDAWNl0WIgLyzUL+avp8Ur1AeFNAdpYDaDmjxRmYAhbL4aAV/w+tuyF1ZBjVbt
         nAwYl4DTxaXvvGAha5xx+nKXYEQTi8GL1setWLnQ43uvLFb2Txzbx62qIl+hLhEddm3V
         nU1ezi4MqwGCCalEahUKq4UlcYPMF2cLgY4Wy1NtcJBeVT0Y7gAeKfIn0vAhh3IbSZy6
         Emb6n8prz5r7uVgjv1peEwHCpX8dhv5s6QUc/isFtx9cYjx7FJfpG//njTZ4k3A/1zbr
         q+Cw==
X-Gm-Message-State: AC+VfDx2FGoIr6GxVnQYpi8Vglf1r6eVeH7VRI91oSNURGEAzTkFgFOp
	YQb0K+mykJUTmuv0fY0NjMw=
X-Google-Smtp-Source: ACHHUZ6mg+nXLbwOeNLI4PHXGyat/PgdoNj2/P0JgglK01CYlsjcnt7Aw1zCe9/EiLmDfGOMgOBsnA==
X-Received: by 2002:a17:907:3da0:b0:982:2278:bcef with SMTP id he32-20020a1709073da000b009822278bcefmr10581997ejc.60.1686816059684;
        Thu, 15 Jun 2023 01:00:59 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id l6-20020a1709065a8600b0097866bc5119sm8953130ejq.200.2023.06.15.01.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 01:00:59 -0700 (PDT)
Date: Thu, 15 Jun 2023 09:00:56 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc: ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, Yanghang Liu <yanghliu@redhat.com>
Subject: Re: [PATCH net] sfc: fix XDP queues mode with legacy IRQ
Message-ID: <ZIrFONMcNWZQKjiv@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
	ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, Yanghang Liu <yanghliu@redhat.com>
References: <20230613133854.37832-1-ihuguet@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230613133854.37832-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 03:38:54PM +0200, Íñigo Huguet wrote:
> In systems without MSI-X capabilities, xdp_txq_queues_mode is calculated
> in efx_allocate_msix_channels, but when enabling MSI-X fails, it was not
> changed to a proper default value. This was leading to the driver
> thinking that it has dedicated XDP queues, when it didn't.
> 
> Fix it by setting xdp_txq_queues_mode to the correct value if the driver
> fallbacks to MSI or legacy IRQ mode. The correct value is
> EFX_XDP_TX_QUEUES_BORROWED because there are not XDP dedicated queues.

Small typo: not should be no.

> 
> The issue can be easily visible if the kernel is started with pci=nomsi,
> then a call trace is shown. It is not shown only with sfc's modparam
> interrupt_mode=2. Call trace example:
>  WARNING: CPU: 2 PID: 663 at drivers/net/ethernet/sfc/efx_channels.c:828 efx_set_xdp_channels+0x124/0x260 [sfc]
>  [...skip...]
>  Call Trace:
>   <TASK>
>   efx_set_channels+0x5c/0xc0 [sfc]
>   efx_probe_nic+0x9b/0x15a [sfc]
>   efx_probe_all+0x10/0x1a2 [sfc]
>   efx_pci_probe_main+0x12/0x156 [sfc]
>   efx_pci_probe_post_io+0x18/0x103 [sfc]
>   efx_pci_probe.cold+0x154/0x257 [sfc]
>   local_pci_probe+0x42/0x80
> 
> Fixes: 6215b608a8c4 ("sfc: last resort fallback for lack of xdp tx queues")
> Reported-by: Yanghang Liu <yanghliu@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx_channels.c       | 2 ++
>  drivers/net/ethernet/sfc/siena/efx_channels.c | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index fcea3ea809d7..41b33a75333c 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -301,6 +301,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
>  		efx->tx_channel_offset = 0;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
> +		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
>  		rc = pci_enable_msi(efx->pci_dev);
>  		if (rc == 0) {
>  			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
> @@ -322,6 +323,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
>  		efx->tx_channel_offset = efx_separate_tx_channels ? 1 : 0;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
> +		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
>  		efx->legacy_irq = efx->pci_dev->irq;
>  	}
>  
> diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
> index 06ed74994e36..1776f7f8a7a9 100644
> --- a/drivers/net/ethernet/sfc/siena/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
> @@ -302,6 +302,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
>  		efx->tx_channel_offset = 0;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
> +		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
>  		rc = pci_enable_msi(efx->pci_dev);
>  		if (rc == 0) {
>  			efx_get_channel(efx, 0)->irq = efx->pci_dev->irq;
> @@ -323,6 +324,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
>  		efx->tx_channel_offset = efx_siena_separate_tx_channels ? 1 : 0;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
> +		efx->xdp_txq_queues_mode = EFX_XDP_TX_QUEUES_BORROWED;
>  		efx->legacy_irq = efx->pci_dev->irq;
>  	}
>  
> -- 
> 2.40.1

