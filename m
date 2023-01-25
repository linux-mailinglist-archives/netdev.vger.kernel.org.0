Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA3567A9E7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 06:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbjAYFPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 00:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjAYFPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 00:15:08 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C515E30C1;
        Tue, 24 Jan 2023 21:15:05 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 30P5DFVr110850;
        Tue, 24 Jan 2023 23:13:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1674623595;
        bh=re1yuXRG1QzWfbml926PUa+KfAnb805uYLtXy/6QWZ0=;
        h=Date:CC:Subject:To:References:From:In-Reply-To;
        b=NDsjfut0T3p7vR3aO6ByE4gg3fZjdYpYkxKVaFHEcN9DDymNkY7sXGQtuQde/NpN+
         s1DBVVXRJ/7e2buVzRva7Rka8C40zLivnm/eYg6QS5go1r5KUVx0c2umJXiMSl8r0b
         npSY3OTjeIyWPydyJhIPNy0X5L+qrfNUJ7i83FYU=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 30P5DFDk056971
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 24 Jan 2023 23:13:15 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Tue, 24
 Jan 2023 23:13:15 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Tue, 24 Jan 2023 23:13:15 -0600
Received: from [172.24.145.61] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 30P5D6Wo061117;
        Tue, 24 Jan 2023 23:13:07 -0600
Message-ID: <c2626bd5-93bb-690d-6c19-d32e40f55dc0@ti.com>
Date:   Wed, 25 Jan 2023 10:43:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
CC:     <linux-phy@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <s-vadapalli@ti.com>
Subject: Re: [PATCH v2 6/9] net: ethernet: ti: am65-cpsw: Convert to
 devm_of_phy_optional_get()
Content-Language: en-US
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Russell King <linux@armlinux.org.uk>
References: <cover.1674584626.git.geert+renesas@glider.be>
 <3d612c95031cf5c6d5af4ec35f40121288a2c1c6.1674584626.git.geert+renesas@glider.be>
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <3d612c95031cf5c6d5af4ec35f40121288a2c1c6.1674584626.git.geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/01/23 00:07, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Rebase on top of commit 854617f52ab42418 ("net: ethernet: ti:
>     am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in net-next
>     (next-20230123 and later).
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index c696da89962f1ae3..794f228c8d632f7a 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -1460,11 +1460,9 @@ static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *por
>  	struct phy *phy;
>  	int ret;
>  
> -	phy = devm_of_phy_get(dev, port_np, name);
> -	if (PTR_ERR(phy) == -ENODEV)
> -		return 0;
> -	if (IS_ERR(phy))
> -		return PTR_ERR(phy);
> +	phy = devm_of_phy_optional_get(dev, port_np, name);
> +	if (IS_ERR_OR_NULL(phy))
> +		return PTR_ERR_OR_ZERO(phy);

Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Regards,
Siddharth.
