Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8204DE647
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 06:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242158AbiCSFZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 01:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiCSFZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 01:25:19 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE802E8421;
        Fri, 18 Mar 2022 22:23:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mm17-20020a17090b359100b001c6da62a559so303080pjb.3;
        Fri, 18 Mar 2022 22:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=4lPEgZsMovP3pUCJ2ox6cQeKtGidqAFTcwxPJB0RBEE=;
        b=P41O2IcN/LwIE44ywC76HY6ZFdQe/EaPwCjl/NVHFBfIamJJPqAgM+p+kRL3barpAd
         5RX50VjXBZA5d4ugW2rbyuOOkTUVSa3A7SJmrv/I/uWP4cITegAH7GXOFxbQ8bHFHKyY
         7FpMsa3kMohY0fK0NVX64V+Nj0i/GVM9gIy0cOnZwbNstrAVW966JuAulPNTkqiHi8O0
         MaHfMmC6j3LMIZrArkvyLJ/gWfA3z803Q3A9AHkxbWnkmhecxLId0dlHjfwGAaxu+gXc
         i7Avsn5P3mWeAzi+4PrLk/bToIUThbh/LsndTGUr8YkRJ60EZIE1QcgEko0M5lEXX0V5
         lcPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4lPEgZsMovP3pUCJ2ox6cQeKtGidqAFTcwxPJB0RBEE=;
        b=SN0JRBFFsemooBHW5RyycNbNnDypqgtYWVS2+SX3QEmZnZFsRVAz2R9Ed55qtx6Yrl
         UE6pAeAeG9Mofq/rTDNPFseVdUekVourvwJhSK01FBLVPMw9bNRyyGCNKmMSQxEPbc+F
         Pkkzd2zBxLQFQyNHPEOJYyJTVWisBU0r5NjCaMRKi9c66FA/SzySWQkj5vRCZ1OG31MY
         x9NibcRBwmRyQQ5B82ZwE+RPwkppiI0a/UVdC6KzTLyy/6MiiFOII7WlOwtf+63CYKWJ
         hlriCXJtN+laOE7o/HM/k/u1UViUkYnAnqmU9CZUIbf9RxgaRuyGLFT1hobwzgG4e6TY
         JsXg==
X-Gm-Message-State: AOAM531/Ov+t9GlhNiq1m5RoSEqu6h276bELxu1AnHK9Lw8IDCwjk4ab
        BQCOAKeW/HNjYQrpfh+qVojY/nBJbSv8vw==
X-Google-Smtp-Source: ABdhPJwaBbPjwj9kjZy8VfejQrDDPRGbGAOwsjPOZWLQJXpCnKu9TUCBj9siG+SDaK1oYICDqYmIrA==
X-Received: by 2002:a17:902:a98b:b0:14f:ae28:c660 with SMTP id bh11-20020a170902a98b00b0014fae28c660mr2962523plb.94.1647667438533;
        Fri, 18 Mar 2022 22:23:58 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id t24-20020a056a00139800b004f7586bc170sm12796502pfg.95.2022.03.18.22.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 22:23:57 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     christopher.lee@cspi.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH] myri10ge: remove an unneed NULL check
Date:   Sat, 19 Mar 2022 13:23:50 +0800
Message-Id: <20220319052350.26535-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define of skb_list_walk_safe(first, skb, next_skb) is:
  for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
     (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)

Thus, if the 'segs' passed as 'first' into the skb_list_walk_safe is NULL,
the loop will exit immediately. In other words, it can be sure the 'segs'
is non-NULL when we run inside the loop. So just remove the unnecessary
NULL check.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 50ac3ee2577a..424160dd650c 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2903,12 +2903,10 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-			if (segs != NULL) {
-				curr = segs;
-				segs = next;
-				curr->next = NULL;
-				dev_kfree_skb_any(segs);
-			}
+			curr = segs;
+			segs = next;
+			curr->next = NULL;
+			dev_kfree_skb_any(segs);
 			goto drop;
 		}
 	}
-- 
2.17.1

