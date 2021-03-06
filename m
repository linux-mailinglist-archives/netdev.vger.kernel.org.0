Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9E432F7FF
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 04:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhCFDQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 22:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCFDP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 22:15:59 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FFAC0613D7
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 19:15:58 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id a7so4109779iok.12
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 19:15:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3pf3F65RZucsIMXc3J9HNUjACeQQX3TS4fzpwXGEtjU=;
        b=uJ9LqBW64xawg2GQYw0Lomzejf0+ejneX7u8Q34Pgygl8ZzbDHpX4gHHV+mQjdt8Ua
         VMhs68YznM7G6lcLvwNw+krd+8Rkjph+RQmOfB1bqWbNjwyHxwLZZ0VVmcAIOCW7oZQl
         SUT0po0KzaS9fU3Ds33YqwELQfIOJ0RqL8VrdBeMn7VxVuKP2ORZWEe/tGolsx1t4CLT
         n281ZO8pjoTnuWKW9xiUl+HNB2ICxptZ9CrKJtzu2WJpWe6nEn44TtKW0OoLIJ9Tg29N
         ZAu97+NP9bKHuZJV7RWei9oL2Rbgb1YYmcUfFC5sfhSOyGbfXXRcH2XzWXuO1w0yMXpM
         onJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3pf3F65RZucsIMXc3J9HNUjACeQQX3TS4fzpwXGEtjU=;
        b=fdK+OqHwkekupTyWfz3bX2rUsnteIoppCp95JDq8Q1TPQgI4oC0DTF5JHiduAPhkN+
         d14BhMSZHSVMfINcK+lDcP/eU3U8dsiZFdo7KBQKNIC3m23rfwJJK+BH2M+QEcUopM1J
         +/3SaNy6HFqmKV8WSMSPrbyxihAKFKCawuFJLZCAm9V/90qTvJtDCfwmJgVF6kow4VHE
         f8mpYTF12rFbi5e3/Imff8Z6QidxMUDRNsiVHtowtut3hvF+39XBAXWpFI6AyGkTiYUq
         SnosED8ET67TZE+syP4gthDRUIlDZNAX7HW28tPDl8wMelNfXibo4VChy9zHmYixev/3
         Oaog==
X-Gm-Message-State: AOAM532UQ1VKVdPvv4yben8dUWrquP6yE2Fbq/SSRdLpgQoVHKDTAiHr
        RgGe8U33TT699VtXBzv9rsqSGg==
X-Google-Smtp-Source: ABdhPJzflJncvIDzkoo05tdIH/yJshc/rqK2eKgqrop/MuyCrCDvlnMS9S/5g44zj8dcpuRhKj14qg==
X-Received: by 2002:a5e:9908:: with SMTP id t8mr11147172ioj.101.1615000557713;
        Fri, 05 Mar 2021 19:15:57 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i67sm2278693ioa.3.2021.03.05.19.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 19:15:57 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     sharathv@codeaurora.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/6] net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
Date:   Fri,  5 Mar 2021 21:15:47 -0600
Message-Id: <20210306031550.26530-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210306031550.26530-1-elder@linaro.org>
References: <20210306031550.26530-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following macros, defined in "rmnet_map.h", assume a socket
buffer is provided as an argument without any real indication this
is the case.
    RMNET_MAP_GET_MUX_ID()
    RMNET_MAP_GET_CD_BIT()
    RMNET_MAP_GET_PAD()
    RMNET_MAP_GET_CMD_START()
    RMNET_MAP_GET_LENGTH()
What they hide is pretty trivial accessing of fields in a structure,
and it's much clearer to see this if we do these accesses directly.

So rather than using these accessor macros, assign a local
variable of the map header pointer type to the socket buffer data
pointer, and derereference that pointer variable.

In "rmnet_map_data.c", use sizeof(object) rather than sizeof(type)
in one spot.  Also, there's no need to byte swap 0; it's all zeros
irrespective of endianness.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c | 10 ++++++----
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h      | 12 ------------
 .../net/ethernet/qualcomm/rmnet/rmnet_map_command.c  | 11 ++++++++---
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c |  4 ++--
 4 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index 3d00b32323084..2a6b2a609884c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -56,20 +56,22 @@ static void
 __rmnet_map_ingress_handler(struct sk_buff *skb,
 			    struct rmnet_port *port)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_endpoint *ep;
 	u16 len, pad;
 	u8 mux_id;
 
