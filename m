Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B97167BD48
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 21:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236621AbjAYUqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 15:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbjAYUp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 15:45:59 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C4B5E508
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:56 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id f8so20943ilj.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 12:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2aF4dRRxXYWgXxbaJpBxk8mqsz625P0c71KwZ9Suks=;
        b=aAw5L9RyrOP8c+CWms4LOllqpd14csq3QWj37+enc7FPuxwgZAk6M+WW8EOGT7bEFS
         14a9Y/8zKWkGuAHcQuoPMozbKHolxqU5BHvMVWe7BgdW2+HxZi5P+GpKqa2kbSos1jlf
         vKvFYSRP1Ebqq0h2VM+aZXROo3rgiRlGxhISiPW4gZIDHlOypX3AkGd0LjGv4IZ0db6c
         viDsY+FrT99rTMtv6d7Z483CZChE1S9fb2OICmSSa/WaPQMhwEBJ6dN6tSDKdQyo2LbP
         tq4RuCXhH7KBze1Cc6XE8gIJHciau060X/BBAsU7eu+B8SqrNqyUc4pUdnZMw2YQG0jm
         aMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2aF4dRRxXYWgXxbaJpBxk8mqsz625P0c71KwZ9Suks=;
        b=O8iY0aVNTcDjY0nQRAHyOR6KLi7aCldiR0RcpPh3hSYBgdhxymnXeA2DYPxqwGXh/l
         kTXO8js9gmBdBsPnVj42v9ZNKlRFOSVWOwIB1T0fdO41l6FQRNSH97jVETxPDbGWLart
         ogCqnyPDusiYGPiLj+X7MixvFhyeeQGQ9P8AWZg6KOQ1e86e9jetq5CutY9GTgUw31eY
         R4yQy0silECWjvkxWkhxxhlJJwRW45Cipn5MSKl5yAQDKr+dSETTdtZRdsfWsGF/vVkO
         s+u+hndtq/BunEbdLzL3rQ6CKhLEZAWVSR4ZD3gOZm2O0pwodd+7SJDKjwE1FVatOZPm
         XqGg==
X-Gm-Message-State: AO0yUKXLgzSkVyEIeJadA9nsMWkhUZ63e1Hq2xrv1T7jvFyWTKcU9LTu
        O7DzTS9PDnWIZlqz/itbjFVMbw==
X-Google-Smtp-Source: AK7set9st4MWDlh7U7AjjbEL+gFLq+4qpbtx3jTqTFLY0kkhr3Xq8lue4Nfl/4KbTdDleWVPQvLzwQ==
X-Received: by 2002:a05:6e02:1c06:b0:310:a923:772e with SMTP id l6-20020a056e021c0600b00310a923772emr2091606ilh.21.1674679555972;
        Wed, 25 Jan 2023 12:45:55 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id w14-20020a02968e000000b00389c2fe0f9dsm1960696jai.85.2023.01.25.12.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 12:45:55 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] net: ipa: IPA status preparatory cleanups
Date:   Wed, 25 Jan 2023 14:45:43 -0600
Message-Id: <20230125204545.3788155-7-elder@linaro.org>
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

The next patch reworks how the IPA packet status structure is
interpreted.  This patch does some preparatory work, to make it
easier to see the effect of that change:
  - Change a few functions that access fields in a IPA packet status
    structure to store field values in local variables with names
    related to the field.
  - Pass a void pointer rather than an (equivalent) status pointer
    to two functions called by ipa_endpoint_status_parse().
  - Use "rule" rather than "val" as the name of a variable that
    holds a routing rule ID.
  - Consistently use "IPA packet status" rather than "status
    element" when referring to this data structure.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 43 ++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ee3c29b1efea9..5097eb1bbadb0 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1182,8 +1182,8 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 			val |= ipa_reg_encode(reg, STATUS_ENDP,
 					      status_endpoint_id);
 		}
-		/* STATUS_LOCATION is 0, meaning status element precedes
-		 * packet (not present for IPA v4.5+)
+		/* STATUS_LOCATION is 0, meaning IPA packet status
+		 * precedes the packet (not present for IPA v4.5+)
 		 */
 		/* STATUS_PKT_SUPPRESS_FMASK is 0 (not present for v4.0+) */
 	}
