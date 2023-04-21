Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1CD6EB39B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjDUV0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbjDUVZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:25:58 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6D8272B
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:52 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-38dfa504391so1525817b6e.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682112351; x=1684704351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JPJ4oLG4sFtQHlowOjfVCKB8UUyQws2m/Bu8cseeYMA=;
        b=231uPKal/NBl55tggGjdVIB1FZqYhhJfONGNxq74WEXbnM0dYGKcD6zXBWtRVF9vBd
         cemUMFyx8WSyPOCLtUsvIx69eg3EpWGLI8rAPk4UGwb2Ls7o/hgN1GACQY5WzZ0Y5M+i
         Hz9KsFenI02q/RSSc9WpU8gFMpbHPSKByPECo3fth+288KMIdAgrV2SAXwJo0Z0UlI54
         Lp/ncw/phpxPVPtO/obz+xaTti31ax3797/oBX1/xayoAVfKU1M30S9b5wxTrtBaZsp6
         hdE1lbX6yficWdY9V3db6DlWbfrZOor57MnbqQV0XboVKhp+j+15/hse/8IFBK/kRAVm
         kawQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682112351; x=1684704351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JPJ4oLG4sFtQHlowOjfVCKB8UUyQws2m/Bu8cseeYMA=;
        b=AQLrLblHDWk29AlCfDka3VvxW3LqQpT0aAoDw3+hNa1N1AxIoM+TwSrJ06ZqijxjIo
         q4KiSf37NvC6JFk8OquH2BrnBTcFLGBkQOkREblaaNv1rtHDYhO7mZse/rogXIAjEN9V
         fGB2yhwyvO5nBJyXsr+Sipbu6vv/AJCxAicWJU0JE1l3nGBW7hF40tZ8VSePWqKIPRzB
         qtMNy02LVLtaT3fJhBCfvenMBW0cWkZxPV1abcfNQb64IjKdLlirih9wX2f48d0M2tQR
         B26AFDp+cFDFdb6nJii8PvTExgT0f+pbaP6Zec8RBym37dw0kzrjaDGtq1XYEHU9QVeP
         Rabg==
X-Gm-Message-State: AAQBX9eEGOXpunodCa/ZmBgFV6gi495kGLwP2iLKUUIhtpNJ8pSE9C9d
        /ltvwQzxOSpXlUVf3q/IPLmHwrBuK32HyL6yqfg=
X-Google-Smtp-Source: AKy350bRcohqnG/hq+dQBwBda8V9MlliP0iJ5JWm2fLLDEaXL3Epfww8HVCbdyhlkEU01oqCQ9hBSw==
X-Received: by 2002:aca:646:0:b0:38d:e7a6:5a68 with SMTP id 67-20020aca0646000000b0038de7a65a68mr3277835oig.15.1682112351260;
        Fri, 21 Apr 2023 14:25:51 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id j11-20020a4a888b000000b00524fe20aee5sm2147663ooa.34.2023.04.21.14.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:25:51 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 4/5] net/sched: act_pedit: remove extra check for key type
Date:   Fri, 21 Apr 2023 18:25:16 -0300
Message-Id: <20230421212516.406726-5-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421212516.406726-1-pctammela@mojatatu.com>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index cc4dfb01c6c7..2fec4473d800 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -325,37 +325,28 @@ static bool offset_valid(struct sk_buff *skb, int offset)
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
@@ -388,10 +379,9 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
 
 	for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 		int offset = tkey->off;
+		int hoffset = 0;
 		u32 *ptr, hdata;
-		int hoffset;
 		u32 val;
-		int rc;
 
 		if (tkey_ex) {
 			htype = tkey_ex->htype;
@@ -400,12 +390,7 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
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

