Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E95C5821FA
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiG0IWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiG0IWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:22:43 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF2F42ADE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:22:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id f15so12007693edc.4
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Y/222Cm84RV0Lulq/WSSuQXjmvUtsc6p2rHarENgd2E=;
        b=Hl1hMvUb0P9tjF6MqfciHbbCGbPJIzHoXYcWSXxHos3jaP9nxeRl/XIAz3QwDHCoFs
         tFeBdlUoD/0IuISLBc+Ojl6A5YRei8t5orjUIl8CIpkDpsVgve58Ks/NpWjx9AIm1IVU
         mhKruHs2ai98++YWxgzbsDjMUo6FY89V1NlCkzx8B7H3EB8RzsmFjFGaODUEVM+X+ONX
         H4+UmUBnD9CVxr2cU8vQCm3uI1HKAkRPDDXZsJabgQzMHtvWe8hv4ZT8ao3a1K8Jef9H
         TUgPwcBOpxpx6Ack+FObgNgaf2IfHCwerQlRV2SMCQH0GCBpsbAmpEfBS9kZWUKz1WpI
         8z+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y/222Cm84RV0Lulq/WSSuQXjmvUtsc6p2rHarENgd2E=;
        b=dCXJxhWNtR0flMRyIjUA+tXWIciUCTJ2e7bEEoqdoGm9Iz+tRbLoCZSwqgs0mWTbHS
         cZgfGBqIPQTQkeZ0ikNwBdRuT8bl+o+Rb5awoD0VgsK1/a0GTxY7d8Yka9ozjCW5ydIH
         rfSaXrigs1Ss07h/jNBnVehCaq7+8Ss2HdjeYFznxmlEDOqcjY9VU0mGwCdDxG1EHHYK
         ILJF1Roondquv0nBKflHKJAQHU9anadoxtkydoq2y5z4VU/S+9gIKf3FRdUNFIjJEalO
         4wm3Hrt0IkBGVDbEVjo3HNPXi3sJZjiPMBc84biRjq6C5PLKL/DCPD9lnXiEaYixOkjR
         Xw4A==
X-Gm-Message-State: AJIora+uFteBV8aKz9HuLOM304hLvilsWnEpEwyQ3/o4a2/CJybm+Alj
        TSXC1nGb8bJyOjN8YcOl4Rg=
X-Google-Smtp-Source: AGRyM1us6tedWtLk/M4BsvvCdwFCUzmDvXXM+aIjyIzh8O271mzm4JptUckteey8gWQ0v4JPKiIkqg==
X-Received: by 2002:a05:6402:13c1:b0:43b:e330:9bbf with SMTP id a1-20020a05640213c100b0043be3309bbfmr18879998edx.417.1658910160910;
        Wed, 27 Jul 2022 01:22:40 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:994d:5eac:a62d:7a76? ([2a04:241e:502:a09c:994d:5eac:a62d:7a76])
        by smtp.gmail.com with ESMTPSA id kx20-20020a170907775400b0072aa014e852sm7251506ejc.87.2022.07.27.01.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 01:22:40 -0700 (PDT)
Message-ID: <e09f6bc5-b5c4-5ab6-16c3-029b45810530@gmail.com>
Date:   Wed, 27 Jul 2022 11:22:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] tcp: md5: fix IPv4-mapped support
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Brian Vazquez <brianvv@google.com>,
        Dmitry Safonov <dima@arista.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
References: <20220726115743.2759832-1-edumazet@google.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220726115743.2759832-1-edumazet@google.com>
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



On 7/26/22 14:57, Eric Dumazet wrote:
> After the blamed commit, IPv4 SYN packets handled
> by a dual stack IPv6 socket are dropped, even if
> perfectly valid.
> 
> $ nstat | grep MD5
> TcpExtTCPMD5Failure             5                  0.0
> 
> For a dual stack listener, an incoming IPv4 SYN packet
> would call tcp_inbound_md5_hash() with @family == AF_INET,
> while tp->af_specific is pointing to tcp_sock_ipv6_specific.
> 
> Only later when an IPv4-mapped child is created, tp->af_specific
> is changed to tcp_sock_ipv6_mapped_specific.
> 
> Fixes: 7bbb765b7349 ("net/tcp: Merge TCP-MD5 inbound callbacks")
> Reported-by: Brian Vazquez <brianvv@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Leonard Crestez <cdleonard@gmail.com>

I had a test in this area for AO and MD5 but it was incorrect (it did 
not actually use an ipv4-mapped-ipv6 address for the ipv6 socket, it 
used an ipv6 wildcard address).

After fixing the test I can confirm that this patch does in fact fix 
something.

https://github.com/cdleonard/tcp-authopt-test/commit/662a6a7e1a818f4581fc0055e821bc1b4c8d04e8

Tested-by: Leonard Crestez <cdleonard@gmail.com>

> ---
>   net/ipv4/tcp.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 002a4a04efbe076ba603d7d42eb85e60d9bf4fb8..766881775abb795c884d048d51c361e805b91989 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4459,9 +4459,18 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
>   		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
>   	}
>   
> -	/* check the signature */
> -	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
> -						 NULL, skb);
> +	/* Check the signature.
> +	 * To support dual stack listeners, we need to handle
> +	 * IPv4-mapped case.
> +	 */
> +	if (family == AF_INET)
> +		genhash = tcp_v4_md5_hash_skb(newhash,
> +					      hash_expected,
> +					      NULL, skb);
> +	else
> +		genhash = tp->af_specific->calc_md5_hash(newhash,
> +							 hash_expected,
> +							 NULL, skb);
>   
>   	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
>   		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
