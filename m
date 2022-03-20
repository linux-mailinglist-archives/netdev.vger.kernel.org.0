Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231C14E19AF
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 05:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244721AbiCTEq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 00:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244713AbiCTEq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 00:46:26 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA135A80;
        Sat, 19 Mar 2022 21:45:04 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id o8so8028180pgf.9;
        Sat, 19 Mar 2022 21:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=s770C6klEms02pbWlMqZ7qzWEPI+Uww/MfxHY8uG4vE=;
        b=k9YKR5Tf7qVAuC1cUWm77yUBOwwc0CbCrfIyggXfvSpC/32ovsPXOy0OJV/8XglEv0
         lHNZbVWeVgLB6M/PfMdgSkGgjDUn0V2IEz+4KSh8heWJEOdcAU+tR2R52BF/htpDFV01
         jUlul/JVNkE57GLLE78mbT0ZED/ARHEplwRYOHkBux0vrdFOspWowqjDywZrRs5KroCP
         OYdC5q8PXyzaRQBNOnbGdA5VRbYgVLX1leyl/7XGeRDc44JOlz4o0kPaaeACW4jIk5TJ
         /VfQZOaD7FBkyiDgQg+oOfRB7b2ObkXE7bL48UbNnMDyc332bodgcRARZvt2iiC2F8ZW
         eEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s770C6klEms02pbWlMqZ7qzWEPI+Uww/MfxHY8uG4vE=;
        b=oa+jdSNSO1dKFoexSdFRhRw/MfLZiJ5jacAERZEXv+8r5yHHdF6Eq1V2fWzD+1M6Qe
         XA/XQf/8uNTzgBTG61i0FM7PpRpVh6fiauEPke9CVsL6t3DHwRW8PUllQKCOa8mjpi8z
         qlppUhb7ESrwU2blhl4H7aMQnrF8Y51YiWrauU6QYXsqrFfBo/mVGUhokzyB54Q+awjL
         K78Nt2a7/EPZoSo/OWxkI6ybprsXj7dMk8YXZ04od2lbxWr3pNFC8xr+sJaBMVMNBTUb
         srn+NQWpMVQAySClJpBGKX+bRm82PKESiCxz3AjMMqIyL1Cs/ObV/vDWlffYXYjLilGZ
         4qDg==
X-Gm-Message-State: AOAM530e9BpGEMnTw+t/LxCH65+gCx8D2w4cQvXWVi7/DWVTnRzvm8zI
        PcaxQw50bbYY3Hkj9NjQNyM=
X-Google-Smtp-Source: ABdhPJyZWbaHloV4cvyTYd9gMf3UeNVpHyzScqPG05ZRjHgvljJYu1oRJQy/4CJPo8RCghCt/zikJw==
X-Received: by 2002:a63:5409:0:b0:382:7e1:db0c with SMTP id i9-20020a635409000000b0038207e1db0cmr12121080pgb.204.1647751503605;
        Sat, 19 Mar 2022 21:45:03 -0700 (PDT)
Received: from localhost.localdomain ([36.24.165.243])
        by smtp.googlemail.com with ESMTPSA id na8-20020a17090b4c0800b001bf191ee347sm17160560pjb.27.2022.03.19.21.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 21:45:03 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     christopher.lee@cspi.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jakobkoschel@gmail.com, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v2] myri10ge: remove an unneeded NULL check
Date:   Sun, 20 Mar 2022 12:44:57 +0800
Message-Id: <20220320044457.13734-1-xiam0nd.tong@gmail.com>
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
NULL check. Also remove the unneeded assignmnets.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
changes since v1:
 - remove the unneeded assignmnets.

v1: https://lore.kernel.org/lkml/20220319052350.26535-1-xiam0nd.tong@gmail.com/
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 50ac3ee2577a..071657e3dba8 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2903,12 +2903,8 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-			if (segs != NULL) {
-				curr = segs;
-				segs = next;
-				curr->next = NULL;
-				dev_kfree_skb_any(segs);
-			}
+			segs->next = NULL;
+			dev_kfree_skb_any(next);
 			goto drop;
 		}
 	}
-- 
2.17.1

