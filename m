Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 054BF20F543
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388145AbgF3M65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388125AbgF3M6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:58:54 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217FFC03E97B
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:58:54 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v6so7156955iob.4
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nae080oEZX7FnMGUXLt4+wKsFcs0lNWW0DRxHmTZnmM=;
        b=zBHXI769t9uyz8WBfdyyP9ALh1MsJ5LaGP07LTYIJH8Dkufa1muknxr/m4u32IKesg
         RKkKzyxfQ4SsXmS1/oyNegmI9clfMwrqWQtIQJzzpOQC3KmN6KaAl0q5nvJURf/V6iuv
         qBHnsEfeHoMM8TtinepXa8kazRAq2jxMe/16ERmlxmfz1IIsoobUhzLRuSXsfvu/MwmY
         8GDyCBpbL1aDcfW+ZYSn2e9jalJi0GMsGkiJXoQ/ChT08ohORR/RFx1iSXf3BuB87Y9g
         twQI+nQFJ7+Qoi3yvvCX2kAjDeIMjdKqxyyLbpQuNA156JW3GQeOPLlm2R+w1D8/Ag6p
         Sk7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nae080oEZX7FnMGUXLt4+wKsFcs0lNWW0DRxHmTZnmM=;
        b=YjWJUr09tQfbNmD8rZTzQkqf29/3IDlchOdpk7UOREWm3D2EdZqcQhY9QuecYyZJIA
         jWH1G6VbEEgC/xhgsTiBuk7EMMgLSb3cHxt+j9+x8QoPaWoI+R/J20s6SvblrnmLONPD
         eoH9P7GUKbfp1PEmnkmMW1yLKCe4qgXLRVQbNEFvuhIWXkMYVOo3RNFcyQu7n8at1UbM
         6BRPHnS49QAOWdT1Zi3cUC0kpktOhGM73N4hVWFHNTCaGcwIIHtjahRuq94tCKHvJbgT
         kipKCH+lWxpOL14c4zQ8K+XKEYbOvmBPaDOne1h+3VKgnietwsd2DKrQqjg0UIlP8LcK
         OmGQ==
X-Gm-Message-State: AOAM532Gi/J0+b2ZoUaTBcvzJNT6OmZNC/EhkTDLT/upjhS6aYkhaF9y
        pIA46OTAYQuJdN1WfUvAP3UV6Q==
X-Google-Smtp-Source: ABdhPJwtS0fI5UJxLBaBgqS6d1G1x5c68po82HuqaSxuRcKfIpUgseiiTFMDsfs5CcSC0RjLKeSh7Q==
X-Received: by 2002:a6b:15c2:: with SMTP id 185mr21540522iov.207.1593521933515;
        Tue, 30 Jun 2020 05:58:53 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z9sm1622588ilb.41.2020.06.30.05.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:58:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/3] net: ipa: kill IPA_MEM_UC_OFFSET
Date:   Tue, 30 Jun 2020 07:58:46 -0500
Message-Id: <20200630125846.1281988-4-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630125846.1281988-1-elder@linaro.org>
References: <20200630125846.1281988-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The microcontroller shared memory area is at the beginning of the
IPA resident memory.  IPA_MEM_UC_OFFSET was defined as the offset
within that region where it's found, but it's 0, and it's never
actually used.  Just get rid of the definition, and move some of the
description it had to be above the definition of the ipa_uc_mem_area
structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: No change from v1.

 drivers/net/ipa/ipa_uc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index a1f8db00d55a..9f9980ec2ed3 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -35,12 +35,6 @@
  */
 /* Supports hardware interface version 0x2000 */
 
-/* Offset relative to the base of the IPA shared address space of the
- * shared region used for communication with the microcontroller.  The
- * region is 128 bytes in size, but only the first 40 bytes are used.
- */
-#define IPA_MEM_UC_OFFSET	0x0000
-
 /* Delay to allow a the microcontroller to save state when crashing */
 #define IPA_SEND_DELAY		100	/* microseconds */
 
@@ -60,6 +54,10 @@
  * @hw_state:		state of hardware (including error type information)
  * @warning_counter:	counter of non-fatal hardware errors
  * @interface_version:	hardware-reported interface version
+ *
+ * A shared memory area at the base of IPA resident memory is used for
+ * communication with the microcontroller.  The region is 128 bytes in
+ * size, but only the first 40 bytes (structured this way) are used.
  */
 struct ipa_uc_mem_area {
 	u8 command;		/* enum ipa_uc_command */
-- 
2.25.1

