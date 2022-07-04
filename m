Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F835652B2
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiGDKo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiGDKo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:44:56 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BAA2647
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 03:44:55 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id z12so3261702wrq.7
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 03:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HHAe6rQwr9MrDt9I7ObAOqlnyRBGIZbM5f/5orMaIbY=;
        b=uS1bGty8VICWPH72+GPnXGmWChQniwhiv7ShefNQyAaXa6ppTQrEoVs4K4es9kn90s
         8JvoQBV+ID+WHLZDUTIbzeezdG5SUSiScft/09OStpKS87DKNsGccRt8Ssu4MOwS9TjN
         qaWbpxBa+wd96ZKDVQbrKdsmRNwKfve6u/Vi986HoR+OLkMAWyjYLP2M238aBfV9OMgn
         LTAc4pwyR0NsNFMgbhoRWguSac46OMWXPmxfrK2o+oC+S80XzjQvXfiYzNBgU3JWH3uS
         WnE2bsfU4YyFSAxWYp5YB1zzRwOt26tMO6qG/4cJual7hfWwGNCaXMmftWLdawm2tMBG
         nlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HHAe6rQwr9MrDt9I7ObAOqlnyRBGIZbM5f/5orMaIbY=;
        b=e1bP8WOe5BQqdHNOxlKn5R2ZiRiecfQOIPHSFM1RKsBho+omPZajk9p0BzJhZnn362
         DP0FwPRZ6hCUrkZzS/HM1OPwfKANPYtuPe/uxFFyNIBVBSGfQNXdE5igWvRH3QkfTtLr
         QjPstzrmoD8nUOfmN8tcRFRSny3mo4mqpxTFM1wtYGj1qm1DdN9HsRqrxhdPEfu33VTQ
         oiC5+17HthoQNqQeAmTolT8RSDD5kPkXPZaVcrdGzwXPlngKPTflZxnR7TQbZ8h1vOYW
         9swKXzsYU4rZG0B3PyPRgorWbS0zfXLKh2TN7SRKbQS097ntZOrEL/ktjJzuC0fqyFh/
         RIRg==
X-Gm-Message-State: AJIora/sz3lM+qBRsKMv/vE32tqHaNo/9zTNnXgdAw01aVPiSIjUAzeZ
        ixeJvt+coE7VUpgP0fg4thgF/w==
X-Google-Smtp-Source: AGRyM1sl2wr40mQuZP0/e8RXkOdJ7KwhGN0yLyRxR7osfhMoG8OGzEUYAcBOzwLR59dixL7dEdA/kA==
X-Received: by 2002:a5d:690c:0:b0:21d:6a26:9378 with SMTP id t12-20020a5d690c000000b0021d6a269378mr4315516wru.375.1656931493552;
        Mon, 04 Jul 2022 03:44:53 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id z21-20020a1c4c15000000b0039c871d3191sm19765350wmf.3.2022.07.04.03.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 03:44:53 -0700 (PDT)
Message-ID: <e41a3aba-ae19-9713-0d41-bd7287fdfc43@blackwall.org>
Date:   Mon, 4 Jul 2022 13:44:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2] net: ip6mr: add RTM_GETROUTE netlink op
Content-Language: en-US
To:     David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220630202706.33555ad2@kernel.org>
 <20220704095845.365359-1-equinox@diac24.net>
 <80dd41cc-5ff2-f27f-3764-841acf008237@blackwall.org>
 <YsLDPnuC6dlROlj3@eidolon.nox.tf>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <YsLDPnuC6dlROlj3@eidolon.nox.tf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2022 13:38, David Lamparter wrote:
> On Mon, Jul 04, 2022 at 01:22:36PM +0300, Nikolay Aleksandrov wrote:
>> On 04/07/2022 12:58, David Lamparter wrote:
>>> +const struct nla_policy rtm_ipv6_mr_policy[RTA_MAX + 1] = {
>>> +	[RTA_UNSPEC]		= { .strict_start_type = RTA_UNSPEC },
>>
>> I don't think you need to add RTA_UNSPEC, nlmsg_parse() would reject
>> it due to NL_VALIDATE_STRICT
> 
> Will remove it.
> 
>>> +	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*rtm))) {
>>> +		NL_SET_ERR_MSG(extack, "ipv6: Invalid header for multicast route get request");
>>> +		return -EINVAL;
>>> +	}
>>
>> I think you can drop this check if you...
>>
>>> +
>>> +	rtm = nlmsg_data(nlh);
>>> +	if ((rtm->rtm_src_len && rtm->rtm_src_len != 128) ||
>>> +	    (rtm->rtm_dst_len && rtm->rtm_dst_len != 128) ||
>>> +	    rtm->rtm_tos || rtm->rtm_table || rtm->rtm_protocol ||
>>> +	    rtm->rtm_scope || rtm->rtm_type || rtm->rtm_flags) {
>>> +		NL_SET_ERR_MSG(extack,
>>> +			       "ipv6: Invalid values in header for multicast route get request");
>>> +		return -EINVAL;
>>> +	}
>>
>> ...move these after nlmsg_parse() because it already does the hdrlen
>> check for you
> 
> Indeed it does.  Moving it down.
> 
> [...]
>>> +	/* rtm_ipv6_mr_policy does not list other attributes right now, but
>>> +	 * future changes may reuse rtm_ipv6_mr_policy with adding further
>>> +	 * attrs.  Enforce the subset.
>>> +	 */
>>> +	for (i = 0; i <= RTA_MAX; i++) {
>>> +		if (!tb[i])
>>> +			continue;
>>> +
>>> +		switch (i) {
>>> +		case RTA_SRC:
>>> +		case RTA_DST:
>>> +		case RTA_TABLE:
>>> +			break;
>>> +		default:
>>> +			NL_SET_ERR_MSG_ATTR(extack, tb[i],
>>> +					    "ipv6: Unsupported attribute in multicast route get request");
>>> +			return -EINVAL;
>>> +		}
>>> +	}
>>
>> I think you can skip this loop as well, nlmsg_parse() shouldn't allow attributes that
>> don't have policy defined when policy is provided (i.e. they should show up as NLA_UNSPEC
>> and you should get "Error: Unknown attribute type.").
> 
> I left it in with the comment above:
> 
>>> +	/* rtm_ipv6_mr_policy does not list other attributes right now, but
>>> +	 * future changes may reuse rtm_ipv6_mr_policy with adding further
>>> +	 * attrs.  Enforce the subset.
>>> +	 */
> 
> ... to try and avoid silently starting to accept more attributes if/when
> future patches add other netlink operations reusing the same policy but
> with adding new attributes.
> 

They really should be using policies specific to their actions with only the allowed
attributes. Re-using this policy is ok only if those match, otherwise it's a bug IMO.

> But I don't feel particularly about this - shall I remove it?  (just
> confirming with the rationale above)
> 

I don't have a preference either, IMO if anyone re-uses this policy without making
sure the same attributes and types are needed is adding buggy code. Actually the thing
that I like about keeping the loop is the more specific error message, let's see what
others think.

>>> +	struct net *net = sock_net(in_skb->sk);
>>> +	struct nlattr *tb[RTA_MAX + 1];
>>> +	struct sk_buff *skb = NULL;
>>> +	struct mfc6_cache *cache;
>>> +	struct mr_table *mrt;
>>> +	struct in6_addr src = {}, grp = {};
>>
>> reverse xmas tree order
> 
> Ah.  Wasn't aware of that coding style aspect.  Fixing.
> 
> Thanks for the review!
> 
> 
> -David/equi

