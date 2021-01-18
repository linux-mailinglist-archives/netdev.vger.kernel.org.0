Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370CB2F9D09
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389405AbhARKoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390002AbhARKcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:32:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A53C0613D3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:31:23 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b2so16959112edm.3
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 02:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4vN8V97DN/Vqa1SyeUnwLeX79EuS/Kv+b3WBKqiHhnI=;
        b=FnEBx2qfKNqnybHWuIwrXkl6v9LGFzPmppvbUCThM9uGl9kjheZkopYuQuRwJPT25q
         02cENnuvZU/Szsf/Bydl0bXvvGuAi9faCm8GTl5VPjuoYgfdXdhZ5JrPtAVSvuynK64U
         WHwbyhG2hrJ7sdKCItwv82qmXuagMxHJTfhiHog3KP1qs68aWRbkIiZKlXHuIuWde6FL
         v33qPeXBHj0z2hFXtZSGTM9ZKQGyxh4MFMX9YxcH610OJwqxx+NCSXnqbmGatY+p9mIl
         vhGg2StRZBLT9ue8lRFZvqeLtNL7/hTmegvOukGOo1YWkD5oh4GKzajB2pRoSv+GQfYB
         9oRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4vN8V97DN/Vqa1SyeUnwLeX79EuS/Kv+b3WBKqiHhnI=;
        b=rMib9uAZKhzvcXtu1PkHlGNKSBJKRQg+qS47aWGmlChsP6HLlOj/TFN9v7d2DesrCQ
         WSIcdpcAbmsfDkFxqR4KGYVEUPE9wM3b1cH0+IdyL5oKV+5df3+EhiA5vSeMW2HjJjRi
         aWPympvirTyTnulzkovqJ393GFp8Ibu60YAlwUYBRmcE+czIWtpp2d16g26jpf0i9n3t
         T4pegdeadn0NCc5WjHERVeUSgsBqND6hS2cQa3XC0DuudN43s+SzgGNRvWLdSCAjOsb+
         PXl3JYlf39YqGCKnUUTBwpqnS9xIHAblN/VMPDSZiQBYB3N8PgmxmMPh0Q5DUudVvG8P
         109g==
X-Gm-Message-State: AOAM530XjXwcDqmNQSJbang4izBa6iC6jPf01wYKlPdvtfg11zqzdz/X
        h6fy2IQGXdYHjhRoo0rfq0A=
X-Google-Smtp-Source: ABdhPJyadK6jWJHY7bO/seG9vgLG8Tl2nKCR1F8Vdp6zcTz9B1YKOkWgHhxqr3P2/cmHQ23O/mnSqw==
X-Received: by 2002:a05:6402:1e5:: with SMTP id i5mr1738553edy.86.1610965881769;
        Mon, 18 Jan 2021 02:31:21 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b26sm5289406edy.57.2021.01.18.02.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 02:31:21 -0800 (PST)
Date:   Mon, 18 Jan 2021 12:31:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [PATCH v6 net-next 11/15] net: catch errors from dev_get_stats
Message-ID: <20210118103119.3xkfjll5vkunum2x@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
 <20210109172624.2028156-12-olteanv@gmail.com>
 <b517b9a54761a0ee650d6d64712844606cf8a631.camel@kernel.org>
 <20210111231535.lfkv7ggjzynbiicc@skbuf>
 <6a6f5e835255a196f461b0e63a68b9bfa576ca1f.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a6f5e835255a196f461b0e63a68b9bfa576ca1f.camel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 03:51:39PM -0800, Saeed Mahameed wrote:
> On Tue, 2021-01-12 at 01:15 +0200, Vladimir Oltean wrote:
> > On Mon, Jan 11, 2021 at 02:54:50PM -0800, Saeed Mahameed wrote:
> > > On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> > > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > > dev_get_stats can now return error codes. Convert all remaining call
> > > > sites to look at that error code and stop processing.
> > > >
> > > > The effects of simulating a kernel error (returning -ENOMEM) upon
> > > > existing programs or kernel interfaces:
> > > >
> > > > - ifconfig and "cat /proc/net/dev" print up until the interface that
> > > >   failed, and there they return:
> > > > cat: read error: Cannot allocate memory
> > > >
> > > > - ifstat and "ip -s -s link show":
> > > > RTNETLINK answers: Cannot allocate memory
> > > > Dump terminated
> > > >
> > > > Some call sites are coming from a context that returns void (ethtool
> > > > stats, workqueue context). So since we can't report to the upper layer,
> > > > do the next best thing: print an error to the console.
> > > >
> > >
> > > another concern, one buggy netdev driver in a system will cause
> > > unnecessary global failures when reading stats via netlink/procfs
> > > for all the netdev in a netns, when other drivers will be happy to
> > > report.
> > >
> > > can't we just show a message in that driver's stats line about the
> > > occurred err ? and show the normal stats line of all others ?
> >
> > So you're worried that user space apps won't handle an error code when
> > reading from a file, but you're not worried that they'll start scraping
> > junk from procfs when we print this?
>
> both are equivalently concerning.
> to avoid any user crashes, we can just toss failed netdevs out from the
> output.

I'm not sure I'm on the same page here, basically I churned through the
whole kernel to propagate the error code from dev_get_stats, just to not
report it anywhere?
