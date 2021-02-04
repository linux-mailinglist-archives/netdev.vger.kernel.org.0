Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EF730FC6E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 20:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239391AbhBDTSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 14:18:14 -0500
Received: from mga03.intel.com ([134.134.136.65]:60733 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239741AbhBDTR4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 14:17:56 -0500
IronPort-SDR: Nq5cIV1IS1h0RKXRFYh/5yoSwDXzphIrBvbFtoFJS2guw0fHuTuWOL6FiJ3CEpJy45BAbNfBMd
 SrJvTR1t8mVg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181378958"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="181378958"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:17:14 -0800
IronPort-SDR: +Dhe4crGnrdhv7EDuKjorK7XTvF6epnPsutQfLmU4tiTiuUxJOVHxqgqjJTpoeH7McB2x8YApT
 W26CcC5hJUmg==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="393331149"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.212.188.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 11:17:14 -0800
Date:   Thu, 4 Feb 2021 11:17:13 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org
Subject: Re: [PATCH net-next v5 1/2] net: mhi-net: Add re-aggregation of
 fragmented packets
Message-ID: <20210204111713.00005fb6@intel.com>
In-Reply-To: <1612428002-12333-1-git-send-email-loic.poulain@linaro.org>
References: <1612428002-12333-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Loic Poulain wrote:

> When device side MTU is larger than host side MTU, the packets
> (typically rmnet packets) are split over multiple MHI transfers.
> In that case, fragments must be re-aggregated to recover the packet
> before forwarding to upper layer.
> 
> A fragmented packet result in -EOVERFLOW MHI transaction status for
> each of its fragments, except the final one. Such transfer was
> previously considered as error and fragments were simply dropped.
> 
> This change adds re-aggregation mechanism using skb chaining, via
> skb frag_list.
> 
> A warning (once) is printed since this behavior usually comes from
> a misconfiguration of the device (e.g. modem MTU).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: use zero-copy skb chaining instead of skb_copy_expand.
>  v3: Fix nit in commit msg + remove misleading inline comment for frag_list
>  v4: no change
>  v5: reword/fix commit subject
> 

Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
