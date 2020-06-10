Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61031F58E3
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgFJQSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:18:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:10548 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgFJQSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 12:18:07 -0400
IronPort-SDR: FYtMEJkip4VfC8YdeUSRBIFM0v8xMgbZxkdwyizMew0etLXYkuyrwxjYmFzXT3HNF+/dCj5Boa
 fD1GDVmikrNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2020 09:18:07 -0700
IronPort-SDR: NSo4/NBIGqOn+vaxO10VsYFX88Xyvk3JlQuR0gjkJXXrglVtj3MN/tmT/fKDjU/A7ImkazCtde
 smGLAKnHfg4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,496,1583222400"; 
   d="scan'208";a="306637274"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.249.92.147]) ([10.249.92.147])
  by orsmga008.jf.intel.com with ESMTP; 10 Jun 2020 09:18:03 -0700
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Squash an unused function
 warning
To:     Palmer Dabbelt <palmer@dabbelt.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        kuba@kernel.org, kernel-team@android.com,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        vitaly.lifshits@intel.com, amir.avivi@intel.com
References: <20200610014907.148473-1-palmer@dabbelt.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <8b01c6d6-db4d-d05c-d8cd-733cec31094e@intel.com>
Date:   Wed, 10 Jun 2020 19:18:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200610014907.148473-1-palmer@dabbelt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/2020 04:49, Palmer Dabbelt wrote:
> From: Palmer Dabbelt <palmerdabbelt@google.com>
> 
> e1000e_check_me is only used under CONFIG_PM_SLEEP but exists
> unconditionally, which triggers a warning.
> 
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index a279f4fa9962..f7148d1fcba2 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -134,6 +134,7 @@ static const struct e1000e_me_supported me_supported[] = {
>   	{0}
>   };
>   
> +#ifdef CONFIG_PM_SLEEP
Thanks Palmer for catching this warning,
can we use "__maybe_unused" declaration instead of wrapping? I think it 
is more convenient and consistent.
>   static bool e1000e_check_me(u16 device_id)
>   {
>   	struct e1000e_me_supported *id;
> @@ -145,6 +146,7 @@ static bool e1000e_check_me(u16 device_id)
>   
>   	return false;
>   }
> +#endif
>   
>   /**
>    * __ew32_prepare - prepare to write to MAC CSR register on certain parts
> 

