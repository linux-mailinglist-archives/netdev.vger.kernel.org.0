Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3C546351C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 14:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236985AbhK3NM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 08:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237001AbhK3NMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 08:12:54 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D32C061746
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 05:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CrzjMyMj2fl+xR9Xgec/HhrwWoXtgbAxoLeORV+tOYo=; b=ZpB1Rn0vkmm1hNCeGtYURz1If4
        FyIwe+SD5wf4KHzKSFK6VDLZXyeToNFLfRd3RrhKrp+bin0Sk229PEfXXuq1mi0Dm0s98FsIIWRot
        eYPCTXQwrW6M+oWN/5hktvubPZwXKXj3bBGjRsQhTR3XcFzaUciNYNjnQnOkgX3dFTU82d0OwWib/
        RoNJMZjWNSQnAIIvR7GnGYkk3bU12C/wqVovp6OqDHYo402mxdzVKTlQWdbopLSsR/cIezHG2YSfk
        B8q9PrwMcfO5HiTahSwaFldZDlXKJtpsQ5HWyWdXcdXoIY6z+sbslm7Fy8alLOhRA7QQKE86kNmxT
        Ph5GfGYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55982)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ms2t1-0006uw-Ty; Tue, 30 Nov 2021 13:09:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ms2sz-00074y-Rm; Tue, 30 Nov 2021 13:09:29 +0000
Date:   Tue, 30 Nov 2021 13:09:29 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/5] net: dsa: convert two drivers to
 phylink_generic_validate()
Message-ID: <YaYiiU9nvmVugqnJ@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following series comes from the RFC series posted last Thursday
adding support for phylink_generic_validate() to DSA.

Patches 1 to 3 update core DSA code to allow drivers to be converted,
and patches 4 and 5 convert hellcreek and lantiq to use this (both of
which received reviewed-by from their maintainers.) As the rest have
yet to be reviewed by their maintainers, they are not included here.

Patch 1 had a request to change the formatting of it; I have not done
so as I believe a patch should do one change and one change only -
reformatting it is a separate change that should be in its own patch.
However, as patch 2 gets rid of the reason for reformatting it, it
would be pointless, and pure noise to include such an intermediary
patch.

Instead, I have swapped the order of patches 2 and 3 from the RFC
series.

 drivers/net/dsa/hirschmann/hellcreek.c |  24 ++++---
 drivers/net/dsa/lantiq_gswip.c         | 120 +++++++++++----------------------
 include/net/dsa.h                      |   4 +-
 net/dsa/dsa_priv.h                     |   2 +-
 net/dsa/port.c                         |  48 ++++++++-----
 net/dsa/slave.c                        |  19 +-----
 6 files changed, 88 insertions(+), 129 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
