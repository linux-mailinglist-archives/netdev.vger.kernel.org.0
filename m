Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA955A4ABB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 13:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiH2LuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 07:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbiH2Ltq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 07:49:46 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323478B2D1;
        Mon, 29 Aug 2022 04:32:54 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id x19so6007856pfr.1;
        Mon, 29 Aug 2022 04:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=pBLLGEGYnktZSeTxTWcGt32QrgAx7yVlLK4MjY1qqhI=;
        b=ne5d51L9xjEKs7DdRagSRjMWmJdrKnT4+ZCYielLT7zYOqPWHqnyekjpB+s8YssnmY
         nAkKS48j/zv4Ymbxp2jhiIrh923qqStFaklqrv+MZWXqJIJcGaPKYarg7bScG8de5dXu
         9TURein/V2qkWEFJzd0rnLAv57JzEC0TaQ0VivabE22ARFpvA9egnaEEcnV2ipBdQsJX
         ccSx5kMENmqFAGzvXpLCXkYe0tkLPiYtt523YpFL6cnIVTpy58tkOpyEeE8PB9k9JDOZ
         0rzb+Qbl2zSz5RgKVinchg5gSPsJDejG3W4aAEvbvZV9sBmovj7MAX2UkWsjQILkLQ7E
         AMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=pBLLGEGYnktZSeTxTWcGt32QrgAx7yVlLK4MjY1qqhI=;
        b=GX17oIs3EWn6ieruM3Cm2DS59AhHLKBF0lYDf8WODV1VwjpJ6CMBU7k2DqYUnu6HrP
         S8nC72snQP6j688eIgvvBNXhI1bAbIRHjJMixuNEh0dqdECaFm8HL8knnDEjPMgAKa0g
         c0DtspcHz1ao5dyXT7rCyAr/Ij5xyoQXde3b+w8IEau4r+TfZ25iTJhqoQZ4XV8n2Sz+
         6uiu7hshm93DDC/d+kR3eL7oG537vdDXHZZyP4BYQgtv3HLbjT4y3lVrUgBOzEtU02MS
         adrJgeLqYn5htHpSeCGj6B5wzuJLi393XmhRVbVp5YUoFQzCLYbfobIUAjs3E8FUfu8u
         aO6g==
X-Gm-Message-State: ACgBeo0MD3xy4mWYvKQUvGO5XbCbXVM00b14dsBe8ujjfIf4+B+JbmVV
        fTNKsFgqs/mR0nmA+ci0ZN5wbE5RwMc=
X-Google-Smtp-Source: AA6agR5XQyCzNY1WzDhZvKkWUGQF1sEJ7Yb1v2dBNb+sMJjEBq1+LrTNZhd/G+OU17ymO/VRwgp30g==
X-Received: by 2002:a63:f747:0:b0:429:f993:da06 with SMTP id f7-20020a63f747000000b00429f993da06mr13633553pgk.291.1661772623684;
        Mon, 29 Aug 2022 04:30:23 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 126-20020a620484000000b0053617cbe2d2sm6983286pfe.168.2022.08.29.04.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 04:30:23 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: cui.jinpeng2@zte.com.cn
To:     johannes@sipsolutions.net, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] wifi: nl80211: remove redundant err variable
Date:   Mon, 29 Aug 2022 11:29:53 +0000
Message-Id: <20220829112953.267100-1-cui.jinpeng2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Return value from rdev_set_mcast_rate() directly instead of
taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
---
 net/wireless/nl80211.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dad88d231d56..4f5e5b763a15 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11279,7 +11279,6 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	int mcast_rate[NUM_NL80211_BANDS];
 	u32 nla_rate;
-	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
@@ -11298,9 +11297,7 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 	if (!nl80211_parse_mcast_rate(rdev, mcast_rate, nla_rate))
 		return -EINVAL;
 
-	err = rdev_set_mcast_rate(rdev, dev, mcast_rate);
-
-	return err;
+	return rdev_set_mcast_rate(rdev, dev, mcast_rate);
 }
 
 static struct sk_buff *
-- 
2.25.1

