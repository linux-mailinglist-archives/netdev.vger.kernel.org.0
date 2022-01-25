Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FDD49B987
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1587228AbiAYRBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587076AbiAYQ7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:59:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEFEC061780
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 08:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rc17EqJotT9igAWejJvxQHWflHYheJvAZvsnwj9OshQ=; b=bHp9pGOHATOy0i8hymwN9JFnvZ
        zF9jG6x2jZmuImuWDjTYJjZJm+rgtWDO1b5nlM7c4oar1F0cmg60//Gn0167KtC+44pZ3u/9ZCmeH
        WEijdzNnZlMtvGoAC4XshaVsqaVC4b6tY/0rAR2qDfIhS52sU3HoQ5HqQW38Kk6syCAt8W53raK/W
        qz9xnOByGCpPZzUCFTeu8RyM7MqIcdT6wM5OOCu+zzy7ht0ekBHnYyM7N68DlfyF4ayYmx220k2JW
        N/TEMfgAhPTZfUPCL6NKGH5qjqV2UnrudpWOom3cL1TrUz+9C94bkmpdy3gm6w5sP5HLsjNNJBlAQ
        OKzEmilQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56860)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nCP9z-0002Es-Qo; Tue, 25 Jan 2022 16:59:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nCP9x-0003Ro-Vh; Tue, 25 Jan 2022 16:59:09 +0000
Date:   Tue, 25 Jan 2022 16:59:09 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: mvneta: use .mac_select_pcs()
Message-ID: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts mvneta to use the .mac_select_pcs() like eventually
everything else will be. mvneta is slightly more involved because we
need to rearrange the initialisation first to ensure everything required
is initialised prior to phylink_create() being called.

Tested locally on SolidRun Clearfog.

 drivers/net/ethernet/marvell/mvneta.c | 115 ++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 54 deletions(-)


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
