Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48B832F68A
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 00:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEXW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 18:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhCEXWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 18:22:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7307C06175F;
        Fri,  5 Mar 2021 15:22:03 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lIJlf-00027F-Sr; Sat, 06 Mar 2021 00:22:00 +0100
Date:   Sat, 6 Mar 2021 00:21:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Alexander Ahring Oder Aring <aahringo@redhat.com>, fw@strlen.de,
        netdev@vger.kernel.org, linux-man@vger.kernel.org,
        David Teigland <teigland@redhat.com>
Subject: Re: [PATCH resend] netlink.7: note not reliable if NETLINK_NO_ENOBUFS
Message-ID: <20210305232159.GB10808@breakpoint.cc>
References: <20210304205728.34477-1-aahringo@redhat.com>
 <20210305030437.GA4268@salvia>
 <CAK-6q+iBhzFVgm5NQaPCZhJ8tEvVVeTt2OAEGH4QkOfHqfYzaA@mail.gmail.com>
 <20210305203657.GA9426@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305203657.GA9426@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If I understand correctly, the connection tracking netlink interface
> > is an exception here because it has its own handling of dealing with
> > congestion ("more reliable"?) so you need to disable the "default
> > congestion control"?
> 
> In conntrack, you have to combine NETLINK_NO_ENOBUFS with
> NETLINK_BROADCAST_ERROR, then it's the kernel turns on the "more
> reliable" event delivery.

The "more reliable" event delivery guarantees that the kernel will
deliver at least the DESTROY notification (connection close).

If the userspace program is stuck, kernel has to hold on the expired
entries.  Eventually conntrack stops accepting new connections because
the table is full.

So this feature can't be recommended as a best-practice for conntrack
either.
