Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66556DAE40
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjDGNtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjDGNsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:22 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB48B450;
        Fri,  7 Apr 2023 06:46:47 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5491fa028adso300419247b3.10;
        Fri, 07 Apr 2023 06:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DCKgE17ON7u0QHZu5XuejlM/Ee789bX9Og0M55Yu/Ng=;
        b=FXl03DPkffUd83inDI9nua6QLZG0ri5iSwcLfh4bGFcnshhGYoV/nzfVLu2nbeTVQ3
         H99nr5zoHPBXLGf+2qImHIuMHaTwxJK6dBtbpdqnjzmSnTgDLipt4yb1g7J6Hu8mWe3s
         P9liPnO7uhqDErcxnJ/R2fSWNZV3W5i/hRiCdLm1xZGwgu9phYgrAq7QiVr6aIDEhqCa
         kumcV11FLjiFbSD7fLoNy8ioua+64SGcCQlaOpgZ7mTEl7i5w36pBbF+GOOsHturCL6W
         2I0f2AmxlmV5RonEQ0lb6f45atq7Ey6piHfovamXh/erpqcYBMdGyBiiso7FZxchnbz0
         ujrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DCKgE17ON7u0QHZu5XuejlM/Ee789bX9Og0M55Yu/Ng=;
        b=lTRz5jOulVhe2gpeO3hPMmd55N9/ASFmfhBCLW7NS8Rn+/0Kj4iBaSgWIifJMx1L7P
         7mQtx7Ce2lVUAvw44VIVX0cg+pt0aNG6ZHe5dzBL0kREIHs3pWp+6LWpEg4+eMulVo+T
         gHrLfzNMhOY7dBp3GTCSm9fwz8cC6VEu7doCcgFUpiieYKlnFvaGyvriPPC1qwNnHYy/
         7C/KEmWbsGgyPeqfl/EpAWozAV/cq+hLnnLFIKHpvm7C/d20cP9XafQOmUT+9g6Cixrh
         TUWUg9vT2LJoiQ5cSwFvSpZdu2LnJSQ6H1mhWnHQ+M+Ci7c8A9UhBeZx2QbM8NT8RxfD
         /HYA==
X-Gm-Message-State: AAQBX9cJ7VOCUk+gRhTL7GjoNSbrJj+37VGyJFXdKP4z0DeUGj6cj5iR
        8hjofI3h+zV+jLDr0WdhnRQ=
X-Google-Smtp-Source: AKy350bFexJHt8BM+7xRCz9TGcQvf+PSV4XF/v+yDKLMmRJNDGcPwoW7OeJNexXHi/cRqBgiTSqD4w==
X-Received: by 2002:a0d:d80a:0:b0:54c:eb8:5a5b with SMTP id a10-20020a0dd80a000000b0054c0eb85a5bmr2041776ywe.13.1680875204454;
        Fri, 07 Apr 2023 06:46:44 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:46:44 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH v2 net-next 02/14] net: dsa: mt7530: fix phylink for port 5 and fix port 5 modes
Date:   Fri,  7 Apr 2023 16:46:14 +0300
Message-Id: <20230407134626.47928-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230407134626.47928-1-arinc.unal@arinc9.com>
References: <20230407134626.47928-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

There're two code paths for setting up port 5:

mt7530_setup()
-> mt7530_setup_port5()

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()

The first code path is supposed to run when PHY muxing is being used. In
this case, port 5 is somewhat of a hidden port. It won't be defined on the
devicetree so phylink can't be used to manage the port.

The second code path used to call mt7530_setup_port5() directly under case
5 on mt7530_phylink_mac_config() before it was moved to mt7530_mac_config()
with 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a
new hardware"). mt7530_setup_port5() will never run through this code path
because the current code on mt7530_setup() bypasses phylink for all cases
of port 5.

Fix this by leaving it to phylink if port 5 is used as a CPU, DSA, or user
port. For the cases of PHY muxing or the port being disabled, call
mt7530_setup_port5() directly from mt7530_setup() without involving
phylink.

Move setting the interface and P5_DISABLED mode to a more specific
location. They're supposed to be overwritten if PHY muxing is detected.

Add comments which explain the process.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 31ef70f0cd12..a00aabe4987e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2288,16 +2288,19 @@ mt7530_setup(struct dsa_switch *ds)
 		return ret;
 
 	/* Setup port 5 */
-	priv->p5_intf_sel = P5_DISABLED;
-	interface = PHY_INTERFACE_MODE_NA;
-
 	if (!dsa_is_unused_port(ds, 5)) {
+		/* Set the interface selection of port 5 to GMAC5 when it's used
+		 * as a CPU, DSA, or user port. Let phylink handle the rest.
+		 */
 		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
-		ret = of_get_phy_mode(dsa_to_port(ds, 5)->dn, &interface);
-		if (ret && ret != -ENODEV)
-			return ret;
 	} else {
-		/* Scan the ethernet nodes. look for GMAC1, lookup used phy */
+		/* Scan the ethernet nodes. Look for GMAC1, lookup the used PHY.
+		 * Set priv->p5_intf_sel to P5_DISABLED first, then overwrite it
+		 * if PHY muxing is detected.
+		 */
+		priv->p5_intf_sel = P5_DISABLED;
+		interface = PHY_INTERFACE_MODE_NA;
+
 		for_each_child_of_node(dn, mac_np) {
 			if (!of_device_is_compatible(mac_np,
 						     "mediatek,eth-mac"))
@@ -2328,6 +2331,8 @@ mt7530_setup(struct dsa_switch *ds)
 			of_node_put(phy_node);
 			break;
 		}
+
+		mt7530_setup_port5(ds, interface);
 	}
 
 #ifdef CONFIG_GPIOLIB
@@ -2338,8 +2343,6 @@ mt7530_setup(struct dsa_switch *ds)
 	}
 #endif /* CONFIG_GPIOLIB */
 
-	mt7530_setup_port5(ds, interface);
-
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
-- 
2.37.2

