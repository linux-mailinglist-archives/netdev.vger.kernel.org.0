Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067475EDFF3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 17:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbiI1PTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 11:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiI1PTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 11:19:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8069DB5D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 08:19:13 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso1481118wmk.2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 08:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=Ne+wIvF4h4jdpuWRXJDV2IIB6Lw03ExhlOVyjiHeims=;
        b=FUGnIsyoL60k3POnNpIZ4OTGE2gC8JQU9YifASuUudnrn+hc8ckoT6cOCEtjGJTHg7
         Zj9Ke0in0GhA0YjVvJIeYTWYnDHsVK2Yw/+AdNyoH80e1AkQyhdo/SvS/wauOJVho351
         DgHEO6oParvF1yvbhct8vtplud8YVkJZmjVBZ2IDArzyuyVIXanWDHXAkbD7b689SKxy
         JoFehYGHKUts803Wkxhxb5QufM71MmVviyFMqNhQLVxHMX3lk4RjG7ZcFTbi3Dr9vynL
         DHaPE3TAhRSd123S3XJaTXgIXrqGqmcfRzPY8+unlA9QKhhzeEkl5Nwpx7QpUfAwlE75
         2SYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Ne+wIvF4h4jdpuWRXJDV2IIB6Lw03ExhlOVyjiHeims=;
        b=aE/8+4ymJJvJO+D2xYzN0pa9tQaebv+6Jruxt60vuGqNtTgZKA+HMKjexeiqLWGZqC
         IDstypCu4OUookg5LFaRL/xl+bJKiLhdpzYiwVnIFNRq0Wd0tmSNBmkETAhK98FbKeDk
         5mXfb3LWWQzPRTwe0jpiwz+5ihT2hBxtv4CkWUUFfhMobzsVPrvJhQNsOcbrDyGv2CVi
         5utpaY5kSwtTgMj6koDST831e1zo4DEOI0soBk2VTDad4TVgK7OVUw8ecW2XDRFF6xL2
         EXi9haRip+j2vMXbqgiMAZvXVnlDe1k3hi3DnGso7B0kPIAvN4VQbPA8QP//S1SLf/wN
         R2oA==
X-Gm-Message-State: ACrzQf0qozteDIybxi5sr2MGzYZ8hDHprbdnql99dhKJn5EvF1NypFg/
        j/G2CMGU6mWHvKiLvwv0r+g4dA==
X-Google-Smtp-Source: AMsMyM7qNliZDI91xLCHa2MukxQwSxyV6nnVreLMwyogm0aWpXAPUYZq+FFmCnw1lXVnozjz4njsTw==
X-Received: by 2002:a05:600c:4f01:b0:3b4:a8c8:2523 with SMTP id l1-20020a05600c4f0100b003b4a8c82523mr7193574wmq.199.1664378352416;
        Wed, 28 Sep 2022 08:19:12 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:3555:34ed:fe84:7989? ([2a01:e0a:b41:c160:3555:34ed:fe84:7989])
        by smtp.gmail.com with ESMTPSA id b8-20020a5d45c8000000b0022ca921dc67sm4378281wrs.88.2022.09.28.08.19.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 08:19:11 -0700 (PDT)
Message-ID: <bfc759f7-1ce5-17de-15b1-37320200be55@6wind.com>
Date:   Wed, 28 Sep 2022 17:19:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
References: <20220927212306.823862-1-kuba@kernel.org>
 <a93cea13-21e9-f714-270c-559d51f68716@wifirst.fr>
 <d93ee260-9199-b760-40fe-f3d61a0af701@6wind.com>
 <e4db8d52-5bbb-8667-86a6-c7a2154598d1@blackwall.org>
 <20220928073709.1b93b74a@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220928073709.1b93b74a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 28/09/2022 à 16:37, Jakub Kicinski a écrit :
[snip]
> I was very tempted to send a patch which would validate the top
> byte of flags in genetlink for new commands, this way we may some day
> find a truly common (as in enforced by the code) use for the bits. 
> 
> WDYT?
I think it's worth trying it. In the worst case, this could be reverted.
It will help to see how people are using these flags.
The same kind of patch for rtnetlink could be interesting before someone adds a
new flag that overlaps.

> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 7c136de117eb..0fbaed49e23f 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -739,6 +739,22 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
>  	return err;
>  }
>  
> +static int genl_header_check(struct nlmsghdr *nlh, struct genlmsghdr *hdr)
> +{
> +	if (hdr->reserved)
> +		return -EINVAL;
> +
> +	/* Flags - lower byte check */
> +	if (nlh->nlmsg_flags & 0xff & ~(NLM_F_REQUEST | NLM_F_ACK | NLM_F_ECHO))
> +		return -EINVAL;
> +	/* Flags - higher byte check */
> +	if (nlh->nlmsg_flags & 0xff00 &&
> +	    nlh->nlmsg_flags & 0xff00 != NLM_F_DUMP)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static int genl_family_rcv_msg(const struct genl_family *family,
>  			       struct sk_buff *skb,
>  			       struct nlmsghdr *nlh,
> @@ -757,7 +773,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
>  	if (nlh->nlmsg_len < nlmsg_msg_size(hdrlen))
>  		return -EINVAL;
>  
> -	if (hdr->cmd >= family->resv_start_op && hdr->reserved)
> +	if (hdr->cmd >= family->resv_start_op && genl_header_check(nlh, hdr))
>  		return -EINVAL;
>  
>  	if (genl_get_cmd(hdr->cmd, family, &op))
