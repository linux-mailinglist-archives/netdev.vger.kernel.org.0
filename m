Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8526105ADA
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKUULp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:11:45 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33664 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfKUULp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:11:45 -0500
Received: by mail-qk1-f193.google.com with SMTP id 71so4279227qkl.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 12:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U+o+hsiKSsZCbg7bMX0pDFc7T8+SR9cxrUFACjFkFvY=;
        b=FWfyYJz8EphpOuZoYcdO5SukxUkEyZKe4dbRAv3QUu0R38VVqRPFHR40X4hWjZXGW/
         mRV+cxZ16EJCD35BiPZVZXBnt3XD0G6lqo98/5VI2AM56Mq8CcMYr4+WHzSJwdgvJEXM
         7ODDrsdvpsmfrcn8YYOCanECaz5osyYIfzFYVeOWi1SzaxLoTByMYF5G8zLuIVv574TE
         8CW9zMdWxDK1mih+lehfjNzWe5i83h2TMtwSuD/AEVgQLnBFgKJt+j9d9msKHYfhanon
         Bjg0LNebqOAc9AMY6unBAg1pzo/lloDsgGU1jchc3nJ8gCzl9cKpc2wZ5ZxzGod3SBlK
         Rt6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U+o+hsiKSsZCbg7bMX0pDFc7T8+SR9cxrUFACjFkFvY=;
        b=OB6JRjr/MjObi0l9kf4uBeifueW7bXG7TV5VUYjz/799/lAGeL0t8dlKiBdXqdXIPk
         ERGpymfC+ZKfHNGLi9xBTgWm98qpXRo0GQqrfL9yltNSEk/jXxU+OWUkKIXMUjMnPUEZ
         8qSoAErfXqYol7y/FLR2bkOVstO7+XHRJg4LPI0+TPv7gMy8eI0Xr1nWpI4wx658GVSI
         s74h/tfGNtvRBf7wdIjdA1+VvV3dF24BxjGeU7gcmUYFc7dtEuLlfsjAL4Wv3089k2Od
         5M5zhI4+MYfqjr6wFF+3DPRrbtGVCxq4vsJFHHvzTZ8abTOfZUr9X4CJfyn/zS0RMeXL
         GEoA==
X-Gm-Message-State: APjAAAXj5lUR/JR8VFWd3yD/L8v320K6qzcIPLYg38fjnG3YSQP1q+dj
        ysICMKq2VeI2LHHUF1ByFbKR5gbu
X-Google-Smtp-Source: APXvYqxwfz05gzsnOFAKnhVqpIWR20nrsllp39Y1nixX0ygFBUUMKxp+XUiFAf0DKQnUj0JQDjfPUg==
X-Received: by 2002:a37:4f10:: with SMTP id d16mr9814230qkb.80.1574367103951;
        Thu, 21 Nov 2019 12:11:43 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id d145sm1865957qkc.120.2019.11.21.12.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 12:11:43 -0800 (PST)
Subject: Re: [PATCH net-next v4 3/5] ipv6: introduce and uses route look hints
 for list input.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1574252982.git.pabeni@redhat.com>
 <af831ed39b697b86cd380d67b976438156d04da2.1574252982.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9efbe588-6fe9-fd9e-cd37-1779cfd00343@gmail.com>
Date:   Thu, 21 Nov 2019 13:11:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <af831ed39b697b86cd380d67b976438156d04da2.1574252982.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:47 AM, Paolo Abeni wrote:
> When doing RX batch packet processing, we currently always repeat
> the route lookup for each ingress packet. When no custom rules are
> in place, and there aren't routes depending on source addresses,
> we know that packets with the same destination address will use
> the same dst.
> 
> This change tries to avoid per packet route lookup caching
> the destination address of the latest successful lookup, and
> reusing it for the next packet when the above conditions are
> in place. Ingress traffic for most servers should fit.
> 
> The measured performance delta under UDP flood vs a recvmmsg
> receiver is as follow:
> 
> vanilla		patched		delta
> Kpps		Kpps		%
> 1431		1674		+17
> 
> In the worst-case scenario - each packet has a different
> destination address - the performance delta is within noise
> range.
> 
...

> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv6/ip6_input.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)

Reviewed-by: David Ahern <dsahern@gmail.com>
