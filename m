Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73415224DE1
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 22:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgGRUoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 16:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgGRUoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 16:44:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99AC0619D2;
        Sat, 18 Jul 2020 13:44:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so14325043ejq.6;
        Sat, 18 Jul 2020 13:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eNqJDV2iAMbq3HVML7UY4zvrGwXZas14mdyS5+WPjI4=;
        b=XLhU1J8FakGTXzyCXK29IR7yOpuNOnMflHC6IXEV8Lq7t7DAUY0nROV0cDLymtdP/w
         xgY39O5TZwZRiNqyI0PiXmxSxFLYj3tTHJ/mf0Q9bLElo96BzIcqaUMSFoGC8ikA4cLj
         dKgokNhK7Ts7oLOs4OfxFDRyf4p8WBQ6r9f39kMtaOuyE4polbuZnnxtd0oQWKJrDJfP
         /C2OlppPcnH0w62FeeL1sWnH4w+IVNXDZTx/KxTx8tWyhtJGpMC5nGuLkoeazSgmj++A
         6/kIWSh/AcvcLNROfgk6tq1gZaUS347/esAXD59MdyxvCnFnUWfGHsuxkpZoH0jPIcQ6
         +w4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eNqJDV2iAMbq3HVML7UY4zvrGwXZas14mdyS5+WPjI4=;
        b=V/APiKeEXHlBwMI5WAuevBADk+K8mI8kY0RVA/BRoQLd+UNJzjhFqXdMtbabJ4Id0o
         hV2gIRMS5VHbKNnPP7nVNQNWVQ8xUNiI3HcGK4m+u2o+tqcZVAhSz9E2GbYRM+iJFn2i
         dgQWTOfe124p4xE30AnfegbAcw22EJaGo335OE6vhMtZIGEAfuqQe2/TBR31Z9B92qip
         tC6SSXR+j3Q3VLkzZtSbemRQQnVdMN284rgLfeIE9nrVtYf0zdkls9u4ohLPwjMw4tZV
         WgozmckaiQLamfI8TSxAB8PGkUGIRxqfsOebJ/23XUutqllwXKPdITgBB8/9FNAVHuA7
         N76Q==
X-Gm-Message-State: AOAM533K+EE4quYjQAjd9fKgRLe5eHkWNT9VZo14SpQstmDk46Ym8v6h
        IjEEHX8C0P1fCGVGLYzB9a5QUqdE
X-Google-Smtp-Source: ABdhPJww2TePyFELFYDJJTj3a4AKOkpWnGNQcpk4a0PKldZO65voQAqwZVog3Igem7fw6kpBafCDrQ==
X-Received: by 2002:a17:906:7d9:: with SMTP id m25mr13834151ejc.25.1595105044501;
        Sat, 18 Jul 2020 13:44:04 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id a8sm11572688ejp.51.2020.07.18.13.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 13:44:03 -0700 (PDT)
Date:   Sat, 18 Jul 2020 23:44:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: Wrap ndo_do_ioctl() to prepare for DSA
 stacked ops
Message-ID: <20200718204401.237cie3gufldls2o@skbuf>
References: <20200718030533.171556-1-f.fainelli@gmail.com>
 <20200718030533.171556-2-f.fainelli@gmail.com>
 <20200718203010.6dg5chsor5rufkaa@skbuf>
 <a8b08bf9-2f45-8816-4056-2da42d4d9e24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8b08bf9-2f45-8816-4056-2da42d4d9e24@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 01:36:25PM -0700, Florian Fainelli wrote:
> 
> 
> On 7/18/2020 1:30 PM, Vladimir Oltean wrote:
> > Hi Florian,
> > 
> > On Fri, Jul 17, 2020 at 08:05:30PM -0700, Florian Fainelli wrote:
> >> In preparation for adding another layer of call into a DSA stacked ops
> >> singleton, wrap the ndo_do_ioctl() call into dev_do_ioctl().
> >>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> ---
> > 
> > I missed most of the context, but this looks interesting. Am I correct
> > in saying that this could save us from having to manually pass
> > phy_mii_ioctl() and that it could be generically handled here?
> 
> The motivation for this work started with the realization while
> untangling the ethtool/netlink and PHY library that tests like those:
> dev->netdev_ops == &foo_ops would be defeated by the way DSA overloads
> the DSA net_device operations. A better solution needed to be found.
> 
> You are correct that we could just put a call to phy_mii_ioctl() here as
> well and avoid having drivers have to use phy_do_ioctl_running or roll
> their own.
> -- 
> Florian

I see.
The background for my question is that we came to realize that it would
be way cleaner if an Ethernet PHY with 1588 timestamping could just
overload .ndo_do_ioctl() and the ethtool .get_ts_info() of the host
network interface, very similarly to what DSA does.
So it's very good that you started this work, it looks like it provides
a very good foundation. Thanks!

-Vladimir
