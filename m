Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292C850AFDD
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbiDVGDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbiDVGCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:02:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796CA4F9E8;
        Thu, 21 Apr 2022 22:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14E0D61DCB;
        Fri, 22 Apr 2022 05:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A62DC385A0;
        Fri, 22 Apr 2022 05:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650607188;
        bh=Z6tYJdQ52dK4e0TCyEc9tLY3AwqFGgq40orqV6fBm6I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=r84SSopwf/s426Y3Tqm8PhD7fx4YvbRG9di2doiNhFgYM+pLczZUTEomOCqe8/n7i
         QwGm6NDr/N6xfl8Vz0vxV4TIvWnvavgsATCFf4wYOo7OuRCIjXseHk300sUFZHYWZ+
         8Xi4gOKnnH4If6c4M9JE7MxoR/tfQJWFPoK3WxO/gG89eb6fAAVwO8pnMxhcq3QMzu
         OefWm0STllhbrVFwX/caHXJzOjWhG3CqpJhuofyMIww6R4LvXLD7fLuZnmkCee/ZwS
         8Cd3aG68oWXgXwrIQJqeA4Z9dyxFNxOk8+FPUBpMBxLCecW9rHVO8Z/dRtqztCCx6b
         s3RANwmlupXdg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hermes Zhang <chenhui.zhang@axis.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        Hermes Zhang <chenhuiz@axis.com>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] brcmfmac: of: introduce new property to allow disable PNO
References: <20220422044419.3415842-1-chenhui.zhang@axis.com>
Date:   Fri, 22 Apr 2022 08:59:43 +0300
In-Reply-To: <20220422044419.3415842-1-chenhui.zhang@axis.com> (Hermes Zhang's
        message of "Fri, 22 Apr 2022 12:44:18 +0800")
Message-ID: <8735i5odyo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hermes Zhang <chenhui.zhang@axis.com> writes:

> From: Hermes Zhang <chenhuiz@axis.com>
>
> The PNO feature need to be disable for some scenario in different
> product. This commit introduce a new property to allow the
> product-specific toggling of this feature.

"some scenario"? That's not really helpful.

> Signed-off-by: Hermes Zhang <chenhuiz@axis.com>
> ---
>
> Notes:
>     Change property name to brcm,pno-disable
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index 8623bde5eb70..121a195e4054 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -11,6 +11,7 @@
>  #include "core.h"
>  #include "common.h"
>  #include "of.h"
> +#include "feature.h"
>  
>  static int brcmf_of_get_country_codes(struct device *dev,
>  				      struct brcmf_mp_device *settings)
> @@ -102,6 +103,9 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>  	if (bus_type != BRCMF_BUSTYPE_SDIO)
>  		return;
>  
> +	if (of_find_property(np, "brcm,pno-disable", NULL))
> +		settings->feature_disable |= BIT(BRCMF_FEAT_PNO);

Is this DT property documented and acked by the Device Tree maintainers?
AFAIK DT is not supposed to be used as a software configuration
database.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
