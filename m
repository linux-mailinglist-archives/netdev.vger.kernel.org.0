Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AF03B4FC6
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhFZRwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 13:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhFZRwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 13:52:45 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1484CC061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 10:50:23 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id 84so15626198oie.2
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 10:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6oyYvhzpMBs1oA/LyhswQ7TCrA8VtFQRAh/hvCIT0po=;
        b=TyeQ5DBZ8r7CrRXl2PmOPb5kpK7u5qjEzBhCFxje+tSE3eSdnPqfl44C3HgBOl+3dH
         snwlKdtjenDcZ8u4MDtk1JQ1A2fybc08zX962QIyewwU6pfV3PXdaEJdmKG3SDq5xUwH
         aFwnQ+7CAW4ch3Q2rcRdIRaOs54bO9UsB5zCzLWrCto/R0O/5CJ1/KaVe4Noc8xryKsI
         H/w8Qn3iGJj2HE9Dp1fcCFh4+sIsYZAyw5ON1Ot8Qs1v04PwZ+vnU6RnfcnAzGeO1tfr
         93WD1ImobM+izBtTZo4CchzB1z6OO2a1eHQcp6nXh59+3ga5za8aDc8BRqTs1jXxa1Bn
         7j0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6oyYvhzpMBs1oA/LyhswQ7TCrA8VtFQRAh/hvCIT0po=;
        b=OtglQIQYECQNu9qakEfwFJH0ZcAcLKXdekTaUTxwIrhYrSbmHgZN/40IfVeT9n0W2h
         qDZzC1/pR2qO76SZCvjpZ7fLDCtEenLruEodw/L1byPIAsBGMrkguMpFg88Ye6VA6p8h
         S5Sbtu5jERYidNYwCxYo8+o5fIUyhtHzlHYwsmEQXy7m5QLKy1UZztI/rSo2pGNG6siw
         IKchjjs3dtUGXPAKpv6ziKt4HU1plbtuVsSVQjcSjKxzkvYCvyaz+LrZR6pH31jKC5SI
         VO69r7EOP1sBCfvUV+VhwTgMuvuKpVtiWR2WAqX58CIXdFjxRC8pRPXD3CUR0en4E1ER
         Btlg==
X-Gm-Message-State: AOAM5337wMYhGIJjXj+T/AeIkjIc71m72fCejfh2NQcVnts7PBYyVOTn
        LifVmeQ9ZYG1k1OE1sC/k7c=
X-Google-Smtp-Source: ABdhPJyVOXs83Nw7TwytgmnWEC+XGn7pQ0euZvj3eRf3I/VE4xmS2dC32FT0GYV/cgJlTk4I9MZF0g==
X-Received: by 2002:aca:4302:: with SMTP id q2mr446053oia.111.1624729822270;
        Sat, 26 Jun 2021 10:50:22 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id m8sm1526480oie.33.2021.06.26.10.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 10:50:21 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] net: reset MAC header consistently across L3
 virtual devices
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Eli Cohen <elic@nvidia.com>, Jiri Benc <jbenc@redhat.com>,
        Tom Herbert <tom@herbertland.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        Andreas Schultz <aschultz@tpip.net>,
        Jonas Bonn <jonas@norrbonn.se>
References: <cover.1624572003.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <84fe4ab5-4a80-abf8-675f-29a2f8389b1a@gmail.com>
Date:   Sat, 26 Jun 2021 11:50:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1624572003.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/21 7:32 AM, Guillaume Nault wrote:
> Some virtual L3 devices, like vxlan-gpe and gre (in collect_md mode),
> reset the MAC header pointer after they parsed the outer headers. This
> accurately reflects the fact that the decapsulated packet is pure L3
> packet, as that makes the MAC header 0 bytes long (the MAC and network
> header pointers are equal).
> 
> However, many L3 devices only adjust the network header after
> decapsulation and leave the MAC header pointer to its original value.
> This can confuse other parts of the networking stack, like TC, which
> then considers the outer headers as one big MAC header.
> 
> This patch series makes the following L3 tunnels behave like VXLAN-GPE:
> bareudp, ipip, sit, gre, ip6gre, ip6tnl, gtp.
> 
> The case of gre is a bit special. It already resets the MAC header
> pointer in collect_md mode, so only the classical mode needs to be
> adjusted. However, gre also has a special case that expects the MAC
> header pointer to keep pointing to the outer header even after
> decapsulation. Therefore, patch 4 keeps an exception for this case.
> 
> Ideally, we'd centralise the call to skb_reset_mac_header() in
> ip_tunnel_rcv(), to avoid manual calls in ipip (patch 2),
> sit (patch 3) and gre (patch 4). That's unfortunately not feasible
> currently, because of the gre special case discussed above that
> precludes us from resetting the MAC header unconditionally.

What about adding a flag to ip_tunnel indicating if it can be done (or
should not be done since doing it is the most common)?

> 
> The original motivation is to redirect bareudp packets to Ethernet
> devices (as described in patch 1). The rest of this series aims at
> bringing consistency across all L3 devices (apart from gre's special
> case unfortunately).

Can you add a selftests that covers the use cases you mention in the
commit logs?


