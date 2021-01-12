Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B112F3D6A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732972AbhALVih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437161AbhALVa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:30:26 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26892C061786;
        Tue, 12 Jan 2021 13:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Z5ech7lMOEi8A0xFzwLs1v8qWUXfPofbI1uhUfji1RA=; b=Ar30arYs5Kb5q9RNYupVGHAn1A
        U0FSqTi3L8HHyjMQezhSd66MpV6NUkVaW/8hOcE4yEo/+6oCBYsL/g+/fZNgT5nh/+ZzfZp6jFnW5
        NgRNtMHzFti3O7uIthSl+6q7dJ68R/ykjjjwGxU2T0Tby5mDrjdJh3QgaPLfIB/wRD+SlueKvVvOq
        pU1xZ6QB2A74vCv1WesyJOmOnirQvJbhzzy+7KUGwrKGqJhasdxGWM6LhUVSTOkdlLAFHfOVsUg3T
        7TVWpQzSbLmlLZLPny0kAzY9spxnk198R2oz2+/4zgNPTwkR1fl2MOS6uSNzn8BTr7gXpkO9C1ELZ
        NlCgJhtw==;
Received: from [2601:1c0:6280:3f0::79df]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kzRET-00024X-G4; Tue, 12 Jan 2021 21:29:41 +0000
Subject: Re: [PATCH net-next] net: ipa: add config dependency on QCOM_SMEM
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210112192134.493-1-elder@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <fc143824-e989-8ad7-2dbd-95b81636f828@infradead.org>
Date:   Tue, 12 Jan 2021 13:29:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112192134.493-1-elder@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 11:21 AM, Alex Elder wrote:
> The IPA driver depends on some SMEM functionality (qcom_smem_init(),
> qcom_smem_alloc(), and qcom_smem_virt_to_phys()), but this is not
> reflected in the configuration dependencies.  Add a dependency on
> QCOM_SMEM to avoid attempts to build the IPA driver without SMEM.
> This avoids a link error for certain configurations.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 38a4066f593c5 ("net: ipa: support COMPILE_TEST")
> Signed-off-by: Alex Elder <elder@linaro.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/net/ipa/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> index 10a0e041ee775..b68f1289b89ef 100644
> --- a/drivers/net/ipa/Kconfig
> +++ b/drivers/net/ipa/Kconfig
> @@ -1,6 +1,6 @@
>  config QCOM_IPA
>  	tristate "Qualcomm IPA support"
> -	depends on 64BIT && NET
> +	depends on 64BIT && NET && QCOM_SMEM
>  	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
>  	select QCOM_MDT_LOADER if ARCH_QCOM
> 


-- 
~Randy

