Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725F33F5867
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 08:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhHXGpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 02:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhHXGpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 02:45:09 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACEDC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 23:44:25 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v123so2763495pfb.11
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 23:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=F+iP6sdhDu7M9+Lwp23Im3s5iE2JstLP0U7/CVbXU6A=;
        b=KA4CLqVpW8ZC/aaX8B5ognYyOUXOrhYJzwBQq8MlVvTvDijDE9qJ03wK5sZgqIsvz8
         2DeslHCC1fu+34QjZ+EOj/ZSE/KzM2I72Jsx5+PJjR9hVpPwnX0V+dxxBOfowJPS8DjP
         7bQ+J8e1bwsrCKAzqtvSVhuNKcpVwME9gePQFk+/4u4FfAy0LQKtDai66+nvecGqpoYl
         9I1jKTDj7Ff68M51XhbPQYztl902oWF07jkHkIfNn/yaPmyhjTTib0EnaHVf4aWVL6nm
         Fd8bhtQb9zhyMoGMgGSxHy77h9b8SRyvZjX9WPkqvJY30pcy40YZqJkiZM3y5JBf6GtK
         2eBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=F+iP6sdhDu7M9+Lwp23Im3s5iE2JstLP0U7/CVbXU6A=;
        b=CVmtT0v36ebzwsa+yjAFbt7vM1sUmaTkcRdslOiFv4zX1vi0WEV/f3Gfo2NTe5jDYB
         fTZJ7HG+fmC2CJMvMk9g7MMWgqqA6JCh5+4jRixry08LvFXVrCeFoWype8iUIzeSCNft
         EWJ52N7pmPtUEp4FJGQ+sM7lSIDE4ad3wIaDdt2GImD/UDthyGN0Wj8QcH+zx2LIzOqA
         e8xg0ZRLOS4pur4mRPVnPudQvwX3EqCW6t9DsbjxfuTC5028vLRqekPpFTWpRwl1tR8A
         J1d+Pfh/djm4tf8NfuuAoIqmHAIitl/RXUnj6oesmmJ2AXfIfyJhk8C9cb9u4H/4QvzG
         Nfbg==
X-Gm-Message-State: AOAM530TmhGkq98wBBRzqUrDoefSPQMSdPIGzDmoSgMO+hKI9Kpj8tWU
        zDl42YoM+BsIDIY3PV4X/wMn2BRSUP+1Ha7JCYU=
X-Google-Smtp-Source: ABdhPJz7pBk27cD0Q0YPvSKufaE4bmrLxOnn3pN3fTLFmSYEni3FZ0Py7vfoTRRML7qtS4PRh3NDHw==
X-Received: by 2002:a63:cc0e:: with SMTP id x14mr35812903pgf.352.1629787464956;
        Mon, 23 Aug 2021 23:44:24 -0700 (PDT)
Received: from [127.0.1.1] (117-20-69-24.751445.bne.nbn.aussiebb.net. [117.20.69.24])
        by smtp.gmail.com with UTF8SMTPSA id u17sm17553370pfh.184.2021.08.23.23.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 23:44:24 -0700 (PDT)
Date:   Tue, 24 Aug 2021 06:44:13 +0000
Message-Id: <20210824064413.95675-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: dsa: mv88e6xxx: Update mv88e6393x serdes errata
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

In early erratas this issue only covered port 0 when changing from
[x]MII (rev A 3.6). In subsequent errata versions this errata changed to
cover the additional "Hardware reset in CPU managed mode" condition, and
removed the note specifying that it only applied to port 0.

In designs where the device is configured with CPU managed mode
(CPU_MGD), on reset all SERDES ports (p0, p9, p10) have a stuck power
down bit and require this initial power up procedure. As such apply this
errata to all three SERDES ports of the mv88e6393x.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index b1d46dd8ea..6ea0036787 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -1277,15 +1277,16 @@ static int mv88e6393x_serdes_port_errata(struct mv88e6xxx_chip *chip, int lane)
 	int err;
 
 	/* mv88e6393x family errata 4.6:
-	 * Cannot clear PwrDn bit on SERDES on port 0 if device is configured
-	 * CPU_MGD mode or P0_mode is configured for [x]MII.
-	 * Workaround: Set Port0 SERDES register 4.F002 bit 5=0 and bit 15=1.
+	 * Cannot clear PwrDn bit on SERDES if device is configured CPU_MGD
+	 * mode or P0_mode is configured for [x]MII.
+	 * Workaround: Set SERDES register 4.F002 bit 5=0 and bit 15=1.
 	 *
 	 * It seems that after this workaround the SERDES is automatically
 	 * powered up (the bit is cleared), so power it down.
 	 */
-	if (lane == MV88E6393X_PORT0_LANE) {
-		err = mv88e6390_serdes_read(chip, MV88E6393X_PORT0_LANE,
+	if (lane == MV88E6393X_PORT0_LANE || lane == MV88E6393X_PORT9_LANE ||
+	    lane == MV88E6393X_PORT10_LANE) {
+		err = mv88e6390_serdes_read(chip, lane,
 					    MDIO_MMD_PHYXS,
 					    MV88E6393X_SERDES_POC, &reg);
 		if (err)
---
2.33.0
