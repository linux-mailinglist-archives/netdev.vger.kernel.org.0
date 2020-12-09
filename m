Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7F2D3E01
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgLII5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbgLII5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:57:48 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9DBC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 00:57:08 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id m25so2020109lfc.11
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 00:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=VX+ohVJ0dfspS+7p1Jyr/L+1PORQux5Vem16IxlCaNI=;
        b=emZh3CSiEoRqMb5N88UR8khVsmmwl6HMflMLwpQ0GjVlkX294lbOb4x8ZGv4yIYgwE
         8j1c4GYKoXc0f9tTYI/AeIqPeL7MY/qzMaovwGCLiIlE8x8vYpAigdJI0g55G/7TO/X7
         wTAbZEvb8odrC2NJjwBPPXNMK+niEzcyDqG3fXrXY1qS2qdpnfApz0ffIOOx36WK7/N9
         YhrbD3nkbAbCn713nOL4g9naVOioGWbnFV9WiILvopgGYd3LyztyfsOgcWbfluaHm9aY
         foHhh8uXy568yUEz0zulCQNQQjXe9X1Ozj+14veltw3O/dK48jE7fxzFEyBfDtyYZ1yI
         E77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VX+ohVJ0dfspS+7p1Jyr/L+1PORQux5Vem16IxlCaNI=;
        b=hAOPVt/gp5z2AY1huN/XpJd2pMu3/356+nYO79FvF1aCLzPmI0LcbPwEyQeG94hrs4
         dFfNL8gl5BW3tCjwSk4PGxxR3bALlglK0LHbLYk64M09JtNHL+RTVo+y2oEoeAIB+ezQ
         LjBW4OSwVJQWz5vGdh0Tq+rDc3ZRLr2sUkMFhGts1oxFgldI5ra2EGm6FOsHWi2x41h0
         KQ15RDN0z0fQM/Ss9sUa0tRA5a3znqLogsAOEVvf1HVi1SWMVZtrUQhut4PIRK7H87PJ
         WZOzCqx5wyGTcR9pNzF13Ccoq9gqarfbNWLM2Az2VHgpBfnFMn50Omx1kfdmx1UPShs+
         81Xw==
X-Gm-Message-State: AOAM532KhX2EwuVRP2dnwpc3rOx2n4iTTOblCbM4MoXuQc0EznNqIIVG
        9ThLn32PpAr+V6+Ui/rJuaQJmerCV9Sbzb1x
X-Google-Smtp-Source: ABdhPJzCK9qkdhsJ17AdScdfd28/SeqHrw7HZb1h7SzMGZq8hKL3eutXsTlW3hwuD6AeRaJMZLx8nA==
X-Received: by 2002:a19:c194:: with SMTP id r142mr657263lff.122.1607504226338;
        Wed, 09 Dec 2020 00:57:06 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e27sm100338lfc.155.2020.12.09.00.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 00:57:05 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201207232622.GA2475764@lunn.ch>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201204022025.GC2414548@lunn.ch> <87v9dd5n64.fsf@waldekranz.com> <20201207232622.GA2475764@lunn.ch>
Date:   Wed, 09 Dec 2020 09:57:05 +0100
Message-ID: <87h7ov5pcu.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 00:26, Andrew Lunn <andrew@lunn.ch> wrote:
> On Mon, Dec 07, 2020 at 10:19:47PM +0100, Tobias Waldekranz wrote:
>> On Fri, Dec 04, 2020 at 03:20, Andrew Lunn <andrew@lunn.ch> wrote:
>> >> +static inline bool dsa_port_can_offload(struct dsa_port *dp,
>> >> +					struct net_device *dev)
>> >
>> > That name is a bit generic. We have a number of different offloads.
>> > The mv88E6060 cannot offload anything!
>> 
>> The name is intentionally generic as it answers the question "can this
>> dp offload requests for this netdev?"
>
> I think it is a bit more specific. Mirroring is an offload, but is not
> taken into account here, and does mirroring setup call this to see if
> mirroring can be offloaded? The hardware has rate control traffic
> shaping which we might sometime add support for via TC. That again is
> an offload.

I see what you are saying.

>> >> +{
>> >> +	/* Switchdev offloading can be configured on: */
>> >> +
>> >> +	if (dev == dp->slave)
>> >> +		/* DSA ports directly connected to a bridge. */
>> >> +		return true;
>> 
>> This condition is the normal case of a bridged port, i.e. no LAG
>> involved.
>> 
>> >> +	if (dp->lag && dev == rtnl_dereference(dp->lag->dev))
>> >> +		/* DSA ports connected to a bridge via a LAG */
>> >> +		return true;
>> 
>> And then the indirect case of a bridged port under a LAG.
>> 
>> I am happy to take requests for a better name though.
>
> There probably needs to be lag in the name.

I disagree. A LAG is one type of netdev that a DSA port can offload. The
other one is the DSA port's own netdev, i.e. what we have had since time
immemorial.

dsa_port_offloads_netdev(dp, dev)?
