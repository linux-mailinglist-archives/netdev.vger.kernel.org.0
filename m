Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87746DAE52
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbjDGNud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239658AbjDGNtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:49:53 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A723C660;
        Fri,  7 Apr 2023 06:47:35 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54c0c86a436so96826077b3.6;
        Fri, 07 Apr 2023 06:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1HASBb71XtLwecn3CRcGVRneQXdr8W/qyVtG8y0vZQ=;
        b=nyWA4EQ30Lz7Z4a91iWxW0yFcH5DiujHL1C9mYTH8A3PqJsCVElakqiyjcg72CMqZt
         jMlxzkJ3LF6uVdqB9TbyHGrZsLiGkEl+cirgcCkMd1YKZmEUl3mAOjoZLfJQZRM/bQ18
         GAv7ODceNyHqp+wbTyowvGsxio+SMzsrrnMUP5HfgnGZJ/LsVB9KjTouJIfLB+HC7FBe
         2MNZWPjiy18CkfEY9O3wOxueliKlWnopMrg3tTbVdbwiC1Tl2Z3DFsfOkvjBTmHxenXz
         Q8dqBnmIioGC+JOahdzkHDGwqy3M/kYhLZJTcPmzIvRazNqACZic32m44lxyQ7IztMyC
         6iEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1HASBb71XtLwecn3CRcGVRneQXdr8W/qyVtG8y0vZQ=;
        b=nYJUtyHAEY9sNEHdYurA43f4fhfRsMU8BR0B4E3TOv0JX0jqw+x9SMY/k9gCDk9DW5
         XCxi3XOytYxIIsDp2Wa1y0VIpG1G6PBbrpXysWT7gGrZg/s59q0HUlhR3L/XtJ7K87E5
         YjQCrbqpPE7DPDwcU9Fd7AEgQ4BrfTeu7GWBYvfnUw+hJJjBxw4iuYApUCQUXnJoyCaU
         Ed5tjQNTROk2AQMshzltlhTTfOiMNqxR/mpGniWaEiEw+FB20my64F65/YPvUdOEmDNF
         zr3yVTvL4x8ZfkV+Yfz671feROY/a471Xp/Y2EyawAGaVmbxmyw0xouLlcnbdTv0wnO9
         R9Yg==
X-Gm-Message-State: AAQBX9f9PDCgyYhHNB/ujzpOuQzbdEEd3ecJcxbNCtsFInoIhw2nh6Vl
        S4mKh4SUAZLSvxPFXDGZBCc=
X-Google-Smtp-Source: AKy350ZjQyB7r5zLr3cqyHm1Yiv9Pt+md3WiiRwq5UnsioctFwZEM4XEPYHrU5Y8xfI1wc9PE++k4A==
X-Received: by 2002:a0d:ef07:0:b0:540:cb3f:b34a with SMTP id y7-20020a0def07000000b00540cb3fb34amr1992837ywe.32.1680875254253;
        Fri, 07 Apr 2023 06:47:34 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:34 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 13/14] net: dsa: mt7530: fix port capabilities for MT7988
Date:   Fri,  7 Apr 2023 16:46:25 +0300
Message-Id: <20230407134626.47928-14-arinc.unal@arinc9.com>
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

On the switch on the MT7988 SoC, there are only 4 PHYs. That's port 0 to 3.
Set the internal phy cases to '0 ... 3'.

There's no need to clear the config->supported_interfaces bitmap before
reporting the supported interfaces as all bits in the bitmap will already
be initialized to zero when the phylink_config structure is allocated.
There's no code that would change the bitmap beforehand. Remove it.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 6fbbdcb5987f..903e39b7b772 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2545,10 +2545,8 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
 static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
 				     struct phylink_config *config)
 {
-	phy_interface_zero(config->supported_interfaces);
-
 	switch (port) {
-	case 0 ... 4: /* Internal phy */
+	case 0 ... 3: /* Internal phy */
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
 		break;
-- 
2.37.2

