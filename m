Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5C64F8661
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbiDGRoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiDGRoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:44:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A67B22834A;
        Thu,  7 Apr 2022 10:42:21 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j12so8951642wrb.5;
        Thu, 07 Apr 2022 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Qf5/HY0H/HARlpQawjWcubI38eU259kawMq8gp9O7d4=;
        b=CrkVJRLO1aSJixV9DWKUTF746y41oFcj/ZYQXCMA93sWiB0r8cbHO/f8LZz8KS6V2R
         VtJYpBNgDsp6YUKM35f2uF3N+8gfMhpVgeHmhzuz8xy4T8pCvh4xoKIQ25X6AicMAZXP
         deImoshAMsKtF6YC9AZ2M7IJUaUdxIiycCgtpArV5rA0mTPv8LpJEcJyarvYcnZXmNCI
         aWlfhIlk0mpOrWQ6OdxS5X8MjD75utFVj5Sl/xPB855dp78ch/LkHjf2soCCgGydwfVJ
         cTIojrIudwVz04FEA14NfrVFmBYZG7vKl9ICFrjbOEbVg9rmja7sZ7v3ms1J2iW6OXWv
         jt3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qf5/HY0H/HARlpQawjWcubI38eU259kawMq8gp9O7d4=;
        b=7qi7tCz7JqzOUKHbGVwAmoXq7ilh7nC0G7LKmc9lF8tsOysF7stit+/K9GUCHtkMaw
         wD93RyXmGooAdt0zLE9rd23OK2tShHUQOgGyVigLPOP1v3dVeNAg4thLVXtXDEw5rnC7
         +RAWU0G38rm49LrSPrm2NDFoKCyXRnW9pauqVE7595z86BDH6ThQGNy1PvPtCl5lPnJB
         Jk+J5amPSGX7FgF+3XZRFkZXSxzKfWw1ybkYSgqMw9sTGQxeWw7HUNQ/i/XGNR68F7ks
         3GmZtmfujAIrET9f2y1Xzlu+VY2GS17NxUPYV7T53Z1ZSpOIXG3ISLjC5rVvUKPwha7l
         yziA==
X-Gm-Message-State: AOAM531nls20aIahsE1S/drhLWAagcYpTVRewh/N6nIuXB41hd3aUWOh
        MbZZ+P43s8t+kl2zGDb5gnI=
X-Google-Smtp-Source: ABdhPJygSojkbPQ9T6nmuvpmWKE0eBxm5eOSmqhSZlDa5KHyWLaKpOYDGTp1qDvg6zbYeK2/pSW5Og==
X-Received: by 2002:adf:d222:0:b0:206:17ba:5f76 with SMTP id k2-20020adfd222000000b0020617ba5f76mr11454903wrh.484.1649353339722;
        Thu, 07 Apr 2022 10:42:19 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600015c600b00203fa70b4ebsm21873677wry.53.2022.04.07.10.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 10:42:19 -0700 (PDT)
Subject: Re: [PATCH net-next 11/15] sfc: Remove usage of list iterator for
 list_add() after the loop body
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-12-jakobkoschel@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <4520e9c5-8871-b281-f621-ac737e64333b@gmail.com>
Date:   Thu, 7 Apr 2022 18:42:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20220407102900.3086255-12-jakobkoschel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/04/2022 11:28, Jakob Koschel wrote:
> In preparation to limit the scope of a list iterator to the list
> traversal loop, use a dedicated pointer to point to the found element [1].
> 
> Before, the code implicitly used the head when no element was found
> when using &pos->list. Since the new variable is only set if an
> element was found, the list_add() is performed within the loop
> and only done after the loop if it is done on the list head directly.
> 
> Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
> Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>

The commit message doesn't accurately describe the patch; it states
 that "the list_add() is performed within the loop", which doesn't
 appear to be the case.
Also it seems a bit subtle to use `head` as both the head of the
 list to iterate over and the found entry/gap to insert before; a
 comment explaining that wouldn't go amiss.
(I'd question whether this change is really an improvement in this
 case, where the iterator really does hold the thing we want at the
 end of the search and so there's no if(found) special-casing —
 we're not even abusing the type system, because efx->rss_context
 is of the same type as all the list entries, so ctx really is a
 valid pointer and there shouldn't be any issues with speculative
 accesses or whatever — but it seems Linus has already pronounced
 in favour of the scope limiting, and far be it from me to gainsay
 him.)

-ed

> ---
>  drivers/net/ethernet/sfc/rx_common.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
> index 1b22c7be0088..a8822152ff83 100644
> --- a/drivers/net/ethernet/sfc/rx_common.c
> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -563,8 +563,10 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
>  
>  	/* Search for first gap in the numbering */
>  	list_for_each_entry(ctx, head, list) {
> -		if (ctx->user_id != id)
> +		if (ctx->user_id != id) {
> +			head = &ctx->list;
>  			break;
> +		}
>  		id++;
>  		/* Check for wrap.  If this happens, we have nearly 2^32
>  		 * allocated RSS contexts, which seems unlikely.
> @@ -582,7 +584,7 @@ struct efx_rss_context *efx_alloc_rss_context_entry(struct efx_nic *efx)
>  
>  	/* Insert the new entry into the gap */
>  	new->user_id = id;
> -	list_add_tail(&new->list, &ctx->list);
> +	list_add_tail(&new->list, head);
>  	return new;
>  }
>  
> 

