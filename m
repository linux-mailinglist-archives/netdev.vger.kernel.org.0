Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3E76EDE24
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjDYIcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbjDYIba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:30 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775113C27;
        Tue, 25 Apr 2023 01:30:38 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-956eacbe651so958824966b.3;
        Tue, 25 Apr 2023 01:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411427; x=1685003427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MATvTsgGeOmEQ/GANoUT20RiIWs3kO1MdMdepZzbt0=;
        b=bjcPp1ixgcYS0CdsMEKFpoRu5Vl9iYehRJyOq+x3P+aPBuYpVbrBkxhDE60ijZq4Cn
         jsAE6U7+b2vCL4yZJg6hDCZrZkjgZXqD1Fk+FHc30mWrtj31wfLnjVvbNfceZ7xwlOE9
         dcVL9knnSHgtpJFYrObMrkCAWBD0JhQJKWW2VmvOVEg7E7XuL0yCSc6RKFSPmvlVamG+
         ztYFGQInl27UNENF0L6JukJ63mBAw1u1lZE+RxMDKVeZNrVOXIbsAOVAE8t0rpzFF/j+
         CZhTBxMbN5iW0l+3973AX/+j6/Z0WSfZ2qxvPR5aXn/3v7Pfi94NFbkeQbnDROUntJoU
         DLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411427; x=1685003427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MATvTsgGeOmEQ/GANoUT20RiIWs3kO1MdMdepZzbt0=;
        b=hy9d+v8XqmJp3rnKUd5yTtgUlV1uCOljEgf1qGAptksT6ytixN4h8lv7i2O41jzY6L
         fjGAi4BEjJzPG7qgCg7KbO6OSVFWVyncBSFNM1ZLqCASVLBmVYU9xyAFcrPekhfCoMlW
         CvYdTVjYjhmBTySWPlRDQXCMkGVcWxWweR+zu5avpdAF5dhti4+5IBRVnT19k6dhgLHP
         4q5/5eVdx3xcbIL3byrAA5UiPOrSv4tStwPrrjI6VEPtqGMb3KqaiscTy3/yOn+q+ma9
         RDkdTuKVQrvheX3Umf/CfqaZMa2u2lPfAcyP08ijo3hjbPe6/Dt/ZKc3JZyBh7CmvEle
         8usw==
X-Gm-Message-State: AAQBX9cH2VupmrFAlvTrFo8ILpQ6jHEL6HAnwQfCnMD9gmI3iNdcNVJi
        SVonTjIRxoPysw4B/VSyE1s=
X-Google-Smtp-Source: AKy350Ym3aXZPGeAbGZAmIl+ZSX9R9HZR20W6VN0rTWWg05z4lCRUaNGqdiq7x1Mun7p5ti0Rr6aog==
X-Received: by 2002:a17:906:9bfa:b0:94e:c4b:4d95 with SMTP id de58-20020a1709069bfa00b0094e0c4b4d95mr12322934ejc.69.1682411427432;
        Tue, 25 Apr 2023 01:30:27 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:26 -0700 (PDT)
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
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 14/24] net: dsa: mt7530: move enabling port 6 to mt7530_setup_port6()
Date:   Tue, 25 Apr 2023 11:29:23 +0300
Message-Id: <20230425082933.84654-15-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230425082933.84654-1-arinc.unal@arinc9.com>
References: <20230425082933.84654-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Enable port 6 only when port 6 is being used. Update the comment on
mt7530_setup() with a better explanation.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 04a48829465c..980d59170ba2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,11 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal;
+	u32 ncpo1, ssc_delta, trgint, xtal, val;
+
+	val = mt7530_read(priv, MT7530_MHWTRAP);
+	val &= ~MHWTRAP_P6_DIS;
+	mt7530_write(priv, MT7530_MHWTRAP, val);
 
 	xtal = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
 
@@ -2224,9 +2228,9 @@ mt7530_setup(struct dsa_switch *ds)
 		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
 			   RD_TAP_MASK, RD_TAP(16));
 
-	/* Enable port 6 */
+	/* Enable PHY access and operate in manual mode */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
-	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
+	val &= ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
-- 
2.37.2

