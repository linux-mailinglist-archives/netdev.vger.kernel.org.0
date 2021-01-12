Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BF12F3D5F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393004AbhALVgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436670AbhALUHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:07:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CFEE22CAD;
        Tue, 12 Jan 2021 20:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610482010;
        bh=BYOwi14XIyMWkUkXWLq4Q2TVCPjAj1Mu1pWypYSjWts=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EsYCkK/3Zt4n61rmkWrDwHgrI1kAnrOrSV0KwQnIwN6+TTTBAb8iTvdq4ny7bpueF
         e39HRyc6asxB3bIHIHKwCxlatMYBskpVqXrIatRLv4rrQ9fHy9CjSVcfSYla1B4/uj
         y0ddnCvKS+qXLzKyROZO13BA9coOhk0iZq1HKcSITpFfFIFAVgg0HanhzygQ4Bj9Js
         32vURnCNm7ZvXxTuc7mgkg4yznn7ot1MrAIqCsh4QJjqxBbx1QxGsbkmCZHAHZl9oY
         xFmTv2OIMlWDFR1FbQZ0AaQgN6dBW0GT5jHsPeUSVbhUDUg260WCaxpIhSXrrSj5G3
         5z7Pxe1VEVFbg==
Message-ID: <63682fd5278a6b6bd116529b7b8a1487969edf80.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 03/15] net: procfs: hold netif_lists_lock
 when retrieving device statistics
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
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
Date:   Tue, 12 Jan 2021 12:06:47 -0800
In-Reply-To: <20210112134410.pr5lqv4hcxe3dxfy@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-4-olteanv@gmail.com>
         <fa9efc8c4c0cb3dd3b0bba153b4b368e64ff06c3.camel@kernel.org>
         <20210112134410.pr5lqv4hcxe3dxfy@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 15:44 +0200, Vladimir Oltean wrote:
> On Mon, Jan 11, 2021 at 03:46:32PM -0800, Saeed Mahameed wrote:
> > This can be very costly, holding a mutex while traversing the whole
> > netedv lists and reading their stats, we need to at least allow
> > multiple readers to enter as it was before, so maybe you want to
> > use
> > rw_semaphore instead of the mutex.
> > 
> > or just have a unified approach of rcu+refcnt/dev_hold as you did
> > for
> > bonding and failover patches #13..#14, I used the same approach to
> > achieve the same for sysfs and procfs more than 2 years ago, you
> > are
> > welcome to use my patches:
> > https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/
> 
> Ok, what mail address do you want me to keep for your sign off?

Either is fine. Just make sure author and signed-off are the same :).
Thanks!


