Return-Path: <netdev+bounces-7756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1100B72167C
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 13:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2C11C209C9
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB607538D;
	Sun,  4 Jun 2023 11:58:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FCD525C
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 11:58:41 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1637DC
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 04:58:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-977c72b116fso158036766b.3
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 04:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1685879918; x=1688471918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCcosYCHd/XDPNokbGnd37kSTJfadMM1wXb8Sbc9+80=;
        b=LNbKPuXewMcN1EJPel65quQD5L97ZmtK3GvCwpBzihkC39U/OMLsXZGcZOF1AEb9dm
         eVh+IAgo/43JBiBNvHeUJZPXkXBQRKnB04B9AffWuO63rPowqTG0nqDN4aF4xSw+tF2g
         eD0CWhfba74IVo/tWQ1LRv30AJa/huj1JNaS1HckqweAkskinuE+mtrhCnidUpONqP1h
         7AZXFdlMzmhxJ+KaEnLucaK1Ml4rbAI8BOPnOYJBio0IvXj3yVxZad2tIgzlYTP8/kwf
         H5eL1sypVaHYXEVAmvags8KmlYX+iJa9I7JYnpOlk6D2MJckZo3IAumj+aoMSJ2kBimF
         BaHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685879918; x=1688471918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SCcosYCHd/XDPNokbGnd37kSTJfadMM1wXb8Sbc9+80=;
        b=B5C7advexMe+20ggNTii0/SsJFuWUmvpqv4gWKonoGZpYM4rCIQ3YPxrI/yIyU/ogf
         G9Wj0eylF8Fa04VZ+x8tktYcRMxdQRj2P4O50oUQefOq3fKmBt+Zn5LAZNKqq3YZ/tG4
         U4DY4yePnAD1drAue0N8G2eubljFWRRFjTTdJhJDkWgqNMe6ILCeKKw03ysDvEyVWIFW
         CX+FNiTQTUD2i/3+4axz2B35NYJT1haBRcitwwDq+GdeL4S5zjmPYy1/mCrPsJ+L73pb
         j0HsKC3HGiFy7Emmgc3kzqJ8+MUmdKz2t8aIf4D2rMa6Uv3TpbYlHeVaop8dxzcSWcQ0
         Docw==
X-Gm-Message-State: AC+VfDxxYmq8+oFzxA5qarcpiWF8zx+FQBz/bNjfPdMo1FoOUsoE+2W+
	u4JceIcC8N4GSgIk4hkdvV1VCzELJbJaKg==
X-Google-Smtp-Source: ACHHUZ77xYmv8S/7WARrWOnbDMQrX6uQaxafVNj6Yw7lquZgzNY/LxnTd5Sfw0RjxMRTOiIuD4Y9hQ==
X-Received: by 2002:a17:906:fe05:b0:974:6065:c4be with SMTP id wy5-20020a170906fe0500b009746065c4bemr3262357ejb.21.1685879917968;
        Sun, 04 Jun 2023 04:58:37 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id bc10-20020a056402204a00b00510de087302sm2706489edb.47.2023.06.04.04.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 04:58:37 -0700 (PDT)
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
	Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v5 1/3] net: flow_dissector: add support for cfm packets
Date: Sun,  4 Jun 2023 13:58:23 +0200
Message-Id: <20230604115825.2739031-2-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230604115825.2739031-1-zahari.doychev@linux.com>
References: <20230604115825.2739031-1-zahari.doychev@linux.com>
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
2.40.1


