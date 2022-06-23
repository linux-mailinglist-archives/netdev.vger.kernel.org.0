Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70218557F95
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbiFWQRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbiFWQRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:17:21 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D04237A01
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:17:20 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id s17so15196123iob.7
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nRXz2QLIQlbVyJOP0gFf52RwLwhjUHvwRqqAFUW0Qds=;
        b=ffQYxs0K60SymtwXXUkzIPYZEhdieSYkV4592dTtIv4TI/KRWIQzj4eJek9C1jKhYo
         Y8FLCQOr5zOBzQAZqkYL6iYsG6kYvFaRLj5vLTfotmBJZElN8wVZgknmT+BPxUh8s5/l
         s4VecASdriq7vCgGIMgyBJ0Q+1DHzfKcXpsokOwWtqPutiq8xG6KIvcEuYPxHRCWl4UW
         9gdTrw5jE52pzPFOBO21IkaII17ItRQe1xx/HWi5iAv1xGupWhh0NhdVhL0P+v78wxMG
         lgTlAx8vSUP5htoGtm2hY5MSq6OEyW1ggBRmJQEOrbjU9tI6N8h1JQ/Zb3QaFJagT/30
         x2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nRXz2QLIQlbVyJOP0gFf52RwLwhjUHvwRqqAFUW0Qds=;
        b=fXrWnC4BEu0I6FqdJypbtTIGXidGhwl+W0iMQ3N+QXsFSqzgB0d5pqtTREs1bJKIbS
         6OPxAlGYAlbGUXbWj/z2hdVuCRDIw7tKntIQBbKu/sW42DQw422A0v6T1U3Vb754BOnH
         TqGAlrJ0aBS+2OHkumN1v4t+awqlyj3qIxemgUGxWRHg3eWM0KKWoyWy/mk4pjBQ1Qfr
         MojurLEc9/b2o5lzj9r2AH/TD/5sMygQA77ZG570ERBeNi5dMA/I/DPv5ruPb6ED61Bl
         r+XXSua6SNiX/YI9GsjjVE01k8+RoVXLw3Eqo/bvTs69IfNhwoPF604E0Ih64vlJ9Zc0
         9ruA==
X-Gm-Message-State: AJIora9hgwvSWomWz8TdhghReg7uDKwkxR5kGPQneHtj/znUPqaJC8zB
        10/WaeqLk4d3HjcRfelIOek=
X-Google-Smtp-Source: AGRyM1tJQLZDlT17+H/mUj2tRooN50HIn7ZrRWR1qWVRZu8oXj68Ym85mmLMDzh0gud7tzRhvE0YkA==
X-Received: by 2002:a02:a45:0:b0:339:c58d:9ac3 with SMTP id 66-20020a020a45000000b00339c58d9ac3mr5911806jaw.51.1656001039613;
        Thu, 23 Jun 2022 09:17:19 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:a54b:f51d:f163:ba49? ([2601:282:800:dc80:a54b:f51d:f163:ba49])
        by smtp.googlemail.com with ESMTPSA id r17-20020a922a11000000b002d3a3f4685dsm1145ile.21.2022.06.23.09.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jun 2022 09:17:19 -0700 (PDT)
Message-ID: <bd76637b-0404-12e3-37b6-4bdedd625965@gmail.com>
Date:   Thu, 23 Jun 2022 10:17:17 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ismael Luceno <iluceno@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20220615171113.7d93af3e@pirotess>
 <20220615090044.54229e73@kernel.org> <20220616171016.56d4ec9c@pirotess>
 <20220616171612.66638e54@kernel.org> <20220617150110.6366d5bf@pirotess>
 <20220622131218.1ed6f531@pirotess> <20220622165547.71846773@kernel.org>
 <fef8b8d5-e07d-6d8f-841a-ead4ebee8d29@gmail.com>
 <20220623090352.69bf416c@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220623090352.69bf416c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/22 10:03 AM, Jakub Kicinski wrote:
> On Wed, 22 Jun 2022 22:01:37 -0600 David Ahern wrote:
>>> Right, the question is what message can we introduce here which would
>>> not break old user space?  
>>
>> I would hope a "normal"
> 
> "normal" == with no attributes?
> 
>> message with just the flags set is processed by
>> userspace. iproute2 does - lib/libnetlink.c, rtnl_dump_filter_l(). It
>> checks the nlmsg_flags first.
> 
> 🤞
> 
>>> The alternative of not wiping the _DUMP_INTR flag as we move thru
>>> protocols seems more and more appealing, even tho I was initially
>>> dismissive.
>>>
>>> We should make sure we do one last consistency check before we return 0
>>> from the handlers. Or even at the end of the loop in rtnl_dump_all().  
>>
>> Seems like netlink_dump_done should handle that for the last dump?
> 
> Yeah, the problem is:
>  - it gets lost between families when dumping all, and
>  - if the dump get truncated _DUMP_INTR never gets set because many
>    places only check consistency when outputting an object.
> 
>> That said, in rtnl_dump_all how about a flags check after dumpit() and
>> send the message if INTR is set? would need to adjust the return code of
>> rtnl_dump_all so netlink_dump knows the dump is not done yet.
> 
> Yup, the question for me is what's the risk / benefit of sending 
> the empty message vs putting the _DUMP_INTR on the next family.
> I'm leaning towards putting it on the next family and treating 
> the entire dump as interrupted, do you reckon that's suboptimal?

I think it is going to be misleading; the INTR flag needs to be set on
the dump that is affected.

All of the dumps should be checking the consistency at the end of the
dump - regardless of any remaining entries on a particular round (e.g.,
I mentioned this what the nexthop dump does). Worst case then is DONE
and INTR are set on the same message with no data, but it tells
explicitly the set of data affected.

> User space can always dump family by family if it cares about
> breaking the entire dump.
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index ac45328607f7..c36874d192ef 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3879,6 +3879,7 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
>  			continue;
>  
>  		if (idx > s_idx) {
> +			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>  			memset(&cb->args[0], 0, sizeof(cb->args));
>  			cb->prev_seq = 0;
>  			cb->seq = 0;
> 

