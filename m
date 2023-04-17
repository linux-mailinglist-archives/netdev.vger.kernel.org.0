Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB8C6E53E7
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 23:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjDQVcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 17:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjDQVcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 17:32:53 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A8E4EC0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:51 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-506b8c6bbdbso243143a12.1
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1681767170; x=1684359170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BM90YRQwqNZnnjkPWJq7Gxrd9nK6/umT338BzFntPRg=;
        b=YYRPpr10xX50GYpkEfId07D+YFaWViLMbxwwauuDlD/81TBpkZhvuqe9p+Jg7Edm/A
         wmzUFvPyqXleS8Zin+Pdazdcgozg2TEpPppLTNN18DpxG/yLh8cAJNT1FYJ44SLLcYgu
         729ilLcxl4ETY7hGIBkipMMBVE3M15atFoj7f5Aq+HmckfBm1Qh31hbQh/uySm3Eg19v
         ax5KpLM5fJC/nDD+63cvW9v60K0vMIfn+ODxzJRFtisqtqNWoxXFDFC/2YTy+ii+6LRx
         8fByRzoUTv0KktCIzUl57ySBKTNqAhcvkliicsX/Za+n4Z0wm2/PJMPVdvapTjUBKkv+
         wKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681767170; x=1684359170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BM90YRQwqNZnnjkPWJq7Gxrd9nK6/umT338BzFntPRg=;
        b=iID3KjwT/pPtYRwBMna8CaBdwtaM/diDoMbUki4fQtbvj706hYxa8UF8CMW+gPRvUi
         1D2Ex4xig79kg5RJ5WYGjW61zDaPgv9e3DgUsCq5+lv/RRmaNlHLTJRaRyOEJNCl8Igp
         gw7DPNjh4rEMJmpSFtHkJvMNkXvZoubI8s+bJ3FVUIEpQaoeRDKNwUwz52fiblAH3HJE
         lQyuGyWz5f5EeDp6plzgWOUePpKVmrNDvAtSf0dY778GH08nJUEQstPcaXB43vKBlAXI
         8BUBvN2wik9YPqS2AG+4S4GGiPAEhlw/MJZNvfRxusl87AXwd/yLeKMqAd4WBKkxh/Pe
         xzKg==
X-Gm-Message-State: AAQBX9dzf6OMckWFH1eihM/vuJsoZxJIMNRloCicvlgYuWge7S33tCFc
        IcUYGqSMOt2WABzH1EepfPI7yGsebnAwUF2Y
X-Google-Smtp-Source: AKy350bpkiyI6DZA+Amli9EQtJFje31YCF99jEi1Js+5s8j5toolJomeK9fNJalu2ms07rRFsX1iqw==
X-Received: by 2002:aa7:c68e:0:b0:4fe:ddf:8d8c with SMTP id n14-20020aa7c68e000000b004fe0ddf8d8cmr381919edq.13.1681767169678;
        Mon, 17 Apr 2023 14:32:49 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id k18-20020a17090632d200b0094f05fee9d3sm4670005ejk.211.2023.04.17.14.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 14:32:49 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v3 1/3] net: flow_dissector: add support for cfm packets
Date:   Mon, 17 Apr 2023 23:32:31 +0200
Message-Id: <20230417213233.525380-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230417213233.525380-1-zahari.doychev@linux.com>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

Add support for dissecting cfm packets. The cfm packet header
fields maintenance domain level and opcode can be dissected.

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
---
 include/net/flow_dissector.h | 20 ++++++++++++++++++++
 net/core/flow_dissector.c    | 30 ++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 5ccf52ef8809..b6d6d2d36d79 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -297,6 +297,25 @@ struct flow_dissector_key_l2tpv3 {
 	__be32 session_id;
 };
 
+/**
+ * struct flow_dissector_key_cfm
+ * @mdl_ver: maintenance domain level(mdl) and cfm protocol version
+ * @opcode: code specifying a type of cfm protocol packet
+ *
+ * See 802.1ag, ITU-T G.8013/Y.1731
+ *         1               2
+ * |7 6 5 4 3 2 1 0|7 6 5 4 3 2 1 0|
+ * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
+ * | mdl | version |     opcode    |
+ * +-----+---------+-+-+-+-+-+-+-+-+
+ */
+struct flow_dissector_key_cfm {
+	u8	mdl_ver;
+	u8	opcode;
+};
+
+#define FLOW_DIS_CFM_MDL_MASK GENMASK(7, 5)
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -329,6 +348,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
 	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
 	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
+	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 25fb0bbc310f..62cc1be693de 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -547,6 +547,30 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
 	return FLOW_DISSECT_RET_OUT_GOOD;
 }
 
+static enum flow_dissect_ret
+__skb_flow_dissect_cfm(const struct sk_buff *skb,
+		       struct flow_dissector *flow_dissector,
+		       void *target_container, const void *data,
+		       int nhoff, int hlen)
+{
+	struct flow_dissector_key_cfm *key, *hdr, _hdr;
+
+	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_CFM))
+		return FLOW_DISSECT_RET_OUT_GOOD;
+
+	hdr = __skb_header_pointer(skb, nhoff, sizeof(*key), data, hlen, &_hdr);
+	if (!hdr)
+		return FLOW_DISSECT_RET_OUT_BAD;
+
+	key = skb_flow_dissector_target(flow_dissector, FLOW_DISSECTOR_KEY_CFM,
+					target_container);
+
+	key->mdl_ver = hdr->mdl_ver;
+	key->opcode = hdr->opcode;
+
+	return  FLOW_DISSECT_RET_OUT_GOOD;
+}
+
 static enum flow_dissect_ret
 __skb_flow_dissect_gre(const struct sk_buff *skb,
 		       struct flow_dissector_key_control *key_control,
@@ -1390,6 +1414,12 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
+	case htons(ETH_P_CFM): {
+		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
+					       target_container, data,
+					       nhoff, hlen);
+		break;
+	}
 	default:
 		fdret = FLOW_DISSECT_RET_OUT_BAD;
 		break;
-- 
2.40.0

