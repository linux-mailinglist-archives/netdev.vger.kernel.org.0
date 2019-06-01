Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B009B3190A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfFACef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:34:35 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41682 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfFACee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:34:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id s24so4572062plr.8
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9+M+ohgDMKWhlssasKvYhzp15SYsekHBEzUleayolDs=;
        b=nxXfhXPMQgU3h/vlgkrDfbsl3mTx8gXs0YzTRlVdKdA357q8vanqWWImCIukaOGCvk
         ewEpRaBYAk4eIeC0o3upyr+xKxrnj8/QKCQWdxqAK9DLB8mU30du5Mx3cpj5IY9GS7qX
         D4K2QjeKy1pyEdGVx/0KG5pdWcNkEeQNXFDuZrplEDyZWdLqWAMGAA3hT6ORL72Latdu
         hc02uX/Wbhs0xorHFNVTCc37561j6i7UQhRSyaAhmiuvD7Olw24FAw4FOnqmGRYmvdKq
         4Pd1hjQWONElUDrAOtjQ6Dyz6CN8AyEm3QMfaO3ikUIiqvkwhOKBiErnSOffdWeXr2BF
         c5Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+M+ohgDMKWhlssasKvYhzp15SYsekHBEzUleayolDs=;
        b=AMEjSi6D3inSM7kTD3suCe4zAGnOHgZ/d5NlowFqnhqeRaUWKY2ggPtcnM7R27/yH2
         ueE77NmwQKzsmFzLRChxgNBB7Op3UnTaQMrzvGj6auF+rCOB4SKF/vl7AVglgoullTrw
         iH56bCpWiuLyWmYwJcCAk87F50u94/XlL0/8hS3e4C7906EQ6n8vbdzDyZQBBEGxp1uu
         Jq86bMoEsCjRD0dKe3BcsENyoudSiP7jo3KnYcKv1KNwt4+MEofUxhJ5D4SUpLKFRlmB
         J296wKYutLNFn5srDBz0DzNjfG+Ko2jEI1pDkK6/i4WWIaMvp+SRQTzwx8rudKPeB9Cz
         YTcA==
X-Gm-Message-State: APjAAAUXX2kgOzR9aC539LEghbzAcFr8FaPdWuub7MNUImgMeUC7nDiX
        Yn3PXufQdd/WkEFnIkXymxk=
X-Google-Smtp-Source: APXvYqyo2EQK/s5V1cdE+LFLo0gR4KDTv7qmy7UgUAmcI3dc5DVUu0Z7mVy/nsohYJMTHKaprW2smg==
X-Received: by 2002:a17:902:4283:: with SMTP id h3mr13574472pld.214.1559356474133;
        Fri, 31 May 2019 19:34:34 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id m7sm11149520pff.44.2019.05.31.19.34.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 19:34:33 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        alexei.starovoitov@gmail.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, kafai@fb.com, weiwan@google.com
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net>
 <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
 <68a9a65c-cd69-6cb8-6aab-4be470b039a8@gmail.com>
 <9f57c949-66b6-20d9-2cab-960074616e71@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b044ed92-28b3-4743-db87-db84f0c8606b@gmail.com>
Date:   Fri, 31 May 2019 19:34:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <9f57c949-66b6-20d9-2cab-960074616e71@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/19 7:29 PM, David Ahern wrote:
> On 5/31/19 7:04 PM, Eric Dumazet wrote:
>>
>> I have a bunch (about 15 ) of syzbot reports, probably caused to your latest patch series.
>>
>> Do we want to stabilize first, or do you expect this new patch series to fix
>> these issues ?
>>
> 
> Please forward. I will take a look.
> 

I will release one of them, I suspect they are duplicates.

This is why I was looking at rt6_get_pcpu_route()

I thought we were lacking a READ_ONCE() but this does not seem needed.

https://patchwork.ozlabs.org/patch/1108632/
