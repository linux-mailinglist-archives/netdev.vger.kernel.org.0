Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C23C1BB7
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfI3Gqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:46:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:40066 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729022AbfI3Gqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 02:46:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Sep 2019 23:46:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,565,1559545200"; 
   d="scan'208";a="220553529"
Received: from oamoreno-mobl.ccr.corp.intel.com ([10.252.17.131])
  by fmsmga002.fm.intel.com with ESMTP; 29 Sep 2019 23:46:31 -0700
Message-ID: <dbf90ac06b27395dc2d19fbc37e47877785b8d52.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: dvm: excessive if in rs_bt_update_lq()
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Denis Efremov <efremov@linux.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 30 Sep 2019 09:46:31 +0300
In-Reply-To: <20190925204935.27118-1-efremov@linux.com>
References: <20190925204935.27118-1-efremov@linux.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-25 at 23:49 +0300, Denis Efremov wrote:
> There is no need to check 'priv->bt_ant_couple_ok' twice in
> rs_bt_update_lq(). The second check is always true. Thus, the
> expression can be simplified.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
> index 74229fcb63a9..226165db7dfd 100644
> --- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
> +++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
> @@ -851,7 +851,7 @@ static void rs_bt_update_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
>  		 * Is there a need to switch between
>  		 * full concurrency and 3-wire?
>  		 */
> -		if (priv->bt_ci_compliance && priv->bt_ant_couple_ok)
> +		if (priv->bt_ci_compliance)
>  			full_concurrent = true;
>  		else
>  			full_concurrent = false;

Thanks, Denis! I have applied this to our internal tree and it will
reach the mainline following our usual upstreaming process.

--
Cheers,
Luca.

