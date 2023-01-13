Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A93669082
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjAMIS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240757AbjAMIRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:17:55 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B28F3AB3C;
        Fri, 13 Jan 2023 00:15:18 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so16799001wms.2;
        Fri, 13 Jan 2023 00:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lDH2r+aaMVDaTXe1cqxFgeM1gF0GH9kuOcqbkmIJc7g=;
        b=CO7lmyYPjib1vcKA4kDkfTCt6tAJQap9PeYr9Sepjp3b1cgq5d15zZGEVk9RIoJRUO
         2idOaK+2Ea/XCj2Zku0uZSGLlZItx3KVZPUSCaHFIdJI7djnUbsKcGsZK/BKLXqVHV/1
         XTXJ7KK0M041H8fT0+bj1QG1M1cnThB/Qy0Sy6l6Dq4x7aSRvZQ1xNn2R6xXjBUrAQyQ
         /Whk4pCa+zYztlX1ikcUUvQrhlzqeix6k409un8WAdcrHILvQNt7dbfFdcFpkY8zgdkX
         PF9Vnculzi95GIY1s6N826Ie6GnepwfIDGx29akm/e/oAYJtKY+EPEwMyPtioIQcFft9
         pUBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lDH2r+aaMVDaTXe1cqxFgeM1gF0GH9kuOcqbkmIJc7g=;
        b=k853k8WDS2b+2Jq5L/X49Em+dh8XB+Fd/iS3I0z8/A1sGeDyAmcgkX+0AjJKo9fvGV
         eYliw4nYGrnsXy8gzKnTtI94OiWqaNF+75a+SYqDPjFk9y+hcclcyfpKQ+hTaj/RwEIV
         mN+VA6M8xNcBskpm4eqkK3FR1TIMXrAIeI/BiWgyB8kCPMNl0fcKBpLKUkcZKJatFm8w
         2HAm1xuvVmsZ5edd1kClJgZAeuSkfVV+T3ifRHk3JmhdDaR9NPxSch4BUfuN2ChwYO0C
         YsdxW3+1WWNJ7/7dqVGPbf5J9fMWNd4Sa1o1c1CV5k6Apf3OI8WnKvy4BWcBnAUnXmvw
         /bnQ==
X-Gm-Message-State: AFqh2koVEUarGa2Z2nMhnJ4tbRu9FbyIWMzcGsG7gucL2l4K6+1pKYum
        CcihtWTGuWyjjlLr0k4et1Ty+CnbHd0=
X-Google-Smtp-Source: AMrXdXtNghofGnEbWo9JKqxJeXxWHJk4LRlHecbMzJteV00KOBfZi1377H8QiJ2JmuKainsvpXz9VQ==
X-Received: by 2002:a1c:4b04:0:b0:3c6:f0b8:74e6 with SMTP id y4-20020a1c4b04000000b003c6f0b874e6mr58720117wma.4.1673597716762;
        Fri, 13 Jan 2023 00:15:16 -0800 (PST)
Received: from [10.0.0.13] ([37.166.131.240])
        by smtp.gmail.com with ESMTPSA id n14-20020a05600c3b8e00b003b49bd61b19sm32553847wms.15.2023.01.13.00.15.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:15:16 -0800 (PST)
Message-ID: <b5ad26c3-fa10-b056-d79d-8bebb8795a90@gmail.com>
Date:   Fri, 13 Jan 2023 09:15:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] wifi: mac80211: fix memory leak in ieee80211_if_add()
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20221117064500.319983-1-shaozhengchao@huawei.com>
Content-Language: en-US
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20221117064500.319983-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/17/22 07:45, Zhengchao Shao wrote:
> When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
> isn't released. Fix it.
>
> Fixes: 5a490510ba5f ("mac80211: use per-CPU TX/RX statistics")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>   net/mac80211/iface.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index dd9ac1f7d2ea..46f08ec5ed76 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -2258,6 +2258,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
>   
>   		ret = cfg80211_register_netdevice(ndev);
>   		if (ret) {
> +			ieee80211_if_free(ndev);
>   			free_netdev(ndev);
>   			return ret;
>   		}


Note: I will send a revert of this buggy patch, this was adding a double 
free.



