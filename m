Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B0755FC75
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbiF2JoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiF2JoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:44:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B2D3B02F;
        Wed, 29 Jun 2022 02:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hTOUDEg4blfwUlQNzGC/+sYc9DIP+OWNGDmymLRC7EI=; b=oTtVDKJbUIdpUWfW1bnc8xR6ec
        IQsR3eTeNU6Zbl+LYfRtyMQL3pokuL+xCLGbDuQAWiwQUTh19A4NTHOmvlJrzEfX2Mv9D2Ol7FiLC
        cW5q6tGh2WxS294PooM7CRGLaiBoOjtQnuMePLUBIHhz5cJUau2kWWDAXAXjZh/GbsYfWd2bzJ3tY
        lN4nk6aCAkF9p2QUzPJewP3Zg7X0ryCT0P+Am2CnTaZS/i1x142TSgFTE6FASGpsO2prQJzglA0fL
        8y1JD/AIoevunjSjKb6edLa1ZY3lyuxIL7Pg6EPgpIc+LErA2oqtFB9w3wNiPGewhZcnUQWmmgmkC
        Iy1IjcDQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33088)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o6UEm-0002mh-RT; Wed, 29 Jun 2022 10:43:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o6UEk-0005kp-FV; Wed, 29 Jun 2022 10:43:54 +0100
Date:   Wed, 29 Jun 2022 10:43:54 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net: sfp: fix memory leak in sfp_probe()
Message-ID: <Yrwe2oWk/lXkZQgL@shell.armlinux.org.uk>
References: <20220629075550.2152003-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629075550.2152003-1-niejianglei2021@163.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 03:55:50PM +0800, Jianglei Nie wrote:
> sfp_probe() allocates a memory chunk from sfp with sfp_alloc(). When
> devm_add_action() fails, sfp is not freed, which leads to a memory leak.
> 
> We should use devm_add_action_or_reset() instead of devm_add_action().
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>

Thanks!

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
