Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F60B28AB1F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 01:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgJKX4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 19:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387799AbgJKX4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 19:56:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E630EC0613CE;
        Sun, 11 Oct 2020 16:56:47 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id m17so15888927ioo.1;
        Sun, 11 Oct 2020 16:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/fduF09yM7vuP+WIo3gczCgW86zcHAmHOB9GlTh+hfA=;
        b=reMWvGiq0ouMhl326muorYxlUAV0TT8c5fYPf0FHRNo+YkZ2LOw8PP/Gv7vZ7Q7PIp
         Lnyn68oxDalFKBjG3GzQxpV720iN7fY7wnqmx7yG8O6cNp839MQL24YkXTJzIZ79Srns
         1o+nkDNHpV2UijbcPbYur3eGuAkv5GHvDOMqjNEoi4x+EIbgysXQbDeK4WunJjnP6UYA
         fxQyyzlmKvNlx4snD/KSycGGlb9V9dN/TQNfKNURgBWOlMRIJXtZ1FWyS2uVTwjXnvPW
         R9BUhdAg26A0ifVDOSW/kgFgMLsOY8Tnc80qMngm+8PceW6uZJYQ39HSQtfd54AUTLFS
         gLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/fduF09yM7vuP+WIo3gczCgW86zcHAmHOB9GlTh+hfA=;
        b=Rct4MeZ6BwYEk4UpmC1416vrJA/BCZv+H811KE5ukjaQmI6mAKYENAxdnD/sg+ih/C
         wGp9EZTOqbBorFxIDMGbDvOl7mrIeb7SWIW73SIDU77/FpBygcRUClnLySN3yBC2ex8X
         alawy8XpDd5QCVwZrGdHNHxBxAxich0/tcQnFR17UB8D6u/jEN1groMDNDH5JeT13ZkF
         ut65HXgsGfajM51HNt+NmC3Do9GbuCNa/7YLp8/2bnPseo/2y+GZbFr1zJMJyKRwo66C
         IctMFh6g+m5D5ViCs7cKdiFBtpqWntxTaUHaybMPabDgiyNsPRlJE+5xTZIHXEMMn503
         0RgQ==
X-Gm-Message-State: AOAM530LTba+FFjp+ZLTZnYTuEP+jXxoOHm7X2sj/oHUP4uSu/0xj1MX
        7/Tw7KLtzyVVWmhPPeA7Q3UEa6g/Cls=
X-Google-Smtp-Source: ABdhPJyJJmBv0bPJEFldWnZVeCAKEDBfKwvDPK+zYZMoVTIdKHbzYw7wl2vzpknPZdSSY/rWG/mnTw==
X-Received: by 2002:a6b:6c0c:: with SMTP id a12mr15283601ioh.40.1602460606890;
        Sun, 11 Oct 2020 16:56:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:85e0:a5a2:ceeb:837])
        by smtp.googlemail.com with ESMTPSA id h184sm6530152ioa.34.2020.10.11.16.56.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 16:56:46 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] l3mdev icmp error route lookup fixes
From:   David Ahern <dsahern@gmail.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Michael Jeanson <mjeanson@efficios.com>
Cc:     linux-kernel@vger.kernel.org
References: <20200925200452.2080-1-mathieu.desnoyers@efficios.com>
 <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com>
Message-ID: <19cf586d-4c4e-e18c-cd9e-3fde3717a9e1@gmail.com>
Date:   Sun, 11 Oct 2020 17:56:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <fd970150-f214-63a3-953c-769fa2787bc0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/5/20 9:30 AM, David Ahern wrote:
> On 9/25/20 1:04 PM, Mathieu Desnoyers wrote:
>> Hi,
>>
>> Here is an updated series of fixes for ipv4 and ipv6 which which ensure
>> the route lookup is performed on the right routing table in VRF
>> configurations when sending TTL expired icmp errors (useful for
>> traceroute).
>>
>> It includes tests for both ipv4 and ipv6.
>>
>> These fixes address specifically address the code paths involved in
>> sending TTL expired icmp errors. As detailed in the individual commit
>> messages, those fixes do not address similar icmp errors related to
>> network namespaces and unreachable / fragmentation needed messages,
>> which appear to use different code paths.
>>
>> The main changes since the last round are updates to the selftests.
>>
> 
> This looks fine to me. I noticed the IPv6 large packet test case is
> failing; the fib6 tracepoint is showing the loopback as the iif which is
> wrong:
> 
> ping6  8488 [004]   502.015817: fib6:fib6_table_lookup: table 255 oif 0
> iif 1 proto 58 ::/0 -> 2001:db8:16:1::1/0 tos 0 scope 0 flags 0 ==> dev
> lo gw :: err -113
> 
> I will dig into it later this week.
> 

I see the problem here -- source address selection is picking ::1. I do
not have a solution to the problem yet, but its resolution is
independent of the change in this set so I think this one is good to go.
