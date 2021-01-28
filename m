Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA24308102
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhA1WR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhA1WR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:17:56 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652FEC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:17:16 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hs11so10128599ejc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dSI5sM9pdLs+VZdf7MQrMzeojqPQnRh/IJoFohgXMCc=;
        b=fyxD17XwXqKqf1xS+y1ONoaeEvq074ehIlhAdInzM2G1jE0omX3nq3Q1Nv58qesmUH
         i2vbf8ybWAqCi8YxoTbI1OF89LzJTk10bbbg+L/wOgt+E67WMHnkYZ877XxG3e89FSFj
         1sEAB1DxwZEjNOF6Q42sNxADMeBTJCoUQf/cWDbhvsnEsKqs3ntyz3ZcBO4zg42WagSZ
         4Gaz52iCY9rn2hB3ewVzbhg0NKdyQk4KU6V5ZObnUysfyaynI5lr8KAIUWzhWgaUKJh+
         T6YzPm6C6nqhBNuRFWQaAW+jd4dIXuXWScXoOun8S/79XImbdLNdlNBaz8+YVoHwmmny
         cb8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dSI5sM9pdLs+VZdf7MQrMzeojqPQnRh/IJoFohgXMCc=;
        b=ufHd7lDfLXe9fnel9GwchWnwZj+UnQeNJAxOMbahysf3Q5iluqWQl+2sLrzP5Ba5Ws
         i/Vh7BZ6qe3BDizaFbfPn3iA3uJRlIyxFQJ01pud0gX9ueVJdkflII1+nIIBvB5dKaTd
         d8X3iClocJDt8nAhtflaMBYMGPiRbiwO7zopGuqdcJgxu2UeCoio8QyDUIHTCUbLF/ph
         EN9iNg5exRnn4ibjZuOFAqvNbN+01OaxIS+DqXIUcpuTo5zAcjTqVtQGpqXCwOZdWuWj
         ILgvt2kKsXHEXiIjWpRskyrzTkxXztfYgNDtR2Ub/VVV9gFFHaem1ytxzFwaGXyQc0CB
         52XQ==
X-Gm-Message-State: AOAM533p501oy2MU0KM8vlm6yGdmoB1Au2jDmCzUAaiWe6pTgcgqCN1I
        1DVst65HTCZ7O3iK9wJXvC9+7UQ2o2hylDHfhTY=
X-Google-Smtp-Source: ABdhPJxIbzUOYt0YDi1maVKsSbdjeVkRjrhBIARme3ugWyInBhdD49VKSipDNdXz3rUT3ip2dxi2GUvz8bRBhGJz9p0=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr1602217ejd.119.1611872235218;
 Thu, 28 Jan 2021 14:17:15 -0800 (PST)
MIME-Version: 1.0
References: <6e453d49-1801-e6de-d5f7-d7e6c7526c8f@gmail.com>
In-Reply-To: <6e453d49-1801-e6de-d5f7-d7e6c7526c8f@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 17:16:39 -0500
Message-ID: <CAF=yD-+MdpFQZ8+M5hQaHMODUhAg9FadTm5ck2wu9C=4We9=OA@mail.gmail.com>
Subject: Re: [PATCH v4 net] r8169: work around RTL8125 UDP hw bug
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 5:02 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> It was reported that on RTL8125 network breaks under heavy UDP load,
> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> and provided me with a test version of the r8125 driver including a
> workaround. Tests confirmed that the workaround fixes the issue.
> I modified the original version of the workaround to meet mainline
> code style.
>
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>
> v2:
> - rebased to net
> v3:
> - make rtl_skb_is_udp() more robust and use skb_header_pointer()
>   to access the ip(v6) header
> v4:
> - remove dependency on ptp_classify.h
> - replace magic number with offsetof(struct udphdr, len)
>
> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> Tested-by: xplo <xplo.bn@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for the quick iterations. I was afraid that the switch with
implicit fall-through to the default label could trigger
Wimplicit-fallthrough, but it seems that warning is suppressed if the
case only has a break or return. It's not strictly needed in that
case, but no need to respin just for that, either.
