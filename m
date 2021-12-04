Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947074681A2
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383938AbhLDBDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344497AbhLDBDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:03:48 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C033CC061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 17:00:23 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id d10so14269055ybe.3
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 17:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+O7gKcbr2xtdbjYE1rvk3ZNjGwlHToJgyNYAZFaxexE=;
        b=puvEoN91J4XcdWtf3vTnUoCBhCxHv6n1SaIF/S4BMcBuHXZfscjr6A/AQdUtDls0O7
         clsSYzQN+vHyRup7OOxptKZIJfko4ecGX/ixa0zABmCfDRR8C5HZXrXKkflj8NRLqdIY
         Sf3y/URDpyuEOP6wS3atGWv/2IrpmL3jzHW38xGqT/Cz0ZljJiS0o5Hkg/qyYE3PhCoI
         Lf0p3k8FXXM6JEH+XK9O/66/KaSxCQKuqixziMdFuUzWY4mXByo9kieQ3CxKQbUoPSit
         qSCtnGoupJa+EkuqLMF2ntLUlRl6ipQ+l1GZlkYUR8l1DBAAxbOCDHKZ4D2jpSsW9mC8
         rg7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+O7gKcbr2xtdbjYE1rvk3ZNjGwlHToJgyNYAZFaxexE=;
        b=5eGoOgJqsvsrXZNF4AO7Zl1uOaRarjVugMlsTg3oW6iOVPmx4LjKesVM2wnihZI1ys
         L0URCNclUHPp7MU6fu3Vv+ty8/A+1Gh6zMSdTh6GtLKdROtGmm+koJPwOiDAsMRZXsYi
         317vQgQc4LIn0hM7dMgZ1A88x2H2Ijs4kfoJTMVIlblmVfPc5UozSLrCBtxOIY+E+eFQ
         TeqaTkb+vjBNEFAY3O7sOJkU9K2w5ENR3NSP61+bm3SwjjjD03VP9V6njoNOgFUe7EAF
         L/BCLrd2GYsoIGb+9ccvXr0NHHTMPaGFzBW9RSuQPfNhpx+EegLidcgrtDkJPhG/v0iI
         B/eA==
X-Gm-Message-State: AOAM5329J273GBOlXRuExW2H+SKmOP/V8AV+J8P+iuJNhlHWnWsybnIU
        bEiYOQz5jr4YfqnKdxn4lBpbjYI4lUdNr+2fmblEhA==
X-Google-Smtp-Source: ABdhPJxg5EZvcpPWmTWclb1eDJaL95YsLAzzk47/OfCWjEShTWh+yDYFQwNqRPO3qWLGVYSr6a5ZPv6bRV/n7p7G9UM=
X-Received: by 2002:a25:df4f:: with SMTP id w76mr28506240ybg.711.1638579622596;
 Fri, 03 Dec 2021 17:00:22 -0800 (PST)
MIME-Version: 1.0
References: <20211203024640.1180745-1-eric.dumazet@gmail.com> <20211203164743.23de4a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203164743.23de4a66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 3 Dec 2021 17:00:11 -0800
Message-ID: <CANn89iLK_XokM_zBz-xNvU36pOv_gH5uSvUBLNKpK3z4zOaQkg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 4:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  2 Dec 2021 18:46:17 -0800 Eric Dumazet wrote:
> > Two first patches add a generic infrastructure, that will be used
> > to get tracking of refcount increments/decrements.
> >
> > The general idea is to be able to precisely pair each decrement with
> > a corresponding prior increment. Both share a cookie, basically
> > a pointer to private data storing stack traces.
> >
> > The third place adds dev_hold_track() and dev_put_track() helpers
> > (CONFIG_NET_DEV_REFCNT_TRACKER)
> >
> > Then a series of 20 patches converts some dev_hold()/dev_put()
> > pairs to new hepers : dev_hold_track() and dev_put_track().
> >
> > Hopefully this will be used by developpers and syzbot to
> > root cause bugs that cause netdevice dismantles freezes.
> >
> > With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
> > some class of bugs, but too late (when too many dev_put()
> > were happening).
>
> Hi Eric, there's a handful of kdoc warnings added here:
>
> include/linux/netdevice.h:2278: warning: Function parameter or member 'refcnt_tracker' not described in 'net_device'
> include/net/devlink.h:679: warning: Function parameter or member 'dev_tracker' not described in 'devlink_trap_metadata'
> include/linux/netdevice.h:2283: warning: Function parameter or member 'refcnt_tracker' not described in 'net_device'
> include/linux/mroute_base.h:40: warning: Function parameter or member 'dev_tracker' not described in 'vif_device'
>
> Would you mind following up? likely not worth re-spinning just for that.

Sure thing, I will insert a patch to fix this in the next round.

Thanks !
