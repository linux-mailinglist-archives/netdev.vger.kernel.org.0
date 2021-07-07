Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26B3BEFD5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 20:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhGGSxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 14:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbhGGSxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 14:53:07 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7A4C061574;
        Wed,  7 Jul 2021 11:50:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so2353438wmc.2;
        Wed, 07 Jul 2021 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q6LzrfY7vgLbFhj6JNyuBgQmAYgd/L18gqM5n+AEigc=;
        b=LkJ7eob4UWs6iWo0boqTZ7QHYJtgkk5K2inIOu7dCQeigRhfgxQEs2Uhf8DJOUVkEP
         WS2pgdGL3dkIx76zOX7qe5sTvdDwpRrYit6B/HIeP+KoPcT59Nv/jG7Uqmb26cQZ9QkN
         en2T9gxld8aN0FWhAUw0B2j6lGySi5j3i/JttgLZIaUeRvpMFw37exvHE1A7ArK1m5dr
         WpR7ivkx/a0cK9QuyEbuIs/8PJxtwCjz75Iae3ffDFKKC+aMXXFuvQO8W48Xbwi+rlPs
         GEPX+5mgyA1uQqhnKEYxc1VJUdx4cPDEolkEuxSSLHjA3v0P1KODAemFsYZXhO5zKTr2
         SwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q6LzrfY7vgLbFhj6JNyuBgQmAYgd/L18gqM5n+AEigc=;
        b=SPLVTfLX7uLnrjUoyjO+oD1spvMWZAVo7W/elnQMoUHffGb9+I2HHp8cnP1pdbyvhT
         vNw3jm8dLsDeUVCsEvSnHCAex/i/utCX/GNyTLlEAExi1ONTCLyI9ygssAtd0sys0ig2
         NoookDJQYrjWw7+A/2sJS2O6xjUX7oJGCiZW3Le26Cd/JEejesUwQFy7T6KLE3eufJkq
         8CUlealNFtApGyi0P/jQEudC6iP0BZI+4w183hVeHmshOhUvhryhdkHAE/3rB1zdzA7e
         7v8DkDJ2j5upqeG03JnrMxRkvHZ241FES+3c5QZA3dAxdnBBk9WV51bSf94io6tL2pcw
         XkBA==
X-Gm-Message-State: AOAM5321WUT7jpKTGmiRI5aKAJ0VUJxa9SKYQ0x4C289HqazM/TcHyhv
        fbtMheLHlB/IBsAJAs5xHLCFLzNvKco=
X-Google-Smtp-Source: ABdhPJz8TPmkumyEp5GhrB1ukjEtnHAXwfEcq/CdpAf1WHrmD0ezuUb4nO0EOuA2k6yGsDTcNIzrOw==
X-Received: by 2002:a05:600c:2197:: with SMTP id e23mr3078630wme.101.1625683824258;
        Wed, 07 Jul 2021 11:50:24 -0700 (PDT)
Received: from [192.168.98.98] (162.199.23.93.rev.sfr.net. [93.23.199.162])
        by smtp.gmail.com with ESMTPSA id n13sm12792360wms.4.2021.07.07.11.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jul 2021 11:50:23 -0700 (PDT)
Subject: Re: [PATCH IPV6 1/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1625665132.git.vvs@virtuozzo.com>
 <3cb5a2e5-4e4c-728a-252d-4757b6c9612d@virtuozzo.com>
 <8996db63-5554-d3dc-cd36-94570ade6d18@gmail.com>
 <20210707094218.0e9b6ffc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1cbf3c7b-455e-f3a5-cc2c-c18ce8be4ce1@gmail.com>
 <20210707113027.4077e544@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0f2c9281-a5fa-f129-ffef-7add5b1d7d02@gmail.com>
Date:   Wed, 7 Jul 2021 20:50:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210707113027.4077e544@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/21 8:30 PM, Jakub Kicinski wrote:
> On Wed, 7 Jul 2021 19:41:44 +0200 Eric Dumazet wrote:
>> On 7/7/21 6:42 PM, Jakub Kicinski wrote:
>>> On Wed, 7 Jul 2021 08:45:13 -0600 David Ahern wrote:  
>>>> why not use hh_len here?  
>>>
>>> Is there a reason for the new skb? Why not pskb_expand_head()?  
>>
>>
>> pskb_expand_head() might crash, if skb is shared.
>>
>> We possibly can add a helper, factorizing all this,
>> and eventually use pskb_expand_head() if safe.
> 
> Is there a strategically placed skb_share_check() somewhere further
> down? Otherwise there seems to be a lot of questionable skb_cow*()
> calls, also __skb_linearize() and skb_pad() are risky, no?
> Or is it that shared skbs are uncommon and syzbot doesn't hit them?
> 

Some of us try hard to remove skb_get() occurrences,
but they tend to re-appear fast :/

Refs: commit a516993f0ac1694673412eb2d16a091eafa77d2a
("net: fix wrong skb_get() usage / crash in IGMP/MLD parsing code") 

