Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A288B47E4F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfFQJZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:25:04 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42950 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726286AbfFQJZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 05:25:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hcnsr-0003zM-IO; Mon, 17 Jun 2019 11:25:01 +0200
Date:   Mon, 17 Jun 2019 11:25:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Ran Rozenstein <ranro@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH net-next v3 7/7] net: ipv4: provide __rcu annotation for
 ifa_list
Message-ID: <20190617092501.vu3trkq4nvgkkilv@breakpoint.cc>
References: <20190531162709.9895-1-fw@strlen.de>
 <20190531162709.9895-8-fw@strlen.de>
 <04a5f0ab-00b7-7ba9-2842-915479abe6be@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a5f0ab-00b7-7ba9-2842-915479abe6be@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq Toukan <tariqt@mellanox.com> wrote:
> On 5/31/2019 7:27 PM, Florian Westphal wrote:
> > ifa_list is protected by rcu, yet code doesn't reflect this.
> > 
> > Add the __rcu annotations and fix up all places that are now reported by
> > sparse.
> > 
> > I've done this in the same commit to not add intermediate patches that
> > result in new warnings.
> > 
> > Reported-by: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Hi Florian,
> 
> Our verification team bisected a degradation [1], seems to be in this patch.
> I see you already posted one fix for it [2], but it does not solve.
> Any idea?

Thanks for the report, is there are reproducer?

> [2019-06-11 22:38:19] 8021q: adding VLAN 0 to HW filter on device ens8f1
> [2019-06-11 22:38:47] watchdog: BUG: soft lockup - CPU#4 stuck for 22s! 
> [ifconfig:32042]

> [2019-06-11 22:38:47] RIP: 0010:__inet_del_ifa+0xa5/0x300

I will have look later today.
