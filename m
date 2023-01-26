Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D039A67C643
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 09:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjAZIxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 03:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234330AbjAZIxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 03:53:08 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870966A339
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:52:29 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id n7so1010464wrx.5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 00:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=09S0zXnEWE7OwkaLkcnmfZZGQsVszbcmZ2vyt1Z1g+I=;
        b=NMtlXSeoDy64o1PJpq6bJy3U+JYUQze64A0S8IL0NHPaJBmD8LcifEPxje/WqWvl7d
         IxxBbepqF4n7bq5/3rRDizuJNbuG+75T0nT4OYXnHozoks6CoX6hxmnO5ur2PXocNOSC
         B7HcXoJwZXzYAGaVzAwaTSVDYISS4t9+uxuHsVyQvrQqMzUPOZyxLLDat77qEmwzSUfZ
         zOlEKIJT/aOIOcFMUBlTFYjxDpZCAErgXvV2NmzWdzyRlIKBll6wneFoqM3nUNIEyJP4
         RmPrs5pJm6qtESYXzhztvclHDaUIDSYSU8BNvpUNlwD7W7Z6xhHhe/14b1FnZSnzU0ZX
         /+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09S0zXnEWE7OwkaLkcnmfZZGQsVszbcmZ2vyt1Z1g+I=;
        b=jqWLtvhg7H8dqGh8bodN17eBd6vXEAYUCHdSlkUqJ1KuLJogaI+24E9UWqD4h29Kam
         FsAoERakW5LCRrbNBwo8ijU8W3awrN407NOLg2YTnFd2nrjd7l10z9NBkYV0/BcgimOJ
         0IRU56Y3eAVvmpiGdffzoSiU65OB7qdVUfyvDvzCudC76l1DYUm882cq1Gf1+Eo8U3je
         lWJ0UfyAQcL/wzcRnW1Nu9QEjifxVeN89veZBGE+mPFGfMrZ+irUBzzY8eXx+7mF/SmF
         BiY+9Wi4hOF2zOcfp6q5OJcSm/i2DzLPcblPY2BxvXhCphox+vDEhQGQAljMQsOD/S+X
         kRWA==
X-Gm-Message-State: AFqh2krAqB9ULP+RIV0XmyqYyTu0DznXLo/ZJ6Az1Mxp6BV86yt105VZ
        0B1Lw99pSZkHVlsh3VDnqYM=
X-Google-Smtp-Source: AMrXdXsyqzxYA1d1BpamHHbYVelW4UOIrg4v6foD4AQfAamOBd5EnCcfsDNYTgGQJU5NI2p5ewVXsw==
X-Received: by 2002:a05:6000:1c04:b0:232:be5d:5ee9 with SMTP id ba4-20020a0560001c0400b00232be5d5ee9mr34201035wrb.64.1674723146433;
        Thu, 26 Jan 2023 00:52:26 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id d3-20020adfe2c3000000b002bc7fcf08ddsm634222wrj.103.2023.01.26.00.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 00:52:25 -0800 (PST)
Date:   Thu, 26 Jan 2023 08:52:22 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
Subject: Re: [PATCH net] sfc: correctly advertise tunneled IPv6 segmentation
Message-ID: <Y9I/RmuOPJeHJ8X1@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>
References: <20230125143513.25841-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230125143513.25841-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 03:35:13PM +0100, Íñigo Huguet wrote:
> Recent sfc NICs are TSO capable for some tunnel protocols. However, it
> was not working properly because the feature was not advertised in
> hw_enc_features, but in hw_features only.
> 
> Setting up a GENEVE tunnel and using iperf3 to send IPv4 and IPv6 traffic
> to the tunnel show, with tcpdump, that the IPv4 packets still had ~64k
> size but the IPv6 ones had only ~1500 bytes (they had been segmented by
> software, not offloaded). With this patch segmentation is offloaded as
> expected and the traffic is correctly received at the other end.
> 
> Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
> Reported-by: Tianhao Zhao <tizhao@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/efx.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index 0556542d7a6b..3a86f1213a05 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -1003,8 +1003,11 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
>  	/* Determine netdevice features */
>  	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
>  			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
> -	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
> +	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
>  		net_dev->features |= NETIF_F_TSO6;
> +		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
> +			net_dev->hw_enc_features |= NETIF_F_TSO6;
> +	}
>  	/* Check whether device supports TSO */
>  	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
>  		net_dev->features &= ~NETIF_F_ALL_TSO;
> -- 
> 2.34.3
