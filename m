Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CB92F226E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389295AbhAKWJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:52768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730835AbhAKWJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 17:09:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EAC422CBE;
        Mon, 11 Jan 2021 22:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610402912;
        bh=4p3GlMa5uuzaUQpucb08pxfSVG1/RhEJjBvTXywbceg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MAFzJWUGNc7vfusWtiOs2a9vtCpqjlILFwU3lxeRNkV0I7EeqoE1zR8F4zAhmerGZ
         BpUL9jvs6WMrmq2rOCCnJOkPA9XjlsjtMztuf5h5e1dOcqws0gwtx3wTLG8QXAIkg/
         pTLRqW7okfTbpwvN2o6F0ywd0YIn1MGiR3d4dUUXDhMZv62RoGDpuePfP9fZ5EWTk2
         71OvW46TZFsimqes/Rr+scDabd4BHkIDlnuep/tie8d27ArIqgXP9hjXaWsrgs58WR
         sOJp/PabduZWc7V2TvA0Me0rudQdRE9gdPaZ/3bFt2A9getq2cXE/0yaACUvRE9E7v
         qlv0jZ7AyR9Vw==
Message-ID: <ae7cdf19f9ffcf5b6cc0a7cf44d068c94ec56f3f.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 07/15] net: remove return value from
 dev_get_stats
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
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
Date:   Mon, 11 Jan 2021 14:08:29 -0800
In-Reply-To: <20210109172624.2028156-8-olteanv@gmail.com>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-8-olteanv@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After commit 28172739f0a2 ("net: fix 64 bit counters on 32 bit
> arches"),
> dev_get_stats got an additional argument for storage of statistics.
> At
> this point, dev_get_stats could return either the passed "storage"
> argument, or the output of .ndo_get_stats64.
> 
> Then commit caf586e5f23c ("net: add a core netdev->rx_dropped
> counter")
> came, and the output of .ndo_get_stats64 (still returning a pointer
> to
> struct rtnl_link_stats64) started being ignored.
> 
> Then came commit bc1f44709cf2 ("net: make ndo_get_stats64 a void
> function") which made .ndo_get_stats64 stop returning anything.
> 
> So now, dev_get_stats always reports the "storage" pointer received
> as
> argument. This is useless. Some drivers are dealing with unnecessary
> complexity due to this, using another pointer to poke around the
> returned statistics, when they can do that directly through the
> stack-allocated struct rtnl_link_stats64.
> 
> Refactor these callers to ignore the return value completely and just
> access the values from their struct rtnl_link_stats64 local variable.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


