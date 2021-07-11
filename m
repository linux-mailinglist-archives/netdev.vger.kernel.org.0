Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A4A3C3DED
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 18:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhGKQ0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 12:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhGKQ0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 12:26:35 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5568C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:23:47 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id w15-20020a056830144fb02904af2a0d96f3so15802490otp.6
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 09:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B3CqA+AxSniV0MpzXT5ucyWp/lZXKZaZKilQOTJs1Jo=;
        b=YjVfbavdkHi0b/6WiHx1EvC2B4i1WpNAmR1d04phBa2u2uAtKHaaiZmHoyKhuZXGpU
         DFMta0xB1xyMVQ9FSp5Cq2z+9jIh39udr0i3VmifaHa8eLcYSMREvPQohlIHJLTz3k5L
         JvhqOEFVtnxnqSlsDm0ELSw8cg2MUO3CX8c/C1o0looau9YylpoOnPGtb1eSIfwhbm/N
         VdGBjKbi1RRp14iNiq8CKig6Xp/3Kr5gMZQE11QWb3n75l8Wt5IhJ+A3gLlYPOvvNGHZ
         kqkdokN0M1UIEcRCAcdslgePTFKh0oUkPENu68Ze+TeiXF4Cx2+BBIuW7nBWmQmLh7vF
         g7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B3CqA+AxSniV0MpzXT5ucyWp/lZXKZaZKilQOTJs1Jo=;
        b=T2fpt5dLM/+9/IzrtbpqWL99UJXhRpxmJdOnDLIN5upNiECWUnNYwHQv/NeloBqYMt
         /eHYwytAYeDIzqq/SLqXdwSPDZZmXFjDvEAu8f00qb3xYn5aFavUx7h+/zloqTl6JuJl
         RgCk+fB60MUsTaR3w67mhvj9Qaxa/ITa9uhoM9Lz6ANcHoe7vt0j+EH+WkFFnbRuBnzl
         NicDkJW+3WbQ9tugfxZGcMmETKLmyWIHa4L0hWMmSlBp7MqUj63WoUqaoDRbwS/H3oDI
         8kEkm8LEHhpoL0oUy7MbSJpsXFF5MSuv5WwwVvFHW3bKdYXHYclDG+FAYEGR0+paPFtw
         slHw==
X-Gm-Message-State: AOAM531aNOPGJY02MhBun1qaUNqANDGEP113Uc47GCGRo+Ap1312uwEP
        5pQmnSihUC9Atg1iO7jlkhE=
X-Google-Smtp-Source: ABdhPJy/OMO+VhJFVf17vpdzjdgyUBMWAr9dg5kVuF1lqYIk5+aWZdR9K5eMFugpxRXR5UII8ez8Kw==
X-Received: by 2002:a9d:5f07:: with SMTP id f7mr37334186oti.183.1626020626792;
        Sun, 11 Jul 2021 09:23:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id w26sm2528301oth.75.2021.07.11.09.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 09:23:46 -0700 (PDT)
Subject: Re: [PATCH net-next 1/2] net: ipv6: introduce
 ip6_dst_mtu_maybe_forward
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
References: <20210705213617.18317-1-vfedorenko@novek.ru>
 <20210705213617.18317-2-vfedorenko@novek.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <897c968b-866f-b5c3-7f59-eab0c92f166b@gmail.com>
Date:   Sun, 11 Jul 2021 10:23:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210705213617.18317-2-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/5/21 3:36 PM, Vadim Fedorenko wrote:
> Replace ip6_dst_mtu_forward with ip6_dst_mtu_maybe_forward and
> reuse this code in ip6_mtu. Actually these two functions were
> almost duplicates, this change will simplify the maintaince of
> mtu calculation code.
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>  include/net/ip6_route.h            |  5 +++--
>  net/ipv6/ip6_output.c              |  2 +-
>  net/ipv6/route.c                   | 20 +-------------------
>  net/netfilter/nf_flow_table_core.c |  2 +-
>  4 files changed, 6 insertions(+), 23 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


