Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3E46C365A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjCUP5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbjCUP5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:57:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC454E5C7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sWV4N8h7dAyrfdqFFX5qgzGCf74m9dqObldaiP805oo=; b=x0AmLgQQS8WMZV3XRv64BZ3I+s
        k5Pdce2Ao1K0nvFkodxRru4QnaEbA25cPO+iigsfnxNwYUGLvyb36p860yxldjHMNMUbSop/N0wYA
        q2NoXxTa4d+gNdxmTD8MdmLlkAFeRU6430lky6qPD7sYTxcUx9RiMEkM/P1cR6af52ctzjLokZXxj
        d53Dk0NvjZLnzdHwhxr7otoaYSEUauj8JIjTeyX8CH9CADpKGd7sqL+DU+wmUXhutrL8jnOmHS4Aj
        LLe4GSbdbcghN3APfPLSTrFNMLY4Y0WFvTraWvHaiMWt4CXZUXmRvHVMRHVTS1EVhI3pvha1A01Gj
        tDC6d2pg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44956)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peeMi-0001TW-Qa; Tue, 21 Mar 2023 15:57:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peeMd-0007rY-R3; Tue, 21 Mar 2023 15:57:31 +0000
Date:   Tue, 21 Mar 2023 15:57:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/3] Remove phylink_state's an_enabled member
Message-ID: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Now that all the fixes and correctness patches have been merged, it is
time to switch the two users that make use of .an_enabled to check the
Autoneg bit in the advertising mask, and finally remove the
.an_enabled member.

The first two patches remove the last uses of .an_enabled, which are
in DPAA2 and XPCS. The final patch removes the member.

 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  3 +-
 drivers/net/pcs/pcs-xpcs.c                       | 10 +++++--
 drivers/net/phy/phylink.c                        | 37 +++++++++++-------------
 include/linux/phylink.h                          |  2 --
 4 files changed, 26 insertions(+), 26 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
