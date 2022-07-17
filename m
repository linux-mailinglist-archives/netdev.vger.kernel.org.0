Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECC57773F
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbiGQQMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiGQQMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:38 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F2813D40
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id o15so9733571pjh.1
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n6Dthk+er3Yye3+nU1WvbyJD3N/uReAOaBDLcBvSh0c=;
        b=YL9A2AiWdSd/2h96ldJdtutfZNJAHNzgbq/ubApd7f3ntrTZ7qgH2/chN+ER7UByLd
         x8gLvRx5eSBu4yx+PIGrRx+XUGF0vn0nHXOIw2r7AySbQFpNbL7HahW+aNicUkUfJCuG
         7TVC/Un+RiQdbshWhP89w3EaONH4WiMd5qn5JV7Xu/QKzGluygT81dZ5IwfYYbAO1Y3P
         hOWS+++ac+EXOor1cv09qpAAGO7197uII4iog6bsKLmMdM0SBe0/LpcBABtixgo7Z3x3
         mJ/uGONm2tBpXNZnyIdyFGRFlTlUG3s+g8dTB86gqmNkHS+fi9lmcu2rcjuBPjgRP+0R
         ifDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n6Dthk+er3Yye3+nU1WvbyJD3N/uReAOaBDLcBvSh0c=;
        b=i1o4+Kvz96MQJ1VrfG43DniCHgHarWhjZxoQN8VvceoV+Hc6Ll+3nL52AoQ3MRuE3S
         JWIfgW7X1jBPejtsgLYSQYMD+p5XvydBqx6KN93E5JmfRXguc6cQqorc5ubswq/zpD6K
         BbZa6DDpSTDJTHLniXZmOtco7fFJaqz9e6QMUO8K4MOHYxz+90yQmGhGSO4N5U8637BU
         pn42Vd4W2AB+t3CWw1uRqSYT7CFUooKGn9KLOc+MylVyhBfIOa+jesIScfiNCrwxppg0
         3FtyQDaltzSs1yJUoq+6M6TRYU9iRE3kZY0qToL5KUBmatruYFGL6rLb5xoLwgvZRppM
         YYxA==
X-Gm-Message-State: AJIora9e+kookDUL8HtJpyrrIAi65uwCmfe4U9hUMLKH8k1MIe6XIdE7
        +49ZlBnIM+6SrJclp2pUYS4=
X-Google-Smtp-Source: AGRyM1sOsHm8nQ295+8oQrN4tUBVeYI78dUdT1V/bedxUzDAMGOZAmTZrh4QcuMUqY0vxxlfGiwfCQ==
X-Received: by 2002:a17:902:da92:b0:16b:ecee:28a8 with SMTP id j18-20020a170902da9200b0016becee28a8mr24344478plx.71.1658074356699;
        Sun, 17 Jul 2022 09:12:36 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:36 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 7/8] amt: drop unexpected multicast data
Date:   Sun, 17 Jul 2022 16:09:09 +0000
Message-Id: <20220717160910.19156-8-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
References: <20220717160910.19156-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AMT gateway interface should not receive unexpected multicast data.
Multicast data message type should be received after sending an update
message, which means all establishment between gateway and relay is
finished.
So, amt_multicast_data_handler() checks amt->status.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes.

 drivers/net/amt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 396cfee018a0..ecd2de22bdfc 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2282,6 +2282,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct ethhdr *eth;
 	struct iphdr *iph;
 
+	if (READ_ONCE(amt->status) != AMT_STATUS_SENT_UPDATE)
+		return true;
+
 	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
-- 
2.17.1

