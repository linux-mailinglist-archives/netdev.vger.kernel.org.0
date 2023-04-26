Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D603D6EF64F
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbjDZOW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241036AbjDZOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:22:57 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107CA6E87
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:22:45 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-187de655f15so2897115fac.3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682518964; x=1685110964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X8mpcczn4jpnrKTjlU8EsDGeonMOgq2K3x/HxqEapbM=;
        b=ChIqTOZIRESw/L+32noHs54fFStD6xcbXzq89+I/cRu6Q3sWsTMsxqeVJZ+mb3MeYJ
         rGQK3m8gCtFs3FG9/Hh1qEmiqwNzj/3yM+Hw8kQBXhS508RsiPxwKDwAgtqclQAQ6MCS
         CTpAFXid7ECAqOzRoVyA0qbYsD8zna6Nundos115NL/PLzEK2ejwPexUlKgAKIfevhSM
         Ll1aLuRGVE5OyJ9pNbr5egxV5eaT98lSDk7uZotdhpn6PijcyyKCh9FUKn6UI2jJV21F
         M5tqBi3VTLqfaNETCZheZFlYpUTXGz2760ZXqVEggJ4YqE1YHA7nQ5azZM7oe7fcNlpG
         KH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682518964; x=1685110964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X8mpcczn4jpnrKTjlU8EsDGeonMOgq2K3x/HxqEapbM=;
        b=atCEAMf+kWW9840fIYfkrWMetGzmh5aLUYGmmddimI8z0HSVB7gUuf5FZzOuJHOA7D
         47l7i1CDA4jNZ5rFHN9x/Jt/KIbWz6eMc03ToBcRH1DExeLzXYOgBLotQLF+dsTA8VPw
         aiHJJEKAXVa+M74wR7gutQUj9RHhl4i1KdvsSxPvzncpTqfK2kc9HkKDl8II2QWdcCeH
         IF+Kjcqzqw8taXtbgweRU4wx7BcKUaRxAP2fgNl+vLszi6/cKvWxQ6gHNS3906ukiCmx
         jjmhPKQ5ARFiuFqDEmZzLrOmcqdjn+gU62/XLXIEYS/33FWM8yCNxHu68LBQzaE/8vcn
         Iv1g==
X-Gm-Message-State: AAQBX9fzR4Opkkh4BcIeo3WFW2zfPVB2zUr4slDkVtyPx3lwDYNCJ8Mi
        JwYPM0x6hV8yVbyF0Z9kPlTqEw==
X-Google-Smtp-Source: AKy350bTRFDT/yr0HDg8Pg/v0pBkEDsDzYqSX49GDUokwweiowQU9zdLDfZrBztRIkAKgAugwsXfrw==
X-Received: by 2002:a05:6870:d14a:b0:18e:2e28:d3aa with SMTP id f10-20020a056870d14a00b0018e2e28d3aamr11746358oac.31.1682518964383;
        Wed, 26 Apr 2023 07:22:44 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:fb2a:b3eb:47f1:343a? ([2804:14d:5c5e:44fb:fb2a:b3eb:47f1:343a])
        by smtp.gmail.com with ESMTPSA id h7-20020a9d6a47000000b0069f1774cde8sm5166792otn.71.2023.04.26.07.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 07:22:43 -0700 (PDT)
Message-ID: <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
Date:   Wed, 26 Apr 2023 11:22:39 -0300
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

Actually this seems to be fixing the same issue:
https://lore.kernel.org/all/20230425140604.169881-1-ivecera@redhat.com/
