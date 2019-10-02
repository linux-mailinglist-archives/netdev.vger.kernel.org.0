Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E5BC94A8
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfJBXOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:14:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38135 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfJBXOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:14:40 -0400
Received: by mail-pl1-f195.google.com with SMTP id w8so564268plq.5
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4rtTmpsVhlx8+e7wdoUm8AEZSQTyNsPFhjsOUnFs8oo=;
        b=cijraE47bIyHH6ByGaihiLMd1jrZwbUQr0fbbJWEy5oGG+GVB/RLXSXkgWkM1fAmRw
         A6lQcEjHTf5P/c4HLtOnzm+vtbafH7XUPSmq06DGWm2rSuv1w+0/llF53Vod+KC22Ph6
         z454CQZLiPIb8Hey6CNg7cUSW0k4gQUkpKEpRuFT+0OwQMNLin9FTJmoyV6D9WEl4kk3
         WyNOPQte/FzNIjYz2igcNYn9jvJ6Az/+tjcEGBlit5MfxlmMRn5PHBs0vU7PWdJn5dPB
         hpHIwwRCrHSk40oDLarPcJBdEOCSxnIbm3hEz+xJPJOVyF4dckU13yHq5M18JGTJIkuz
         YaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4rtTmpsVhlx8+e7wdoUm8AEZSQTyNsPFhjsOUnFs8oo=;
        b=g3TdVho9N028cfwaR6LZZCLG5PV4/+YbvD9HsA6KR3e2nYx5HQ+Ve9wkG+QOgdDl9+
         8rX2ZMoFWcfXdfixbD8LNxXItdcCPJN4Wl2EylP+x4PTgX3X3g2Fa3L+OJC+Bi1WABCQ
         vnu7qODLUUr2Uze0pvGMDSZTH8OEmYkuq25TYsTny57ayTQ/1fjPUUkvqMDP/01zOFAj
         jRiJyLLU4I1uePc3eAl5ACEGO2c4onKN1qQ9pgjPBeJ/4ELo0HzgbJB/zT1PCdB6vb5D
         p+BFnUEgUMF+ZSK/f4q1vxr8L41v5hu1OWLpGT6DpJHMWif8sQT58E/UXov1nmmywjyE
         0cdA==
X-Gm-Message-State: APjAAAVr5wKJWZquxHAAX5bUZwzuuSLKNgY9uK/Z61Rr1OGU+hSXL+zm
        bUY95XpEKSs0MODtirxWbuw=
X-Google-Smtp-Source: APXvYqwoHXpkffR8GtEsgHS8zQEcJj/q73WJQAOl/y5IqPRzAFljtGrqciqk1GVwFwYD/kxf81Fssg==
X-Received: by 2002:a17:902:67:: with SMTP id 94mr6529982pla.121.1570058079739;
        Wed, 02 Oct 2019 16:14:39 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id r1sm398877pgv.70.2019.10.02.16.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 16:14:38 -0700 (PDT)
Subject: Re: [PATCH] tcp: add tsval and tsecr to TCP_INFO
To:     William Dauchy <wdauchy@gmail.com>
Cc:     NETDEV <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20191002221017.2085-1-wdauchy@gmail.com>
 <025bcf1e-b7d4-5fa2-ec68-074c62b9d63c@gmail.com>
 <CAJ75kXZT1Mt_=dqG+YEZHpzDLUZaPK=Nep=S85t9V+cT1TNMfA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d0b1f5b1-8182-a1d0-4abf-924a0f050393@gmail.com>
Date:   Wed, 2 Oct 2019 16:14:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJ75kXZT1Mt_=dqG+YEZHpzDLUZaPK=Nep=S85t9V+cT1TNMfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 3:54 PM, William Dauchy wrote:
> Hello Eric,
> 
> On Thu, Oct 3, 2019 at 12:33 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> On 10/2/19 3:10 PM, William Dauchy wrote:
>> Reporting the last recorded values is really not good,
>> a packet capture will give you all this information in a non
>> racy way.
> 
> Thank you for your quick answer.
> In my use case I use it on a http server where I tag my requests with
> such informations coming from tcp, which later helps to diagnose some
> issues and create some useful metrics to give me a general signal.
> Does it still sound like an invalid use case?

I would rather use a new getsockopt() to fetch this specific data,
instead of making TCP_INFO bigger for everyone :/

ss command can dump millions of sockets in busy hosts, we need to be
careful of TCP_INFO size.

