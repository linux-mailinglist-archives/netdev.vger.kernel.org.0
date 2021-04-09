Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC03B35A543
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234557AbhDISH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbhDISHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:07:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FBDC061765
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 11:07:32 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y4so6835113ioy.3
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 11:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TOH3l++0jw4JADgwzNPOO7zYc7PdMPjbZGsmYctkn9E=;
        b=zd10W9BN0tLyMuoOeWEg/iNO635zlwEZtexPDtav7TzSKX3z8C0IU7JispTTfNNliB
         XQ2+Ksd4W642woc1RJR01vkK2ajrZ2yIzsXfP6gY/DOI0SvWRHNBDcvUzmqGyMeU+K+4
         zW4jT0UpP6Bpzjvc99ACO05ydGO3eoosQ9NX3xyfRi42B0EN5Dqcqv6I4HSKkkojL1HM
         GGQ/lm9QsojPBE0dpLwAnmrBhoOIz/h7cVVNLlsBbeaoexDAY9R/09WrOlZyCkj8DUC4
         AldwkRyqn1HE2YQgkFzjhDM+YDrysN1RhdEc1CMt2T76E++HCczhwk5j4SS8bVNSedtf
         VikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOH3l++0jw4JADgwzNPOO7zYc7PdMPjbZGsmYctkn9E=;
        b=JYjvJBnRDkMtLmRjMfRaHxeqU3NMNUuYjq3j+SICB1nQA9sJffeX3kgV0VMEAl0j+H
         /SRpQ5Km/8sT/jLgjUC0fLqjK+Byx0h7MlA5L+MzB4NyXJglenBtLAMOzcJrUe3jTE9D
         1ZQ9yL+8V0Dv/69TLOYMxMOc4O6EhdjdYF5zH5J8EFOCkvWeZUDk31EA6MhNL8PcQ9fG
         fCgkFrvDl0/N5nqyB6NF30tkzTcLQxX63KydGc+t3GMUvSUYsLE7wNhaQDhCVQj9fui5
         wTcW0v0XqSHocM4TlRYZb3tuxJqanjSQjVIKM4P7NPXlCV2t1n11JP5Ug8zfWp0zhSWN
         0D7w==
X-Gm-Message-State: AOAM532OwRyVcSQDVREMjqBOglLMC9M4hPgTI6JguNSREwulwNCTBAmh
        luYqmlm2vQP9EvhhYRYVTmc9dw==
X-Google-Smtp-Source: ABdhPJzTeZc06YyCZzSyxFsI8x7rr1p0kBTjjomD0a8PWoU2jLQ++YrRsMZ40HlucdjQmwT51cWnug==
X-Received: by 2002:a05:6638:140e:: with SMTP id k14mr15429481jad.31.1617991652431;
        Fri, 09 Apr 2021 11:07:32 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g12sm1412786ile.71.2021.04.09.11.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:07:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: ipa: three small fixes
Date:   Fri,  9 Apr 2021 13:07:22 -0500
Message-Id: <20210409180722.1176868-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180722.1176868-1-elder@linaro.org>
References: <20210409180722.1176868-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some time ago changes were made to stop referring to clearing the
hardware pipeline as a "tag process."  Fix a comment to use the
newer terminology.

Get rid of a pointless double-negation of the Boolean toward_ipa
flag in ipa_endpoint_config().

make ipa_endpoint_exit_one() private; it's only referenced inside
"ipa_endpoint.c".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 6 +++---
 drivers/net/ipa/ipa_endpoint.h | 2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index dd24179383c1c..72751843b2e48 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -397,7 +397,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 	/* We need one command per modem TX endpoint.  We can get an upper
 	 * bound on that by assuming all initialized endpoints are modem->IPA.
 	 * That won't happen, and we could be more precise, but this is fine
-	 * for now.  We need to end the transaction with a "tag process."
+	 * for now.  End the transaction with commands to clear the pipeline.
 	 */
 	count = hweight32(initialized) + ipa_cmd_pipeline_clear_count();
 	trans = ipa_cmd_trans_alloc(ipa, count);
@@ -1755,7 +1755,7 @@ int ipa_endpoint_config(struct ipa *ipa)
 
 		/* Make sure it's pointing in the right direction */
 		endpoint = &ipa->endpoint[endpoint_id];
-		if ((endpoint_id < rx_base) != !!endpoint->toward_ipa) {
+		if ((endpoint_id < rx_base) != endpoint->toward_ipa) {
 			dev_err(dev, "endpoint id %u wrong direction\n",
 				endpoint_id);
 			ret = -EINVAL;
@@ -1791,7 +1791,7 @@ static void ipa_endpoint_init_one(struct ipa *ipa, enum ipa_endpoint_name name,
 	ipa->initialized |= BIT(endpoint->endpoint_id);
 }
 
-void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint)
+static void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint)
 {
 	endpoint->ipa->initialized &= ~BIT(endpoint->endpoint_id);
 
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index f034a9e6ef215..0a859d10312dc 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -87,8 +87,6 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa);
 
 int ipa_endpoint_skb_tx(struct ipa_endpoint *endpoint, struct sk_buff *skb);
 
-void ipa_endpoint_exit_one(struct ipa_endpoint *endpoint);
-
 int ipa_endpoint_enable_one(struct ipa_endpoint *endpoint);
 void ipa_endpoint_disable_one(struct ipa_endpoint *endpoint);
 
-- 
2.27.0

