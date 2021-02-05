Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75462310443
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 06:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBEE6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 23:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhBEE6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 23:58:35 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A06BC061786
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 20:57:55 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id d7so5767920otf.3
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 20:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pYNj1ioeAKjF12VVHsxe98piY/by3hAAPBaY1XeF9q4=;
        b=mcyIBsXOk8TsI0y2rJ6+s5GsSjf3Bfh6VpOGtjVjLqbCogrkeunXh1vhp4sqZKM4Sd
         z/aqDLnAJghv6w4pc71SS/rqwhwHdMlZPY/wiM0nJvx/myNXGOeMedJFR1V0K4TwB7VI
         f3yWl0n2rej3UMMzoEkbZNRwXMxHJFsvHMSR9Lh1KtHujErOmQ5nGqroW1GlriVcIaL3
         6q5lkBuN4Fviv43NKl8c19E/3srK42vLeYMuvuSusIsYIq9C5BoEpB/q5gVzxDelDuuh
         IuzdBNnJEtWOpyExoAVzc0fiwKk6WaYZXmm0TSRxlZnm6iJF5ET2i9EDS4XmEe/tRlWp
         qwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pYNj1ioeAKjF12VVHsxe98piY/by3hAAPBaY1XeF9q4=;
        b=NwhP+GGiuA4yWNirVqfhTg60/oK4wEv2SAaSO1TYKlqu+gZe3x70Ql42+TDoQ9MTY+
         gVSDswZi8xxWmLk99LxT8kTYicRKbdZyJHX7yNGDgxwEM0I0np+/7iYu/5xOY5VssxPU
         t7faN8T133to+eRE8dJG8WV1166bT8EiVtcXpvpzaUBWCSmaQg25Hn3UwAskW9Yob0gE
         lWKkq/oXlqs/U7I3A22QTz86Vq+a3yBLYGwyutRouhCVaLX40BwxuoZZ86xP5YDqk3Et
         TbveBn7MhFlYmAczdPqHXItP5tBxh5wsHIjkkiJkUFm86xKjS/ejsjBZrZ7snvSiaz2f
         NJ7A==
X-Gm-Message-State: AOAM531VZJO+QZjeX6dUFzb3DQJQS4OUERHFpCelhetuqvYi8y8mviIn
        NVyxcev6NWhngFdSgJK4qTo+Qh1i7Fo=
X-Google-Smtp-Source: ABdhPJxymNll0XtRhBq0IFgWMq0WK/QzLQDi3GY98TxhB9t44XUfQSs3nQMY7q28XokFYN1AySewoA==
X-Received: by 2002:a05:6830:134d:: with SMTP id r13mr2175488otq.140.1612501074274;
        Thu, 04 Feb 2021 20:57:54 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id 62sm6249oii.23.2021.02.04.20.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 20:57:53 -0800 (PST)
Subject: Re: [PATCH iproute2-next v3] tc/htb: Hierarchical QoS hardware
 offload
To:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>, netdev@vger.kernel.org
References: <20210204145137.165298-1-maximmi@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <acd468c6-c3cd-f7eb-7ef8-0d029f198feb@gmail.com>
Date:   Thu, 4 Feb 2021 21:57:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210204145137.165298-1-maximmi@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/21 7:51 AM, Maxim Mikityanskiy wrote:
> This commit adds support for configuring HTB in offload mode. HTB
> offload eliminates the single qdisc lock in the datapath and offloads
> the algorithm to the NIC. The new 'offload' parameter is added to
> enable this mode:
> 
>     # tc qdisc replace dev eth0 root handle 1: htb offload
> 
> Classes are created as usual, but filters should be moved to clsact for
> lock-free classification (filters attached to HTB itself are not
> supported in the offload mode):
> 
>     # tc filter add dev eth0 egress protocol ip flower dst_port 80
>     action skbedit priority 1:10
> 
> tc qdisc show and tc class show will indicate whether the offload is
> enabled. Example output:
> 
> $ tc qdisc show dev eth1
> qdisc htb 1: root offloaded r2q 10 default 0 direct_packets_stat 0 direct_qlen 1000 offload
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> qdisc pfifo 0: parent 1: limit 1000p
> $ tc class show dev eth1
> class htb 1:101 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:1 root rate 100Gbit ceil 100Gbit burst 0b cburst 0b  offload
> class htb 1:103 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:102 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:105 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:104 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:107 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:106 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> class htb 1:108 parent 1:1 prio 0 rate 4Gbit ceil 4Gbit burst 1000b cburst 1000b  offload
> $ tc -j qdisc show dev eth1
> [{"kind":"htb","handle":"1:","root":true,"offloaded":true,"options":{"r2q":10,"default":"0","direct_packets_stat":0,"direct_qlen":1000,"offload":null}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}},{"kind":"pfifo","handle":"0:","parent":"1:","options":{"limit":1000}}]
> 
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>  man/man8/tc-htb.8 |  5 ++++-
>  tc/q_htb.c        | 10 +++++++++-
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks


