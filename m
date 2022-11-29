Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5C563C5F0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbiK2RAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236393AbiK2Q75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:59:57 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403C36DCDC;
        Tue, 29 Nov 2022 08:55:35 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e13so20614737edj.7;
        Tue, 29 Nov 2022 08:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H4WRM4i4cJCaSRummZu07jrquhNO6Qjg2TekBEdVbcE=;
        b=V5ocopjM+waV8hKtdM9oUKjzjikQkHTkxLPRkteuBCt+ovw4+zppKrvMGosxwp1nLS
         sNgvgguGpHasjUzR2f8hKhrpUw8J033xH7aapuBOMwd/5QLOSj0EIQKpZAocRdFd5t4y
         auEfFO6rhRUww28QNoEWn9uWmfXN1/iQ322xuQe6mGaZiR9hCZFYGctl2zVaN6/LZtHL
         uH/N0O2UpbRRR0IrappO8sOvcuKWS0p6itg9Ul4gHkDuRts2HgKRVnRHpsDjk6n1T/Ss
         XvPL1qx+9SxTESvvqPDKJZKWe7HyerN8UVVLJwM5wwsoJZcSKgCubGe4Zn1NKWFOoLU5
         cwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4WRM4i4cJCaSRummZu07jrquhNO6Qjg2TekBEdVbcE=;
        b=SLiF0XWL70M9FXIZOs3/OWji2PJQIZcKu+SwC/fEOZ4aOR4SoxN2dKuBx6VwNLKBkB
         KnZEfyxeN10MFECyCaq2YCN3ALHHKOCFty2kwnbMMVf1ODMW4TNpc06fHVAfhAUjFDE+
         1VtkaY3DNg287nf0ghqknsBHGEHgsSJkZuSVqtF8tvl5gOMc+zH6lWF0n3paO74I0nj7
         WDI5uJueAJgRhbjUsUK8sT/fZraDy7ubbxmlkg+XBe9sWZbP6k1c/fD/PIt4hJAzfj21
         9HcFIi+tLnjZZevOUosRSHYRAVCW9wcdclpMXfHI6xLgqKLPbJVVGtKWa/6NzlfPTfHr
         +vvg==
X-Gm-Message-State: ANoB5pkE8OTgPwgOt94c4FOT0ugOC2HT2/yJIQPRe1f9vgni1ih7/yd5
        NRaHaG8/pBKwa4HxNwrTIAU=
X-Google-Smtp-Source: AA0mqf4CnOnBJvFqGmxhU0Qq9oYKDZkaLNdhJuT+k9UtE/Bd1QezYC2K8/yy74w6LcR1SGG+gstmww==
X-Received: by 2002:a05:6402:2929:b0:469:b603:ca21 with SMTP id ee41-20020a056402292900b00469b603ca21mr37195795edb.350.1669740933664;
        Tue, 29 Nov 2022 08:55:33 -0800 (PST)
Received: from skbuf ([188.26.185.64])
        by smtp.gmail.com with ESMTPSA id k20-20020a17090627d400b007bf5250b515sm3154943ejc.29.2022.11.29.08.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 08:55:33 -0800 (PST)
Date:   Tue, 29 Nov 2022 18:55:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Artem Chernyshev <artem.chernyshev@red-soft.ru>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH] net: dsa: ksz: Check proper trim in ksz_common_rcv()
Message-ID: <20221129165531.wgeyxgo5el2x43mj@skbuf>
References: <20221129140809.2755960-1-artem.chernyshev@red-soft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129140809.2755960-1-artem.chernyshev@red-soft.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Artyom,

On Tue, Nov 29, 2022 at 05:08:09PM +0300, Artem Chernyshev wrote:
> Return NULL if we got unexpected value from skb_trim_rcsum()
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: bafe9ba7d908 ("net: dsa: ksz: Factor out common tag code")
> Signed-off-by: Artem Chernyshev <artem.chernyshev@red-soft.ru>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

It looks like the same pattern exists in tag_hellcreek.c and in
tag_sja1105.c. Do you intend to patch those as well?

>  net/dsa/tag_ksz.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 38fa19c1e2d5..429250298ac4 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -21,7 +21,8 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
>  	if (!skb->dev)
>  		return NULL;
>  
> -	pskb_trim_rcsum(skb, skb->len - len);
> +	if (pskb_trim_rcsum(skb, skb->len - len))
> +		return NULL;
>  
>  	dsa_default_offload_fwd_mark(skb);
>  
> -- 
> 2.30.3
> 
