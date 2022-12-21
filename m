Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E2B6530B5
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 13:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiLUMV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 07:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiLUMVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 07:21:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7A823308
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 04:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2K4ejAIHjvqC+B911MFc7BlaxyFTfJxZCB1dggJi85c=; b=YQgR9NsvEkWkaEFJsIMtJAt3+q
        q68f5i3OQU0/5Ku3l9Gc5868wROAsaemJvCQeEOLmqhYVFETnswqqAL9m4ELGBhsm+Bn6D81yZWBP
        ucDYSOleK7Tj/SHvhEONrXWSAwT80wjvoGDnomu9UUtKrEuQzKteRkmLknCM5xky2Kmw33yppHrKA
        iavTib2ZpvlJ5cfouHFjMJYbwtoAT40u7QOmYnxVJw4rQz4nagnNXDMGYC0Vns4WG1f7Du1xkia1e
        eGsAWgke3gPpYd7yMc5DJcatiOilahdCwm/gBxLC6Eqn7wtPHYmoyAubvpTWQyjI9bYUOJEjMXcBg
        qNnl6mYg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35804)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p7y6a-0000az-48; Wed, 21 Dec 2022 12:21:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p7y6Z-0006XR-EA; Wed, 21 Dec 2022 12:21:51 +0000
Date:   Wed, 21 Dec 2022 12:21:51 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net v2] net: phy: mxl-gpy: fix delay time required by
 loopback disable function
Message-ID: <Y6L6X2w5EdUBq5ON@shell.armlinux.org.uk>
References: <20221221094358.29639-1-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221094358.29639-1-lxu@maxlinear.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Dec 21, 2022 at 05:43:58PM +0800, Xu Liang wrote:
> GPY2xx devices need 3 seconds to fully switch out of loopback mode
> before it can safely re-enter loopback mode.

Would it be better to record the time that loopback mode is exited,
and then delay an attempt to re-enter loopback mode if it's less than
three seconds since we exited?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
