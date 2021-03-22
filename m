Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF3343A1C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 07:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCVG4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 02:56:41 -0400
Received: from mga05.intel.com ([192.55.52.43]:33119 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhCVG4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 02:56:23 -0400
IronPort-SDR: HrrwhAgzS/yO/NIv9jICmYMFQDzxSwkWzskdaZT2ftjI81+XN5wJHNOWoA3iNZnCzghtIHt51J
 9LueNBT4R1eQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9930"; a="275306542"
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="275306542"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2021 23:56:22 -0700
IronPort-SDR: 4pTR/vLmWbPcOGD9wyr9wBolTXNOw5HfQVDR/DAM3+W39Hze015vfEMMpovCc/XUsa0u65IBQs
 YVanmPAhjYWw==
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="414362073"
Received: from sneftin-mobl.ger.corp.intel.com (HELO [10.185.168.91]) ([10.185.168.91])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2021 23:56:19 -0700
Subject: Re: [Intel-wired-lan] [PATCH net-next] e1000e: Mark
 e1000e_pm_prepare() as __maybe_unused
To:     'w00385741 <weiyongjun1@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, Chen Yu <yu.c.chen@intel.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, Hulk Robot <hulkci@huawei.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20210317145234.3171021-1-weiyongjun1@huawei.com>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
Message-ID: <80dcead2-f0e1-c1a4-037c-6215f960f32f@intel.com>
Date:   Mon, 22 Mar 2021 08:56:17 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317145234.3171021-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/2021 16:52, 'w00385741 wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> The function e1000e_pm_prepare() may have no callers depending
> on configuration, so it must be marked __maybe_unused to avoid
> harmless warning:
> 
> drivers/net/ethernet/intel/e1000e/netdev.c:6926:12:
>   warning: 'e1000e_pm_prepare' defined but not used [-Wunused-function]
>   6926 | static int e1000e_pm_prepare(struct device *dev)
>        |            ^~~~~~~~~~~~~~~~~
> 
> Fixes: ccf8b940e5fd ("e1000e: Leverage direct_complete to speed up s2ram")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index f1c9debd9f3b..d2e4653536c5 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6923,7 +6923,7 @@ static int __e1000_resume(struct pci_dev *pdev)
>   	return 0;
>   }
>   
> -static int e1000e_pm_prepare(struct device *dev)
> +static __maybe_unused int e1000e_pm_prepare(struct device *dev)
>   {
>   	return pm_runtime_suspended(dev) &&
>   		pm_suspend_via_firmware();
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> 
