Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02C5B8C4A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiINPxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiINPxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:53:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498C35C35F;
        Wed, 14 Sep 2022 08:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Y2nENUJNda1WOPfbAiiYeaWd6fg5bfLU6YozHB10ABk=; b=t5yewRq8LgXr7pweKZSwjPBINP
        +Q8AIr9CBw27Sgr9NcCoemr/Zt9fQT7jIZqmIZQ4cX2vE8E32Njx6h1VWJ8+rlw7PVXL355Z+vIM0
        CKFSe8CQrwaVplEMmikJ5nfHmb7yUcjH+/cUKCgcWYQHMkW2s8A/X8Wu6+6w2zIMhWlYfVVAvGgm7
        sFGN0aO3mQuQ2kCJOJbDeFshnieU9TwOvgTk7wJzTxEWZaS6IyggpSbWRv25CTDqrZkfo+eHxx7lQ
        RvGjTJLiT7orwhuacVAfAkW2caxlak7GzY1YEvWoYevNAYcYoPC6CLszq4UmjbM4qYxSIqwa6cYBt
        gcVZUxRw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34326)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUhN-0004Ze-Lg; Wed, 14 Sep 2022 16:53:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUhM-0001mD-AA; Wed, 14 Sep 2022 16:53:12 +0100
Date:   Wed, 14 Sep 2022 16:53:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 3/8] net: ethernet: ti: am65-cpsw: Add mac control
 function
Message-ID: <YyH46OaWlk6prvep@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-4-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-4-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:48PM +0530, Siddharth Vadapalli wrote:
> Add function am65_cpsw_nuss_mac_control() corresponding to the mac
> control register writes that are performed in the
> am65_cpsw_nuss_mac_link_up() function and use it in the
> am65_cpsw_nuss_mac_link_up() function. The newly added function will be
> used in am65_cpsw_nuss_mac_config() function in a future patch, thereby
> making it necessary to define a new function for the redundant mac control
> operations.

I think if you debug why you don't see mac_link_up called when in
fixed-link mode, you won't need this change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
