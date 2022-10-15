Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FC55FF792
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 02:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJOATG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 20:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJOATF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 20:19:05 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D0D97EF0;
        Fri, 14 Oct 2022 17:19:03 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id f8so3532910qkg.3;
        Fri, 14 Oct 2022 17:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/alrnZ8RGuVp6j1Zrsk6QBDaasP3/xhmubHkhBRVSsA=;
        b=AMVphJLHZ9lrDKEKh7lRVA3M2w8YEDw/iRcjZJi4l4uqd0BZ8kFXJ6zQeixuFeZMHP
         G87iS7fpZB6tK79bknSf6a0GDBjvlUP2pN4BgXXoVhQvScEb+j388Vc7IhdtWAXbu6ek
         zU95ZMWhc7FUi1vfacyfVmYW/VUXNcISX1ZBEDEHLCmo8vSrDCwmsk8U2FiYMgplCVcq
         +6Gf07bq4c4d3TGPDdC2uM9WOcssXpbLj6iCJ3PamCvYRduutKIb4km6y6WWlUR2sB0z
         XY/gTWB9H1zKfzFTv8TDQ98MK9fTtZazv83qlwtwjMOGZpVcK33p+l+qYXra3G6fC33c
         tb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/alrnZ8RGuVp6j1Zrsk6QBDaasP3/xhmubHkhBRVSsA=;
        b=mAqca8cnHKuVLDiWiAzVzIKLG6hwUSHaGaXVchWLEPPDGxcDcKmKhY0Wdzl16CLcxH
         7WRQBi2nslQRqjQPSzenII1FCdLKs2sOMT2y428eDre14/EjhhNp1c5FqcYYSPFnfu4o
         hXGC1vds2pnWZZhu1wlWIE6UY0OwQ9I7aNcNPEATCrgvDaFNjRY3+18gDqi390iAzQ/P
         bD8M3tUNZGJ5UF3uP4HRNajBFgteZJcS1IQanRLq6oSuCI6/hW/JX9+LZFR7qCkO4g/L
         1JqnRB2c301EctSkRvxGkjztLvGktzAw6ve2Ize9B+hAmL8MCNvnQ1L1Rdw3w9OHkAPh
         L0MA==
X-Gm-Message-State: ACrzQf0DxiDmTycCqhyWrwfer/wWvrbiMoh2QtDgQgStA3+aF6KfCD90
        N3e3MMcjWqigHVRwUMu15K6EkCY1Cb4=
X-Google-Smtp-Source: AMsMyM6z3AyQjtw4AbKFBqX7lNUeKpxoug5KAdK4vFnqkkcSJ9SU5gFd6CgpXfEu+0DzFu6wecx2mw==
X-Received: by 2002:a05:620a:bd4:b0:6cf:468e:e092 with SMTP id s20-20020a05620a0bd400b006cf468ee092mr332445qki.583.1665793142955;
        Fri, 14 Oct 2022 17:19:02 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id i7-20020ac87647000000b0035cd6a4ba3csm3012049qtr.39.2022.10.14.17.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 17:19:02 -0700 (PDT)
Message-ID: <fe87aff8-bb93-cea0-f05c-e72a256bdf11@gmail.com>
Date:   Fri, 14 Oct 2022 20:19:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] sunhme: Uninitialized variable in
 happy_meal_init()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <Y0lzHssyY3VkxuAz@kili>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y0lzHssyY3VkxuAz@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/22 10:33, Dan Carpenter wrote:
> The "burst" string is only initialized for CONFIG_SPARC.  It should be
> set to "64" because that's what is used by PCI.
> 
> Fixes: 24cddbc3ef11 ("sunhme: Combine continued messages")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Use "64" instead of ""
> 
>   drivers/net/ethernet/sun/sunhme.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 62deed210a95..55f7ec836744 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -1328,7 +1328,7 @@ static int happy_meal_init(struct happy_meal *hp)
>   	void __iomem *erxregs      = hp->erxregs;
>   	void __iomem *bregs        = hp->bigmacregs;
>   	void __iomem *tregs        = hp->tcvregs;
> -	const char *bursts;
> +	const char *bursts = "64";
>   	u32 regtmp, rxcfg;
>   
>   	/* If auto-negotiation timer is running, kill it. */

Reviewed-by: Sean Anderson <seanga2@gmail.com>
