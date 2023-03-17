Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554396BEFC7
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCQRgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjCQRgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:36:42 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B04C1BD9;
        Fri, 17 Mar 2023 10:36:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o12so23269632edb.9;
        Fri, 17 Mar 2023 10:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679074596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7EAQShATxzdhJQQb5tocPxykTn/sRjDru15SsB0eMkY=;
        b=aKxgUx89cU/ougX8mQL6NitjRTPZR0lcg51PxzfxsNhmfXtK/EigFl3GTpEpcBxUl2
         N0LveujLoWE0DLA2yYwXXs+musBK4q/6asn6MKvNyNvSn5cnbUSGx7XyDjIEuG9ikbyT
         3DA7kMjb6Udfh9IIK98GYNYpYGnfgx7dYZCPfRSmnLioC1rBaqLrEeGJpvU5T7IW9czl
         LBLv0fUV3FohPWk32ydtmnxO/SS36n6szQJyZT8UMqegaYkP/2zP6mXgWUFiWwQIpM31
         EJJ7qe/sVEVRWIaQSgxyGJ8TvgcILTXCPT9AUOsiHdSyAdkxcxZ+4tlYE3t1++sOxP5s
         KkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679074596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7EAQShATxzdhJQQb5tocPxykTn/sRjDru15SsB0eMkY=;
        b=CRU68dqftD4OVEBJnXy7aS/pv90sw+HWy/FjLZmq4tHdfHhv+WPmZbx6tUF29t1trI
         OQKyEVSlpWN+AwiUMoyo6ji2yN24aaKk5WN48w1QBfcNK4MLWIMu98mJ36Lzo0iGwcdI
         YtfrOV9rrJn26mK08F3GgMHNZNd/+BTV0fC/e9wbe5/sboAOfp4qrUJG3FsQmdRbGfnm
         UVTBFFr7QsLI8MZuSzzades3nofxHeCxtoeykRsLU3nLKHjiHh/hLh9ar9ltzjxHfF00
         A3NTwO7zR9iGiCqvrjXF3bYNmR+fy28LyjNmBfrdvCWY/hjl56cPzrk6b5tg0ldDPnPb
         GVHg==
X-Gm-Message-State: AO0yUKXEzH07jY6gKJ4QAAnJQ6SsfJTbpSyDo7eH42vfI9s+nRqGdM6p
        2pWkkoRW88WOwyavbzVVxE4=
X-Google-Smtp-Source: AK7set+BiHUaPH654xcLX2P8WRLz/aiyXQEL0Al2DC5tor/u+f57qSyngurpg/M5qkv4KMKi5+yqGg==
X-Received: by 2002:a17:906:7fc9:b0:92b:c56a:7efe with SMTP id r9-20020a1709067fc900b0092bc56a7efemr167913ejs.31.1679074596541;
        Fri, 17 Mar 2023 10:36:36 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id qx20-20020a170906fcd400b008eaf99be56esm1212888ejb.170.2023.03.17.10.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 10:36:35 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com
Cc:     pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: [PATCH v2] net: usb: lan78xx: Limit packet length to skb->len
Date:   Fri, 17 Mar 2023 18:36:06 +0100
Message-Id: <20230317173606.91426-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <202303180031.EsiDo4qY-lkp@intel.com>
References: <202303180031.EsiDo4qY-lkp@intel.com>
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

Packet length retrieved from descriptor may be larger than
the actual socket buffer length. In such case the cloned
skb passed up the network stack will leak kernel memory contents.

Additionally prevent integer underflow when size is less than
ETH_FCS_LEN.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
---
V1 -> V2: Fix ISO C90 forbids mixed declarations and code

 drivers/net/usb/lan78xx.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 068488890..a150711a1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3579,11 +3579,27 @@ static int lan78xx_rx(struct lan78xx_net *dev, struct sk_buff *skb,
 		size = (rx_cmd_a & RX_CMD_A_LEN_MASK_);
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x", rx_cmd_a);
 		} else {
-			u32 frame_len = size - ETH_FCS_LEN;
+			u32 frame_len;
+
+			if (unlikely(size < ETH_FCS_LEN)) {
+				netif_dbg(dev, rx_err, dev->net,
+					  "size err rx_cmd_a=0x%08x\n",
+					  rx_cmd_a);
+				return 0;
+			}
+
+			frame_len = size - ETH_FCS_LEN;
 			struct sk_buff *skb2;
 
 			skb2 = napi_alloc_skb(&dev->napi, frame_len);
-- 
2.40.0

