Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF22ABC60
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733110AbgKINgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732416AbgKINgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:36:46 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FB8C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 05:36:45 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id n5so8262126ile.7
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 05:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hfk8kyBYhxKkGRwHn7XHXw6Umn/AY2R8En7BdB9972U=;
        b=ImIKuA5EjY+A/mCGf8NaL8bRLp5GQBqFh3g2zT6h6YPO2Y0+DNn3GHC7c/IKKSdNHB
         +d5uFobFp1dCIDfmCETsiXWwHe59/Wcd8SKUt7BRv+PT5gf1AgLstdj+Az4/v5uyGj1j
         P1jqU9N762ysbX8ARls8gBLlEG4YCjn0IAxf8q1pWZhlyJRYrXXG+46Mk6YFpDmTkr8f
         c2UcbC805dDF6OXo5kVXBet/vFq08RzoPGNGFeIhdRpiJVTRDBIg5rfQwcQ2AOhJGta8
         tzPOaAwBktRETObKK2bjoKe99CqrBiJ63pCOicpENTN6OK+WUZNt+4MWMtCSfHsr2s2a
         l86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hfk8kyBYhxKkGRwHn7XHXw6Umn/AY2R8En7BdB9972U=;
        b=dJgeUvXiDG0kfoH3g3oVsyP5dmlf0G3wUskxykRqInrzKNsn5XILOcN8jUFtMYy0Jt
         Q6Kk5NDU5zIPYnoLawVNmfwsZTS3QyWmQkAwDHvvcOEssDKwzSW4W1bcuLRld2V0X4q5
         eaJU2IpOdK/HF+M6tQlxiU426ShkydSKsEjEhbn58HGMUVziSr4/4dG2nWCt23ybnw/h
         sgYavKOLj2wd23CoDR62n5RR2nFf1xGMHTqKxuXE/ha8jNvLNDVN6MB6fWoRJYGfTRXW
         CCPxfvwnafYj7YN/LYZ9W/bPd0HzBr2InCQchqdMx2uJqc+X9VpG6uRMZzeDMuHP5yG+
         ARmA==
X-Gm-Message-State: AOAM533EWSh3ndtZrgyX2ll4qeV6Uw3o6gUQOxiJiC/ui9ZTV298XjKA
        THlRiFU0t/8ccDrMRNB/V/yPGw9/sMW6DYGi7GKfSg==
X-Google-Smtp-Source: ABdhPJyjwCNqDorGY2SsoiKJYgyaM1r1ZLZlyUAvFGznUs/LPEKgmw+MSfJ9hjXYOj4uGpUwD/Plpul/I/r30FT6iC8=
X-Received: by 2002:a92:6f11:: with SMTP id k17mr10114518ilc.69.1604929004839;
 Mon, 09 Nov 2020 05:36:44 -0800 (PST)
MIME-Version: 1.0
References: <5fa93ef0.1c69fb81.bff98.2afc@mx.google.com>
In-Reply-To: <5fa93ef0.1c69fb81.bff98.2afc@mx.google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 14:36:33 +0100
Message-ID: <CANn89iJNYyON8khtQYzZi2LdV1ZSopGfnXB1ev9bZ2cDUdekHw@mail.gmail.com>
Subject: Re: [PATCH] net: tcp: ratelimit warnings in tcp_recvmsg
To:     menglong8.dong@gmail.com
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 2:07 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <dong.menglong@zte.com.cn>
>
> 'before(*seq, TCP_SKB_CB(skb)->seq) == true' means that one or more
> skbs are lost somehow. Once this happen, it seems that it will
> never recover automatically. As a result, a warning will be printed
> and a '-EAGAIN' will be returned in non-block mode.
>
> As a general suituation, users call 'poll' on a socket and then receive
> skbs with 'recv' in non-block mode. This mode will make every
> arriving skb of the socket trigger a warning. Plenty of skbs will cause
> high rate of kernel log.
>
> Besides, WARN is for indicating kernel bugs only and should not be
> user-triggable. Replace it with 'net_warn_ratelimited' here.
>
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

I do not think this patch is useful. That is simply code churn.

Can you trigger the WARN() in the latest upstream version ?
If yes this is a serious bug that needs urgent attention.

Make sure you have backported all needed fixes into your kernel, if
you get this warning on a non pristine kernel.
