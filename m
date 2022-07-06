Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25C9568082
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiGFHyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiGFHyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:54:01 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5EEE0;
        Wed,  6 Jul 2022 00:54:01 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id s1so20761798wra.9;
        Wed, 06 Jul 2022 00:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=wTaiitSYSTKAftb+sClK9RtM/bwgI7yK3/X/dGn1Cl8=;
        b=lzERZhMa6lH6qQHZNTOfPP9/N9alWnSobQKvmKTnYSjEhm4umwKblSeZZtCPFnm7hk
         dltwLuFztcyV00xuK3HbZ+Eq7RyNB+HLyJj1D7RMuYkR+K6zkkHiw+MdAca0vnEe8BbZ
         HTVnhCRlrISL6vZEqWG8BGLblBTFWlrqXdlxg43cJd+GyCAmjE916yhWPD7slhWmeJFU
         iHXvCvXrZYVbI8fSO6ZSzACX+c7VmaueluPbmzQ0f6nuM7rzkyKLOrdstkED5j0Ozklh
         WEyT9hZpbHLxqQUDFZ3DfIZFO6fICj2SbQzLgop12Zh1zUx9fwNFmR5wPfvVcVtkwBQe
         ZI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=wTaiitSYSTKAftb+sClK9RtM/bwgI7yK3/X/dGn1Cl8=;
        b=WA5zkfuORSHzAjgB5ycG93q6k4xfFcfeaHsdWcnPR21S14frIjADKKCvh5ARou0k2L
         7vyo33mfAU8XPecHJLpWZrmFi1aIHHVAl85M7umMa8mTiB1bIHPGe/3vmrUVFcHovdqE
         msLYQ8ds+tGacrJbIVsvebhOGOFM8V0ik8u9ExJf2JG8cq7Gg9PqKEZKKaUxF81LE4MF
         zr5xR19kZqz5/lhhBytyHy/bHdJvVtKr+OzVdKiDifxVp4ZNnf8oAAdmCg1omHHe1dUl
         MCzxr1m2hPVzQyn37dx/m9xzLCaZfi8mj/yD+XoM2b19gXjHzLCqHHA0OQ2Nz5JseXkN
         N4cg==
X-Gm-Message-State: AJIora/nh3KLMjRyV8MDhM642Nn3ehQkH1xBXfo1/Abjpn41rviUwW5K
        QfrP5NoymcIUbrWD1ielQpo=
X-Google-Smtp-Source: AGRyM1v2VfNRofCEEnbrLHBU/cC3GaWRmsG8bFKUDwxemNUW6rQAZsF0k5vzR89zOpfDKyq6N+GzgQ==
X-Received: by 2002:a5d:4b05:0:b0:21d:79fb:88d5 with SMTP id v5-20020a5d4b05000000b0021d79fb88d5mr3541245wrq.54.1657094039639;
        Wed, 06 Jul 2022 00:53:59 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id s1-20020a5d4ec1000000b0021004d7d75asm9147970wrv.84.2022.07.06.00.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 00:53:58 -0700 (PDT)
Date:   Wed, 6 Jul 2022 08:53:56 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sfc: falcon: Use the bitmap API to allocate bitmaps
Message-ID: <YsU/lJUM0fIXubKY@gmail.com>
Mail-Followup-To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <c62c1774e6a34bc64323ce526b385aa87c1ca575.1657049799.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62c1774e6a34bc64323ce526b385aa87c1ca575.1657049799.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 09:36:51PM +0200, Christophe JAILLET wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/falcon/farch.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/farch.c b/drivers/net/ethernet/sfc/falcon/farch.c
> index 2c91792cec01..c64623c2e80c 100644
> --- a/drivers/net/ethernet/sfc/falcon/farch.c
> +++ b/drivers/net/ethernet/sfc/falcon/farch.c
> @@ -2711,7 +2711,7 @@ void ef4_farch_filter_table_remove(struct ef4_nic *efx)
>  	enum ef4_farch_filter_table_id table_id;
>  
>  	for (table_id = 0; table_id < EF4_FARCH_FILTER_TABLE_COUNT; table_id++) {
> -		kfree(state->table[table_id].used_bitmap);
> +		bitmap_free(state->table[table_id].used_bitmap);
>  		vfree(state->table[table_id].spec);
>  	}
>  	kfree(state);
> @@ -2740,9 +2740,7 @@ int ef4_farch_filter_table_probe(struct ef4_nic *efx)
>  		table = &state->table[table_id];
>  		if (table->size == 0)
>  			continue;
> -		table->used_bitmap = kcalloc(BITS_TO_LONGS(table->size),
> -					     sizeof(unsigned long),
> -					     GFP_KERNEL);
> +		table->used_bitmap = bitmap_zalloc(table->size, GFP_KERNEL);
>  		if (!table->used_bitmap)
>  			goto fail;
>  		table->spec = vzalloc(array_size(sizeof(*table->spec),
> -- 
> 2.34.1
