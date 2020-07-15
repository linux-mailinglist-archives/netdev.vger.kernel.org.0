Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125B1220D30
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgGOMnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgGOMnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:43:00 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37C5C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 05:43:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jvgkU-0001R5-TJ; Wed, 15 Jul 2020 14:42:58 +0200
Date:   Wed, 15 Jul 2020 14:42:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org, aconole@redhat.com
Subject: Re: [PATCH net-next 1/3] udp_tunnel: allow to turn off path mtu
 discovery on encap sockets
Message-ID: <20200715124258.GP32005@breakpoint.cc>
References: <20200712200705.9796-1-fw@strlen.de>
 <20200712200705.9796-2-fw@strlen.de>
 <20200713003813.01f2d5d3@elisabeth>
 <20200713080413.GL32005@breakpoint.cc>
 <b61d3e1f-02b3-ac80-4b9a-851871f7cdaa@gmail.com>
 <20200713140219.GM32005@breakpoint.cc>
 <20200714143327.2d5b8581@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714143327.2d5b8581@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> I would still like the idea I proposed better (updating MTUs down the
> chain), it's simpler and we don't have to duplicate existing
> functionality (generating additional ICMP messages).

It doesn't make this work though.

With your skeleton patch, br0 updates MTU, but the sender still
won't know that unless input traffic to br0 is routed (or locally
generated).

Furthermore, such MTU reduction would require a mechanism to
auto-reconfig every device in the same linklevel broadcast domain,
and I am not aware of any such mechanism.
