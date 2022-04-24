Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD7250D2BA
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiDXPhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240741AbiDXPfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:35:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7379D171C01
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 08:32:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k4so10114612plk.7
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 08:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=DPNto3RCybjogKfr456o+QEcokurj06jetoOd1VBs74=;
        b=Kb28HEvQESzMvIBoLcX56XxVgEM+RnJHXrpj37528afTgp5M3XHE4/G5VHSKlDTP1a
         SYUo447iH71nX8OvnfTf28m2Hielc6+e3XygAR4dUxK3AThrSpYR8XRn25b1cSL1znrf
         1PFEQRjw1lxEWr9moRYYsItBgY69ADMrm6JN7axZ2Tdp4degAxJGGA6G39LBVcGcLvqW
         Ul+ZiA6guY7o7v13drb7yIuaZEOzpPbgc2y8aQDe+17KuEwzEUztgzKhLUPl1hT95BUw
         vNEymW4QNodpWQnSrx6tEFi9ZvWwmD4quTO3Y0TgngJPWWSdMIPCDxJrl2htOzyZMxZf
         03zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=DPNto3RCybjogKfr456o+QEcokurj06jetoOd1VBs74=;
        b=qnJjChWyi2OEH6ek1AKd7Ua24mq65KtbXneP42tVQEqyU9CQvh5vSqlQI/W6e9/2s/
         huE2vcbI3XGc+qJFHalr+yx7mdWG5ZAJT5sU79BL/oC4oeZkpTdDQ/ZW2KnIkOBQhDTZ
         ohSnwCnROUYivF+XSebWD8wBFvAOLV6tY/UHzvd4pvCphrDN750TeORuSwm6TCLhCkiQ
         DNrZN7t9c4ZoXAJi6DFnclqkRdYE8HNIr7oRveCsTHEvAh6i+eyIg5esH/ASvyc49p+n
         aCYNcG74Kqgtd9BYQ+kSEbzGb/nqVrKF14QHrGWaRFh78oqXpk9/hTPWUxNjXtBwoS0K
         OoUw==
X-Gm-Message-State: AOAM5305JHaQ4yeqcVO5S3HME6NthNLSvcrNSk+fSHHMx9bVxqTwO38L
        QKkLxLCmwoOQQNmRHhVBVCTpjw==
X-Google-Smtp-Source: ABdhPJyETDVhVTYNkCKpQXCEPpl7+sz2RmWm0F2IMHyootGSXwrP7S6fl4n0LIJfkleB3tYY+cstng==
X-Received: by 2002:a17:90a:db45:b0:1d9:29d0:4c6e with SMTP id u5-20020a17090adb4500b001d929d04c6emr9037581pjx.46.1650814320015;
        Sun, 24 Apr 2022 08:32:00 -0700 (PDT)
Received: from [127.0.1.1] (117-20-68-98.751444.bne.nbn.aussiebb.net. [117.20.68.98])
        by smtp.gmail.com with UTF8SMTPSA id u25-20020aa78399000000b00505f75651e7sm8374307pfm.158.2022.04.24.08.31.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 08:31:59 -0700 (PDT)
Date:   Sun, 24 Apr 2022 15:31:43 +0000
Message-Id: <20220424153143.323338-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Marek Behun <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2] net: dsa: mv88e6xxx: Fix port_hidden_wait to account for
 port_base_addr
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

Fixes: ea89098ef9a5 ("net: dsa: mv88x6xxx: mv88e6390 errata")
Signed-off-by: Nathan Rossi <nathan@nathanrossi.com>
---
Changes in v2:
- Add fixes
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

