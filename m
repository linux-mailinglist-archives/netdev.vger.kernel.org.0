Return-Path: <netdev+bounces-8621-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C713F724E62
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 824C1280AC0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B42924E9A;
	Tue,  6 Jun 2023 20:59:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3672F46BE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 20:59:50 +0000 (UTC)
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5147C1717
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:59:48 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-977d0288fd2so511906166b.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 13:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1686085187; x=1688677187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyEypgMHs16jFFVDrTGDhZ6nW/XpKqv3equcjRN5BJA=;
        b=QPClDo6ZA6CejESsGMTdCDvR7+4nHdJYsqsQkE+DQ3ArNSRnPp98JbqmCYgNQSr1Eb
         MAKE/x91DKjFM+gohZx9RLkx5Go29Hr0JP0O5/Ar6VXgp2tLyO+CbyOUhDcxSgEW80Qb
         kA1Xs1ze1kUAaNR6o2lcCaNS4rXr3R1H/Du4JtDlskmHYYaf+St7ZhpFytpRjj2mJaUl
         vbPcmdTa9YkYviRQnt7ewYftKDE8b51ONIxVbpJppVuf0qKaAhQB52CKOTQibZVsHfBh
         8+Or97pqek8ghVA922Vcg2bt2W9aFv5HUEbmjaZYkKzxoeSO5wfOv0iho5sR6Ahqs9/Z
         GUsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686085187; x=1688677187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QyEypgMHs16jFFVDrTGDhZ6nW/XpKqv3equcjRN5BJA=;
        b=eJ3Ue5inwKCR5+Q6qx6aqzt+O8uQNfiBNVbHTg07gvbWyFwErgucSVIBDmS0hVncb9
         0c5cTB7NcTfpKsDQctKnCj6rtntJO8jzfsVovW1grTKgrVLYhb+dgbBXElOW/62e2+l2
         sKJFtS8G0WYo/Bn6anwXdwN/Nay8lBC6VXvVA+9G3qM4EMmGVuxzFobbcLFNlzjVjZ1n
         6jmlietuB7zpxQm2vxd6O4tftLqKpzqJwVjiz78fS+crGl9sI8d60ivyDZqmuQucWhh8
         y7TnY1k7z3lQ0cZIo5arFPXJFUhj0ZWHQpVnIs0xtM5rNafYdTS5Eeen/wdII90Vpyfz
         oDww==
X-Gm-Message-State: AC+VfDwc8Y5Wtrd6F6qIZZoF+9APuQTj/GmaYV7chyFPWe/GvP1NOTDw
	dHl61+ypAwM5fZQaWNnblGerOvJM1eRIeg==
X-Google-Smtp-Source: ACHHUZ4j0kbuBFCjborja/VjPwePCvBz5Fog5d7vDkXRSjWjRZGSR+vcnt+U1lttAh3cPhXvGSzjjw==
X-Received: by 2002:a17:907:6e89:b0:977:4b19:974 with SMTP id sh9-20020a1709076e8900b009774b190974mr4184151ejc.19.1686085186513;
        Tue, 06 Jun 2023 13:59:46 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id l1-20020a17090615c100b0096a742beb68sm5926162ejd.201.2023.06.06.13.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 13:59:46 -0700 (PDT)
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
Subject: [PATCH net-next v6 1/3] net: flow_dissector: add support for cfm packets
Date: Tue,  6 Jun 2023 22:59:33 +0200
Message-ID: <20230606205935.570850-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230606205935.570850-1-zahari.doychev@linux.com>
References: <20230606205935.570850-1-zahari.doychev@linux.com>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
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


