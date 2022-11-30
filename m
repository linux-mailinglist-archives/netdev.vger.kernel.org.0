Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4543D63D603
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiK3MxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiK3MxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:53:15 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0B73D934
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:53:13 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id bj12so41015563ejb.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 04:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kUL+fnkYqREMTmf+lv/PPYO5I8gGFAOnXhiQuCwpEo=;
        b=GhlC0hyYoYVGN0GtPRXJCBtacUcXZLEKZljouBMFysXnIcFTkTXevfclhr/71+7zIq
         0I0Ff7fuXkH0UZv0/ihHRTwfTMc5oJIxbjMvJAZx0NGbmLVSlC1bNirqbfhh+mk/TP9f
         gxUsEb8BM0D+lmgNE4S//Gugya0ZMzAuE9dy2huh41LIdjJ/rB5D77KSYi+UJaMK+dWz
         SglBQ9I5qrY1aazRJjmR1BhpdJ3pIV8FPN+qbJ9HeE3LU3MT1YksBTcMXRVgJBUxqX5Q
         0LnLF6v9MB81e8PtV6ctHD2MLnFN7Jn0uJ5WR54JK0qPJgCU7q6nu20zZp8dkAPxlIA/
         VT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kUL+fnkYqREMTmf+lv/PPYO5I8gGFAOnXhiQuCwpEo=;
        b=hI60PwtGyzXRLcZsPYjLMFtxpzi7aCtb5ql5+aVT3Rop4Q4WZCvfJU/AHvOUf8iSlQ
         KjEDk/l6ZhjbWJCjoTe802/R4MDT56rhXPRhbGtoQnzwMrnvwzhkkv+EzZ0Sdyq7F9eA
         9c3ubrheDYCjyj61OhNeTmV68fSD20kVF3qyEJ0t1gY46hkxsienvh/TxRj9/O8EDSNy
         wKljnAbRRtxUt4EyIduvG86VZoZ7yATViZX6TrANNS5+/SnRmVMJGU1H3YpX2ZlKXZAP
         yoEubJxEnmLgRw7xYrXIxZpp8l41oCanmCLe0olG8IE+3G2CA0JEHc5jTmC2oAMTZ2Kv
         rv1g==
X-Gm-Message-State: ANoB5plIMoA1+izAf+J4rKXZwGYz/uIKhc9IYdOMv2h9t8mmk+Rao+Km
        NJttI4A1NE2bhUTQMud5vBA=
X-Google-Smtp-Source: AA0mqf6hoRbtvNNy6OHt8tKsTionIta/g3rWAAY0vP0pZC6F7x2vMURiN+S31H1YA5chERYSMbkirw==
X-Received: by 2002:a17:906:a050:b0:78d:47c8:e80f with SMTP id bg16-20020a170906a05000b0078d47c8e80fmr52277809ejb.700.1669812792373;
        Wed, 30 Nov 2022 04:53:12 -0800 (PST)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709063bc100b007ad84cf1346sm608426ejf.110.2022.11.30.04.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 04:53:12 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v2 1/3] ethtool: add tx aggregation parameters
Date:   Wed, 30 Nov 2022 13:46:14 +0100
Message-Id: <20221130124616.1500643-2-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221130124616.1500643-1-dnlplm@gmail.com>
References: <20221130124616.1500643-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the following ethtool tx aggregation parameters:

ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES
Maximum size in bytes of a tx aggregated block of frames.

ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES
Maximum number of frames that can be aggregated into a block.

ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS
Time in usecs after the first packet arrival in an aggregated
block for the block to be sent.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
v2
- Replaced the generic 'size' word with 'bytes' in the related ETHTOOL define
- Changed all the names making the word 'aggr' to follow 'tx'
- Improved documentation on the feature in ethtool-netlink.rst
---
 Documentation/networking/ethtool-netlink.rst | 17 +++++++++++++++
 include/linux/ethtool.h                      | 12 ++++++++++-
 include/uapi/linux/ethtool_netlink.h         |  3 +++
 net/ethtool/coalesce.c                       | 22 ++++++++++++++++++--
 4 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index bede24ef44fd..ac51a01b674d 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1002,6 +1002,9 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr packets size, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr pkts, Tx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
@@ -1020,6 +1023,17 @@ each packet event resets the timer. In this mode timer is used to force
 the interrupt if queue goes idle, while busy queues depend on the packet
 limit to trigger interrupts.
 
