Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEAE1BA153
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgD0Kcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726604AbgD0Kcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 06:32:41 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22824C0610D5;
        Mon, 27 Apr 2020 03:32:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x77so8827823pfc.0;
        Mon, 27 Apr 2020 03:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9wV8t+KAUUaO16pTgyBed4eZ0237ulm/o+EEA3p/VZ8=;
        b=NvfFV3P9QENxPnI2l9UcXJtPbHzPGkZrbJ8cJrKRP68i56PxFVUdgEPp7inA8uSTla
         KlT1oN8rs6O+i7rVyOApTHfx8c0kRbFEKzlolrlv/K7vBS6lY51NuUUYwtqRmye7tD+R
         SCfrgjepue1841vdRLGL8x0BRhL6MBVvlahMTGszldUwIXmaqZnwNv9B2oOPpMeoZJmJ
         IPtnmNhpD4FGsbw+7FWs5q8fx5onLjWCvho7vfEepvfA2BkINDmxD1qOy4mZ4NvJw/Gl
         igXuoO2/7aTR8PG0T98L7j3oJt8c8wljW56wbgOd4nn0VUEQfpPJ9934p1ihf4X5pAuM
         5zqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9wV8t+KAUUaO16pTgyBed4eZ0237ulm/o+EEA3p/VZ8=;
        b=UtGDT1gwih7OflapIsoGCEDHQrTORiOXLCHdfO1AQzLekktI6bVzRXI2yCYLMxf/o3
         WtWno4hmLK66YNHMqbAGiaqB8xN8L2OOsrd3WV+ZFK93328OwGwS0UqzlHhDkqVP85IH
         ag7IEKPaVKc6lKJXFODnmUv/hS1/VvQJpyLOG93vnv+XQ3vOsAZxad0NMSHI7J3+SKsU
         SYRqLDgqbyJZfX6YcykYKD9S6SK3wJYDyCeVyfKQ55mcCUmmC7V5S4svfgfaF3hhD6yL
         njjw3CQgn03Z4MyMaiiIgucElWrGVf3wI8JDwB3uRQAk+rO/sqiIBfdF1UBaYCqLSg8R
         1cQA==
X-Gm-Message-State: AGi0PubUWJcEPDtH0XYGBACig+zz20apr6A1BFRGArm2+2rsRrj4Zh/9
        P10EdJdvFrDCfUqq/J7QPZg=
X-Google-Smtp-Source: APiQypLzBV7LgcIQDo3MSfmmD4EcCJ9MuxGEJL6bgWC248oosT9TJ7kHhen5TYtyapMlm3tL+6vLPA==
X-Received: by 2002:a63:794d:: with SMTP id u74mr22587793pgc.15.1587983560703;
        Mon, 27 Apr 2020 03:32:40 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:6004:5f2a:b425:fe6e:9d3f:4b82])
        by smtp.gmail.com with ESMTPSA id fy21sm10801438pjb.25.2020.04.27.03.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 03:32:39 -0700 (PDT)
From:   Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     aishwaryarj100@gmail.com
Subject: [PATCH] dpaa_eth: Fix comparing pointer to 0
Date:   Mon, 27 Apr 2020 16:02:30 +0530
Message-Id: <20200427103230.4776-1-aishwaryarj100@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:
./drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2110:30-31:
WARNING comparing pointer to 0

Avoid pointer type value compared to 0.

Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2cd1f8efdfa3..c4416a5f8816 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2107,7 +2107,7 @@ static int dpaa_a050385_wa(struct net_device *net_dev, struct sk_buff **s)
 
 	/* Workaround for DPAA_A050385 requires data start to be aligned */
 	start = PTR_ALIGN(new_skb->data, DPAA_A050385_ALIGN);
-	if (start - new_skb->data != 0)
+	if (start - new_skb->data)
 		skb_reserve(new_skb, start - new_skb->data);
 
 	skb_put(new_skb, skb->len);
-- 
2.17.1

