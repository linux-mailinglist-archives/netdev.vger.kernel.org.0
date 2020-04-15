Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C841AAA55
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634543AbgDOOkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S370818AbgDOOkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:40:22 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BB2C061A0E
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:22 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h25so3917820lja.10
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RO6kouuowzfuF2lpmzEcqaiqY+vQEzweKZj87S/u2/E=;
        b=pruLdR10uQo3JVc2Zd3eB+VtKMoCOlq05rp1pGDn/ssEXOd9r/0xyJtgt6+PuycT9Z
         BRdiBieS52BmvkbGf0AvOZlINn90Rm6ScNqax8jnGfjMF73rqzTTERCsuuAyaT9ulNSa
         V1kg++IhArmJc7pxi8RRNXDZSVKW0QwkPyKe7tQ8Vc/6JWDAbg8F1rvulwmy8I2I6Ai5
         UMHGjSI/hSpA0huIZHk+5ng81hMiTw7wRt9EkupTSR7IR7PSK+ji4c3wyDHU3AHqvhN6
         aLfyKexyeaaqHAQrpqQRJihl/aP2GdSEMlNAxhlJx5e77kt13D10ZN7xgkcFSDqyW72C
         ZufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RO6kouuowzfuF2lpmzEcqaiqY+vQEzweKZj87S/u2/E=;
        b=jWBJV86I6Y10qVBtWTtk2/SUOuKZx9wht/lO7N2Ak5aCHODFW2SVZS3avWGhvARK1e
         lfd54rxf82aJsRsQja3cIT7j0kBN4/JwqGi5jtujftK1wMIEP8XPxEPSxdys+JnEN/2C
         NUGHHvHEx9JDnZviLkBa08XkFl6bmSS1R1cRpFNBOPfdj9BzbrUtUOVtkm8i9tW+JvKr
         GAC+xIkhHD54dcpvezh6gR3YHvfDRu+H0emR3inTmFQ5fjmqmPHpDTUe2N/M3rxtKhzY
         FlIa8jnAMPKP8iX/ngzbQ096aVagl0CbQk4ZUV1ape3wHs2PErP7eIn5tAGWID7WTrcd
         Vxjw==
X-Gm-Message-State: AGi0Pua/6sMRv+ldyACtSjhxrCR0RkU9M32WhMK1pW0LdkOchC0TtFnN
        KB+z6yivkD2cSXkEzFv3R9iKFg==
X-Google-Smtp-Source: APiQypI/uOQdNB7OoXoRtSE4LH8L4k2+cECEjdk7Gsye8NA4hOt1lFwZQAV/8AugbkSe7n4CXOo6Zw==
X-Received: by 2002:a2e:93d7:: with SMTP id p23mr3612568ljh.9.1586961620548;
        Wed, 15 Apr 2020 07:40:20 -0700 (PDT)
Received: from xps13.home ([2001:4649:7d40:0:4415:c24b:59d6:7e4a])
        by smtp.gmail.com with ESMTPSA id l22sm1860327lja.74.2020.04.15.07.40.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 07:40:20 -0700 (PDT)
From:   Odin Ugedal <odin@ugedal.com>
To:     toke@redhat.com, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: [PATCH 2/3] q_cake: properly print memlimit
Date:   Wed, 15 Apr 2020 16:39:35 +0200
Message-Id: <20200415143936.18924-3-odin@ugedal.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200415143936.18924-1-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Load memlimit so that it will be printed if it isn't set to zero.

Also add a space to properly print it.

Signed-off-by: Odin Ugedal <odin@ugedal.com>
---
 tc/q_cake.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tc/q_cake.c b/tc/q_cake.c
index 9ebb270c..12d648d7 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -520,6 +520,10 @@ static int cake_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	    RTA_PAYLOAD(tb[TCA_CAKE_RTT]) >= sizeof(__u32)) {
 		interval = rta_getattr_u32(tb[TCA_CAKE_RTT]);
 	}
+	if (tb[TCA_CAKE_MEMORY] &&
+		RTA_PAYLOAD(tb[TCA_CAKE_MEMORY]) >= sizeof(__u32)) {
+		memlimit = rta_getattr_u32(tb[TCA_CAKE_MEMORY]);
+	}
 	if (tb[TCA_CAKE_FWMARK] &&
 	    RTA_PAYLOAD(tb[TCA_CAKE_FWMARK]) >= sizeof(__u32)) {
 		fwmark = rta_getattr_u32(tb[TCA_CAKE_FWMARK]);
@@ -572,7 +576,7 @@ static int cake_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	if (memlimit) {
 		print_uint(PRINT_JSON, "memlimit", NULL, memlimit);
-		print_string(PRINT_FP, NULL, "memlimit %s",
+		print_string(PRINT_FP, NULL, "memlimit %s ",
 			     sprint_size(memlimit, b1));
 	}
 
-- 
2.26.1

