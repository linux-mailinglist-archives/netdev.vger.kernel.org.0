Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE892EFBB5
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 00:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbhAHXcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 18:32:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbhAHXcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 18:32:17 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F75C061757
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 15:31:37 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y24so12816632edt.10
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 15:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3wGEgyLXu21aIj53cUJUBAvDrdd24BRg3uMBnuiKUnE=;
        b=IqZcSylzfc8Ke6rDN8PpNyMBlp5EriJFj0ZptwXXnExkZD/Bdz7B6qvqdHLBYj5tBh
         zKcMT3Ew3arFUKXQNYl7jCIUx7dMfZirYud58N3eqDjOTg6I0xN1aRNwFONvzMhRycFo
         78Wxp8uPzWJk4UKHj/km6KfYEOpfSuuL9VeNq8d4a5uvihADmLWf5sfKezE6q4PgPU8P
         w5o3FbeV9Tuip+2a8Dd3SU7GArjiSTLOBlruQVjvFz2ZpJ5bczxCAk16LUgxfAepGiZo
         xRv7YoZFUDrFavO1GR6HxLWKAGMH22eerDhONFv5jj1VIDfXLMVQwv0AJbBCmV7373l6
         22+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wGEgyLXu21aIj53cUJUBAvDrdd24BRg3uMBnuiKUnE=;
        b=TDeiPz8sVjaLupoZAkH8Fbwh8HeP14JAfN8HlQqR4QvLbrBl2eVtrjQ+TFrSuz1cE2
         iDQMAOouyV/XMcyYijnsfM++FnSTuY6dIrnC951JtaYAOHlzy47Orrtmq4VSs4TmoeeQ
         IQ0eT4SSE7Nd47GqQZTzIZosBa12MQ2uCcwHYk79AFsHuBm2Q1sb8ydx0OcNxEpB7Jjh
         yeNjiWW7vEaJFYwY623IQRP/nPGgex9qo9cDpXgSHGUeFIBYTRbU9j86+FgA7tXPCQP+
         W1poMO8ijRQZa90CEf6SpnMvZkqaR4w8CGjb2PiOUeaGFGgM1x3Pp9woK3LlMe/Qr2cz
         e83w==
X-Gm-Message-State: AOAM5302PYhkOc/ttJfylvYEq3q9LiwtGL5NL+LJqX9YCDPxsjHm/PBw
        03lq4UeRRTZvxxpBjvYLTHOQkxI0hMmv6UUmN4dACKCZecU=
X-Google-Smtp-Source: ABdhPJxz7UpHABIQIiir7w/mEhBtqesB8WpBftsyUgatQBQ3RIj25hZC/+U+wIaUqDvJi+CI09bB1UJAVVNLk4OszWI=
X-Received: by 2002:a50:ec18:: with SMTP id g24mr6780084edr.6.1610148695530;
 Fri, 08 Jan 2021 15:31:35 -0800 (PST)
MIME-Version: 1.0
References: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com> <20210108171152.2961251-3-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210108171152.2961251-3-willemdebruijn.kernel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 8 Jan 2021 18:30:59 -0500
Message-ID: <CAF=yD-JSFwV_zp1x_cWSk95txnkRb9GYMaHRvj4=Ypk-bcqUAA@mail.gmail.com>
Subject: Re: [PATCH net 2/3] net: compound page support in skb_seq_read
To:     Network Development <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 12:11 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> skb_seq_read iterates over an skb, returning pointer and length of
> the next data range with each call.
>
> It relies on kmap_atomic to access highmem pages when needed.
>
> An skb frag may be backed by a compound page, but kmap_atomic maps
> only a single page. There are not enough kmap slots to always map all
> pages concurrently.
>
> Instead, if kmap_atomic is needed, iterate over each page.
>
> As this increases the number of calls, avoid this unless needed.
> The necessary condition is captured in skb_frag_must_loop.
>
> I tried to make the change as obvious as possible. It should be easy
> to verify that nothing changes if skb_frag_must_loop returns false.
>
> Tested:
>   On an x86 platform with
>     CONFIG_HIGHMEM=y
>     CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y
>     CONFIG_NETFILTER_XT_MATCH_STRING=y
>
>   Run
>     ip link set dev lo mtu 1500
>     iptables -A OUTPUT -m string --string 'badstring' -algo bm -j ACCEPT
>     dd if=/dev/urandom of=in bs=1M count=20
>     nc -l -p 8000 > /dev/null &
>     nc -w 1 -q 0 localhost 8000 < in
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

I don't have a clear Fixes tag for this.

That was also true for commit c613c209c3f3 ("net: add
skb_frag_foreach_page and use with kmap_atomic"), which deals with the
same problem in a few other functions.

It goes back to when compound highmem pages may have appeared in the
skb frag. Possibly with vmsplice, around 2006. The skb_seq_read
interface itself was added in 2005.
