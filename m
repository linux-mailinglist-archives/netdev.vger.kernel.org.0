Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78EE478692
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhLQIyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbhLQIyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:54:00 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717FCC061574
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:54:00 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id c22-20020a17090a109600b001b101f02dd1so5087252pja.5
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ogeGlxqSPd1FJJQKiGKzFCLgWlHHw0Y10iEbEgiBDCo=;
        b=T4E/2A+/b8qvLG5zJQIu5OXJ1rV4FC0aoe+M7zXY1N2B/Cr1EWo0F/ORRan2qXXuEh
         UuOTnh2uKE1kqOPpqotCjHK8V54xli3rJE+oS9TnYsSlL4ztdskz+3q1KQ46ZjekFhWi
         GadlouhS/m98rfriIulFnEmrkM9EcMSNl39nrsIagf5AOZOBK4yWVTdT8WiVqlPLg3Rz
         gx9zgE/qH/j+1NtxB1BNOk0ukvTftmPGZURp5DDqSrmxoy5h9X2Wyd2eAZFmnmvJb+v1
         65eQ+CZxJ1UoOKctNIMggaEYmD4uEjTsQ9S/RKIAAKYbhkg6UEfwYKk96ldCPu7A+wR8
         638g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ogeGlxqSPd1FJJQKiGKzFCLgWlHHw0Y10iEbEgiBDCo=;
        b=WRzvZzK2ycnSuey2TWyogf/XISbIW7M/Xc1NG89in9bsWTDJTJB1T3+RFnU1w05vLl
         mlOi/t3dlKWgSjFDjAX9Qxxv37CLDUb1H5SbVLSsQMaMGXHF+tIWyBROrfy/RFoPNcBb
         2TuDdfLcoDSx1drjScAQBT2DFSE1h7O3cGZzKZbmTWoAQGAc3rJNpYG2gYaFcSVbyRAd
         V1IB2NBfldM7G5H9ETtt4wZSJYrpvY5BF0xsZ/ZRdxw0Lyg/RpWWmiNgU5bCOvwxKWLb
         IBP8WxlsKtkEKeEroAKMq0J8lT0S6bHVQjUd8+SLZhOKF1dPHqiyQQVWvz6OPnHuQONH
         x3ZQ==
X-Gm-Message-State: AOAM533zMx/GmRVgw2Vw0VzROIiA5VIY4iGX6b3PPnk1WmakWDrbveIr
        IhTDWetmetsCqd2V4MAqkXr6ILesi3MG4QJhQhI=
X-Google-Smtp-Source: ABdhPJz8aSVr/ytbS4zvaSDQnb0A02NcnIKu7u65bLOG0K7q7KGnFBXMy1QzHytSGMFVgvFygmG3a2RtdW6+lui4kZ0=
X-Received: by 2002:a17:90b:88e:: with SMTP id bj14mr2651747pjb.183.1639731239962;
 Fri, 17 Dec 2021 00:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216162557.7e279ff6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216162557.7e279ff6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 17 Dec 2021 05:53:49 -0300
Message-ID: <CAJq09z4P6fGe6Og4tHAg0qZZ1eR609ytCZj3h_+yp=UD_czh1Q@mail.gmail.com>
Subject: Re: [PATCH net-next 00/13] net: dsa: realtek: MDIO interface and RTL8367S
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        olteanv@gmail.com,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, 16 Dec 2021 17:13:29 -0300 luizluca@gmail.com wrote:
> > This series refactors the current Realtek DSA driver to support MDIO
> > connected switchesand RTL8367S. RTL8367S is a 5+2 10/100/1000M Ethernet
> > switch, with one of those 2 external ports supporting SGMII/High-SGMII.
>
> nit: plenty of warnings in patch 3 and patch 8, please try building
> patch-by-patch with C=1 and W=1. Also some checkpatch warnings that
> should be fixed (scripts/checkpatch.pl).

Yes, I got those problems fixed. I'll resend as soon as the
rtl8365mb/rtl8367c name discussion settles.
Or should I already send the patches before that one?

For now, here is my repo:
https://github.com/luizluca/linux/commits/realtek_mdio_refactor
