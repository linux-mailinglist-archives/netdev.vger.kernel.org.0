Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A85D225713
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 07:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGTFfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 01:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbgGTFfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 01:35:15 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945DEC0619D4
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 22:35:15 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id e15so7845800vsc.7
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 22:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=verdurent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7xTYHfNfEUh5QyUY2sEOu/zQIiIEk+hTgIzqseAVmRw=;
        b=fFE/iuDQ/w2Jg6B0FP4wHReZcx+GJUKFbPpJWTX6LSw3d8CN0DuO9BmtAbgVqHEJRi
         Ic8dHrvvxxr0aJZBu8+gVCYW+U0PAPE3no3hgoX1Sw2ed2FHpviFzEpm8qkB0k97z1P1
         an3Oiq9tw522O3sd1yA7tNnNDB5rJMgAe2W/4EOEAC9qr8LZUV9QKo2bomP69UndH7vL
         5osXQ8ZpEazbfSUF00e7b/rcYHqm94rI2VecTnpVXOkF8hfJyaZ/YC9MllKQhZKr42yL
         67K8LDKuLydu+3XWRWEtqZ9TXBNhUX6XRd+3lo16cmwhs9yyrwsoZATbGN5o/xiSaTIa
         d7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7xTYHfNfEUh5QyUY2sEOu/zQIiIEk+hTgIzqseAVmRw=;
        b=fWOzm+UAbEVCE8NoYkCUd0mAx6/R1qb9MbGXt2B8u3wNXXdRLMZ4xmXlfSDO8cyyS5
         3I8C+te0blrAO0vDIA9tOhCZ9prf2lBx7gmwGa9Xz+FGxOEgg6dl5bhcTiHFGZUDJbek
         fSIMcFUH8W8XotRU84daXayGmkVcvYaRJQsizDBnu8uwWjGGhICedeb3Pnws0KvbgLFg
         TBLmPniQjWp3O7JOeafSqHJ1WJ1i2EEgQTVC1W7xbnrLBsGeeuZrMM2OsZ6jaKqqb8/3
         FqGSwxtmOKzlP0FNbQV4x8eKQBFaFcDcb3iuhUqSc0xi8gwiuW4O+T64JGjyZLRAnF6V
         Ilzg==
X-Gm-Message-State: AOAM533xuR96IysQ8WR3FrfvcQYF02tjrta9BePV84ud4CK9IQgPZB7l
        ApqDb+4xAOk9J/+d2ISF86NCH76OBmk9OEm7VbFf3A==
X-Google-Smtp-Source: ABdhPJzp9F30GAHjXrnn4V9iyB7ZS2SepAZH+q92hTVOB/KEvvMu4mFLkioreCQvj0CgtVz8RAUvr9LfBhH9M33E304=
X-Received: by 2002:a67:2285:: with SMTP id i127mr14127135vsi.159.1595223314360;
 Sun, 19 Jul 2020 22:35:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200715074120.8768-1-daniel.lezcano@linaro.org>
In-Reply-To: <20200715074120.8768-1-daniel.lezcano@linaro.org>
From:   Amit Kucheria <amit.kucheria@verdurent.com>
Date:   Mon, 20 Jul 2020 11:05:03 +0530
Message-ID: <CAHLCerO31g4-5ALMikFx+mA9bGrLLVv2ayncpiHCL5nn44TQhQ@mail.gmail.com>
Subject: Re: [PATCH] net: genetlink: Move initialization to core_initcall
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 1:11 PM Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>
> The generic netlink is initialized far after the netlink protocol
> itself at subsys_initcall. The devlink is initialized at the same
> level, but after, as shown by a disassembly of the vmlinux:
>
> [ ... ]
> 374 ffff8000115f22c0 <__initcall_devlink_init4>:
> 375 ffff8000115f22c4 <__initcall_genl_init4>:
> [ ... ]
>
> The function devlink_init() calls genl_register_family() before the
> generic netlink subsystem is initialized.
>
> As the generic netlink initcall level is set since 2005, it seems that
> was not a problem, but now we have the thermal framework initialized
> at the core_initcall level which creates the generic netlink family
> and sends a notification which leads to a subtle memory corruption
> only detectable when the CONFIG_INIT_ON_ALLOC_DEFAULT_ON option is set
> with the earlycon at init time.
>
> The thermal framework needs to be initialized early in order to begin
> the mitigation as soon as possible. Moving it to postcore_initcall is
> acceptable.
>
> This patch changes the initialization level for the generic netlink
> family to the core_initcall and comes after the netlink protocol
> initialization.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>


> ---
>  net/netlink/genetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 55ee680e9db1..36b8a1909826 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1263,7 +1263,7 @@ static int __init genl_init(void)
>         panic("GENL: Cannot register controller: %d\n", err);
>  }
>
> -subsys_initcall(genl_init);
> +core_initcall(genl_init);
>
>  static int genlmsg_mcast(struct sk_buff *skb, u32 portid, unsigned long group,
>                          gfp_t flags)
> --
> 2.17.1
>
