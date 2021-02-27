Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A163326FAD
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 00:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhB0XsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 18:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhB0XsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 18:48:10 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38892C06174A
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 15:47:30 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id h4so14821745ljl.0
        for <netdev@vger.kernel.org>; Sat, 27 Feb 2021 15:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j1VtW2X8LEXJJ/paDmy9xh4EVxSPrsHQs71fRPbsyLU=;
        b=xt2GC1WVDtzEOGyKyEawlv0aE2HInn5u0M71JK0xOKfeyki167WEVJPegoF6J44weT
         XOHJIj91DBb48yc+hO197Ux09F5qjr9lxj/WDt9YKJdV2d9mrU9VOoqM8qnGuxLkSu9H
         Y54G6A0fL+FkmmjLVdBMD2E+N2wdQO8vi5RNqfg8yuXO9Cbz+b4enkDPh/IagJL8luuI
         5TFB4MWvLmZ34Sd4LSLxh6NPjwhX5grZa/F2OPVJNMKpyfgv8rJpqzO7Fh+WhZ3TJvf9
         nMng9lorC+duCMB8H/nTn7aEcy1XZrjE44FFo52SIFWtShmMbt5cxgqGN7w9o6ONdNfX
         gKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j1VtW2X8LEXJJ/paDmy9xh4EVxSPrsHQs71fRPbsyLU=;
        b=Fvdlr6ueBnb4OD7w75XMqUp5eQE4b3MQY9DS6VclBbn1GzNEQwJLm4dey/q2ECbafY
         +82avLc85pmr36FRXYKW082ixpiK+QtfD6NfJgpzPJL8R8PY+nFlwPNzhZIndsDdgFTe
         3pX3gvUEj31awVpjtO+GdebnH5l9M9AkGo7xhUQ7r3rBb8s7KrC61ZlTSOdRNr+Xsmy0
         463cbn08UvEvvy1kFzxYRRZMn6kgQULMwPDZ4TotzD9oInB2FrMfiCQp/LDs7jZ/geRX
         pOmQqjIdx6XaxfEIdJY/dFouAwmm5dsQQ9DUKnbS9+l50ZJ1r2gQQKGJHUhNh5fkJGva
         SHSQ==
X-Gm-Message-State: AOAM532qU0g5mp4oTveLGJHpyvRG8PTQ9sX9kNhU/lHGZcaERAjdpFcP
        uFtuxDjW+wniUr8mYOmepya6f7WVqj9gKMtx2q69gw==
X-Google-Smtp-Source: ABdhPJwx9inzx5EfnMExnrXKn6CJhM8Be7qX8NUqB3G3zP3X818fsu6IvSycQg7/fi01hEkqO00jUJzOs4Fw4HbXIg4=
X-Received: by 2002:a2e:9004:: with SMTP id h4mr1954265ljg.326.1614469648640;
 Sat, 27 Feb 2021 15:47:28 -0800 (PST)
MIME-Version: 1.0
References: <20210217062139.7893-1-dqfext@gmail.com> <20210217062139.7893-2-dqfext@gmail.com>
In-Reply-To: <20210217062139.7893-2-dqfext@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 28 Feb 2021 00:47:17 +0100
Message-ID: <CACRpkdaP9RGX9OY2s1fqkZJD0fc3jtZ4_R4A7VvL0=po-KEqyQ@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: dsa: add Realtek RTL8366S switch tag
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 7:21 AM DENG Qingfang <dqfext@gmail.com> wrote:

> Add support for Realtek RTL8366S switch tag
>
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

I understand this switch tag now sorry for confusion.

> @@ -104,6 +104,12 @@ config NET_DSA_TAG_RTL4_A
>           Realtek switches with 4 byte protocol A tags, sich as found in
>           the Realtek RTL8366RB.
>
> +config NET_DSA_TAG_RTL8366S
> +       tristate "Tag driver for Realtek RTL8366S switch tags"
> +       help
> +         Say Y or M if you want to enable support for tagging frames for the
> +         Realtek RTL8366S switch.

I names the previous protocol "RTL4 A" after a 4-byte tag
with protocol indicted as "A", what about naming this
"RTL2 9" in the same vein? It will be good if some other
switch is using the same protocol. (If any...)

>  obj-$(CONFIG_NET_DSA_TAG_RTL4_A) += tag_rtl4_a.o
> +obj-$(CONFIG_NET_DSA_TAG_RTL8366S) += tag_rtl8366s.o

So tag_rtl2_9.o etc.

Yours,
Linus Walleij
