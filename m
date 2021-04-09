Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825DF359B16
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhDIKHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbhDIKF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:05:58 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18924C0613DB;
        Fri,  9 Apr 2021 03:04:16 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x7so5028253wrw.10;
        Fri, 09 Apr 2021 03:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NSfrVBc4gnBnGyMOAUSWxE3ofLPQlOdazdZ0AK5gUrs=;
        b=ttz2xBuswd45OqpQMqSaIZwwr8oh/lyTBNV3o43u0Uy1iEYgI19nT/2tBGpxkNjEzu
         pcC/WrSwR4/wRE+2ayZ2Tq+2pM8DFZEgzIfvTp8wMQjWTIvdFI3bio8YmYqW6snx9XMH
         uHQzoQb30spuptwToPUdXaWagBpSvKx97ipzyZgl3x3Njd66ThKp1/rSEPFvSQxcwSwt
         unlAuTwM3RUiDQQDdJHDb89+/qGpNR5KY4C5+4Cmpb6p2EMZIxERS6IYMHzjgz+aXgGj
         5yWjHxfyxIZdfs1hgO5t5ea04JqARZ/q+NOc/VfnM6QAZa+jE9Ti/xThrgKtqFpUmSjL
         P40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NSfrVBc4gnBnGyMOAUSWxE3ofLPQlOdazdZ0AK5gUrs=;
        b=mGrFK8rXC9KI0444D1Zd3hEQ9msf6207VtuXLG3fPG97qKIMVYDewoNNlyg63jbqVj
         UKW/8WpK/UpQwiVJG23bbMTsGUgGqntuZ0wpr0r1Gue6cfp2kQ9Qw7EbttwkVzxD1xq5
         cpQ2RB+Fr3A4JsnYovW8lH7lwi0z2Ruro7UYLgkoMBnUvkCJDNsFEMEDBslY/JKW5g5i
         8wvhkclM7xS1rPiiJ/YATUX8WB5Yy82wkDTLxD4gditBgFxY1VADYCJ9JAuOvXM5549c
         I+xDhV6sMWpCNYisovGwwT+yKJEkiXwSYou85FEujfY9/yKZgItYU+fUYtFNv6FzEA/r
         8ujQ==
X-Gm-Message-State: AOAM531bHJa4kh2QGh4qTYy62AU5IGSzspdh2J2Hi1AzaAakhSZ28tRU
        LFZ0ZVZf1wNups1UboPxxzGxetuTfXI=
X-Google-Smtp-Source: ABdhPJxN0nnazorW+GBjvRZFe1GEFxk06xl5tAsQhQnT9v1ttFJlE3Z8nQvhfwJ0ibjQllkli19u6A==
X-Received: by 2002:adf:f88a:: with SMTP id u10mr17072590wrp.162.1617962654622;
        Fri, 09 Apr 2021 03:04:14 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.116.29])
        by smtp.gmail.com with ESMTPSA id b1sm932241wru.90.2021.04.09.03.04.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 03:04:13 -0700 (PDT)
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Xie He <xie.he.0141@gmail.com>,
        Mel Gorman <mgorman@techsingularity.net>
Cc:     Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net>
 <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
 <20210409084436.GK3697@techsingularity.net>
 <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <87ab3d13-f95d-07c5-fc6a-fb33e32685e5@gmail.com>
Date:   Fri, 9 Apr 2021 12:04:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAJht_EPrdujG_0QHM1vc2yrgwwKMQiFzUAK2pgR4dS4z9-Xknw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/9/21 11:14 AM, Xie He wrote:
> On Fri, Apr 9, 2021 at 1:44 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>>
>> That would imply that the tap was communicating with a swap device to
>> allocate a pfmemalloc skb which shouldn't happen. Furthermore, it would
>> require the swap device to be deactivated while pfmemalloc skbs still
>> existed. Have you encountered this problem?
> 
> I'm not a user of swap devices or pfmemalloc skbs. I just want to make
> sure the protocols that I'm developing (not IP or IPv6) won't get
> pfmemalloc skbs when receiving, because those protocols cannot handle
> them.
> 
> According to the code, it seems always possible to get a pfmemalloc
> skb when a network driver calls "__netdev_alloc_skb". The skb will
> then be queued in per-CPU backlog queues when the driver calls
> "netif_rx". There seems to be nothing preventing "sk_memalloc_socks()"
> from becoming "false" after the skb is allocated and before it is
> handled by "__netif_receive_skb".
> 
> Do you mean that at the time "sk_memalloc_socks()" changes from "true"
> to "false", there would be no in-flight skbs currently being received,
> and all network communications have been paused?
> 


Note that pfmemalloc skbs are normally dropped in sk_filter_trim_cap()

Simply make sure your protocol use it.
