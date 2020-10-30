Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DCA2A1172
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 00:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJ3XNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 19:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgJ3XNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 19:13:33 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20058C0613D5
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 16:13:33 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id x26so2230871uau.0
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 16:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jhnkn6O+IBJivpm4x45o0hEsUEHyyIRA6UM1WrSAjs=;
        b=lLLAgBHaHCEENE9FMdwW1DQz9gtsQiu6Wk1fJ3/7x++D6gr+t+TutBPoWNPMDmHZSQ
         uiHS2fUC2i2h4d0hInc8uJNC0FziubFkdrHFvv+zvJn/DjAERWbIwR0v7puFUM8coQ2h
         G8myr1RD22yxBijkDZpfKujrWZvGNo8TNNa+GWNxdHlgovInuheNmueUCkXESUTwMztY
         0lNLGfvBNiVmqjczpXaD59Lm4A/RW/w3ecyb7y5lTKsRnDTtHbNW5lXhKiqnI/5YxSxd
         51YROmY8VPJyV85fQysrOeQ91e9oiaPWSLLQWvtuxBSu6FUo6OSC3mfIgaeXkoOnbkBB
         2S1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jhnkn6O+IBJivpm4x45o0hEsUEHyyIRA6UM1WrSAjs=;
        b=rZH51ad3KaMH91NQ2/CJt7tc7d+jIGI9qQXGCsS0OioeTGBqpSYw2RJ9rkiMmGTcjG
         0k67pg0MKP4S3ERENJfCf8gw9ijFd57OrtuZfJz+AyOyD2vlKLpD47MLYEujR7ehJzNv
         VemWS+wJ/JaH50l1me+jfiUgVQ1BHqF7SbAZvk1rEjKwc95BZAT2Iojcwo9v4XTvxRKs
         FyJHxUSZgOYlwHiNdgJPxiJ+XZxfvltf5KEogke042T19NPqZqiSsiQUXNOKoBjFt/D0
         2AoRhN9NpCf+HEa8lYaWa8Bi22Mlmg2dNjMqdonAP2cTnbwh2At3EGis/3SIw16MysrQ
         e2Kg==
X-Gm-Message-State: AOAM532OCR3tzKVIMi2F0OmO1cv7S3OYmjMMnWzGerFdKnV8Ff9C5rhl
        odjUl0Kw12EjN1s88eQlRx3SuwXAjP4=
X-Google-Smtp-Source: ABdhPJzeIBQQUhNxVTskcSwSEujYUDXeSgWJCXOlVWJK2HNXzYidZY7Wpm7olM0hAzc9EvO9dHo7AQ==
X-Received: by 2002:ab0:3721:: with SMTP id s1mr1613116uag.92.1604099611421;
        Fri, 30 Oct 2020 16:13:31 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id r7sm927676vkf.13.2020.10.30.16.13.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 16:13:30 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id d19so4268429vso.10
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 16:13:30 -0700 (PDT)
X-Received: by 2002:a67:7704:: with SMTP id s4mr8879367vsc.51.1604099609967;
 Fri, 30 Oct 2020 16:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch>
In-Reply-To: <Mx3BWGop6fGORN6Cpo4mHIHz2b1bb0eLxeMG8vsijnk@cp3-web-020.plabs.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 30 Oct 2020 19:12:52 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdiqaZJ3HQHuEEMwKioWGKvGwZ42Oi7FpRf0hqWdZ27pQ@mail.gmail.com>
Message-ID: <CA+FuTSdiqaZJ3HQHuEEMwKioWGKvGwZ42Oi7FpRf0hqWdZ27pQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: avoid unneeded UDP L4 and fraglist GSO resegmentation
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Antoine Tenart <atenart@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 2:33 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> Commit 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.") added a support
> for fraglist UDP L4 and fraglist GSO not only for local traffic, but also
> for forwarding. This works well on simple setups, but when any logical
> netdev (e.g. VLAN) is present, kernel stack always performs software
> resegmentation which actually kills the performance.
> Despite the fact that no mainline drivers currently supports fraglist GSO,
> this should and can be easily fixed by adding UDP L4 and fraglist GSO to
> the list of GSO types that can be passed-through the logical interfaces
> (NETIF_F_GSO_SOFTWARE). After this change, no resegmentation occurs (if
> a particular driver supports and advertises this), and the performance
> goes on par with e.g. 1:1 forwarding.
> The only logical netdevs that seem to be unaffected to this are bridge
> interfaces, as their code uses full NETIF_F_GSO_MASK.
>
> Tested on MIPS32 R2 router board with a WIP NIC driver in VLAN NAT:
> 20 Mbps baseline, 1 Gbps / link speed with this patch.
>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  include/linux/netdev_features.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index 0b17c4322b09..934de56644e7 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -207,8 +207,8 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>                                  NETIF_F_FSO)
>
>  /* List of features with software fallbacks. */
> -#define NETIF_F_GSO_SOFTWARE   (NETIF_F_ALL_TSO | \
> -                                NETIF_F_GSO_SCTP)
> +#define NETIF_F_GSO_SOFTWARE   (NETIF_F_ALL_TSO | NETIF_F_GSO_SCTP |        \
> +                                NETIF_F_GSO_UDP_L4 | NETIF_F_GSO_FRAGLIST)

What exactly do you mean by *re*segmenting?

I think it is fine to reenable this again, now that UDP sockets will
segment unexpected UDP GSO packets that may have looped. We previously
added general software support in commit 83aa025f535f ("udp: add gso
support to virtual devices"). Then reduced its scope to egress only in
8eea1ca82be9 ("gso: limit udp gso to egress-only virtual devices") to
handle that edge case.

If we can enable for all virtual devices again, we could revert those
device specific options.
