Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B6671A28
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjARLM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjARLMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:12:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D85F9AAB5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 02:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CnsqxMttzIum7fcRqp6WOF2aEfEW/zPNxzk1E7P73VE=; b=rAdF6/DQr2HgEMO67wasDbskqm
        bOEaKeKZYrYuFLUMnzWrxofc0zvdFo0EWU5qj0NxRAw3K5FYS3pvEsnjqgdcnY/yNScvBpjq3EdwY
        Tfx5lP+rz2OD1eMkwH911TkE7xCn2KQnCVxM/g0kv43cGhb3EU0wxi5GR/e8iUXlzo/8600uo/f1v
        S7YdL4lSL1URAGNGQFwElakVA443Q7KwLaU6N4UTKTDeTpr0fUma911m9yjmyqweWLiKrHhFOFSAS
        WzsMt5q/xoxVNywHlJqW5EGorfmVUafaSEh2IwwgqRJDw0phyWvVRZfvGpzKEsIEiI3mEtLCaFsGC
        SqlgnERw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60660 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pI5ZC-0001QC-Bn; Wed, 18 Jan 2023 10:21:14 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pI5ZB-006Goa-E3; Wed, 18 Jan 2023 10:21:13 +0000
In-Reply-To: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
References: <Y8fH+Vqx6huYQFDU@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 4/5] net: sfp: remove acpi.h include
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pI5ZB-006Goa-E3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 18 Jan 2023 10:21:13 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing in the sfp code now references anything from the ACPI header,
everything is done via fwnode APIs, so get rid of this header.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 64dfc5f1ea7b..99cd2b538126 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1,5 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/acpi.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
 #include <linux/delay.h>
-- 
2.30.2

