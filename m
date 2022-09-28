Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7F5EDF16
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbiI1Oqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiI1Oqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:46:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7798E440
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:46:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id hy2so27616550ejc.8
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Rg8q6sr0v63hGHCdlAeSjJTGQsexDzdClJbGCM6Q6pE=;
        b=XXG78eYCHRQkQwxiVGu57fvcz9y2pDrOrFgIl65g6yUT8Bbb8e+lqKAATrBeF3+C9Z
         JVh8HjZ9Vwyr/faIBiia5/BAea7GzYuIndaI8dFnRVMRLOu6t5i3b0T/d0Axr1WIcWnk
         7iL1SVDMzC1JDTTfPxzgr1H1yaqi3BDfnnXDf9jBKH3+y13i8v8QpMyg1B7n+6Bg3Tt6
         DCeVw8O44pgKnu/lv2JKjRwKo7XOMvYhC3Egd+5Ng0NEJzY3UedHsvkdvA8yPpe8E/Qq
         /f+yeSybwwNQhxz7b8HVthWHnM5OiX01RrbPR9idCw5WRU+KN1trteMNRvL/ZHBbBq8Y
         xFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Rg8q6sr0v63hGHCdlAeSjJTGQsexDzdClJbGCM6Q6pE=;
        b=K9SYxwykhMAMjehM57eCoyzflkjru8u4yW/zR8q0PK9nwxkLSN24eqI6OvvoneaMoC
         5LW6YK33hUbvDqKSGziftEC0kXM0xtQfW5PSHEtDSUZo5jCRNwY5gVy20q7khTjTOSk6
         WvOolSiYDoovDU+Lg1NbkTWITNp4taMgI3+SAyvcwA7oL17mHdpFqHT779X/rQUVP84k
         PGyyx6E0DA8lJRHaeT+XM6eiYB3p1xBOhMqgOUn0JyXbtgLaOTFNa69vUR5LUYv3Sxon
         vuVWV5uOAxrnO4bHohstIM4lzguWE3iRX3ThXGG2K5Dg82Z8p/qL+cdjj0uJXVYPaw/6
         Accg==
X-Gm-Message-State: ACrzQf2bdGOA0MT2u+A+wOuDaX3FnXPYOBY6wFOzAZWLPbzW4jSqkOcS
        oZW+gPhYXqKPiuDgEBV1c7J4V0m6Rd9/QIKs9Ck=
X-Google-Smtp-Source: AMsMyM7JpJuxXrSwM9LCUK/JBCYow7iy+rMxDZ1N6uy2NrqZVMTPAmXObJZhjHKEuGvJCIJ6PUJz9w==
X-Received: by 2002:a17:907:72d4:b0:783:22e1:43a1 with SMTP id du20-20020a17090772d400b0078322e143a1mr17231900ejc.47.1664376390740;
        Wed, 28 Sep 2022 07:46:30 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b0077ce503bd77sm2466670ejf.129.2022.09.28.07.46.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 07:46:30 -0700 (PDT)
Message-ID: <60f75b7a-e9c3-ed30-0992-711c7ab23bc1@blackwall.org>
Date:   Wed, 28 Sep 2022 17:46:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     nicolas.dichtel@6wind.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
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
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220928073709.1b93b74a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/2022 17:37, Jakub Kicinski wrote:
> On Wed, 28 Sep 2022 12:21:57 +0300 Nikolay Aleksandrov wrote:
>> On 28/09/2022 11:55, Nicolas Dichtel wrote:
>>> Le 28/09/2022 à 10:04, Florent Fourcot a écrit :  
>>>> About NLM_F_EXCL, I'm not sure that my comment is relevant for your intro.rst
>>>> document, but it has another usage in ipset submodule. For IPSET_CMD_DEL,
>>>> setting NLM_F_EXCL means "raise an error if entry does not exist before the
>>>> delete".  
> 
> Interesting.
> 
>>> So NLM_F_EXCL could be used with DEL command for netfilter netlink but cannot be
>>> used (it overlaps with NLM_F_BULK, see [1]) with DEL command for rtnetlink.
>>> Sigh :(
>>>
>>> [1] https://lore.kernel.org/netdev/0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com/
>>
>> One could argue that's abuse of the api, but since it's part of a different family
>> I guess it's ok. NLM_F_EXCL is a modifier of NEW cmd as the comment above it says
>> and has never had rtnetlink DEL users.
> 
> It's fine in the sense that it works, but it's rather pointless to call
> the flags common if they have different semantics depending on the
> corner of the kernel they are used in, right?
> 

Right, and their comments and docs become kind of meaningless because of that.

> I was very tempted to send a patch which would validate the top
> byte of flags in genetlink for new commands, this way we may some day
> find a truly common (as in enforced by the code) use for the bits. 
> 
> WDYT?
> 

I like it, can't check right now if we can get into the same issue as with BULK where
someone is passing unused/wrong flags with the command and we break him though.
But I'd bite the bullet and maybe issue an extack msg as well.

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

