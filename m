Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38C25717CA
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiGLK6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiGLK5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:44 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B7BAEF6D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s206so7230111pgs.3
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZmrZiQFBC6l990PQEciLe6BAOAE1sHLGUqsi0b7e6Dg=;
        b=KxjKQMr/lfbEXqjldbDjZ4pI+2u8vOX8/lneGr1gBHnlC5HJOVjOzIBOO/47gZzh0F
         1rHfjAxvyUdi153eWc4ShkW8hBxHZByd/SV0fCcVyFaarVEupo8kIj+ATkJWm00izRbW
         WIzY6GkAo5sw3aVwMt4T6ek8412k4LUVnQW6aDuQZe2bbJ7NEmTyuQZZWflLftBaCGU2
         Yu+dlVKTiRV8i418qvg24W6x4o39YibMG9a4e0F8O90zWi8QinmAJguHn8IBKcwANx1V
         VegAcSGDlFJ+sA8K0800YBGs80DEe6xPZEGHx2GZOKpi0F6ECLBWHGO0wlIJyUMOirJv
         /adQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZmrZiQFBC6l990PQEciLe6BAOAE1sHLGUqsi0b7e6Dg=;
        b=reUS+Q/OSax+CGpto1TJduKpVBPKIRh06z5ZjMudip5Rybfsi1XJlAL3mKKM7Nqi+O
         ts1dnYwrdy0S8rY6cK/s4XfTJaG5/hPHeWfRuRHZF9RoFHohslKYrbGt+nq22Lp9Vj4t
         MlI3dNBuAKOVj/lNbKT30EWN/yEWCrZU6FlhzbUgpn1n0UJggkw/pz/or4NoGMCv3dsg
         Gt9y4gUF1baOp3SQTdKDRDstZd34qUO8uWfCn9XZWA+pN0IxwIMOOP57n5wO5IgNLHWv
         uH3X7WVTSSK1GvGfJKItlgOFvGyadYIHP6Q1t1IOTR5IrBjYkaZ7avfAYYJc8VnI5ZD0
         rPaw==
X-Gm-Message-State: AJIora+YsWc2i7PJqQGBUpSKq9tPq3YkA71oQoE8f6eFgTSFUjPFCXve
        nJbrQfKO3sy71ENHX+CMz9E=
X-Google-Smtp-Source: AGRyM1szw81lcj7RQHvPWTU3UT0SS/kY+NskykmcWycABg+wJHVqvE9uShp9rr0Db9wsnVBo+JXsBw==
X-Received: by 2002:a63:1e15:0:b0:411:c9e8:2f14 with SMTP id e21-20020a631e15000000b00411c9e82f14mr20543305pge.293.1657623462750;
        Tue, 12 Jul 2022 03:57:42 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:42 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 7/8] amt: drop unexpected multicast data
Date:   Tue, 12 Jul 2022 10:57:13 +0000
Message-Id: <20220712105714.12282-8-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712105714.12282-1-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/amt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index dbaf490cc33f..03decb3caa5c 100644
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

