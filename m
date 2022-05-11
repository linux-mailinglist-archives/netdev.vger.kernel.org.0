Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D423152371A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239018AbiEKPWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 11:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343597AbiEKPWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 11:22:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D53224061
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:22:45 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id ks9so4799762ejb.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 08:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MAomAbEfzePQl0GGOXKInUw4+ZuXa/k4VIV62YMex0U=;
        b=ZEH8OPVJsHOKFJUZr50vtmXZ5xKTywx2dMLfySVnFjYY6oDxf8MAmmQr51ck6c/6NX
         SK9AkqTTT2W0ujymsEQIprCXYiSpDCPwG5TxfdvcGotewUyeU8eoP6TxLPhChgIr65cQ
         psQoqsnMYjSx5A4fPnVP/YGbVRv3xv4xUC5nF2wLz1zGUL8X+dvL549IAsZfZwMPGcIF
         nTgsUbxez0Z9teod7j18f6nH3ZH/h/Xt3N39R+x4asHfA/lv4KpJQp2Y6di6el9gZhje
         dcKSTlZCTv7LWrBE0beGBnHwLmJlErkL8OnlttewQHKYpQvRXH/mrfV5OTZcfF49eMas
         9rOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MAomAbEfzePQl0GGOXKInUw4+ZuXa/k4VIV62YMex0U=;
        b=CXsjwfPicQIfKNu19MArk4DL7TFGbOi5z3vnWVF4d5AAE3FQhkpyIiE6wpyoNQkSze
         tXU/ev+YMr1i+w9nIaH/fzKTfnyMQi9U3BDqqQu7yZ5ajMcdKeE9Zaj0yqjCDvN8OTnL
         jlxhlQrd/a+1MTVSqVXpZUD90XS114VXAmjLrcAW5b/rR1/FPN4KBWg2eGfNFttEXiFi
         EeOuF9YbQjjWxDfX8JwXLh2GRvvu+YHEKAD06xPvT6XiV7utEXJLd44ULLiSZ2YBCu5S
         M3rNTCWS/hw4SJ3/c/viQWyFnnAIlY4nkHKgz0UBoCr/Qw1MD53XavA0U5p9gNBa/ZYO
         gw2g==
X-Gm-Message-State: AOAM532nBolxMc2KmkVxAw2ndpgzM8Bh/mb8r5MefM4LP5gMZCK9CSWm
        gnfxCYwxtdQUtlnzdzKkq078t3+PKx0=
X-Google-Smtp-Source: ABdhPJyzj78JPsercJuKNgn28uobLh1Bf7aq7GDkK/d/6ru7Q9Jv9yOCdIQM3KE0UpqI4UGOL/06Zw==
X-Received: by 2002:a17:907:1b20:b0:6da:649b:d99e with SMTP id mp32-20020a1709071b2000b006da649bd99emr24757581ejc.712.1652282563906;
        Wed, 11 May 2022 08:22:43 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id y25-20020aa7ca19000000b0042617ba639dsm1348199eds.39.2022.05.11.08.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 08:22:43 -0700 (PDT)
Date:   Wed, 11 May 2022 18:22:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 0/5] Simplifications for Broadcom and Realtek
 DSA taggers
Message-ID: <20220511152241.nl2vrj3wtktpzwks@skbuf>
References: <20220511151431.780120-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511151431.780120-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 06:14:26PM +0300, Vladimir Oltean wrote:
> This series contains the removal of some "if" conditions from the TX hot
> path in tag_brcm and tag_rtl4_a. This is made possible by the fact that
> the DSA core has previously checked that memory allocations are not
> necessary, so there is nothing that can fail.
> 
> Vladimir Oltean (5):
>   net: dsa: tag_rtl4_a: __skb_put_padto() can never fail
>   net: dsa: tag_brcm: do not account for tag length twice when padding
>   net: dsa: tag_brcm: __skb_put_padto() can never fail
>   net: dsa: tag_brcm: eliminate conditional based on offset from
>     brcm_tag_xmit_ll
>   net: dsa: tag_brcm: use dsa_etype_header_pos_tx for legacy tag
> 
>  net/dsa/tag_brcm.c   | 51 +++++++++++++++++++-------------------------
>  net/dsa/tag_rtl4_a.c |  4 +---
>  2 files changed, 23 insertions(+), 32 deletions(-)
> 
> -- 
> 2.25.1
> 

Oh, wait, the premise behind patches 1 and 3 is invalid.
dsa_realloc_skb() only ensures there are ETH_ZLEN bytes of space in the
skb for tail taggers.

	if (unlikely(needed_tailroom && skb->len < ETH_ZLEN))
		needed_tailroom += ETH_ZLEN - skb->len;

Please treat the patch set as RFC, if we have agreement on the overall
idea I can update dsa_realloc_skb() by removing "needed_tailroom && "
from the check so the guarantee applies to all taggers.
