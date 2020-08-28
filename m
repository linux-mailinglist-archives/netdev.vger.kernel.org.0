Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5615C255E46
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgH1P4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgH1P4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 11:56:21 -0400
Received: from caffeine.csclub.uwaterloo.ca (caffeine.csclub.uwaterloo.ca [IPv6:2620:101:f000:4901:c5c:0:caff:e12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82531C06121B;
        Fri, 28 Aug 2020 08:56:21 -0700 (PDT)
Received: by caffeine.csclub.uwaterloo.ca (Postfix, from userid 20367)
        id 4D92B46052C; Fri, 28 Aug 2020 11:56:16 -0400 (EDT)
Date:   Fri, 28 Aug 2020 11:56:16 -0400
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: VRRP not working on i40e X722 S2600WFT
Message-ID: <20200828155616.3sd2ivrml2gpcvod@csclub.uwaterloo.ca>
References: <20200827183039.hrfnb63cxq3pmv4z@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827183039.hrfnb63cxq3pmv4z@csclub.uwaterloo.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
From:   lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 27, 2020 at 02:30:39PM -0400, Lennart Sorensen wrote:
> I have hit a new problem with the X722 chipset (Intel R1304WFT server).
> VRRP simply does not work.
> 
> When keepalived registers a vmac interface, and starts transmitting
> multicast packets with the vrp message, it never receives those packets
> from the peers, so all nodes think they are the master.  tcpdump shows
> transmits, but no receives.  If I stop keepalived, which deletes the
> vmac interface, then I start to receive the multicast packets from the
> other nodes.  Even in promisc mode, tcpdump can't see those packets.
> 
> So it seems the hardware is dropping all packets with a source mac that
> matches the source mac of the vmac interface, even when the destination
> is a multicast address that was subcribed to.  This is clearly not
> proper behaviour.
> 
> I tried a stock 5.8 kernel to check if a driver update helped, and updated
> the nvm firware to the latest 4.10 (which appears to be over a year old),
> and nothing changes the behaviour at all.
> 
> Seems other people have hit this problem too:
> http://mails.dpdk.org/archives/users/2018-May/003128.html
> 
> Unless someone has a way to fix this, we will have to change away from
> this hardware very quickly.  The IPsec NAT RSS defect we could tolerate
> although didn't like, while this is just unworkable.
> 
> Quite frustrated by this.  Intel network hardware was always great,
> how did the X722 make it out in this state.

Another case with the same problem on an X710:

https://www.talkend.net/post/13256.html

-- 
Len Sorensen
