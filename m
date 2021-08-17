Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8441E3EE9D6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239683AbhHQJ37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbhHQJ3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:52 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FC2C0612A4;
        Tue, 17 Aug 2021 02:29:10 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i10-20020a05600c354ab029025a0f317abfso1370453wmq.3;
        Tue, 17 Aug 2021 02:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UntOPN8LGfo5I7NL6hwAYt7BuYwmBcZpzxTKWC6m74E=;
        b=m4NNrDQmBwwkSBneXX+6ikcm9yMSQlkZ4wpZl71gcdcCwb8FthgwLw7TZAXTGSwKOV
         A2wz9sr66KJ1M62MBAe4W2H3b5B4zsniCEi5PX8/ll3wCn5aEDrCjDvVoSZV9h/fuWRE
         u2S66zA1RKjK4gCkFOnPbJGkb7cPVp+yosGZlwii4YI+y/sJ0/BNVbJDnX+oj6f+tXPT
         eonSc8jcVaSf+lUlB5FXr2YQ24Skjb8ZAKmEBExWa3nA0LxOQ9nm8D5irLFCsYpSRQ7b
         pZfvwN0LPMifp7ETRykZwrjC8zwLMQygY/cuPWnJ+vvVE8jRSOAj7xteOOl1uAYeI4/P
         9sBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UntOPN8LGfo5I7NL6hwAYt7BuYwmBcZpzxTKWC6m74E=;
        b=mU1Hnjntvnk6MGqZAJs9W7oSE6ypI0IxK/6nh2Lbyq+IxPt39f5h1mas2R0wbuyv5+
         CG5zL0tQ+8yBmCM4KNfDu3PC42Chr9ovVTfg39pNWa8WofFp7x4WU2po5cgVvivajSai
         d+sX/qFdyhp7t/dcCK5NCU0YyPGWSdK5FJXKcN2wqrfYC+vXWa8pOdFliJ2tR8t4n4LQ
         SmrW+9ygpQ5KJJLIRsVHtW47fa0+8CEzCf3xywFX7VQCkTVeU2gy49Bb7HCl3jFWfEKI
         RyIAzW698/7UGyP9AgdE7xRMXlxNSN+dGbmOZh4WFcMmlco6pKLKw81Wvbxtwi1VnS2s
         hPNA==
X-Gm-Message-State: AOAM530Hg558wnlfgu+kUIGDhwzChfoQdQLgMJt34e82InXMNfjO20H3
        R4nepWKKtndiEr8PNfbbnH4=
X-Google-Smtp-Source: ABdhPJwlS73ulryONz08JNFFIobA6ro9fDPJDiHIPR9GQHp2mM+OaYaZgLrM5AMwEOkOxvO9hoo16g==
X-Received: by 2002:a7b:c005:: with SMTP id c5mr2309886wmb.59.1629192549499;
        Tue, 17 Aug 2021 02:29:09 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:09 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 11/16] selftests: xsk: decrease batch size
Date:   Tue, 17 Aug 2021 11:27:24 +0200
Message-Id: <20210817092729.433-12-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Decrease the batch size from 64 to 8 to avoid potentially overflowing
some buffers in the skb case that leads to dropped packets we cannot
control (and thus the tests may generate false negatives).

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0fb657b505ae..1c5457e9f1d6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -36,7 +36,7 @@
 #define UDP_PKT_DATA_SIZE (UDP_PKT_SIZE - sizeof(struct udphdr))
 #define USLEEP_MAX 10000
 #define SOCK_RECONF_CTR 10
-#define BATCH_SIZE 64
+#define BATCH_SIZE 8
 #define POLL_TMOUT 1000
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define RX_FULL_RXQSIZE 32
-- 
2.29.0

