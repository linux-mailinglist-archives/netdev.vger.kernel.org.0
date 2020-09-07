Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF6F2605AB
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 22:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbgIGU1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 16:27:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgIGU1U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 16:27:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27C7821556;
        Mon,  7 Sep 2020 20:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599510439;
        bh=nKy/rzLAWRf54aoPo+PrRowJ1euqWN4cWkwUgQ9wVQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MHqV1K+eSoZXTqutpE73tF/indnyd5zB18ZGfKs7+tzfjr14/eotE5g3WCzEHJcF0
         pcfwfRvNa7Kh5rBXqzIkFfD/T/Jg7oBaN25jbSle7WZ8sTbvNrGX797etkoN6WT3nZ
         wE/l6rELydzqdaicPGbkn+327KHu7QgufkcKb4Mg=
Date:   Mon, 7 Sep 2020 13:27:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH net-next v4 00/15] net: bridge: mcast: initial
 IGMPv3/MLDv2 support (part 1)
Message-ID: <20200907132717.5fdb04d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 12:56:04 +0300 Nikolay Aleksandrov wrote:
> Hi all,
> This patch-set implements the control plane for initial IGMPv3/MLDv2
> support which takes care of include/exclude sets and state transitions
> based on the different report types.
> Patch 01 arranges the structure better by moving the frequently used
> fields together, patch 02 factors out the port group deletion code which is
> used in a few places. Patches 03 and 04 add support for source lists and
> group modes per port group which are dumped. Patch 05 adds support for
> group-and-source specific queries required for IGMPv3/MLDv2. Then patch 06
> adds support for group and group-and-source query retransmissions via a new
> rexmit timer. Patches 07 and 08 make use of the already present mdb fill
> functions when sending notifications so we can have the full mdb entries'
> state filled in (with sources, mode etc). Patch 09 takes care of port group
> expiration, it switches the group mode to include and deletes it if there
> are no sources with active timers. Patches 10-13 are the core changes which
> add support for IGMPv3/MLDv2 reports and handle the source list set
> operations as per RFCs 3376 and 3810, all IGMPv3/MLDv2 report types with
> their transitions should be supported after these patches. I've used RFCs
> 3376, 3810 and FRR as a reference implementation. The source lists are
> capped at 32 entries, we can remove that limitation at a later point which
> would require a better data structure to hold them. IGMPv3 processing is
> hidden behind the bridge's multicast_igmp_version option which must be set
> to 3 in order to enable it. MLDv2 processing is hidden behind the bridge's
> multicast_mld_version which must be set to 2 in order to enable it.
> Patch 14 improves other querier processing a bit (more about this below).
> And finally patch 15 transforms the src gc so it can be used with all mcast
> objects since now we have multiple timers that can be running and we
> need to make sure they have all finished before freeing the objects.
> This is part 1, it only adds control plane support and doesn't change
> the fast path. A following patch-set will take care of that.

Applied thank you.
