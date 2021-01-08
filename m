Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01E02EF07E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 11:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbhAHKPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 05:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbhAHKPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 05:15:43 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A73AC0612F4
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 02:15:02 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id z5so9191080iob.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 02:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M8L+mie9YodxFyusmkOnVHf2G5LUkmbLsYSRkKh90/c=;
        b=j0FPTQ3k0mLUwVczuY984QPNHNvr9ibneShlad7i1XNVTWVG7B0F4IHjEsxGGOK9KS
         v2ite3BXoGYoPeeugYHKPw9YVDO+2S26zMqch3Gknf6XUfGbWUyvNgVQ0CkTPq42kd8W
         j5ArQQI1iMVy82xhU8Q2wJokuMN4Iw2TQTdmxBqCXlHW3D4Tqg5QZU8kfS/XwuN3PP37
         9m8bZBzZHMOXF1ME3dq7bSth7+7eKq3jKy1BFcGvPbDgQ88YkdkSpt6KPRn560qBO9eq
         rTUttfiKUqzjZI2RB4WpQRJVt238qEDUc4MvLq0b9V+5yiHGx01nP9UgzZ2vCJMBCskl
         2Gdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M8L+mie9YodxFyusmkOnVHf2G5LUkmbLsYSRkKh90/c=;
        b=cIaqgrKjsCtoS7sRLyV/d9ZrcxVqQRyNML1GvUQLaXeHUa8hAcfOgtDwseV6TP4s7y
         nnOPjoNGLUqp9jlDE2q8J6B2VZUPAwAwPRGUapx26jcqQI+Kxy+DJ80Exi6y8op1oZGf
         ag/hen9+JjxkDZIf/VhRQR3SaAq0Y+lDwf8fEUB964jcJKoBe3Zfwzn7BV5uX9+Aoggv
         lvKuLRDzuMU0FJN0lnEmkoXlS9/bz6iwDYXl3xetZlJ1rtvfc03QJvLypKnpLkimA+JE
         KPSn0P0RzsdRGOsuYjjUNryh3VAiFgfwBaBh4OxEJ5TKORC+RMyVH/9sFUl4J3agHRUe
         M9jw==
X-Gm-Message-State: AOAM533K/YcaWVu3jNA1hJ6ZItB2ptmDRG3HX3h8VmP0JIehTsckAcbW
        inrDIIkyO8R8wMzcrOwV8L2u5AUA5swM1kTcczkKFw==
X-Google-Smtp-Source: ABdhPJyy3jebXM0G/zF7Q6xXQMA+FCSCmCouMUb9/1BOT/4ZV4iye+9PhxkXuszoHZRfTR88WqA+PTAgZxgV397k+N4=
X-Received: by 2002:a6b:918a:: with SMTP id t132mr4932677iod.157.1610100901679;
 Fri, 08 Jan 2021 02:15:01 -0800 (PST)
MIME-Version: 1.0
References: <20210108002005.3429956-1-olteanv@gmail.com> <20210108002005.3429956-9-olteanv@gmail.com>
In-Reply-To: <20210108002005.3429956-9-olteanv@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 Jan 2021 11:14:50 +0100
Message-ID: <CANn89iJNTgXsRv0Wgp4V=TUws-d4Mc4FwR4kUBy+r8+UxWC06Q@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 08/18] net: make dev_get_stats return void
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 1:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> After commit 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches"),
> dev_get_stats got an additional argument for storage of statistics. At
> this point, dev_get_stats could return either the passed "storage"
> argument, or the output of .ndo_get_stats64.
>
> Then commit caf586e5f23c ("net: add a core netdev->rx_dropped counter")
> came, and the output of .ndo_get_stats64 (still returning a pointer to
> struct rtnl_link_stats64) started being ignored.
>
> Then came commit bc1f44709cf2 ("net: make ndo_get_stats64 a void
> function") which made .ndo_get_stats64 stop returning anything.
>
> So now, dev_get_stats always reports the "storage" pointer received as
> argument. This is useless. Some drivers are dealing with unnecessary
> complexity due to this, so refactor them to ignore the return value
> completely.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>

This seems like a lot of code churn.

Ultimately we need this function to return an error code, so why keep
this patch with a void return ?

Please squash your patches a bit, to avoid having 18 patches to review.

Additionally I would suggest a __must_check attribute on
dev_get_stats() to make sure we converted all callers.

 I can not convince myself that after your patches, bonding does the
right thing...
