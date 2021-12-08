Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B934E46CEBC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 09:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244707AbhLHITP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 03:19:15 -0500
Received: from mga12.intel.com ([192.55.52.136]:44570 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244669AbhLHITO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 03:19:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10191"; a="217806354"
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="217806354"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 00:15:42 -0800
X-IronPort-AV: E=Sophos;i="5.87,296,1631602800"; 
   d="scan'208";a="515667160"
Received: from krausnex-mobl.ger.corp.intel.com (HELO [10.13.8.81]) ([10.13.8.81])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 00:15:40 -0800
Message-ID: <2eb0a775-2035-f806-b391-d3ce8d3e53a2@linux.intel.com>
Date:   Wed, 8 Dec 2021 10:15:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [Intel-wired-lan] [PATCH net-next 7/9] igc: switch to
 napi_build_skb()
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-8-alexandr.lobakin@intel.com>
From:   "Kraus, NechamaX" <nechamax.kraus@linux.intel.com>
In-Reply-To: <20211123171840.157471-8-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/2021 19:18, Alexander Lobakin wrote:
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order
> to save some cycles on freeing/allocating skbuff_heads on every
> new Rx or completed Tx.
> igc driver runs Tx completion polling cycle right before the Rx
> one and uses napi_consume_skb() to feed the cache with skbuff_heads
> of completed entries, so it's never empty and always warm at that
> moment. Switch to the napi_build_skb() to relax mm pressure on
> heavy Rx.
> 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>

