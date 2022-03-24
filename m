Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301644E6469
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 14:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350602AbiCXNvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 09:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350584AbiCXNvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 09:51:09 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1741B782
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:49:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id q19so3889109pgm.6
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 06:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ikm/0ZjRJewNvQ6cWOgMbpAqJSotvsfurofTtKMVK4A=;
        b=QHaNmZa8r3exqnPtdcsJd7MtwOIffBxpxhm2DC4Wrztpoatu46cqaELPCwm4SUZjoP
         eGaTvPZ94tT4p/cNL0HuDPgthCpAfzapwa42RKovG3nlenXCnL3YpSZNW6SBZB0U0pjm
         OA4SKPU3nfOc2kk8oqYI1mc7mdpL8lYq04+wipMddkPWoi2R4zlvsVHzo/r/AlBpJoZw
         Uxirm6FHsTjvDFr9/oh+ChK9vOxmnZDdNiVQvmmR9hHKCY/hAvyoR1I7r8p0V0ovQIgu
         hSZ5ilNtLjbY1mNzOdQcpOYqJDsEtbh5RC6nn5TUekMFc8yJ/GurJiqKpkaOUAp+9KJf
         MfAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ikm/0ZjRJewNvQ6cWOgMbpAqJSotvsfurofTtKMVK4A=;
        b=Z4R6Hu1zUygtSt4BWCf7vtr1gI4NLJTmEkNHjDLytrjbVTCq38el/pgwHVyiCJ6St9
         GpLTUwcD/eLMVto2tWNwCiez9l3zyQixgf/4M8x1e1xI8kXKSM4dcVPhtKjpO5plY2zY
         95r5qD2fGmhPPLlWZpe4Cad1+K2mZfCHUpkLXbzKLPyHr1niiBm61XHW1xIMUrBBmT7j
         CUFYUmlhZLAzpeSQViLZNw2Tili3CMwUf/djuL96ImCa6rmMVNeM+swaxCg6CVL8w+gR
         pseAtDaOl7quy9aXxNovcFBROdHzt8PrCKvsDSRADz2vQcBJnOdEq9SWh70pHXQ5VuqB
         VkdA==
X-Gm-Message-State: AOAM530vib9Gk/kxiKMETs3d+zpUZ4QlXfvvpQI5QMiTLVKoLfSDA7GF
        qBC1u2UoaVesAm4mGNRIwh0=
X-Google-Smtp-Source: ABdhPJz2sfQAR38yyq7HMwWgt0LTvOkXeF9spelcdsBSPH9KarJ6FKnyaRTsm8W/p4UdVMMjidJDuA==
X-Received: by 2002:a63:17:0:b0:37f:f283:24b with SMTP id 23-20020a630017000000b0037ff283024bmr4146482pga.407.1648129777476;
        Thu, 24 Mar 2022 06:49:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s21-20020a63dc15000000b00378c9e5b37fsm2714090pgg.63.2022.03.24.06.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 06:49:37 -0700 (PDT)
Date:   Thu, 24 Mar 2022 06:49:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org,
        mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 2/6] ptp: Request cycles for TX timestamp
Message-ID: <20220324134934.GB27824@hoboy.vegasvil.org>
References: <20220322210722.6405-1-gerhard@engleder-embedded.com>
 <20220322210722.6405-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322210722.6405-3-gerhard@engleder-embedded.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 10:07:18PM +0100, Gerhard Engleder wrote:
> The free running time of physical clocks called cycles shall be used for
> hardware timestamps to enable synchronisation.
> 
> Introduce new flag SKBTX_HW_TSTAMP_USE_CYCLES, which signals driver to
> provide a TX timestamp based on cycles if cycles are supported.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  include/linux/skbuff.h |  3 +++
>  net/core/skbuff.c      |  2 ++
>  net/socket.c           | 10 +++++++++-
>  3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 26538ceb4b01..f494ddbfc826 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -578,6 +578,9 @@ enum {
>  	/* device driver is going to provide hardware time stamp */
>  	SKBTX_IN_PROGRESS = 1 << 2,
>  
> +	/* generate hardware time stamp based on cycles if supported */
> +	SKBTX_HW_TSTAMP_USE_CYCLES = 1 << 3,

Bit 4 used, but 3 was unused... interesting!

>  	/* generate wifi status information (where possible) */
>  	SKBTX_WIFI_STATUS = 1 << 4,
>  
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 10bde7c6db44..c0f8f1341c3f 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4847,6 +4847,8 @@ void __skb_tstamp_tx(struct sk_buff *orig_skb,
>  		skb_shinfo(skb)->tx_flags |= skb_shinfo(orig_skb)->tx_flags &
>  					     SKBTX_ANY_TSTAMP;
>  		skb_shinfo(skb)->tskey = skb_shinfo(orig_skb)->tskey;
> +	} else {
> +		skb_shinfo(skb)->tx_flags &= ~SKBTX_HW_TSTAMP_USE_CYCLES;
>  	}
>  
>  	if (hwtstamps)
> diff --git a/net/socket.c b/net/socket.c
> index 982eecad464c..1acebcb19e8f 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -683,9 +683,17 @@ void __sock_tx_timestamp(__u16 tsflags, __u8 *tx_flags)
>  {
>  	u8 flags = *tx_flags;
>  
> -	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE)
> +	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE) {
>  		flags |= SKBTX_HW_TSTAMP;
>  
> +		/* PTP hardware clocks can provide a free running time called
> +		 * cycles as base for virtual clocks.

"PTP hardware clocks can provide a free running cycle counter as a
time base for virtual clocks."


Thanks,
Richard


