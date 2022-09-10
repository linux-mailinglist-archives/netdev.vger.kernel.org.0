Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AD55B4360
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 02:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiIJAZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 20:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIJAZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 20:25:55 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B886C6B42
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 17:25:54 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-12803ac8113so8145716fac.8
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 17:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=IHz1n1F+mYQ2GHilCtmGNlQvtKqI4gMzrqCJ8di/S4k=;
        b=yepNDjPcFktekGyr/GQ2pM/793pJEMkibtp+DobRKw5Dv8ui14BGbUzOLAjl+CXt8a
         ZlqLLZWewhi0yRpoDkAmvnaTYmy0GAgCZQb/80LYcbAnHoqCnH3CT8NaD6I4H6m70PAh
         uQUbHmaSek9sjqNtXLSC8zCk4jg358FwU6j8lcg9CrDkCYn1hom6sPZL8H7gqZmBHClr
         45qpsI2lV8jrznd6T1boWU8TdapDrCB6oasVmTgAfFUNsZEgAgFBTk8KrVlgmxPfM6Pb
         nKCQWUDXL0AwxwfpUd9XCoF7zBcEq5J8eWAP/sEOrG8XGPdilGxEafnjp3wTFhPnBMeN
         mlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=IHz1n1F+mYQ2GHilCtmGNlQvtKqI4gMzrqCJ8di/S4k=;
        b=iH3wNS+TKMvcmsNQRysws7ptb9xpBZiVMcMOtv+fejJiIdM3e0A49aySROs5/+HuO/
         ED5RR+FpOOMZB/N1egUMrADTbn047RO9vgXtKy9B803vsF8wEsdhIArz6yOx8+sBiWZj
         jsVTvNs0ip5kV6KYRQ+awSYWevt5f7LXuP1AaJIXHTbOK/89V2YPshfrxWJk1Pfg6omZ
         FcY2XYTy22seT4yuCBaK2pyIETqqz31l4MFm1w/paejMcdSlH3xd3URn/bbsRMHkiDOj
         ghpDTIBIZcxQrOICyWQE/5ICUXh8WZXxoruZHo4OBbmM1gRYNcwlxuWed3COaMb3tPD8
         rA6w==
X-Gm-Message-State: ACgBeo0B2WHL85ndOT1XwozGAwVVCeno468/S/vwwVQLXtHavstl29cV
        WFO5Uj+SJ2BRPL7sHTnSiX/cSg==
X-Google-Smtp-Source: AA6agR4tCoERmPmUNfwD2+GSpNCJHR+9pME1ydZfX37zsgKt2d5MZXiz1sDxzUyt25pyU1gnFlwrOA==
X-Received: by 2002:a05:6808:bcd:b0:344:d614:c5e with SMTP id o13-20020a0568080bcd00b00344d6140c5emr4682721oik.78.1662769552735;
        Fri, 09 Sep 2022 17:25:52 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id q133-20020aca438b000000b00344aa3f17d9sm463607oia.10.2022.09.09.17.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 17:25:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: properly limit modem routing table use
Date:   Fri,  9 Sep 2022 19:25:47 -0500
Message-Id: <20220910002547.1178129-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA can route packets between IPA-connected entities.  The AP and
modem are currently the only such entities supported, and no routing
is required to transfer packets between them.

The number of entries in each routing table is fixed, and defined at
initialization time.  Some of these entries are designated for use
by the modem, and the rest are available for the AP to use.  The AP
sends a QMI message to the modem which describes (among other
things) information about routing table memory available for the
modem to use.

Currently the QMI initialization packet gives wrong information in
its description of routing tables.  What *should* be supplied is the
maximum index that the modem can use for the routing table memory
located at a given location.  The current code instead supplies the
total *number* of routing table entries.  Furthermore, the modem is
granted the entire table, not just the subset it's supposed to use.

This patch fixes this.  First, the ipa_mem_bounds structure is
generalized so its "end" field can be interpreted either as a final
byte offset, or a final array index.  Second, the IPv4 and IPv6
(non-hashed and hashed) table information fields in the QMI
ipa_init_modem_driver_req structure are changed to be ipa_mem_bounds
rather than ipa_mem_array structures.  Third, we set the "end" value
for each routing table to be the last index, rather than setting the
"count" to be the number of indices.  Finally, instead of allowing
the modem to use all of a routing table's memory, it is limited to
just the portion meant to be used by the modem.  In all versions of
IPA currently supported, that is IPA_ROUTE_MODEM_COUNT (8) entries.

Update a few comments for clarity.

Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
Signed-off-by: Alex Elder <elder@linaro.org>
---
Note:  I will send a back-port for v5.10.y separately once upstream

 drivers/net/ipa/ipa_qmi.c     |  8 ++++----
 drivers/net/ipa/ipa_qmi_msg.h | 37 ++++++++++++++++++++---------------
 drivers/net/ipa/ipa_table.c   |  2 --
 drivers/net/ipa/ipa_table.h   |  3 +++
 4 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index ec010cf2e816a..6f874f99b910c 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -308,12 +308,12 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_ROUTE);
 	req.v4_route_tbl_info_valid = 1;
 	req.v4_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v4_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v4_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE);
 	req.v6_route_tbl_info_valid = 1;
 	req.v6_route_tbl_info.start = ipa->mem_offset + mem->offset;
