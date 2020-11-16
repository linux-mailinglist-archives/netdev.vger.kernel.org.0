Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B7F2B54DF
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbgKPXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:20:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKPXUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:20:42 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE961C0613CF;
        Mon, 16 Nov 2020 15:20:41 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so14575270pgg.13;
        Mon, 16 Nov 2020 15:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rrDVDEnDH/iiVuvmKCir8fwE7q6Cx1qQiA3IFSfCGz0=;
        b=PCW5GeqHITY3lFpIHJJ9B+pOiBiazK/kwVnAM6oktEt5yL/NW4UtI6RIpVyUxp8i4f
         nIf5zNmvJXm5Nzoc59K9VgOl144ZwHjw7r7updK5fz0pveND7e8xo5N0xRckNhPkwC0X
         J+ZcVVtLCF4E3lau3w+Hvwe6NGkFY7W3VqvPMGMTkSouhpzSR7I74dTXyoIWxeUWEdOY
         0LL4sq2WGyQxB1AudQGbYsK2oUd5NNDh8NDyI+3xiywhzAQMhgRBPHB83+NQvs/jB2KL
         0Ju+bcYiX32bo8kieqshKn2YA6piWQ0437rJ6SX+ESsoum6YUITn/vgNGAW+8FSgwO9x
         ygCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=rrDVDEnDH/iiVuvmKCir8fwE7q6Cx1qQiA3IFSfCGz0=;
        b=Jv32insD9Kf0MfRtUIKs2gydacQNCAXxF05PrgXNNiL+9VE43GQAa1hiskK0xmQkC0
         q3NEeayatLLYp06BmUv/T9wdjTXM/QUtyy6uavmYOb4aqViz5lSriPZAXzGWEW1w6Iz8
         u5PTnScBkk6CuIEuyM+HQor6cDAE/zCTuf1ll7Vw3zet3LWKymaN4LJa4ukP/vzUeY4F
         yyoCTlp8V728Rvf3uovhHdbDR952kSJ2sr6p+M48KrHX0yarNKPpEk2fHaSHszGOyD8U
         q7sJ5U2mOhL0s2hBtGJiar1Y4TdKpVHSuAmALdcT4zm4fBoLdT5gJEVBwAWMMnuDjO6Z
         YENA==
X-Gm-Message-State: AOAM530swPVqxS7FR8H2niip6VtoQsjQ9wlDK0D4DOqc8l0wv1sa5JUq
        V+I42+K+l5/NzZ+gbFwM4d51RALrzRg=
X-Google-Smtp-Source: ABdhPJwdn6n7imGuaY9Ts2ZhpaGhlerGnfYklTz1R/GHqNzm5wqkdNpl3JkstORn18YE9mXqHHUesw==
X-Received: by 2002:aa7:8c55:0:b029:18c:45ed:d87e with SMTP id e21-20020aa78c550000b029018c45edd87emr15951872pfd.76.1605568841020;
        Mon, 16 Nov 2020 15:20:41 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m68sm6476667pfm.173.2020.11.16.15.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 15:20:39 -0800 (PST)
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
 <20201019200258.jrtymxikwrijkvpq@skbuf>
 <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
 <20201019211916.j77jptfpryrhau4z@skbuf>
 <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <d2dbb984-604a-ecbd-e717-2e9942fdbdaa@gmail.com>
Date:   Mon, 16 Nov 2020 15:20:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a8d38b5b-ae85-b1a8-f139-ae75f7c01376@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20 3:06 PM, Florian Fainelli wrote:
> On 10/20/20 6:12 PM, Jakub Kicinski wrote:
>> On Tue, 20 Oct 2020 00:19:16 +0300 Vladimir Oltean wrote:
>>> On Mon, Oct 19, 2020 at 02:03:40PM -0700, Florian Fainelli wrote:
>>>>> Completely crazy and outlandish idea, I know, but what's wrong with
>>>>> doing this in DSA?  
>>>>
>>>> I really do not have a problem with that approach however other stacked
>>>> devices like 802.1Q do not do that. It certainly scales a lot better to
>>>> do this within DSA rather than sprinkling DSA specific knowledge
>>>> throughout the network stack. Maybe for "configuration less" stacked
>>>> devices such as DSA, 802.1Q (bridge ports?), bond etc. it would be
>>>> acceptable to ensure that the lower device is always brought up?  
>>>
>>> For upper interfaces with more than one lower (bridge, bond) I'm not so
>>> sure. For uppers with a single lower (DSA, 8021q), it's pretty much a
>>> no-brainer to me. Question is, where to code this? I think it's ok to
>>> leave it in DSA, then 8021q could copy it as well if there was a need.
>>
>> FWIW no strong preference here. Maybe I'd lean slightly towards
>> Florian's approach since we can go to the always upping the CPU netdev
>> from that, if we start with auto-upping CPU netdev - user space may
>> depend on that in general so we can't go back.
>>
>> But up to you folks, this seems like a DSA-specific problem, vlans don't
>> get created before user space is up (AFAIK), so there is no compelling
>> reason to change them in my mind.
> 
> Right I remembered in my previous job we had a patch that would support
> creating VLAN devices when specified over ipconfig on the kernel command
> line, but that as never upstream AFAICT.
> 
>>
>> Florian for you patch specifially - can't we use
>> netdev_for_each_lower_dev()?
> 
> Looks like I forgot to respond here, yes we could do that because we do
> call netdev_upper_dev_link() in net/dsa/slave.c. Let me re-post with
> that done.

I remember now there was a reason for me to "open code" this, and this
is because since the patch is intended to be a bug fix, I wanted it to
be independent from: 2f1e8ea726e9 ("net: dsa: link interfaces with the
DSA master to get rid of lockdep warnings")

which we would be depending on and is only two-ish releases away. Let me
know if you prefer different fixes for different branches.
-- 
Florian
