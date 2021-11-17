Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98F8454105
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 07:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhKQGoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 01:44:22 -0500
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:41894 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233355AbhKQGoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 01:44:22 -0500
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id 785FB80874;
        Wed, 17 Nov 2021 06:41:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 5C54CE000364;
        Wed, 17 Nov 2021 06:41:21 +0000 (UTC)
Message-ID: <977fbfb8aaae8a54d8769f49d397d68f6387a0e8.camel@perches.com>
Subject: Re: [PATCH] iwlwifi: rs: fixup the return value type of
 iwl_legacy_rate_to_fw_idx()
From:   Joe Perches <joe@perches.com>
To:     cgel.zte@gmail.com, luciano.coelho@intel.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        miriam.rachel.korenblit@intel.com, ye.guojin@zte.com.cn,
        johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Date:   Tue, 16 Nov 2021 22:41:20 -0800
In-Reply-To: <20211117063621.160695-1-ye.guojin@zte.com.cn>
References: <20211117063621.160695-1-ye.guojin@zte.com.cn>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5C54CE000364
X-Spam-Status: No, score=1.42
X-Stat-Signature: kf1tej5c85qm7kf5ch6o3gwmpifgnp1n
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/nrJ61Pj2j64ayg4atnOtye6WRLeJOREQ=
X-HE-Tag: 1637131281-988392
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-17 at 06:36 +0000, cgel.zte@gmail.com wrote:
> From: Ye Guojin <ye.guojin@zte.com.cn>
> 
> This was found by coccicheck:
> ./drivers/net/wireless/intel/iwlwifi/fw/rs.c, 147, 10-21, WARNING
> Unsigned expression compared with zero legacy_rate < 0
[]
> diff --git a/drivers/net/wireless/intel/iwlwifi/fw/rs.c b/drivers/net/wireless/intel/iwlwifi/fw/rs.c
[]
> @@ -142,7 +142,7 @@ u32 iwl_new_rate_from_v1(u32 rate_v1)
>  		}
>  	/* if legacy format */
>  	} else {
> -		u32 legacy_rate = iwl_legacy_rate_to_fw_idx(rate_v1);
> +		int legacy_rate = iwl_legacy_rate_to_fw_idx(rate_v1);
>  
>  		WARN_ON(legacy_rate < 0);

Why not just remove the WARN_ON instead?


