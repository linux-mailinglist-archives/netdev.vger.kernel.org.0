Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036F84CE484
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbiCELWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiCELWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:22:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D5D4C784
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:22:03 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646479321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2UoMgbNDevdyl3a6+qnDk62Bo1C7w3xgkxYhUbYd3Sc=;
        b=w1SH4Bw2Ok+Ft5/0RPEhyt3dRhDRAwyJ8hj6vcF+SFLu2I7oo9o5jM0WCknDT1HrQYRX5C
        fFTQEsI0cyoaWHXm/7B9AK2XB0gDwfTTCrLH9cnNsz5ER5UkKucA0U7nuM0Kv1UIXRWrJ3
        4zQcZlcXzYOeai5zA+gApX3Yg8avhImKU7FleHd35AfPdwb614OwC8PGMW6sW4XVUzn1EO
        Se5qKjaOBswiSitRRSQ7ZPcF1F26IkwvXU2eLeyvny0pCgyq/K/cZL975WBx66tCW6iyOU
        plJdhiZA5awlmzuDPGfRwFrHhPXjrV55Rd3TZGUGKhddhM3BD2RuMSSq5BfD3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646479321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2UoMgbNDevdyl3a6+qnDk62Bo1C7w3xgkxYhUbYd3Sc=;
        b=H8oij7JE6WcAPv3qy7SKyBeRkM/SbhG7toCKzcQ91U+SwlGTVE8ZprSKzBaA5oJdqzdXsl
        Yej/zbKihGXwuhAw==
To:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 0/3] ptp: Add generic is_sync() function
Date:   Sat,  5 Mar 2022 12:21:24 +0100
Message-Id: <20220305112127.68529-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

as multiple PHY drivers such as micrel or TI dp83640 need to inspect whether a
given skb represents a PTP Sync message, provide a generic function for it. This
avoids code duplication and can be reused by future PHY IEEE 1588 implementations.

Thanks,
Kurt

Kurt Kanzenbach (3):
  ptp: Add generic PTP is_sync() function
  dp83640: Use generic ptp_msg_is_sync() function
  micrel: Use generic ptp_msg_is_sync() function

 drivers/net/phy/dp83640.c    | 13 +------------
 drivers/net/phy/micrel.c     | 13 +------------
 include/linux/ptp_classify.h | 15 +++++++++++++++
 net/core/ptp_classifier.c    | 12 ++++++++++++
 4 files changed, 29 insertions(+), 24 deletions(-)

-- 
2.30.2

