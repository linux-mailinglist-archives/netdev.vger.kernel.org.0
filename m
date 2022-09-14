Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5F5B8C72
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiINQFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiINQFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:05:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C0C52DF5;
        Wed, 14 Sep 2022 09:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FwesLpLPuGyJPMI7wyXhTgLiMYCetylz5H1vHnn5ZMM=; b=pBAjllSS/SZ1vhpJFqQmPESKFr
        NpVVBneVr5n1KZa1BfzH/ww6j9GbAqsBAX3AXjNnPxS3rKpbsXB6t4/RMGKA0syJFlgB5UXu1ViJ4
        c7NR/3ysaCOxZnOP6iY5LjIrdLlzO4AwatGd7zdAOc6uUyCCuS+2KT/z1xUAyfWoA5xfAbfyXa5mU
        /JfUkHw+dDoL+xvH+M01ZAk1G2n4V/EXz1FvxQywtoMnbokckwxuiVpSpQ8xzKshlJbiveE5gnRLj
        dob/Yl9sJCOejEJIdKWHEk5te/VK/u8F38TVNsrZf8WxMVKqxGgb6F8DWj06Il/LmUM0oiGFMpE7F
        MlrYsLNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34330)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYUsk-0004aV-P3; Wed, 14 Sep 2022 17:04:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYUsj-0001mU-C4; Wed, 14 Sep 2022 17:04:57 +0100
Date:   Wed, 14 Sep 2022 17:04:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski@linaro.org, krzysztof.kozlowski+dt@linaro.org,
        vladimir.oltean@nxp.com, grygorii.strashko@ti.com, vigneshr@ti.com,
        nsekhar@ti.com, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kishon@ti.com
Subject: Re: [PATCH 6/8] net: ethernet: ti: am65-cpsw: Add support for SGMII
 mode for J7200 CPSW5G
Message-ID: <YyH7qTZL9Pv1DJdB@shell.armlinux.org.uk>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
 <20220914095053.189851-7-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914095053.189851-7-s-vadapalli@ti.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 03:20:51PM +0530, Siddharth Vadapalli wrote:
> +#define MAC2MAC_MR_ADV_ABILITY_BASE		(BIT(15) | BIT(0))
> +#define MAC2MAC_MR_ADV_ABILITY_FULLDUPLEX	BIT(12)
> +#define MAC2MAC_MR_ADV_ABILITY_1G		BIT(11)
> +#define MAC2MAC_MR_ADV_ABILITY_100M		BIT(10)
> +#define MAC2PHY_MR_ADV_ABILITY			BIT(0)

In addition to my other comments, this looks like a reimplementation of
the LPA_SGMII* constants found in include/uapi/linux/mii.h

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
