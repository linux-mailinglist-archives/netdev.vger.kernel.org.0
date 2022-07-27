Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BB2581E5C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240109AbiG0Dsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiG0Dsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:48:39 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C585D192B2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:48:36 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id z18so12186409qki.2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JCCzp3HZFSj6lOIxaQ26s3p5QXn0ej4QjDBMyQKElJ0=;
        b=QuzaHJ1Sf5Cj7dgOEl+iBukEa1l/NgeJ38q52iwsHxKa9HzoN41k9WiAzIaeaIpqEx
         G/s3I1z9rY5mwlApDOAIOW1Qj9GkMbYQ+qUDHdu/Iv5Bc0yyReRd57qMQ5T3R56ScQwK
         1mxmC8YHw3D/0ZskuAxOGZJr+Q8WSbTkvQFTkl4e+QE+TII35ImTRvZf8JAjdnKzfr04
         Lh1shEcheo2fCRz5Uun7RaLoiHE9SMqjqmus0szdfq+TiWDgSoZ7iIjIihaVuSFZPwKm
         OdkxKMvcfvByTJ/IhVezoId6d2cmL187I+g//FXeXIgELlDDb+ltD6byBJv4g09aV4N9
         Rm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JCCzp3HZFSj6lOIxaQ26s3p5QXn0ej4QjDBMyQKElJ0=;
        b=pFHJsCJO15l38FEMimMnFv0Lh2DhcLKY+6rLgv36il725x/4USD96BgYEOMDn59Z+B
         vCuGqVTK1eQJVHG1sEQO9enKofl0F/SSm4RNKWEjzHKIgSO7/3+VONXJJWZvxLilQNFy
         EAh/1RGg/qp0fNjyGCmGXeEd9t3s4Zh/bFFfEgG1RAZBXUl+F5SFWmF0EcXE762BAYK1
         3rjQwI+jWfngUY9ubiixPtYeAfXHs3BRDmhB2yj99vf5d5BrPB4uXpwDmpWxH/mMNBwz
         PmsIz3fDijAKSk9A8JbLureKjP90Mlty+gSi7/YZTJe1N37QMAbFIHJ4Nb2ElrhNbbjU
         uoOw==
X-Gm-Message-State: AJIora8LIfAqJY+VUv26tLgzNGDd4rDzNKgHWKMirmWQuaVvV/EFdGuI
        4LoGFeqUopSIEtcUF/2U13EizzttyhI=
X-Google-Smtp-Source: AGRyM1uFFtGb3Nv267yXXNDB0pyIcLKFK7gdERY/x4gORPCK1LN6sdojQSWaI0bFLxhkJz06guHmWg==
X-Received: by 2002:ae9:eb0a:0:b0:6b5:ee4d:e500 with SMTP id b10-20020ae9eb0a000000b006b5ee4de500mr15844645qkg.333.1658893715752;
        Tue, 26 Jul 2022 20:48:35 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id w16-20020a05620a425000b006b6641c4c35sm4663509qko.79.2022.07.26.20.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 20:48:35 -0700 (PDT)
Subject: Re: [PATCH 3/3] sunhme: forward the error code from
 pci_enable_device()
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>, netdev@vger.kernel.org
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <8022143.T7Z3S40VBb@eto.sf-tec.de>
From:   Sean Anderson <seanga2@gmail.com>
Message-ID: <e7c7dbbd-7a8a-3c81-6b78-7069f71642b0@gmail.com>
Date:   Tue, 26 Jul 2022 23:48:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <8022143.T7Z3S40VBb@eto.sf-tec.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 11:23 AM, Rolf Eike Beer wrote:
> This already returns a proper error value, so pass it to the caller.
> 
> Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
> ---
>   drivers/net/ethernet/sun/sunhme.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 43834339bb43..980a936ce8d1 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2969,11 +2969,12 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   		strcpy(prom_name, "SUNW,hme");
>   #endif
>   
> -	err = -ENODEV;
> +	err = pci_enable_device(pdev);
>   
> -	if (pci_enable_device(pdev))
> +	if (err)
>   		goto err_out;
>   	pci_set_master(pdev);
> +	err = -ENODEV;
>   	if (!strcmp(prom_name, "SUNW,qfe") || !strcmp(prom_name, "qfe")) {
>   		qp = quattro_pci_find(pdev);
> 

This is incrementally better, but there are several more calls like this. A follow
up converting those as well would be good.

Reviewed-by: Sean Anderson <seanga2@gmail.com>
