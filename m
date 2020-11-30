Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C122C92F3
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387915AbgK3XpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:45:25 -0500
Received: from mga06.intel.com ([134.134.136.31]:46019 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388050AbgK3XpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:45:25 -0500
IronPort-SDR: cKzpPP9TYwItYRqcLfbloKVdZp+jSAMd8LrLQqxBgP3lMAvu4O4rmjgSmhC6u8TI8fiTJH/6/I
 348M321aom2A==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="234336112"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="234336112"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:43:44 -0800
IronPort-SDR: 7jBJZYLVq2AujBWlvOd5MrZ8gUR9tTeaDowf0K+a447szE6ll9G/CpMXQBYM3DfUctlJnE1TF2
 qqhXLy+n/1aw==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="480855427"
Received: from cdhirema-mobl5.amr.corp.intel.com ([10.254.71.173])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 15:43:34 -0800
Date:   Mon, 30 Nov 2020 15:43:33 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 2/6] mptcp: implement wmem reservation
In-Reply-To: <e1726dbf86cee84d76098f42774be3abe2c367c7.1606413118.git.pabeni@redhat.com>
Message-ID: <7d93fc11-4993-802e-e318-157226f91cf6@linux.intel.com>
References: <cover.1606413118.git.pabeni@redhat.com> <e1726dbf86cee84d76098f42774be3abe2c367c7.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020, Paolo Abeni wrote:

> This leverages the previous commit to reserve the wmem
> required for the sendmsg() operation when the msk socket
> lock is first acquired.
> Some heuristics are used to get a reasonable [over] estimation of
> the whole memory required. If we can't forward alloc such amount
> fallback to a reasonable small chunk, otherwise enter the wait
> for memory path.
>
> When sendmsg() needs more memory it looks at wmem_reserved
> first and if that is exhausted, move more space from
> sk_forward_alloc.
>
> The reserved memory is not persistent and is released at the
> next socket unlock via the release_cb().
>
> Overall this will simplify the next patch.
>
> Acked-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 92 ++++++++++++++++++++++++++++++++++++++++----
> net/mptcp/protocol.h |  1 +
> 2 files changed, 86 insertions(+), 7 deletions(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
