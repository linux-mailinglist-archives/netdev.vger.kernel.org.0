Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFFB43678F
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 18:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhJUQZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 12:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhJUQZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 12:25:17 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B1CC061764
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so916500pjb.4
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 09:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dfltF+KdoBWysgdk4AaWUKJJEeefM25wtANwmdckgLY=;
        b=AhK+IgPxuQhOXvjxETC0QY2cGZD5UMQ7Z98eme3opfGqFbrINxhN+WHRsYdwJxq4v9
         XPCB2D7LQtWn92KIgwa3474oAhgvbTzSAJS7fmI/UL5ovZKzyh+r4w5gxHQ5Jxg8gGUb
         gpe6MWlFC1RKspM6RHGc1K7G19sNfh3ejfsuCHjS+Wj6KNVvcCVUjCmUQWRUAzw012gO
         NJlRR5MEh3Nr02WBgLkIVPIE4OuDnP0kIy5CChH/sLH32L6qZ2pCZ2MgwB9oA1SmeJXC
         sUggL/RFtOi/c4h8I4jPJYArjBB1E0C2fIOQRU+nXCASE2Tdz4XtemSsun9VWxunr0SS
         ypbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dfltF+KdoBWysgdk4AaWUKJJEeefM25wtANwmdckgLY=;
        b=CPAmhFP+fJdVbzIXw5+RZjPi2UJ3c/EeyWtP5Sy3KpwtIaC6rhDJQ+NyJZoNCI925q
         Q4vl2lWrJUl0vn9J7Xp6giSLMMLinF+U9HF+zCd9U3k17csPwd6W42yG35zCJSQ4OEyr
         vaYkRsirwSibjk/xC6xNHsOnUoM2fgwdPKW3q4hiaHpNqdFll3n5bTdFxEUDD0pIZ5a/
         tAkgNh1e7VmSsegrJq1cPUvEvGNx3G+rOxVwYyFYTGfWGv+/b3T2HQezoqRvuMPCsfnX
         O4GP/nc0gQLxeq7QFYCew6r+pQ3kAFV8BX8Y2cJmcRY7WwlrD4KfrNU77YRI9SHKy0hs
         6rIQ==
X-Gm-Message-State: AOAM532LH3n9w1X/zo7kW3oU9lFD3QnpD9IPQO4zHYVB8J1JCbD6Yskx
        Tzx+ZkMb/IwF6g1Ib5Jtx98=
X-Google-Smtp-Source: ABdhPJzQnXLLGjcAU6aEYoAAPeRXKDyVb1dz4c5Dq4bbMendHFU0MLvIlSLBwA2hQ3Kj51VlCjPe/g==
X-Received: by 2002:a17:90b:4c11:: with SMTP id na17mr7882895pjb.105.1634833380760;
        Thu, 21 Oct 2021 09:23:00 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c17a:20ce:f4d9:d04c])
        by smtp.gmail.com with ESMTPSA id n22sm6719291pfo.15.2021.10.21.09.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 09:23:00 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 1/2] net: sched: fix logic error in qdisc_run_begin()
Date:   Thu, 21 Oct 2021 09:22:43 -0700
Message-Id: <20211021162253.333616-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211021162253.333616-1-eric.dumazet@gmail.com>
References: <20211021162253.333616-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

For non TCQ_F_NOLOCK qdisc, qdisc_run_begin() tries to set
__QDISC_STATE_RUNNING and should return true if the bit was not set.

test_and_set_bit() returns old bit value, therefore we need to invert.

Fixes: 29cbcd858283 ("net: sched: Remove Qdisc::running sequence counter")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/net/sch_generic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index baad2ab4d971cd3fdc8d59acdd72d39fa6230370..e0988c56dd8fd7aa3dff6bd971da3c81f1a20626 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -217,7 +217,7 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		 */
 		return spin_trylock(&qdisc->seqlock);
 	}
-	return test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
+	return !test_and_set_bit(__QDISC_STATE_RUNNING, &qdisc->state);
 }
 
 static inline void qdisc_run_end(struct Qdisc *qdisc)
-- 
2.33.0.1079.g6e70778dc9-goog

