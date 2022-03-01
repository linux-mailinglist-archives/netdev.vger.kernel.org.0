Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349444C8331
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiCAFfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:35:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbiCAFfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:35:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F2970F48;
        Mon, 28 Feb 2022 21:35:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30C3A61030;
        Tue,  1 Mar 2022 05:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C4AC340EE;
        Tue,  1 Mar 2022 05:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646112911;
        bh=yulE+IPxlxYpmFDBcItH84VTpVmoVAp0vgR2CalT8kg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IQD7RnFkDQQL95isKBUCzdpglKb0EPoZWgJ5GdfK615LtXWMBtGWte16tgVW6xvfu
         waqMQe6yTk3QCbkfLUHhzMJvzGYIiAXdozqBKboqXRlP8CC2rsfCcqNl9TdHPdcYdB
         ioVYeAb5LnbdsEvBVepDl0n7MAr9ogEfopbHxSocbX9ejgymlGVLj/8eBuGnX/u5pJ
         ad5isNMNwTewzqRltc3UZrgS2v25Nd44aDg4Rqrz5nuGsTIBAheWOjMSk0BKvcoPLb
         VlR9VRjsTRuGFhiB2Y3ICl+ri9FSiO4AwNpsBIMpMSg/qtGhYqyT6TXum/lFsZkp5/
         QlnI/2U0YbspQ==
Date:   Mon, 28 Feb 2022 21:35:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, lkp@intel.com,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: add an interconnect dependency
Message-ID: <20220228213509.64434f4b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220226195747.231133-1-elder@linaro.org>
References: <20220226195747.231133-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Feb 2022 13:57:47 -0600 Alex Elder wrote:
> In order to function, the IPA driver very clearly requires the
> interconnect framework to be enabled in the kernel configuration.
> State that dependency in the Kconfig file.
> 
> This became a problem when CONFIG_COMPILE_TEST support was added.
> Non-Qualcomm platforms won't necessarily enable CONFIG_INTERCONNECT.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 38a4066f593c5 ("net: ipa: support COMPILE_TEST")
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipa/Kconfig b/drivers/net/ipa/Kconfig
> index d037682fb7adb..3e0da1e764718 100644
> --- a/drivers/net/ipa/Kconfig
> +++ b/drivers/net/ipa/Kconfig
> @@ -2,6 +2,7 @@ config QCOM_IPA
>  	tristate "Qualcomm IPA support"
>  	depends on NET && QCOM_SMEM
>  	depends on ARCH_QCOM || COMPILE_TEST
> +	depends on INTERCONNECT
>  	depends on QCOM_RPROC_COMMON || (QCOM_RPROC_COMMON=n && COMPILE_TEST)
>  	select QCOM_MDT_LOADER if ARCH_QCOM
>  	select QCOM_SCM

Looks like this patch was based on a tree without the QCOM_AOSS_QMP
dependency patch, please rebase and repost.
