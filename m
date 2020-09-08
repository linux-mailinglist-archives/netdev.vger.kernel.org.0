Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4EE262210
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 23:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgIHVrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 17:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgIHVrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 17:47:43 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE40C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 14:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=K1GvyEssQ1ZfebI1jIj7Gp/unXLag+ubOD3vkaJ7pho=; b=kykUE8D+GZU/L57OeE7gCFv2Z
        Ar6dbxczxQCC6+0mQ7tD2tkRwp6yTyyKXLDP8NKJlq9hse0JmBwbmVhPWz/w/5nY+IyiUpkquwV+I
        L35z9nWxfTQbux008LhjRmVx2uNOk56L8L+nOA5uYqTG2XzTD2a1/wRmOoLOdfrNjGEU7pLLX/BGp
        2wPzEW8nxx6n7Yu+wkt480HQOvDivo6vT1YFAmrNjGh/ThWYr7K8hMhnca7XOowC1oQ5qDn1vAYYR
        RlvSlMtb1cm7UUxTLqHeKccm7jXI+edjui2w2lEWofDXv68HHzHldmI0K8xqisD56VsAwBsEV5LvC
        roliiXaoQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32930)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kFlSd-0004Am-6f; Tue, 08 Sep 2020 22:47:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kFlSZ-0005n2-TL; Tue, 08 Sep 2020 22:47:27 +0100
Date:   Tue, 8 Sep 2020 22:47:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next v3 0/6] Marvell PP2.2 PTP support
Message-ID: <20200908214727.GZ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds PTP support for PP2.2 hardware to the mvpp2 driver.
Tested on the Macchiatobin eth1 port.

Note that on the Macchiatobin, eth0 uses a separate TAI block from
eth1, and there is no hardware synchronisation between the two.

 drivers/net/ethernet/marvell/Kconfig            |   6 +
 drivers/net/ethernet/marvell/mvpp2/Makefile     |   3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 196 +++++++++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 411 ++++++++++++++++++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c  | 456 ++++++++++++++++++++++++
 5 files changed, 1022 insertions(+), 50 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c

v2: add Andrew's r-bs, squash patch 6 and patch 7.
v3: Address Richard's comments on patch 4.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
