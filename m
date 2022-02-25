Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5D4C5023
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 21:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237665AbiBYUxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 15:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbiBYUxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 15:53:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D204A915;
        Fri, 25 Feb 2022 12:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=mRnwsckpOZEOzJRp+vH/tiCdw3vZv2oJQwGWi1VkBT4=; b=cEM/a8HfVpJy36VpZLKcxxJOaN
        qFA5LuqH8piOtvXPhXLvPAM9Q28Y3kHp8xkGYACDN47TIFPyCb5xPyhRRFGwCsKMV02Ww4340Dv1m
        2hGbcwveUHKiyB+5wDzOxDVOygCZQG0U6H5F6D1cAZOq30wwGL0edDbYsAyy6oQSDfPlTF9PfdIH9
        rd0fRVZMYUczjTM6hLHlJY4jDZkV4ha9J/A1wlY/FFH0+z0DE+BgoIRD0tfKrjXvdmkcHgKusHIUV
        bNORt6aAUtdwkSRF7PiTMIIGXJEwpw3ujb3UM0ftD6+fe8ank+ueBXjUcxGiTtl2cAaF+DjgDL2Zg
        aicWoXoA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNhZl-0067eL-2x; Fri, 25 Feb 2022 20:52:29 +0000
Message-ID: <515e00ec-fdfb-0a45-f504-4dd2dce60254@infradead.org>
Date:   Fri, 25 Feb 2022 12:52:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net] net: ipa: fix a build dependency
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220225201530.182085-1-elder@linaro.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220225201530.182085-1-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/22 12:15, Alex Elder wrote:
> An IPA build problem arose in the linux-next tree the other day.
> The problem is that a recent commit adds a new dependency on some
> code, and the Kconfig file for IPA doesn't reflect that dependency.
> As a result, some configurations can fail to build (particularly
> when COMPILE_TEST is enabled).
> 
> The recent patch adds calls to qmp_get(), qmp_put(), and qmp_send(),
> and those are built based on the QCOM_AOSS_QMP config option.  If
> that symbol is not defined, stubs are defined, so we just need to
> ensure QCOM_AOSS_QMP is compatible with QCOM_IPA, or it's not
> defined.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 34a081761e4e3 ("net: ipa: request IPA register values be retained")
> Signed-off-by: Alex Elder <elder@linaro.org>

Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

> ---
>  drivers/net/ipa/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> index d037682fb7adb..e0164a55c1e66 100644
> --- a/drivers/net/ipa/Kconfig
> +++ b/drivers/net/ipa/Kconfig
> @@ -3,6 +3,7 @@ config QCOM_IPA
>  	depends on NET && QCOM_SMEM
>  	depends on ARCH_QCOM || COMPILE_TEST
>  	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
> +	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
>  	select QCOM_MDT_LOADER if ARCH_QCOM
>  	select QCOM_SCM
>  	select QCOM_QMI_HELPERS

-- 
~Randy
