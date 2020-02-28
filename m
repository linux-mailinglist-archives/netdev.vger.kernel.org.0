Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8CCA17422A
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgB1Wma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:42:30 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41085 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgB1Wm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:42:28 -0500
Received: by mail-yw1-f67.google.com with SMTP id h6so4925738ywc.8
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GSt5faLYca4AcJbso3LEBGMbkMJiDIuIJIY2653z1qs=;
        b=n27LLQO4fxLC/vx1IUby/iG5qg8nrK0PVUru7gTopDoj7YDgLK64U31I4Up9Dfnj5W
         cKl+eZ7FZX12ndm1beXvwuKfS1HQyD7huM2uOUuu3w1flT4qU62n2Mji2LELqJ+s+fEk
         GWr3H+/q8BhoByJdA9GjvZ1YV5isxdU59SvCBLCnP7soEvgkVXgKHv9NySV9Y0HUsYrt
         Xnos0iFgENPrBrW6CL4Yv25YevJ9noGrClgtzkoJClx3L1m0gjASgt92F8oODK65B5mM
         UjqJm9OhZc8z1pVXQ3ytSkHYKTJVM+k09AQVQZe7gwKMH9f1PbChwUHjlebxnBl7XnyB
         5EOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GSt5faLYca4AcJbso3LEBGMbkMJiDIuIJIY2653z1qs=;
        b=LyNrnLG/gwTze/88WLdsYr0OHTpoI8adkmSZPYGYV8laf6/p6zX5yACzGCAYxPE4gk
         aCI/yuIcGEnsw5er2WWFMN6zMlP/BlxVanS8LeCVhm2ukaXcOE8AizNpeachrvRlll+Z
         0pSGtvzAGEdXP2i2uhOXFS2JgWRbxAutCuNbjGVZaBLjHeLYXw9iux3kr7eZ59CMAa8T
         gCD4DwOSdCgkeF7aYp9byMJQKOIpyU+k2I/+mpbsRSPgO9cvuIAtiSt9r5jCivSm7OJP
         MOia6C/rHExOXcKksatoan8dIc0vYeef1Gqg/UMC+AsFILsVtkiJ+2gsRzaCFh6w/yOT
         S6Ag==
X-Gm-Message-State: APjAAAXOgLdGNTKGDZ/1PHAlhW47UOxQIR18ErYhtSPDR2howIS++R0c
        Yo+GsNxYe7B4e2wxzspHzmhlWw==
X-Google-Smtp-Source: APXvYqwm8qR4Jqt5uFYcZzaP1JgcSaExwXlCTMjLAGxC0Eu3f1PZ2tmN4bFG7LwXdep2fvngNPTwSw==
X-Received: by 2002:a0d:d106:: with SMTP id t6mr6796249ywd.211.1582929747125;
        Fri, 28 Feb 2020 14:42:27 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d188sm4637830ywe.50.2020.02.28.14.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 14:42:26 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Dan Williams <dcbw@redhat.com>,
        Evan Green <evgreen@google.com>,
        Eric Caruso <ejcaruso@google.com>,
        Susheel Yadav Yadagiri <syadagir@codeaurora.org>,
        Chaitanya Pratapa <cpratapa@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/17] soc: qcom: ipa: IPA interface to GSI
Date:   Fri, 28 Feb 2020 16:41:55 -0600
Message-Id: <20200228224204.17746-9-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200228224204.17746-1-elder@linaro.org>
References: <20200228224204.17746-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch provides interface functions supplied by the IPA layer
that are called from the GSI layer.  One function is called when a
GSI transaction has completed.  The others allow the GSI layer to
inform the IPA layer when the hardware has been told it has new TREs
to execute, and when the hardware has indicated transactions have
completed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_gsi.c | 54 +++++++++++++++++++++++++++++++++++
 drivers/net/ipa/ipa_gsi.h | 60 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)
 create mode 100644 drivers/net/ipa/ipa_gsi.c
 create mode 100644 drivers/net/ipa/ipa_gsi.h

