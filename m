Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44A5234D9F
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgGaWis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:38:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:36404 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgGaWis (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:38:48 -0400
IronPort-SDR: AsmHAu7jtyGvEHop+Hb1O3l0mS3MLUI2W+5cNsw10wAZGi+xvH6UDJYYltjIUIFJRFnu3UqvMV
 xNOraHzSGppg==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="131942833"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="131942833"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:38:48 -0700
IronPort-SDR: MswcHRBUmgDEKGZNYbxgxEZQrwz+nc8EZo9qgBqEEI/7tMoQ+Rrhl7ffYmlPlNkIunQz4dn060
 CLeQeqQsgkXQ==
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="287331010"
Received: from nataliet-mobl.amr.corp.intel.com ([10.254.79.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 15:38:47 -0700
Date:   Fri, 31 Jul 2020 15:38:47 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@nataliet-mobl.amr.corp.intel.com
To:     Florian Westphal <fw@strlen.de>
cc:     netdev@vger.kernel.org, edumazet@google.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 5/9] mptcp: subflow: add mptcp_subflow_init_cookie_req
 helper
In-Reply-To: <20200730192558.25697-6-fw@strlen.de>
Message-ID: <alpine.OSX.2.23.453.2007311538230.30834@nataliet-mobl.amr.corp.intel.com>
References: <20200730192558.25697-1-fw@strlen.de> <20200730192558.25697-6-fw@strlen.de>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020, Florian Westphal wrote:

> Will be used to initialize the mptcp request socket when a MP_CAPABLE
> request was handled in syncookie mode, i.e. when a TCP ACK containing a
> MP_CAPABLE option is a valid syncookie value.
>
> Normally (non-cookie case), MPTCP will generate a unique 32 bit connection
> ID and stores it in the MPTCP token storage to be able to retrieve the
> mptcp socket for subflow joining.
>
> In syncookie case, we do not want to store any state, so just generate the
> unique ID and use it in the reply.
>
> This means there is a small window where another connection could generate
> the same token.
>
> When Cookie ACK comes back, we check that the token has not been registered
> in the mean time.  If it was, the connection needs to fall back to TCP.
>
> Changes in v2:
> - use req->syncookie instead of passing 'want_cookie' arg to ->init_req()
>   (Eric Dumazet)
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> include/net/mptcp.h  | 10 +++++++++
> net/mptcp/protocol.h |  1 +
> net/mptcp/subflow.c  | 50 +++++++++++++++++++++++++++++++++++++++++++-
> net/mptcp/token.c    | 26 +++++++++++++++++++++++
> 4 files changed, 86 insertions(+), 1 deletion(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
