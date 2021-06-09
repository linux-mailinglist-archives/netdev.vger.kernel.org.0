Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8723A08EA
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbhFIBS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:18:29 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:42992 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhFIBS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 21:18:29 -0400
Received: by mail-ot1-f47.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so17874066oth.9;
        Tue, 08 Jun 2021 18:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gc6LRAE93UAouk5r1UrRQsU79NB0S8R7+iG/4LiWPCc=;
        b=QzYmixMODh3QOA/deGZCdchRnjDAYO9awTNRffPjYvC92V6vK2pJm5/kOuJEFZTSfp
         RDAeeNcf9ciKKvyEqsbXIQdlvoQ45VtTmYWISfmrBHDfaIiUFt+8+P75EuCv41UGzrmI
         pRKs5LfRf1bN4S/QqCwyZrSWZEvbvnaktsZTcty2BU4syEYhYDuP0sll1JbM6FUpZC8f
         rJcHqOImjyvVI6VQFJe+hkr3W59D/ZE9rbiZhlegiRcqei7NmMV7pGf5PlWlXJiT0e5y
         pc+jQYn0DTzYyvNdRYZoy5zrJ8ziCutlQCwNuIgeXE+RDb5kDcgMj03puatwhcn4xvRY
         k9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gc6LRAE93UAouk5r1UrRQsU79NB0S8R7+iG/4LiWPCc=;
        b=MOo7CUBitXKb4HwTPR4RU/YAMv8hpDE8nUK+6LWkkAdRof+09IgO/zrxT51ljO6wxx
         RI+4tLTdF+/HjB2rC57NKDYDlmlREIYaUsxZmDH4FSN02ld9Pkpt8F8FU1QyVk9xzDYi
         sVq6joDizhcxAq7MajthlhNBALBD76uUO9Xq9GGN/ifHsGXw/kr3jS/n6SjqHx0zUtTj
         xWEK2JAeth4TDAt/u+rmoyCBIzcmtIxRxDey0gS7gBZ4dF10jQJFS8J255vsMXbzBZuO
         LvLGuBMWzu+6UvpbsB2mS4Ppyb/g/Cbo7J5HStu45mO8AL3Jm34367acJORjhUwbfn6K
         3bpA==
X-Gm-Message-State: AOAM530xYq+qqg4Z4STTWizlbASL8DBxCSk2W2rGYpYD5MahM8w2jRUT
        M/SL+YoqCXDVfknyoGfMcLw=
X-Google-Smtp-Source: ABdhPJyzKokATSCEHbzoP9aFIkQGIxZ5gd7X2QsYI4s5NhgD9lo9RumqlaVZqZ9eEiGh0eqU/e0DmQ==
X-Received: by 2002:a9d:541:: with SMTP id 59mr15538169otw.301.1623201321896;
        Tue, 08 Jun 2021 18:15:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x13sm3398105ote.70.2021.06.08.18.15.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 18:15:21 -0700 (PDT)
Subject: Re: [RFC net-next 1/2] seg6: add support for SRv6 End.DT46 Behavior
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20210608104017.21181-1-andrea.mayer@uniroma2.it>
 <20210608104017.21181-2-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <548983f7-a06c-ea80-0906-88231851bc17@gmail.com>
