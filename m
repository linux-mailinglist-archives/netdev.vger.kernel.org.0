Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3096EDE09
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbjDYIa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbjDYIaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:30:02 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DB97AA8;
        Tue, 25 Apr 2023 01:30:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5055141a8fdso7909975a12.3;
        Tue, 25 Apr 2023 01:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411400; x=1685003400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7rU2rEuh2fF/AUhiTvEQmHXWDUbju8C9sKkmr3u6JBw=;
        b=P/ECSuh6Fs+oMNsVuAbO7v2WqO2J8/Bs7A6vuJ7oPUFYjuhaSJXrnd6tw8ERYNodHv
         M4MKjb7+pE/aDSS8oa1OVS683xnnTg0sJRGEiI8ZMy2PLihmdJj6yXp4x6fmuoW3vgOP
         qSnVT4BHlhybLzJkfpBu2C32NqXDM9acUB2nhbNlx8/SjRa0IyQ9LsVWRHUgtbGHWUVk
         +Yc/M4qGMqoWP1Wr8DKjVfWzEzKXc0Eh66evGXDZ7F42OlCUzTNfKzT/7RTjMwUetU/m
         JatOPGsJKen2PS2Lo9I1mDQo/AtWmFYcYUXmWyiaAc7oIEMprE3PCRuaJzcV2vh24ZMl
         0iOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411400; x=1685003400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7rU2rEuh2fF/AUhiTvEQmHXWDUbju8C9sKkmr3u6JBw=;
        b=L7JCA9qaZVs6akFCi20QbAayaAIqieb8XyBAchsEnYycTxj3Yqrdd4naojDe16Rerj
         uYAvI7sSFTxsZAoK/XsBd1KZHzBe+Z1oe9AuSSPoxjNyvJbtkZSwcBuWogluYOMUa1rV
         6ekwgBvZDbgo0iExO2c8XcY/cyXQYGrLc2VlXJDpCK+ZwgyPtbZ6qHDYVb5yRD9k/HYQ
         DvdP5uZ5iv73+aA63Aa+eX5x93OeE8uH2grN9AZp9Q3IkGDdoFNWlKyadlIPKsQrIaAW
         3LsgtRxgYF4pmJfQQb3dctjBY0aS4ScJkjRPn9rm+/SPSfeUwg1mYs6qkEuBhxU2VH3e
         42Ww==
X-Gm-Message-State: AAQBX9edfLzM6w5oSYkE/I5wbmEq7hDvaLEmNfQVaipL9at66MiKeE3E
        Zp73OBFiAAaK5rOkRu8YraQ=
X-Google-Smtp-Source: AKy350bkcOtAPqPEVvCIw4dBxIjTwoE4qSLUO9+d/iejSLnws3XSgdmdmMCOCq8NCWekbY1afU7U0A==
X-Received: by 2002:aa7:de11:0:b0:506:b209:edb with SMTP id h17-20020aa7de11000000b00506b2090edbmr12731369edv.38.1682411399523;
        Tue, 25 Apr 2023 01:29:59 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:29:59 -0700 (PDT)
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
Subject: [PATCH net-next 03/24] net: dsa: mt7530: use p5_interface_select as data type for p5_intf_sel
Date:   Tue, 25 Apr 2023 11:29:12 +0300
Message-Id: <20230425082933.84654-4-arinc.unal@arinc9.com>
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

Use the p5_interface_select enumeration as the data type for the
p5_intf_sel field. This ensures p5_intf_sel can only take the values
defined in the p5_interface_select enumeration.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 845f5dd16d83..415d8ea07472 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -675,7 +675,7 @@ struct mt7530_port {
 
 /* Port 5 interface select definitions */
 enum p5_interface_select {
-	P5_DISABLED = 0,
+	P5_DISABLED,
 	P5_INTF_SEL_PHY_P0,
 	P5_INTF_SEL_PHY_P4,
 	P5_INTF_SEL_GMAC5,
@@ -768,7 +768,7 @@ struct mt7530_priv {
 	bool			mcm;
 	phy_interface_t		p6_interface;
 	phy_interface_t		p5_interface;
-	unsigned int		p5_intf_sel;
+	enum p5_interface_select p5_intf_sel;
 	u8			mirror_rx;
 	u8			mirror_tx;
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
-- 
2.37.2

