Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10781C1BC
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 07:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfENFQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 01:16:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:61702 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfENFQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 01:16:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 22:16:15 -0700
X-ExtLoop1: 1
Received: from llanecki-mobl1.ger.corp.intel.com ([10.252.11.109])
  by fmsmga006.fm.intel.com with ESMTP; 13 May 2019 22:16:12 -0700
Message-ID: <731a28ba06246e57e9cc8a681dda720ff76f1925.camel@intel.com>
Subject: Re: [PATCH][next] iwlwifi: lib: Use struct_size() helper
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 14 May 2019 08:16:11 +0300
In-Reply-To: <20190403155901.GA22686@embeddedor>
References: <20190403155901.GA22686@embeddedor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-04-03 at 10:59 -0500, Gustavo A. R. Silva wrote:
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
>  drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
> b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
> index b2f172d4f78a..cae9cd438697 100644
> --- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
> +++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
> @@ -1022,8 +1022,7 @@ int iwlagn_send_patterns(struct iwl_priv *priv,
>  	if (!wowlan->n_patterns)
>  		return 0;
>  
> -	cmd.len[0] = sizeof(*pattern_cmd) +
> -		wowlan->n_patterns * sizeof(struct
> iwlagn_wowlan_pattern);
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


