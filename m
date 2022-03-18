Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6769D4DD3D4
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 05:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbiCREEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 00:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiCREEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 00:04:48 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BFC63DE;
        Thu, 17 Mar 2022 21:03:28 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KKVgS4JNQzCqkR;
        Fri, 18 Mar 2022 12:01:24 +0800 (CST)
Received: from [10.174.179.215] (10.174.179.215) by
 canpemm500007.china.huawei.com (7.192.104.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 12:03:26 +0800
Subject: Re: [PATCH -next] wlwifi: mei: Fix build error without CFG80211
To:     <luciano.coelho@intel.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ayala.beker@intel.com>, <emmanuel.grumbach@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220318030149.1328-1-yuehaibing@huawei.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <ee4cc974-1cfc-f9ba-5e23-f429eb5d311d@huawei.com>
Date:   Fri, 18 Mar 2022 12:03:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20220318030149.1328-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/3/18 11:01, YueHaibing wrote:
> If CFG80211 is n and IWLMEI is y,  building fails:
> 
> drivers/net/wireless/intel/iwlwifi/mei/net.o: In function `iwl_mei_tx_copy_to_csme':
> net.c:(.text+0xd0): undefined reference to `ieee80211_hdrlen'
> 
> Make IWLMEI depends on CFG80211 to fix this.
> 

It seems has been fixed, Pls igbore this.

> Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
> index 85e704283755..8c003cd29ab7 100644
> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> @@ -137,7 +137,7 @@ endif
>  
>  config IWLMEI
>  	tristate "Intel Management Engine communication over WLAN"
> -	depends on INTEL_MEI
> +	depends on INTEL_MEI && CFG80211
>  	depends on PM
>  	help
>  	  Enables the iwlmei kernel module.
> 
