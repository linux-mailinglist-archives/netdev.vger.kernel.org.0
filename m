Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15003CC9BE
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhGRPZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 11:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhGRPZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 11:25:32 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935B7C061762;
        Sun, 18 Jul 2021 08:22:34 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id e11so14620912oii.9;
        Sun, 18 Jul 2021 08:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o57yGjRTaWAqfZDrSBIZV03JfvmeovTUKB74MRJQo7I=;
        b=aD/PXWd4ypap/fpxUpC1rd8Db++f1jJkZ7KLxTrSacfphOfX//0htFXUg8z6nGHSwi
         +uej3OyLGojjfNy9wcZIpH0W+eKw/oGvRCnUlVoZ7GxgLn6Zx/QdaXXKz+hRQNXn7Hbb
         E22AtiXA+36pBQ2vQqkS5t5QvcBfdqT0a003yx8sGaaYkltvcaVMBaESlRt0aUL9HAOM
         QajEqpBSEcPCwWrn1fVC6gRReO3nofFbXLGxtO5YC2lBifSvaasA3+Ez4mYqNX2eeQZk
         +DeHvCqwylBzGGldXZyG5lrHY7fZ9q9pHZob7zfl2uODgehTczjD8z5vIaLDNAukiQL9
         tW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o57yGjRTaWAqfZDrSBIZV03JfvmeovTUKB74MRJQo7I=;
        b=XyfhIMJezfap3iuNhFky62RgK7simuNGC0ePAA5CEpYIlSM+V7BPwqlQo2TkBRZtxc
         ZOVGzricKtmPwwhgsdmZUWD7qszxQLW98XJBbUOXy4bi2hBXfQr6r14UvrN9i6/wCd9+
         0zyoqdyC3ZuAFr5sVvypA/s+WdpixSAOJRpHaAPqX2q173yka9e5VYwsKFFuYlIiQ299
         Kue1yUnLMbGG5wVssIgX2dkpvwMVQ/QvrNNArK7MastFdSLPCR/p+i523gWOZXu/zqcP
         Ht21WXu7NNcnkgQzR7H0NJai6LobYJ7ewad3MzMhxtmZz0eYr6l1ereg57569NRaikeU
         GSVQ==
X-Gm-Message-State: AOAM530KIFKwfQ3ZhFSk5cDe6bjBXAhhQBZe9X/+BHQssGkhxCHMvvYQ
        dfcwkJ0RwqsMjQI4FOa/WzI=
X-Google-Smtp-Source: ABdhPJzhVJmtPkRtvs+XzqfN5EEIqgaZQfPEG9XLzalSTVmCFYfscFcPsxkSalwJ7yN1lS0oBMS0BQ==
X-Received: by 2002:aca:ac15:: with SMTP id v21mr18638255oie.5.1626621753935;
        Sun, 18 Jul 2021 08:22:33 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id j30sm3135190otc.43.2021.07.18.08.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 08:22:33 -0700 (PDT)
Subject: Re: [PATCH NET v4 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <e44bfeb9-5a5a-9f44-12bd-ec3d61eb3a14@virtuozzo.com>
 <cover.1626177047.git.vvs@virtuozzo.com>
 <dc51dab2-8434-9f88-d6cd-4e6754383413@virtuozzo.com>
 <922a110c-4d20-a1e9-8560-8836d4ddbba1@virtuozzo.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <628b7b2b-494a-07f5-5d74-1867ec351b7b@gmail.com>
Date:   Sun, 18 Jul 2021 09:22:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <922a110c-4d20-a1e9-8560-8836d4ddbba1@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/21 4:44 AM, Vasily Averin wrote:
> I've found that you have added v3 version of this patch into netdev-net git.
> This version had one mistake: skb_set_owner_w() should set sk not to old skb byt to new nskb.
> I've fixed it in v4 version.
> 
> Could you please drop bad v3 version and pick up fixed one ?
> Should I perhaps submit separate fixup instead?

Patches are not dropped once pushed; send the diff between v3 and v4
with a Fixes tag.
