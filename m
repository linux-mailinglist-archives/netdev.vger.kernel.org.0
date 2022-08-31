Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398B45A7F4F
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiHaNyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbiHaNyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:54:10 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79459D5DD2
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:54:07 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id l65so4115020pfl.8
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=oy6rVv0u+mlmtZoLXHdu1thGaNO4e45kezqyXBHkd8c=;
        b=TZsGMnzU1E46IIn0FwEvQQ9keVNF+VsCOlSEbXirKwj+OJ5gGlWkT/XwczVjOHQ5DW
         pkqgrAkZwviSCs3GAEAZcTy2pvzPzdIJvbdtsA71t/puAleMkIoojDIQ3isOn4u0ERk+
         cxRA1n+/8bCMFXhtNeEeFOBdqWu0MRl3kHdZCTO3hV8K0oRvf3njIZY6eLhL0GSuFPnx
         EGmPD5KMbBTguQSJwL4h8VErw1k4Dj1CNyg8Jx/4QOMpK8NYer3SYcp7he4grY8Ow0jp
         6ZVWPlycmj0JEEXAl4iJu5jSozNt8Fd+Er4rpHVT/zDMdkmRkene1kM4Vvh0itMiX6Xq
         5y1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=oy6rVv0u+mlmtZoLXHdu1thGaNO4e45kezqyXBHkd8c=;
        b=ETqPJCHN9glLtnIuyWuLpm5CmOd774EzNvaiRLW1xpOGfGgeaaCUKeBYFvWzVo0XZm
         PFxqcJLCdr7oec9cGblPRw9gkGgei8OL0Rk+HJNJLmQDV0uJ+vb7FdukHB4DBXk5EOVh
         Sr+2mum8kCwAJBA0FcJHLZMpBt4KrXhv/DooCpaaNBUmmI++c0z11icHkEuB7hGzHk4C
         5hVdw72Z9GVMbPNbYIfSSAQ2v0RxZFH/YfwMg137BbvhQn0+Md0XH9UtDb9uaeF2vaYv
         RJe/zlIWSetNkOda7TVFB9pzpY1sVLmxB9nna478DQChEynTLtNoB67oopKDSoyUrPAt
         zm/w==
X-Gm-Message-State: ACgBeo1bU36xRZwAkeQX/EPrHcUSTObvLrjRSDAMTznO0k22tg9/V99i
        6TgUdbjZ/dbXHEl3y8OxVlQ=
X-Google-Smtp-Source: AA6agR7aeEI7DRc+F39jFmFBVn4fqYR2Hi+q7l5nC250f0VfWPvbghhw0UXqmrJADiZqYILTr3GwEA==
X-Received: by 2002:a63:284:0:b0:41d:9b60:497c with SMTP id 126-20020a630284000000b0041d9b60497cmr22057896pgc.29.1661954047000;
        Wed, 31 Aug 2022 06:54:07 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a2c0a00b001f24c08c3fesm1354947pjd.1.2022.08.31.06.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:54:06 -0700 (PDT)
Date:   Wed, 31 Aug 2022 06:54:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [PATCH] Use a spinlock to guard `fep->ptp_clk_on`
Message-ID: <Yw9n/JfdenzRkAyq@hoboy.vegasvil.org>
References: <20220831125631.173171-1-csokas.bence@prolan.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220831125631.173171-1-csokas.bence@prolan.hu>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 02:56:31PM +0200, Csókás Bence wrote:

> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
> index c74d04f4b2fd..dc8564a1f2d2 100644
> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> @@ -365,21 +365,21 @@ static int fec_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>   */
>  static int fec_ptp_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
>  {
> -	struct fec_enet_private *adapter =
> +	struct fec_enet_private *fep =
>  	    container_of(ptp, struct fec_enet_private, ptp_caps);
>  	u64 ns;
> -	unsigned long flags;
> +	unsigned long flags, flags2;
>  
> -	mutex_lock(&adapter->ptp_clk_mutex);
> +	spin_lock_irqsave(&fep->ptp_clk_lock, flags);
>  	/* Check the ptp clock */
> -	if (!adapter->ptp_clk_on) {
> -		mutex_unlock(&adapter->ptp_clk_mutex);
> +	if (!fep->ptp_clk_on) {

BTW This test is silly. If functionality isn't available then the code
should simply not register the clock in the first place.

> +		spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);
>  		return -EINVAL;
>  	}
> -	spin_lock_irqsave(&adapter->tmreg_lock, flags);
> -	ns = timecounter_read(&adapter->tc);
> -	spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
> -	mutex_unlock(&adapter->ptp_clk_mutex);
> +	spin_lock_irqsave(&fep->tmreg_lock, flags2);
> +	ns = timecounter_read(&fep->tc);
> +	spin_unlock_irqrestore(&fep->tmreg_lock, flags2);
> +	spin_unlock_irqrestore(&fep->ptp_clk_lock, flags);

Two spin locks?  Why not just use one?

Thanks,
Richard
