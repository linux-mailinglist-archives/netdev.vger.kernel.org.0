Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C028231A9EC
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 05:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhBMEx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 23:53:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:54186 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229648AbhBMEx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:56 -0500
IronPort-SDR: wYAIVSdLGKIwJkyzmW0SJ9F6TRGWirv6IdOYF6Ob5m+uHLuyzofm44tBaelbbnHesLZc5PFF0F
 T7arhBwjmC0Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179005136"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179005136"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 20:52:08 -0800
IronPort-SDR: WRMF3Q0iVpNjn2aJnCP7/lpsd8IJF6SoXC9kjfO7xcT4TKaI6N+vS2yebqaEDU+qaG/A/UJB+r
 /4SMYdrBhzQg==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="400089514"
Received: from coryjbev-mobl.amr.corp.intel.com ([10.255.230.149])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 20:52:07 -0800
Date:   Fri, 12 Feb 2021 20:52:07 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        Florian Westphal <fw@strlen.de>
cc:     kuba@kernel.org, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next 0/8] mptcp: Add genl events for connection
 info
In-Reply-To: <b89e4be5-cac-af1d-1c1-2ce92fa55e10@linux.intel.com>
Message-ID: <76f164fa-113d-8ae0-331c-705696301d6f@linux.intel.com>
References: <20210213000001.379332-1-mathew.j.martineau@linux.intel.com> <b89e4be5-cac-af1d-1c1-2ce92fa55e10@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 12 Feb 2021, Mat Martineau wrote:

> On Fri, 12 Feb 2021, Mat Martineau wrote:
>
>> This series from the MPTCP tree adds genl multicast events that are
>> important for implementing a userspace path manager. In MPTCP, a path
>> manager is responsible for adding or removing additional subflows on
>> each MPTCP connection. The in-kernel path manager (already part of the
>> kernel) is a better fit for many server use cases, but the additional
>> flexibility of userspace path managers is often useful for client
>> devices.
>> 
>> Patches 1, 2, 4, 5, and 6 do some refactoring to streamline the netlink
>> event implementation in the final patch.
>> 
>> Patch 3 improves the timeliness of subflow destruction to ensure the
>> 'subflow closed' event will be sent soon enough.
>> 
>> Patch 7 allows use of the GENL_UNS_ADMIN_PERM flag on genl mcast groups
>> to mandate CAP_NET_ADMIN, which is important to protect token information
>> in the MPTCP events. This is a genetlink change.
>> 
>
> David -
>
> I noticed that this series got merged to net-next and shows as "Accepted" in 
> patchwork:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0a2f6b32cc45e3918321779fe90c28f1ed27d2af
>
>
> However, somehow patch 7 did not propagate through the netdev list and does 
> not show up in patchwork or the merged series!
>
>
> It did get archived on the cc'd mptcp list 
> (https://lists.01.org/hyperkitty/list/mptcp@lists.01.org/message/KBY6UIFETMXCAOHNXQLYWKXNCHSGJ7AG/) 
> so hopefully your directly-addressed copy also arrived. The missing patch 
> won't cause a build error but does lead to a token getting exposed to 
> non-admin users.
>
> I will re-send it with an extra note about where it originally fit in.

Ok, please disregard. When I went to prepare the patch to re-send I found 
that Dave was a step ahead of me, and the code is in fact in the tree. 
Thanks for handling the issue.


--
Mat Martineau
Intel
