Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16D436364A
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhDRPJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 11:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235642AbhDRPJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 11:09:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA941C06174A;
        Sun, 18 Apr 2021 08:09:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b8-20020a17090a5508b029014d0fbe9b64so18918758pji.5;
        Sun, 18 Apr 2021 08:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HWOn6tI0bETN/19C3ddt2D/DYLiSrfaENiNxauN8Rn0=;
        b=X2ZBOzfiYayUMDkUYLz5PnpUIPbK+06rWtEA/tUxBKEDYnGP1tFFS9E5hXmgg1kQgi
         sqlVrYonFg/kSK/L3G5Y0zt1ikdDT/7zFs5Agd1MYxC59tmUEM8OBKFNhIYohiNrAcCF
         6coHHlbpY+fzx9Ai6Q4ioOephkcAP6fWy8Mln2G6KkdSY0AtbVwWsxvKmTB0+UfFiW+T
         HN6cVU4QktB9O9RDEecbDmmhxotsVfx7UzDj3gcDTAGX71SzQ522RBZPDardemO7Kkzi
         mCNYATatPsGh+NQ635jXP+ENgM/TbI9kDnF/hbuBNuEBjzd3w4G7PwM1RDpjMFDShecm
         eRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HWOn6tI0bETN/19C3ddt2D/DYLiSrfaENiNxauN8Rn0=;
        b=cYVA51G0tZfcr55pOG4AwKma4338oSzwAFOsEPZIHhBJ6Br62INAQw4DaeIzrcYrWw
         6+mPfAQBBKwsUm3R1NX0WSW4C66ugzU2DKLdsOFC5Dl6AYdfGmsI2S2bQIwUi1SwuyNd
         l4mJGUr4dOyWUHPEwNXmHWUDOb/US09wGyPR8a2P23KZKYH/MP9bovzTE0p8s2t7CseP
         mzbl4jYI+G6efooc66u541CmNJW4fSDgt+deuQrrmk4hryDq8CyQgoZKDcUyrLDGvD6t
         w/xVGAa5SahMO95Nc2YXxcUI0C84g1CAU4cHXNkOHgfIjF+4r/uqdJ2hPdFbYQdiMWOz
         6g9Q==
X-Gm-Message-State: AOAM530lAVzcVK5Bki8GaXD79L9sIkSeZlfqnbfLDfxBupg3+mSPssfj
        KHG3RaA4bTq0p+T2RqTzgXU=
X-Google-Smtp-Source: ABdhPJzDGfOGzDBrl7UE9YVdGpddPF8XtAXSEBuYDETIK/Vi4YSvLjNQJdj8Wy/DWFGgsqfF9FzETw==
X-Received: by 2002:a17:902:361:b029:e9:8392:7abd with SMTP id 88-20020a1709020361b02900e983927abdmr18902202pld.8.1618758540374;
        Sun, 18 Apr 2021 08:09:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id s56sm4189321pfw.184.2021.04.18.08.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 08:08:59 -0700 (PDT)
Date:   Sun, 18 Apr 2021 08:08:57 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/3] net: dsa: optimize tx timestamp request handling
Message-ID: <20210418150857.GB24506@hoboy.vegasvil.org>
References: <20210416123655.42783-1-yangbo.lu@nxp.com>
 <20210416123655.42783-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416123655.42783-2-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 08:36:53PM +0800, Yangbo Lu wrote:
> @@ -628,9 +620,7 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	DSA_SKB_CB(skb)->clone = NULL;
>  
> -	/* Identify PTP protocol packets, clone them, and pass them to the
> -	 * switch driver
> -	 */
> +	/* Handle tx timestamp request if has */

"if has" what?

>  	dsa_skb_tx_timestamp(p, skb);
>  
>  	if (dsa_realloc_skb(skb, dev)) {
> -- 
> 2.25.1
> 

Thanks,
Richard
