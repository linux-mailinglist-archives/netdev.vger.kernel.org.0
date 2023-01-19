Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916C3673680
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjASLO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbjASLOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:14:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D266DB33;
        Thu, 19 Jan 2023 03:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23CCB611F8;
        Thu, 19 Jan 2023 11:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48B6C433D2;
        Thu, 19 Jan 2023 11:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674126879;
        bh=p3Z8Q4RuUEKmn89jofySoCuckl7D3b7GECL7f6tdmis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oammpthbp+k17llgdvjQtywF/mkmiCatFL8NT7ZjboYjzeOzvWUj2onOepljpgKr9
         HO+1huJW58CWoSX2gypnx7qm4NT4/YTZcSBGg2qy4Ydk7BptInzehY7Ts0j2eOIbda
         WOgP8/Z6oN5qBuhhnGqqxzN7HCBuf/b6GXCURSK/7+VNS45FUoOjxhX87s2gAbABFH
         EkCxym/b2Jy9Hle3z7lY1IpT+Rhc7/TjX63MLpoANzR0cmUL2ACLFjmpbg+/xbhEHL
         lTlU0X6yKDV5QqO9TRRze5eXx5WNAAJUThQibPM36+eObIIlidHCmBi9IVthNt5kUB
         YJOvCNYogX6Rg==
Date:   Thu, 19 Jan 2023 16:44:35 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/7] phy: Add devm_of_phy_optional_get() helper
Message-ID: <Y8kmG+jB/s7stebA@matsya>
References: <cover.1674036164.git.geert+renesas@glider.be>
 <f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be>
 <20230118192809.2082b004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118192809.2082b004@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18-01-23, 19:28, Jakub Kicinski wrote:
> On Wed, 18 Jan 2023 11:15:14 +0100 Geert Uytterhoeven wrote:
> > Add an optional variant of devm_of_phy_get(), so drivers no longer have
> > to open-code this operation.
> 
> For merging could you put this one on an immutable branch and then
> everyone can pull + apply patches for callers from their section?

Since this is phy, I can do that and everyone else can merge that in or
all changes can go thru phy tree

Thanks
-- 
~Vinod
