Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC6218161A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 11:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgCKKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 06:48:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50105 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCKKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 06:48:10 -0400
Received: from 2606-a000-111b-43ee-0000-0000-0000-1bf2.inf6.spectrum.com ([2606:a000:111b:43ee::1bf2] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1jByu4-0006Kh-Se; Wed, 11 Mar 2020 06:48:03 -0400
Date:   Wed, 11 Mar 2020 06:47:56 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>, jiri@mellanox.com,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kbuild@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: drop_monitor: use IS_REACHABLE() to guard
 net_dm_hw_report()
Message-ID: <20200311104756.GA1972672@hmswarspite.think-freely.org>
References: <20200311062925.5163-1-masahiroy@kernel.org>
 <20200311093143.GB279080@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311093143.GB279080@splinter>
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 11:31:43AM +0200, Ido Schimmel wrote:
> On Wed, Mar 11, 2020 at 03:29:25PM +0900, Masahiro Yamada wrote:
> > In net/Kconfig, NET_DEVLINK implies NET_DROP_MONITOR.
> > 
> > The original behavior of the 'imply' keyword prevents NET_DROP_MONITOR
> > from being 'm' when NET_DEVLINK=y.
> > 
> > With the planned Kconfig change that relaxes the 'imply', the
> > combination of NET_DEVLINK=y and NET_DROP_MONITOR=m would be allowed.
> > 
> > Use IS_REACHABLE() to avoid the vmlinux link error for this case.
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> Thanks, Masahiro.
> 
> Neil, Jiri, another option (long term) is to add a raw tracepoint (not
> part of ABI) in devlink and have drop monitor register its probe on it
> when monitoring.
> 
> Two advantages:
> 1. Consistent with what drop monitor is already doing with kfree_skb()
> tracepoint
> 2. We can remove 'imply NET_DROP_MONITOR' altogether
> 
> What do you think?
> 
Agreed, I think I like this implementation better.
Neil

