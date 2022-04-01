Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F66B4EF63F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347959AbiDAPb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352403AbiDAPDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 11:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3182928F822;
        Fri,  1 Apr 2022 07:51:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15C2EB82504;
        Fri,  1 Apr 2022 14:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D98C340EE;
        Fri,  1 Apr 2022 14:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824660;
        bh=gjV78sg4M+SM1WZOKlh+sYIDNQs2GbRiH0Kl00+k6sU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XtL/uOlm7Nc/XmvuFw9Y8MtWQjXB4YZxqS9fsjx/DLkiHyr7t611GPc4N30ZUWosI
         IbH9H7f6G2MXdFMO7g80pNst29rq5yBE/AC+QU6eDkb6UDaFqadfzdt09ucBXG3DTr
         mPQh/siL1bHfm+/iWaHQeBSL5b6a5msoZOxR6CA3GIVMJ9nWtd/gU2500iKjMpbyzQ
         zc0EOfevuMQ/7n2/CxQ6Lk8feUVkwqb/n1P2iQnwSy7dT+e75xnUPhb0AywOUhBaJr
         u4W1kOQfxdp69fWzo6QoLdcSkHodk3c4PTNnY94yW+I0TTkgkdGUlTfDbMeFTJt4Ro
         zmIv6r7ZkLU7g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath11k: select QRTR for AHB as well
References: <20220401093554.360211-1-robimarko@gmail.com>
Date:   Fri, 01 Apr 2022 17:50:55 +0300
In-Reply-To: <20220401093554.360211-1-robimarko@gmail.com> (Robert Marko's
        message of "Fri, 1 Apr 2022 11:35:54 +0200")
Message-ID: <87ilrsuab4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robimarko@gmail.com> writes:

> Currently, ath11k only selects QRTR if ath11k PCI is selected, however
> AHB support requires QRTR, more precisely QRTR_SMD because it is using
> QMI as well which in turn uses QRTR.
>
> Without QRTR_SMD AHB does not work, so select QRTR in ATH11K and then
> select QRTR_SMD for ATH11K_AHB and QRTR_MHI for ATH11K_PCI.
>
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
>
> Signed-off-by: Robert Marko <robimarko@gmail.com>
> ---
>  drivers/net/wireless/ath/ath11k/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
> index ad5cc6cac05b..b45baad184f6 100644
> --- a/drivers/net/wireless/ath/ath11k/Kconfig
> +++ b/drivers/net/wireless/ath/ath11k/Kconfig
> @@ -5,6 +5,7 @@ config ATH11K
>  	depends on CRYPTO_MICHAEL_MIC
>  	select ATH_COMMON
>  	select QCOM_QMI_HELPERS
> +	select QRTR
>  	help
>  	  This module adds support for Qualcomm Technologies 802.11ax family of
>  	  chipsets.
> @@ -15,6 +16,7 @@ config ATH11K_AHB
>  	tristate "Atheros ath11k AHB support"
>  	depends on ATH11K
>  	depends on REMOTEPROC
> +	select QRTR_SMD
>  	help
>  	  This module adds support for AHB bus
>  
> @@ -22,7 +24,6 @@ config ATH11K_PCI
>  	tristate "Atheros ath11k PCI support"
>  	depends on ATH11K && PCI
>  	select MHI_BUS
> -	select QRTR
>  	select QRTR_MHI
>  	help
>  	  This module adds support for PCIE bus

I now see a new warning:

WARNING: unmet direct dependencies detected for QRTR_SMD
  Depends on [n]: NET [=y] && QRTR [=m] && (RPMSG [=n] || COMPILE_TEST [=n] && RPMSG [=n]=n)
  Selected by [m]:
  - ATH11K_AHB [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && ATH11K [=m] && REMOTEPROC [=y]

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
