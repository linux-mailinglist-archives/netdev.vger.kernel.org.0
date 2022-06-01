Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A7D539E1A
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345457AbiFAHUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350321AbiFAHUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:20:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2004BB9B
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 00:20:34 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s24so1016677wrb.10
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 00:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=oVYPJ5V4XRF/YFuHIoNlS53E/wjRCM4CdhnX89E+rAA=;
        b=JrxsdXzTSqqie91kObH/oTICkaVTag44CXSrDuxy797fwdPt3LVE6cj4ZBFcQjxL2+
         ciFlaXsvlUQZ1Bk/ScfK6+st6t652NBtlyR0SNhGDu8uQnGSt0yeY21BBsIitt+NYOP9
         qh1SRMpKqnYd/A4jN34Te5pVtk36wkfAoq2UwVFZDJ8hXTmmMBJrPQAwSzdE3SPR1d1Z
         qcaqyv56Gm51p2U7wTetC3tudemLbPuPJicevzejbk9Tp3wXYHub0hZ04aWfguHvaie9
         s9osrUCo4eHKO8XhVO9kU4MrYWviEqThNo2t5n9NP+LxtFZueZynJl6S4KjJSyuNHJ4Q
         3pGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=oVYPJ5V4XRF/YFuHIoNlS53E/wjRCM4CdhnX89E+rAA=;
        b=kCAg4UGokBY45QAyMOcyf6KJw/+Ae5AP2a3gf6Nm6T5aE5dHz94C+I34hv0RUeySi6
         cHk7gUxy3FbfQr3GuTJTAh2sDAmOAogR7zwqdo4WG4KpAR+jaRTJm1qA9yKcmaNFYCWO
         ZjOSwzqVo8Xm2urPuI+/Jqi27k8dXk4qeugMQzG5ogttwOIiP6ybZMKizMnbU8A5QKTL
         yCH0pgmENnY7lsHOJS+4I+W+lEvXHVK9lnWmNlga3q2a8+1n5sJicWzgk/5i8h0pqkbE
         OB29zimRNwqJwhIP9PbpLPdDmAYyHJ3JC9JgqLzRCsQqqaa0S9fKHubV/EkJNDeEjgOb
         tTRw==
X-Gm-Message-State: AOAM5338Mee5Sa74sG/QgpBLEYw/ZWpiDwUBB9Kl30QvVzek2S9pu4Ki
        FqG5cbjd9eOhtQQLO4qEGew=
X-Google-Smtp-Source: ABdhPJwibNov7qe4q0s5QqCPM5fIz9Jx0Bekle3Ww9vh5dDjJUkHWVep6PpoX3hJDamLkYHfhLbKQg==
X-Received: by 2002:adf:e19a:0:b0:210:157c:7b3c with SMTP id az26-20020adfe19a000000b00210157c7b3cmr21691557wrb.121.1654068032794;
        Wed, 01 Jun 2022 00:20:32 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n30-20020a05600c501e00b003973d0a78casm993685wmr.38.2022.06.01.00.20.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 00:20:32 -0700 (PDT)
Date:   Wed, 1 Jun 2022 08:20:29 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, cmclachlan@solarflare.com,
        brouer@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
Subject: Re: [PATCH net v2 2/2] sfc/siena: fix wrong tx channel offset with
 efx_separate_tx_channels
Message-ID: <YpcTPexECg3LLrJb@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, cmclachlan@solarflare.com,
        brouer@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
References: <20220531134034.389792-1-ihuguet@redhat.com>
 <20220601063603.15362-1-ihuguet@redhat.com>
 <20220601063603.15362-3-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220601063603.15362-3-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 08:36:03AM +0200, Íñigo Huguet wrote:
> tx_channel_offset is calculated in efx_allocate_msix_channels, but it is
> also calculated again in efx_set_channels because it was originally done
> there, and when efx_allocate_msix_channels was introduced it was
> forgotten to be removed from efx_set_channels.
> 
> Moreover, the old calculation is wrong when using
> efx_separate_tx_channels because now we can have XDP channels after the
> TX channels, so n_channels - n_tx_channels doesn't point to the first TX
> channel.
> 
> Remove the old calculation from efx_set_channels, and add the
> initialization of this variable if MSI or legacy interrupts are used,
> next to the initialization of the rest of the related variables, where
> it was missing.
> 
> This has been already done for sfc, do it also for sfc_siena.
> 
> Fixes: 3990a8fffbda ("sfc: allocate channels for XDP tx queues")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/siena/efx_channels.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.c b/drivers/net/ethernet/sfc/siena/efx_channels.c
> index 2465cf4d505c..017212a40df3 100644
> --- a/drivers/net/ethernet/sfc/siena/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/siena/efx_channels.c
> @@ -299,6 +299,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
>  		efx->n_channels = 1;
>  		efx->n_rx_channels = 1;
>  		efx->n_tx_channels = 1;
> +		efx->tx_channel_offset = 0;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
>  		rc = pci_enable_msi(efx->pci_dev);
> @@ -319,6 +320,7 @@ int efx_siena_probe_interrupts(struct efx_nic *efx)
>  		efx->n_channels = 1 + (efx_siena_separate_tx_channels ? 1 : 0);
>  		efx->n_rx_channels = 1;
>  		efx->n_tx_channels = 1;
> +		efx->tx_channel_offset = 1;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
>  		efx->legacy_irq = efx->pci_dev->irq;
> @@ -958,10 +960,6 @@ int efx_siena_set_channels(struct efx_nic *efx)
>  	struct efx_channel *channel;
>  	int rc;
>  
> -	efx->tx_channel_offset =
> -		efx_siena_separate_tx_channels ?
> -		efx->n_channels - efx->n_tx_channels : 0;
> -
>  	if (efx->xdp_tx_queue_count) {
>  		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
>  
> -- 
> 2.34.1
