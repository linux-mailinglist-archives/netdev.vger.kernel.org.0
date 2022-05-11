Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BD8522DCF
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 10:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbiEKIDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 04:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241805AbiEKIDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 04:03:03 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29E08B085
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:03:01 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h16so1086297wrb.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 01:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+wPy9NPHk/Mf1gdMAmzmwC+sHb1QCR/lOjxgbei49/A=;
        b=D2IGg74L6dmswcPFahDlKvyia8kQbEnAeicoczDa5oObXdov9toyBrd4lX/S7wsGRm
         CcCT8d+KsjUUOhIcT8pkF83Ql1h2o08JXjcdsb8wD+Wq4Sqe7AKk+7d8hP3cW9be5hKl
         D1qQJnTwg/CJZu2hpHTThRfWkatKeoMc9d7ew5DAUnkpnBTQ+UFXfbGVTgvx0z3gaTTB
         sGH+FjGCjJb7phqCjotn+jb+hB3xO12PgoKiwud2WAp04X0k02CBIfQwt3u+HjGE708v
         93pBoFstkeVh7xfX0zN2VrBQnX4+v+3MnIGJCQjoLRMiJ11qVx10C6+PSIw/XO4lYnRJ
         Mpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=+wPy9NPHk/Mf1gdMAmzmwC+sHb1QCR/lOjxgbei49/A=;
        b=yMiK0u/af836SckBwb3Msp+u2POAwkaFYfXmxi/onBPZz8nlU/CnIjOxwrORWxetUa
         AssRVcRJcbLSdZbPneS1xXoSjwNQFPwc+NqplEtE5XZiQIZ/Qk5aoW4IkclQyA9urUei
         QX10IGIoVKxvmWMmNAboVzZ8E+VdzYe8Ant1ZIYHkGZXUuPs4UqWZGtaWtEzcYeN3Ul2
         /3of0dBblhliTHTwQUt6xG3BVHPPsEigW81aUs6euu/XVPoCc0sEYiSpoWhCdGndMS7y
         xrGn5cppHN0xghWkMFaF0rniQm7IBliq5cIjSNc21YsYzbXeNupJYtuWjTVXLQ7CAjcN
         zu6w==
X-Gm-Message-State: AOAM5306JAr7lPLdVMibfxG0IWm18szMSfdHyq3joiKAgjCS2UTxJ0sZ
        TcvT5Ns/XGKUK1uhU2KvKTE=
X-Google-Smtp-Source: ABdhPJxessb45V5hc05DY5VcOZtiv4VKDhpRURkgQUQLhuXdDh1PR86wuyTkjczzK2UPwfuScDo+NA==
X-Received: by 2002:a5d:47c8:0:b0:20c:95c6:23df with SMTP id o8-20020a5d47c8000000b0020c95c623dfmr22278080wrc.315.1652256180218;
        Wed, 11 May 2022 01:03:00 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id q2-20020a5d61c2000000b0020c5253d8e0sm992873wrv.44.2022.05.11.01.02.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 May 2022 01:02:59 -0700 (PDT)
Date:   Wed, 11 May 2022 09:02:57 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, ap420073@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] sfc: move tx_channel_offset calculation to
 interrupts probe
Message-ID: <20220511080257.zorpazlwyefv3fjy@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, ap420073@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20220510084443.14473-1-ihuguet@redhat.com>
 <20220510084443.14473-6-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220510084443.14473-6-ihuguet@redhat.com>
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

On Tue, May 10, 2022 at 10:44:43AM +0200, Íñigo Huguet wrote:
> All parameters related to what channels are used for RX, TX and/or XDP
> are calculated in efx_probe_interrupts or its called function
> efx_allocate_msix_channels.
> 
> tx_channel_offset was recalculated needlessly in efx_set_queues. Remove
> this from here since it's more coherent to calculate it only once, in
> the same place than the rest of channels parameters. If MSIX is not used,
> this value was not set in efx_probe_interrupts, so let's do it now.
> 
> The value calculated in efx_set_queues was wrong anyway, because with
> the addition of the support for XDP, additional channels had been added
> after the TX channels, and efx->n_channels - efx->n_tx_channels didn't
> point to the beginning of the TX channels any more.

Apart from the reformatting this fixes a bug in the existing code.
Please submit this bug fix part again as an individual patch.

Martin

> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> ---
>  drivers/net/ethernet/sfc/efx_channels.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index f6634faa1ec4..b9bbef07bb5e 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -220,14 +220,9 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
>  	n_channels -= efx->n_xdp_channels;
>  
>  	if (efx_separate_tx_channels) {
> -		efx->n_tx_channels =
> -			min(max(n_channels / 2, 1U),
> -			    efx->max_tx_channels);
> -		efx->tx_channel_offset =
> -			n_channels - efx->n_tx_channels;
> -		efx->n_rx_channels =
> -			max(n_channels -
> -			    efx->n_tx_channels, 1U);
> +		efx->n_tx_channels = min(max(n_channels / 2, 1U), efx->max_tx_channels);
> +		efx->tx_channel_offset = n_channels - efx->n_tx_channels;
> +		efx->n_rx_channels = max(n_channels - efx->n_tx_channels, 1U);
>  	} else {
>  		efx->n_tx_channels = min(n_channels, efx->max_tx_channels);
>  		efx->tx_channel_offset = 0;
> @@ -303,6 +298,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
>  		efx->n_channels = 1;
>  		efx->n_rx_channels = 1;
>  		efx->n_tx_channels = 1;
> +		efx->tx_channel_offset = 0;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
>  		rc = pci_enable_msi(efx->pci_dev);
> @@ -323,6 +319,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
>  		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
>  		efx->n_rx_channels = 1;
>  		efx->n_tx_channels = 1;
> +		efx->tx_channel_offset = 1;
>  		efx->n_xdp_channels = 0;
>  		efx->xdp_channel_offset = efx->n_channels;
>  		efx->legacy_irq = efx->pci_dev->irq;
> @@ -952,10 +949,6 @@ int efx_set_queues(struct efx_nic *efx)
>  	unsigned int queue_num = 0;
>  	int rc;
>  
> -	efx->tx_channel_offset =
> -		efx_separate_tx_channels ?
> -		efx->n_channels - efx->n_tx_channels : 0;
> -
>  	/* We need to mark which channels really have RX and TX queues, and
>  	 * adjust the TX queue numbers if we have separate RX/TX only channels.
>  	 */
> -- 
> 2.34.1
