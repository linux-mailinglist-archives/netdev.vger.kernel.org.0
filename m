Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCD84483950
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiACXyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiACXx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:53:59 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939DBC061761;
        Mon,  3 Jan 2022 15:53:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NzpSqidIrSiRvAMR2e/pdmK+AJmG9qozRG/2nhDCeio=; b=CIQcd34nacfek6rhCdFSm9e5pB
        wySYuhnWTNgK8Y3HbOu7pOdlaFwl1xm8ti5eJo4D4CytGItGUWD31aASEB6NEgk+kOFZPq5B9sw+a
        r9Et/1igfhuKbTFcNte5abfrpYXbci6HtU+5EDrCZKWdNcYUmcOAJA6uLYw8f29oJwt/n6DLyCEvI
        gQO8ij9X/e0FrdrOsPumQeNfuILOjeNQ4xzAlJgXS6c/xwzCMROXeKjBTAXuUC39phqEcBFGoOH3s
        omgwtU/uymADgFFDdhZ7Qv38rD1VsJCXijI8+/3txE0LU58aOLJf9Rr7Ut33N5mY3VGJsjaYi23FK
        KtJDyc8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56540)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4X9J-0006Uw-Sj; Mon, 03 Jan 2022 23:53:57 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4X9J-0006gA-AK; Mon, 03 Jan 2022 23:53:57 +0000
Date:   Mon, 3 Jan 2022 23:53:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <YdOMlfbMH9b553V/@shell.armlinux.org.uk>
References: <20220103232555.19791-4-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103232555.19791-4-richardcochran@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 03:25:54PM -0800, Richard Cochran wrote:
> Make the sysfs knob writable, and add checks in the ioctl and time
> stamping paths to respect the currently selected time stamping layer.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>

As I stated for patch 2, this patch will break mvpp2 PTP support,
since as soon as we bind a PHY, whether or not it supports PTP, you
will switch "selected_timestamping_layer" to be PHY mode PTP, and
direct all PTP calls to the PHY layer whether or not the PHY has
PTP support, away from the MAC layer.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
