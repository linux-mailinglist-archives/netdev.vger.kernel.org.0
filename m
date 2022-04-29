Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31EE8515624
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 22:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381094AbiD2U5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 16:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381048AbiD2U5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 16:57:49 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6709BCC518;
        Fri, 29 Apr 2022 13:54:30 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id j8so8119172pll.11;
        Fri, 29 Apr 2022 13:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KxziQN9VA/G/fI05uZ7i5ywd5osxyGBwIkSNjY22z9E=;
        b=lVz9oyD7EZIdedXpxyIXpoHgacK/PRNW20Dyqj/3YW+QaE9k4PW3iJE5+BWNCLAwHf
         jx4SyWMuh+wLep/6Te5CJ9Nf8RE0RRLp/barjDucIGkUuhNwUIsWGGX/P3ogcc8HiYIB
         aHPAIF9VTKpKCEV3fvp5r1iD2lz9mPF0kUQpmlNX9WU99AigM4L4y6QWRiGMr/NtScGf
         889bAQN+WBM2N7b07vXkX60ItYGkdWjvThAxZmP3Uv4e6XDruIxymchIuKqfIFgQ9S+q
         y9i9Of2aF4vBY1U6XaX+pIw/ZOUorVn/ejy+D2fjn0qHIIfQgbGo+Bb4stTPU5s+VaWr
         fF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KxziQN9VA/G/fI05uZ7i5ywd5osxyGBwIkSNjY22z9E=;
        b=3CA4J1vQgbYpRj+ZSTKtBSLLRfV41JpTTp4PuMvYbIjv9d3rqgpvS4V7v4QLzoMaGP
         o6Wp2/XRHu32Jmqimg8x3Ambdix7Ti4VC59yL7i61jl/U+mBirGQhT3qOs1wjRS9+fUU
         qxvSJM7hPS7Wu8g1jqzXUwjWMjFbW46k1O2fCp/SseK7piAUs3se4SVPb/nc1Lu7P8B1
         EPvbjxXfIB8UsDCfZvMLocZ04jQhvuwNw2zvJBIyrassMRQfAEPEKGnJ5e+S7z/vwkDk
         L7DEAkLNWyanAm3JT+4uINexpKb3NH56DpdWsj5JRYOenczptX0/no8QllFQX4jQIskd
         Pvgg==
X-Gm-Message-State: AOAM532e/NOHNB6sHhcyKT+9Iqo4/eiU6rLC9HKbN/SNLihSKSgIINkj
        ey6Ry5I/IZhYRFkYHnnHpQYDi0Fk9NY=
X-Google-Smtp-Source: ABdhPJw1Avr8rMFJg0ZRRZyn+mgi+Y3tZYaePVJpVIX7mpYgPp6t+Yb0UgLZXxhMvxQpPrwd/3HNlg==
X-Received: by 2002:a17:90b:1291:b0:1db:eab7:f165 with SMTP id fw17-20020a17090b129100b001dbeab7f165mr5935409pjb.74.1651265669879;
        Fri, 29 Apr 2022 13:54:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l3-20020a170902d04300b0015e8d4eb1f3sm34873pll.61.2022.04.29.13.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 13:54:29 -0700 (PDT)
Message-ID: <04f72c85-557f-d67c-c751-85be65cb015a@gmail.com>
Date:   Fri, 29 Apr 2022 13:54:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Routing loops & TTL tracking with tunnel devices
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kuba@kernel.org,
        hannes@stressinduktion.org, edumazet@google.com
References: <CAHmME9r_DbZWe4FsfebHSSf_iPctSe5S-w9bU3o8BN43raeURg@mail.gmail.com>
 <20151116203709.GA27178@oracle.com>
 <CAHmME9pNCqbcoqbOnx6p8poehAntyyy1jQhy=0_HjkJ8nvMQdw@mail.gmail.com>
 <1447712932.22599.77.camel@edumazet-glaptop2.roam.corp.google.com>
 <CAHmME9oTU7HwP5=qo=aFWe0YXv5EPGoREpF2k-QY7qTmkDeXEA@mail.gmail.com>
 <YmszSXueTxYOC41G@zx2c4.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <YmszSXueTxYOC41G@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/28/22 17:37, Jason A. Donenfeld wrote:
> Hey Eric,
>
> On Tue, Nov 17, 2015 at 03:41:35AM +0100, Jason A. Donenfeld wrote:
>> On Mon, Nov 16, 2015 at 11:28 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> There is very little chance we'll accept a new member in sk_buff, unless
>>> proven needed.
>> I actually have no intention of doing this! I'm wondering if there
>> already is a member in sk_buff that moonlights as my desired ttl
>> counter, or if there's another mechanism for avoiding routing loops. I
>> want to work with what's already there, rather than meddling with the
>> innards of important and memory sensitive structures such as sk_buff.
> Well, 7 years later... Maybe you have a better idea now of what I was
> working on then. :)
>
> As an update on this issue, it's still quasi problematic. To review, I
> can't use the TTL value, because the outer packet always must get the
> TTL of the route to the outer destination, not the inner packet minus
> one. I can't rely on reaching MTU size, because people want this to work
> with fragmentation (see [1] for my attempt to disallow fragmentation for
> this issue, which resulted in hoots and hollers). I can't use the
> per-cpu xmit_recursion variable, because I use threads.
>
> What I can sort of use is taking advantage of what looks like a bug in
> pskb expansion, such that it always allocates too much, and pretty
> quickly fails allocations after a few loops. Only powerpc64 and s390x
> don't appear to have this bug. See [2] for a description of this in
> depth I wrote a few months ago to you.


Hmm, I will take a look later I think. Thanks for the reminder.


>
> Anyway, it'd be nice if there were a free u8 somewhere in sk_buff that I
> could use for tracking times through the stack. Other kernels have this
> but afaict Linux still does not. I looked into trying to overload some
> existing fields -- tstamp/skb_mstamp_ns or queue_mapping -- which I was
> thinking might be totally unused on TX?


if skbs are stored in some internal wireguard queue, can not you use 
skb->cb[],

like many other layers do ?


>
> Any ideas about this?
>
> Thanks,
> Jason
>
> [1] https://lore.kernel.org/wireguard/CAHmME9rNnBiNvBstb7MPwK-7AmAN0sOfnhdR=eeLrowWcKxaaQ@mail.gmail.com/
> [2] https://lore.kernel.org/netdev/CAHmME9pv1x6C4TNdL6648HydD8r+txpV4hTUXOBVkrapBXH4QQ@mail.gmail.com/
