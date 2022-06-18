Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572B95501BD
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 03:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiFRBqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 21:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbiFRBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 21:46:47 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FAB6B03A;
        Fri, 17 Jun 2022 18:46:43 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id h8so6147189iof.11;
        Fri, 17 Jun 2022 18:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=GvzE0MY7dGfJMgbKlLx/bwUiID6nHhevmap4odLEw0w=;
        b=X6T6z1ZaHZdUxzj59PTAJiqiR1oAztfJq7dzjsVm67X9KHgHX/VClJGUxJ8xB7/uKX
         Efr5Me6MpULj/YyY2yWo7tHzNR3siyFX6RDA/H6cqNZ++Ct0h/h2gov6JD/wZSyyuUXt
         vFgPbEnyRLfob0+rS30X591kmljM+c5T/Z93O0PqMgIrUajEqmd4MSiNzlAzmRtWBLBM
         YP7fiqyYm5dUQrwXASXGdQVD0jmOFz88oIzJcvGBql4knEr3qW72JMNHw9IjY16TuVfa
         SxOgGaL5mKYXw3R4GbI8m6SrhxkKzo3JB8/NXqrHiD0wdhtJemF7Xw9kMM8ENU3F4EK7
         h6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=GvzE0MY7dGfJMgbKlLx/bwUiID6nHhevmap4odLEw0w=;
        b=eUUxAYyJgNWqpfRy6surxorHDTNzTDvZidRcxDJfFsbMMiQ7QN8tO9r6Vh5HeKeKOB
         q0Ij9aVre6Lu8g40UhqgZ7whDuVypd9a/vc7ZJU++eMsGIo52R5EaBAPgbd+y6d2Tq1v
         hDlWCuxSGxU3Tg1QtKBHoh+vC6bzxDsh/Euq7YJQe4c75PC3r0xxxisSO4NUQd12u9E4
         rzOlH7CKUbG/TXy+1i03D6dFxaFmuZyh/YpCSOczkKA+K9Ap9SG7UvKfJohL7pqZB21m
         alM6m8p3oMkbBnvFylXAr5c3jr7id5zZ4s3ch1QVnjLUvVSAft5eG9N98n26pLDZZxa/
         d4eQ==
X-Gm-Message-State: AJIora93QOV/8CFZ+ZV8GzSM4sucsZRQn05gkHM/v39XpRoF7VEzdXqN
        /eWa/XhP44pCcndE+anJYA0=
X-Google-Smtp-Source: AGRyM1tCoeDIg42MjHnB1CNnjXxeIR3zdmznQaYjTB5ELvKLdh+Jtxg3rCNe+vVPIJ3FA9X8K9ebvg==
X-Received: by 2002:a05:6602:2aca:b0:669:e6ec:9b6c with SMTP id m10-20020a0566022aca00b00669e6ec9b6cmr6363592iov.176.1655516802415;
        Fri, 17 Jun 2022 18:46:42 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id b11-20020a92dccb000000b002d3edd935e5sm3009932ilr.53.2022.06.17.18.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 18:46:41 -0700 (PDT)
Date:   Fri, 17 Jun 2022 18:46:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Message-ID: <62ad2e7b9ff11_24b342081a@john.notmuch>
In-Reply-To: <20220616180609.905015-2-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-2-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 01/10] ice: compress branches in
 ice_set_features()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> Instead of rather verbose comparison of current netdev->features bits vs
> the incoming ones from user, let us compress them by a helper features
> set that will be the result of netdev->features XOR features. This way,
> current, extensive branches:
> 
> 	if (features & NETIF_F_BIT && !(netdev->features & NETIF_F_BIT))
> 		set_feature(true);
> 	else if (!(features & NETIF_F_BIT) && netdev->features & NETIF_F_BIT)
> 		set_feature(false);
> 
> can become:
> 
> 	netdev_features_t changed = netdev->features ^ features;
> 
> 	if (changed & NETIF_F_BIT)
> 		set_feature(!!(features & NETIF_F_BIT));
> 
> This is nothing new as currently several other drivers use this
> approach, which I find much more convenient.

Looks good couple nits below. Up to you if you want to follow through
on them or not I don't have a strong opinion. For what its worth the
other intel drivers also do the 'netdev->features ^ features'
assignment.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 40 +++++++++++------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index e1cae253412c..23d1b1fc39fb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -5910,44 +5910,41 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
>  static int
>  ice_set_features(struct net_device *netdev, netdev_features_t features)
>  {
> +	netdev_features_t changed = netdev->features ^ features;
>  	struct ice_netdev_priv *np = netdev_priv(netdev);
>  	struct ice_vsi *vsi = np->vsi;
>  	struct ice_pf *pf = vsi->back;
>  	int ret = 0;
>  
>  	/* Don't set any netdev advanced features with device in Safe Mode */
> -	if (ice_is_safe_mode(vsi->back)) {
> -		dev_err(ice_pf_to_dev(vsi->back), "Device is in Safe Mode - not enabling advanced netdev features\n");
> +	if (ice_is_safe_mode(pf)) {
> +		dev_err(ice_pf_to_dev(vsi->back),

bit of nitpicking but if you use pf in the 'if' above why not use it here
as well and save a few keys. Also matches below then.

> +			"Device is in Safe Mode - not enabling advanced netdev features\n");
>  		return ret;
>  	}
>  
>  	/* Do not change setting during reset */
>  	if (ice_is_reset_in_progress(pf->state)) {
> -		dev_err(ice_pf_to_dev(vsi->back), "Device is resetting, changing advanced netdev features temporarily unavailable.\n");
> +		dev_err(ice_pf_to_dev(pf),
> +			"Device is resetting, changing advanced netdev features temporarily unavailable.\n");
>  		return -EBUSY;
>  	}
>  

[...]

> @@ -5956,11 +5953,12 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
>  		return -EACCES;
>  	}
>  
> -	if ((features & NETIF_F_HW_TC) &&
> -	    !(netdev->features & NETIF_F_HW_TC))
> -		set_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> -	else
> -		clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> +	if (changed & NETIF_F_HW_TC) {
> +		bool ena = !!(features & NETIF_F_HW_TC);
> +
> +		ena ? set_bit(ICE_FLAG_CLS_FLOWER, pf->flags) :
> +		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
> +	}

Just a note you changed the logic slightly here. Above you always
clear the bit. But, it looks like it doesn't matter caveat being
I don't know what might happen in hardware.

>  
>  	return 0;
>  }
> -- 
> 2.27.0
> 


