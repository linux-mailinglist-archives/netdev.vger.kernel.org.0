Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9207D6EA0B5
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 02:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjDUAkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 20:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjDUAku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 20:40:50 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75CA9F;
        Thu, 20 Apr 2023 17:40:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63d4595d60fso11103828b3a.0;
        Thu, 20 Apr 2023 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682037648; x=1684629648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sTuACkgKkUG8BEjwqXpr54lGYsJ9iErhStfiFT3Cv7A=;
        b=FSchoR9xgp6F+ve4+ehe7wI+avX0bRiEH9RPU3EVxiKT1InQGzWmlFVCHI+wuQ56Bd
         POdQhLwUfJ5GniUFhzZ8YgQRn482TmzKYWU4Kztqg9WrDaDuxgToh32bCXyvGcmYLZBn
         gkCVWOmnLYgqDt5dtwY/Ig46jludUd0UTVKMGKoVpk9PAvVQ9ZB43/HI4EewOkY13BVR
         tiFFJ0uC1obSwv9MxNkEJmhtPohB1JkG5nDTBLquJjzS7qXfF6OmAz8GWdKAStUNmCJH
         c7d9pPxx42AibEzTFYTXYRuuDDnmRL5UEE+1AtwtaUBGpst38nWpJJk8AKVqQ74Wz2FN
         TBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682037648; x=1684629648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sTuACkgKkUG8BEjwqXpr54lGYsJ9iErhStfiFT3Cv7A=;
        b=KN91QSqYeFhuiTDHY6zAmmF7DLt2qXjKiJsDCSSYvReH8RGQ+MHAbEQIVS+brvNraY
         UomkGFSMcJ1JEWWPb/rPqlCqpoAQQrYumgsR3lxjIKV5x77Zc16/X3znjucG28JhxqtI
         GDDtIARxZjdlIGMEo0jmHwiH1A+n8p7HIejTfjcAj8jeMZhoBcaPdH83o1BHc6bQTl5X
         Pxk202VpoCRgkUU8K+yhbEgda5/jPE7r8PyHXph8V0xVh+v0aK+kn+w5an2JSbW8Nftf
         dvE+cFmnSb/rof4T0uM0M1vzRQI/RJHaTK9VG9flHPg7i0vRT5yUmVIJwLedMozhp2Qi
         isJg==
X-Gm-Message-State: AAQBX9eBP12YcD3tQ9RCM+oHGQqvE3U1KaA+EtxcjEpxCZrv1eoE98xe
        jTdidfNoYaIb/0DtHFaVpG4=
X-Google-Smtp-Source: AKy350aevJh+Ax/Lfo5mZD5qxH5k9UlZic5c4IzDGiFBdH37T91eUaWm/KoHdNEnp0LR2meRFjunzA==
X-Received: by 2002:a17:90a:1481:b0:23f:9445:318e with SMTP id k1-20020a17090a148100b0023f9445318emr3560129pja.3.1682037648157;
        Thu, 20 Apr 2023 17:40:48 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:65e8:96ae:d527:184b? ([2600:8802:b00:4a48:65e8:96ae:d527:184b])
        by smtp.gmail.com with ESMTPSA id lt24-20020a17090b355800b00247735d1463sm1685467pjb.39.2023.04.20.17.40.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 17:40:47 -0700 (PDT)
Message-ID: <be0d976a-2219-d007-617d-6865c0344335@gmail.com>
Date:   Thu, 20 Apr 2023 17:40:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next] net: dsa: b53: Slightly optimize b53_arl_read()
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <c94fb1b4dcd9a04eff08cf9ba2444c348477e554.1682023416.git.christophe.jaillet@wanadoo.fr>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <c94fb1b4dcd9a04eff08cf9ba2444c348477e554.1682023416.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2023 1:44 PM, Christophe JAILLET wrote:
> When the 'free_bins' bitmap is cleared, it is better to use its full
> maximum size instead of only the needed size.
> This lets the compiler optimize it because the size is now known at compile
> time. B53_ARLTBL_MAX_BIN_ENTRIES is small (i.e. currently 4), so a call to
> memset() is saved.
> 
> Also, as 'free_bins' is local to the function, the non-atomic __set_bit()
> can also safely be used here.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/net/dsa/b53/b53_common.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> index 3464ce5e7470..8c55fe0e0747 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1627,7 +1627,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
>   	if (ret)
>   		return ret;
>   
> -	bitmap_zero(free_bins, dev->num_arl_bins);
> +	bitmap_zero(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);

That one I am not a big fan, as the number of ARL bins is a function of 
the switch model, and this illustrates it well.

>   
>   	/* Read the bins */
>   	for (i = 0; i < dev->num_arl_bins; i++) {
> @@ -1641,7 +1641,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
>   		b53_arl_to_entry(ent, mac_vid, fwd_entry);
>   
>   		if (!(fwd_entry & ARLTBL_VALID)) {
> -			set_bit(i, free_bins);
> +			__set_bit(i, free_bins);

I would be keen on taking that hunk but keep the other as-is. Does that 
work for you?
--
Florian
