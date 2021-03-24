Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32335347959
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 14:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhCXNQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 09:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhCXNPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 09:15:37 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8621C0613E5
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:36 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id d10so14546473ils.5
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 06:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FQFA2QStDKmo1XhVZ4KOEMpN+hi3li+F67WfkjwPMWs=;
        b=WeDb3w8CTitNL7fiuwx+cOti4cQKBLcjExxqeMWo37GnH6C6+LRup+izK3itSPaCJb
         A5anL4t6Ar5H7xQe7JJ3UC4nvW9CR2nVc6TBklSLUY4skzJO+/+vSM9/KBdKH6uh4eQX
         1wkSfJVsyVbwbe1UpQT4pCWIEkUNF/eW4+vSMVQ7cGDoArCop7lzkLv1y/pQ3/AF7AeU
         JPFYKXclr0SuCOnz1u4CiZpXoOH3oRrrMHaGZdpE/m4TMHUvJ8mvY70d5GlWRivr7wqA
         O/cAB5//lqMxT5ZqGHd/9VW1R8jBtI33CpRPWvaoupgYZvHrrcc7RGYB8KdfzkIrzTra
         rKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FQFA2QStDKmo1XhVZ4KOEMpN+hi3li+F67WfkjwPMWs=;
        b=U3JmOziUEcO1UQyEbk1OxeCMgZR0xQkPnznwKjo/ZMQvTk44NMlp7why09QLo7b1C2
         1KPUGJ/abwdi1fmWgxRUlL/1uEmBFXZWBgdK+04VzIFfkMt2VIhtX8CeQ4H1BkZSqZ8m
         k/GLEReppzNgs39UpBjzSHHciA/+4LFVYVm5On2cU0AP/8L3BemIO5wyIHJa7kAgs+Wm
         saWFMU5RZQUGP1l9EWbes18xttyS+E+bkcM/eWL6np9FEItiIQThS6+7x+71W8eUFk9N
         vMSqqGPBDIQyZT5pWL2bmL1ewfhe8osz+Qvx+3nml/IcLYPxOhxYZ93uN/jaqV9FafgY
         QKKQ==
X-Gm-Message-State: AOAM533tCVNHTm7N/ZYo3LInh9nQoJCjh/Y5o7cQAbEuxk9LWOu3rOHF
        LAt6DT0ZHf2djJkf5hDf2djWIQ==
X-Google-Smtp-Source: ABdhPJxgqUoXVAUq3XhOK9/xiuwRElTHsbJ8mq0GmNX+XUfXi2axSbQ5PPrxXNjQyq0a1hn/+Ri1vQ==
X-Received: by 2002:a92:b011:: with SMTP id x17mr2598180ilh.113.1616591736340;
        Wed, 24 Mar 2021 06:15:36 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n7sm1160486ile.12.2021.03.24.06.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:15:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/6] net: ipa: increase channels and events
Date:   Wed, 24 Mar 2021 08:15:28 -0500
Message-Id: <20210324131528.2369348-7-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210324131528.2369348-1-elder@linaro.org>
References: <20210324131528.2369348-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increase the maximum number of channels and event rings supported by
the driver, to allow the maximum available on the SDX55.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index efc980f96109e..d5996bdb20ef5 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -16,8 +16,8 @@
 #include "ipa_version.h"
 
 /* Maximum number of channels and event rings supported by the driver */
-#define GSI_CHANNEL_COUNT_MAX	17
-#define GSI_EVT_RING_COUNT_MAX	13
+#define GSI_CHANNEL_COUNT_MAX	23
+#define GSI_EVT_RING_COUNT_MAX	20
 
 /* Maximum TLV FIFO size for a channel; 64 here is arbitrary (and high) */
 #define GSI_TLV_MAX		64
-- 
2.27.0

