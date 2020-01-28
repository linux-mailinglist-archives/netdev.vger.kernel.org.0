Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B31D14BE53
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 18:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgA1RH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 12:07:56 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:42462 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgA1RH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 12:07:56 -0500
Received: by mail-yb1-f194.google.com with SMTP id z125so4963509ybf.9
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 09:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=89ZztVz1GhyxUtVXR8FrfEaNg9iKH8MTtJtIh/D3ZCs=;
        b=HMLS0Z4JZ/Nt7Pg7jW7cZhW4jGsECX4lWahZx9qZouMIoJG9HKdOxDSAG26H5R4LP9
         giv0xb5QNkPWf7GnrkNP0NuGdKdgtM1JLYgvY0IHYTHq1RAAyGgToCpVczr60QpBebYh
         U93Ud6SJ1ORl4psf2FsLD/KTVWY8GczAfNkRNKL7VW4jthg+YmmluTud/cSLn5/5Rb/w
         sW8Ri7uq9nFX35t27wyxw7eeiP2iT1tBQm1nVHsNpW8zjZsDRBmJFpg/ZWcGYjXslPZc
         imyaNFmiVS0Xacifar6l09LUdI5YP/EOdPb+hmf78t8Muh7lmMA7pGBwZ1PH8BrhE3f0
         r3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=89ZztVz1GhyxUtVXR8FrfEaNg9iKH8MTtJtIh/D3ZCs=;
        b=dnYntbro7MkkixBLI+u5VQqXP69WcspukEAaWNkk4wzc+Aa3jXOvEY6IHvmMkcgypA
         BdA4/pH0rqNyc4TxMaEbGdeBWdp3c0K7DGq0xtxpu8xy2EXs7o28FhJLXAP804Z6RqTE
         YM9+7gXlxyhL5cmsfiovVoyJ6m3h5O2wwmA29ssRC8x1YLE87bH2HviMPiE16aaWO2jB
         pdOCmeCgFcbxL4WOvsJT4LlDdvIhy7IHkAbF9ONBmjwFmPFkcjkFaCGKPPZK6eakN1Pw
         rb+DvZC2r7ecYU7aRi+nC5StVs6BQpAi4w44owkqbhAzLJFLDd5PKUeH6jEu8rp12/Pl
         Tmrw==
X-Gm-Message-State: APjAAAWR4YqqOX2Q9plAiJ6fgus8/zsXFpqpqYg3kbia52wO5d7Wlh2G
        mMcC3VYE7z+yxMyKr4AHMIGv3Fyo
X-Google-Smtp-Source: APXvYqxq9Xsoun6goP4nWO2Ubb7Xn+Eph+5wL8aG6A/HMGpA3mSBqLKHDZ5nqX1Wc5AxCfnY0I9yxw==
X-Received: by 2002:a25:7601:: with SMTP id r1mr18312211ybc.187.1580231274605;
        Tue, 28 Jan 2020 09:07:54 -0800 (PST)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id q16sm8315367ywa.110.2020.01.28.09.07.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 09:07:53 -0800 (PST)
Received: by mail-yw1-f45.google.com with SMTP id v126so6808926ywc.10
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 09:07:53 -0800 (PST)
X-Received: by 2002:a81:6f85:: with SMTP id k127mr17949041ywc.507.1580231272780;
 Tue, 28 Jan 2020 09:07:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1580205811.git.martin.varghese@nokia.com>
In-Reply-To: <cover.1580205811.git.martin.varghese@nokia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 28 Jan 2020 12:07:16 -0500
X-Gmail-Original-Message-ID: <CA+FuTSf366JXT8JRZY6DMdHF2UnTCya9Z+b6cWQGXaenrd75AQ@mail.gmail.com>
Message-ID: <CA+FuTSf366JXT8JRZY6DMdHF2UnTCya9Z+b6cWQGXaenrd75AQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 0/2] Bare UDP L3 Encapsulation Module
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 11:57 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> From: Martin Varghese <martin.varghese@nokia.com>
>
> There are various L3 encapsulation standards using UDP being discussed to
> leverage the UDP based load balancing capability of different networks.
> MPLSoUDP (__ https://tools.ietf.org/html/rfc7510) is one among them.
>
> The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
> support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
> a UDP tunnel.
>
> Special Handling
> ----------------
> The bareudp device supports special handling for MPLS & IP as they can have
> multiple ethertypes.
> MPLS procotcol can have ethertypes ETH_P_MPLS_UC  (unicast) & ETH_P_MPLS_MC (multicast).
> IP protocol can have ethertypes ETH_P_IP (v4) & ETH_P_IPV6 (v6).
> This special handling can be enabled only for ethertypes ETH_P_IP & ETH_P_MPLS_UC
> with a flag called multiproto mode.
>
> Usage
> ------
>
> 1) Device creation & deletion
>
>     a) ip link add dev bareudp0 type bareudp dstport 6635 ethertype 0x8847.
>
>        This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
>        0x8847 (MPLS traffic). The destination port of the UDP header will be set to
>        6635.The device will listen on UDP port 6635 to receive traffic.
>
>     b) ip link delete bareudp0
>
> 2) Device creation with multiple proto mode enabled
>
> There are two ways to create a bareudp device for MPLS & IP with multiproto mode
> enabled.
>
>     a) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 multiproto
>
>     b) ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls
>
> 3) Device Usage
>
> The bareudp device could be used along with OVS or flower filter in TC.
> The OVS or TC flower layer must set the tunnel information in SKB dst field before
> sending packet buffer to the bareudp device for transmission. On reception the
> bareudp device extracts and stores the tunnel information in SKB dst field before
> passing the packet buffer to the network stack.
>
> Why not FOU ?
> ------------
> FOU by design does l4 encapsulation.It maps udp port to ipproto (IP protocol number for l4 protocol).
> Bareudp acheives a generic l3 encapsulation.It maps udp port to l3 ethertype.
>
> Martin Varghese (2):
>   net: UDP tunnel encapsulation module for tunnelling different
>     protocols like     MPLS,IP,NSH etc.
>   net: Special handling for IP & MPLS.

>
>  Documentation/networking/bareudp.rst |  53 +++
>  Documentation/networking/index.rst   |   1 +
>  drivers/net/Kconfig                  |  13 +
>  drivers/net/Makefile                 |   1 +
>  drivers/net/bareudp.c                | 803 +++++++++++++++++++++++++++++++++++
>  include/net/bareudp.h                |  20 +
>  include/net/ipv6.h                   |   6 +
>  include/net/route.h                  |   6 +
>  include/uapi/linux/if_link.h         |  12 +
>  net/ipv4/route.c                     |  48 +++
>  net/ipv6/ip6_output.c                |  70 +++
>  11 files changed, 1033 insertions(+)
>  create mode 100644 Documentation/networking/bareudp.rst
>  create mode 100644 drivers/net/bareudp.c
>  create mode 100644 include/net/bareudp.h

net-next is currently closed, see also
http://vger.kernel.org/~davem/net-next.html
