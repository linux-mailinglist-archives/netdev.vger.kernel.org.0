Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1914401CF
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhJ2SZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhJ2SZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 14:25:20 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE87C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 11:22:51 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o4so14545732oia.10
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VHH+BQifiZRnT3dycfVFY91BntqwTooPfVatuLJ7EfM=;
        b=gje33FzmtRtGOSoMMW2yCc/JK6U0DJ7fU/q7Pgf3URuxb2xW7mzjUvP9VcxhNDIsZS
         J0RakgxUpvuRoB/xusPZINFmrX54DwfwwWDNIobOm/WBJGg6pEb683ONdx5bzEHbIs0T
         xppCNh23QbrntCLqgHOqH18d8Dws+K1EOJUgA3hNZhDfl7361EJgroAGveWqDe8xLAsA
         ZpHJ++xKNTBcapagM2sFFx4BtbL/sbD7MA2d6P62GzHC8EIFg+NR3qoubzklaN36hRHC
         Pp7tF/gDD2yESNvfAGioVQ+I1V0btDNQ9JGN6IaiqErtS02xdwzLB5BZcqitVczhsa6x
         sQ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VHH+BQifiZRnT3dycfVFY91BntqwTooPfVatuLJ7EfM=;
        b=uq2XF5RP5wQhgXbKku3M/io66bDwJuO8zZ71JBEBWv0KPGnp3cZJIFU3KpaQBwQZeD
         E8DN5NSQmGcSDZQ49AoG3/4iAxZDV7ASNlLs9rWbbQn2+YA/yaMHeYW0y9WCyGKhzuDJ
         WydojXsVuiFlJrO8Y/hobDgZTYz/ouwe0FWvGKkZ5xJ7JAvvaUWIQRyxJJKQ76Zf3RUl
         zdSl0te0k2wS2A0BySI38BV3Z5JNcTprXdTeUJUprTdMqHuoGAw/O+h0/8RgBMgAd5SW
         LhhklLsc6HGd+mx5bC/9Su75+SQWMPNKqU2jPaLdO+iCy4vRiseZv00n3BrPmq1IDaO4
         8Wag==
X-Gm-Message-State: AOAM531sbzMzkbEBd2+hujrHnZ+HapulKv5kDx1b061cUP3dwpI1XBpV
        HQZZWTDtmAy50vlQN+XmyO+DVyonRWs=
X-Google-Smtp-Source: ABdhPJzkxt2qBoVhJJ5c9MYdUtC4FF9PGi8TEuZEOUYNxN1RNWyV3/NNW5r7qAU4QEPyovcvwTdHTg==
X-Received: by 2002:aca:100e:: with SMTP id 14mr9473195oiq.72.1635531770744;
        Fri, 29 Oct 2021 11:22:50 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id f10sm2333034otc.26.2021.10.29.11.22.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 11:22:50 -0700 (PDT)
Message-ID: <ff189fbe-7b72-44ec-266e-1613930fb8cf@gmail.com>
Date:   Fri, 29 Oct 2021 12:22:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH net 1/2] udp6: allow SO_MARK ctrl msg to affect routing
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        willemb@google.com
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Xintong Hu <huxintong@fb.com>
References: <20211029155135.468098-1-kuba@kernel.org>
 <20211029155135.468098-2-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211029155135.468098-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 9:51 AM, Jakub Kicinski wrote:
> Commit c6af0c227a22 ("ip: support SO_MARK cmsg")
> added propagation of SO_MARK from cmsg to skb->mark.
> For IPv4 and raw sockets the mark also affects route
> lookup, but in case of IPv6 the flow info is
> initialized before cmsg is parsed.
> 
> Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> Reported-and-tested-by: Xintong Hu <huxintong@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv6/udp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

