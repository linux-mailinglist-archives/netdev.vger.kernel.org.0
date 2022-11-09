Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AECF623214
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiKISJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKISJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:09:26 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722081C41A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:09:25 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bj12so48918612ejb.13
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 10:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4zL1hfmtgQMnqgdfJLzIDEINdeloTLiy6lXdpMwhNEI=;
        b=CFitsk7sgicEAAsX7oCrEpTfMyvgR7yWIGpS7KEL2GHgrCd5ynsA63AiZRij9JOZGi
         Jg1JT/dkpk5twfBvle2r+RPaB3+qgSiZWx2qDrkiGmvtpCp+tIe988HdoGaG12gZf8Bn
         FGn47tZYyTCMW22O9rlIqK4ykgOLtTthLBoTCZMSFQQcZ+ka3X5xrMhRChC9spqAbvxG
         RVuJsxy3pc3jFz4TDWytDjk0q6aooz57PvLVld+5sbzytxnkQoyQO37/VOGcZtOaZgFC
         rO90cX8wtDZW/hUOd4t93kuwTAdjfi87UK9B71Ej8nd+JckNXzcfvhCMgrjszbIAuXjd
         7sNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4zL1hfmtgQMnqgdfJLzIDEINdeloTLiy6lXdpMwhNEI=;
        b=GmUwYkUbCayQzC8eh5gtDPu5m/eJoaw4mKkZLJMogooCTf3iBnvRc454q7tBmZBhnE
         iC2Ad6ABWhDLZ+5RX9LHm1/K792xGGP2k/M08riqOgOkMgS/l89F8XaARQo06RGR8QHZ
         cfHGdNxvoozfd8bIVrxP2Pj8C1S9bPNa0k5v94ICdbIowv/lNQTNKrnGDxusNkcJtFko
         F4LeHAXCLtYAY3mRAeu84ODxjPZ0Y7bkz3EzPwEhwfjP62Gret5gfG04aMZFne6okATy
         BAAG1vYhrEWd5upGT0Qlcvdzp2tC9xDsCwarVU0L+S+pN/Kx39Dld/Fn5JTGyW9cavcU
         caxw==
X-Gm-Message-State: ACrzQf06IfkLUD5eF4VTnj3jWzsNHOHO4eKCOPqUk8WLFdYvCRBqYkUS
        +CANizEUcbQ1V2N2JH7nPL0=
X-Google-Smtp-Source: AMsMyM5vQrZ9hvPS7BBdrk37P2PJkYVCXal73xlmSe7R3+TGzpYHg9Oip/l8JoSUTqvz1eIPtxUbpg==
X-Received: by 2002:a17:907:2c71:b0:79e:8603:72c6 with SMTP id ib17-20020a1709072c7100b0079e860372c6mr58786595ejc.172.1668017363864;
        Wed, 09 Nov 2022 10:09:23 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id rh16-20020a17090720f000b0077016f4c6d4sm6116311ejb.55.2022.11.09.10.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 10:09:23 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
Date:   Wed,  9 Nov 2022 19:02:47 +0100
Message-Id: <20221109180249.4721-2-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221109180249.4721-1-dnlplm@gmail.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following ethtool tx aggregation parameters:

ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE
Maximum size of an aggregated block of frames in tx.

ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES
Maximum number of frames that can be aggregated into a block.

ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME
Time in usecs after the first packet arrival in an aggregated
block for the block to be sent.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 Documentation/networking/ethtool-netlink.rst |  6 ++++++
 include/linux/ethtool.h                      | 12 ++++++++++-
 include/uapi/linux/ethtool_netlink.h         |  3 +++
 net/ethtool/coalesce.c                       | 22 ++++++++++++++++++--
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d578b8bcd8a4..a6f115867648 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1001,6 +1001,9 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE``      u32     max aggr packets size, Tx
+  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME``    u32     time (us), aggr pkts, Tx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
@@ -1052,6 +1055,9 @@ Request contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE``      u32     max aggr packets size, Tx
+  ``ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME``    u32     time (us), aggr pkts, Tx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 99dc7bfbcd3c..3726db470247 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -203,6 +203,9 @@ __ethtool_get_link_ksettings(struct net_device *dev,
 struct kernel_ethtool_coalesce {
 	u8 use_cqe_mode_tx;
 	u8 use_cqe_mode_rx;
+	u32 tx_max_aggr_size;
+	u32 tx_max_aggr_frames;
+	u32 tx_usecs_aggr_time;
 };
 
 /**
@@ -246,7 +249,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
 #define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
 #define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
+#define ETHTOOL_COALESCE_TX_MAX_AGGR_SIZE	BIT(24)
+#define ETHTOOL_COALESCE_TX_MAX_AGGR_FRAMES	BIT(25)
+#define ETHTOOL_COALESCE_TX_USECS_AGGR_TIME	BIT(26)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(26, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -274,6 +280,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 #define ETHTOOL_COALESCE_USE_CQE					\
 	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
+#define ETHTOOL_COALESCE_TX_AGGR		\
+	(ETHTOOL_COALESCE_TX_MAX_AGGR_SIZE |	\
+	 ETHTOOL_COALESCE_TX_MAX_AGGR_FRAMES |	\
+	 ETHTOOL_COALESCE_TX_USECS_AGGR_TIME)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index bb57084ac524..08872c8ea0d6 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -397,6 +397,9 @@ enum {
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
 	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
 	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
+	ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 487bdf345541..014a7a4f73f2 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -105,7 +105,10 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
 	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_TX */
-	       nla_total_size(sizeof(u8));	/* _USE_CQE_MODE_RX */
+	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_RX */
+	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_AGGR_SIZE */
+	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_AGGR_FRAMES */
+	       nla_total_size(sizeof(u32));	/* _TX_USECS_AGGR_TIME */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -180,7 +183,13 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
 			      kcoal->use_cqe_mode_tx, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
-			      kcoal->use_cqe_mode_rx, supported))
+			      kcoal->use_cqe_mode_rx, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE,
+			     kcoal->tx_max_aggr_size, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES,
+			     kcoal->tx_max_aggr_frames, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME,
+			     kcoal->tx_usecs_aggr_time, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -227,6 +236,9 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= NLA_POLICY_MAX(NLA_U8, 1),
 	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME] = { .type = NLA_U32 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
@@ -321,6 +333,12 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
 	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
 			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_max_aggr_size,
+			 tb[ETHTOOL_A_COALESCE_TX_MAX_AGGR_SIZE], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_max_aggr_frames,
+			 tb[ETHTOOL_A_COALESCE_TX_MAX_AGGR_FRAMES], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_usecs_aggr_time,
+			 tb[ETHTOOL_A_COALESCE_TX_USECS_AGGR_TIME], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.37.1

