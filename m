Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E323159DE
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 00:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbhBIXHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 18:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234252AbhBIWyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:54:18 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46A9C06178C;
        Tue,  9 Feb 2021 14:51:56 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id b9so266980ejy.12;
        Tue, 09 Feb 2021 14:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iIyWAOeW0XMcNsoXJ5PtY4MXLZl7m47B6NixrVZ9rLY=;
        b=QROU2sHT54xgG1rdVX7quLFP4mqoeCSQs0ThOZCX6uDYptZlkgvUpc/Ua16G2M3IIm
         9mdHcpY1TXWxExmULswJGhiblC8SQfzMkYkQWF7ZxVuKSJDzUDqNFvOVkcO2XvDg0nMw
         zyw4YLRSyDlGbE7wjuhFx4axkFNewJj6fX0wX7TpARXuhuN///jUgZHAwBtuwEI3Y65B
         d5T936dLuKJtlPkWBCd6BhOwJkMtcntkYBmGdvPtuNWqxRJaXc/Fgmk0GIujYiNrIz7e
         S3vWVSpw8FHphgotzxypXVcocDnAfs7N90I/G+oBQS1UgiBE62ZsmoWY0TKQpUgtxwO1
         lLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iIyWAOeW0XMcNsoXJ5PtY4MXLZl7m47B6NixrVZ9rLY=;
        b=Z+VsKDoaViZHESy0xASznPAFY2QgG/oAo/pxe1ZALmnodKa5HCg+oJfA2ruW2OgttZ
         8MZFgNXrwMRs6fryE30yMRlRLaYq677o8SBJwhtZAUGhv16En7LOL8UU1UF6vyl1kcr9
         21SUfmp4IufxRwCYJwDVesKVeORmapMXSGvQHcsxJuLSlwNzRWQVld3kuggWnbYsXJI6
         DlDdcJhajur/FdjLz8ffftYgBbxjfWBpj0Ivfxqmz4iokXgzh5Q8KW/KYv8pdFocYbcY
         7mO7OEABuYQ/e8wNS4QjAkmudOoYydPVQwzEt3fDEp0ZhqnVeozkQeJ357/TjhqU33sT
         IgjA==
X-Gm-Message-State: AOAM5314uhmI+/qCwDXBOP3ArxiN090Ib15GNFshrCmlrOsGjpuB1CUS
        WgYwtihgqeXpBXRtGqAvRjk=
X-Google-Smtp-Source: ABdhPJxnm/2Oy51X5r9okPXZbs0ExERqCkzNQ+8h7ASZynbjNBPmsOzitXLwMBz6MvIjMoUAhAwnvQ==
X-Received: by 2002:a17:906:560b:: with SMTP id f11mr25703142ejq.162.1612911115421;
        Tue, 09 Feb 2021 14:51:55 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ga5sm63174ejb.114.2021.02.09.14.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 14:51:54 -0800 (PST)
Date:   Wed, 10 Feb 2021 00:51:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 net-next 04/11] net: bridge: offload initial and final
 port flags through switchdev
Message-ID: <20210209225153.j7u6zwnpdgskvr2v@skbuf>
References: <20210209151936.97382-1-olteanv@gmail.com>
 <20210209151936.97382-5-olteanv@gmail.com>
 <20210209185100.GA266253@shredder.lan>
 <20210209202045.obayorcud4fg2qqb@skbuf>
 <20210209220124.GA271860@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209220124.GA271860@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:01:24AM +0200, Ido Schimmel wrote:
> On Tue, Feb 09, 2021 at 10:20:45PM +0200, Vladimir Oltean wrote:
> > On Tue, Feb 09, 2021 at 08:51:00PM +0200, Ido Schimmel wrote:
> > > On Tue, Feb 09, 2021 at 05:19:29PM +0200, Vladimir Oltean wrote:
> > > > So switchdev drivers operating in standalone mode should disable address
> > > > learning. As a matter of practicality, we can reduce code duplication in
> > > > drivers by having the bridge notify through switchdev of the initial and
> > > > final brport flags. Then, drivers can simply start up hardcoded for no
> > > > address learning (similar to how they already start up hardcoded for no
> > > > forwarding), then they only need to listen for
> > > > SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS and their job is basically done, no
> > > > need for special cases when the port joins or leaves the bridge etc.
> > >
> > > How are you handling the case where a port leaves a LAG that is linked
> > > to a bridge? In this case the port becomes a standalone port, but will
> > > not get this notification.
> >
> > Apparently the answer to that question is "I delete the code that makes
> > this use case work", how smart of me. Thanks.
>
> Not sure how you expect to interpret this.

Next patch (05/11) deletes that explicit notification from dsa_port_bridge_leave,
function which is called from dsa_port_lag_leave too, apparently with good reason.

> > Unless you have any idea how I could move the logic into the bridge, I
> > guess I'm stuck with DSA and all the other switchdev drivers having this
> > forest of corner cases to deal with. At least I can add a comment so I'm
> > not tempted to delete it next time.
>
> There are too many moving pieces with stacked devices. It is not only
> LAG/bridge. In L3 you have VRFs, SVIs, macvlans etc. It might be better
> to gracefully / explicitly not handle a case rather than pretending to
> handle it correctly with complex / buggy code.
>
> For example, you should refuse to be enslaved to a LAG that already has
> upper devices such as a bridge. You are probably not handling this
> correctly / at all. This is easy. Just a call to
> netdev_has_any_upper_dev().

Correct, good point, in particular this means that joining a bridged LAG
will not get me any notifications of that LAG's CHANGEUPPER because that
was consumed a long time ago. An equally valid approach seems to be to
check for netdev_master_upper_dev_get_rcu in dsa_port_lag_join, and call
dsa_port_bridge_join on the upper if that is present.

> The reverse, during unlinking, would be to refuse unlinking if the upper
> has uppers of its own. netdev_upper_dev_unlink() needs to learn to
> return an error and callers such as team/bond need to learn to handle
> it, but it seems patchable.

Again, this was treated prior to my deletion in this series and not by
erroring out, I just really didn't think it through.

So you're saying that if we impose that all switchdev drivers restrict
the house of cards to be constructed from the bottom up, and destructed
from the top down, then the notification of bridge port flags can stay
in the bridge layer?
