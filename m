Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D6843B885
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbhJZRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbhJZRtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:49:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE09C061745
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 10:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uyk4EEnZfAucuLAziXWqQNuTImmXkBpvJyFXF1BlOFE=; b=QrclmoA+T+6a+I5vVlyWzHxUS9
        Raqg2ZMET3qonKvpa/ISG+DmfeHMUKZMsuu4lSSb8yV+qPXwS8jtFE2Yku25tHMVRcbA0Hz9XkdrI
        jXljFfmYS+b0CZlLd3GpMFROR6S64bfFFmE8/4J4kQk+lMP57t7ISCzdSanz7L4vO7ltSr54dFFvH
        jnGar1aFcDUhnrMEOBTYXtp5wh6vvFU+jb8apZNxlXj9AqE8Es6cMKR+db+ZK5wAqk5FCCkFb0e0f
        6jT41INovOzYwM8fOtP4LIoX3KmmVdfw8QxeEP34yJod2R9rloTxfkObqb0wBTPN2y2VyM4xqRam5
        htJcOtZA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55322)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfQXF-0005cx-Fr; Tue, 26 Oct 2021 18:46:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfQXE-0006wd-OZ; Tue, 26 Oct 2021 18:46:52 +0100
Date:   Tue, 26 Oct 2021 18:46:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <YXg/DP2d1UM831+c@shell.armlinux.org.uk>
References: <20211025172405.211164-1-sean.anderson@seco.com>
 <YXcfRciQWl9t3E5Y@shell.armlinux.org.uk>
 <5e946ab6-94fe-e760-c64b-5abaf8ac9068@seco.com>
 <a0c6edd9-3057-45cf-ef2d-6d54a201c9b2@microchip.com>
 <YXg1F7cGOEjd2a+c@shell.armlinux.org.uk>
 <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d9f92e-78d8-5d14-50d1-1ed886ec0e17@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 01:28:15PM -0400, Sean Anderson wrote:
> Actually, according to the Zynq UltraScale+ Devices Register Reference
> [1], the PCS does not support 10/100. So should SGMII even fall through
> here?
> 
> [1] https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_control.html

Hmm. That brings with it fundamental question: if the PCS supports 1G
only, does it _actually_ support Cisco SGMII, or does it only support
1000base-X?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
