Return-Path: <netdev+bounces-9194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD9C4727D5A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 988D42816E8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B821095B;
	Thu,  8 Jun 2023 10:57:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B738810958
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:57:03 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BB62697
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:57:01 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5149e65c218so801214a12.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 03:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686221820; x=1688813820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyEypgMHs16jFFVDrTGDhZ6nW/XpKqv3equcjRN5BJA=;
        b=bKYrP0hKUo8Sq5QjloFoMz9nGnXUbLKBqhkGXalf0iOrGnvgjp9l6uyTK6XoJ5Lruh
         f8y11YjvkqMc/Q6m1JQ41qVsZLuewxGrZpJJ9fa9hWlH87xW/wSXLrzuFsoh+WxzvmVX
         QgHmWT6NhA802qfTsFm0pFTDfIWI/EVrot6vNlfAZOe8zwwJsDUqA0rdfgLu8VEIwRhc
         gJYfzwRqkCGoJA9SCFsqn4fSIavkNjva7qYuTac7zUQd7bQEqfLTiWNGSpjl7rRwV+5J
         VTOeUmHcI7CWHdzQnlL+6LDzyBUYeSzAgGVihLnLIeY5Hjw27RgmsVRB8xMPCdEiH3Zx
         Mdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686221820; x=1688813820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QyEypgMHs16jFFVDrTGDhZ6nW/XpKqv3equcjRN5BJA=;
        b=E5hwsN27pP6k1CmYrx+gGJ16GWcVl7Yz8ioOv5Y9bsR22NuuT6KKFIQ0CAwg6zwaPJ
         R7SDi3d+g61NIBjr8KPb4JVna7/DziqRjrBRLWVFSGUkLHSZR+7yyKl3iYgUUdETvyvM
         EHay5x3ckfBFIa3mOdMco7YD152k4munT/mDBJHi/8xcMpNvK9j375OVTWOjQNOwHYFW
         A16i5EiovK6s+IOulDkyFvy2eC4hYIZREZ3HKw6WB0S27tzVStmdYE0w1kusWv1FkTXB
         pl9nu65ue/b6I/i28JKWAwb6g2Mxw6zh2MkNokn4qpjfzSfFc3izY0fcl/yLU8nAzd/W
         wckw==
X-Gm-Message-State: AC+VfDxK8G5R3zSEQxYYXNsTyJDCFkGYCtZt83zPGX2IwYjRaUjLvWuA
	lUxuq+S9Npg9ehp3T1xTSd6N5jGFH8jlKQ==
X-Google-Smtp-Source: ACHHUZ60DxB4BfS5a+NtpygWcbRK4EUYuwAZZkhGWGBmNDvP0jPCW8YsW+3I4dkHgtz8izJ+jlSUuw==
X-Received: by 2002:a17:907:72c9:b0:977:abac:9635 with SMTP id du9-20020a17090772c900b00977abac9635mr8277942ejc.20.1686221819913;
        Thu, 08 Jun 2023 03:56:59 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id t23-20020a1709064f1700b0094f07545d40sm522719eju.220.2023.06.08.03.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 03:56:59 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From: Zahari Doychev <zahari.doychev@linux.com>
To: netdev@vger.kernel.org
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	hmehrtens@maxlinear.com,
	aleksander.lobakin@intel.com,
	simon.horman@corigine.com,
	idosch@idosch.org,
	Zahari Doychev <zdoychev@maxlinear.com>,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v7 1/3] net: flow_dissector: add support for cfm packets
Date: Thu,  8 Jun 2023 12:56:46 +0200
Message-ID: <20230608105648.266575-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230608105648.266575-1-zahari.doychev@linux.com>
References: <20230608105648.266575-1-zahari.doychev@linux.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Zahari Doychev <zdoychev@maxlinear.com>

Add support for dissecting cfm packets. The cfm packet header
fields maintenance domain level and opcode can be dissected.

Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_dissector.h | 21 +++++++++++++++++++++
 net/core/flow_dissector.c    | 30 ++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 8b41668c77fc..8664ed4fbbdf 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -301,6 +301,26 @@ struct flow_dissector_key_l2tpv3 {
 	__be32 session_id;
 };
 
+/**
+ * struct flow_dissector_key_cfm
+ * @mdl_ver: maintenance domain level (mdl) and cfm protocol version
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
+#define FLOW_DIS_CFM_MDL_MAX 7
+
 enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_CONTROL, /* struct flow_dissector_key_control */
 	FLOW_DISSECTOR_KEY_BASIC, /* struct flow_dissector_key_basic */
@@ -333,6 +353,7 @@ enum flow_dissector_key_id {
 	FLOW_DISSECTOR_KEY_NUM_OF_VLANS, /* struct flow_dissector_key_num_of_vlans */
 	FLOW_DISSECTOR_KEY_PPPOE, /* struct flow_dissector_key_pppoe */
 	FLOW_DISSECTOR_KEY_L2TPV3, /* struct flow_dissector_key_l2tpv3 */
+	FLOW_DISSECTOR_KEY_CFM, /* struct flow_dissector_key_cfm */
 
 	FLOW_DISSECTOR_KEY_MAX,
 };
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 481ca4080cbd..85a2d0d9bd39 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -557,6 +557,30 @@ __skb_flow_dissect_arp(const struct sk_buff *skb,
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
+	return FLOW_DISSECT_RET_OUT_GOOD;
+}
+
 static enum flow_dissect_ret
 __skb_flow_dissect_gre(const struct sk_buff *skb,
 		       struct flow_dissector_key_control *key_control,
@@ -1400,6 +1424,12 @@ bool __skb_flow_dissect(const struct net *net,
 		break;
 	}
 
+	case htons(ETH_P_CFM):
+		fdret = __skb_flow_dissect_cfm(skb, flow_dissector,
+					       target_container, data,
+					       nhoff, hlen);
+		break;
+
 	default:
 		fdret = FLOW_DISSECT_RET_OUT_BAD;
 		break;
-- 
2.41.0


