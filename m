Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306F430E718
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhBCXQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:16:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:58173 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233222AbhBCXQV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:16:21 -0500
IronPort-SDR: AaI2vwOO2aDfxmTM0SeJWLA6N3J6jXIGWQ+BNzBQYizx1Mni4prFxENNKQNUSswBgk2nwWqs2l
 3ha7mmzwHpnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="181208539"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="181208539"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:16:00 -0800
IronPort-SDR: tDOjc9uBKKJsJJodzoXRQdrh0bexHOEn2qck8A79WDJPL8EC8zcDzDqrvws4AyZ6WGXxLmWgt3
 cx18cC0KRLyA==
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="356184224"
Received: from jbrandeb-mobl4.amr.corp.intel.com (HELO localhost) ([10.209.23.15])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 15:16:00 -0800
Date:   Wed, 3 Feb 2021 15:15:59 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, netdev@vger.kernel.org,
        stranche@codeaurora.org, subashab@codeaurora.org
Subject: Re: [PATCH net-next v4 1/2] net: mhi-net: Add de-aggeration support
Message-ID: <20210203151559.00007e94@intel.com>
In-Reply-To: <1612365335-14117-1-git-send-email-loic.poulain@linaro.org>
References: <1612365335-14117-1-git-send-email-loic.poulain@linaro.org>
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

apologies for the nit, can you please fix the spelling of aggregation in
the subject?
