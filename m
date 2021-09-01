Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F8D3FD102
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241719AbhIACCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241711AbhIACCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:02:31 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B799C061764
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:01:35 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id e131so2160913ybb.7
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wGf0CBf7Tu/z6D0lNg7ihUdE2JvD3e3Vtv/fQHec648=;
        b=YmSq0+bWCymGEFH+CXNH4EwHLCnhnw+M+d6hWq6smLmdS+GV57gbbjyBLM/uPToPY1
         51iU7WHx67Fw1MIefKAH817ioZ0E6suxsrLjIvLmdLCutUqcGf+0oC1RTzYsmVJqQmnY
         l9VOCvYVyb7LgVBt+Tv0H4ic7xi7yJLf8RoxHrDM16NHbNIfOGC1xLIe1D95ePlc5cLz
         2a84XENy2oJl3CLZ+TpH7z4td1iRinNGQPsppAcMQBwomHXFwBeO0eGy+snzj2Br+IFz
         FLrBPKRDEZcjHxw+XFZY7ObbDA+Be0hUdsWKneO8ZFyXKpZ2MyhHLYNh+nqaD8ApD6ex
         j7ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wGf0CBf7Tu/z6D0lNg7ihUdE2JvD3e3Vtv/fQHec648=;
        b=o8iZ6yz/eTf+Xl7KXxkqqDkOS3cQO9BPDV7Es0xx0l0C339apECbbcqD9bxS0ZiNR3
         CJWTzlpqlj2EFTKBhePqSdvfUi5l04PRLrrlyeNw54jSF3CNwhEsI/PQ6RQt2zCrf30X
         EkrsLshrCWDc/igXJiBWXtyAmpayREHIjgpfwdkJLyIi3wnnuwNgoqgn9MEGf13YUzGS
         QWkYrEfHjUA6i7RbBGk0s9g/HBwt3VtIbdML8yQaxQB47FQAi+R3S0wp9kZz1A02b7XH
         wq7gfA55jgqVNf+Pm6OymbHtGTSvsDwuzCGdH103pcMtXQJHGEHx4BMFdp49ZrB37W9f
         EkMA==
X-Gm-Message-State: AOAM531O1/7QBAJ6/FhDcwBn2rhj87RsiQHPHvX0HUzoyTV9MeOqHAqt
        fRcdj6q/G6ylicMeON1bTcxVUNZrMbHsOqffQhlI9w==
X-Google-Smtp-Source: ABdhPJzS7FEQLRCVO4eB7zcbXBfM/3bpCfq0Sb6/vCuY1JPZSdsXPS2l/TYnXb0DygQv9KJKHtWoGYr+Jwlq5e1MuKo=
X-Received: by 2002:a25:9c01:: with SMTP id c1mr33882582ybo.228.1630461694456;
 Tue, 31 Aug 2021 19:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
 <YSlG4XRGrq5D1/WU@lunn.ch> <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch> <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch> <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch> <20210831231804.zozyenear45ljemd@skbuf>
In-Reply-To: <20210831231804.zozyenear45ljemd@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 31 Aug 2021 19:00:58 -0700
Message-ID: <CAGETcx-ktuU1RqXwj_qV8tCOLAg3DXU-wCAm6+NukyxRencSjw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 4:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > Rev B is interesting because switch0 and switch1 got genphy, while
> > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > interrupt properties, so don't loop back to their parent device.
>
> This is interesting and not what I really expected to happen. It goes to
> show that we really need more time to understand all the subtleties of
> device dependencies before jumping on patching stuff.
>
> In case the DSA tree contains more than one switch, different things
> will happen in dsa_register_switch().
> The tree itself is only initialized when the last switch calls
> dsa_register_switch(). All the other switches just mark themselves as
> present and exit probing early. See this piece of code in dsa_tree_setup:
>
>         complete = dsa_tree_setup_routing_table(dst);
>         if (!complete)
>                 return 0;
>
> So it should be a general property of cross-chip DSA trees that all
> switches except the last one will have the specific PHY driver probed
> properly, and not the genphy.
>
> Because all (N - 1) switches of a tree exit early in dsa_register_switch,
> they have successfully probed by the time the last switch brings up the
> tree, and brings up the PHYs on behalf of every other switch.
>
> The last switch can connect to the PHY on behalf of the other switches
> past their probe ending, and those PHYs should not defer probing because
> their supplier is now probed. It is only that the last switch cannot
> connect to the PHYs of its own ports.

I'm not saying this with any intention of making things easier for me
(I'm not even sure it does). But your description about how multiple
switches are handled by DSA has me even more convinced than before
that DSA needs to use a component device model. This is like the
textbook example for component devices.


-Saravana
