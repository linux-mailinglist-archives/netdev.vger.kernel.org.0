Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01314C8548
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbiCAHe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiCAHe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:34:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEC27DE09;
        Mon, 28 Feb 2022 23:33:46 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u1so18930796wrg.11;
        Mon, 28 Feb 2022 23:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y9Y2mj3S2zRil16X7prWFdXExNWoZA9j+0fmL9SEGfk=;
        b=piokGCAo03HjCBwtitKDBXrEXbrLk/rrVMQIFRnZt3WzgBF1dmLNklb67ET7JolGIp
         CAPeqhoD4eBdNKAu1aM5uz9v3tmM3x/xlc9RcYc+1/Q6HRFQ5kk5EPprI4XeiTswxrpQ
         OIKyDsldGdaXVSwD7hl88EBdFRnW8jXKQlxroCCF019HEewzDCZJT1sPKCUv1YXcefop
         trMYci8gKc+MFZrYzJGVMC/sTCHAwqGNO5t9VatHiz1S0SGa9om7Y9PeQoM0eGrUzDJb
         bVeCJfnB5xbA3tRVpPat1eHjEN69vnMkCg/wExlpolE+tCevUdA3ti9J8u+vxcmabCwB
         0H2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y9Y2mj3S2zRil16X7prWFdXExNWoZA9j+0fmL9SEGfk=;
        b=HtT+EtdDKJDVdz6PFG7rp85A+O/IkS2KPCyALnEeir549ua5wDKPUv1FQ1cAJQs1Zi
         xsq8DG/QHMSZ2P1ydioEzZFJKokkX0TFuShr4PiH3TQfeqSkGLOpev95fsbf9r3rDBzF
         NyuzTYEjp+cg91aofbkMfeFmaVoQ8fsj6IVL3kuk7flwe2ke+nLR/s+pxEEe1WpOTyok
         Le4U+QPA1dtP+pFWwWMT7wHxNipedDwz/yBCr0XOiJo2PbSG2gT67bkqjmiUcbBpBToc
         1S8rbdPv2F7N9b5722j5ftrdLD4CqAkJNyzIayQOEJ3GNlJtgwsmJAt6ax9cGrbMFIN9
         3nlQ==
X-Gm-Message-State: AOAM532DRka6vghRO+tiPnp2sLD+Hx/Cx4+IA6jqjUbVm4PNUK4+Sytn
        Kezv9ljg8sl8XDT9w3/bJ6BF8/A2J5o=
X-Google-Smtp-Source: ABdhPJxgj/kSS+3DxSfB2yPKsaS3KRax2OV/mkOk84u8T7Kqgh3qMzoP9E/1Kctww6Og0SFZfNXwGg==
X-Received: by 2002:adf:9799:0:b0:1ea:8dcc:25e9 with SMTP id s25-20020adf9799000000b001ea8dcc25e9mr19011924wrb.248.1646120024846;
        Mon, 28 Feb 2022 23:33:44 -0800 (PST)
Received: from ?IPV6:2a01:c23:b88b:a500:3457:e529:abc5:d0e6? (dynamic-2a01-0c23-b88b-a500-3457-e529-abc5-d0e6.c23.pool.telefonica.de. [2a01:c23:b88b:a500:3457:e529:abc5:d0e6])
        by smtp.googlemail.com with ESMTPSA id o15-20020a05600c4fcf00b00381614e5b60sm1726414wmq.34.2022.02.28.23.33.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 23:33:44 -0800 (PST)
Message-ID: <ff76734b-fb2f-cc9d-cd05-5256efb6cde0@gmail.com>
Date:   Tue, 1 Mar 2022 08:33:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] net: marvell: Use min() instead of doing it manually
Content-Language: en-US
To:     Haowen Bai <baihaowen88@gmail.com>,
        sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1646115417-24639-1-git-send-email-baihaowen88@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1646115417-24639-1-git-send-email-baihaowen88@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.03.2022 07:16, Haowen Bai wrote:
> Fix following coccicheck warning:
> drivers/net/ethernet/marvell/mv643xx_eth.c:1664:35-36: WARNING opportunity for min()
> 
> Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
> index 143ca8b..1018b9e 100644
> --- a/drivers/net/ethernet/marvell/mv643xx_eth.c
> +++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
> @@ -1661,7 +1661,7 @@ mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
>  	if (er->rx_mini_pending || er->rx_jumbo_pending)
>  		return -EINVAL;
>  
> -	mp->rx_ring_size = er->rx_pending < 4096 ? er->rx_pending : 4096;
> +	mp->rx_ring_size = min(er->rx_pending, 4096);

Did you test this? Supposedly it won't compile cleanly due to the
min macro type checking (rx_pending is __u32, 4096 is int).

>  	mp->tx_ring_size = clamp_t(unsigned int, er->tx_pending,
>  				   MV643XX_MAX_SKB_DESCS * 2, 4096);
>  	if (mp->tx_ring_size != er->tx_pending)

