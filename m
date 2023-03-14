Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634606BA0A9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 21:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjCNUZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 16:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbjCNUZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 16:25:07 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0765924BE3
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:05 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id e26-20020a9d6e1a000000b00694274b5d3aso9103797otr.5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678825505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H2PkFhtB5ZubtyL+ATwbxbh9RB/tWz0cSQR+9+zw2VU=;
        b=xcbTz6jjxfOcAncDE0rafYDVRZ1/HYoR1MtoPz5F6Yugj6b9RUz4qiNWItUS2ESiiX
         S02O0dJ4kFrPOi7Hb+u+DQy8Tz9PFGb/Cq9i/uwqLBQxM8PyRfjjUmhjEq7H3bwzSofw
         v/H8YmU0idM+72BWz4zQMlXLINx3pJZIz6A65+2AlscF98VPK9OMMNUaeKQTU6WtWSXd
         c1f/ACqol8YIw22+2NX4G8BV8gOE81FjNxGPlD78ghMCb4dQ7xYWiAtCSu9U5gE97w3Z
         qDz+3vkaVxIm/WE7C2nWco11AX8tkfMqrTTQP0zFWWIEJ7N/f0criF5tUIkBWX2pGu23
         W3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678825505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H2PkFhtB5ZubtyL+ATwbxbh9RB/tWz0cSQR+9+zw2VU=;
        b=DSxO5Vxaf8TK7Ao/t2UTbOg+UY5RhkbCekQPbFNe9LJ0+K1UuIn4vW56/oc0i1C/Gj
         xMjB7wfE8Sj5P8GNUB0r/wvnR8IQbp5jeaJViH6Rvthj5IcGOpILNNSpcisqPpw56ioQ
         Z7B33G8WA2ajQi6qdrLcKRNX9RdYEAMHlwujS0G7sHaNNWOtGeQ33M4zcZawsRmn8Tmq
         6i9TqqgPmhy4D9y7bZ0r5yhWHo6fhRNC/AIzir6Lac/IO1O3CB5o9yOGI63td1JuP1YX
         VtKQXh/8H8wTMvWBqby7F+Ft76SPzK5NKBEn3yYx2HZAsRI0g8a0s4KDqbUR5GTTDrOq
         x/ZA==
X-Gm-Message-State: AO0yUKU9qUtS8sBjXqUPmqg6btVvVoul+O5ESYj09FpBKK8T/rIEcq2x
        A0fJeRqOWrDcJr2IzGxJaDFV2MpPi6jOeUjiPwI=
X-Google-Smtp-Source: AK7set9lbMPO4HZJ1+BDSrilU1huRoPthJ5WMnah1jiiAmBfBOY8Vfzj++gfcHvd8rorjRhIZ8jppw==
X-Received: by 2002:a9d:487:0:b0:696:13be:c37a with SMTP id 7-20020a9d0487000000b0069613bec37amr2012721otm.22.1678825505234;
        Tue, 14 Mar 2023 13:25:05 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:95f9:b8d9:4b9:5297])
        by smtp.gmail.com with ESMTPSA id 103-20020a9d0870000000b00690e783b729sm1509278oty.52.2023.03.14.13.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 13:25:05 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 3/4] net/sched: act_pedit: remove extra check for key type
Date:   Tue, 14 Mar 2023 17:24:47 -0300
Message-Id: <20230314202448.603841-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230314202448.603841-1-pctammela@mojatatu.com>
References: <20230314202448.603841-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netlink parsing already validates the key 'htype'.
Remove the datapath check as it's redundant.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index e6725e329ec1..b09e931f23d5 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -319,37 +319,28 @@ static bool offset_valid(struct sk_buff *skb, int offset)
 	return true;
 }
 
-static int pedit_skb_hdr_offset(struct sk_buff *skb,
-				enum pedit_header_type htype, int *hoffset)
+static void pedit_skb_hdr_offset(struct sk_buff *skb,
+				 enum pedit_header_type htype, int *hoffset)
 {
-	int ret = -EINVAL;
-
+	/* 'htype' is validated in the netlink parsing */
 	switch (htype) {
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_ETH:
-		if (skb_mac_header_was_set(skb)) {
+		if (skb_mac_header_was_set(skb))
 			*hoffset = skb_mac_offset(skb);
-			ret = 0;
-		}
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP4:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_IP6:
 		*hoffset = skb_network_offset(skb);
-		ret = 0;
 		break;
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_TCP:
 	case TCA_PEDIT_KEY_EX_HDR_TYPE_UDP:
-		if (skb_transport_header_was_set(skb)) {
+		if (skb_transport_header_was_set(skb))
 			*hoffset = skb_transport_offset(skb);
-			ret = 0;
-		}
 		break;
 	default:
-		ret = -EINVAL;
 		break;
 	}
-
-	return ret;
 }
 
 TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
@@ -382,10 +373,9 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
 	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 		int offset = tkey->off;
+		int hoffset = 0;
 		u32 *ptr, hdata;
-		int hoffset;
 		u32 val;
-		int rc;
 
 		if (tkey_ex) {
 			htype = tkey_ex->htype;
@@ -394,12 +384,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 			tkey_ex++;
 		}
 
-		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
-		if (rc) {
-			pr_info("tc action pedit bad header type specified (0x%x)\n",
-				htype);
-			goto bad;
-		}
+		pedit_skb_hdr_offset(skb, htype, &hoffset);
 
 		if (tkey->offmask) {
 			u8 *d, _d;
-- 
2.34.1

