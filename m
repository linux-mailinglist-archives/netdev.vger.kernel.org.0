Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C881B82E9
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 02:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDYA6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 20:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgDYA6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 20:58:20 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3E1C09B049;
        Fri, 24 Apr 2020 17:58:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h11so4376748plr.11;
        Fri, 24 Apr 2020 17:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tRhsjd8Am6Cw/B3NaPu2RtrW8z5YgI2PGow/Cf8kXxg=;
        b=dQi4hRZl5mD+QtDwbquIv6+oCtUg88rS3nzeaGjlIZWmBl4sRxXWG/ZnOUoEFsUvju
         rKBWgeSJDdK0jLS+Je9YphRfZ/m18xtzFlkxgWZnqbPzBYP3zQB/0a7ErocUGCgJbRJ/
         kSWDGn/TU9vjjh9shuX8O++DEtPnMS/OtIfhvLiVeH/OxDprR9fgNESU4KJqZtq9ZX4Q
         QWSuN0Thcfoc+9Rr3rKgw5UznPF3Us6SWHCWjIV7Fn34v/RZQTgBsFWtHpgvcUPtvAS3
         4PXj5vSX3bI6v23vgYRkY56ku2ICU4LPrsVwWbzDSCVCIQN3IzG4to7bYXCBPR9lhuak
         dddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tRhsjd8Am6Cw/B3NaPu2RtrW8z5YgI2PGow/Cf8kXxg=;
        b=N0Kkjk71kfZ2pGtZP2qQ1z5HuR7y0Q3NnWYzaFDnS8zpZWBOrAmRC5jwlxxjIGgmum
         YY4GHpPiMVikC44cwgr1KuToHFhdBkX2VEkuCj9q9xWpaMKVK0EvX06/IA87qwX/48M0
         R3GM06tmoEiF0sOS/7HSyxhqXs3TqqaftwsEI7UUqYGhPIxcrONwON6eIN7MhnmKishY
         zGJxSGwHMZyGse+eweN7w/s7vMYe8gs3W04AH2854WvMglYemP0pFWHjJjvN4NPgiSo2
         16WpHkfObMv0gMoH4M4BPA+yCQdheLaxeI0iMfCOXltpYXw5Xm1edZGElWKxH7LjUkpN
         a9+w==
X-Gm-Message-State: AGi0PuZrgllWxMlsAYO4djpXKHUwNLgDUwbZRy52kN1HXvdPWA2v5PgB
        +AOErKk6fUfd78nIxs6DF2GiARPTxQQ=
X-Google-Smtp-Source: APiQypK6CtV6IbJKErUbHv1LFjAU21iJSl48bdJnLBN/kxLqLYld/xUASo0Tmun9ng0GMqi2LlrIEg==
X-Received: by 2002:a17:902:b709:: with SMTP id d9mr11843348pls.118.1587776299555;
        Fri, 24 Apr 2020 17:58:19 -0700 (PDT)
Received: from DennisMBP.www.tendawifi.com ([122.225.224.238])
        by smtp.gmail.com with ESMTPSA id o9sm5672333pje.47.2020.04.24.17.58.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 17:58:19 -0700 (PDT)
From:   Richard Clark <richard.xnu.clark@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, xuesong.cxs@alibaba-inc.com,
        richard.xnu.clark@gmail.com, Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] Fix the media type of AQC100 ethernet controller in the driver
Date:   Sat, 25 Apr 2020 08:58:11 +0800
Message-Id: <20200425005811.13021-1-richard.xnu.clark@gmail.com>
X-Mailer: git-send-email 2.24.1 (Apple Git-126)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Aquantia AQC100 controller enables a SFP+ port, so the driver should
configure the media type as '_TYPE_FIBRE' instead of '_TYPE_TP'.

Signed-off-by: Richard Clark <richard.xnu.clark@gmail.com>
Cc: Igor Russkikh <irusskikh@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 2edf137a7030..8a70ffe1d326 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -57,7 +57,7 @@ static const struct aq_board_revision_s hw_atl_boards[] = {
 	{ AQ_DEVICE_ID_D108,	AQ_HWREV_2,	&hw_atl_ops_b0, &hw_atl_b0_caps_aqc108, },
 	{ AQ_DEVICE_ID_D109,	AQ_HWREV_2,	&hw_atl_ops_b0, &hw_atl_b0_caps_aqc109, },
 
-	{ AQ_DEVICE_ID_AQC100,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc107, },
+	{ AQ_DEVICE_ID_AQC100,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc100, },
 	{ AQ_DEVICE_ID_AQC107,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc107, },
 	{ AQ_DEVICE_ID_AQC108,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc108, },
 	{ AQ_DEVICE_ID_AQC109,	AQ_HWREV_ANY,	&hw_atl_ops_b1, &hw_atl_b0_caps_aqc109, },
-- 
2.17.1

