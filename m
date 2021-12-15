Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958704754FE
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 10:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241102AbhLOJSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 04:18:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236009AbhLOJSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 04:18:16 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B9BC06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 01:18:15 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 8so20169085pfo.4
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 01:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PuUpV7unZmDgwkYXvnbs8yf/Y2SOw0EcLwtXV3LJfDE=;
        b=EJj8entE9fccxgKtWpK2X0p2L1Nzsln4+xQCyKlCaPjieIxV4K30Fx70/AxkqNunZC
         kJPeAQgkePmYa+PSoGPscDigPn9uvqq89tHBq8uAccgzV12ta0i2KSbIioQgrN+WuL6r
         sBxxLSq+UAPW395eA5SPZNyETeiBBaDIG1sUmqJt+ZKj5eD+3wbiW5/aTGAhAafuKX9g
         wUuwNLUn9xhVPq/nXQ1K3qX5AwPYM0N2Vo/yqUrQrlki2CXQDDQhD0IbSZL2BXsXPQ1M
         Alf0ISOpNMzECaq1yfhsK+DWl7Xa4O5VwhtQzBPag0f/zuMgcXcThDfwTUJIugprzE1m
         a6jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PuUpV7unZmDgwkYXvnbs8yf/Y2SOw0EcLwtXV3LJfDE=;
        b=oMVU2b+TtgsMOuhPeqvQwwoyCBhC8Csrezrj8i6ZLxcgGirhWdwe+GP3Mk7uEg7UID
         flp3BQQkBJMzIR+uU4edjKfdtxU0iz80LUj87WQVWc7dbt1iWOzB9KhsAD7/foULpm/9
         1bjm6TDuPhWVe9+HY7e++VsQOUBB79W4qiBZGNUWVaiLREn0g1PUYaTtKt7tKv9MmJWa
         XfqTLkgFZN37E0OqcLtYY04ryKTfkGy8aV/T8fBCub5I5eJBatg7MVdoW8x4rlqn9z5z
         Jg/2lx25RZlyaBsM9vg32YNSNmuQ2EQfBZjBMo8lIcEAM5n9Yhgk/gdLEPm9EUZIxjzz
         rgBQ==
X-Gm-Message-State: AOAM532zRZofeplbMojqovhW2IeUZaonVPIIwF64FBuo4cx/kY5mTxZj
        oBN6YnhGU9gqy/9l7t4KcLTOyl4Wtp+vs/DVQSPT4A==
X-Google-Smtp-Source: ABdhPJweKdAqX4eth/0RRfyhxeipqNSi1Pn37tjp7vkwm8PbUqsllU7qQk/phWZI5KFGpeGw/yMtpaRR3rKlcbgDZ1c=
X-Received: by 2002:a63:2212:: with SMTP id i18mr7095763pgi.586.1639559895299;
 Wed, 15 Dec 2021 01:18:15 -0800 (PST)
MIME-Version: 1.0
References: <20211208040414.151960-1-xiayu.zhang@mediatek.com>
 <CAHNKnsRZpYsiWORgAejYwQqP5P=PSt-V7_i73G1yfh-UR2zFjw@mail.gmail.com>
 <6f4ae1d8b1b53cf998eaa14260d93fd3f4c8d5ad.camel@mediatek.com>
 <CAHNKnsQ6qLcUTiTiPEAp+rmoVtrGOjoY98nQFsrwSWUu-v7wYQ@mail.gmail.com> <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
In-Reply-To: <76bc0c0174edc3a0c89bb880a237c844d44ac46b.camel@mediatek.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 15 Dec 2021 10:29:48 +0100
Message-ID: <CAMZdPi_bpCdbxsEfh-=-LzGywsmXqoqujg-8H8y1bp2VM5uayw@mail.gmail.com>
Subject: Re: [PATCH] Add Multiple TX/RX Queues Support for WWAN Network Device
To:     Xiayu Zhang <xiayu.zhang@mediatek.com>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?UTF-8?B?Wmhhb3BpbmcgU2h1ICjoiJLlj6zlubMp?= 
        <Zhaoping.Shu@mediatek.com>,
        =?UTF-8?B?SFcgSGUgKOS9leS8nyk=?= <HW.He@mediatek.com>,
        srv_heupstream <srv_heupstream@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiayu, Sergey,

> > > > As for the default queues number selection it seems better to
> > > > implement the RTNL .get_num_rx_queues callback in the WWAN core
> > > > and
> > > > call optional driver specific callback through it. Something like
> > > > this:
> > > >
> > > > static unsigned int wwan_rtnl_get_num_tx_queues(struct nlattr
> > > > *tb[])
> > > > {
> > > >     const char *devname = nla_data(tb[IFLA_PARENT_DEV_NAME]);
> > > >     struct wwan_device *wwandev = wwan_dev_get_by_name(devname);
> > > >
> > > >     return wwandev && wwandev->ops && wwandev->ops-
> > > > >get_num_tx_queues
> > > > ?
> > > >               wwandev->ops->get_num_tx_queues() : 1;
> > > > }
> > > >
> > > > static struct rtnl_link_ops wwan_rtnl_link_ops __read_mostly = {
> > > >     ...
> > > >     .get_num_tx_queues = wwan_rtnl_get_num_tx_queues,
> > > > };
> > > >
> > > > This way the default queues number selection will be implemented
> > > > in a
> > > > less surprising way.
> > > >
> > > > But to be able to implement this we need to modify the RTNL ops
> > > > .get_num_tx_queues/.get_num_rx_queues callback definitions to
> > > > make
> > > > them able to accept the RTM_NEWLINK message attributes. This is
> > > > not
> > > > difficult since the callbacks are implemented only by a few
> > > > virtual
> > > > devices, but can be assumed too intrusive to implement a one
> > > > feature
> > > > for a single subsystem.

I agree with this solution. The wwan core can forward
get_num_tx_queues to per wwan driver callbacks or simply rely on a
'default_tx_queues' field in ops struct. As said previously, you need
a user for this change in the same series.

Regards,
Loic
