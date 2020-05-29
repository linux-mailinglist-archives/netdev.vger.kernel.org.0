Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4B71E850D
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgE2RgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:36:16 -0400
Received: from mga06.intel.com ([134.134.136.31]:52276 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgE2RgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 13:36:14 -0400
IronPort-SDR: l4G8mnWin5TWDyKxeUfQAZKIzxFaOtAJZ2GNw2r/1rKTmRTNpEqwTc28EbTGbEuKZ6EB3/b4mU
 tglolVE5N3Rg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:36:13 -0700
IronPort-SDR: SiStjoQT9Hp6OINDvF2bem0z3mgtkgtNSJUWLPxsN4tj6o0hDs+vuTKQ7ENsFLa6He0gBX/F8l
 TOqqYJBD8xVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="303192639"
Received: from aparnash-mobl.amr.corp.intel.com ([10.254.67.112])
  by orsmga008.jf.intel.com with ESMTP; 29 May 2020 10:36:13 -0700
Date:   Fri, 29 May 2020 10:36:13 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@aparnash-mobl.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 3/3] mptcp: remove msk from the token container at
 destruction time.
In-Reply-To: <73105e38dc7e9153dc3b58a3c4ccc59de3a10947.1590766645.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2005291035490.3506@aparnash-mobl.amr.corp.intel.com>
References: <cover.1590766645.git.pabeni@redhat.com> <73105e38dc7e9153dc3b58a3c4ccc59de3a10947.1590766645.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020, Paolo Abeni wrote:

> Currently we remote the msk from the token container only
> via mptcp_close(). The MPTCP master socket can be destroyed
> also via other paths (e.g. if not yet accepted, when shutting
> down the listener socket). When we hit the latter scenario,
> dangling msk references are left into the token container,
> leading to memory corruption and/or UaF.
>
> This change addresses the issue by moving the token removal
> into the msk destructor.
>
> Fixes: 79c0949e9a09 ("mptcp: Add key generation and token tree")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> net/mptcp/protocol.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

--
Mat Martineau
Intel
