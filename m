Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1421631EF8C
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234173AbhBRTRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhBRSxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 13:53:32 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3496C06178A;
        Thu, 18 Feb 2021 10:52:51 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9788B2223A;
        Thu, 18 Feb 2021 19:52:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613674370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1ENiqWVoqb7QdBU1FVAbF6cbtRZBQv5DFP4QtNFwGKs=;
        b=EJG4+rjGtSxuX6jhjWYbDVKxafQjQCMkpVJfAd7eVSGvOj8kXQ0R72xZ5NqzNMXn+INH/F
        kBQSLvB4EwFTPzWkjDMm5RFGFteio5gpayK8wHrdgYaVmJfiZuFIjhR6W4JrBcL7eZvOEp
        5t3VMxmV7kOjwsEjkQuupMP1clmidkQ=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 0/2] net: phy: at803x: paging support
Date:   Thu, 18 Feb 2021 19:52:38 +0100
Message-Id: <20210218185240.23615-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add paging support to the QCA AR8031/33 PHY. This will be needed if we
add support for the .config_inband_aneg callback, see series [1].

The driver itself already accesses the fiber page (without proper locking).
The former version of this patchset converted the access to
phy_read_paged(), but Vladimir Oltean mentioned that it is dead code.
Therefore, the second patch will just remove it.

changes since v1:
 - second patch will remove at803x_aneg_done() altogether

Michael Walle (2):
  net: phy: at803x: add pages support to AR8031/33
  net: phy: at803x: remove at803x_aneg_done()

 drivers/net/phy/at803x.c | 66 +++++++++++++++++++++-------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

-- 
2.20.1

