Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB876EDE2E
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjDYIc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbjDYIbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:48 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA0913C3C;
        Tue, 25 Apr 2023 01:30:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9536df4b907so1010396066b.0;
        Tue, 25 Apr 2023 01:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411437; x=1685003437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C5hqUQUWJA4Uxj9fJ3Q/CFxmrWCj6ubL+CzXNJi3V1s=;
        b=l6Zmw5EkxiNQk+byLSELxBUGpq8fx69yVzl8OnHtsAdKEPG57VTkFohAnDFKn5maJV
         +NupxKI9QlQzq3hcCniFstqkxZdfJxYcKY2T0A6sn37l2eSu7/BUfpmqUTCz/8duqtcz
         aQ5pf4IWcK/LiFfP/HYsvX/ii1Xu+lP23zV/k/ySZc4iksp8itwYux+s3LaS1DMLoarf
         IcLPWfjkA9xU2/m95m6aiZQQ/Y9tPsozse6D3dGkalyogZDGE1fg2N2cVbNT0dOljW7m
         2/52tKdaFQTEK177jh9lK/TU7+mml47SfUT7jc1NUSlwjpDYSQFgEj3kmcmGqv3WoMkg
         FdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411437; x=1685003437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C5hqUQUWJA4Uxj9fJ3Q/CFxmrWCj6ubL+CzXNJi3V1s=;
        b=Jyodfs8YBek0Zo0B485HBG7bDazQv4jRMTXWxHca/XMvAXLYy0GmxMNhAj8Or/9NCt
         18YGTB0RUYgDavLESDmmUMU5wrdeSNcz+60ksrB+L8IpQ7Zgu+QFmJOKmk1HbN10x5Pa
         adtL2ROw1bxZuPCImchXeRJ/AUJ+up1i4/ocLDywyfBvVAhnbdv+ws9OBHiJeCmNH8xF
         hAhDN69ZvvczfPd9NEas1NMbQeXBQk6GwTprKmswqi3QUANDVkKAdh7tnhj8rIRBrep+
         jgrvWW+dRsSe9CtUbDm5zZ2C2TEf1u3LJtMawsqgE75wxDWtojaRISwGs/RPJm2uqGH6
         BpNg==
X-Gm-Message-State: AAQBX9fPOE++TiQv48jRWs4VgHe8w81mpr9uoTRZ60ve2pL4Lj1bQc5Z
        TvpROM+c/GTOECB4gyf1KjI=
X-Google-Smtp-Source: AKy350b37JDSEapeflnu+5zn7Wr27HMEhEoGZYWKkBgRxS9IHg7Eds53wkx91bSWNPonWlDIM7kelA==
X-Received: by 2002:a17:907:d21:b0:94f:39d7:6454 with SMTP id gn33-20020a1709070d2100b0094f39d76454mr14917820ejc.63.1682411437241;
        Tue, 25 Apr 2023 01:30:37 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:36 -0700 (PDT)
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
Subject: [PATCH net-next 18/24] net: dsa: mt7530: fix port capabilities for MT7988
Date:   Tue, 25 Apr 2023 11:29:27 +0300
Message-Id: <20230425082933.84654-19-arinc.unal@arinc9.com>
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

On the switch on the MT7988 SoC, there are only 4 PHYs. That's port 0 to 3.
Set the internal phy cases to '0 ... 3'.

There's no need to clear the config->supported_interfaces bitmap before
reporting the supported interfaces as all bits in the bitmap will already
be initialized to zero when the phylink_config structure is allocated.
There's no code that would change the bitmap beforehand. Remove it.

Fixes: 110c18bfed41 ("net: dsa: mt7530: introduce driver for MT7988 built-in switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 468c50b3f43b..aee1e4d71547 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2532,10 +2532,8 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
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

