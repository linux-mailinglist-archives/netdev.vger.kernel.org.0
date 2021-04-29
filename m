Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E017736E323
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 04:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhD2CEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 22:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhD2CEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 22:04:14 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846AEC06138B;
        Wed, 28 Apr 2021 19:03:27 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id x54-20020a05683040b6b02902a527443e2fso9054140ott.1;
        Wed, 28 Apr 2021 19:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+BkPf6ouH7ZXKDiYFqOTfX8y6jRjgrxp2WW9zPHG2zM=;
        b=bkM3ihNeJ0HW0mwEhAryX/7RY+zSFEiCvJZ+gRl5PCNaIWoBzeHbMJhZiX2JleCqFx
         HLNTKqeM8OY8uIxF8eC8DT7mVkA1iUEaNmHvfekXAfP17uNorz2h/jIY7Gu+LX4/Y2sl
         z3n7dwLFasEJJCChT8MptcwyeFTF/Yxw3X0vJ3SoRiFGI6oNZA/4GuLwz7YvCNoOqC3t
         Oi1fe+2Bqa2kHo8xEJjBuisMEFZJfLfSjPyt4JaoCymoVOjNmpSIlIUmR739KLfHNGmg
         dZ2RYKJ7OCK8mcRsu5D48S2iI2L+ZoNxyfFObXATtJUEr13ucFaPxfZtH9kit5zH/1Xw
         UEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BkPf6ouH7ZXKDiYFqOTfX8y6jRjgrxp2WW9zPHG2zM=;
        b=A+rncepdDwUWBm+21B6mhL44pFyT84qxhYCN5+ag6y9ruETwmBz8VgI3XhoBleNEye
         DL0cK2l90XcXZfFIPfobgq3wje9X+tWBBco7xKtwNpP4/o8ndNGVJxCVlKJgfZ8V8TGV
         l8rKhWzNyeXdliO3HzJTLbFqsoz4u2k5LieoqmtQePI6NPurC21KUN6feX2h7uH8c972
         C1Ya/OXfaZKNXVZes1JlwVLzprmwAT04IKfiX0MHBg9EJweSzGxGHnfuA3Y/4qGaAlx6
         3/yPdd0j3ZyiRun/MaJ0R3aOCZdmH/J1cMg3PGw2oc9gXZJ+kGM/7+Zl2rDd+X/QIahn
         Zsrw==
X-Gm-Message-State: AOAM533wcSkeERZLXJyvp6JsYsNVmgLtPCeHiJmRMX106ecrJBEXk+Vl
        HxsCF6i4B7zgyvNC1WxNcB8=
X-Google-Smtp-Source: ABdhPJzIh5K3WybsuN2qQVsgk+GkFZwEBCxYE8vSJTtctdFBN25tv3nh4KCPzFxiPnOSASwlBkjY9g==
X-Received: by 2002:a9d:6a88:: with SMTP id l8mr16463342otq.236.1619661806887;
        Wed, 28 Apr 2021 19:03:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id f20sm413214oov.21.2021.04.28.19.03.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 19:03:26 -0700 (PDT)
Subject: Re: [net-next] seg6: add counters support for SRv6 Behaviors
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210427154404.20546-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a49ed340-3f92-8533-3efb-ac7ee2231ca3@gmail.com>
Date:   Wed, 28 Apr 2021 20:03:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210427154404.20546-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/21 9:44 AM, Andrea Mayer wrote:
> This patch provides counters for SRv6 Behaviors as defined in [1],
> section 6. For each SRv6 Behavior instance, counters defined in [1] are:
> 
>  - the total number of packets that have been correctly processed;
>  - the total amount of traffic in bytes of all packets that have been
>    correctly processed;
> 

...

> 
> Results of tests are shown in the following table:
> 
> Scenario (1): average 1504764,81 pps (~1504,76 kpps); std. dev 3956,82 pps
> Scenario (2): average 1501469,78 pps (~1501,47 kpps); std. dev 2979,85 pps
> Scenario (3): average 1501315,13 pps (~1501,32 kpps); std. dev 2956,00 pps
> 
> As can be observed, throughputs achieved in scenarios (2),(3) did not
> suffer any observable degradation compared to scenario (1).
> 
> Thanks to Jakub Kicinski and David Ahern for their valuable suggestions
> and comments provided during the discussion of the proposed RFCs.
> 
> [2] https://www.cloudlab.us
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  30 +++++
>  net/ipv6/seg6_local.c           | 198 +++++++++++++++++++++++++++++++-
>  2 files changed, 226 insertions(+), 2 deletions(-)

Thanks for the detailed commit message and stats on performance impact.

> @@ -977,7 +1044,14 @@ static int seg6_local_input(struct sk_buff *skb)
>  	slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
>  	desc = slwt->desc;
>  
> -	return desc->input(skb, slwt);
> +	rc = desc->input(skb, slwt);
> +
> +	if (!seg6_lwtunnel_counters_enabled(slwt))
> +		return rc;
> +
> +	seg6_local_update_counters(slwt, len, rc);
> +
> +	return rc;

Nit: This would be simpler as

	if (seg6_lwtunnel_counters_enabled(slwt))
		seg6_local_update_counters(slwt, len, rc);

	return rc;

but not worth a re-do since net-next is about to close, so:

Reviewed-by: David Ahern <dsahern@kernel.org>

