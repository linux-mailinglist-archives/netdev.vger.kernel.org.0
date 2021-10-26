Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4643D43B4C7
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbhJZOwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbhJZOwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:52:51 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A3BC061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:50:27 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r6so20951265oiw.2
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ToIszPTV0gVTDf9mb37fABQMMVVUKLxA3wv8zltwXUk=;
        b=VhgHu5Iyv0IxoUbjGNiWbTaYVjy+tEpgueF8dFbgt+7WUfBUALWYgKQU2CwPfeJh0+
         C5vhDvxmWJpj34QN1WWtsx6UuRjjIiLGvVIFAGx0fat1htL0Hoxyfl0kV4J+d+a5FLlb
         R3wc0eB8jXR7EEYn33HsQZRuFCG05+IjGURh769LgHgMnXqoHXtO39Mc3Iy3JR1pEqJm
         mfHLqD+2OhMTfprP52cBRUxwP73la4AWzHL9YVX4/M92V6bnN3icRPZfvmoY3dnKwdfr
         a2+RcGeqGAH7pHXlyOpSKf7oydjPUl0mpg9V1kW0bJGtC5bWHUb4LQrqShZxXf7+FGci
         V9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ToIszPTV0gVTDf9mb37fABQMMVVUKLxA3wv8zltwXUk=;
        b=Si/nq1Ze5GyAc6BXoRssFWWyXUfJBQVf3DWBO1TEqciUX4aULBSzQRIelvOFAl5EJ5
         i4eUIon24EoZwzEmeRyoOOxoZl3OM5jeuC0PPA6yYIYzQug++U0gDE8UpW5h0o79JcC5
         KHCUJ1di4Uyy3Svjok01J4DNeCOJ1Sr7vLGJd1ZXmMiD9cx7o3DHG7eJcha4GoFe0TpL
         LdaXpEhL7qSQGbW5icUTr+cCcl9x13Nu+Aft9bvgQvXkIHNGfiG8gpOmLY7aFKrEH/Gh
         zhhGXqI878q9Ohbuf7ygveTmfbKJ8tbMxkyo0z00QrDqXyYMdrKF1nRXzRkoWmY7AKvA
         nlJg==
X-Gm-Message-State: AOAM531h9BMuF9RrDnh+aoALcYiC/4g0wdPJklhLX3gBCW9dlC+1H9yF
        guOCajy53T1ws5tTADkuao0=
X-Google-Smtp-Source: ABdhPJy8wRilnL1SsEIRV5naqUiVaORTjja+Ytmq7o0U6w2UrUB/mF5VqY2i1DqSP05bwcQE0USVgA==
X-Received: by 2002:a05:6808:1444:: with SMTP id x4mr17794971oiv.157.1635259826692;
        Tue, 26 Oct 2021 07:50:26 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id l16sm3805126oou.7.2021.10.26.07.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Oct 2021 07:50:26 -0700 (PDT)
Message-ID: <d080507b-a5a8-aa8f-182f-1182a5405ec0@gmail.com>
Date:   Tue, 26 Oct 2021 08:50:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [RESEND PATCH v7 1/3] net: arp: introduce arp_evict_nocarrier
 sysctl parameter
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
References: <20211025164547.1097091-1-prestwoj@gmail.com>
 <20211025164547.1097091-2-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211025164547.1097091-2-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/21 10:45 AM, James Prestwood wrote:
> This change introduces a new sysctl parameter, arp_evict_nocarrier.
> When set (default) the ARP cache will be cleared on a NOCARRIER event.
> This new option has been defaulted to '1' which maintains existing
> behavior.
> 
> Clearing the ARP cache on NOCARRIER is relatively new, introduced by:
> 
> commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> Author: David Ahern <dsahern@gmail.com>
> Date:   Thu Oct 11 20:33:49 2018 -0700
> 
>     net: Evict neighbor entries on carrier down
> 
> The reason for this changes is to prevent the ARP cache from being
> cleared when a wireless device roams. Specifically for wireless roams
> the ARP cache should not be cleared because the underlying network has not
> changed. Clearing the ARP cache in this case can introduce significant
> delays sending out packets after a roam.
> 
> A user reported such a situation here:
> 
> https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/
> 
> After some investigation it was found that the kernel was holding onto
> packets until ARP finished which resulted in this 1 second delay. It
> was also found that the first ARP who-has was never responded to,
> which is actually what caues the delay. This change is more or less
> working around this behavior, but again, there is no reason to clear
> the cache on a roam anyways.
> 
> As for the unanswered who-has, we know the packet made it OTA since
> it was seen while monitoring. Why it never received a response is
> unknown. In any case, since this is a problem on the AP side of things
> all that can be done is to work around it until it is solved.
> 
> Some background on testing/reproducing the packet delay:
> 
> Hardware:
>  - 2 access points configured for Fast BSS Transition (Though I don't
>    see why regular reassociation wouldn't have the same behavior)
>  - Wireless station running IWD as supplicant
>  - A device on network able to respond to pings (I used one of the APs)
> 
> Procedure:
>  - Connect to first AP
>  - Ping once to establish an ARP entry
>  - Start a tcpdump
>  - Roam to second AP
>  - Wait for operstate UP event, and note the timestamp
>  - Start pinging
> 
> Results:
> 
> Below is the tcpdump after UP. It was recorded the interface went UP at
> 10:42:01.432875.
> 
> 10:42:01.461871 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
> 10:42:02.497976 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
> 10:42:02.507162 ARP, Reply 192.168.254.1 is-at ac:86:74:55:b0:20, length 46
> 10:42:02.507185 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 1, length 64
> 10:42:02.507205 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 2, length 64
> 10:42:02.507212 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 3, length 64
> 10:42:02.507219 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 4, length 64
> 10:42:02.507225 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 5, length 64
> 10:42:02.507232 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 6, length 64
> 10:42:02.515373 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 1, length 64
> 10:42:02.521399 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 2, length 64
> 10:42:02.521612 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 3, length 64
> 10:42:02.521941 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 4, length 64
> 10:42:02.522419 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 5, length 64
> 10:42:02.523085 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 6, length 64
> 
> You can see the first ARP who-has went out very quickly after UP, but
> was never responded to. Nearly a second later the kernel retries and
> gets a response. Only then do the ping packets go out. If an ARP entry
> is manually added prior to UP (after the cache is cleared) it is seen
> that the first ping is never responded to, so its not only an issue with
> ARP but with data packets in general.
> 
> As mentioned prior, the wireless interface was also monitored to verify
> the ping/ARP packet made it OTA which was observed to be true.
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  9 +++++++++
>  include/linux/inetdevice.h             |  2 ++
>  include/uapi/linux/ip.h                |  1 +
>  include/uapi/linux/sysctl.h            |  1 +
>  net/ipv4/arp.c                         | 11 ++++++++++-
>  net/ipv4/devinet.c                     |  4 ++++
>  6 files changed, 27 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

