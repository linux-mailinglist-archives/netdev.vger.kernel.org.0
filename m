Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E89BB3EE
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437192AbfIWMji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 08:39:38 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:35962 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390719AbfIWMjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 08:39:37 -0400
Received: by mail-yb1-f193.google.com with SMTP id p23so5391744yba.3
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 05:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MXDJQgSKtD5dGfYEIG7aUB4gOpH2kOow0O13ionmQG8=;
        b=ipo/pSIHGLZUlmom4UmtaXmbV26Xz6/g9cjD/JfR3p/MuH3zrj/uXsn82Y0XqZFCyy
         /bYLZg4zjuVB9x/yDLF2jXL7cYo8l25wWTs+v0BsRnwKySwtzIQxsozUH7+kkClijQ32
         JPgMYJXplUXeuliDAwtVimDEbbzqiWUue8FZVi3ghR2xBkaKnz/Hp5P92ykRFPLKfc2O
         oEKHHQhyEodw75y4MAIgbmcBb662nbjIJkgG1HDWHvZRPIvmD4F0d7+FvOK9pyGWjk4V
         L6GRyHl4D9+0mUb28KAIefGNJlinLy5jtyXnB7uB5vzPxKR/w2GxxjqUzC6pJrCL3p2m
         Q1Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MXDJQgSKtD5dGfYEIG7aUB4gOpH2kOow0O13ionmQG8=;
        b=X1bW0Q8YkBHd/Gdh2SberLejatySgMonc6ozKPQ+bHUXYZLX34Ya3Cc+5VRmon+S8M
         Wjk9Y/CiC8mLGGjRCUOwG1bhK9gwtinJRBPgFWbxG6TTGw1UZ7J4tay1WW1HxNixgJpW
         NTmz92974IlSBhogBjWEUIiRlmJQrACzQDJJIPLVy0aY89HbUGP4rJ02YECOmTzMB1t+
         CR8kJU0UNYF3IpYOC2FEDefZOsXD7u3vPLi/vUM83Vba4Sf1NzVz6BM7vw1xXYkHN3yQ
         yrGNLgZQEdTCQlIYaaqHiTo0TxbOf+f1Swxfa2AYp8mPnZdYyvjvZQAPPqaFKueFBDv8
         UKJw==
X-Gm-Message-State: APjAAAV1jaC8rFKHIeBLz8fa0RQwG2/0V+BWUff1OYsd6F+XquQZaRpe
        CjyFCVsWraYgr6hsHLQn81d6uOJE
X-Google-Smtp-Source: APXvYqzERASUhYD2Vv6laIvK9KddB0r6tPqg8XeChoCd+XYnL0HmJHQ6QRAQziNH/1c52rxO8zvI/g==
X-Received: by 2002:a05:6902:513:: with SMTP id x19mr6782581ybs.77.1569242376007;
        Mon, 23 Sep 2019 05:39:36 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id f68sm2644285ywb.96.2019.09.23.05.39.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 05:39:34 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id h73so5129753ywa.1
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 05:39:34 -0700 (PDT)
X-Received: by 2002:a0d:e802:: with SMTP id r2mr21859422ywe.109.1569242373755;
 Mon, 23 Sep 2019 05:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com> <20190920044905.31759-4-steffen.klassert@secunet.com>
In-Reply-To: <20190920044905.31759-4-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 23 Sep 2019 08:38:56 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
Message-ID: <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> The previous patch added the NETIF_F_GRO_FRAGLIST feature.
> This is a software feature that should default to off.
> Current software features default to on, so add a new
> feature set that defaults to off.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  include/linux/netdev_features.h | 3 +++
>  net/core/dev.c                  | 2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> index b239507da2a0..34d050bb1ae6 100644
> --- a/include/linux/netdev_features.h
> +++ b/include/linux/netdev_features.h
> @@ -230,6 +230,9 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
>  /* changeable features with no special hardware requirements */
>  #define NETIF_F_SOFT_FEATURES  (NETIF_F_GSO | NETIF_F_GRO)
>
> +/* Changeable features with no special hardware requirements that defaults to off. */
> +#define NETIF_F_SOFT_FEATURES_OFF      NETIF_F_GRO_FRAGLIST
> +

NETIF_F_GRO_FRAGLIST is not really a device feature, but a way to
configure which form of UDP GRO to apply.

The UDP GRO benchmarks were largely positive, but not a strict win if
I read Paolo's previous results correctly. Even if enabling to by
default, it probably should come with a sysctl to disable for specific
workloads.

If so, how about a ternary per-netns sysctl {off, on without gro-list,
on with gro-list} instead of configuring through ethtool?

Alternative, the choice between gro-list or not could perhaps be
informed by whether ip_forward is set. I think we discussed that and
it was rejected, but I cannot remember why.
