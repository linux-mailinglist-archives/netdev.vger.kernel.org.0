Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19DF36BDB3
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 05:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhD0DWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 23:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhD0DWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 23:22:42 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4E1C061574;
        Mon, 26 Apr 2021 20:21:58 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id f75-20020a9d03d10000b0290280def9ab76so49015151otf.12;
        Mon, 26 Apr 2021 20:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2y1skpQm5O9nY3/sAmsR/w1AbZytq1gVeLlk4C9o/lk=;
        b=sBFtoSAUpLDJmX0PMdbcueyJLnj7Yd0LccPDGWnmTmDDIgiI4UGvR7xD+dgaoz+4a2
         VbarueU/Mx26TxFOi29+mkj9r4yDziOxr/Srf7g5w4rztQVjBzDCds50y3Iak2EcUJhu
         YcL+uS62BXr2Q8aUNAQIiYXYxeDAlXwZWmvZYBrVIfI0vj+JZ0vmzPRZMHz/HFVY1bGC
         pcwrQz/UdLLoS61hdA64/pGcGNs15FTeqQjqk+QCZWvEtJk4vmkeQ+WasQ/+WTZsvV5I
         a/KcNj+XZ/nw+BavnoBNvOQyXx5EYRvMhMFcuQSz3yKwu9p4vgheMljfe4+xcOB0yBij
         ZGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2y1skpQm5O9nY3/sAmsR/w1AbZytq1gVeLlk4C9o/lk=;
        b=H4MHcXMklok5rBbjEGLjqYFtCy7HRV1lTIeRd4U+hypXaAdkkDxSniPOaBJnyOcq5T
         rz/5vK86EmfQ65HPs2ELQ0js91EmZ15T+32vdcvjgvJOvfjsNzx25WnqJBnzWfqrJXfz
         swKgFr8FUXRPmYDkQ1NOFrDN3modsoK86CycxeadJ99ObZsmVBq8dUhUaTeuxsSuDDa5
         +xCqPIfIdPKgiggr1SqV7MKvVIDvJu+EmWYKLQA/irLdck4nzV8CmQAFSm3Re+Ov+Cf0
         PyKdyihMUsNegR2ZjQWklrXj9NeJanOVfnQmXkm2fN3ONaqID80jYQqEzRORy6Hq/M03
         T1jg==
X-Gm-Message-State: AOAM532pBdELgw0oXK14sIXvEVVWoKzXIlzKg77NQG7IkOQFzX295tHj
        IOhuG4l44SsRSeiNsqQYT2lMnGEo2Vo=
X-Google-Smtp-Source: ABdhPJz7lv4mElFZRkcyXxzJygI9MnlneCXXDmSUqufdUZy4R+6DR2GDIqlPOM9PKHJKVsvf32sAog==
X-Received: by 2002:a9d:6e8f:: with SMTP id a15mr11153409otr.169.1619493717525;
        Mon, 26 Apr 2021 20:21:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id 3sm427755ood.46.2021.04.26.20.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 20:21:56 -0700 (PDT)
Subject: Re: [PATCH v4 net-next] net: multipath routing: configurable seed
To:     Balaev Pavel <balaevpa@infotecs.ru>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>
References: <YILPPCyMjlnhPmEN@rnd>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <93ca6644-fc5a-0977-db7d-16779ebd320c@gmail.com>
Date:   Mon, 26 Apr 2021 21:21:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YILPPCyMjlnhPmEN@rnd>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/21 6:44 AM, Balaev Pavel wrote:
> Ability for a user to assign seed value to multipath route hashes.
> Now kernel uses random seed value to prevent hash-flooding DoS attacks;
> however, it disables some use cases, f.e:
> 
> +-------+        +------+        +--------+
> |       |-eth0---| FW0  |---eth0-|        |
> |       |        +------+        |        |
> |  GW0  |ECMP                ECMP|  GW1   |
> |       |        +------+        |        |
> |       |-eth1---| FW1  |---eth1-|        |
> +-------+        +------+        +--------+
> 
> In this use case, two ECMP routers balance traffic between two firewalls.
> If some flow transmits a response over a different channel than request,
> such flow will be dropped, because keep-state rules are created on
> the other firewall.
> 
> This patch adds sysctl variable: net.ipv4|ipv6.fib_multipath_hash_seed.
> User can set the same seed value on GW0 and GW1 for traffic to be
> mirror-balanced. By default, random value is used.
> 
> Signed-off-by: Balaev Pavel <balaevpa@infotecs.ru>
> ---
>  Documentation/networking/ip-sysctl.rst        |  14 +
>  include/net/flow_dissector.h                  |   4 +
>  include/net/netns/ipv4.h                      |   2 +
>  include/net/netns/ipv6.h                      |   3 +
>  net/core/flow_dissector.c                     |   9 +
>  net/ipv4/route.c                              |  10 +-
>  net/ipv4/sysctl_net_ipv4.c                    |  97 +++++
>  net/ipv6/route.c                              |  10 +-
>  net/ipv6/sysctl_net_ipv6.c                    |  96 +++++
>  .../testing/selftests/net/forwarding/Makefile |   1 +
>  tools/testing/selftests/net/forwarding/lib.sh |  41 +++
>  .../net/forwarding/router_mpath_seed.sh       | 347 ++++++++++++++++++
>  12 files changed, 632 insertions(+), 2 deletions(-)
>  create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_seed.sh

this really needs to be multiple patches. At a minimum 1 for ipv4, 1 for
ipv6 and 1 for the test script (thank you for adding that).

[ cc'ed Ido since most of the tests under
tools/testing/selftests/net/forwarding come from him and team ]

> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 9701906f6..d1a67e6fe 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -100,6 +100,20 @@ fib_multipath_hash_policy - INTEGER
>  	- 1 - Layer 4
>  	- 2 - Layer 3 or inner Layer 3 if present
>  
> +fib_multipath_hash_seed - STRING
> +	Controls seed value for multipath route hashes. By default
> +	random value is used. Only valid for kernels built with
> +	CONFIG_IP_ROUTE_MULTIPATH enabled.
> +
> +	Valid format: two hex values set off with comma or "random"
> +	keyword.
> +
> +	Example to generate the seed value::
> +
> +		RAND=$(openssl rand -hex 16) && echo "${RAND:0:16},${RAND:16:16}"
> +
> +	Default: "random"
> +
>  fib_sync_mem - UNSIGNED INTEGER
>  	Amount of dirty memory from fib entries that can be backlogged before
>  	synchronize_rcu is forced.
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index ffd386ea0..2bd4e28de 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -348,6 +348,10 @@ static inline bool flow_keys_have_l4(const struct flow_keys *keys)
>  }
>  
>  u32 flow_hash_from_keys(struct flow_keys *keys);
> +#ifdef CONFIG_IP_ROUTE_MULTIPATH
> +u32 flow_multipath_hash_from_keys(struct flow_keys *keys,
> +			   const siphash_key_t *seed);

column alignment looks off here ^^^^ and a few other places; please
correct in the next version.


