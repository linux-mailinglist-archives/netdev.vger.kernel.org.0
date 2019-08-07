Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8698583E4E
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfHGA2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:28:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51462 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726238AbfHGA2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:28:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hv9oe-00066H-Di; Wed, 07 Aug 2019 02:28:32 +0200
Date:   Wed, 7 Aug 2019 02:28:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Peter Oskolkov <posk@google.com>,
        Alexander Aring <alex.aring@gmail.com>
Subject: Re: [PATCH net] inet: frags: re-introduce skb coalescing for local
 delivery
Message-ID: <20190807002832.q4xvst4i4jj6fwst@breakpoint.cc>
References: <22d8da10c97214edd0677e6478093ad9376180ef.1564758715.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d8da10c97214edd0677e6478093ad9376180ef.1564758715.git.gnault@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume Nault <gnault@redhat.com> wrote:
> Before commit d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6
> defrag"), a netperf UDP_STREAM test[0] using big IPv6 datagrams (thus
> generating many fragments) and running over an IPsec tunnel, reported
> more than 6Gbps throughput. After that patch, the same test gets only
> 9Mbps when receiving on a be2net nic (driver can make a big difference
> here, for example, ixgbe doesn't seem to be affected).
> 
> By reusing the IPv4 defragmentation code, IPv6 lost fragment coalescing
> (IPv4 fragment coalescing was dropped by commit 14fe22e33462 ("Revert
> "ipv4: use skb coalescing in defragmentation"")).

[..]

> This patch is quite conservative and only coalesces skbs for local
> IPv4 and IPv6 delivery (in order to avoid changing skb geometry when
> forwarding). Coalescing could be extended in the future if need be, as
> more scenarios would probably benefit from it.

No objections from my side, so:

Acked-by: Florian Westphal <fw@strlen.de>