-	if (RMNET_MAP_GET_CD_BIT(skb)) {
+	if (map_header->cd_bit) {
+		/* Packet contains a MAP command (not data) */
 		if (port->data_format & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
 			return rmnet_map_command(skb, port);
 
 		goto free_skb;
 	}
 
-	mux_id = RMNET_MAP_GET_MUX_ID(skb);
-	pad = RMNET_MAP_GET_PAD(skb);
-	len = RMNET_MAP_GET_LENGTH(skb) - pad;
+	mux_id = map_header->mux_id;
+	pad = map_header->pad_len;
+	len = ntohs(map_header->pkt_len) - pad;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP)
 		goto free_skb;
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
index 576501db2a0bc..2aea153f42473 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h
@@ -32,18 +32,6 @@ enum rmnet_map_commands {
 	RMNET_MAP_COMMAND_ENUM_LENGTH
 };
 
-#define RMNET_MAP_GET_MUX_ID(Y) (((struct rmnet_map_header *) \
-				 (Y)->data)->mux_id)
-#define RMNET_MAP_GET_CD_BIT(Y) (((struct rmnet_map_header *) \
-				(Y)->data)->cd_bit)
-#define RMNET_MAP_GET_PAD(Y) (((struct rmnet_map_header *) \
-				(Y)->data)->pad_len)
-#define RMNET_MAP_GET_CMD_START(Y) ((struct rmnet_map_control_command *) \
-				    ((Y)->data + \
-				      sizeof(struct rmnet_map_header)))
-#define RMNET_MAP_GET_LENGTH(Y) (ntohs(((struct rmnet_map_header *) \
-					(Y)->data)->pkt_len))
-
 #define RMNET_MAP_COMMAND_REQUEST     0
 #define RMNET_MAP_COMMAND_ACK         1
 #define RMNET_MAP_COMMAND_UNSUPPORTED 2
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
index beaee49621287..add0f5ade2e61 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_command.c
@@ -12,12 +12,13 @@ static u8 rmnet_map_do_flow_control(struct sk_buff *skb,
 				    struct rmnet_port *port,
 				    int enable)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_endpoint *ep;
 	struct net_device *vnd;
 	u8 mux_id;
 	int r;
 
-	mux_id = RMNET_MAP_GET_MUX_ID(skb);
+	mux_id = map_header->mux_id;
 
 	if (mux_id >= RMNET_MAX_LOGICAL_EP) {
 		kfree_skb(skb);
@@ -49,6 +50,7 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
 			       unsigned char type,
 			       struct rmnet_port *port)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_map_control_command *cmd;
 	struct net_device *dev = skb->dev;
 
@@ -58,7 +60,8 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
 
 	skb->protocol = htons(ETH_P_MAP);
 
-	cmd = RMNET_MAP_GET_CMD_START(skb);
+	/* Command data immediately follows the MAP header */
+	cmd = (struct rmnet_map_control_command *)(map_header + 1);
 	cmd->cmd_type = type & 0x03;
 
 	netif_tx_lock(dev);
@@ -71,11 +74,13 @@ static void rmnet_map_send_ack(struct sk_buff *skb,
  */
 void rmnet_map_command(struct sk_buff *skb, struct rmnet_port *port)
 {
+	struct rmnet_map_header *map_header = (void *)skb->data;
 	struct rmnet_map_control_command *cmd;
 	unsigned char command_name;
 	unsigned char rc = 0;
 
-	cmd = RMNET_MAP_GET_CMD_START(skb);
+	/* Command data immediately follows the MAP header */
+	cmd = (struct rmnet_map_control_command *)(map_header + 1);
 	command_name = cmd->command_name;
 
 	switch (command_name) {
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index bd1aa11c9ce59..fd55269c2ce3c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -321,7 +321,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 		return NULL;
 
 	maph = (struct rmnet_map_header *)skb->data;
-	packet_len = ntohs(maph->pkt_len) + sizeof(struct rmnet_map_header);
+	packet_len = ntohs(maph->pkt_len) + sizeof(*maph);
 
 	if (port->data_format & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
 		packet_len += sizeof(struct rmnet_map_dl_csum_trailer);
@@ -330,7 +330,7 @@ struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
 		return NULL;
 
 	/* Some hardware can send us empty frames. Catch them */
-	if (ntohs(maph->pkt_len) == 0)
+	if (!maph->pkt_len)
 		return NULL;
 
 	skbn = alloc_skb(packet_len + RMNET_MAP_DEAGGR_SPACING, GFP_ATOMIC);
-- 
2.27.0

