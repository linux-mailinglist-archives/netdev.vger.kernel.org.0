Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398C3402870
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbhIGMTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:19:45 -0400
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:33452
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344099AbhIGMTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 08:19:31 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0C11B4079B
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631017105;
        bh=ygx+SrZOuhDRvL55hE9xxzLOd3db853TUebx3pnrgoQ=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=qR2mBzHAg4xNvGGzKLIBF7SEUJ5NOhEoyl3qE0updZ3W8SzdP48mLxO/jtC2D6+Ay
         SlIrRbexGDB5fO5v0Irf2kCxkRlP6PrIRsqf/czAGGA5ggJI3QSQrSa29sQa70jGJE
         LkhT8qhYTYwebXC+Z+Cw1XldYql3OUC0haqxWqNbWdn5Ux8V7H80BaWHTutEBxOcmH
         FKPzYC9NZ0tr5H35mcaFQ9UQcVbC/lV5hocLWILedAlyNPTj7tD1Wm2yAiXxoVNn62
         ydTd+DHR7N0dCHNumCgVxvVp+jkvUet9RLHHJXV6JcOG1H6p+1bnRfYiO6GzugWnFs
         jQWjetbI+6vow==
Received: by mail-wm1-f70.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so1112983wml.5
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 05:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ygx+SrZOuhDRvL55hE9xxzLOd3db853TUebx3pnrgoQ=;
        b=X6Zxe0p/ajMhMGm0j5kivhLQkTH5Azh85IKKae2l2k+dEqOqY2/T7nLbW105J0w8cl
         ib8Cu6Y304JypU61WGI9JKB9DyPmddIPhko6Rc3SvDOFHZgSimq2ArvbWpAV9O/aFS+R
         ND32FWVxOqkShXpK1C75tlnZteRsfDbgQRSrTvcfcsXlwEGtIHmFTYhVUDQBbY2TVSwD
         RFG4YdB2TyOnDhY3BuGJ9kBdS0EzcjrQRiD/dYop7ahHXvuwiuDdLzZQ/tHGTQAxDysj
         UtEQ4QU45rH4zFEiEqYmQA2rEOyWvNDToxxsWgCZ7vY5F53NmJcGwraRj3CAHI0ZoOhl
         FI2A==
X-Gm-Message-State: AOAM5329IWHxQosaRQZeIHZ4Kx9dzpvY8YpU1Roq0cC7NUM83/P+Pi5X
        j6OdW/cYBXXaw6IEBxYPBqIPU3thkiEpQOg3tXxIKx5Y7V+06/wjnNoUEasxKt0JtMRHBEUSErs
        jIqTqqwj0LCU6ZOx5J+DiGwjuKFggepLOXg==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr3576590wml.127.1631017104502;
        Tue, 07 Sep 2021 05:18:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyB9lpSYRjC+nwBj78YNN3ZDlBL5vpXCZ8sbbrL5Cjob2y7j5eoJJP5w2OFbtm4kDLZhWgyyA==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr3576575wml.127.1631017104347;
        Tue, 07 Sep 2021 05:18:24 -0700 (PDT)
Received: from kozik-lap.lan ([79.98.113.47])
        by smtp.gmail.com with ESMTPSA id m3sm13525216wrg.45.2021.09.07.05.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 05:18:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH 02/15] nfc: do not break pr_debug() call into separate lines
Date:   Tue,  7 Sep 2021 14:18:03 +0200
Message-Id: <20210907121816.37750-3-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
References: <20210907121816.37750-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unneeded line break between pr_debug and arguments.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 net/nfc/hci/llc_shdlc.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 78b2ceb8ae6e..e90f70385813 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -201,8 +201,7 @@ static void llc_shdlc_reset_t2(struct llc_shdlc *shdlc, int y_nr)
 			del_timer_sync(&shdlc->t2_timer);
 			shdlc->t2_active = false;
 
-			pr_debug
-			    ("All sent frames acked. Stopped T2(retransmit)\n");
+			pr_debug("All sent frames acked. Stopped T2(retransmit)\n");
 		}
 	} else {
 		skb = skb_peek(&shdlc->ack_pending_q);
@@ -211,8 +210,7 @@ static void llc_shdlc_reset_t2(struct llc_shdlc *shdlc, int y_nr)
 			  msecs_to_jiffies(SHDLC_T2_VALUE_MS));
 		shdlc->t2_active = true;
 
-		pr_debug
-		    ("Start T2(retransmit) for remaining unacked sent frames\n");
+		pr_debug("Start T2(retransmit) for remaining unacked sent frames\n");
 	}
 }
 
@@ -518,12 +516,11 @@ static void llc_shdlc_handle_send_queue(struct llc_shdlc *shdlc)
 	unsigned long time_sent;
 
 	if (shdlc->send_q.qlen)
-		pr_debug
-		    ("sendQlen=%d ns=%d dnr=%d rnr=%s w_room=%d unackQlen=%d\n",
-		     shdlc->send_q.qlen, shdlc->ns, shdlc->dnr,
-		     shdlc->rnr == false ? "false" : "true",
-		     shdlc->w - llc_shdlc_w_used(shdlc->ns, shdlc->dnr),
-		     shdlc->ack_pending_q.qlen);
+		pr_debug("sendQlen=%d ns=%d dnr=%d rnr=%s w_room=%d unackQlen=%d\n",
+			 shdlc->send_q.qlen, shdlc->ns, shdlc->dnr,
+			 shdlc->rnr == false ? "false" : "true",
+			 shdlc->w - llc_shdlc_w_used(shdlc->ns, shdlc->dnr),
+			 shdlc->ack_pending_q.qlen);
 
 	while (shdlc->send_q.qlen && shdlc->ack_pending_q.qlen < shdlc->w &&
 	       (shdlc->rnr == false)) {
@@ -641,8 +638,7 @@ static void llc_shdlc_sm_work(struct work_struct *work)
 		llc_shdlc_handle_send_queue(shdlc);
 
 		if (shdlc->t1_active && timer_pending(&shdlc->t1_timer) == 0) {
-			pr_debug
-			    ("Handle T1(send ack) elapsed (T1 now inactive)\n");
+			pr_debug("Handle T1(send ack) elapsed (T1 now inactive)\n");
 
 			shdlc->t1_active = false;
 			r = llc_shdlc_send_s_frame(shdlc, S_FRAME_RR,
@@ -652,8 +648,7 @@ static void llc_shdlc_sm_work(struct work_struct *work)
 		}
 
 		if (shdlc->t2_active && timer_pending(&shdlc->t2_timer) == 0) {
-			pr_debug
-			    ("Handle T2(retransmit) elapsed (T2 inactive)\n");
+			pr_debug("Handle T2(retransmit) elapsed (T2 inactive)\n");
 
 			shdlc->t2_active = false;
 
-- 
2.30.2

