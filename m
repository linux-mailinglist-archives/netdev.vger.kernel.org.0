Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5B4623460
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbiKIURP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKIURO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:17:14 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9FB2F67A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:17:13 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b11so17745663pjp.2
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 12:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d+SVZ+lDNxtme3AVhqJqB9b1GpGuxCUr5Wo0beBZFxo=;
        b=EuorGx5WtWeAY5eP2tdGofSkKEU/xmyDZiaB1hPOJB+RjoGGvwO2FEUeyn/JWB7jH3
         oGk9d2jY1eOJjH8S4TyRlH891G3AsvwbaDMkrvuk607IUgQ8ZDd2kbymXcYgtHCzas8B
         yns1P+JmxM3TnenkN/DuphGkaFX8NlT0Z6CpLP5ymIaL/osU0hiQe6/8/pgvTpOUwUD5
         sJ3zGmYD8Kdzi6pt5wDz4JXG663kPD+q3UxQMUtddWtZ5nHUUWCmkzGwwRJlHfJdwg6a
         JT5H4uafs5NLNLJX/ExZ5TPcw/6e4k+BexK+Bu2D8UXuogDspYI72VGchd3nivQrXDAj
         hpFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d+SVZ+lDNxtme3AVhqJqB9b1GpGuxCUr5Wo0beBZFxo=;
        b=3aHMmU4+h+LdovcqhEXxOesUBzfbIrXldeVtmxVKAY+FELjH5yanlQlHD0KuFT/4aL
         d4bvNXUqC8uECyEmsyI80j5qK4tpN3Q8UAspUTuIpVvlQXmslTQ2+KFTC1GX2/OFQgQw
         zTUfRJz32AQyURI/PYcruSIBv6t2YMH9n5wddM8pH26P6K3EOSokqQP0XqMEg05uzudE
         qDSoAbxr97NtHYQFX+T1ZwACvHoRHfYy1pLqfIxyfkTFzIxObolGiUubGyksDtIWmm6L
         1Cmf7D8CTd+wu4rILj2ysee/OgLCwAmndHIJWQPep75R/7cApMq1c2EIF3dDlmEhvOTI
         efRA==
X-Gm-Message-State: ACrzQf2imdkzVwjY8a7nNwJbLmlOrVy6KM788TTvvQj4rjjnrAWWiUn3
        st1ruiBb8HIMvzkTatFb80Y=
X-Google-Smtp-Source: AMsMyM5YGcfiC4lw/VHpyJstUTXi3TS1ahFHzLOoQ3oEkmJ0cM4JJc2vgYIJj6cBU8dHJ0N4TQczSA==
X-Received: by 2002:a17:902:ec8e:b0:187:1c64:7c32 with SMTP id x14-20020a170902ec8e00b001871c647c32mr54547555plg.24.1668025032812;
        Wed, 09 Nov 2022 12:17:12 -0800 (PST)
Received: from ?IPV6:2620:15c:2c1:200:2e00:ecf1:249d:7286? ([2620:15c:2c1:200:2e00:ecf1:249d:7286])
        by smtp.gmail.com with ESMTPSA id x29-20020aa7941d000000b0056bf4f8d542sm8721110pfo.74.2022.11.09.12.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 12:17:11 -0800 (PST)
Message-ID: <49594248-1fd7-23e2-1f17-9af896cd25b0@gmail.com>
Date:   Wed, 9 Nov 2022 12:17:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCHv3 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        edumazet@google.com
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>,
        David Ahern <dsahern@kernel.org>
References: <20221109014018.312181-1-liuhangbin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20221109014018.312181-1-liuhangbin@gmail.com>
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


On 11/8/22 17:40, Hangbin Liu wrote:
> Currently, we get icmp6hdr via function icmp6_hdr(), which needs the skb
> transport header to be set first. But there is no rule to ask driver set
> transport header before netif_receive_skb() and bond_handle_frame(). So
> we will not able to get correct icmp6hdr on some drivers.
>
> Fix this by checking the skb length manually and getting icmp6 header based
> on the IPv6 header offset.
>
> Reported-by: Liang Li <liali@redhat.com>
> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> Acked-by: Jonathan Toppins <jtoppins@redhat.com>
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> v3: fix _hdr parameter warning reported by kernel test robot
> v2: use skb_header_pointer() to get icmp6hdr as Jay suggested.
> ---
>   drivers/net/bonding/bond_main.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index e84c49bf4d0c..2c6356232668 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3231,12 +3231,17 @@ static int bond_na_rcv(const struct sk_buff *skb, struct bonding *bond,
>   		       struct slave *slave)
>   {
>   	struct slave *curr_active_slave, *curr_arp_slave;
> -	struct icmp6hdr *hdr = icmp6_hdr(skb);
>   	struct in6_addr *saddr, *daddr;
> +	const struct icmp6hdr *hdr;
> +	struct icmp6hdr _hdr;
>   
>   	if (skb->pkt_type == PACKET_OTHERHOST ||
>   	    skb->pkt_type == PACKET_LOOPBACK ||
> -	    hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
> +	    ipv6_hdr(skb)->nexthdr != NEXTHDR_ICMP)


What makes sure IPv6 header is in skb->head (linear part of the skb) ?


> +		goto out;
> +
> +	hdr = skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &_hdr);
> +	if (!hdr || hdr->icmp6_type != NDISC_NEIGHBOUR_ADVERTISEMENT)
>   		goto out;
>   
>   	saddr = &ipv6_hdr(skb)->saddr;
