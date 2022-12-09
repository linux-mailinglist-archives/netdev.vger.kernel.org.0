Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08204647C7F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 04:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLIDDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 22:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLIDDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 22:03:00 -0500
X-Greylist: delayed 1931 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Dec 2022 19:02:48 PST
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CCE26486;
        Thu,  8 Dec 2022 19:02:47 -0800 (PST)
Received: from [78.40.148.178] (helo=webmail.codethink.co.uk)
        by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
        id 1p3SfQ-006rLO-U8; Fri, 09 Dec 2022 01:59:12 +0000
MIME-Version: 1.0
Date:   Fri, 09 Dec 2022 01:59:08 +0000
From:   Ben Dooks <ben.dooks@codethink.co.uk>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v1 2/7] net: stmmac: platform: Add snps,dwmac-5.20 IP
 compatible string
In-Reply-To: <20221201090242.2381-3-yanhong.wang@starfivetech.com>
References: <20221201090242.2381-1-yanhong.wang@starfivetech.com>
 <20221201090242.2381-3-yanhong.wang@starfivetech.com>
Message-ID: <f6fd99d22a025377e176890cc7641ab9@codethink.co.uk>
X-Sender: ben.dooks@codethink.co.uk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-12-01 09:02, Yanhong Wang wrote:
> Add "snps,dwmac-5.20" compatible string for 5.20 version that can avoid
> to define some platform data in the glue layer.
> 
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> index 50f6b4a14be4..cc3b701af802 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
> @@ -519,7 +519,8 @@ stmmac_probe_config_dt(struct platform_device
> *pdev, u8 *mac)
>  	if (of_device_is_compatible(np, "snps,dwmac-4.00") ||
>  	    of_device_is_compatible(np, "snps,dwmac-4.10a") ||
>  	    of_device_is_compatible(np, "snps,dwmac-4.20a") ||
> -	    of_device_is_compatible(np, "snps,dwmac-5.10a")) {
> +	    of_device_is_compatible(np, "snps,dwmac-5.10a") ||
> +	    of_device_is_compatible(np, "snps,dwmac-5.20")) {
>  		plat->has_gmac4 = 1;
>  		plat->has_gmac = 0;
>  		plat->pmt = 1;

out of interest, is the version of the ip autodetectable yet?
also, we would be better off if having an if (version > 4) check if we 
use the standard snps ip block code headers

