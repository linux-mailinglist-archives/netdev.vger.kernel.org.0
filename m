Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F34F6EE97A
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236353AbjDYVQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbjDYVQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:16:45 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4612685
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-957dbae98b4so679669266b.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1682457403; x=1685049403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEAEpgawb0fihVIbfq9hAFx1mIhUit3COHV/bqBn2XA=;
        b=b+nkOVtHw+MUx0iFPGBZz9fLRZcSeKmfFxOp1qZOMW5z/jDQxDZtTJIGQEyH2PAUvm
         7PXAB/bn36N9eLwZ82XyqriYHrZJlex4SwxKlNvesmiD7hpcVYcowPnW8ewd7DZl4PBH
         Y4tQnCDjWLfcyHrvhB4NA1XavJsBUnXkzEcMmJc1UzTzZT4mtUZCBKp14cIpKsiQIzOi
         mV/+IQFdFO5onohHdBxIQFl0xsNA7+b6KVhq4UfLPGgCWO5BQa19afOmfa9BPkwf751n
         LAGHc9gl1KY8iOX5O60iAgOitntCiIgFos270ffF9qFYu5I47xjB6sT0P5sQ6WINnmWb
         OTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682457403; x=1685049403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CEAEpgawb0fihVIbfq9hAFx1mIhUit3COHV/bqBn2XA=;
        b=ONMVFc6Oc67RL8gLT5R/KPDAi3uY6AhKA2MuO+Qa9ZXKUSqlVEbuG8KJuWLEq24vn1
         x2PV2+h/eeBEFjZWskFLpEQN7CbZd7MDKga+rPqs/Imv6y1eioQMyECuO6mr2J6ybbqW
         PscSZGLSacV5+Ze3JarshVExO13Te+NRodc7lOLScKPGSq0rHamuYlK6BgKIbeIFo+WQ
         S7kHc90jasmfKlPCEQ4Hs9AglnMLZGm3sEYfcxCCjzHWcZi3SaoDqoe3LkpPw73jz7dd
         6V28aFFT1+eKuTRv057FG0b46hOMWtdYMHcEGa4bh5wsDPphDgLtzvCQJ/S7tsb7U93w
         8rHw==
X-Gm-Message-State: AAQBX9eowmYz6/usGe+rqrCywyunTiq2AmA55sF1o0An2nYhgLQQFiRa
        4sySNj8/WyNTEdBT4qiDIy0EZjYQUaTJGg==
X-Google-Smtp-Source: AKy350YL9ao9MCNiT8Cd7bErMcRQMTj/d6tChNniiKqQZyGPAhZby351zpkTT2MrfJiRXleT0ioymw==
X-Received: by 2002:a17:906:9c8f:b0:959:5407:3e65 with SMTP id fj15-20020a1709069c8f00b0095954073e65mr7841499ejc.55.1682457402537;
        Tue, 25 Apr 2023 14:16:42 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bv7-20020a170907934700b00959c6cb82basm2302896ejc.105.2023.04.25.14.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 14:16:42 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        idosch@idosch.org, Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v4 1/3] net: flow_dissector: add support for cfm packets
Date:   Tue, 25 Apr 2023 23:16:28 +0200
Message-Id: <20230425211630.698373-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425211630.698373-1-zahari.doychev@linux.com>
References: <20230425211630.698373-1-zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

Add support for dissecting cfm packets. The cfm packet header
fields maintenance domain level and opcode can be dissected.

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/flow_dissector.h | 20 ++++++++++++++++++++
 net/core/flow_dissector.c    | 30 ++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 85b2281576ed..479b66b11d2d 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -299,6 +299,25 @@ struct flow_dissector_key_l2tpv3 {
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
@@ -331,6 +350,7 @@ enum flow_dissector_key_id {
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

