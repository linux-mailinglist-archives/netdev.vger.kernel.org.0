Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB4F42C4B1F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgKYWyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbgKYWx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 17:53:59 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807C7C0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 14:53:59 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id o8so3789198ioh.0
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 14:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oVUnr7E2mvu+n0bKwmlxscbZJeF25SzxpVY68WfFlcQ=;
        b=bje2ArzppJri6mdXBPneJf1469GdCaFzhxFfJZIT4WPKrO8dOeqPoamc4P0pxtM1+z
         NE+VkKIYeCv5/gJscx7gO10YjKUxhtbjQepWUwdXCMCJPF3xZGp6aBxs+xjHenlPoYGi
         IK1MfuPG7aFqoPgMexIgh+TekiOHUO7DHcgSwhZ7ZOlS5PN3YAzNKiN1HJR8SWThB4rC
         w4WVZcbgYl949t7NZD7ZhV/OE3hJaRD/Iyjtxi4Gv+ZtB+JZKn3Orib/ykVvb9657imt
         Y2EwM8ZbqrzP6z8XW/0oELlTn+38nFh6vIjn2SPucneEmwPWBarOcQdW8p7jksrHmbFB
         qWGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oVUnr7E2mvu+n0bKwmlxscbZJeF25SzxpVY68WfFlcQ=;
        b=GPxvWhm68Lup1YOtox5K4vd5mxOAIFmuKFTd9x3bPQ513uNvpJhWkijEFP5ru3Rn0G
         iH4rn1mXTYPQvgzXF63d7AkRFGWZObeYGSCiknS4aFKDl32Fhp6+S7e3g+y+ebhCIGpn
         e4GBBurhuaFJAEhNSvmMt9Pry7NehyFmvIK+lM7fq0xYFtA7JgS3hJuvTuPZYmCqmE2j
         WCvDD+VRnTLPYp00VW+IGtgvPw6kjVyhDHyPBrTuo4g3mA94czSwT27PMj/O3JHId/99
         h4eTGyrgZIux2yptvzf54cjdyKK1LGmwF/ds+KfJwvABO3qWT7Oqx0Q6iKemDvoZmCp/
         kBBw==
X-Gm-Message-State: AOAM531Ym5wWVpnRR4UDu/5KDT1Se8m4a3zHHIH5AXIwOd5u958Nqi34
        xt/u0DaTWYnUKbt/n4ecifs=
X-Google-Smtp-Source: ABdhPJyI++LmMjECPnTn/c5cRKUvCvXRoti35pRelkgzx5d6k1IM7qZbDFXoQ9xYiytPz8PU9pzhJQ==
X-Received: by 2002:a6b:760e:: with SMTP id g14mr130810iom.136.1606344838827;
        Wed, 25 Nov 2020 14:53:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:1c24:45b7:26d4:a203])
        by smtp.googlemail.com with ESMTPSA id m7sm1459231iow.46.2020.11.25.14.53.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 14:53:58 -0800 (PST)
Subject: Re: [PATCH net-next 0/5] mlxsw: Update adjacency index more
 efficiently
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20201125193505.1052466-1-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4c97e61a-6267-f4c1-5e82-f8b3f15252e7@gmail.com>
Date:   Wed, 25 Nov 2020 15:53:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125193505.1052466-1-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 12:35 PM, Ido Schimmel wrote:
> Example:
> 
> 8k IPv6 routes were added in an alternating manner to two VRFs. All the
> routes are using the same nexthop object ('nhid 1').
> 
> Before:
> 
> # perf stat -e devlink:devlink_hwmsg --filter='incoming==0' -- ip nexthop replace id 1 via 2001:db8:1::2 dev swp3
> 
>  Performance counter stats for 'ip nexthop replace id 1 via 2001:db8:1::2 dev swp3':
> 
>             16,385      devlink:devlink_hwmsg
> 
>        4.255933213 seconds time elapsed
> 
>        0.000000000 seconds user
>        0.666923000 seconds sys
> 
> Number of EMAD transactions corresponds to number of routes using the
> nexthop group.
> 
> After:
> 
> # perf stat -e devlink:devlink_hwmsg --filter='incoming==0' -- ip nexthop replace id 1 via 2001:db8:1::2 dev swp3
> 
>  Performance counter stats for 'ip nexthop replace id 1 via 2001:db8:1::2 dev swp3':
> 
>                  3      devlink:devlink_hwmsg
> 
>        0.077655094 seconds time elapsed
> 
>        0.000000000 seconds user
>        0.076698000 seconds sys
> 
> Number of EMAD transactions corresponds to number of VRFs / VRs.

wow, that is a huge difference - a good example of the efficiencies the
nexthop model allows.

