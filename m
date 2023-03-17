Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC6C6BE8D3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 13:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCQMIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 08:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCQMIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 08:08:20 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1F6A8E99;
        Fri, 17 Mar 2023 05:08:19 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m18-20020a05600c3b1200b003ed2a3d635eso3162808wms.4;
        Fri, 17 Mar 2023 05:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679054897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4R+McvwLJzdXl02/Ru76qhL6bP85xlaByobAfhbENFE=;
        b=HuNVoBq4yP44zFW0EP2vLEmT4t90Ib3/Al+mUau6fG9SYyHwJXEh36khhetWpPzizI
         UymeupParz1L7s5ovjyLdC4IfvsFbBSMKWGy2upEAZMTy00G8FWCE8opFtglR/KxT6Se
         bmtaacoV9DTrh8TVYXSVkPEcO89yeXDWPsQU5BGRw6w+k+T2G5v/gUMPq74jTtRkQheO
         bmDEymJTsISHSe2oMH8MzPKPyKxP+5XgLODytyajsTIIRvMGuOTgkZpcVa41c7+ocX5M
         cRcDJJWxymJYg/GhLGbGndG7/288cG003LURjmKSlnF2bl/Yc4GMiPD1eWN8anXPh8jh
         qMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679054897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4R+McvwLJzdXl02/Ru76qhL6bP85xlaByobAfhbENFE=;
        b=8M9MEvdQl7aGD4C7v3b2AwAOYw19fyN6DZT+3xqcXArv+eadTqzhasPVlBivf5n0W/
         c3wgFknuWNjFOWi2f09/9lAyj2XOLBotEs2PmAn4mVunyhhEgWZ4+qg2Hpseti9nADnf
         RttOQOh5UjifRVCQ5eSzqZ2vRHCf7euVUoTX3bAQ5YkONiN9/N2CLh1c0aMc1eiRqYvW
         5iCeBFARgyaM8v6F2LtXsfLLnTk0y1PAUxyuHltYC5g0hr25ZvSoKnGI7cWEVq0s/0Yn
         mkk7e3mo5Vbfm2qoMpj+OBXGea+7dIFCbSCSjVWGXzwHpJJ+/mn3ZN+c5TO+M1gDDvJ2
         5Sqw==
X-Gm-Message-State: AO0yUKVQ6Fx5J8jF0cogGMTsECmo1agEnDEF2katVY6ivL7p6XFNEYB0
        yqIRAqmDrjijOSlUENwnOis=
X-Google-Smtp-Source: AK7set/qW1V2Ezj/kapMA0eJpwPRPCevDAIZe7KiNsKDkdKuZyUaYiQkOC+eZxPrCrN7GaowIFrpkg==
X-Received: by 2002:a05:600c:46c7:b0:3d3:49db:9b25 with SMTP id q7-20020a05600c46c700b003d349db9b25mr23764046wmo.26.1679054897573;
        Fri, 17 Mar 2023 05:08:17 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id p2-20020a05600c204200b003e91b9a92c9sm1816031wmg.24.2023.03.17.05.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 05:08:17 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, jonas.gorski@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
Date:   Fri, 17 Mar 2023 13:08:15 +0100
Message-Id: <20230317120815.321871-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

When BCM63xx internal switches are connected to switches with a 4-byte
Broadcom tag, it does not identify the packet as VLAN tagged, so it adds one
based on its PVID (which is likely 0).
Right now, the packet is received by the BCM63xx internal switch and the 6-byte
tag is properly processed. The next step would to decode the corresponding
4-byte tag. However, the internal switch adds an invalid VLAN tag after the
6-byte tag and the 4-byte tag handling fails.
In order to fix this we need to remove the invalid VLAN tag after the 6-byte
tag before passing it to the 4-byte tag decoding.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 net/dsa/tag_brcm.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 10239daa5745..cacdafb41200 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -7,6 +7,7 @@
 
 #include <linux/dsa/brcm.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 
@@ -252,6 +253,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
 static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 					struct net_device *dev)
 {
+	int len = BRCM_LEG_TAG_LEN;
 	int source_port;
 	u8 *brcm_tag;
 
@@ -266,12 +268,16 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
+	/* VLAN tag is added by BCM63xx internal switch */
+	if (netdev_uses_dsa(skb->dev))
+		len += VLAN_HLEN;
+
 	/* Remove Broadcom tag and update checksum */
-	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
+	skb_pull_rcsum(skb, len);
 
 	dsa_default_offload_fwd_mark(skb);
 
-	dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
+	dsa_strip_etype_header(skb, len);
 
 	return skb;
 }
-- 
2.30.2

