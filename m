Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302F914E084
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 19:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgA3SHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 13:07:21 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43449 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727499AbgA3SHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 13:07:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id u131so2036735pgc.10
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 10:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=1S6CV21lOaRLXKoyd1LR/Pkc/8et3fMNM0VtMjTfn6M=;
        b=UouOqD1syYK47KQtn+XO1FJ79QN1QcJ3J3AfYp8cXI2bV2n4Ucqv39OClnT/9fa2bh
         K+ENbiAOtYDkIzzwiNRPLS6Awvk0RPXo0kDzhE9Rp3+vywssJeWk9OV/kiMf6k1JxvAd
         UDAFkuWjxABBv2oRKQNfjpPHaSkE2Oiink8LiukKyYYTHJtAaR7fmKSHj8ybXXUpGfQf
         T7ibqk0B6iHBcKkJqwm0daeJsvTV79xyqgPGDTXHIhfAyMeioXSy1kJ7Xfoxo9c5tIbN
         wBwOyXwoq57aNWchirv/nBLXBqYKrFbbJa+0ShcYso+QEwvcu36kSEtT60wUPVfgaULg
         uiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1S6CV21lOaRLXKoyd1LR/Pkc/8et3fMNM0VtMjTfn6M=;
        b=hNE4oJYoKcP7hVslfbCnQ2n17ohjUSavIPlzAJIGZDwB8GuuNJoAFcB/1CM+AKJZoS
         OFscC6tAPDczktDjIG3y+tWtt/1DACRCoD9oseDUUV5lEhc+1Iju9nIA/ex/NXi6kxeZ
         SKE6Vewn4OP2wZX4BK/tY88ZKr+BXWkHjrDYKJqLxrMVKgtXJl2NGauou7SGsBh4ZA8m
         9u309kSoyoKFAQuskjIaSLvZkP+90OCVr0gSoZHKahTuIu9OEQ1ctB52zcCp4S68oP+P
         720tTc8WMAQ+Yj9sFANIMnu41mKhlSFS1oRygapDf5RoC1EyEyLO8cCneLN3+ClYumFp
         7/OA==
X-Gm-Message-State: APjAAAUXXZWVriqa/P4FUY2eqLyza34nJgkkThIhWxO3niPc+IAkkzpq
        0LrZ9vW/oWmNFxBHumI7R6rJEDWtnew7qw==
X-Google-Smtp-Source: APXvYqxjsekRxIFlHLq2YzWsNODPvzqcBrXm5D/OhHOPFaVMaTBRuUC8qtLr+zGelR3P9bc0+JyiWQ==
X-Received: by 2002:a63:3f4f:: with SMTP id m76mr5682695pga.353.1580407640415;
        Thu, 30 Jan 2020 10:07:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id g10sm7107094pgh.35.2020.01.30.10.07.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:07:19 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix rxq comp packet type mask
Date:   Thu, 30 Jan 2020 10:07:06 -0800
Message-Id: <20200130180706.4891-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Be sure to include all the packet type bits in the mask.

Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index f131adad96e3..ce07c2931a72 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -866,7 +866,7 @@ struct ionic_rxq_comp {
 #define IONIC_RXQ_COMP_CSUM_F_VLAN	0x40
 #define IONIC_RXQ_COMP_CSUM_F_CALC	0x80
 	u8     pkt_type_color;
-#define IONIC_RXQ_COMP_PKT_TYPE_MASK	0x0f
+#define IONIC_RXQ_COMP_PKT_TYPE_MASK	0x7f
 };
 
 enum ionic_pkt_type {
-- 
2.17.1

