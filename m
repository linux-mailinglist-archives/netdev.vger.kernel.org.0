Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616FE3BEBBF
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbhGGQCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:02:21 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:57312 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhGGQCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 12:02:21 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 167FxUKe002271;
        Wed, 7 Jul 2021 17:59:30 +0200
Date:   Wed, 7 Jul 2021 17:59:30 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Maciej Zenczykowski <maze@google.com>
Subject: Re: [PATCH net] ipv6: tcp: drop silly ICMPv6 packet too big messages
Message-ID: <20210707155930.GE1978@1wt.eu>
References: <20210707154630.583448-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210707154630.583448-1-eric.dumazet@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Wed, Jul 07, 2021 at 08:46:30AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While TCP stack scales reasonably well, there is still one part that
> can be used to DDOS it.
> 
> IPv6 Packet too big messages have to lookup/insert a new route,
> and if abused by attackers, can easily put hosts under high stress,
> with many cpus contending on a spinlock while one is stuck in fib6_run_gc()

Just thinking loud, wouldn't it make sense to support randomly dropping
such packets on input (or even better rate-limit them) ? After all, if
a host on the net feels like it will need to send one, it will surely
need to send a few more until one is taken into account so it's not
dramatic. And this could help significantly reduce their processing cost.

Willy
