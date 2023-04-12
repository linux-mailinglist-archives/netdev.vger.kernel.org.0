Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735D46DFB73
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDLQfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjDLQfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:35:46 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30391BD9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:35:43 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id he11-20020a05600c540b00b003ef6d684102so4799436wmb.3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681317342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H1UERlLb0IEE7WBn0kYzdjfH5tmfRGpcO4CVjo1qns8=;
        b=srJyMIcA9wYhLFxrOJumnj/lWyLknS7vptC3tXSODOgkF+NH2HXLV2E3NLus/Fz/QC
         3NZ6NR2wlzxpneu0qsj13dQRxy3lWv10K7lzKP3+QcRHnn00H3mbQVn4RzImQUcJoGEw
         2TiJmwkVHKiYOJ4BmYhwHNOT/fpdaNmqdKbrhANg0M2+EGmUGcCnlCVXQ4WgnTF/ExVv
         qlnav663mlJM4X5MPzPLYw7bTtVWsiOHKZZc9YlH4ToN0Byr9M4NwflNtwW3121RtXt0
         uLA2C8XWMlu8RNKcEJRKmuabudSCQAfe0gBBEYOVz0SZ+gJfEjIzQ0tiJ/8kPXM5wM62
         sBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681317342;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H1UERlLb0IEE7WBn0kYzdjfH5tmfRGpcO4CVjo1qns8=;
        b=mIAoTH7kixjmOf9V0noIR7C2ZqXBRnnelKeQWxaaovBG9OwgzT1oDf7SPw77npOhN4
         d+W+UNVmp5lL2ucKqqJyrGFnkBouGOqeP5wIh+pd/EkM+r303l+rJOX1DjUjRlUG99dy
         SfwmHuBSVO1ok4NQFlsSTAH2AQfOpkDx0LNo+CvldEnrlS3xZ9TDCZfBGGO50SvdV/wh
         lcINnx1YVHqDyKPo0aXQ8+wRveOESQDcn3GMqTxxgeOoiO9OHzPKsk+StGXkSOsdkUu6
         ByGl89lXqA0EcnxNllFubB2e/AgHPY2c+TINa/z0ftBlFXjhExdK9VJLEuhM/yg7D8tn
         rLxQ==
X-Gm-Message-State: AAQBX9cYFgmMAUmScZcRrbAiCxuVueR890JfXYDNrJJ9EsiGm8xWPPs8
        FOKBGkcMR/sLNrp1VU/KEk3Xbw==
X-Google-Smtp-Source: AKy350a3cFwPBXW4EEIcV5d3YNiKWX3quvpKi2I4dTOhbKHelQVHInOX1SqWs7kCp6euXqjgbzhYPw==
X-Received: by 2002:a05:600c:da:b0:3ee:1acd:b039 with SMTP id u26-20020a05600c00da00b003ee1acdb039mr2460893wmm.34.1681317342401;
        Wed, 12 Apr 2023 09:35:42 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:4382:4a00:b3c9:ac57? ([2a02:578:8593:1200:4382:4a00:b3c9:ac57])
        by smtp.gmail.com with ESMTPSA id t15-20020a05600c198f00b003f0a007b802sm1936412wmq.12.2023.04.12.09.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 09:35:41 -0700 (PDT)
Message-ID: <7405c14e-1fbe-c820-c470-36b0a50b4cae@tessares.net>
Date:   Wed, 12 Apr 2023 18:35:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
Content-Language: en-GB
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, mathew.j.martineau@linux.intel.com,
        mptcp@lists.linux.dev
References: <20230406092558.459491-1-pablo@netfilter.org>
 <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net>
 <20230412072104.61910016@kernel.org>
 <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net>
 <ZDbWi4dgysRbf+vb@calendula>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <ZDbWi4dgysRbf+vb@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

