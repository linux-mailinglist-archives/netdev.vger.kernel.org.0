Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188786EF5FF
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240793AbjDZOGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjDZOGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:06:42 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6D7659C
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:06:41 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6a438f0d9c9so5448257a34.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682518001; x=1685110001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H5KhvYnmBVoQjjNfAqtoIrjmE3iR+zLGLX/nl2fjNmI=;
        b=Ncdb/jx6votSdiqxb1g080ddt1l3g3qFFIkhipQtnhSAmcpV8iiq5XDBJ1x8Ox2kYD
         QdQDE6QYaht49bNeumNobT+yUxy4rDtL6ISyR4z88n9DG5BR8M3QAvHpHFn8w7OaSUAB
         iQ8sCPGuHb1JsA87dbPpM5/RL2rgGGufnogBf4awEGEu/WEReYfoncOaRi8ey9kTmyVP
         pl+cqJWsWlnugCWCyGaH5opLiUXbfEkdJ/MRMbPpArzTfUT3nHbFgcDeOMUCqkaM7YWz
         DqwK+9+sOESnndEWcmzfN6FNRM7xKczYO3ioblzP35l3upXX2gcyIxuS7X2K/YTQni75
         hUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682518001; x=1685110001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H5KhvYnmBVoQjjNfAqtoIrjmE3iR+zLGLX/nl2fjNmI=;
        b=PycxigxeCDAZbrt57V24pw3Aj8hcDphUq83wYQiTkmQ4LWrkBbqYfyKUG2tXxXRzgv
         4iOAaYvej7yZ+RLeL9RJWgmL9jJUQQNvGuMy6ca9BsqXJQxQjfS+TEkbt3hdF5H2EW8I
         LxxGlHETWbrcEkouXWEeZ5ZvXpyzCt4LosFz6wU+G0fQ0O/vkUrcOlNha3lEGSg2I6rc
         qglLNjlO+03MGt5KFeqBULOLLgpuPokmohBEVIdEQ5bsoOW+Gx/GOwh6L/4fxWyhN5px
         jHIPovI7NzElt8mCrjrZ8aGph+Jvugi1+Gmskt+ZugGCZ0XG9S8sGACauNNBjJ920YTW
         h7Ww==
X-Gm-Message-State: AAQBX9eB0CAFonh67UqSAucIwZ0nz2D86HtBc5kei/vOCibDNN6X73Lk
        9bLhDpTbZtR14kYoGK8yKPeVpA==
X-Google-Smtp-Source: AKy350ZOdlmoESOwY4kEQdzqATaKLDt0VT4QKxH34EB/lDlj6upcVdNUro7Bm2gwPHge9+AnKqAZmA==
X-Received: by 2002:a9d:6651:0:b0:6a4:4252:47aa with SMTP id q17-20020a9d6651000000b006a4425247aamr9805305otm.21.1682518001173;
        Wed, 26 Apr 2023 07:06:41 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:8626:e4ab:d4a8:f0f? ([2804:14d:5c5e:44fb:8626:e4ab:d4a8:f0f])
        by smtp.gmail.com with ESMTPSA id b6-20020a056830104600b0068bd922a244sm6972171otp.20.2023.04.26.07.06.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 07:06:40 -0700 (PDT)
Message-ID: <aa6cb27e-d9ab-5371-a545-dc2fb45ed992@mojatatu.com>
Date:   Wed, 26 Apr 2023 11:06:35 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Content-Language: en-US
To:     Vlad Buslov <vladbu@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcelo.leitner@gmail.com, paulb@nvidia.com,
        simon.horman@corigine.com
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20230426121415.2149732-3-vladbu@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/04/2023 09:14, Vlad Buslov wrote:
> When replacing a filter (i.e. 'fold' pointer is not NULL) the insertion of
> new filter to idr is postponed until later in code since handle is already
> provided by the user. However, the error handling code in fl_change()
> always assumes that the new filter had been inserted into idr. If error
> handler is reached when replacing existing filter it may remove it from idr
> therefore making it unreachable for delete or dump afterwards. Fix the
> issue by verifying that 'fold' argument wasn't provided by caller before
> calling idr_remove().
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>

LGTM

Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
>   net/sched/cls_flower.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 1844545bef37..a1c4ee2e0be2 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2339,7 +2339,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>   errout_mask:
>   	fl_mask_put(head, fnew->mask);
>   errout_idr:
> -	idr_remove(&head->handle_idr, fnew->handle);
> +	if (!fold)
> +		idr_remove(&head->handle_idr, fnew->handle);
>   	__fl_put(fnew);
>   errout_tb:
>   	kfree(tb);


