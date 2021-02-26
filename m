Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 776F9326925
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhBZVHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:07:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhBZVH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 16:07:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78D4564EAF;
        Fri, 26 Feb 2021 21:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614373606;
        bh=dll3zwV+2fsgaVPWZQp38anBe34JTVJ6LJ1kb1y9oCQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tTZwo7DopJ7h8hLaCuzLgarVUktQ7SYTz/lDZ52SXvmk8WL7p2SADNV0kNjadaHrS
         GDh0y7wYCBLp0FPGJp7J7w02oOky7poG5dAzFzEHMlfV0ZTc6Rl1D0wi4pY0zirqKq
         w2mCtrbziUpSk43BoXPrG8iVlHVntTeGuBw+rw1OtLMyCDfcHL7Y5c0L560VijWSfQ
         ozIgUgQKFDLrMVbI6YLm57hDEHrNriXhnRwbYF1W5649UxyDUCZR5zm8plokoPcT5L
         BVoqPFP2IuAY+twK7jn7YnDVKQNKbwGjJfmnAKm43DZDvbrfpD0WXMSW//RtnUAp89
         5N1jAsGzUNaCA==
Date:   Fri, 26 Feb 2021 14:06:40 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Hulk Robot <hulkci@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Gil Adam <gil.adam@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mvm: add terminate entry for dmi_system_id
 tables
Message-ID: <20210226210640.GA21320@MSI.localdomain>
References: <20210223140039.1708534-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223140039.1708534-1-weiyongjun1@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 02:00:39PM +0000, Wei Yongjun wrote:
> Make sure dmi_system_id tables are NULL terminated.
> 
> Fixes: a2ac0f48a07c ("iwlwifi: mvm: implement approved list for the PPAG feature")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>

We received a report about a crash in iwlwifi when compiled with LTO and
this fix resolves it.

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> index 15e2773ce7e7..5ee64f7f3c85 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> @@ -1083,6 +1083,7 @@ static const struct dmi_system_id dmi_ppag_approved_list[] = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek COMPUTER INC."),
>  		},
>  	},
> +	{}
>  };
>  
>  static int iwl_mvm_ppag_init(struct iwl_mvm *mvm)
> 