Date:   Tue, 8 Jun 2021 19:15:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210608104017.21181-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/8/21 4:40 AM, Andrea Mayer wrote:
> IETF RFC 8986 [1] includes the definition of SRv6 End.DT4, End.DT6, and
> End.DT46 Behaviors.
> 
> The current SRv6 code in the Linux kernel only implements End.DT4 and
> End.DT6 which can be used respectively to support IPv4-in-IPv6 and
> IPv6-in-IPv6 VPNs. With End.DT4 and End.DT6 it is not possible to create a
> single SRv6 VPN tunnel to carry both IPv4 and IPv6 traffic.
> 
> The proposed End.DT46 implementation is meant to support the decapsulation
> of IPv4 and IPv6 traffic coming from a single SRv6 tunnel.
> The implementation of the SRv6 End.DT46 Behavior in the Linux kernel
> greatly simplifies the setup and operations of SRv6 VPNs.
> 
> The SRv6 End.DT46 Behavior leverages the infrastructure of SRv6 End.DT{4,6}
> Behaviors implemented so far, because it makes use of a VRF device in
> order to force the routing lookup into the associated routing table.
> 
> To make the End.DT46 work properly, it must be guaranteed that the routing
> table used for routing lookup operations is bound to one and only one VRF
> during the tunnel creation. Such constraint has to be enforced by enabling
> the VRF strict_mode sysctl parameter, i.e.:
> 
>  $ sysctl -wq net.vrf.strict_mode=1
> 
> Note that the same approach is used for the SRv6 End.DT4 Behavior and for
> the End.DT6 Behavior in VRF mode.
> 
> The command used to instantiate an SRv6 End.DT46 Behavior is
> straightforward, i.e.:
> 
>  $ ip -6 route add 2001:db8::1 encap seg6local action End.DT46 vrftable 100 dev vrf100.
> 
> [1] https://www.rfc-editor.org/rfc/rfc8986.html#name-enddt46-decapsulation-and-s
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Performance and impact of SRv6 End.DT46 Behavior on the SRv6 Networking
> =======================================================================
> 
> This patch aims to add the SRv6 End.DT46 Behavior with minimal impact on
> the performance of SRv6 End.DT4 and End.DT6 Behaviors.
> In order to verify this, we tested the performance of the newly introduced
> SRv6 End.DT46 Behavior and compared it with the performance of SRv6
> End.DT{4,6} Behaviors, considering both the patched kernel and the kernel
> before applying the End.DT46 patch (referred to as vanilla kernel).
> 
> In details, the following decapsulation scenarios were considered:
> 
>  1.a) IPv6 traffic in SRv6 End.DT46 Behavior on patched kernel;
>  1.b) IPv4 traffic in SRv6 End.DT46 Behavior on patched kernel;
>  2.a) SRv6 End.DT6 Behavior (VRF mode) on patched kernel;
>  2.b) SRv6 End.DT4 Behavior on patched kernel;
>  3.a) SRv6 End.DT6 Behavior (VRF mode) on vanilla kernel (without the
>       End.DT46 patch);
>  3.b) SRv6 End.DT4 Behavior on vanilla kernel (without the End.DT46 patch).
> 
> All tests were performed on a testbed deployed on the CloudLab [2]
> facilities. We considered IPv{4,6} traffic handled by a single core (at 2.4
> GHz on a Xeon(R) CPU E5-2630 v3) on kernel 5.13-rc1 using packets of size
> ~ 100 bytes.
> 
> Scenario (1.a): average 684.70 kpps; std. dev. 0.7 kpps;
> Scenario (1.b): average 711.69 kpps; std. dev. 1.2 kpps;
> Scenario (2.a): average 690.70 kpps; std. dev. 1.2 kpps;
> Scenario (2.b): average 722.22 kpps; std. dev. 1.7 kpps;
> Scenario (3.a): average 690.02 kpps; std. dev. 2.6 kpps;
> Scenario (3.b): average 721.91 kpps; std. dev. 1.2 kpps;
> 
> Considering the results for the patched kernel (1.a, 1.b, 2.a, 2.b) we
> observe that the performance degradation incurred in using End.DT46 rather
> than End.DT6 and End.DT4 respectively for IPv6 and IPv4 traffic is minimal,
> around 0.9% and 1.5%. Such very minimal performance degradation is the
> price to be paid if one prefers to use a single tunnel capable of handling
> both types of traffic (IPv4 and IPv6).
> 
> Comparing the results for End.DT4 and End.DT6 under the patched and the
> vanilla kernel (2.a, 2.b, 3.a, 3.b) we observe that the introduction of the
> End.DT46 patch has no impact on the performance of End.DT4 and End.DT6.
> 
> [2] https://www.cloudlab.us
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  include/uapi/linux/seg6_local.h |  2 +
>  net/ipv6/seg6_local.c           | 94 +++++++++++++++++++++++++--------
>  2 files changed, 74 insertions(+), 22 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

