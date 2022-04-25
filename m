Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4E950D9D9
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 09:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbiDYHIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 03:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiDYHIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 03:08:20 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325811CB21
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:05:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k4so13386128plk.7
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 00:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=G5sRPyebMiaK+CkKH2Wzg8i7aV0+QrCrVRBT1qhOcaI=;
        b=gvarVsivP2TPPQp1s7mNr2WOCLQsBnv0xBRbTwG1WzVGyS2y+du/JKIx4sCrfuF4YH
         PcNQiL2hI5ki5NBdy6HX2xYCg/SdnJEmfFN7kZsSczLSlHVIo+FCghmgvG7x52O+cQCz
         IQwEqKTvi9oIqxeY9IHsLv4LS7+tlcvvN2ZqFCwOrHCQ4T6VbnnA21aKlit+rjhnPC/z
         NrjfD3D/wejkBGy2F6myXSkBvEZu2fIcBp9d+euVI0IBw8J+e60BxVEjT7Xg7gHPzcWY
         Qcts47D+S1u0a7hwlMExteDdQ1PFjhfxhKjbaL4Zkh8gFr5MJdBS/3yICoXpDbzAm5DC
         hAFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=G5sRPyebMiaK+CkKH2Wzg8i7aV0+QrCrVRBT1qhOcaI=;
        b=Q6gLy4J9ATAjK9i2TMc542IQ2Ftl8zTE9dFQzeFjwvF2y4eoKQAtn4tf4PFYPIKY6X
         Op4D2lEBiX6ZUVWj+1hMo1SySKOwqASPphDRzYpzvj3yjeXVQdDcLVvb6j+8JMDcu3r3
         J7+UIu2YTsQKmXP/46rvUpHVTN2tzps5vlqyZA4BkHjxA5UBYqhqbEe6D5f7GmRhkP9I
         S6KWhvtltAzmX5+D6CtuK7SgIEq04uiN7+hEwBX9iJJzuFucCuqXyQDKt7SKd68wTuAS
         v3Ht3fb1CnBV02+2vHXDxpiuJk+he0Nqgh2RQ9qQ/HZh24tLDhQKI/qyS3zD8BjiqAID
         VALQ==
X-Gm-Message-State: AOAM533L2p6Xb93Blg6MHoyMBe/Ehnmc+exFSt7Bsh7Bvtuxeaa1c5A4
        ewNbQCC0fM3MmRYO2Gst+Wl7KA==
X-Google-Smtp-Source: ABdhPJz9XaphssmX1kc6CKUT43yG5iztoWC0yHVEvD8x5O7s98+J22lh+ZUuA8TgUolp2Zds6H+MIg==
X-Received: by 2002:a17:902:8f86:b0:15b:4dfa:ba7b with SMTP id z6-20020a1709028f8600b0015b4dfaba7bmr16605446plo.43.1650870316700;
        Mon, 25 Apr 2022 00:05:16 -0700 (PDT)
Received: from [127.0.1.1] (117-20-68-98.751444.bne.nbn.aussiebb.net. [117.20.68.98])
        by smtp.gmail.com with UTF8SMTPSA id k15-20020a63ab4f000000b00381eef69bfbsm8685165pgp.3.2022.04.25.00.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 00:05:16 -0700 (PDT)
Date:   Mon, 25 Apr 2022 07:04:54 +0000
Message-Id: <20220425070454.348584-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marek =?utf-8?q?Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v3] net: dsa: mv88e6xxx: Fix port_hidden_wait to account for
 port_base_addr
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The other port_hidden functions rely on the port_read/port_write
functions to access the hidden control port. These functions apply the
offset for port_base_addr where applicable. Update port_hidden_wait to
use the port_wait_bit so that port_base_addr offsets are accounted for
when waiting for the busy bit to change.

Without the offset the port_hidden_wait function would timeout on
devices that have a non-zero port_base_addr (e.g. MV88E6141), however
devices that have a zero port_base_addr would operate correctly (e.g.
MV88E6390).

Fixes: 609070133aff ("net: dsa: mv88e6xxx: update code operating on hidden registers")
Signed-off-by: Nathan Rossi <nathan@nathanrossi.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
Changes in v2:
- Add Fixes
Changes in v3:
- Changed Fixes to more recent commit where the bug is present
---
 drivers/net/dsa/mv88e6xxx/port_hidden.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/port_hidden.c b/drivers/net/dsa/mv88e6xxx/port_hidden.c
index b49d05f0e1..7a9f9ff6de 100644
--- a/drivers/net/dsa/mv88e6xxx/port_hidden.c
+++ b/drivers/net/dsa/mv88e6xxx/port_hidden.c
@@ -40,8 +40,9 @@ int mv88e6xxx_port_hidden_wait(struct mv88e6xxx_chip *chip)
 {
 	int bit = __bf_shf(MV88E6XXX_PORT_RESERVED_1A_BUSY);
 
-	return mv88e6xxx_wait_bit(chip, MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
-				  MV88E6XXX_PORT_RESERVED_1A, bit, 0);
+	return mv88e6xxx_port_wait_bit(chip,
+				       MV88E6XXX_PORT_RESERVED_1A_CTRL_PORT,
+				       MV88E6XXX_PORT_RESERVED_1A, bit, 0);
 }
 
 int mv88e6xxx_port_hidden_read(struct mv88e6xxx_chip *chip, int block, int port,
---
2.35.2
