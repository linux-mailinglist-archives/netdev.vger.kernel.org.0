Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3EB62DB05
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234842AbiKQMfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240213AbiKQMfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:35:30 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DB631EC7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pcLFnWBpINWdtN55+ZAWI5KlFvFzM1dcp9eZKa44lfM=; b=RzTsbPp4Zb9sDjtBff+KKYW2UD
        /LXYcUXaJo/RYj4lZeRqS4SDWsyGQTiExeLj/+pC40LQL5/xItq7Ib3IG/Xf7ciPuGoOxKrY5WeVC
        da6+2GEfAsoWYcf84/9hZSFYJXIpLBW5Ak979gv+hvNhdv/FQt0yl7B6UOtd9hGUXefj9WDbaPNwP
        SGZ53Yhb+27xHIkoQ8uaGEcH3Jhjb0HORr7RNVTvJOg1HgmJbU0uF9UxIwmP45xciLHOfMq4zXieS
        7TGbuPjzsMvb0OefiWhKH9q8GZltsLqRaGUbwS6b1SfJj6cMmyKrtS+12qy9e4FVztGKXeTaKApBq
        huwq5Reg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35308)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ove6M-0004US-90; Thu, 17 Nov 2022 12:34:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ove6F-0006no-QH; Thu, 17 Nov 2022 12:34:35 +0000
Date:   Thu, 17 Nov 2022 12:34:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Liu Jian <liujian56@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        opensource@vdorst.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix error handling in
 mtk_open()
Message-ID: <Y3YqW2HApXOcDAE+@shell.armlinux.org.uk>
References: <20221117111356.161547-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117111356.161547-1-liujian56@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 07:13:56PM +0800, Liu Jian wrote:
> If mtk_start_dma() fails, invoke phylink_disconnect_phy() to perform
> cleanup. phylink_disconnect_phy() contains the put_device action. If
> phylink_disconnect_phy is not performed, the Kref of netdev will leak.
> 
> Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Looks sensible to me.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