@@ -1339,8 +1339,8 @@ static bool ipa_endpoint_skb_build(struct ipa_endpoint *endpoint,
 	return skb != NULL;
 }
 
-/* The format of a packet status element is the same for several status
- * types (opcodes).  Other types aren't currently supported.
+ /* The format of an IPA packet status structure is the same for several
+  * status types (opcodes).  Other types aren't currently supported.
  */
 static bool ipa_status_format_packet(enum ipa_status_opcode opcode)
 {
@@ -1358,9 +1358,11 @@ static bool ipa_status_format_packet(enum ipa_status_opcode opcode)
 static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
 				     const struct ipa_status *status)
 {
+	enum ipa_status_opcode opcode;
 	u32 endpoint_id;
 
-	if (!ipa_status_format_packet(status->opcode))
+	opcode = status->opcode;
+	if (!ipa_status_format_packet(opcode))
 		return true;
 
 	endpoint_id = u8_get_bits(status->endp_dst_idx,
@@ -1371,14 +1373,16 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
 	return false;	/* Don't skip this packet, process it */
 }
 
-static bool ipa_endpoint_status_tag(struct ipa_endpoint *endpoint,
-				    const struct ipa_status *status)
+static bool ipa_endpoint_status_tag_valid(struct ipa_endpoint *endpoint,
+					  const struct ipa_status *status)
 {
 	struct ipa_endpoint *command_endpoint;
+	enum ipa_status_mask status_mask;
 	struct ipa *ipa = endpoint->ipa;
 	u32 endpoint_id;
 
-	if (!le16_get_bits(status->mask, IPA_STATUS_MASK_TAG_VALID))
+	status_mask = le16_get_bits(status->mask, IPA_STATUS_MASK_TAG_VALID);
+	if (!status_mask)
 		return false;	/* No valid tag */
 
 	/* The status contains a valid tag.  We know the packet was sent to
@@ -1404,20 +1408,23 @@ static bool ipa_endpoint_status_tag(struct ipa_endpoint *endpoint,
 static bool ipa_endpoint_status_drop(struct ipa_endpoint *endpoint,
 				     const struct ipa_status *status)
 {
-	u32 val;
+	enum ipa_status_exception exception;
+	u32 rule;
 
 	/* If the status indicates a tagged transfer, we'll drop the packet */
-	if (ipa_endpoint_status_tag(endpoint, status))
+	if (ipa_endpoint_status_tag_valid(endpoint, status))
 		return true;
 
 	/* Deaggregation exceptions we drop; all other types we consume */
-	if (status->exception)
-		return status->exception == IPA_STATUS_EXCEPTION_DEAGGR;
+	exception = status->exception;
+	if (exception)
+		return exception == IPA_STATUS_EXCEPTION_DEAGGR;
 
 	/* Drop the packet if it fails to match a routing rule; otherwise no */
-	val = le32_get_bits(status->flags1, IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
+	rule = le32_get_bits(status->flags1,
+			     IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
 
-	return val == field_max(IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
+	return rule == field_max(IPA_STATUS_FLAGS1_RT_RULE_ID_FMASK);
 }
 
 static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
@@ -1443,15 +1450,15 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 
 		/* Skip over status packets that lack packet data */
 		length = le16_to_cpu(status->pkt_len);
-		if (!length || ipa_endpoint_status_skip(endpoint, status)) {
+		if (!length || ipa_endpoint_status_skip(endpoint, data)) {
 			data += IPA_STATUS_SIZE;
 			resid -= IPA_STATUS_SIZE;
 			continue;
 		}
 
 		/* Compute the amount of buffer space consumed by the packet,
-		 * including the status element.  If the hardware is configured
-		 * to pad packet data to an aligned boundary, account for that.
+		 * including the status.  If the hardware is configured to
+		 * pad packet data to an aligned boundary, account for that.
 		 * And if checksum offload is enabled a trailer containing
 		 * computed checksum information will be appended.
 		 */
@@ -1460,7 +1467,7 @@ static void ipa_endpoint_status_parse(struct ipa_endpoint *endpoint,
 		if (endpoint->config.checksum)
 			len += sizeof(struct rmnet_map_dl_csum_trailer);
 
-		if (!ipa_endpoint_status_drop(endpoint, status)) {
+		if (!ipa_endpoint_status_drop(endpoint, data)) {
 			void *data2;
 			u32 extra;
 
-- 
2.34.1

