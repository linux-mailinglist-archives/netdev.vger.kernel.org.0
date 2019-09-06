Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009F8AB564
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 12:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389992AbfIFKIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 06:08:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39373 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfIFKIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 06:08:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id q12so6405988wmj.4
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 03:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GdB3/1MpsDzDzkvoeCl6BJH5UKRZkpG87pd7j0f8SYc=;
        b=WOnGMuG/65q+gsaVZ1cXHMrg99El4LQxAbaeqP1E3ziZNeQMLjyzK6h05bBMc7Y1rl
         dUZlqPsDHatIImtD1ii+z6RlFu+KiUhgiClw7bTToDQEJr4R8krzRJjo6oLzeSjLq/3C
         HmxNWaQByX+ISfgCGLbEk6GnHWRxCjCgKiL8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GdB3/1MpsDzDzkvoeCl6BJH5UKRZkpG87pd7j0f8SYc=;
        b=CVTLpLDrwPgo/J4LPQPTnx/3PbejbAKuSYoxzmEgKFOMIpD39hrwmSsoM1xsj/JAzV
         qHh52Z147Vo+8IXRW1IqkBeh3It308qH/VdhVKGsoNry7Cx0r39seGmeFO9TziUp9X33
         9ZONgpeOyk07yQxSwQE/AO1FuI4jSFMMmNpRNg8zzhfnpyz1G283eZDejBzn6nnjMGKE
         ML8P638LZvbJLyH9ETbup8j9CrvAgVMzgs9CdgiKcFS5oe1X4IYCB06rQKpZ6oLtea0U
         Ptq9EUY8BVWT+svAFga4Oti5WthF2VuAqCy5VcZSSjTqyO61IYRV+KWvcaPEP4LPa6ap
         NHTQ==
X-Gm-Message-State: APjAAAVSEaD6E1tor/DfNKo+MiwNGkWSFPArpoOlW6xhurBv1plfZYOf
        pVywgC6rskQyh14G0jZV+ln8kg==
X-Google-Smtp-Source: APXvYqxWasmQFKOSsCKjLMTiSv0W7d7r5h9M/sUj/NGo9VyjI/NtHDLtE6GW5Q9Xq8DcFadwDY2wQQ==
X-Received: by 2002:a7b:c764:: with SMTP id x4mr6129491wmk.134.1567764496803;
        Fri, 06 Sep 2019 03:08:16 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id j22sm9856674wre.45.2019.09.06.03.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2019 03:08:16 -0700 (PDT)
Subject: Re: [PATCHv3 net-next] ipmr: remove hard code cache_resolve_queue_len
 limit
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Phil Karn <karn@ka9q.net>,
        Sukumar Gopalakrishnan <sukumarg1973@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20190903084359.13310-1-liuhangbin@gmail.com>
 <20190906073601.10525-1-liuhangbin@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <9162c077-463e-69d9-af97-0a5d4f02b78b@cumulusnetworks.com>
Date:   Fri, 6 Sep 2019 13:08:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190906073601.10525-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/09/2019 10:36, Hangbin Liu wrote:
> This is a re-post of previous patch wrote by David Miller[1].
> 
> Phil Karn reported[2] that on busy networks with lots of unresolved
> multicast routing entries, the creation of new multicast group routes
> can be extremely slow and unreliable.
> 
> The reason is we hard-coded multicast route entries with unresolved source
> addresses(cache_resolve_queue_len) to 10. If some multicast route never
> resolves and the unresolved source addresses increased, there will
> be no ability to create new multicast route cache.
> 
> To resolve this issue, we need either add a sysctl entry to make the
> cache_resolve_queue_len configurable, or just remove cache_resolve_queue_len
> limit directly, as we already have the socket receive queue limits of mrouted
> socket, pointed by David.
> 
> From my side, I'd perfer to remove the cache_resolve_queue_len limit instead
> of creating two more(IPv4 and IPv6 version) sysctl entry.
> 
> [1] https://lkml.org/lkml/2018/7/22/11
> [2] https://lkml.org/lkml/2018/7/21/343
> 
> v3: instead of remove cache_resolve_queue_len totally, let's only remove
> the hard code limit when allocate the unresolved cache, as Eric Dumazet
> suggested, so we don't need to re-count it in other places.
> 
> v2: hold the mfc_unres_lock while walking the unresolved list in
> queue_count(), as Nikolay Aleksandrov remind.
> 
> Reported-by: Phil Karn <karn@ka9q.net>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv4/ipmr.c  | 4 ++--
>  net/ipv6/ip6mr.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 

Please CC all interested parties who have reviewed/commented on previous versions.

I'd also add a Suggested-by tag such as:
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>

Looks good to me, thanks!
Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