-	req.v6_route_tbl_info.count = mem->size / sizeof(__le64);
+	req.v6_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER);
 	req.v4_filter_tbl_start_valid = 1;
@@ -352,7 +352,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v4_hash_route_tbl_info_valid = 1;
 		req.v4_hash_route_tbl_info.start =
 				ipa->mem_offset + mem->offset;
-		req.v4_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v4_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V6_ROUTE_HASHED);
@@ -360,7 +360,7 @@ init_modem_driver_req(struct ipa_qmi *ipa_qmi)
 		req.v6_hash_route_tbl_info_valid = 1;
 		req.v6_hash_route_tbl_info.start =
 			ipa->mem_offset + mem->offset;
-		req.v6_hash_route_tbl_info.count = mem->size / sizeof(__le64);
+		req.v6_hash_route_tbl_info.end = IPA_ROUTE_MODEM_COUNT - 1;
 	}
 
 	mem = ipa_mem_find(ipa, IPA_MEM_V4_FILTER_HASHED);
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 495e85abe50bd..9651aa59b5968 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -86,9 +86,11 @@ enum ipa_platform_type {
 	IPA_QMI_PLATFORM_TYPE_MSM_QNX_V01	= 0x5,	/* QNX MSM */
 };
 
-/* This defines the start and end offset of a range of memory.  Both
- * fields are offsets relative to the start of IPA shared memory.
- * The end value is the last addressable byte *within* the range.
+/* This defines the start and end offset of a range of memory.  The start
+ * value is a byte offset relative to the start of IPA shared memory.  The
+ * end value is the last addressable unit *within* the range.  Typically
+ * the end value is in units of bytes, however it can also be a maximum
+ * array index value.
  */
 struct ipa_mem_bounds {
 	u32 start;
@@ -129,18 +131,19 @@ struct ipa_init_modem_driver_req {
 	u8			hdr_tbl_info_valid;
 	struct ipa_mem_bounds	hdr_tbl_info;
 
-	/* Routing table information.  These define the location and size of
-	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of non-hashable IPv4 and
+	 * IPv6 routing tables.  The start values are byte offsets relative
+	 * to the start of IPA shared memory.
 	 */
 	u8			v4_route_tbl_info_valid;
-	struct ipa_mem_array	v4_route_tbl_info;
+	struct ipa_mem_bounds	v4_route_tbl_info;
 	u8			v6_route_tbl_info_valid;
-	struct ipa_mem_array	v6_route_tbl_info;
+	struct ipa_mem_bounds	v6_route_tbl_info;
 
 	/* Filter table information.  These define the location of the
 	 * non-hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_filter_tbl_start_valid;
 	u32			v4_filter_tbl_start;
@@ -181,18 +184,20 @@ struct ipa_init_modem_driver_req {
 	u8			zip_tbl_info_valid;
 	struct ipa_mem_bounds	zip_tbl_info;
 
-	/* Routing table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	/* Routing table information.  These define the location and maximum
+	 * *index* (not byte) for the modem portion of hashable IPv4 and IPv6
+	 * routing tables (if supported by hardware).  The start values are
+	 * byte offsets relative to the start of IPA shared memory.
 	 */
 	u8			v4_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v4_hash_route_tbl_info;
+	struct ipa_mem_bounds	v4_hash_route_tbl_info;
 	u8			v6_hash_route_tbl_info_valid;
-	struct ipa_mem_array	v6_hash_route_tbl_info;
+	struct ipa_mem_bounds	v6_hash_route_tbl_info;
 
 	/* Filter table information.  These define the location and size
-	 * of hashable IPv4 and IPv6 filter tables.  The start values are
-	 * offsets relative to the start of IPA shared memory.
+	 * of hashable IPv4 and IPv6 filter tables (if supported by hardware).
+	 * The start values are byte offsets relative to the start of IPA
+	 * shared memory.
 	 */
 	u8			v4_hash_filter_tbl_start_valid;
 	u32			v4_hash_filter_tbl_start;
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 2f5a58bfc529a..69efe672ca528 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -108,8 +108,6 @@
 
 /* Assignment of route table entries to the modem and AP */
 #define IPA_ROUTE_MODEM_MIN		0
-#define IPA_ROUTE_MODEM_COUNT		8
-
 #define IPA_ROUTE_AP_MIN		IPA_ROUTE_MODEM_COUNT
 #define IPA_ROUTE_AP_COUNT \
 		(IPA_ROUTE_COUNT_MAX - IPA_ROUTE_MODEM_COUNT)
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index b6a9a0d79d68e..1538e2e1732fe 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -13,6 +13,9 @@ struct ipa;
 /* The maximum number of filter table entries (IPv4, IPv6; hashed or not) */
 #define IPA_FILTER_COUNT_MAX	14
 
+/* The number of route table entries allotted to the modem */
+#define IPA_ROUTE_MODEM_COUNT	8
+
 /* The maximum number of route table entries (IPv4, IPv6; hashed or not) */
 #define IPA_ROUTE_COUNT_MAX	15
 
-- 
2.34.1

