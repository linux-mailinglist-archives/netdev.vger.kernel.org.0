Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBCA466D1C
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 23:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377412AbhLBWpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 17:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377333AbhLBWpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 17:45:38 -0500
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233D6C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 14:42:15 -0800 (PST)
Received: by mail-ua1-x931.google.com with SMTP id p37so1955674uae.8
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 14:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjGInSXjOzFeYXK8IrlkDMiFkwVJjfntG08vZHGTiDI=;
        b=CBvCRrl0fibp0MVVvbGKVNtyV/39Y27GfR8ht3aKkcpBsp5u1spcewSLtzQrDR4YtY
         1mKcj8E+cw3ZqBXK1CGt7hUt44Zid3OukJkr67c2EVGm2hQWdRYlrefRwNVEBiEarOoz
         BjDfWQCYCBgiTvMdv3C5b7Plt/UPSjzGeGQW7B5/bOAxqi0/K6xXwo2b3egUY3205rwU
         hh3b+f5fS8Wy3WVw9OKGWuRNR2mKxp5RoR6AVZTfFMKIxuN2fvK1e5UAsDbXX66iv0tM
         yNpUJg0bUJI0j8K/K+gxP+ncmP3PJYqMMVh1AgSeuzSc40diq9ZyQGQN3o7w89Z34AaA
         2hNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjGInSXjOzFeYXK8IrlkDMiFkwVJjfntG08vZHGTiDI=;
        b=TSJqe1zURFu4dOdudx64TPbFaLUQLib2Si6Ma5Qd29bBzAiOBeyYBlBhRG/h8cVl41
         QntM7rGZzLhqyIQ5ZGFaQrSFmSsQZgWgKqYiOphMIfCtPnW1gHNQNBCHP8BmfGwOo7lu
         YknRGOmdnM0SXbBDIinbzd2dtNv2eOmNH49Epatp6wpDETIJcOZH42TnNZtdQhR0BhF8
         mknZu7WXkcmF1xuC3gUyVJHJFu8GYUr6mCCojpZZYTO2LuxwcP5kNcKBJSPkscmk79nP
         CeoxBRFVfdikIgFrDwKg9V9tClvAO40fmBr/yTp0dmc4etlFliuFBu3sFkSJrayiLlUE
         WOzA==
X-Gm-Message-State: AOAM531kPPPL5SjT8/pDYKu35OuzwvThUFMZfvVWugCm+Zv/r6qaGhhN
        I2YNOCWx8ojBKO0A0l1KHhpVJ2Kn5izhsvr3jdQ=
X-Google-Smtp-Source: ABdhPJwcJclDVG5A3TvtdSSctUcSaBf8Vc4B/TnGLpq5nkuhxbDgVe5pGPqhaP8D6/o1RHfBmkweLQ9vT7z8VvKmGvs=
X-Received: by 2002:a67:d893:: with SMTP id f19mr18520321vsj.39.1638484934188;
 Thu, 02 Dec 2021 14:42:14 -0800 (PST)
MIME-Version: 1.0
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
 <20211128125522.23357-6-ryazanov.s.a@gmail.com> <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
 <CAHNKnsSgc0bEwJbS01f26JRLpnzky9mcSJ6sWy2vFDuNOHz-Xw@mail.gmail.com>
 <YaR17NOQqvFxXEVs@unreal> <CAHNKnsTYzkz+n6rxrFsDSBuYtaqX0vePPv3s3ghB4KfXbP5m+A@mail.gmail.com>
 <YaX3V12BTl6pXsYr@unreal> <CAHNKnsT10PPUXEVJajHkYXyrya2_O7b80D8dcXOpcH5n0LVzLw@mail.gmail.com>
 <Yai2FxeS3zOHcitl@unreal>
In-Reply-To: <Yai2FxeS3zOHcitl@unreal>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Fri, 3 Dec 2021 01:42:04 +0300
Message-ID: <CAHNKnsQ1abmGQs5990dK0nN7zNnZG7=hPNJAX__VREw1=Ky2Vw@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs optional
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 3:03 PM Leon Romanovsky <leon@kernel.org> wrote:
> On Thu, Dec 02, 2021 at 01:03:33AM +0300, Sergey Ryazanov wrote:
>> Ironically, I took your "don't over-engineer" argument and started
>> removing the IOSM specific configuration option when I realized that
>> the IOSM debugfs interface depends on relayfs and so it should select
>> the RELAY option. Without the IOSM debugfs option, we should either
>> place RELAY selection to an option that enables the driver itself, or
>> to the WWAN subsystem debugfs enabling option. The former will cause
>> the kernel inflation even with the WWAN debugfs interface disabled.
>> The latter will simply be misleading. In the end, I decided to keep
>> both config options in the V2.
>
> Something like this will do the trick.
>
> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> index bdb2b0e46c12..ebb7292421a1 100644
> --- a/drivers/net/wwan/Kconfig
> +++ b/drivers/net/wwan/Kconfig
> @@ -85,6 +85,7 @@ config IOSM
>         tristate "IOSM Driver for Intel M.2 WWAN Device"
>         depends on INTEL_IOMMU
>         select NET_DEVLINK
> +        select RELAY if WWAN_DEBUGFS
>         help
>           This driver enables Intel M.2 WWAN Device communication.

Yes! This is exactly what I need to finally solve this puzzle. Thank you!

-- 
Sergey