On 12/04/2023 18:04, Pablo Neira Ayuso wrote:
> On Wed, Apr 12, 2023 at 05:22:36PM +0200, Matthieu Baerts wrote:
>> On 12/04/2023 16:21, Jakub Kicinski wrote:
>>> On Thu, 6 Apr 2023 12:45:25 +0200 Matthieu Baerts wrote:

(...)

>>>> Is it not safer to expose something new to userspace, something
>>>> dedicated to what can be visible on the wire?
>>>>
>>>> Or recommend userspace programs to limit to lower than IPPROTO_RAW
>>>> because this number is marked as "reserved" by the IANA anyway [1]?
>>>>
>>>> Or define something new linked to UINT8_MAX because the layer 4 protocol
>>>> field in IP headers is limited to 8 bits?
>>>> This limit is not supposed to be directly linked to the one of the enum
>>>> you modified. I think we could even say it works "by accident" because
>>>> "IPPROTO_RAW" is 255. But OK "IPPROTO_RAW" is there from the "beginning"
>>>> [2] :)
>>>
>>> I'm not an expert but Pablo's patch seems reasonable to me TBH.
>>> Maybe I'm missing some extra MPTCP specific context?
>>
>> I was imagining userspace programs doing something like:
>>
>>     if (protocol < 0 || protocol >= IPPROTO_MAX)
>>         die();
>>
>>     syscall(...);
> 
> Is this theoretical, or you think any library might be doing this
> already? I lack of sufficient knowledge of the MPTCP ecosystem to
> evaluate myself.

This is theoretical.

But using it with socket's protocol parameter is the only good usage of
IPPROTO_MAX for me :-D

More seriously, I don't see such things when looking at:


https://codesearch.debian.net/search?q=%5CbIPPROTO_MAX%5Cb&literal=0&perpkg=1

IPPROTO_MAX is (re)defined in different libs but not used in many
programs, mainly in Netfilter related programs in fact.


Even if it is linked to MPTCP, I cannot judge if it can be an issue or
not because it depends on how the different libC or other libs/apps are
interpreting this IPPROTO_MAX and if they are using it before creating a
socket.


>> With Pablo's modification and such userspace code, this will break MPTCP
>> support.
>>
>> I'm maybe/probably worry for nothing, I don't know any specific lib
>> doing that and to be honest, I don't know what is usually done in libc
>> and libs implemented on top of that. On the other hand, it is hard to
>> guess how it is used everywhere.
>>
>> So yes, maybe it is fine?
> 
> It has been 3 years since the update, I think this is the existing
> scenario looks like this:
> 
> 1) Some userspace programs that rely on IPPROTO_MAX broke in some way
>    and people fixed it by using IPPROTO_RAW (as you mentioned Matthieu)
> 
> 2) Some userspace programs rely on the IPPROTO_MAX value in some way and
>    they are broken (yet they need to be fixed).
> 
> If IPPROTO_MAX is restore, both two type of software described in the
> scenarios above will be fine.
> 
> If Matthieu consider that likeliness that MPTCP breaks is low, then I
> would go for applying the patch.

Even if I continue to think that IPPROTO_MAX should not be used when
looking at protocol field visible on the wire, I guess it doesn't make
sense for a lib to restrict the socket syscall to < IPPROTO_MAX as well
just in case this soft limit is modified later like we did 3 years ago.
We didn't have any bug reports saying that it was not possible to create
an MPTCP socket because of a lib restricting the protocol field to max 256.

In other words, indeed, it looks like the likeliness that MPTCP breaks
is low.

> Yet another reason: Probably it is also good to restore it to
> IPPROTO_MAX so Linux gets aligned again with other unix-like systems
> which provide this definition? Some folks might care of portability in
> userspace.

Good point, I guess we should not have modified IPPROTO_MAX 3 years ago.
It looks then OK to apply such patch (with the small fix asked by Jakub).

It is just a shame we only see this issue now. Maybe because IPPROTO_MAX
is used in such context mainly by Netfilter? :-)

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
