Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D489688EF8
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 06:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjBCF1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 00:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjBCF1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 00:27:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982381F5C1;
        Thu,  2 Feb 2023 21:27:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 327FF61D0D;
        Fri,  3 Feb 2023 05:27:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95D55C433EF;
        Fri,  3 Feb 2023 05:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675402051;
        bh=fHq9IkxqxVUwz3GGvOE/Mwt4EK7elXIC9jlHvqcrh8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8aDl1NIsRsl5BjZTgbUD7FGwU0exrjPdV5CSous9UsW/GkGSVWtwdmywNbhtc1vP
         qD9wUxbxs4lj9ObsBx32KTRRww8VYUVzr6hON2oshLd7CP5vusl+YUfCsiAkfcSbSw
         7Z6mei8DcZOM3Ehye2TfF33alKtXhQjfgRng4kstNIvCyfoPX98cySlNoZWzbVFS2d
         cor3Ij5NklP1JiZI+8k/udVX0Y6uJoq2kDnY3bYNBFzIO3aheHu2zWc5I9WQSve3bl
         0dJycH5YhwSy/+uaptRsgK8hnl4CyBZ+y01J2rNUqcZt8yXiLMgEcbaeqXlcGIi7ry
         TS2czWrz8ECfQ==
Date:   Fri, 3 Feb 2023 10:57:26 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 6/9] net: ethernet: ti: am65-cpsw: Convert to
 devm_of_phy_optional_get()
Message-ID: <Y9ybPmWub43JpMUb@matsya>
References: <cover.1674584626.git.geert+renesas@glider.be>
 <3d612c95031cf5c6d5af4ec35f40121288a2c1c6.1674584626.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d612c95031cf5c6d5af4ec35f40121288a2c1c6.1674584626.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24-01-23, 19:37, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - Rebase on top of commit 854617f52ab42418 ("net: ethernet: ti:
>     am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in net-next
>     (next-20230123 and later).

I was trying to apply this on rc1, so ofcourse this fails for me? How do
we resolve this?

I can skip this patch, provide a tag for this to be pulled into -net
tree

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
>  
>  	/* Serdes PHY exists. Store it. */
>  	port->slave.serdes_phy = phy;
> -- 
> 2.34.1

-- 
~Vinod
