Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429C93B3777
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhFXUBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:01:06 -0400
Received: from mga06.intel.com ([134.134.136.31]:27339 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232554AbhFXUBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 16:01:06 -0400
IronPort-SDR: prDRVVIt83sAT4ea1DdrH8IRNjsNYdzKC5AX34QeXmJuwmGrELAAUjqmh1s0pMi5Zn5+1zMHsH
 nGypccPWypmw==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="268682515"
X-IronPort-AV: E=Sophos;i="5.83,297,1616482800"; 
   d="scan'208";a="268682515"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 12:58:39 -0700
IronPort-SDR: 9kxQzp6jeZmOIo5W0vvGj+HLZ5lymwQKayMgXxAO3XSx+C1pp2yhYHcsk0VR3FPe9/HKBPUZg+
 a416MsUFmuHw==
X-IronPort-AV: E=Sophos;i="5.83,297,1616482800"; 
   d="scan'208";a="487896188"
Received: from rsharon-mobl1.ger.corp.intel.com (HELO [10.214.203.125]) ([10.214.203.125])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 12:58:32 -0700
Subject: Re: [Intel-wired-lan] [PATCH] igc: change default return of
 igc_read_phy_reg()
To:     trix@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        jeffrey.t.kirsher@intel.com, sasha.neftin@intel.com
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
References: <20210521195019.2078661-1-trix@redhat.com>
From:   "Fuxbrumer, Dvora" <dvorax.fuxbrumer@linux.intel.com>
Message-ID: <1c0592d7-7d54-7834-61d4-f6b3183b5cf2@linux.intel.com>
Date:   Thu, 24 Jun 2021 22:58:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210521195019.2078661-1-trix@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/2021 22:50, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Static analysis reports this problem
> 
> igc_main.c:4944:20: warning: The left operand of '&'
>    is a garbage value
>      if (!(phy_data & SR_1000T_REMOTE_RX_STATUS) &&
>            ~~~~~~~~ ^
> 
> pyy_data is set by the call to igc_read_phy_reg() only if
> there is a read_reg() op, else it is unset and a 0 is
> returned.  Change the return to -EOPNOTSUPP.
> 
> Fixes: 208983f099d9 ("igc: Add watchdog")
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>   drivers/net/ethernet/intel/igc/igc.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
