Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98AE767844B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjAWSRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjAWSRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:17:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F32459FA;
        Mon, 23 Jan 2023 10:17:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA556B80E5C;
        Mon, 23 Jan 2023 18:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3E0C433D2;
        Mon, 23 Jan 2023 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674497847;
        bh=BZEO8SDQ8/Vkc7GQ657ERlWHgTSZADVcbO3BThEGNLM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=bvnB7JP4zU9lnf+VoRMzrNsdyd7+16HsB1fwP94Of3IPA0jZcb66ZfnY98IGJdI6J
         KKIlByypjx8FdDgaSTMhSn3JyYOnmMMxdNQMxi8GIYtKijz0tqySBDGiO4acc8q/gb
         1CNcSAUlamyofG8sGplSaaWK1MsMjbiNxJv9h/8fToxFisaH5hAfSUsxNwADRP5qpN
         K5DG+eh7fTsr/nTX8rYTCqoo3MV7HY2sUrXEqRNQhdJZz73Hx/JpcSwuxd1go59U4Y
         ve1gvHhBJoow4ZaZWGdSzIX5geABezwJGfTNv/N76WtY8e4HB03rKNSAJfT2a8CIZI
         e7sXmSECDgWEw==
Date:   Mon, 23 Jan 2023 12:17:25 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
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
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 5/7] PCI: tegra: Convert to devm_of_phy_optional_get()
Message-ID: <20230123181725.GA903141@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9e0aa207d531ccea00e8947678a4f6ce1c625ac.1674036164.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 11:15:18AM +0100, Geert Uytterhoeven wrote:
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks!

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Let me know if you want me to apply; otherwise I'll assume you will
merge along with the [1/7] patch.

> ---
>  drivers/pci/controller/pci-tegra.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/controller/pci-tegra.c b/drivers/pci/controller/pci-tegra.c
> index 929f9363e94bec71..5b8907c663e516ad 100644
> --- a/drivers/pci/controller/pci-tegra.c
> +++ b/drivers/pci/controller/pci-tegra.c
> @@ -1330,12 +1330,9 @@ static struct phy *devm_of_phy_optional_get_index(struct device *dev,
>  	if (!name)
>  		return ERR_PTR(-ENOMEM);
>  
> -	phy = devm_of_phy_get(dev, np, name);
> +	phy = devm_of_phy_optional_get(dev, np, name);
>  	kfree(name);
>  
> -	if (PTR_ERR(phy) == -ENODEV)
> -		phy = NULL;
> -
>  	return phy;
>  }
>  
> -- 
> 2.34.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