diff --git a/drivers/net/ipa/ipa_gsi.c b/drivers/net/ipa/ipa_gsi.c
new file mode 100644
index 000000000000..dc4a5c2196ae
--- /dev/null
+++ b/drivers/net/ipa/ipa_gsi.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+
+#include <linux/types.h>
+
+#include "gsi_trans.h"
+#include "ipa.h"
+#include "ipa_endpoint.h"
+#include "ipa_data.h"
+
+void ipa_gsi_trans_complete(struct gsi_trans *trans)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+
+	ipa_endpoint_trans_complete(ipa->channel_map[trans->channel_id], trans);
+}
+
+void ipa_gsi_trans_release(struct gsi_trans *trans)
+{
+	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
+
+	ipa_endpoint_trans_release(ipa->channel_map[trans->channel_id], trans);
+}
+
+void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
+			       u32 byte_count)
+{
+	struct ipa *ipa = container_of(gsi, struct ipa, gsi);
+	struct ipa_endpoint *endpoint;
+
+	endpoint = ipa->channel_map[channel_id];
+	if (endpoint->netdev)
+		netdev_sent_queue(endpoint->netdev, byte_count);
+}
+
+void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
+				  u32 byte_count)
+{
+	struct ipa *ipa = container_of(gsi, struct ipa, gsi);
+	struct ipa_endpoint *endpoint;
+
+	endpoint = ipa->channel_map[channel_id];
+	if (endpoint->netdev)
+		netdev_completed_queue(endpoint->netdev, count, byte_count);
+}
+
+/* Indicate whether an endpoint config data entry is "empty" */
+bool ipa_gsi_endpoint_data_empty(const struct ipa_gsi_endpoint_data *data)
+{
+	return data->ee_id == GSI_EE_AP && !data->channel.tlv_count;
+}
diff --git a/drivers/net/ipa/ipa_gsi.h b/drivers/net/ipa/ipa_gsi.h
new file mode 100644
index 000000000000..3cf18600c68e
--- /dev/null
+++ b/drivers/net/ipa/ipa_gsi.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2019-2020 Linaro Ltd.
+ */
+#ifndef _IPA_GSI_TRANS_H_
+#define _IPA_GSI_TRANS_H_
+
+#include <linux/types.h>
+
+struct gsi_trans;
+
+/**
+ * ipa_gsi_trans_complete() - GSI transaction completion callback
+ * @trans:	Transaction that has completed
+ *
+ * This called from the GSI layer to notify the IPA layer that a
+ * transaction has completed.
+ */
+void ipa_gsi_trans_complete(struct gsi_trans *trans);
+
+/**
+ * ipa_gsi_trans_release() - GSI transaction release callback
+ * @trans:	Transaction whose resources should be freed
+ *
+ * This called from the GSI layer to notify the IPA layer that a
+ * transaction is about to be freed, so any resources associated
+ * with it should be released.
+ */
+void ipa_gsi_trans_release(struct gsi_trans *trans);
+
+/**
+ * ipa_gsi_channel_tx_queued() - GSI queued to hardware notification
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel number
+ * @count:	Number of transactions queued
+ * @byte_count:	Number of bytes to transfer represented by transactions
+ *
+ * This called from the GSI layer to notify the IPA layer that some
+ * number of transactions have been queued to hardware for execution.
+ */
+void ipa_gsi_channel_tx_queued(struct gsi *gsi, u32 channel_id, u32 count,
+			       u32 byte_count);
+/**
+ * ipa_gsi_trans_complete() - GSI transaction completion callback
+ipa_gsi_channel_tx_completed()
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel number
+ * @count:	Number of transactions completed since last report
+ * @byte_count:	Number of bytes transferred represented by transactions
+ *
+ * This called from the GSI layer to notify the IPA layer that the hardware
+ * has reported the completion of some number of transactions.
+ */
+void ipa_gsi_channel_tx_completed(struct gsi *gsi, u32 channel_id, u32 count,
+				  u32 byte_count);
+
+bool ipa_gsi_endpoint_data_empty(const struct ipa_gsi_endpoint_data *data);
+
+#endif /* _IPA_GSI_TRANS_H_ */
-- 
2.20.1

