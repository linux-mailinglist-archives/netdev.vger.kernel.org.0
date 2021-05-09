Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA78377901
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhEIWYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIWYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:24:41 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55011C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:23:38 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id w16so5966655oiv.3
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D5iTcnq8gnsdyLGpg8SsuPo2oQotcwfup0gXhSFVmLI=;
        b=L5XzRc1WpHIAGe2AS2H2f2lCkEIgla23aa8Q3DqHRYUm3SKHJ14btgeK1mFNpTNUnC
         hIBDdqVEJsu4c3B26A8/bXcTtKYtYKH/xj/m4O6bsscmwqeM90Ea+mOx7yN9shctY5MX
         ifTHWNEdo58/zmsllsGXb34hbPrAuQBu+yMCxhkre0E5ek3k6sVws1wO9RsapzlUQTYI
         SdzDC3KPxisaERzP/id/oNpUzkrAXaLC0pLKDHUnoX3euIYoacddIPwm/OjjkPL2zGdG
         mEuBJJPGtlc+vD3dB+L2B6bR8rYQ30lumXfc3tOcYiSTGu8TtVzMV0kkstcFQxSizahn
         oCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D5iTcnq8gnsdyLGpg8SsuPo2oQotcwfup0gXhSFVmLI=;
        b=JKWeZ5Wawim6WLOiwAW0/ZMcD7UsmRoFzeMMfsk5aGnZ1uT3Yc3VPxX1zHIgFDcYpr
         TDvF48PWc59PZeVcM+xDz1G2I45A4pqguOG8qjc98tMzc3ejzMmiwbXsWDl+3vyjRmvo
         6Q8fvTuXeWN2QUlbcat1xdPlMu5HnPcB2KoURg0f1fNlmp7kU2via05usiPrCtVU37NJ
         HOk+cW7/1i1lz1HwZj5lVfcqOApMSZc8bBgtc6WJMLlEwk7rZwx61G3qwgJyeMW755ki
         1tJnOqHdQPO5OOIwQC1oHQFZe4ewubAxCqenegAdJs79arEpuEktC/xidPp3qqYqCT5y
         TBUA==
X-Gm-Message-State: AOAM531efgVKHgyVTPGcmIaYyeevZgTbxw/hXKsb9AKuKuXtBFIY52vh
        h9hMxP7vFk3wajK4KVHj30o=
X-Google-Smtp-Source: ABdhPJy2Od1RqZ4IMt0EIbsDvTzCSr0+/IM2kvJBFadZxKWs5X7KRRsc+WtiegTVMTFi73ln7JUh/Q==
X-Received: by 2002:aca:3c09:: with SMTP id j9mr23150811oia.28.1620599017722;
        Sun, 09 May 2021 15:23:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id x2sm2324400ooe.13.2021.05.09.15.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:23:37 -0700 (PDT)
Subject: Re: [iproute2-next v2] seg6: add counters support for SRv6 Behaviors
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20210508154458.3127-1-paolo.lungaroni@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f7b8e5ce-461e-dfd2-7248-3a330e266172@gmail.com>
Date:   Sun, 9 May 2021 16:23:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508154458.3127-1-paolo.lungaroni@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/21 9:44 AM, Paolo Lungaroni wrote:
> We introduce the "count" optional attribute for supporting counters in SRv6
> Behaviors as defined in [1], section 6. For each SRv6 Behavior instance,
> counters defined in [1] are:
> 
>  - the total number of packets that have been correctly processed;
>  - the total amount of traffic in bytes of all packets that have been
>    correctly processed;
> 
> In addition, we introduce a new counter that counts the number of packets
> that have NOT been properly processed (i.e. errors) by an SRv6 Behavior
> instance.
> 
> Each SRv6 Behavior instance can be configured, at the time of its creation,
> to make use of counters specifing the "count" attribute as follows:
> 
>  $ ip -6 route add 2001:db8::1 encap seg6local action End count dev eth0
> 
> per-behavior counters can be shown by adding "-s" to the iproute2 command
> line, i.e.:
> 
>  $ ip -s -6 route show 2001:db8::1
>  2001:db8::1 encap seg6local action End packets 0 bytes 0 errors 0 dev eth0
> 
> [1] https://www.rfc-editor.org/rfc/rfc8986.html#name-counters
> 
> v2:
>  - add help and route.8 man page updates
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> Signed-off-by: Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h | 30 ++++++++++++++
>  ip/iproute.c                    |  9 ++++-
>  ip/iproute_lwtunnel.c           | 72 ++++++++++++++++++++++++++++++++-
>  man/man8/ip-route.8.in          | 13 ++++--
>  4 files changed, 119 insertions(+), 5 deletions(-)
> 

applied. Thanks,

