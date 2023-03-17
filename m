Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9DF6BF21D
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCQUGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjCQUGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:06:22 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB847CA780
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:09 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-177ca271cb8so6929755fac.2
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679083569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3ulD6Qys0ZfunJDBappONbiScJ689GXwqPtC7oOTRc=;
        b=0gkwx4GvavO5rEpq9NsZkGwn6MxFHEjvwLdfdZFIrnUyb9hPdazXHHDM1bU2mPg61z
         upYYxmseot5gA3jFWpyAI97qvwsQiHxJIup5C3iYUVuHBLw+yss4wNUwCc5zFGbS0wbY
         I+NcugXpWsqvewz8J7UxJW0VKrjpPz0XKerUav2gk0EaxtY7uR3gbr4GsI1mnPu3K0Wm
         ZxoGn3OuoFkhZemOf2+f20TwXEeXW9pTBxQqfD8t8bg2SOCRaoSCuAogg/EtzI5tqod4
         tPiN/qU8qDmT7KPvCWYKRV/9qMZ0CMT9b11bCrHcmhkeH4bjuJgTjli/ZeJbT1VsB86j
         G4yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U3ulD6Qys0ZfunJDBappONbiScJ689GXwqPtC7oOTRc=;
        b=X5Z2B52vKB7bopl7Q86Ra5qtZGV/07EgsZtfQRG5DJPj01tmTsTM4Vbz85QVkmcsWY
         lqcVhaGgjYbPgQHzPZSoExrhgas8P/dOHABM6uFgxO5Rwh7euQX7kLkJxcrnOqmugtB/
         omY0Im/1uYeRV6NNFnbZ890aflRG3Y5HSPshPVjilKYEyvFprJ4vx56KQtfZv4LTySPN
         FbquA5E/6sG9bftaKu6iAH//wcZqa2q/Q1gQnvYqMCSJH1ZG67oJA/xh9jxbLRCT0Ei6
         pNrBFSUr/lDCU2BYNoCMJTl08YoRdjs1kktKLnr6qQRz3HRaGXzo1a7rhHt2gQMMtv2e
         f6FA==
X-Gm-Message-State: AO0yUKVERmLVx6CpAStEBJZKh6X8LPrk10JBX58Sg0mvcxlDCop5Vgbu
        f6FwQtYLEF68Wdw5w5DrvyK6xEH84wiMS0Raxmg=
X-Google-Smtp-Source: AK7set+VsEF/qBn3vtipfPT3YILbISeYqX4+d1wmK3s8bkv4/gb1z2dOddHQPT6IUpnJpp5CRvBJug==
X-Received: by 2002:a05:6871:92:b0:177:9753:f823 with SMTP id u18-20020a056871009200b001779753f823mr463731oaa.20.1679083568827;
        Fri, 17 Mar 2023 13:06:08 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id z8-20020a056830128800b00698a88cfad1sm1304209otp.68.2023.03.17.13.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:06:08 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 3/4] net/sched: act_pedit: remove extra check for key type
Date:   Fri, 17 Mar 2023 16:51:34 -0300
Message-Id: <20230317195135.1142050-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317195135.1142050-1-pctammela@mojatatu.com>
References: <20230317195135.1142050-1-pctammela@mojatatu.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index d780acb44d06..73414cbb6215 100644
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

