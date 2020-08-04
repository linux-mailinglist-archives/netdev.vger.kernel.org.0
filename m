Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CB523C05F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 22:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgHDUCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 16:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgHDUCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 16:02:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527E4C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 13:02:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BCAE612880DE9;
        Tue,  4 Aug 2020 12:45:34 -0700 (PDT)
Date:   Tue, 04 Aug 2020 13:02:19 -0700 (PDT)
Message-Id: <20200804.130219.1503615086211769091.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     fw@strlen.de, dsahern@gmail.com, aconole@redhat.com,
        nusiddiq@redhat.com, kuba@kernel.org, pshelar@ovn.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        lu@pplo.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] Support PMTU discovery with bridged
 UDP tunnels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1596520062.git.sbrivio@redhat.com>
References: <cover.1596520062.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 12:45:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Tue,  4 Aug 2020 07:53:41 +0200

> Currently, PMTU discovery for UDP tunnels only works if packets are
> routed to the encapsulating interfaces, not bridged.
> 
> This results from the fact that we generally don't have valid routes
> to the senders we can use to relay ICMP and ICMPv6 errors, and makes
> PMTU discovery completely non-functional for VXLAN and GENEVE ports of
> both regular bridges and Open vSwitch instances.
> 
> If the sender is local, and packets are forwarded to the port by a
> regular bridge, all it takes is to generate a corresponding route
> exception on the encapsulating device. The bridge then finds the route
> exception carrying the PMTU value estimate as it forwards frames, and
> relays ICMP messages back to the socket of the local sender. Patch 1/6
> fixes this case.
> 
> If the sender resides on another node, we actually need to reply to
> IP and IPv6 packets ourselves and send these ICMP or ICMPv6 errors
> back, using the same encapsulating device. Patch 2/6, based on an
> original idea by Florian Westphal, adds the needed functionality,
> while patches 3/6 and 4/6 add matching support for VXLAN and GENEVE.
> 
> Finally, 5/6 and 6/6 introduce selftests for all combinations of
> inner and outer IP versions, covering both VXLAN and GENEVE, with
> both regular bridges and Open vSwitch instances.
> 
> v2: Add helper to check for any bridge port, skip oif check for PMTU
>     routes for bridge ports only, split IPv4 and IPv6 helpers and
>     functions (all suggested by David Ahern)

Series applied with the extraneous newline in the selftest changes of
patch #5 removed.

Thank you.
