Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D35469B4
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348674AbiFJPqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345635AbiFJPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:46:29 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1354540E7A
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:24 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id y79so7114405iof.2
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 08:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yzpg6uSX6tMLeSyY3HSLNWDLn7gtZwirUKg77xaYBSY=;
        b=NgvGg1sb/EMOxOd0Hk4IC0/bLMvgrcj1VRmfcbBh+wwoCZAw81jAjGyJ18FjHTna2x
         bdp9AKZ06s4jsbYtlf8XJAGKM1NF3tD3DtFX4+IfZg5gZIDyw0TpKrcB8vfpKQ3wJBgy
         9CvUD52CRzeRKBwE1pZ0E+AmX2gNfZYJQztMaBXTl+iKSYgh7f/8x37q795ziU4kmAy6
         TcDxp2zmDOst1QrGrkRcP/r8O3gwh3uIdrlYTqtyCRQUEk1KY2vAApZNZeloNtxuKT8H
         yY+7GUuKHvxzyNMyQojL5RWz2/UZ9ZEMAl9oeoqUhhEgOmXPXP6xoFUoEMqr3wZz+Y1U
         rqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yzpg6uSX6tMLeSyY3HSLNWDLn7gtZwirUKg77xaYBSY=;
        b=LkiR49apma13sYYGls/haz131ENXFh7sq8hcDTuaEzAyjpPOVoQA8I7ZrvTX51V6eB
         SkX9/F9gEn3JqentG11dMX9wpiX2500/bgTQgO4BpjtmUtPgk9YcHNfUaMm4mqW66Y09
         qllnnH3a/fViGoobUTD/RiWH0r4j5638LsfsOZ0CFdWLa7Me7iksa7lSV650sQybpf02
         SmIzCTSXH8R4sq1Qx8JOx4mihzPoOMylF7pwXOgOqJ0Wn+VJhcCFgcmUO7P6udVgF9RR
         ++ZUZuB1eeDMueGxyqpOgZ/Pf6t2xAbQqER0RozkQQvgwroS6ST4epkiFFqGg5nKr7M0
         GIhA==
X-Gm-Message-State: AOAM532GglWswiuNXtt6/OkYJDIJIeM7Jjsvbga/PCL7I1ErnTSmAbQM
        iAIq8VlRkopCYnnlQEaVfHokiYwyzXVzAA==
X-Google-Smtp-Source: ABdhPJxT6mIepia5PxJjdru8UpkhyTrUg4l/P9fcEkomP2u+44qHE3xpLXAGA/tvIhTqpz6z+sKdbQ==
X-Received: by 2002:a6b:108:0:b0:669:a9e4:24a0 with SMTP id 8-20020a6b0108000000b00669a9e424a0mr5226313iob.165.1654875983381;
        Fri, 10 Jun 2022 08:46:23 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y15-20020a92950f000000b002d3adf71893sm12100488ilh.20.2022.06.10.08.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 08:46:23 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: simplify endpoint transaction completion
Date:   Fri, 10 Jun 2022 10:46:13 -0500
Message-Id: <20220610154616.249304-5-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610154616.249304-1-elder@linaro.org>
References: <20220610154616.249304-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a GSI transaction completes, ipa_endpoint_trans_complete() is
eventually called.  That handles TX and RX completions separately,
but ipa_endpoint_tx_complete() is a no-op.

Instead, have ipa_endpoint_trans_complete() return immediately for a
TX transaction, and incorporate code from ipa_endpoint_rx_complete()
to handle RX transactions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 86ef91f83eb68..66d2bfdf9e423 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1368,18 +1368,14 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 	}
 }
 
-/* Complete a TX transaction, command or from ipa_endpoint_skb_tx() */
-static void ipa_endpoint_tx_complete(struct ipa_endpoint *endpoint,
-				     struct gsi_trans *trans)
-{
-}
-
-/* Complete transaction initiated in ipa_endpoint_replenish_one() */
-static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
-				     struct gsi_trans *trans)
+void ipa_endpoint_trans_complete(struct ipa_endpoint *endpoint,
+				 struct gsi_trans *trans)
 {
 	struct page *page;
 
+	if (endpoint->toward_ipa)
+		return;
+
 	if (trans->cancelled)
 		goto done;
 
@@ -1393,15 +1389,6 @@ static void ipa_endpoint_rx_complete(struct ipa_endpoint *endpoint,
 	ipa_endpoint_replenish(endpoint);
 }
 
-void ipa_endpoint_trans_complete(struct ipa_endpoint *endpoint,
-				 struct gsi_trans *trans)
-{
-	if (endpoint->toward_ipa)
-		ipa_endpoint_tx_complete(endpoint, trans);
-	else
-		ipa_endpoint_rx_complete(endpoint, trans);
-}
-
 void ipa_endpoint_trans_release(struct ipa_endpoint *endpoint,
 				struct gsi_trans *trans)
 {
-- 
2.34.1

