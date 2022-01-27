Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7194849E270
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbiA0Mgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbiA0Mge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 07:36:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E3BC061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:36:34 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b13so3520767edn.0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7k9fDV9OkEyB6jl7dl2S84GHJ6DV0tH1HREFjQMT3Z0=;
        b=IXpiU9/aoSnpgTOSxcQCQcJW2RH4ct6tPavKiNp1Up5IoPt5T8Q+IcZB8PDLglISW8
         E85dz70lDIW3LOo79X5vnwyTJUNPbW7b1K8ctHSWgTK25lui+WfluGOjDNbYyfLgHBAn
         x97kdsVjVPlt+fOMDvbH3JBK0dnaH0JAPixQ6GWYCrwbKvdufgQRthV429Jr7gwch/nD
         Wr2ksLy+mii4gCqAOgcqFytgTfymbskPUApt4hpb4EsnEY6UT8TXk1G7nlT9jGU12oae
         neuw74jOCK118S2w2w5sVm/TDrJomuFpBlqMpXprtXV1vBtc7xjTImB9dHrTQX7neO/P
         wTpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7k9fDV9OkEyB6jl7dl2S84GHJ6DV0tH1HREFjQMT3Z0=;
        b=bscNarLthsNSDPCz+mF46c7Lk3BnJE6nMtg/rIdZp8IWCBonvmT9ClFB60mW32xL0E
         yabknshcRe7Vq+6dpqiByhV98hnfdWz2Rq054AAmixLQCfxdQqhuXxWEtyKuz7iB0wqf
         Ahd/+iK8HhwYExoPjXX6CzqVyo2tZy0Chi6FCIoYQYYyErWnB619v6Z6UYUl0yznb8oN
         WWfeWAhxVLG8KvJWml2KTVy6InNfCUSeKurM1zgGnvYoQn4+2Mcdurxm9gL2BlFPH1lh
         GMjXWqZUhH1plK21LhbLI3zJkvnd12XQvczbETg/LxswaRuZ0nIO9P+yplP3B9cPo8Ul
         zd2Q==
X-Gm-Message-State: AOAM532O2nhtjaumkpriB8C6FmvuiYpDuwZQ8Q2pyDPRFj/72DTfniHJ
        vFh3iSkBLuY1Ne8/1/67XWdVzSdDLCU=
X-Google-Smtp-Source: ABdhPJxzI1syXafWv3WFJ0NGJH9+PP2aZ3Y87P8of3b4kDl3s7jadCLkE7YMnduLgNFybVXxb0YEOg==
X-Received: by 2002:a05:6402:1c95:: with SMTP id cy21mr3463699edb.172.1643286992758;
        Thu, 27 Jan 2022 04:36:32 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id y5sm11422275edw.45.2022.01.27.04.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 04:36:31 -0800 (PST)
Date:   Thu, 27 Jan 2022 14:36:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 01/15] mii: remove
 mii_lpa_to_linkmode_lpa_sgmii()
Message-ID: <20220127123630.dcekgawusvmga6ay@skbuf>
References: <20220126191109.2822706-1-kuba@kernel.org>
 <20220126191109.2822706-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126191109.2822706-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:10:55AM -0800, Jakub Kicinski wrote:
> The only caller of mii_lpa_to_linkmode_lpa_sgmii()
> disappeared in v5.10.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: Vladimir Oltean <olteanv@gmail.com>
> CC: Andrew Lunn <andrew@lunn.ch>
> CC: Heiner Kallweit <hkallweit1@gmail.com>
> CC: Russell King <linux@armlinux.org.uk>
> ---
>  include/linux/mii.h | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/include/linux/mii.h b/include/linux/mii.h
> index 12ea29e04293..b8a1a17a87dd 100644
> --- a/include/linux/mii.h
> +++ b/include/linux/mii.h
> @@ -387,23 +387,6 @@ mii_lpa_mod_linkmode_lpa_sgmii(unsigned long *lp_advertising, u32 lpa)
>  			 speed_duplex == LPA_SGMII_10FULL);
>  }
>  
> -/**
> - * mii_lpa_to_linkmode_adv_sgmii
> - * @advertising: pointer to destination link mode.
> - * @lpa: value of the MII_LPA register
> - *
> - * A small helper function that translates MII_ADVERTISE bits
> - * to linkmode advertisement settings when in SGMII mode.
> - * Clears the old value of advertising.
> - */
> -static inline void mii_lpa_to_linkmode_lpa_sgmii(unsigned long *lp_advertising,
> -						 u32 lpa)
> -{
> -	linkmode_zero(lp_advertising);
> -
> -	mii_lpa_mod_linkmode_lpa_sgmii(lp_advertising, lpa);
> -}
> -

This is also the only caller of mii_lpa_mod_linkmode_lpa_sgmii(), so
that function can be deleted too.

>  /**
>   * mii_adv_mod_linkmode_adv_t
>   * @advertising:pointer to destination link mode.
> -- 
> 2.34.1
> 