+Tx aggregation consists of copying frames into a contiguous buffer so that they
+can be submitted as a single IO operation. ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``
+describes the maximum size in bytes for the submitted buffer.
+``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES`` describes the maximum number of frames
+that can be aggregated into a single buffer.
+``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS`` describes the amount of time in usecs,
+counted since the first packet arrival in an aggregated block, after which the
+block should be sent.
+This feature is mainly of interest for specific USB devices which does not cope
+well with frequent small-sized URBs transmissions.
+
 COALESCE_SET
 ============
 
@@ -1053,6 +1067,9 @@ Request contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr packets size, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr pkts, Tx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9e0a76fc7de9..a1ff1ca0a5b6 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -217,6 +217,9 @@ __ethtool_get_link_ksettings(struct net_device *dev,
 struct kernel_ethtool_coalesce {
 	u8 use_cqe_mode_tx;
 	u8 use_cqe_mode_rx;
+	u32 tx_aggr_max_bytes;
+	u32 tx_aggr_max_frames;
+	u32 tx_aggr_time_usecs;
 };
 
 /**
@@ -260,7 +263,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
 #define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
 #define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
+#define ETHTOOL_COALESCE_TX_AGGR_MAX_BYTES	BIT(24)
+#define ETHTOOL_COALESCE_TX_AGGR_MAX_FRAMES	BIT(25)
+#define ETHTOOL_COALESCE_TX_AGGR_TIME_USECS	BIT(26)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(26, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -288,6 +294,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 #define ETHTOOL_COALESCE_USE_CQE					\
 	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
+#define ETHTOOL_COALESCE_TX_AGGR		\
+	(ETHTOOL_COALESCE_TX_AGGR_MAX_BYTES |	\
+	 ETHTOOL_COALESCE_TX_AGGR_MAX_FRAMES |	\
+	 ETHTOOL_COALESCE_TX_AGGR_TIME_USECS)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index aaf7c6963d61..ea686f37f158 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -398,6 +398,9 @@ enum {
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
 	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
 	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
+	ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES,		/* u32 */
+	ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS,		/* u32 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
diff --git a/net/ethtool/coalesce.c b/net/ethtool/coalesce.c
index 487bdf345541..e405b47f7eed 100644
--- a/net/ethtool/coalesce.c
+++ b/net/ethtool/coalesce.c
@@ -105,7 +105,10 @@ static int coalesce_reply_size(const struct ethnl_req_info *req_base,
 	       nla_total_size(sizeof(u32)) +	/* _TX_MAX_FRAMES_HIGH */
 	       nla_total_size(sizeof(u32)) +	/* _RATE_SAMPLE_INTERVAL */
 	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_TX */
-	       nla_total_size(sizeof(u8));	/* _USE_CQE_MODE_RX */
+	       nla_total_size(sizeof(u8)) +	/* _USE_CQE_MODE_RX */
+	       nla_total_size(sizeof(u32)) +	/* _TX_AGGR_MAX_BYTES */
+	       nla_total_size(sizeof(u32)) +	/* _TX_AGGR_MAX_FRAMES */
+	       nla_total_size(sizeof(u32));	/* _TX_AGGR_TIME_USECS */
 }
 
 static bool coalesce_put_u32(struct sk_buff *skb, u16 attr_type, u32 val,
@@ -180,7 +183,13 @@ static int coalesce_fill_reply(struct sk_buff *skb,
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
 			      kcoal->use_cqe_mode_tx, supported) ||
 	    coalesce_put_bool(skb, ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
-			      kcoal->use_cqe_mode_rx, supported))
+			      kcoal->use_cqe_mode_rx, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES,
+			     kcoal->tx_aggr_max_bytes, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES,
+			     kcoal->tx_aggr_max_frames, supported) ||
+	    coalesce_put_u32(skb, ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS,
+			     kcoal->tx_aggr_time_usecs, supported))
 		return -EMSGSIZE;
 
 	return 0;
@@ -227,6 +236,9 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
 	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
 	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= NLA_POLICY_MAX(NLA_U8, 1),
 	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES] = { .type = NLA_U32 },
+	[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS] = { .type = NLA_U32 },
 };
 
 int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
@@ -321,6 +333,12 @@ int ethnl_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX], &mod);
 	ethnl_update_u8(&kernel_coalesce.use_cqe_mode_rx,
 			tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_aggr_max_bytes,
+			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_aggr_max_frames,
+			 tb[ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES], &mod);
+	ethnl_update_u32(&kernel_coalesce.tx_aggr_time_usecs,
+			 tb[ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS], &mod);
 	ret = 0;
 	if (!mod)
 		goto out_ops;
-- 
2.37.1

