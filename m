Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A03D5FFD30
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 05:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJPDuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 23:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJPDuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 23:50:04 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0791BE96
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 20:50:01 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-131dda37dddso10266877fac.0
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 20:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4F+J/oMBG24emXIXIH2VrAbjHgA5ZrEsZTJ/Yxpa24=;
        b=N4OxlLm9q/XDqG3knQkj3nE5ffY7HoQZ4eIQl2Zv3fWalYlulH8bc8obh46Eb0oje9
         baFTwFOMlXCmzVtt+U9UvdXBEYJII/rlH+akYEFplAjq3tTBiT9siZuPR9n4vLvzyhiB
         ksMnEsc3vlmRZ8loD8jsIqziAN7+c82fMgjKF4U/+n9NXVVbrtxfPhCFI+qEGtRPMvd3
         t/wo55IribPutDPtiugSB+0OFKUcE1ciz4PNsthCjiA2C9iM7stLvtPmlfK/whXYDa18
         JTwDNunyd8+iRQwWnsca7GUilZYbYLfNcAyvFdOOq10w9LY7iK17aSN8HMiFii1Se9cY
         x7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O4F+J/oMBG24emXIXIH2VrAbjHgA5ZrEsZTJ/Yxpa24=;
        b=M1Ui7OzzGJ2N4fQOy2B/SfYoZepLdBmaxb9wv2u10bSg74xx9EjKr43suaZQ2aDz0J
         QMnB1CYzlV9yCmqCy6D4ekWivBrSd1oEi4ovxyEhhRTrD/xfT3gD6dsjAH84Y/XUCQYz
         z8aXgtxcFfObWLJfAhNzC3A1e+Ly/R0Fu/0Zbh3rzzTowcUBuUaq4F+flY6xmplr+HU8
         Rtve3eAjcqibYYa/rTFdLY+w+Ln/LIC5/BSxjx+DT3SlmYE4aABBOx1vbhP8ZK5Cao3e
         U8ssXNFE7SME4PrxjFQv7VllW4B2NbFPneba+12TfS6TPE2QsqPz+6z3C1fQrl657h6V
         SFig==
X-Gm-Message-State: ACrzQf0cz6xZEgwV9S6fUPucIhtbnx7nAKDt6NfxGHq/ugiaThhwOHYM
        XtX8Jybk4xMoTP6GKX+bvMs=
X-Google-Smtp-Source: AMsMyM6B/n93Yp2m5/nNj+jiVLYlfTaSmD+SN/qZtLBFsG/IiwvQM5tcu6Y0FBeFYD9WMWkFwWKZWw==
X-Received: by 2002:a05:6871:88a:b0:132:40e6:280 with SMTP id r10-20020a056871088a00b0013240e60280mr12169009oaq.202.1665892200645;
        Sat, 15 Oct 2022 20:50:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l3-20020a9d7a83000000b00661a2c5fef9sm3257541otn.32.2022.10.15.20.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 20:50:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 15 Oct 2022 20:49:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, guoren@kernel.org, yury.norov@gmail.com
Subject: Re: [PATCH net] Revert "net: fix cpu_max_bits_warn() usage in
 netif_attrmask_next{,_and}"
Message-ID: <20221016034959.GA2327678@roeck-us.net>
References: <20221014160746.553813-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014160746.553813-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 09:07:46AM -0700, Jakub Kicinski wrote:
> This reverts commit 854701ba4c39afae2362ba19a580c461cb183e4f.
> 
> We have more violations around, which leads to:
> 
>   WARNING: CPU: 2 PID: 1 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x14e/0x770
> 
> Let's back this out and retry with a larger clean up in -next.
> 
> Fixes: 854701ba4c39 ("net: fix cpu_max_bits_warn() usage in netif_attrmask_next{,_and}")
> Link: https://lore.kernel.org/all/20221014030459.3272206-2-guoren@kernel.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Tested-by: Guenter Roeck <linux@roeck-us.net>

> ---
>  include/linux/netdevice.h | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index a36edb0ec199..eddf8ee270e7 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3663,8 +3663,9 @@ static inline bool netif_attr_test_online(unsigned long j,
>  static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
>  					       unsigned int nr_bits)
>  {
> -	/* n is a prior cpu */
> -	cpu_max_bits_warn(n + 1, nr_bits);
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpu_max_bits_warn(n, nr_bits);
>  
>  	if (srcp)
>  		return find_next_bit(srcp, nr_bits, n + 1);
> @@ -3685,8 +3686,9 @@ static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
>  					  const unsigned long *src2p,
>  					  unsigned int nr_bits)
>  {
> -	/* n is a prior cpu */
> -	cpu_max_bits_warn(n + 1, nr_bits);
> +	/* -1 is a legal arg here. */
> +	if (n != -1)
> +		cpu_max_bits_warn(n, nr_bits);
>  
>  	if (src1p && src2p)
>  		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
> -- 
> 2.37.3
> 
