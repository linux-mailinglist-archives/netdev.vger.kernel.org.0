Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F091F7CCD
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 20:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFLSWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 14:22:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:44495 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgFLSWc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 14:22:32 -0400
IronPort-SDR: Z12PSZSG+mI4KWSv01DKOWd6ZlHXKRv1NH6VtA2ytmn/7ztHo+Vn1B0UxWDuYg72MuaxeQJCs1
 utOQ0yBcbsOg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2020 11:22:32 -0700
IronPort-SDR: VYM7jvspyQwv6EtaDpbciatVWJk76aW7QuH7VlgsL2YMsYDMgO8nYKfj3qJlX2p0NwsR72Ku5k
 mUajBmJh60rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,504,1583222400"; 
   d="scan'208";a="275821509"
Received: from unknown (HELO [10.255.231.235]) ([10.255.231.235])
  by orsmga006.jf.intel.com with ESMTP; 12 Jun 2020 11:22:31 -0700
Date:   Fri, 12 Jun 2020 11:22:31 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@mjmartin-mac01.local
To:     Geliang Tang <geliangtang@gmail.com>
cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptcp: use list_first_entry_or_null
In-Reply-To: <9958d3f15d2d181eb9d48ffe5bf3251ec900f27a.1591941826.git.geliangtang@gmail.com>
Message-ID: <alpine.OSX.2.22.394.2006121114030.74555@mjmartin-mac01.local>
References: <9958d3f15d2d181eb9d48ffe5bf3251ec900f27a.1591941826.git.geliangtang@gmail.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Geliang,

On Fri, 12 Jun 2020, Geliang Tang wrote:

> Use list_first_entry_or_null to simplify the code.
>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>
> ---
> net/mptcp/protocol.h | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> index 86d265500cf6..55c65abcad64 100644
> --- a/net/mptcp/protocol.h
> +++ b/net/mptcp/protocol.h
> @@ -234,10 +234,7 @@ static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock *sk)
> {
> 	struct mptcp_sock *msk = mptcp_sk(sk);
>
> -	if (list_empty(&msk->rtx_queue))
> -		return NULL;
> -
> -	return list_first_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
> +	return list_first_entry_or_null(&msk->rtx_queue, struct mptcp_data_frag, list);
> }
>
> struct mptcp_subflow_request_sock {
> -- 
> 2.17.1

As Matthieu mentioned on your earlier patch, please submit patches to 
netdev with either a [PATCH net] or [PATCH net-next] tag. In this case, 
these are non-critical bug fixes so they should be targeted at net-next.

Note that net-next branch is currently closed to submissions due to the 
v5.8 merge window. Please resubmit both MPTCP patches for net-next when 
David announces that it is open again. The change does look ok but will 
not be merged now.

Thanks for your patch,

--
Mat Martineau
Intel
