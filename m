Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361BF6EAD37
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbjDUOin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjDUOhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:50 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6439414449;
        Fri, 21 Apr 2023 07:37:25 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-504ecbfddd5so2535011a12.0;
        Fri, 21 Apr 2023 07:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087844; x=1684679844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mjphz1SQ1OrOeSXiEFiIHbe85DtwLLcL9ymLDLdzxyQ=;
        b=cnBzdhaf0YmeisJZ6iXXODyfaLPtrxG+H99ayoHqrmFef08H+RwHTPatggPRoIdvBG
         DQk4Yi2+zGHRCvJiEcPGc2oiZwcTUa8iqjUOAVZvHKqRCPLAU0aHQ7c6QUdiZ00NJp0B
         IPk34XNVA9+9Y5KiIvzh01nys8UkR7KXDkZqGpowv+DLAZPrNhSwICIJWFCT2zZHSP/E
         m1oz5h0XYOXTeRQgkMj1A0UfAcWje8uJGtBNtFqetJNy+9vpGHOTefudrid6DXtaIH0v
         VbVu4EkfrPQv3PC5tb/PMFcN7N3pG0N/Iji2jbLcMTwFvgozWDF2q4/JOjvOwabqKWnL
         EKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087844; x=1684679844;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mjphz1SQ1OrOeSXiEFiIHbe85DtwLLcL9ymLDLdzxyQ=;
        b=M179Vv7onQGFSWnGCfkUxQ5zxSdowL+ohDH6GHmEQH/R9Hq4RNNiTlKHpydAE709Ha
         VaJ1pmlnQ1Sk/wlUXytsdqQFU1Ck3sMoxlh4gNSUDDVzi2vXssVawfnLw/EWsmyVlxU+
         0KsLLwOGRSDZmT9FuzEE854/jAfyXwzvp1i0L+XAtjRf28x5s+6eY9eZsoB7qJLRQrvx
         lFvLmQHt9bdO6Hdn3AMArKkT72NuS4n5plAnUMw+W1+llbzrIAW41mTQ8y74nPPgS0rE
         XY/X+JWp9R/bpdZ596qEsZUqaXsr7Qng2QiN03vgYZ0B+EMsN7A8AgtIbiSVkuvmZZB4
         ODNg==
X-Gm-Message-State: AAQBX9fz/r3l/XJHVRaieLv4soNbKvYnZHvyzYMKwThXrfQ9C0VYlPWM
        MqZQLDj0jwiZXcqV4FA63GU=
X-Google-Smtp-Source: AKy350avDHrE1AHP0UASNUQGVphBKj5SjdYshuXQsFJQXaQYtBX6uitIm0GFXha004CfnFV37GEqeA==
X-Received: by 2002:a17:906:bc43:b0:94d:cebe:691 with SMTP id s3-20020a170906bc4300b0094dcebe0691mr2481692ejv.69.1682087843438;
        Fri, 21 Apr 2023 07:37:23 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:23 -0700 (PDT)
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
Subject: [RFC PATCH net-next 13/22] net: dsa: mt7530: move enabling port 6 to mt7530_setup_port6()
Date:   Fri, 21 Apr 2023 17:36:39 +0300
Message-Id: <20230421143648.87889-14-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
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
index eaa36d41e8b9..8fe9b1e6932c 100644
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

