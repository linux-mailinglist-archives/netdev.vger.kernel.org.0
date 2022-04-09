Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358144FA742
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 13:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241651AbiDILYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbiDILYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 07:24:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111F72D8C28;
        Sat,  9 Apr 2022 04:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LbzHadhH/DtBXgPRRQM3ojAn+8JRNa/F/dn71QaSpzc=; b=ml64Ik3eYsRGrNQ5LUoQkIqZEB
        DLwmWoH8CrTLneNBbwmtkQmAnM7/bd2mv6N5f+hj4VTvOz+6PQuNIXYCQc8N9RW+t29nzBsTiNape
        I9zoQDHOepVvUVLJ+TPcCx3etDoajV4w+iB6QEe6Mj8dYh9UJKYzwmORJOjzMkf6rZdq2TjMLEqNI
        DSm8lXLhLqknt1zjXsdOF0J5gwda+oWBlgn2SWXb7O9yTGCTKTDA18qCD65a+4O3wY1gDMGXi7aBo
        AUoiWF/SzNN4dHT2wEm5EH5pktY3p4av/ByuNPbTfl6jBDQlM21lmnq+hWUOJnV3fqq/CDlupqaoj
        C899HO+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58180)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nd9Ab-00071R-8D; Sat, 09 Apr 2022 12:22:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nd9AY-0007uv-97; Sat, 09 Apr 2022 12:22:18 +0100
Date:   Sat, 9 Apr 2022 12:22:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        vladimir.oltean@nxp.com, s-vadapalli@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] net: ethernet: ti: am65-cpsw: Fix build error
 without PHYLINK
Message-ID: <YlFsauXYPB2QzUjc@shell.armlinux.org.uk>
References: <20220409105931.9080-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409105931.9080-1-yuehaibing@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 06:59:31PM +0800, YueHaibing wrote:
> If PHYLINK is n, build fails:
> 
> drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_link_ksettings':
> am65-cpsw-ethtool.c:(.text+0x118): undefined reference to `phylink_ethtool_ksettings_set'
> drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_get_link_ksettings':
> am65-cpsw-ethtool.c:(.text+0x138): undefined reference to `phylink_ethtool_ksettings_get'
> drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_eee':
> am65-cpsw-ethtool.c:(.text+0x158): undefined reference to `phylink_ethtool_set_eee'
> 
> Select PHYLINK for TI_K3_AM65_CPSW_NUSS to fix this.
> 
> Fixes: e8609e69470f ("net: ethernet: ti: am65-cpsw: Convert to PHYLINK")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
