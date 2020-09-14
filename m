Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57923269476
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgINSJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:09:45 -0400
Received: from mga06.intel.com ([134.134.136.31]:32241 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgINSJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:09:29 -0400
IronPort-SDR: fD7cWSrQJ4s3JCg1DqyftiiRck4DJazUtcyNIoJTqcBtLdqAU2oBmbQZPLWVJyxJasXzgzgG6r
 5J38tgTfCFKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220688223"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220688223"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:09:22 -0700
IronPort-SDR: HF10d63qsOu4tgaDwHmbOfEHlijGq8dVj2dpm7v4YjaSG3sySyqoodyDgaRZgLu20mzHGDnggK
 5UrOAEy/kpTw==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482446412"
Received: from ningale-mobl.amr.corp.intel.com ([10.255.229.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 11:09:21 -0700
Date:   Mon, 14 Sep 2020 11:09:21 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@ningale-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next v2 11/13] mptcp: allow picking different xmit
 subflows
In-Reply-To: <e676b2a4b3de838d458353e9f860a2fd4e1a9e35.1599854632.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.23.453.2009141109020.57764@ningale-mobl.amr.corp.intel.com>
References: <cover.1599854632.git.pabeni@redhat.com> <e676b2a4b3de838d458353e9f860a2fd4e1a9e35.1599854632.git.pabeni@redhat.com>
User-Agent: Alpine 2.23 (OSX 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020, Paolo Abeni wrote:

> Update the scheduler to less trivial heuristic: cache
> the last used subflow, and try to send on it a reasonably
> long burst of data.
>
> When the burst or the subflow send space is exhausted, pick
> the subflow with the lower ratio between write space and
> send buffer - that is, the subflow with the greater relative
> amount of free space.
>
> v1 -> v2:
> - fix 32 bit build breakage due to 64bits div
> - fix checkpath issues (uint64_t -> u64)
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 111 ++++++++++++++++++++++++++++++++++++-------
> net/mptcp/protocol.h |   6 ++-
> 2 files changed, 99 insertions(+), 18 deletions(-)
>

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
