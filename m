Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9859E3AE432
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbhFUHa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhFUHa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:30:29 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3A7C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 00:28:15 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m17so4868263plx.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 00:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8a8ZCCoLVRdaeyYlzzPyOwLW9137LTiNLPvHHxRWOlQ=;
        b=FdGevPpBA9mdBjStZuBy3+OtCIIvly0GAesJcrtc9tqXU/kB14MxySaJNgB+Jsa+dP
         Rej/VWbEly12Cm1ANSy05gTF9O5OkY36wRwAXbQuIyUh0SZ3/ca0m1pMamKeRknSjsog
         XKQMY1EuGbP8sRh5uzx5bdst7x/Rw3v+njtKK1QMc1//fBq4GhkENdqm0HgKoNWuN97M
         pCi/P92PGiTly2Igoj1Uh9vVMSzfB6mqf9XfOju8G70x9K2inehhV7Kb1WTlATXT5B3z
         H1H5x9wOLpXi6dopcYxmivzDv7h0+zKAW9H5qLSnkkHSGXxO1r5WPRurHv5q/YqPgIAc
         sg1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8a8ZCCoLVRdaeyYlzzPyOwLW9137LTiNLPvHHxRWOlQ=;
        b=a5WI4lu5mklUc0uk/ZcOpJiY0bc39q4wc28VcNspJv0WxymDiYCAcnPExBUyApcvai
         L1niE0tyuh6Dq5BdWtzH79OEXKmrhcEW8WK2/4qYSl7ejhna4eUfhyMG9M+oaRrTfula
         zRFjt9gqbpxOzeAzs++8Qg5mnQl1RwpO5fc+F5BqYrzj29mdCh6EhueUqoBcgUC/w9OU
         nl1js9FwiQKFY8JdtlOVqaGlBUzLzTauwFvcqzClZbLpUxDEdia9HxjNHRj6+N+Q3wKZ
         ZCe1n6NneAggyqab78w/N3zx9vZ6KYESwgzFinYzgSUQvk2S7mBYe3ctWv4AbPTpgtAX
         mBAw==
X-Gm-Message-State: AOAM531qtEqF4Ax2oCpzwGFFvYK1oij8bsLiCvhoN9gGHhw0AU4JtBZ2
        YKCs1hlq+ABQOiGHRPLwRGoqG3CR9eJ0E2xld13zfQ==
X-Google-Smtp-Source: ABdhPJx72L9PTHP65KYB+Chk1pVDM2i5pbrY1n3nD597lNiVlNRAWKhNmButZTKgYb+Zf2Njgnk0RRcnltXUadULGpY=
X-Received: by 2002:a17:902:f54c:b029:124:109f:fd6e with SMTP id
 h12-20020a170902f54cb0290124109ffd6emr5973610plf.67.1624260494480; Mon, 21
 Jun 2021 00:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210615003016.477-1-ryazanov.s.a@gmail.com> <20210615003016.477-11-ryazanov.s.a@gmail.com>
 <CAMZdPi9mSfaYFnAt5Qux7HtCMkE-4KkkGL8i8T3rtxNXekK+Eg@mail.gmail.com> <CAHNKnsQdWWJ1tAHt4LPS=3jWNSCDcUdQDSrkZ9aakYp-4iaKVw@mail.gmail.com>
In-Reply-To: <CAHNKnsQdWWJ1tAHt4LPS=3jWNSCDcUdQDSrkZ9aakYp-4iaKVw@mail.gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 21 Jun 2021 09:37:09 +0200
Message-ID: <CAMZdPi_e+ibRQiytAYkjo1A9GzLm6Np6Tma-6KMHuWfFcaFsCg@mail.gmail.com>
Subject: Re: [PATCH net-next 10/10] wwan: core: add WWAN common private data
 for netdev
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergey,

On Sun, 20 Jun 2021 at 16:39, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>
> On Tue, Jun 15, 2021 at 10:24 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> > On Tue, 15 Jun 2021 at 02:30, Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> >> The WWAN core not only multiplex the netdev configuration data, but
> >> process it too, and needs some space to store its private data
> >> associated with the netdev. Add a structure to keep common WWAN core
> >> data. The structure will be stored inside the netdev private data before
> >> WWAN driver private data and have a field to make it easier to access
> >> the driver data. Also add a helper function that simplifies drivers
> >> access to their data.
> >
> > Would it be possible to store wwan_netdev_priv at the end of priv data instead?
> > That would allow drivers to use the standard netdev_priv without any change.
> > And would also simplify forwarding to rmnet (in mhi_net) since rmnet
> > uses netdev_priv.
>
> I do not think that mimicking something by one subsystem for another
> is generally a good idea. This could look good in a short term, but
> finally it will become a headache due to involvement of too many
> entities.
>
> IMHO, a suitable approach to share the rmnet library and data
> structures among drivers is to make the rmnet interface more generic.
>
> E.g. consider such netdev/rtnl specific function:
>
> static int rmnet_foo_action(struct net_device *dev, ...)
> {
>     struct rmnet_priv *rmdev = netdev_priv(dev);
>     <do a foo action here>
> }
>
> It could be split into a wrapper and an actual handler:
>
> int __rmnet_foo_action(struct rmnet_priv *rmdev, ...)
> {
>     <do a foo action here>
> }
> EXPORT_GPL(__rmnet_foo_action)
>
> static int rmnet_foo_action(struct net_device *dev, ...)
> {
>     struct rmnet_priv *rmdev = netdev_priv(dev);
>     return __rmnet_foo_action(rmdev, ...)
> }
>
> So a call from mhi_net to rmnet could looks like this:
>
> static int mhi_net_foo_action(struct net_device *dev, ...)
> {
>     struct rmnet_priv *rmdev = wwan_netdev_drvpriv(dev);
>     return __rmnet_foo_action(rmdev, ...)
> }
>
> In such a way, only the rmnet users know something special, while
> other wwan core users and the core itself behave without any
> surprises. E.g. any regular wwan core minidriver can access the
> link_id field of the wwan common data by calling netdev_priv() without
> further calculating the common data offset.

Yes, that would work, but it's an important refactoring since rmnet is
all built around the idea that netdev_priv is rmnet_priv, including rx
path (netdev_priv(skb->dev)).
My initial tests were based on this 'simple' change:
https://git.linaro.org/people/loic.poulain/linux.git/commit/?h=wwan_rmnet&id=6308d49790f10615bd33a38d56bc7f101646558f

Moreover, a driver like mhi_net also supports non WWAN local link
(called mhi_swip), which is a network link between the host and the
modem cpu (for modem hosted services...). This link is not managed by
the WWAN layer and is directly created by mhi_net. I could create a
different driver or set of handlers for this netdev, but it's
additional complexity.

> >> At the moment we use the common WWAN private data to store the WWAN data
> >> link (channel) id at the time the link is created, and report it back to
> >> user using the .fill_info() RTNL callback. This should help the user to
> >> be aware which network interface is binded to which WWAN device data
> >> channel.

I wonder if it would not be simpler to store the link ID into
netdev->dev_port, it's after all a kind of virtual/logical port.
That would only postpone the introduction of a wwan_netdev_priv struct though.

Regards,
Loic
