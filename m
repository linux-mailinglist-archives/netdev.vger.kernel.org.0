Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236B7301A81
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 09:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbhAXIV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 03:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbhAXIVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 03:21:24 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023E1C061573
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:20:42 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j13so11555971edp.2
        for <netdev@vger.kernel.org>; Sun, 24 Jan 2021 00:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KqAhcbtvXgxKqTJPDnavP9+wLR/Ha1yJImQ+0/E/jDA=;
        b=ScYbP3Fju0EAoWuWsgoSZI3IOy5hRAnfSyQs8Wvw9IzMrYbQo9uwYEZnItcH+mH3sD
         /erVfT463y0llLhzZQgozQtDVQvR02vUAbQN+5FLG/XRdO1fpVLBverKB0JLAeiWAWSU
         awISPeDEbwimjX5ote/hU6G/CsbRZSRYep27+UIXZbGMK/ftGWmDdSieWQbTv8tVoIit
         BfPnLCNrlH7FzFoS1V3/rk7WGGXf3yCLugU8lyZYbMsuc3Tax1XQtT2SLcbL0nA1ZOQQ
         d8HFPxkYuakJhaD0X3SlH87W/c0esx6XIDFCbasbfY83YHAzRFyBJRITNfe4wQ07Eq3h
         UbSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KqAhcbtvXgxKqTJPDnavP9+wLR/Ha1yJImQ+0/E/jDA=;
        b=DzlnWew/Izzhtz9Yj1Hs5FjAdvFUw24FyC3oNXAi2W5X95ZYQ7hf/wY+04l8rj7eeH
         LS2TIB9Zjx6CsIaCdXW8wgWVoFj66A7pGTw79EDhqQAWuwXV+i3Q26LuqCYleXZJz8o5
         s1yyOqgLxJ7G3eT48/CCqvkw1+gBxSMI3bymlUsk6Xn9IPH2Q11maflp3v7p4cHEiY6t
         t4MWMethB9QZsLLLlmJTu+NMSIQlnMaPGm3P/x6+7CVT1+2ZHWUkgCIRQjVlKV/es9Ul
         KPynfSnCoAsY5o6koxISeBedEki3+8xsLIA/ddnp8ItLZ4H6IldnMmJVZhIqvlmkCoXy
         mkOA==
X-Gm-Message-State: AOAM530kXJXsndsz0w0gTYSfdllkgUsgIufy/bLnQW0kDHOZfF6wIh27
        sisePM+AJbkH9NaI2sFHa7I=
X-Google-Smtp-Source: ABdhPJxXyq16il3eoftiZIxryucQrklt4t+SfET76Mvba76j4ed1u3m09vkT7x9pJifc/p40DU2Jlg==
X-Received: by 2002:a50:fe85:: with SMTP id d5mr5705edt.140.1611476441597;
        Sun, 24 Jan 2021 00:20:41 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id w11sm8713032edj.8.2021.01.24.00.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jan 2021 00:20:40 -0800 (PST)
Date:   Sun, 24 Jan 2021 10:20:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v6 net-next 07/10] net: dsa: allow changing the tag
 protocol via the "tagging" device attribute
Message-ID: <20210124082039.gkgxskot7oxseub7@skbuf>
References: <20210121160131.2364236-1-olteanv@gmail.com>
 <20210121160131.2364236-8-olteanv@gmail.com>
 <20210122205216.7f1e05f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122205216.7f1e05f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 08:52:16PM -0800, Jakub Kicinski wrote:
> On Thu, 21 Jan 2021 18:01:28 +0200 Vladimir Oltean wrote:
> > +	/* At the moment we don't allow changing the tag protocol under
> > +	 * traffic. May revisit in the future.
> > +	 */
> > +	if (master->flags & IFF_UP)
> > +		return -EBUSY;
>
> But you're not holding rtnl_lock at this point, this check is advisory
> at best.

Yes, I should hold the rtnl_mutex.

> > +	list_for_each_entry(dp, &dst->ports, list) {
>
> What protects this iteration? All sysfs guarantees you is that
> struct net_device *master itself will not disappear.
>
> Could you explain the locking expectations a bit?

The dsa_group sysfs is removed in:

dsa_unregister_switch
-> mutex_lock(&dsa2_mutex)
-> dsa_switch_remove
   -> dsa_tree_teardown
      -> dsa_tree_teardown_master
         -> dsa_master_teardown
            -> sysfs_remove_group
There are 2 points here:
1. sysfs_remove_group actually waits for a concurrent tagging_store()
   call to finish (at least it does when I put an msleep(10000) inside
   tagging_store).
2. After the sysfs_remove_group, dsa_tree_change_tag_proto should never
   be called again.

Next comes:
   -> dsa_tree_teardown
      -> dsa_tree_teardown_switches
         -> dsa_port_teardown
            -> dsa_slave_destroy
After this, all DSA net devices are unregistered and freed.

Next comes:
-> dsa_switch_remove
   -> dsa_switch_release_ports
-> mutex_unlock(&dsa2_mutex)
where the dst->ports list is finally freed.

So there is no chance that the dst->ports list is modified concurrently
with tagging_store.
