Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B060C3752BD
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhEFLCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbhEFLCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:02:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832B6C061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 04:01:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h4so5116820wrt.12
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 04:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5dWfQBlf5OfCEX63KNQKTMBrmuE9VEsWTKJ/CKEXQrc=;
        b=ZJMC377CEcG3jsRUzzY486AWcII4/CnqUc4avz8c/V9BImhMrKYjPuWS8H1/3yPFu0
         4jruOYgK/YW1tTACWYlmAuZj8ADXjyOvCaMQH+0ALt//OFIU+ajp4gVPhUEZt+y56AYy
         hDj/i43py82vHd/luggzigkGkH4mv4PAeX9+6uPttoyXQIh/3aSr9/nGVXYd87L9U4Us
         PKNIuEJgR6L1LwZZW9c6fypfZgluIxEnBPoEAUeLN6nMsiuBPEpWiqLU51yqmOzIl7zd
         dTZOA5PBiFceip5KejOW6Am/VGoTDc2gOPEeC5Thrgz7kZ8YE5rfv4egIgsQruWD7t+f
         Xhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5dWfQBlf5OfCEX63KNQKTMBrmuE9VEsWTKJ/CKEXQrc=;
        b=cYyW9etjHLFEfEtl7Fg4gzd/eyVtJJBKw72KIgbBskVQwmRLoXTLX+VfbdGP0D2GYm
         SWxox77Vb7tcEk2nFjaXejjGgBHoMoMMSbJVgKRHFxXLemIckzCsfF/S7sEWDUiiZbOY
         MoqZPX1Vf/18z3AKzVnQ21u8LfxR9UdnhFT9fAfI61vuJCr6Rxv3lx1H+3tauDUbDqlO
         6RWRDgmuD7OSUWBCMC/Ghtqizr+qxwQCdxYzP4tU36bJwOPVy2jpiRnGfWcapO4Be3uK
         8ZMyC0oatYfSAAgYUUEFw4FqjAtXks7PagLhFpC9e+5aKE5XOpX9+nvABgwMjRTW05UL
         p+SA==
X-Gm-Message-State: AOAM532UFf7BZrjvMQtHE9Tq7nbrs8iJqe2htKJsd4tGGutUjGd9weCV
        0u2cfH8GrTK9IyTKN1jThgQ=
X-Google-Smtp-Source: ABdhPJzbYdd4jBCRBhgkIElCKjLRCNukmEU92WcLW5k5BctpK2k8jBbyc0dD7f63vNaKxaukVHGFIA==
X-Received: by 2002:a5d:570e:: with SMTP id a14mr4405860wrv.254.1620298875324;
        Thu, 06 May 2021 04:01:15 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id j10sm3637913wrt.32.2021.05.06.04.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:01:14 -0700 (PDT)
Date:   Thu, 6 May 2021 14:01:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@resnulli.us, stephen@networkplumber.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [RFC net-next 4/9] net: bridge: switchdev: Forward offloading
Message-ID: <20210506110113.xeb6yzh6ycxr5nxi@skbuf>
References: <20210426170411.1789186-1-tobias@waldekranz.com>
 <20210426170411.1789186-5-tobias@waldekranz.com>
 <YI6/li9hwHo8GfCm@shredder>
 <87eeeonqpb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eeeonqpb.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 10:53:36AM +0200, Tobias Waldekranz wrote:
> On Sun, May 02, 2021 at 18:04, Ido Schimmel <idosch@idosch.org> wrote:
> > On Mon, Apr 26, 2021 at 07:04:06PM +0200, Tobias Waldekranz wrote:
> >> +static void nbp_switchdev_fwd_offload_add(struct net_bridge_port *p)
> >> +{
> >> +	void *priv;
> >> +
> >> +	if (!(p->dev->features & NETIF_F_HW_L2FW_DOFFLOAD))
> >> +		return;
> >> +
> >> +	priv = p->dev->netdev_ops->ndo_dfwd_add_station(p->dev, p->br->dev);
> >
> > Some changes to team/bond/8021q will be needed in order to get this
> > optimization to work when they are enslaved to the bridge instead of the
> > front panel port itself?
> 
> Right you are. We should probably do something similar to the
> switchdev_handle_port_* family of helpers that could be reused in
> stacked devices. I will look at it for v1.

Makes sense, issuing a switchdev notifier of some sort will allow the
switchdev driver to act upon the bridge's request for a net device
belonging to a different driver.
