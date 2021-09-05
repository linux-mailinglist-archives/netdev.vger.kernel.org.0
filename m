Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C7401153
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 21:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238257AbhIETIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 15:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbhIETIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 15:08:38 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E9CC061575;
        Sun,  5 Sep 2021 12:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=/odDc7mk41rre/LvWYwSnSF6ajw14qMrg/v5VI8KJLE=; b=SEeBFrINPxA2rmhesA5ng1d0He
        4wzmEW8qufcl+UrEylhY9OJ0GBbrze1ACP63cghcm7duZbCPtUU0eY6Mu6vHzn6i+0Ng/d8C7E+e3
        ksQYEU/fio0jJIc8NJRXy7P9WiyLY0+UI36+k/Ff4cOoteFlI11isaA2UZuefcDFY/P0yLMTihyDb
        KAIG9hNAcQbeAFpoE7IlbdatF3bxorP4iCOzVFYKNvFpXbjeLKe13vvd97AD3vIp5eEFbBPyTK8jP
        9jyNIZcVGVs1s3o0vo8yV2ujq/AlQvK9DgRl05Y1RBP/SKkR4/QH2K4SebRXDT7Xb9/dAbExCRFyQ
        IZK+ghSg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMxUL-00GINm-83; Sun, 05 Sep 2021 19:07:33 +0000
Subject: Re: [PATCH -net] wireless: iwlwifi: fix printk format warnings in
 uefi.c
To:     netdev@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210821020901.25901-1-rdunlap@infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e5ccd622-e876-d4e8-5f2b-e1d183799026@infradead.org>
Date:   Sun, 5 Sep 2021 12:07:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210821020901.25901-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/21 7:09 PM, Randy Dunlap wrote:
> The kernel test robot reports printk format warnings in uefi.c, so
> correct them.
> 
> ../drivers/net/wireless/intel/iwlwifi/fw/uefi.c: In function 'iwl_uefi_get_pnvm':
> ../drivers/net/wireless/intel/iwlwifi/fw/uefi.c:52:30: warning: format '%zd' expects argument of type 'signed size_t', but argument 7 has type 'long unsigned int' [-Wformat=]
>     52 |                              "PNVM UEFI variable not found %d (len %zd)\n",
>        |                              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     53 |                              err, package_size);
>        |                                   ~~~~~~~~~~~~
>        |                                   |
>        |                                   long unsigned int
> ../drivers/net/wireless/intel/iwlwifi/fw/uefi.c:59:29: warning: format '%zd' expects argument of type 'signed size_t', but argument 6 has type 'long unsigned int' [-Wformat=]
>     59 |         IWL_DEBUG_FW(trans, "Read PNVM from UEFI with size %zd\n", package_size);
>        |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~
>        |                                                                    |
>        |                                                                    long unsigned int
> 
> Fixes: 84c3c9952afb ("iwlwifi: move UEFI code to a separate file")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>   drivers/net/wireless/intel/iwlwifi/fw/uefi.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20210820.orig/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
> +++ linux-next-20210820/drivers/net/wireless/intel/iwlwifi/fw/uefi.c
> @@ -49,14 +49,14 @@ void *iwl_uefi_get_pnvm(struct iwl_trans
>   	err = efivar_entry_get(pnvm_efivar, NULL, &package_size, data);
>   	if (err) {
>   		IWL_DEBUG_FW(trans,
> -			     "PNVM UEFI variable not found %d (len %zd)\n",
> +			     "PNVM UEFI variable not found %d (len %lu)\n",
>   			     err, package_size);
>   		kfree(data);
>   		data = ERR_PTR(err);
>   		goto out;
>   	}
>   
> -	IWL_DEBUG_FW(trans, "Read PNVM from UEFI with size %zd\n", package_size);
> +	IWL_DEBUG_FW(trans, "Read PNVM from UEFI with size %lu\n", package_size);
>   	*len = package_size;
>   
>   out:
> 

Hm, no one has commented on this and the robot is still reporting it as
build warnings.
Do I need to resend it?

thanx.
