Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BE5BB73D
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 10:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiIQI3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 04:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIQI3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 04:29:53 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC271DA76
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 01:29:52 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id m3so14737685eda.12
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 01:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=vqIwZcKbluvTMAjTQnpYPyZCNj+oMkHihHLd47ipyyI=;
        b=Ef7g1m4+vE1Dt7lR3DUQwBwTEgs0WbZr/amckJGN+EOQd+CrTqhZbebMrT+mSohUrD
         F9LVB8+udY3wh9btWp80YNqBtZNKoIkFqhBoIM3NiC0bihx9q3PrEs27bwFPTXVpLW4O
         ZfBNtA6iycztalaD13pWRObb3AQH9z7ug7JpOK1v3yX58zWvDsio/N6vqd4Z0tlg7m1C
         VvcApICnw8fTjarDEIBhI4OGDuoriLh5yoBESYfssj6qjtNL4nN2bYpk7G/OekMyYMEH
         I4OoubY0L+6CHIiOsc0Hth49BPelD+nXWiKJiQZiZxnmG26coMzQcEINy5enuCP3Vv8q
         uzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=vqIwZcKbluvTMAjTQnpYPyZCNj+oMkHihHLd47ipyyI=;
        b=HyEZiEJsNa9riUKS/Gmq2/yNZCy2G7BVxV2pma3ZSF9mf0sQvvluTb+hUXWO5i/rc3
         vcmJAn+GqoS4OHiv8AWBFPUB6CXnNXeqGnkEo1/MQxATqsR7865PJrQ+TZRCL0WeiHep
         OZrSg7U7mD/lt87oBhlcWgK46bOdIivOIXHX8gmwzgI30jB3AgH7GghEHb6ZfYlHh6qm
         uQbMz47NjHWs53bYIK+h/qg1MVlq4/O5XKfUtZKRXhpWYS2wZ9AhrDFOAzgqPO7iQHUE
         YMnCQd85EtplAtTYoHV1lHzA67NO04YSooBQu/sUwDA/1wPbxhHnQikLGvJ6pOIoaN0z
         X8tQ==
X-Gm-Message-State: ACrzQf3RQlBrkrzH/0egeHsgGfIgKHEUoF/kTR+AZGncZ8H9rqjPxCWw
        gJgoJhMzPQFK/ywu/krcEH6Tvg==
X-Google-Smtp-Source: AMsMyM7EyMFffzy6qRli3UphFPopTqdnqcsuJ37K7YpUjlhPvPRqxoGcjDhC8EKCmvi5oXl8pEx1Pw==
X-Received: by 2002:aa7:c0c5:0:b0:453:9a23:a0cd with SMTP id j5-20020aa7c0c5000000b004539a23a0cdmr1725459edp.286.1663403390628;
        Sat, 17 Sep 2022 01:29:50 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id v23-20020aa7cd57000000b0044e796598bdsm15260506edw.11.2022.09.17.01.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 01:29:50 -0700 (PDT)
Message-ID: <9974177e-7067-aacd-1c53-7e82616f3c3f@blackwall.org>
Date:   Sat, 17 Sep 2022 11:29:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v1] net/ipv4/nexthop: check the return value of
 nexthop_find_by_id()
To:     Li Zhong <floridsleeves@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20220917023020.3845137-1-floridsleeves@gmail.com>
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220917023020.3845137-1-floridsleeves@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2022 05:30, Li Zhong wrote:
> Check the return value of nexthop_find_by_id(), which could be NULL on
> when not found. So we check to avoid null pointer dereference.
> 
> Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> ---
>  net/ipv4/nexthop.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index 853a75a8fbaf..9f91bb78eed5 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -2445,6 +2445,10 @@ static struct nexthop *nexthop_create_group(struct net *net,
>  		struct nh_info *nhi;
>  
>  		nhe = nexthop_find_by_id(net, entry[i].id);
> +		if (!nhe) {
> +			err = -EINVAL;
> +			goto out_no_nh;
> +		}
>  		if (!nexthop_get(nhe)) {
>  			err = -ENOENT;
>  			goto out_no_nh;

These are validated in nh_check_attr_group() and should exist at this point.
Since remove_nexthop() should run under rtnl I don't see a way for a nexthop
to disappear after nh_check_attr_group() and before nexthop_create_group().

Did you notice a problem or have a stack dump?

