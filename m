Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7646367BD3A
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbjAYUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbjAYUpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:45:52 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5C44C0C
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:51 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id g15so25164ild.3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOIF99BwsdUg6KBge/yH/xVHzhlMOjGxPJj8j07xdBQ=;
        b=hxtvZim2wjo5p0oljRrnhU09J/FXl/q3kMFv0xI8VeVBra8h2ZKrR2LsZ8KJPtusTo
         +1ZcRlQkP5swxG+FSy8ovUgfE5gGZzSTT3Ugf1DjHXTkpXigrHn841Jyw1/acZSTuM/x
         aUC0w9yr4OC23P+ZZBmZOpllNplBV90+WqFDE/6yWPmj+G/tvsqeI+/Hc50U8JRJ57aM
         P/tOvpVcvZ6wV4eSHp3CXT2lPh592SdHNza2386wrU2+HGZabj7v8nHsG7MFEgfNX7Rn
         2WfvRMKlj0/sfmGg4T5JVwlRDrm+Bcu/q5bYr1ACoJbrGIX2oOLbrCeC91ob2RiqZkRH
         rQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOIF99BwsdUg6KBge/yH/xVHzhlMOjGxPJj8j07xdBQ=;
        b=1aCLHN9oskL+kaRrz73DyRCnIPDHolN4w2E80BphHIzF09iMWZF6m7ta13Ip8jIfUd
         KLbI9Lhx5Oa1IXV7cRkm5BabV279agnL/MRQbRtZrUGnUs2kFPnr+6ReAfR9TTls1EwZ
         ZgYVXgkZypGCps/n6JVitSwhu3YT/XyFsxRAt/lcUuTdrC2FNkQ4Y4MjLRuIOGfCObeF
         O4Os8TLVSsc9jyPZSPQ9r9F8f4SUaPmgsmyq0eBBVmU8Ul2mJkhKWGCOohEE1oxcv+US
         JHVTg6Dp8CKB/F+eb7sRZZ3eZoofThGgkDFSAfrEUDEtIhfzb51iA1nBUeeZe1lTV5df
         j+zg==
X-Gm-Message-State: AO0yUKXfTCzSbyaxg4La0lQvd7l/9JsZB7oQ2SsscUA8NunWEWUTMyXH
        8o2VwaQ9tYiOemwzJ8Tm786+mg==
X-Google-Smtp-Source: AK7set/Vdk2RgNYyVH2sF2H9VvkVLiEXjUAPPdJyUqFQJfP5IbxXFGLB1iaNq0H2KnH8WgaAAJazjA==
X-Received: by 2002:a05:6e02:19ce:b0:310:a8c9:e0bd with SMTP id r14-20020a056e0219ce00b00310a8c9e0bdmr2162564ill.26.1674679550440;
        Wed, 25 Jan 2023 12:45:50 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w14-20020a02968e000000b00389c2fe0f9dsm1960696jai.85.2023.01.25.12.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:45:50 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: ipa: refactor status buffer parsing
Date:   Wed, 25 Jan 2023 14:45:38 -0600
Message-Id: <20230125204545.3788155-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125204545.3788155-1-elder@linaro.org>
References: <20230125204545.3788155-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet length encoded in an IPA packet status buffer is computed
more than once in ipa_endpoint_status_parse().  It is also checked
again in ipa_endpoint_status_skip(), which that function calls.

Compute the length once, and use that computed value later rather
than recomputing it.  Check for it being zero in the parse function
rather than in ipa_endpoint_status_skip().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 136932464261c..3756ce5f3f310 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1325,8 +1325,7 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
 
 	if (!ipa_status_format_packet(status->opcode))
 		return true;
-	if (!status->pkt_len)
-		return true;
+
 	endpoint_id = u8_get_bits(status->endp_dst_idx,
 				  IPA_STATUS_DST_IDX_FMASK);
 	if (endpoint_id != endpoint->endpoint_id)
@@ -1394,6 +1393,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 
 	while (resid) {
 		const struct ipa_status *status = data;
+		u32 length;
 		u32 align;
 		u32 len;
 
@@ -1405,7 +1405,8 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		}
 
 		/* Skip over status packets that lack packet data */
-		if (ipa_endpoint_status_skip(endpoint, status)) {
+		length = le16_to_cpu(status->pkt_len);
+		if (!length || ipa_endpoint_status_skip(endpoint, status)) {
 			data += sizeof(*status);
 			resid -= sizeof(*status);
 			continue;
@@ -1418,19 +1419,16 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		 * computed checksum information will be appended.
 		 */
 		align = endpoint->config.rx.pad_align ? : 1;
-		len = le16_to_cpu(status->pkt_len);
-		len = sizeof(*status) + ALIGN(len, align);
+		len = sizeof(*status) + ALIGN(length, align);
 		if (endpoint->config.checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
 		if (!ipa_endpoint_status_drop(endpoint, status)) {
 			void *data2;
 			u32 extra;
-			u32 len2;
 
 			/* Client receives only packet data (no status) */
 			data2 = data + sizeof(*status);
-			len2 = le16_to_cpu(status->pkt_len);
 
 			/* Have the true size reflect the extra unused space in
 			 * the original receive buffer.  Distribute the "cost"
@@ -1438,7 +1436,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 			 * buffer.
 			 */
 			extra = DIV_ROUND_CLOSEST(unused * len, total_len);
-			ipa_endpoint_skb_copy(endpoint, data2, len2, extra);
+			ipa_endpoint_skb_copy(endpoint, data2, length, extra);
 		}
 
 		/* Consume status and the full packet it describes */
-- 
2.34.1

