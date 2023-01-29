Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709286800DD
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 19:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjA2Sot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 13:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbjA2Sor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 13:44:47 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2397F1E1FE
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 10:44:46 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qw12so10316726ejc.2
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 10:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i4DbpifCqabRgCyCKd8UEM5w26sLROwDi22v6917074=;
        b=TEyhofPv/3fZEM5gSXQq3zJGsQqeL5iVEnb9IUXSl9sHFoeUNzf1trCcve0zg+JoAR
         Z0QHqwd8fPynZgr6nZAWUpJFJ3IoYrs6WG+JvCBNRZxExuXtoakkyP8FMvX0meJhkWQo
         7OSibO+xWr+pYYAv5hszN01KrH5uDAcq7UN9XlrWwHdDcTfLuUJExukgRVHOF/iE7R0G
         KTY88XS91OvXMY2ZD41fjSCHNkgEHQLlrIvKRSxMcuH9MN1aN9gULcasEj2yNaJ18C6Z
         XGMKEqylkFKgoU0KBYgvTeLl/PTZP1jqDusucxa7KS2zGHJK+tJpafQty9ou4gTStI/z
         YSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i4DbpifCqabRgCyCKd8UEM5w26sLROwDi22v6917074=;
        b=YUOdRtuyVXChOAZ4VdbPzHzmMX+HYTJ3k4sUZFJuiJG26UNY9GGeiGAmU4d8hDZKl/
         tTl4YWwzJu7WVyqwzCMsUT5igXkWJRYnrzbNKhzIineHO7iTKC8KMnrDhfy7iyfViMSK
         bbR6fUZJPbQSi0P1tPX4Jj48ao6w6lNy38SwpeLREs//IXHhCBL+liN7iyitG25vL+u9
         pusem7Cxkmkj8YoI6ZZIbIYJwgOedaEeFOIyLnT5eGgFnCbxZV9eVzqJ79+LHEYHuGNq
         6Y5e2so+8MNdm2JhAjg8BauwRqRMhC7Owjw+tuxjLoBPtBZMqAa9V+GKwlRvTzjGwK3A
         0dWQ==
X-Gm-Message-State: AFqh2kr7i1fXfmvUYI3tQROagYX9xtSAlT3/IRP/o+x7sPAlqDBzkXjB
        5Y1/3AytUl+PUeWaqi60A5kRBQ==
X-Google-Smtp-Source: AMrXdXuKMGClb4vuI98zxF7uhYaGzagu25lMseZ08PYThnSOqV0hNzzoGbwJXos8Ts9z63SdfMRpuA==
X-Received: by 2002:a17:907:7e9c:b0:86e:2c11:9bca with SMTP id qb28-20020a1709077e9c00b0086e2c119bcamr66832803ejc.30.1675017884598;
        Sun, 29 Jan 2023 10:44:44 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id e6-20020a1709061e8600b0085e0882cd02sm5734172ejj.92.2023.01.29.10.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 10:44:44 -0800 (PST)
Message-ID: <9b66580a-f158-43d0-36e1-511e6fe63da7@blackwall.org>
Date:   Sun, 29 Jan 2023 20:44:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next v2] netlink: provide an ability to set default
 extack message
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <c1a88f471a8aa6d780dde690e76b73ba15618b6d.1675010984.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/01/2023 18:51, Leon Romanovsky wrote:
> In netdev common pattern, extack pointer is forwarded to the drivers
> to be filled with error message. However, the caller can easily
> overwrite the filled message.
> 
> Instead of adding multiple "if (!extack->_msg)" checks before any
> NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> add new macro to common code.
> 
> [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Changelog:
> v2:
>  * Removed () brackets around msg to fix compilation error.
> v1: https://lore.kernel.org/all/d4843760219f20367c27472f084bd8aa729cf321.1674995155.git.leon@kernel.org
>  * Added special *_WEAK() macro instead of embedding same check in
>    NL_SET_ERR_MSG_MOD/NL_SET_ERR_MSG_FMT.
>  * Reuse same macro for XFRM code which triggered this patch.
> v0: https://lore.kernel.org/all/2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org
> ---
>  include/linux/netlink.h   | 10 ++++++++++
>  net/bridge/br_switchdev.c | 10 ++++------
>  net/dsa/master.c          |  4 +---
>  net/dsa/slave.c           |  4 +---
>  net/xfrm/xfrm_device.c    |  5 ++++-
>  5 files changed, 20 insertions(+), 13 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>


