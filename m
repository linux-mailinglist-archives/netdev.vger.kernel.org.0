Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7AED6BCC70
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjCPKUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjCPKUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:20:35 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC0ABCFE3;
        Thu, 16 Mar 2023 03:20:26 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o12so5382508edb.9;
        Thu, 16 Mar 2023 03:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678962024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jGioppgO0MzFmAHm40uh73Adm2rQQtc87u2aiQkh8H4=;
        b=drd9Ugkav0IjqQXXwvmyIm2esAE32wSSlIYWjYhNCjnOZ0ItBJY/DRlbWWu1/R32eC
         2BNgYkWAkkHMmQnQ6B8JXwWMpdENk2RZEkHohKsbOuA01kwDUuoREQZasK0Pv+URvqEa
         iMWEVXXvSxFk/a24tIk7lN9vGZ+1zywUwf9SzRM+nJe1f0PGbliX0FxR5P1Oc/2VouVH
         P/0dXNpIjz6gpoAsrv/b5e50J8P5Jd30/avK5u057TAIshZKJr+JOItDfL6W8mMKD1Hd
         gZqO7Sg6x1plAuIcgg+MrSS6HB1tBd+7JtbMyhrS4/JgoqCNbjk5ofNeEIOa727P/2/B
         2G1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678962024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jGioppgO0MzFmAHm40uh73Adm2rQQtc87u2aiQkh8H4=;
        b=BHA6vcFeCyU1IXUSSs85pZAPfUYW1asZThsuFxPILIxhC3fpCSQvB1R6+b3Nlyfef6
         fpwNxuTjI1jdM6hfhZzoWLM12FVpgj9++zHCxb3jeIiv0nfC6H//f/QtnvqZTXLYz7lx
         gLWIFH4kmZm/j0G4cxVcVmjWfxeJ6KtrxvpeVXUWfzKsRRxzGvyq0gOHRNz1TkcYGt2q
         x+zfE8PzeRGcaWTHjhyefcVlylyi92X/TiHCWlncnGFRnIEHwklKhs9bNk6kJH+X5GNL
         Yok4oBc3gamLx5HaJGwj+7qTy7Rtyt2dFMhuYZ7k6CzZ/T6uRDIqpiJXSUIIKHPi0/Yi
         ewvQ==
X-Gm-Message-State: AO0yUKV3oTISqROPDSVsS6Qrs4gWxgKmihXzmHpu2Rh9XrrGVmOrbLBe
        zD/2P/kfD3N2WOnTQYEfMRU=
X-Google-Smtp-Source: AK7set83zGBfwIIdGj2u78Yejl5npnGcUU/3kxOM7rghdNvDRp2QU42QsMvnhCzxg1hMxtxs3MXC1w==
X-Received: by 2002:a17:906:9be4:b0:930:eb8e:b1c9 with SMTP id de36-20020a1709069be400b00930eb8eb1c9mr560320ejc.24.1678962023979;
        Thu, 16 Mar 2023 03:20:23 -0700 (PDT)
Received: from localhost.localdomain (077222238142.warszawa.vectranet.pl. [77.222.238.142])
        by smtp.googlemail.com with ESMTPSA id qh2-20020a170906eca200b008e2dfc6382asm3648118ejb.125.2023.03.16.03.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 03:20:23 -0700 (PDT)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     kuba@kernel.org, steve.glendinning@shawell.net,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com
Cc:     pabeni@redhat.com, szymon.heidrich@gmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: usb: smsc95xx: Limit packet length to skb->len
Date:   Thu, 16 Mar 2023 11:19:54 +0100
Message-Id: <20230316101954.75836-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315212425.12cb48ca@kernel.org>
References: <20230315212425.12cb48ca@kernel.org>
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

Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
V1 -> V2: Move packet length check to prevent kernel panic in skb_pull

 drivers/net/usb/smsc95xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 32d2c60d3..563ecd27b 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1833,6 +1833,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16)((header & RX_STS_FL_) >> 16);
 		align_count = (4 - ((size + NET_IP_ALIGN) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err header=0x%08x\n", header);
+			return 0;
+		}
+
 		if (unlikely(header & RX_STS_ES_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error header=0x%08x\n", header);
-- 
2.40.0

