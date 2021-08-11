Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D73E9945
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhHKT5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbhHKT5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 15:57:43 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D3CC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 12:57:20 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id hv22-20020a17090ae416b0290178c579e424so6880601pjb.3
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 12:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3PUqru7QB3ITpwD62+CfFQeRlGCpIZEbODiCPjFfr48=;
        b=krcFoC/jdd9ch0JgFl1o2hM2QL8HPoGVkUa+O3Nu/37AP0RN0NU6/Tiysxih5f1HSS
         RTn8ZnhRNl25eHLFzTHeR/dRw0bWsE2HSdWIq2BgiP4teZ4iwlA/RUsn9e1KUHlmxi+Y
         VD6WTcxzJ/VJwEpac5lnTUoTYdbiZzvlh8vz9xop9XTnuEL4ihSbhibgoHK4mDce3+ih
         JHNOu0VF+YqPKwthTEeQaYXXstSCofFn4mnnpMDuUzQsUKRD9BcRP9+MAaGJp0fGz/IA
         PlXrZ5LIItyofTmLqBoXavjTyqQ0HVHH4RagKp/qAUmeZWm8kOoJvyBZllGUXao6kbV/
         DvZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3PUqru7QB3ITpwD62+CfFQeRlGCpIZEbODiCPjFfr48=;
        b=WZVI4jJoz1c3+Jnwgs4LHlIsUwv3Iit1MFtAivcipgsZ9UgXEPd6keURdyc3RpXrHJ
         lVptT4Lu1rahHShZvdrWbczmsmWj4vjWwE1I2H6JMLZxkbQXEcQj3tcUH+7CjqI+aFYF
         HEICi0u/EayaQ2uH4XR+cLovlulQctYjBJaSRVUXrCVQGlIcD/q4UoTcdkuB5q0HtR6B
         uVr/NdR8fntPUt4KlsgBd1+c6Nzt7599qOYC255d+XsAQHkb7oxEtAB2Rq64GrgQFyjK
         c6IvlIPEQW2V2K1JqlaBpkB2oZzk7mT3Dw5EQZTd2gCembqD1ThwSYLG04D3GLeA6lnW
         hU/g==
X-Gm-Message-State: AOAM533BGpgvtRRb9uJp4Cdr1xDQ3N/RTJ0EhxBmO3OoT3QE9Bf/I4o6
        MzzmaXQnIkbGVTJCjpx/Ri4=
X-Google-Smtp-Source: ABdhPJwT3DEjGLtBvRptU+3UoolTqkPEvW5GfTUMAjFPDUR2l8EXLms+rFNaTpXznoctFU0pD0Vzdg==
X-Received: by 2002:a63:120e:: with SMTP id h14mr354613pgl.215.1628711839642;
        Wed, 11 Aug 2021 12:57:19 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ea40:b827:b832:9f31])
        by smtp.gmail.com with ESMTPSA id 141sm394324pfv.15.2021.08.11.12.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:57:19 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH net] net: igmp: increase size of mr_ifc_count
Date:   Wed, 11 Aug 2021 12:57:15 -0700
Message-Id: <20210811195715.3684218-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Some arches support cmpxchg() on 4-byte and 8-byte only.
Increase mr_ifc_count width to 32bit to fix this problem.

Fixes: 4a2b285e7e10 ("net: igmp: fix data-race in igmp_ifc_timer_expire()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
---
 include/linux/inetdevice.h | 2 +-
 net/ipv4/igmp.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 53aa0343bf694cb817e00ff597b52ce046e29d2c..aaf4f1b4c277c4ad38e1f0742bb480d3bb003287 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -41,7 +41,7 @@ struct in_device {
 	unsigned long		mr_qri;		/* Query Response Interval */
 	unsigned char		mr_qrv;		/* Query Robustness Variable */
 	unsigned char		mr_gq_running;
-	unsigned char		mr_ifc_count;
+	u32			mr_ifc_count;
 	struct timer_list	mr_gq_timer;	/* general query timer */
 	struct timer_list	mr_ifc_timer;	/* interface change timer */
 
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index a51360087b19845a28408c827032e08dabf99838..00576bae183d30518e376ad3846d4fe6025aaea7 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -803,7 +803,7 @@ static void igmp_gq_timer_expire(struct timer_list *t)
 static void igmp_ifc_timer_expire(struct timer_list *t)
 {
 	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
-	u8 mr_ifc_count;
+	u32 mr_ifc_count;
 
 	igmpv3_send_cr(in_dev);
 restart:
-- 
2.32.0.605.g8dce9f2422-goog

