Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F856EAD2C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjDUOjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbjDUOiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:38:25 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D944610DD;
        Fri, 21 Apr 2023 07:37:33 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5066ce4f725so2508061a12.1;
        Fri, 21 Apr 2023 07:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087852; x=1684679852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QL82S92PhjBdYfMxindC7dNu43LqusGvD9gOD5L3A2g=;
        b=bKD2PiaWlSQ8fki7UcZX0yKrc00KrG55tW4wCF3mwt+64q32ybCgNLbl1ad+5I5avz
         oGYmtQU12vKk7tUHMxqOgP+rPs0fOnOwCUKUlzVKB5c8FD85wUc0fLnzCwWAXEhIG8ZP
         USVps0ZH6DAcGtUD1LwBymYbYCWG3nriM0pcCfO2fmSOuzruQ1RaM6bUy1didxjJwPPZ
         sMclDWOM5wSOo6C14S5eoVBXT+JImitb+GV7pomFNjjcqT8wwH1W5GkgUi2iWgEwENq3
         e7k6JritmPMtrB/wkStkMxoxklPEmfSzTmEZIFGFUPMBdzoBBJCBnxeIKmoyVpbzoLpE
         f2sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087852; x=1684679852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QL82S92PhjBdYfMxindC7dNu43LqusGvD9gOD5L3A2g=;
        b=a4PhkpYELgjx2AOvU67Djq2ewOjp33/LCv1T0rjZzrojU2AiQx+zrTaypKI82O+nb5
         TsSk42EuAwdbTLV5xx9MVJC+yVzSg1+68RQtE2Boz1/EcPhrxB+fSZfj07UQwGDvIf7+
         5vyyi5Ho/vzmkgmKePe8+1E9Ww0WLkLoq1giJsTS6CZfGpFPdIi7RqzGjCw+2cTs4CRR
         xDlsSDurZT3Q3b9suvkI7Z//LV4Npd/e6w/8exhFP8SvFq1VV6R0jRFLFq4mwhBQU/81
         uHsFVTGb6lE7c4QSeoHpBXW5jaQvbscz/c12GYcdTjFw4hvKKfoyh4CR5vVpOnCiFFf4
         vngw==
X-Gm-Message-State: AAQBX9cLpE4lIf6PDnr6utUxXhnhkfQ4c9q3w8I3f25OEnNjYb2KJs7h
        b62nuFaG/EUoMuDPH9m55aQ=
X-Google-Smtp-Source: AKy350Zz7vHaBqbcCW8whFHVzYvj2/PnK3KBZofM+qOcv70sDcdPH+IJR6ZEBIq25sled6qYWm94nA==
X-Received: by 2002:a17:906:10ce:b0:94f:5242:a03a with SMTP id v14-20020a17090610ce00b0094f5242a03amr3010132ejv.63.1682087852178;
        Fri, 21 Apr 2023 07:37:32 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:31 -0700 (PDT)
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
Subject: [RFC PATCH net-next 17/22] net: dsa: mt7530: fix port capabilities for MT7988
Date:   Fri, 21 Apr 2023 17:36:43 +0300
Message-Id: <20230421143648.87889-18-arinc.unal@arinc9.com>
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
index 5466259fd99b..899fc52193e1 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2538,10 +2538,8 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
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

