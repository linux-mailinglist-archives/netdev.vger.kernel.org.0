Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D9969680C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:27:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjBNP14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBNP1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:27:54 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160FC2A156;
        Tue, 14 Feb 2023 07:27:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id e17so8547161plg.12;
        Tue, 14 Feb 2023 07:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T2gONfgsuLvi/PGrWuUJXitioJNS4IAdzsnEVyJR18A=;
        b=O3O+5P8E5ydsAjlcTg4zTAFNRyGF6x6+VqqcMyl7B4BEo0soxTJxIQeyIbX1zLhX2o
         A6mn8bsjoa7IOGJsVZjU8cV16ZvUkvO0NEwFbgxp/l3vWdyWstN7y35SOb2P0R4uBgUN
         zxtG5xlsADO4y6lWtK0exfzZuRiYX2b1HWKMNQ9jR+VJzFzZRCsB6Xdb8ynZeWG0fXcD
         LpfIPjuyNf9eqm5ki/Pt/hFmvUf4bM1A6HOYzoXKEnfck+SCWvFzeWaAkYIIXlUP096C
         2TRlYZFN8ykBYNjlgmlJqu7wQut6dulsE6j1nOAzXsYiLUvsicdMkSqIB9RFvTsDuOR3
         ddJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T2gONfgsuLvi/PGrWuUJXitioJNS4IAdzsnEVyJR18A=;
        b=eJ7MXmp3b1T8s5Jsgbsf68OKX1ZTiD+qStTqqsBsf/CcH38iCMRRiAZppNbCfdvMcg
         hEYbcrclPVewkgcVOzT87mX1Qb98mo7a5QNnsbo29gLRDTcaTbHPXfFxWOWxX49xzJK1
         WwjNz8c3XI5HSSUTGjf+D2Ye8rAPgqjJGwgkJfTeNfa/9x9H0RpeUbaSy3RmI84GSjxR
         PyS1yt8CUjsVQAfXYwTDh4P5yg45dcFPWZv1O4PsScu5l46q5Mh41wVmKxPloG3/3e+7
         8m1mzwwq0ZW4RvfFwIoJ0ScAj1xt6uQIEz4bwjgbUMMaHXGUrAUDBdE7FLqez2y8hDIG
         4Qqw==
X-Gm-Message-State: AO0yUKWRnGeOeBJdpi4YGdPxYlbY/QMF0oEFTRsFMfXSxI05HCmhRXz9
        qaKAXaeJWSFzE97QLM3dQrc=
X-Google-Smtp-Source: AK7set8KQGA34gCNM7hSkFqqmm/wuLXsfITw7BJ7sX60wiX9DGGNxUrsm43qVhi2/hzT05MnTTDGfw==
X-Received: by 2002:a05:6a20:4417:b0:c3:cc88:c3a4 with SMTP id ce23-20020a056a20441700b000c3cc88c3a4mr3482202pzb.45.1676388463236;
        Tue, 14 Feb 2023 07:27:43 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id x13-20020a63aa4d000000b004fbb4a55b64sm3109178pgo.86.2023.02.14.07.27.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:27:42 -0800 (PST)
Message-ID: <3bc180079f301dcbc24596b826c94c56424ba6c8.camel@gmail.com>
Subject: Re: [PATCH v2] page_pool: add a comment explaining the fragment
 counter usage
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Date:   Tue, 14 Feb 2023 07:27:41 -0800
In-Reply-To: <20230214104316.2254814-1-ilias.apalodimas@linaro.org>
References: <20230214104316.2254814-1-ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-14 at 12:43 +0200, Ilias Apalodimas wrote:
> When reading the page_pool code the first impression is that keeping
> two separate counters, one being the page refcnt and the other being
> fragment pp_frag_count, is counter-intuitive.
>=20
> However without that fragment counter we don't know when to reliably
> destroy or sync the outstanding DMA mappings.  So let's add a comment
> explaining this part.
>=20
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
> Changes since v1:
> - Update the comment withe the correct description for pp_frag_count
>  include/net/page_pool.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 34bf531ffc8d..277e215cfb58 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -277,6 +277,16 @@ void page_pool_put_defragged_page(struct page_pool *=
pool, struct page *page,
>  				  unsigned int dma_sync_size,
>  				  bool allow_direct);
>=20
> +/* pp_frag_count represents the number of writers who can update the pag=
e
> + * either by updating skb->data or via DMA mappings for the device.
> + * We can't rely on the page refcnt, as we don't know who might be
> + * holding page references and we can't reliably destroy or sync DMA map=
pings
> + * of the fragments.
> + *
> + * When pp_frag_count reaches 0 we can either recycle the page, if the p=
age
> + * refcnt is 1, or return it back to the memory allocator and destroy an=
y
> + * mappings we have.
> + */

I would get rid of the comma between "page" and "if" in the second
paragraph. It breaks things up and makes it a bit harder to read. What
we want to emphasize is that there are two possible paths. The extra
comma makes it almost appear as if there are 3 options.

Otherwise it looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>


