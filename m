Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90922681C29
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 22:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjA3VD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 16:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjA3VD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 16:03:27 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7577F1E1CC
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:20 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id z2so5127774ilq.2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 13:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOMLzNh0yK/0qTgNUqpARcKHC/PDBTSkI4Jf9pY8gkc=;
        b=Am8GWon3yO+XZpbh2vH4WXuITnbyYP6+zqEC6IYJV5Zo8ApLD4K4QnCyfwph0c2GeP
         iVYFTxNcTH9ds5rT8rxSGn+xgS4FFh0VlIiT1ZzKo8EUq7t29YQQU6IzgURvR3uxYNyK
         YOInMA9M9a8FUWOIWkGQg3zDfEwEWVY4hpTTWwtOlfwBFY3bwNbttozjR7KAReXREqW5
         0KshzktYoMfi4dqMUZKMngEG3/v/c+0MTVQxuJLGEVC551B6nAzW6w1ZeupF92sIkned
         qtggfxDLkRdxj7r2vtddlmIgHYRGT3jj8gQ2sT05Hj9yUGrQFW2EUG7KF/2eFCMlHbdX
         IP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOMLzNh0yK/0qTgNUqpARcKHC/PDBTSkI4Jf9pY8gkc=;
        b=neiVt8pr5Eu4qP8hhFkgOGDJtbsH20g6evwjjbcqDeObG4ijybSfZgNYBLiRA6sm7t
         UDIhHQ0XMNIZkfk8GjKmXFRzl8DX9vC1cTGQDxHliH3a8p2M/l0kAQ7qy2T1lgd+fsHP
         CBF9IbDmwBYikggGXVAxh8k0YNj4hRsIcQoiaW36RRTulkChfYcdfWuMeiMcVXTRYjgh
         qdyfr3rVENbPGNVmCtA0lvpUbSLaDPry4fL+k++PE8fNjb019RHBVwZuf+thIx0G38sQ
         Yguz9o8Y8hmyipRXfxyWMXXv+3OBohQvEJbw1m+OuGgMn4nOnsiTOQ54XCetd/a/7c5C
         IRYQ==
X-Gm-Message-State: AO0yUKXcmExR7+lAiCSmmyNhdEvlJYH1SqXAgKjXkzej/rjNnlGeCnuI
        h49EaggZr4dX5PU1TqjTxg+baw==
X-Google-Smtp-Source: AK7set87Oiqf2yVURDq65Vgtj7g6BYcFlvHTkqi6hILl58lH3403noiOUroQUBwzZr/riR7osXHz9w==
X-Received: by 2002:a05:6e02:1aa2:b0:310:cc76:5c9d with SMTP id l2-20020a056e021aa200b00310cc765c9dmr11970789ilv.28.1675112599598;
        Mon, 30 Jan 2023 13:03:19 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id a30-20020a02735e000000b003aef8fded9asm1992046jae.127.2023.01.30.13.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:03:12 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/8] net: ipa: extend endpoints in packet init command
Date:   Mon, 30 Jan 2023 15:01:52 -0600
Message-Id: <20230130210158.4126129-3-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
References: <20230130210158.4126129-1-elder@linaro.org>
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

The IP_PACKET_INIT immediate command defines the destination
endpoint to which a packet should be sent.  Prior to IPA v5.0, a
5 bit field in that command represents the endpoint, but starting
with IPA v5.0, the field is extended to 8 bits to support more than
32 endpoints.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index aa2b594ca5067..5d3a875e50fee 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -94,11 +94,11 @@ struct ipa_cmd_register_write {
 /* IPA_CMD_IP_PACKET_INIT */
 
 struct ipa_cmd_ip_packet_init {
-	u8 dest_endpoint;
+	u8 dest_endpoint;	/* Full 8 bits used for IPA v5.0+ */
 	u8 reserved[7];
 };
 
-/* Field masks for ipa_cmd_ip_packet_init dest_endpoint field */
+/* Field mask for ipa_cmd_ip_packet_init dest_endpoint field (unused v5.0+) */
 #define IPA_PACKET_INIT_DEST_ENDPOINT_FMASK		GENMASK(4, 0)
 
 /* IPA_CMD_DMA_SHARED_MEM */
@@ -491,8 +491,13 @@ static void ipa_cmd_ip_packet_init_add(struct gsi_trans *trans, u8 endpoint_id)
 	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 	payload = &cmd_payload->ip_packet_init;
 
-	payload->dest_endpoint = u8_encode_bits(endpoint_id,
-					IPA_PACKET_INIT_DEST_ENDPOINT_FMASK);
+	if (ipa->version < IPA_VERSION_5_0) {
+		payload->dest_endpoint =
+			u8_encode_bits(endpoint_id,
+				       IPA_PACKET_INIT_DEST_ENDPOINT_FMASK);
+	} else {
+		payload->dest_endpoint = endpoint_id;
+	}
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  opcode);
-- 
2.34.1

