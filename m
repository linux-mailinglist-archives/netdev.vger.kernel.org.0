Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094CE2AE24A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 22:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbgKJV7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 16:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731919AbgKJV7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 16:59:30 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FD8C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:30 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id q1so38237ilt.6
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 13:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ZfCNEsX2F4ym+QjxnD265ywN9odEwbi/6080mald40=;
        b=ypXDU5WgtfV7RHl/tNmoqV8OoYFHOGSVIVm/Ze6HwapCGC5SeKmEN6sZ9kAACyWbYm
         1tTgdpGnpYQaCSeDIte6sWPYB0M0ooOt9gU/SUc+ep6Fv0snUi2KO+ZP1Gjl7MSGREpT
         0djNUA0XV0ZnyyNFMF7w26k1rofHSxUAhhEIDyaGEnsH9kF/zWEVge4wmONCttx3ncVW
         REs268iaDszDJeZGLroS2FxOBdOmHisdN9DVz3bY+bYZLfCQQ+5OCBNi4g5V8fnK9geV
         GAW9/n1DCLa/kYgzfgrknpcU2wBDST1AXL3Jworif37ZON7x7X2rq7njixoqUnikgrcj
         xnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ZfCNEsX2F4ym+QjxnD265ywN9odEwbi/6080mald40=;
        b=ii8yDvJaQJWjt4Ej02YJ8RwbGaDg6JIvT+MNwX4bf/MHL4HNZC2ZfqFzj7KDbbhMZV
         vt0IwSSaMGQZjYs7FxJaX2mdaBf9AfxjY6umd8W8ZqStv4fcUoWdrtWYObGJ+K9LvD2t
         UiT2ZweqdP9PdWVMdBrpxqZa8Nk0/gojqKtzE6MVtyywr8KZrKfuoWxOA5b0PWESaDCg
         VzWmDJ5Zh5gC+8UTxn6dE9tTj4QRT2vyI7faxLA3d3Z6dn/sokvZE7K7g88yyr2yGc5M
         DvTJi+R2OAQY7p1RoJiKK+sYHcq+ILhcQkyr3jQlaOIaC1BCpTyzPEWjN/kQFiYrino3
         FmWA==
X-Gm-Message-State: AOAM5338vnGf3sOrDKTib2+AwNbK6s+tpqEenowCw4BgE7vSAIXkp5JF
        oZ592ekqhqch6uU+kLAAnt+xPQ==
X-Google-Smtp-Source: ABdhPJxmR8xfZQsY3og0xkDOHfC47WaU5mqVqaGKiR1ZY+Zm+YupqUOBxaBUybRdMuS0umMtOjgfRQ==
X-Received: by 2002:a92:ac0a:: with SMTP id r10mr16230520ilh.205.1605045570062;
        Tue, 10 Nov 2020 13:59:30 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d142sm102010iof.43.2020.11.10.13.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 13:59:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: move channel type values into "gsi_reg.h"
Date:   Tue, 10 Nov 2020 15:59:19 -0600
Message-Id: <20201110215922.23514-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201110215922.23514-1-elder@linaro.org>
References: <20201110215922.23514-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gsi_channel_type enumerated type define values used for the
channel type/protocol for event rings and channels.  Move its
definition out of "gsi.c" and into "gsi_reg.h", alongside the
definition of the CH_C_CNTXT_0 register offset and its fields.
Add a comment near the definition of the EV_CH_E_CNTXT_0 register
indicating this type is used for its EV_CHTYPE field.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 8 --------
 drivers/net/ipa/gsi_reg.h | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 8b476e51ab78e..78b793cf8aa4c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -127,14 +127,6 @@ enum gsi_err_type {
 	GSI_ERR_TYPE_EVT	= 0x3,
 };
 
-/* Hardware values used when programming a channel or event ring type */
-enum gsi_channel_type {
-	GSI_CHANNEL_TYPE_MHI			= 0x0,
-	GSI_CHANNEL_TYPE_XHCI			= 0x1,
-	GSI_CHANNEL_TYPE_GPI			= 0x2,
-	GSI_CHANNEL_TYPE_XDCI			= 0x3,
-};
-
 /* Hardware values representing an event ring immediate command opcode */
 enum gsi_evt_cmd_opcode {
 	GSI_EVT_ALLOCATE	= 0x0,
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index e69ebe4aaf884..9260ce99ec525 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -71,6 +71,13 @@
 #define ERINDEX_FMASK			GENMASK(18, 14)
 #define CHSTATE_FMASK			GENMASK(23, 20)
 #define ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+/** enum gsi_channel_type - CHTYPE_PROTOCOL field values in CH_C_CNTXT_0 */
+enum gsi_channel_type {
+	GSI_CHANNEL_TYPE_MHI			= 0x0,
+	GSI_CHANNEL_TYPE_XHCI			= 0x1,
+	GSI_CHANNEL_TYPE_GPI			= 0x2,
+	GSI_CHANNEL_TYPE_XDCI			= 0x3,
+};
 
 #define GSI_CH_C_CNTXT_1_OFFSET(ch) \
 		GSI_EE_N_CH_C_CNTXT_1_OFFSET((ch), GSI_EE_AP)
@@ -128,6 +135,7 @@
 #define EV_INTYPE_FMASK			GENMASK(16, 16)
 #define EV_CHSTATE_FMASK		GENMASK(23, 20)
 #define EV_ELEMENT_SIZE_FMASK		GENMASK(31, 24)
+/* enum gsi_channel_type defines EV_CHTYPE field values in EV_CH_E_CNTXT_0 */
 
 #define GSI_EV_CH_E_CNTXT_1_OFFSET(ev) \
 		GSI_EE_N_EV_CH_E_CNTXT_1_OFFSET((ev), GSI_EE_AP)
-- 
2.20.1

