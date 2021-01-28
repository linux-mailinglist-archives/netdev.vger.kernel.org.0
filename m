Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92C4307B0E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 17:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhA1QfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 11:35:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36032 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhA1Qeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 11:34:37 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611851631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P8ixzyR91Be1yG8uiE1awFzihSb2ZydJiJadRIzRs1o=;
        b=0vIUnVuACfWEkRY+AFWxRJgsvqnZGQD1d/Ndfljhs0bFgDhG55vwJotMNy/swaIGQ4CL4o
        7I4KxmljT4+zk6kA7ky7IC+9fFPblCkbpmdURmSt+vpG0mN7hwJbOHQpiUmxzxL+bc1OSB
        JXk5eDBkCoKbZng366CRnBP+8K9yACgrZF7lcas5TPwgTT9UQcFPD7IHzqdW1eF5f1fEPV
        KAoIi/Skiw1K53nZ/BYrrd1KTF5DnuqL70gwRryJZsyAJ/7XVP2LlhCS9QGLXiST3ih+TF
        3kCwZWukR+sR9jbd1G4jqurYdj3kQJnfcHb7zWwhuGFOBQuLjio7cuvofdht1Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611851631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=P8ixzyR91Be1yG8uiE1awFzihSb2ZydJiJadRIzRs1o=;
        b=REPJj6ANDwiiMov5yV0x3l/8ad83L+OM0SbeFB7Gk3wRG5TPouUJBWo7GwURft8z/1pUUd
        l2zKDmkql4ayY0Aw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO dependency
Date:   Thu, 28 Jan 2021 17:33:38 +0100
Message-Id: <20210128163338.22665-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing dependency to TAPRIO to avoid build failures such as:

|ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
|ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!

Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/Kconfig | 1 +
 1 file changed, 1 insertion(+)

Note: It's not against net, because the fixed commit is not in net tree, yet.

diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
index e01191107a4b..9ea2c643f8f8 100644
--- a/drivers/net/dsa/hirschmann/Kconfig
+++ b/drivers/net/dsa/hirschmann/Kconfig
@@ -5,6 +5,7 @@ config NET_DSA_HIRSCHMANN_HELLCREEK
 	depends on NET_DSA
 	depends on PTP_1588_CLOCK
 	depends on LEDS_CLASS
+	depends on NET_SCH_TAPRIO
 	select NET_DSA_TAG_HELLCREEK
 	help
 	  This driver adds support for Hirschmann Hellcreek TSN switches.
-- 
2.20.1

