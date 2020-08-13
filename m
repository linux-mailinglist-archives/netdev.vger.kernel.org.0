Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129B92439DD
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgHMMfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgHMMe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 08:34:58 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB65C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:34:58 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id 186so1225918vkx.4
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eR1AQA+XciNBQxQud/+jjbn2IP9UCDB7D06iSV36Ojg=;
        b=jnatlmUG2VjgQ9S0DEnTL+j7CXiVpgeRSZaSBmnpH92bdHJgou82J/U74TgR/u0s5j
         Qc3vSzrFG+D6gVEZmdMFK/cBqdQ8BQ0qSjNHuIvoXDM6tWH69+Dg3WsvKoRy/V0VyYHR
         yn7LrNcpsnyl3J0foUuBdeiK/AdmDAXzUJddc0OMZ1rdyM5LZIghOpbZ3/8T58C/WzLl
         IkCe01FELN01t17h54qYVM0L5k867YvVEZimumjoWoxY0RhLTKX2aMWDtgCaERg+zNmU
         wXtnLYG9kNZpv3DUr3dlOIrsukFaFBqR21fP5ZPIVo6BZZsGS/pY4a9jOZmlG51Jw3bu
         dE4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eR1AQA+XciNBQxQud/+jjbn2IP9UCDB7D06iSV36Ojg=;
        b=JS5p21YFztdzE/lEPuupWxPWuE87fIrO/Wc9u/S4NT4XPYD+gHOoQmoSpbv9X1q4Oq
         Jc4T25lb4g0tYcrUXe4sBzsxo9oXogEEbLJhU3sP6zV+xdMU35AtwefOjUEGZS8LcDPe
         K4NjbU9IVvZTBkPoDQklAhg8R8UAZU7Etc+Id0r3dLa+Jx2fkYsAM43eKJ2hLHepDcUa
         Twe4mBq8NncdP6uGUzr1zUKsVIN2n72hZIrX1jKCjtnlIdLl9DxZnZOVhbL7/o+C7W+O
         fe6nyZfbX30RJwIMQRaMwq9+DJWfLXfI/E1+eYNeAvK0JV8su0PbauuFpnL4KF+9rcah
         Gh/w==
X-Gm-Message-State: AOAM531aMOCpivlVJW+tFe3pufvJkqsKe6EChYBgg+MYYJA6ti4MwrR9
        kYMcJetUBExBZr6KdOYqQoKNnRuJo3c=
X-Google-Smtp-Source: ABdhPJxsmdGjXhFIHPPsoFgL5/sRswGwmYHrGUC4ifdf8YVegvoL/7SRb0M8jTk038Cn3X99Pnvd2w==
X-Received: by 2002:a05:6122:2c:: with SMTP id q12mr3123427vkd.39.1597322097043;
        Thu, 13 Aug 2020 05:34:57 -0700 (PDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id 67sm699902vsl.13.2020.08.13.05.34.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 05:34:56 -0700 (PDT)
Received: by mail-vs1-f49.google.com with SMTP id i129so2806166vsi.3
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:34:56 -0700 (PDT)
X-Received: by 2002:a67:f5ce:: with SMTP id t14mr2799183vso.240.1597322095624;
 Thu, 13 Aug 2020 05:34:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200813115800.4546-1-linmiaohe@huawei.com>
In-Reply-To: <20200813115800.4546-1-linmiaohe@huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 13 Aug 2020 14:34:19 +0200
X-Gmail-Original-Message-ID: <CA+FuTScPbXMHZuJWBCTrcs1C3q2kURDrBucF4fvvT_qa1-AyOg@mail.gmail.com>
Message-ID: <CA+FuTScPbXMHZuJWBCTrcs1C3q2kURDrBucF4fvvT_qa1-AyOg@mail.gmail.com>
Subject: Re: [PATCH] net: correct zerocopy refcnt with newly allocated UDP or
 RAW uarg
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 1:59 PM Miaohe Lin <linmiaohe@huawei.com> wrote:
>
> The var extra_uref is introduced to pass the initial reference taken in
> sock_zerocopy_alloc to the first generated skb. But now we may fail to pass
> the initial reference with newly allocated UDP or RAW uarg when the skb is
> zcopied.
>
> If the skb is zcopied, we always set extra_uref to false. This is fine with
> reallocted uarg because no extra ref is taken by UDP and RAW zerocopy. But
> if uarg is newly allocated via sock_zerocopy_alloc(), we lost the initial
> reference because extra_uref is false and we missed to pass it to the first
> generated skb.
>
> To fix this, we should set extra_uref to true if UDP or RAW uarg is newly
> allocated when the skb is zcopied.

extra_uref is true if there is no previous skb to append to or there
is a previous skb, but that does not have zerocopy data associated yet
(because the previous call(s) did not set MSG_ZEROCOPY).

In other words, when first (allocating and) associating a zerocopy
struct with the skb.



> Fixes: 522924b58308 ("net: correct udp zerocopy refcnt also when zerocopy only on append")
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  net/ipv4/ip_output.c  | 4 +++-
>  net/ipv6/ip6_output.c | 4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 61f802d5350c..78d3b5d48617 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c
> @@ -1019,7 +1019,9 @@ static int __ip_append_data(struct sock *sk,
>                 uarg = sock_zerocopy_realloc(sk, length, skb_zcopy(skb));
>                 if (!uarg)
>                         return -ENOBUFS;
> -               extra_uref = !skb_zcopy(skb);   /* only ref on new uarg */
> +               /* Only ref on newly allocated uarg. */
> +               if (!skb_zcopy(skb) || (sk->sk_type != SOCK_STREAM && skb_zcopy(skb) != uarg))
> +                       extra_uref = true;

SOCK_STREAM does not use __ip_append_data.

This leaves as new branch skb_zcopy(skb) && skb_zcopy(skb) != uarg.

This function can only acquire a uarg through sock_zerocopy_realloc,
which on skb_zcopy(skb) only returns the existing uarg or NULL (for
not SOCK_STREAM).

So I don't see when that condition can happen.
