Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664754F215E
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiDECwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiDECvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:51:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8480E298CAA;
        Mon,  4 Apr 2022 19:25:45 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d15so4366934pll.10;
        Mon, 04 Apr 2022 19:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=s770C6klEms02pbWlMqZ7qzWEPI+Uww/MfxHY8uG4vE=;
        b=Pi6mX9On/6yXOYMtjiBhc3JF8ZWFIRVuB7b32wQWsydrrhfhluarLLBI4GwRpY3nrc
         k9h02aLbUfoEgJSHyDJupyCYlT/lWVPfnn6MXNOHdcr6MtZwIrCvMRNTRpvgauX74wIt
         ZfUHLkiEc/EO3heydgGisZp/s4ZCKV0bGC6YNrIiTUtykoBVBYjUfLRuH5TS46eIpWgm
         d2G++eLTzs7sXcAfpSCzKY3EUTgWExD+E1EN7d2yupU3ynJISX/JQ4QEznEXjmWP0IM+
         ol4kaCMAAQlenisLyJLh2z7BKXpeU1d1BAnEjV04xU7+fkjhfz1sihAuM9m3cvtGo6s6
         zYJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=s770C6klEms02pbWlMqZ7qzWEPI+Uww/MfxHY8uG4vE=;
        b=HveN34a8/lO/LdEv8zjZwjqK+wzaSgucO7KwVwDJT33Lxlkn2yeLQlWrAmqs46DGUW
         8THYFbKTVlrttPyl/zGyNMz/qbw99GVQiV1UkhJyZ9rWH7cvQiSFs8G+mcE/bV2k7Pja
         n4o59I1X5WH8uKQVioEJQ08UHSa2hRqh8Df/LnyfnpOjhHz04m/geHWyoNh671mAwy0U
         VydftvZ3XvpjpnQ2uGX7meQhEzEsvEgbGo4SKmlsJ2cgpecchgRGnxkj9fmnQMsqAmxM
         3wUHvuXI8SmKC7B9PvboLlvxsiPzYem55zPXoydaem3+Ug2QgPHLR/nl8d+diz7NwlTp
         ra/Q==
X-Gm-Message-State: AOAM53134PREd9pzgBBF8tm16TDG48w5pEpHhLuRWUtgornSiHm8NMei
        RD2hyDrSKf8zme5bIcJ0YGnuS8mT5OJejA==
X-Google-Smtp-Source: ABdhPJwmBgrLbIlKAQPHNKz0xTu5okVlttnvouUNoCPFbvhEiveNTyPJzyt3jvsp1cecI/Xmo75sSg==
X-Received: by 2002:a17:902:c745:b0:151:e8fa:629b with SMTP id q5-20020a170902c74500b00151e8fa629bmr671335plq.90.1649117161263;
        Mon, 04 Apr 2022 17:06:01 -0700 (PDT)
Received: from localhost.localdomain ([183.156.181.188])
        by smtp.googlemail.com with ESMTPSA id y4-20020a056a00190400b004fac0896e35sm13600693pfi.42.2022.04.04.17.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 17:06:00 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     christopher.lee@cspi.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [RESEND][PATCH v2] myri10ge: remove an unneeded NULL check
Date:   Tue,  5 Apr 2022 08:05:53 +0800
Message-Id: <20220405000553.21856-1-xiam0nd.tong@gmail.com>
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

