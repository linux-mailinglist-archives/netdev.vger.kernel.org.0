Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36A15FC8B8
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 17:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiJLPwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 11:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJLPwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 11:52:09 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62144F2520;
        Wed, 12 Oct 2022 08:52:03 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a5so5680490qkl.6;
        Wed, 12 Oct 2022 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cCvqeLf3ZV6pySPAQmlmFI1gb6Z0Oqu0IwzbIvFJXOs=;
        b=Wi94i1FaQ6yT28Hz9NIlUS2Qy2Hv4lUdEiAmQghGtGHfgTtkIufcBnzCRl5P7GPmlW
         aREjMHguEleNyrJiix3w25TmU5AQv1180Hb96Q5gVa5WglhXnw7ydmrVlV01axywwHRq
         OUSCi30aq3eJTDjRa8lkEune/QZxTawqJiOsRN0XS+tFJK6QZhZD5uLPMfgbVW40PvuQ
         H05ohIofLFYqjaox0xiWXOp4OGN63OwaP6ZtDmPLAFVftYGiKGEo2bnhXjLMjPDOswdc
         BD+YpLByDiH3+WEpROZPZsYGjpvt1l/lTZJVSmuw9gHQHBbdTOUjwnerbgW6hS2Nh6IQ
         c09g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cCvqeLf3ZV6pySPAQmlmFI1gb6Z0Oqu0IwzbIvFJXOs=;
        b=3uPf5sVATgG0TL6JQa6pwycUotswtEod2XgreslSDvp3S3OBbGnJaJj2PPkfqeXpq/
         LazeWxqoVDH9NojM/nvDkqyTeYShEubGX7lylbtlIP/f/3GPDVtw7bmO1nhzv2T2xlq/
         50Xc7VqPJh07PZYH3GDMXHxQJjzs+be2tjt+J3IHH8jbDX52cBzdoUa5Gp6UoDYCKDh+
         Q1jL814poTEx6kApmKFCARnpC5ihdvnvj5VwVapFK6oTv341Px7mpP3VSNA3K/2KCgBP
         aObONtmFLT/xndFJhX6FM6fBer2E7t13SEu9TsqHIWJ9Wk3GglLKDWyMdwje3xxUMEuk
         u2eg==
X-Gm-Message-State: ACrzQf33pW/Bb91NuIZ9jP9GqXiC6c6xugSMA0b2HElEPjoZXw30KeE/
        /RJr6gIgsvRogzJdFn4YI+0=
X-Google-Smtp-Source: AMsMyM7LtO48HZ5f2sR1NieF9+RmAyNc0iOtdYp1GqKzYWVUCGe/jb51+hIXoo3OsLPuNINYTUOI5A==
X-Received: by 2002:a05:620a:2218:b0:6ee:1e01:b189 with SMTP id m24-20020a05620a221800b006ee1e01b189mr8908158qkh.478.1665589922344;
        Wed, 12 Oct 2022 08:52:02 -0700 (PDT)
Received: from [192.168.1.201] (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with ESMTPSA id h15-20020a05620a400f00b006a6ebde4799sm16543987qko.90.2022.10.12.08.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 08:52:01 -0700 (PDT)
Message-ID: <b4a07016-081b-13b0-2cc4-546f419ad59b@gmail.com>
Date:   Wed, 12 Oct 2022 11:52:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] sunhme: fix an IS_ERR() vs NULL check in probe
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Y0bWzJL8JknX8MUf@kili>
From:   Sean Anderson <seanga2@gmail.com>
In-Reply-To: <Y0bWzJL8JknX8MUf@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/22 11:01, Dan Carpenter wrote:
> The devm_request_region() function does not return error pointers, it
> returns NULL on error.
> 
> Fixes: 914d9b2711dd ("sunhme: switch to devres")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/net/ethernet/sun/sunhme.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 62deed210a95..91f10f746dff 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -2896,8 +2896,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
>   
>   	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
>   					pci_resource_len(pdev, 0), DRV_NAME);
> -	if (IS_ERR(hpreg_res)) {
> -		err = PTR_ERR(hpreg_res);
> +	if (!hpreg_res) {
> +		err = -EBUSY;
>   		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
>   		goto err_out_clear_quattro;
>   	}

Reviewed-by: Sean Anderson <seanga2@gmail.com>
