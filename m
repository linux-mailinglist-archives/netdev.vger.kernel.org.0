Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324D23A3A52
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 05:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhFKDkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 23:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhFKDkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 23:40:00 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26FAC061574;
        Thu, 10 Jun 2021 20:37:47 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so1839903oth.8;
        Thu, 10 Jun 2021 20:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=AT7HtHsR7rvrJu0g37QevlV7wDbuUynMriYES38+TFg=;
        b=p4RcckhKlpErhhj9nh6wB7VmbrJBHkCuOMX4QFEORPwtqGetvllOkvUdiypud/vRdP
         6bodSoVssuAx4a0GWp+a2YHiTRvrJ3PuaNtUxcrI4ji3BLfZEEupT0RyQ4ZH8x1ZoDhH
         NLvjV+G6upvzHS9TVgaNWms2GLl23QsTjnQ4NvIxXvrCXsoCffoWsEpoyQujU4ApRaNu
         5drgQzFG64jL/0wS5muQC5XMVQxWOlQSPq0+MMcsbEJzwkGtIWxWs/83REa3rGZVaWiy
         UqkBY9rHfVgJH0cDK1a+Gk3dUOIMQlkFYeXWu/37lKrqw8QdVG0VdllPdQeeIQA78k6t
         2vxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AT7HtHsR7rvrJu0g37QevlV7wDbuUynMriYES38+TFg=;
        b=d+I/D8+HfHCmiCVwui+uruAuK/v8j0lLAeFFfJdTQFkzGr+U12DHpOBIZl1LKt4ZNT
         b8khu4cpH+kCACDllquFu4qY7aa1PmEz7CrhoSPCE59vq6S+ocH4ATd6GfVNi627dqEr
         M5kT95tnI0Sas4TU+MSlja6XBkuo6V/oMqp54KjLA+B0so4oMpEEPEHFAHwPAnguh1W+
         lBBXgWnYl4+9Bp5cUp9768EUOeLYo7okBKLdGC3d7Fcw5Rq9mY7k5lfdYc2SV290g8iV
         9jRh8s2bozjQ+e9rgMzzZOItGnAwz6IdB7uTVwzTEO+5hYA7+q1jRjjr1VEUugSJjSd9
         rGpg==
X-Gm-Message-State: AOAM533SDtJeRjTkTMzAnXru5VdA2zS5ahxuQTb5Nlsr78Hom3BlQvsY
        3q5hgzPKZoxb7omwKLnpsNC2PeJPTng=
X-Google-Smtp-Source: ABdhPJzD5szo9CFT0YIFhD7qR2316nQyATkrdbkRtDhaXNX7lbRPW6xuX1uxs95GhDIXiLBD6payag==
X-Received: by 2002:a9d:58c2:: with SMTP id s2mr1235956oth.80.1623382667020;
        Thu, 10 Jun 2021 20:37:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id t39sm935094ooi.42.2021.06.10.20.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 20:37:46 -0700 (PDT)
Subject: Re: [PATCH v5] ping: Check return value of function
 'ping_queue_rcv_skb'
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210610014136.3685188-1-zhengyongjun3@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ceb72a32-e55b-febe-0331-79a7cf6e7d66@gmail.com>
Date:   Thu, 10 Jun 2021 21:37:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610014136.3685188-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/9/21 7:41 PM, Zheng Yongjun wrote:
> Function 'ping_queue_rcv_skb' not always return success, which will
> also return fail. If not check the wrong return value of it, lead to function
> `ping_rcv` return success.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
> v2:
> - use rc as return value to make code look cleaner
> v3:
> - delete unnecessary braces {}
> v4:
> - put variable 'rc' declaration at the beginning of function
> v5:
> - don/t print unneed debuginfo in the right path
>  net/ipv4/ping.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
