Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E976E00D9
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjDLV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDLV3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:29:24 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9297EC1;
        Wed, 12 Apr 2023 14:29:19 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id by8so13157137ljb.13;
        Wed, 12 Apr 2023 14:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681334958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qp6LyIaTjuBGZ4eQdu84T77cz5sFNOTq+6H0iaPWSIo=;
        b=U+rLnvmAKOQNiK3Ab8LtIRiH+ieLN/gC1CsMYe3pl996C9JvK1LbXg2npsOx7mZTds
         OgftBb1HigpM71CRbeyBo6L9B/v58rp6GQhQvSfBma8O69e8K7nXhaKhfd6MrKK6USdb
         Na0pTQi4GqDuNCwxFjWQqcHAmdVVfQbDLNZnMR1IxXmJifqiU9UqDaOpzqYlcSPETrMS
         51b/tT/389zSyIos+o7mt0NAFTHlkprcf/7EpbTU3RVKvJOUgucS/5aQADUTjldWoZFJ
         5E6wco7U95XgEQCeh+lF6qBwwOlkM6a7ZOVeyTO8fUmVTQ+PKcnohH7zlsHly9TQR4/X
         dm/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681334958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qp6LyIaTjuBGZ4eQdu84T77cz5sFNOTq+6H0iaPWSIo=;
        b=lP4tr5vKW2blERy9tL5fdmXK6x4OyBBV82JRAh5lZe/Sj6ZmYoGJh+n+Pjb8lF65D5
         MK6EquGJA8cwkmX+sUx1fXSFVpd4QkaXFoomtE9zzinP6oOU7vqb3aWZEkvXJ7PPhcah
         FASXHjB1NONqvaUn2YkzXvN4lEEtOViozTOs5TA83dVCNXXfLmEEIajId7f02GRBDtft
         wy5ndFN82p0HEq4YbEDC/X69PBo1vLHw5tevFREVRLZY3qVJ1fnaD9e3prFgKY/uL++/
         BosqNqlTwqvndjXVweNTIn76M5xHQSuaH2Og2QRcFjwjP1cfEnIAUqwWpUUqWtAVE/Y6
         Mxfw==
X-Gm-Message-State: AAQBX9cfuw7Cbj9utzgK0RLNVqlsdaW836I/o10nooSEHiXYXhrRg2vf
        KG1wwe2F3LpUhPf6wK6XJGQ=
X-Google-Smtp-Source: AKy350aldqAfGI10vxdfzvcAzNPZ/ZfmZHdfrVy8JYZwKIOZ/iF1zeFrRzQz63bmJUIMS2oN0qw/Qg==
X-Received: by 2002:a2e:7006:0:b0:2a7:6f97:51bb with SMTP id l6-20020a2e7006000000b002a76f9751bbmr24003ljc.31.1681334958253;
        Wed, 12 Apr 2023 14:29:18 -0700 (PDT)
Received: from localhost.localdomain (93-80-67-75.broadband.corbina.ru. [93.80.67.75])
        by smtp.googlemail.com with ESMTPSA id p14-20020a2e804e000000b002a7758b13c9sm1882481ljg.52.2023.04.12.14.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:29:17 -0700 (PDT)
From:   Ivan Mikhaylov <fr0st61te@gmail.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Mikhaylov <fr0st61te@gmail.com>
Subject: [PATCH 4/4] net/ncsi: add shift MAC address property
Date:   Thu, 13 Apr 2023 00:29:05 +0000
Message-Id: <20230413002905.5513-5-fr0st61te@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230413002905.5513-1-fr0st61te@gmail.com>
References: <20230413002905.5513-1-fr0st61te@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the shift MAC address property for GMA command which provides which
shift should be used but keep old one values for backward compatibility.

Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
---
 net/ncsi/ncsi-rsp.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
index 069c2659074b..1f108db34d85 100644
--- a/net/ncsi/ncsi-rsp.c
+++ b/net/ncsi/ncsi-rsp.c
@@ -9,6 +9,8 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <net/ncsi.h>
 #include <net/net_namespace.h>
@@ -616,9 +618,12 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 {
 	struct ncsi_dev_priv *ndp = nr->ndp;
 	struct net_device *ndev = ndp->ndev.dev;
+	struct platform_device *pdev;
 	struct ncsi_rsp_oem_pkt *rsp;
 	struct sockaddr saddr;
 	u32 mac_addr_off = 0;
+	s32 shift_mac_addr = 0;
+	u64 mac_addr;
 	int ret = 0;
 
 	/* Get the response header */
@@ -635,7 +640,17 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
 
 	memcpy(saddr.sa_data, &rsp->data[mac_addr_off], ETH_ALEN);
 	if (mfr_id == NCSI_OEM_MFR_BCM_ID || mfr_id == NCSI_OEM_MFR_INTEL_ID)
-		eth_addr_inc((u8 *)saddr.sa_data);
+		shift_mac_addr = 1;
+
+	pdev = to_platform_device(ndev->dev.parent);
+	if (pdev)
+		of_property_read_s32(pdev->dev.of_node,
+				     "mac-address-increment", &shift_mac_addr);
+
+	/* Increase mac address by shift value for BMC's address */
+	mac_addr = ether_addr_to_u64((u8 *)saddr.sa_data);
+	mac_addr += shift_mac_addr;
+	u64_to_ether_addr(mac_addr, (u8 *)saddr.sa_data);
 	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
 		return -ENXIO;
 
-- 
2.40.0

