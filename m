Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80CB94D54F9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344514AbiCJXFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244176AbiCJXFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:05:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425A6D8861
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:04:16 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id z3so6197938plg.8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 15:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1coxOHy+MiOVkaWgzSw++tkxGlirBpUlCMovtClURhw=;
        b=CjWfotxA33yOsiAJ7O8Fm3Q6c+I6BF7K7x2OwbbcHiGwT0SPnVY4OXhan3k5QaGlbt
         WU3LZJ+4LVyE4wxo5yZEYRRY6oVg/CwycFcrLAJA/7Sv9vc+4OPp3aEicV+dmxkIPNu7
         B9mDme2VHkIEA86cgc3LRs1aJvhXqL+HivHuz8+8IKsulr7JWTB+EfFZ/70pTeYm0l5s
         jbOQgfW0slhcjisOZ3zLqjDUjedFHxTul8fich1wTn1OV6bH8Bfv3gEdGQUbT/Jx7vRU
         F+KzSYjRifjUoT98RTyxdS3W93t8RAjJ9ejZEz5cAaZ8uPIByzG/qpEFK88zunFNx8JJ
         rnvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1coxOHy+MiOVkaWgzSw++tkxGlirBpUlCMovtClURhw=;
        b=Fzo67wuwuboqjxbytaGX2sPirx0AEvhYlsDUeRwKvBVf20YL12xNjE9TzIXPFE4glx
         q32KidWGStkMkL5SD9PCrC1pr3cYrk7oyi0PHSbWVR1UHIwZ2TNFh05qHU56gpv+w9RI
         c5bLPT0WhKN9lTS43Z2Z5PbY6vUMwRTKpy3MUa+DSmrWKl9j4Jwc1WGpS2xpzAPtyPQs
         LlVIVzulSz3rJKBMhxARkJfOIF7EyfgACVKx40Ug2FoNlpu0PTtCYe8S2aHatJ26JrCC
         IBIW0dHkReuXBjrCX7sbjxBSDaBPwjEePoUxoCwN/yalKgQ2EaUYU8jhTJ56wXTkRcmF
         kFrQ==
X-Gm-Message-State: AOAM5312lJquzqZZ1SCfag2HHbe4fAMBMCK8SOTJcM1vlskI69vw0YZe
        zW1RCxsFm2bH0ZjNbZgIvFldDA==
X-Google-Smtp-Source: ABdhPJw8HTIbG6Vtna5RHQ3w0pUmdSBxZ9o7VNzoRIFubitq+l+4KYvfWrG6iZrcHpsFwfLo5jj15A==
X-Received: by 2002:a17:903:124a:b0:151:99fe:1a10 with SMTP id u10-20020a170903124a00b0015199fe1a10mr7338107plh.87.1646953455727;
        Thu, 10 Mar 2022 15:04:15 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id rj14-20020a17090b3e8e00b001bf50a8b468sm11740225pjb.51.2022.03.10.15.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 15:04:15 -0800 (PST)
Message-ID: <77a44185-c9cd-21f5-125f-b8eec7a66537@linaro.org>
Date:   Thu, 10 Mar 2022 15:04:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com,
        Willem de Bruijn <willemb@google.com>
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
 <20220310221328.877987-1-tadeusz.struk@linaro.org>
 <20220310143011.00c21f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CAF=yD-LrVjvY8wAqZtUTFS8V9ng2AD3jB1DOZvkagPOp3Sbq-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/22 14:43, Willem de Bruijn wrote:
> On Thu, Mar 10, 2022 at 5:30 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Thu, 10 Mar 2022 14:13:28 -0800 Tadeusz Struk wrote:
>>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>>> index 4788f6b37053..6d45112322a0 100644
>>> --- a/net/ipv6/ip6_output.c
>>> +++ b/net/ipv6/ip6_output.c
>>> @@ -1649,6 +1649,16 @@ static int __ip6_append_data(struct sock *sk,
>>>                        skb->protocol = htons(ETH_P_IPV6);
>>>                        skb->ip_summed = csummode;
>>>                        skb->csum = 0;
>>> +
>>> +                     /*
>>> +                      *      Check if there is still room for payload
>>> +                      */
>>
>> TBH I think the check is self-explanatory. Not worth a banner comment,
>> for sure.
>>
>>> +                     if (fragheaderlen >= mtu) {
>>> +                             err = -EMSGSIZE;
>>> +                             kfree_skb(skb);
>>> +                             goto error;
>>> +                     }
>>
>> Not sure if Willem prefers this placement, but seems like we can lift
>> this check out of the loop, as soon as fragheaderlen and mtu are known.
>>
>>>                        /* reserve for fragmentation and ipsec header */
>>>                        skb_reserve(skb, hh_len + sizeof(struct frag_hdr) +
>>>                                    dst_exthdrlen);
> 
> Just updating this boundary check will do?
> 
>          if (mtu < fragheaderlen ||
>              ((mtu - fragheaderlen) & ~7) + fragheaderlen <
> sizeof(struct frag_hdr))
>                  goto emsgsize;

Yes, it will. v3 on its way.

-- 
Thanks,
Tadeusz
