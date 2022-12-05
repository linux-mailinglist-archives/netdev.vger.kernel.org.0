Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BBC6425F4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiLEJm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiLEJmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:42:55 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7182733
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:42:51 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id x22so3965992ejs.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wzCbwTmalrcR17aMh+RsTIbsc3seWGruGKr8c9o0AK8=;
        b=IaMndO1Lh/t6rY9xQRCOKyhBFmv6PaO/ZNiKq032OnAKqNQfvOcFsG9oz/lQXnp3pR
         Of20cpH281QF/sSRGHS5L0rMfVfz5X0J08x/SRgElCGCcCfFw7sf6+W/8QzxWI1GuzHa
         lZ53udny4TM6o8D/pwboSllEYd8Eg0EjBnLdDkqXOSkIJ0tswFQzGthloy3hYWbIr/rp
         d5nYqq4vei15anfaQDh5SztCy+p22hPtvIfZmTqEZKjH7bgup2X+woYvrCJjDTq5/UW3
         fp734DdDaLSGx3jFQBuFoTkV7H6F56U3q6MAPbe006CQwS6Ln0RImgBsdwG20CJZQJsM
         2CzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wzCbwTmalrcR17aMh+RsTIbsc3seWGruGKr8c9o0AK8=;
        b=6/TcinrQyALB2upw8T1YBzgegEzCBKamig1qKrzgj73tWME6GFGwvOnzqZVJWOj/aV
         BaH0ldI3QDHkpgVjsCIECBRGZwo6t8X+1ch8Ds6ysFkQ2sR44jVNAgvVphWP/IAAcvrk
         UgeFLUOMX/sRhPB1eEPYGym5uoD+JlyXwsCaPN5J3h8DmbGXqIaDpFfQDiI5R+k4qhIn
         O1EIOAF2AxVoYNIc1S2XYICdopiFSFmqxqf3sAWRkK4+zrEUfhvb0lcnRD3bbe/2cUo+
         Ft/+d9nfycq90kelWZyhuX6oGLOeHLRE48nwNjBI4bLA0J2wuwaqzzJ6kTL+n7IIuWgP
         qSOg==
X-Gm-Message-State: ANoB5pmmzu0aExc1wx7sw6ljdDyrflbcb6ixGV5vSgf9C6rFOKZvMtli
        FQ+e/aFyN8BKHLPVRTqq9/k=
X-Google-Smtp-Source: AA0mqf6Ktsca4xODmDtvklWajfqrWozY3n3iOFiYsL8/oGsq9O33pFarnLiHoj2URJbUujJ3L+YYcA==
X-Received: by 2002:a17:906:2ac3:b0:7ad:f2f9:2b49 with SMTP id m3-20020a1709062ac300b007adf2f92b49mr55064295eje.94.1670233369277;
        Mon, 05 Dec 2022 01:42:49 -0800 (PST)
Received: from ThinkStation-P340.. (host-217-57-98-66.business.telecomitalia.it. [217.57.98.66])
        by smtp.gmail.com with ESMTPSA id bn18-20020a170906c0d200b0077a1dd3e7b7sm6083866ejb.102.2022.12.05.01.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:42:49 -0800 (PST)
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
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v3 1/3] ethtool: add tx aggregation parameters
Date:   Mon,  5 Dec 2022 10:33:57 +0100
Message-Id: <20221205093359.49350-2-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221205093359.49350-1-dnlplm@gmail.com>
References: <20221205093359.49350-1-dnlplm@gmail.com>
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

ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES
Maximum size in bytes of a tx aggregated block of frames.

ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES
Maximum number of frames that can be aggregated into a block.

ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS
Time in usecs after the first packet arrival in an aggregated
block for the block to be sent.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
v3
- Fixed ethtool-netlink.rst content out of table bounds
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
index bede24ef44fd..49b6c95b10bf 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1002,6 +1002,9 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
   ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
   ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr size, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr, Tx
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
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_BYTES``     u32     max aggr size, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_MAX_FRAMES``    u32     max aggr packets, Tx
+  ``ETHTOOL_A_COALESCE_TX_AGGR_TIME_USECS``    u32     time (us), aggr, Tx
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

