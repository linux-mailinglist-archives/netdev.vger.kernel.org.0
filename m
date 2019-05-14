Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 730661C1C1
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 07:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfENFQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 01:16:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:11715 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfENFQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 01:16:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 22:16:35 -0700
X-ExtLoop1: 1
Received: from llanecki-mobl1.ger.corp.intel.com ([10.252.11.109])
  by fmsmga001.fm.intel.com with ESMTP; 13 May 2019 22:16:32 -0700
Message-ID: <c4a1fd36abf6acafa35bb70f87791d4ef802d87c.camel@intel.com>
Subject: Re: [PATCH][next] iwlwifi: d3: Use struct_size() helper
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 May 2019 08:16:32 +0300
In-Reply-To: <20190403160342.GA24396@embeddedor>
References: <20190403160342.GA24396@embeddedor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-04-03 at 11:03 -0500, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, change the following form:
> 
> sizeof(*pattern_cmd) +
>                wowlan->n_patterns * sizeof(struct
> iwlagn_wowlan_pattern)
> 
>  to :
> 
> struct_size(pattern_cmd, patterns, wowlan->n_patterns)
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> index 83fd7f93d9f5..99589b910bce 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
> @@ -398,8 +398,7 @@ static int iwl_mvm_send_patterns(struct iwl_mvm
> *mvm,
>  	if (!wowlan->n_patterns)
>  		return 0;
>  
> -	cmd.len[0] = sizeof(*pattern_cmd) +
> -		wowlan->n_patterns * sizeof(struct iwl_wowlan_pattern);
> +	cmd.len[0] = struct_size(pattern_cmd, patterns, wowlan-
> >n_patterns);
>  
>  	pattern_cmd = kmalloc(cmd.len[0], GFP_KERNEL);
>  	if (!pattern_cmd)


Thanks! Applied to our internal tree and it will reach the mainline
following our normal upstreaming process.

--
Cheers,
Luca.

