Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7AB56807E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 09:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiGFHxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 03:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiGFHxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 03:53:13 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D222BCA;
        Wed,  6 Jul 2022 00:53:12 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o19-20020a05600c4fd300b003a0489f414cso8482298wmq.4;
        Wed, 06 Jul 2022 00:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0nXdiIhp5hpiKJM0T0v/8E9SNniFeIuey83M+NyOqo=;
        b=oUXZgJ0PbFDJwqHv2skq9OYSLrNvRjMt3jfFXSqnJQ2oKwzdSXzNnN54utgNCysLP0
         B7Met4KCksl8aXZ/onP98+FrrnJtw1tU1vgJdXM/RDo8o1bUPbWweA/wvbVLek0pYVqu
         CsBeinpZ3G1bmd94HKe6HMNP2BqN53KSaz6wNkRLlv2JLx4AdoDEdYc5dNY9bby0Lm+F
         EFILv1s54I2oLMLuR8rVe5WX5NFQPmwaZUfUDh0tSZzt/09WokcsAmKnPRSEg1hgMCZE
         rzOLTz4De4YtM67KyoRArSLRVT1CtfCNparIqR+90GkrJw7OjVZzznHioG/VwKdVis6S
         +/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=a0nXdiIhp5hpiKJM0T0v/8E9SNniFeIuey83M+NyOqo=;
        b=kATH8Qm+GzAeTPGPqNQM9fzuKEZiAWIbGcdM0FBIZ3PiIH/MNvB9yjN74Ro6Wj6xcC
         NRRDs3t9zlzelqTrVbJmRhbDS1MxmXp93o+83M65DpUDAp/l5TfV613QGPfj6ZN4yXUY
         IA6NGj4yBWGiVBWnSjCk9erjYmIZf2+peb+SGBDUfqWn7x1c8tO1Tzve9DQxMDOhpy0N
         51oCAS4aaEuvZr6tyszr4f3TjlFrL9b26fpRa1FWtSMYvih0fQbya2W7brR6I/equooQ
         SvumnDgDpFrfvQxUkn3Cac7kisGU7eWgWvlYhbCr9KJk703BjjxVJbUByDsCbD40cP8P
         H36w==
X-Gm-Message-State: AJIora9yffqi1uqYxERtYLg6EFaued8z+ZQR3/uhLFk9iFRWLEN3DJ8E
        9JSY8JiX08eia7VL6/ydRvw=
X-Google-Smtp-Source: AGRyM1ucMvrmrckFEIpDrHtIqRL56U3uObNXjqMWzzF0QLJ1C3fGV4CbirI/qN6rcwZOo1E+k017Pw==
X-Received: by 2002:a05:600c:4e51:b0:3a0:4e8d:1e44 with SMTP id e17-20020a05600c4e5100b003a04e8d1e44mr41719990wmq.105.1657093990659;
        Wed, 06 Jul 2022 00:53:10 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n30-20020a05600c501e00b0039c454067ddsm25228583wmr.15.2022.07.06.00.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 00:53:09 -0700 (PDT)
Date:   Wed, 6 Jul 2022 08:53:06 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sfc/siena: Use the bitmap API to allocate bitmaps
Message-ID: <YsU/YpqzeV/77Ay7@gmail.com>
Mail-Followup-To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
References: <717ba530215f4d7ce9fedcc73d98dba1f70d7f71.1657049636.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <717ba530215f4d7ce9fedcc73d98dba1f70d7f71.1657049636.git.christophe.jaillet@wanadoo.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please use "PATCH net-next" in these kind of patches for netdev.
See Documentation/process/maintainer-netdev.rst

On Tue, Jul 05, 2022 at 09:34:08PM +0200, Christophe JAILLET wrote:
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/siena/farch.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/siena/farch.c b/drivers/net/ethernet/sfc/siena/farch.c
> index cce23803c652..89ccd65c978b 100644
> --- a/drivers/net/ethernet/sfc/siena/farch.c
> +++ b/drivers/net/ethernet/sfc/siena/farch.c
> @@ -2778,7 +2778,7 @@ void efx_farch_filter_table_remove(struct efx_nic *efx)
>  	enum efx_farch_filter_table_id table_id;
>  
>  	for (table_id = 0; table_id < EFX_FARCH_FILTER_TABLE_COUNT; table_id++) {
> -		kfree(state->table[table_id].used_bitmap);
> +		bitmap_free(state->table[table_id].used_bitmap);
>  		vfree(state->table[table_id].spec);
>  	}
>  	kfree(state);
> @@ -2822,9 +2822,7 @@ int efx_farch_filter_table_probe(struct efx_nic *efx)
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
