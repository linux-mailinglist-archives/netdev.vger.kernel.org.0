Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63121967C7
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 17:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgC1Q5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 12:57:10 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:38701 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgC1Q5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 12:57:10 -0400
Received: by mail-vs1-f67.google.com with SMTP id x206so8267979vsx.5
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 09:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhiFJBSZNtYSvVSvHZmFB6j429D2Xk9a0RkMHEiXG8c=;
        b=IpFBqYydKO4X5tjZdF6/ZSTKxEeM4WlIS+ChGXQtJZy6GTvXCdyL5j9abJnkh8lpj7
         YbRntbJc/li2sXz0p7VnDRVStfetfIIK0Z3oxhLGQMrur1diTBse//y5dNZauZQlUqTA
         2TtgDESP1R/glkc4qtp1x4YUlOMl0OAqyXob9jKHbQCpN7/hq3LZTYnjiHDIk+Zjr/Pl
         sFK+0fNSiKD2CSd2FTJNczajwXqS3XXlxFJ6MQzTfx5NeZYfnJOym/rJ6TVAzEITpO1B
         pOp5DoGZTulkPH2QHCIlixDZpKmc7+9d/Fok2RouVJjxvZzbbFObc9o//WOUHJBGf/Os
         1znA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhiFJBSZNtYSvVSvHZmFB6j429D2Xk9a0RkMHEiXG8c=;
        b=fy9ZqI78//Mf+m8K86QdgF7gv9SYgwsSPZG+qRcZAVvqfUw0DecPPzya8+6Ur1GFaY
         p0s5y1tMziyAYd2r8vsYnkhMdZnTAiEpa5Z45bFVCugxQFgF0vby62CszPT56fMqb5cG
         BsNy0RD/ddq+tRYVz+v9fyetKWGDgT8PhK6f3JlnaxUbD0xx5hBmF3IXQ8E3kOmWr3cm
         Ee+18rCe3gaVwAaGekoSn2yOKmVdJDOjLqX7Y5kTbY08cS/maefaUO+0R5WfRcJakiDa
         IBP4hdv6tHnPpLYwu0tJQxgi8bW6ktrMFj/aJ3Hx6yyCdCadJNuKLi3HYrqefeGgfbJ2
         BaMQ==
X-Gm-Message-State: AGi0PuY3NWUlFe7ePI1JFI/HINnmqMFEjQT3uYfjUrKHrRz5sAskmWgg
        yu+obHeg5lsLc2v09aWmQSOBMOn6PaXG11LlMuYgkQ==
X-Google-Smtp-Source: APiQypKJX0cgH9UX1zvl/KxFagV/iiKpTIDbbtgps7O8QHhbwEjork3xVWP02RmgYM8BlCpeFiPmZ92wI/HPw/80J8Q=
X-Received: by 2002:a67:ec81:: with SMTP id h1mr2530828vsp.96.1585414629166;
 Sat, 28 Mar 2020 09:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <202003281643.02SGhD4n009959@sdf.org>
In-Reply-To: <202003281643.02SGhD4n009959@sdf.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sat, 28 Mar 2020 09:56:58 -0700
Message-ID: <CANP3RGean6M7PuTMXKJrXSdU+2RgzqsoEvnQK5C0RFoXGfFwBA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 18/50] net/ipv6/addrconf.c: Use prandom_u32_max for
 rfc3315 backoff time computation
To:     George Spelvin <lkml@sdf.org>
Cc:     Kernel hackers <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>         /* multiply 'initial retransmission time' by 0.9 .. 1.1 */
> -       u64 tmp = (900000 + prandom_u32() % 200001) * (u64)irt;
> -       do_div(tmp, 1000000);
> -       return (s32)tmp;
> +       s32 range = irt / 5;
> +       return irt - (s32)(range/2) + (s32)prandom_u32_max(range);

The cast on range/2 looks entirely spurious

>         /* multiply 'retransmission timeout' by 1.9 .. 2.1 */
> -       u64 tmp = (1900000 + prandom_u32() % 200001) * (u64)rt;
> -       do_div(tmp, 1000000);
> -       if ((s32)tmp > mrt) {
> +       s32 range = rt / 5;
> +       s32 tmp = 2*rt - (s32)(range/2) + (s32)prandom_u32_max(range);

Here as well.  Honestly the cast on prandom might also not be
necessary, but that at least has a reason.

> +       if (tmp > mrt) {
>                 /* multiply 'maximum retransmission time' by 0.9 .. 1.1 */
> -               tmp = (900000 + prandom_u32() % 200001) * (u64)mrt;
> -               do_div(tmp, 1000000);
> +               range = mrt / 5;
> +               tmp = mrt - (s32)(range/2) + (s32)prandom_u32_max(range);

Ditto.

>         }
>         return (s32)tmp;
>  }

- Maciej
