Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0F93E2C12
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 16:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhHFOFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 10:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbhHFOFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 10:05:54 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0EC0613CF;
        Fri,  6 Aug 2021 07:05:38 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id x7so529549ljn.10;
        Fri, 06 Aug 2021 07:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hus37unWQtifpvoADvykgqUYzzDBdjAzOWr44VKS+/8=;
        b=PLLmjZAkW67pCRxQVGMe74qVbgssttujHRRU85qn0wNlwQl0aQJKml8Tuu1zDo3xd2
         OvxMP2apgteuHaZ6q0tb3ZlfPL6S8RoMYWF6hQbD5j01MicmZm4SYOPaUK4Fib44bc2G
         3nVN3yj3+uV9axed28hMcymV/+ySWvNqKEKGiWPks7zGOn58Co9gqv35iIEYLVbNib/M
         eWb9WooNyv+Aw453WQM/64t9lR0TwOJCDWmxIPQ4h19bdANLx0fKmYcsszOcc8meXLau
         hP6g8h7of7GyMer6qGNUiEBOybd53KUTxccYUyWFhVNgtdNdGhV5sHfBE369CM1H7Ddn
         dzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hus37unWQtifpvoADvykgqUYzzDBdjAzOWr44VKS+/8=;
        b=WaVH/XO2XeYiq7gk8QSnvqCyiGOLnPrzaNtFXxlLjTk5H/7XsVaAUaqGB8v9YDsAvM
         pt2NYahacQic5aWodDfZtySjgPogJsn4TCHC2wqdHBi1qQ5lm/gqCpGjYZKEAFpAilVy
         O/s2tMfdBCHk/16gAdTpWMTDHUD8WMXOjCwPTbFgaUPw9vteRZBzDmIaGOMVlHJhxO5+
         9HyDTT4IGSUd4YUOxp2GPNpujJb/yGtys0J5rXbfVK2p4L/SeMDq3ZLiKvis4r0+NT+v
         BMY0u32L8IO3mBx/E50peedd0mMwTk/Xx4oIyP1k3Nh6S5YQVdg5MHB6n+2KHaG5K6c8
         l0IQ==
X-Gm-Message-State: AOAM5334vu7Azs7RcU3g4SctUklGz43hKANjQWkdFHi928m6sYcVA+Yt
        0Z9/mMlt6W3CavgoxGXOkig=
X-Google-Smtp-Source: ABdhPJySzgwhbHlP1vQ/DOqDLDD2IUNZXSmOLLrYQG82+xqgSmfdmTD0Xe9CD/Y3SQkret30elHpww==
X-Received: by 2002:a2e:3c0d:: with SMTP id j13mr6692126lja.414.1628258736439;
        Fri, 06 Aug 2021 07:05:36 -0700 (PDT)
Received: from localhost.localdomain ([185.6.236.169])
        by smtp.googlemail.com with ESMTPSA id o1sm848020lfl.67.2021.08.06.07.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 07:05:36 -0700 (PDT)
From:   Maksim <bigunclemax@gmail.com>
Cc:     Maksim <bigunclemax@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: marvell: fix MVNETA_TX_IN_PRGRS bit number
Date:   Fri,  6 Aug 2021 17:04:37 +0300
Message-Id: <20210806140437.4016159-1-bigunclemax@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Armada XP datasheet bit at 0 position is corresponding for
TxInProg indication.

Signed-off-by: Maksim <bigunclemax@gmail.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 76a7777c746da..de32e5b49053b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -105,7 +105,7 @@
 #define	MVNETA_VLAN_PRIO_TO_RXQ			 0x2440
 #define      MVNETA_VLAN_PRIO_RXQ_MAP(prio, rxq) ((rxq) << ((prio) * 3))
 #define MVNETA_PORT_STATUS                       0x2444
-#define      MVNETA_TX_IN_PRGRS                  BIT(1)
+#define      MVNETA_TX_IN_PRGRS                  BIT(0)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
 /* Only exists on Armada XP and Armada 370 */
-- 
2.30.2

