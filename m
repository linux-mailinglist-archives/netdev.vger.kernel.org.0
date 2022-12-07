Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393F86459B7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiLGMTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLGMTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:19:41 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CE137239;
        Wed,  7 Dec 2022 04:19:40 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id vv4so13590140ejc.2;
        Wed, 07 Dec 2022 04:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmvTqKRfXOeoURV/WIPlQ7bnJ0f1gD5Beg1+F1mUpNc=;
        b=cW6t/jpbIjWlAWC3U/V1Cs4laFfQKqbrnXK8gl3HFZymMIBqm3RPou+EUhZaiEn2BT
         0U+/1VTkPBOR8KF/yzvzXwVf2TKidFJPG2m5gwyNfTj2oyqblLPeHpzf+qMJzUMv0tZE
         w/Zu5ZvfOuIjQOzy1Xc4cK8Uwb7jy9udzTjr5kmUP1EJHqOhgP0NSArwF8U+Nj8pXNzO
         7ytU4APQp6lCkVZMFpzPYLiUZ+PySwiUg1H9wC2medjJvLN4ujb5ohAQlYeWDSazowMC
         bvqXP4yQkreqFrmFp3V6QP/5uBrEF5iijQ8Mw73nZv7E4WEKPlUiwStHnxjRXI9r2peE
         w/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmvTqKRfXOeoURV/WIPlQ7bnJ0f1gD5Beg1+F1mUpNc=;
        b=O9EDvzPqWNkEO50UQfadidCmOfeyhHI1XwghywKpGyJKxNPuc2De75XkcoZ1W2b62L
         v42EC+64oFt5UXHwjRJx/SO35SdvOD8rfpbIHHEIyIwazmp/MUUQ2a53gp0Thn9YvAZB
         c4zxUDIv1yzHl8QeItDGusejonMi8zbTvPwHQoIN9HEkqlfKeu4v/N6X8BjJlWQVODR0
         7AIJfK8R848UrTR/c0I9/94/y868YS7MJG+6inU83Al+tDlVv6QyqfNGAeZy3T6l8cZs
         gSfKwO4N3AO9xGRtdvQgIurM9tbFcrKs029a+nvRYPtJy6HWcFaOW3fc0lq27D4j6Giu
         AktA==
X-Gm-Message-State: ANoB5pnS2oGsRZDwjQCLZTXmTfreMTq4866BCl5mMDgHgwSvfg8tQZky
        yl600HS8fG0ewtX8LjzjvQXi+sUWPpA5vA==
X-Google-Smtp-Source: AA0mqf710KJyubfBfFDRySyEWxRYlhvTHvDg5EqXEu6Ekf4TW3mQL/90vCxzymeGqShMkUfq2dWoQQ==
X-Received: by 2002:a17:907:a688:b0:7ba:ba67:f2f with SMTP id vv8-20020a170907a68800b007baba670f2fmr51927784ejc.199.1670415578714;
        Wed, 07 Dec 2022 04:19:38 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b007ad9c826d75sm8363992ejf.61.2022.12.07.04.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 04:19:38 -0800 (PST)
Date:   Wed, 7 Dec 2022 14:19:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221207121936.bajyi5igz2kum4v3@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 02:23:28PM +0300, Dan Carpenter wrote:
> The bit_reverse() function is clearly supposed to be able to handle
> 64 bit values, but the types for "(1 << i)" and "bit << (width - i - 1)"
> are not enough to handle more than 32 bits.
> 
> Fixes: 554aae35007e ("lib: Add support for generic packing operations")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  lib/packing.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/packing.c b/lib/packing.c
> index 9a72f4bbf0e2..9d7418052f5a 100644
> --- a/lib/packing.c
> +++ b/lib/packing.c
> @@ -32,12 +32,11 @@ static int get_reverse_lsw32_offset(int offset, size_t len)
>  static u64 bit_reverse(u64 val, unsigned int width)
>  {
>  	u64 new_val = 0;
> -	unsigned int bit;
>  	unsigned int i;
>  
>  	for (i = 0; i < width; i++) {
> -		bit = (val & (1 << i)) != 0;
> -		new_val |= (bit << (width - i - 1));
> +		if (val & BIT_ULL(1))

hmm, why 1 and not i?

> +			new_val |= BIT_ULL(width - i - 1);
>  	}
>  	return new_val;
>  }
> -- 
> 2.35.1
> 

