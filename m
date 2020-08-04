Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C1023B242
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgHDBZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:25:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95911C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:25:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B1AC1278B070;
        Mon,  3 Aug 2020 18:08:41 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:25:26 -0700 (PDT)
Message-Id: <20200803.182526.342368013137626191.davem@davemloft.net>
To:     sbrivio@redhat.com
Cc:     fw@strlen.de, dsahern@gmail.com, aconole@redhat.com,
        nusiddiq@redhat.com, kuba@kernel.org, pshelar@ovn.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        lu@pplo.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Support PMTU discovery with bridged UDP
 tunnels
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1596487323.git.sbrivio@redhat.com>
References: <cover.1596487323.git.sbrivio@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:08:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>
Date: Mon,  3 Aug 2020 22:52:08 +0200

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

Please address the feedback you've received and I will apply this
series, thank you.
