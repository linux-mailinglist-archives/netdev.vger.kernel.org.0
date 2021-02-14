Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1286231AE9C
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 02:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhBNBFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 20:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBNBFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 20:05:03 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201A0C061574;
        Sat, 13 Feb 2021 17:04:23 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4863323E55;
        Sun, 14 Feb 2021 02:04:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613264660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FJMm0TRPOG22B8E/tzkrq9/2Gb1T8Z9gAJPYZb2fb+M=;
        b=X4YN3yfs65Vo0/QtioRoLaz38je6j7WymzrnAG8Ah3KAio0FGTZur/x2QL5XhIepWbDeZk
        g2DL2MfMZeg4wEGvQHQI8Y3GPqrO6AZ+NAVE+kr11T8LEXq6uPRisU3XAesI6QmLHTYaFV
        tNIf4OWXPWM2DY5tqZSsqgqXsPrbYy0=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 0/2] net: phy: at803x: paging support
Date:   Sun, 14 Feb 2021 02:04:03 +0100
Message-Id: <20210214010405.32019-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add paging support to the QCA AR8031/33 PHY. This will be needed if we
add support for the .config_inband_aneg callback, see series [1]. But it
also turns out, that the driver already accessed the fiber page all along
without proper locking. Patch 2 will fix that.

[1] https://lore.kernel.org/netdev/20210212172341.3489046-1-olteanv@gmail.com/

Michael Walle (2):
  net: phy: at803x: add pages support to AR8031/33
  net: phy: at803x: use proper locking in at803x_aneg_done()

 drivers/net/phy/at803x.c | 72 ++++++++++++++++++++++++++++------------
 1 file changed, 51 insertions(+), 21 deletions(-)

-- 
2.20.1

