Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3109D6B376C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCJHd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCJHdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:33:47 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD195B7DB5;
        Thu,  9 Mar 2023 23:33:45 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v16so4199687wrn.0;
        Thu, 09 Mar 2023 23:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678433624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zarTkLijwIfhb3++coRGP/AsVqk8HV3V1KUfOUgPVtk=;
        b=JzR3GSzGt6g7r6i4Cwic2dUusdk/8qRxYUN/wpStfXAPOmEF1yGACv2eH3kQGepu8+
         di2klWZbKaTV059r+B0wKDMMRMn6tD/qA1zOBnT7aQr2k0cg0lbSTms0fg4Mn+0DVRvu
         MBepKuw6rj9cwHTCI6q54QNE0hRSYeCsExGOmG0Nk5HKjpylZS8flUqZz8mUKtZfsmjS
         U+Hmy1VNJTFE/YsqwOBAQJVfuO3j6dW/sJSrztzHrzghLfEkibEzqS0dS1H+SNY2+fAA
         9WByQ3A62u2/y6AfL5Ezw1EUFBl7yVcgoEHGbwbVamu5KnyD+FHqzKn8FAhNscSh48cn
         k9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678433624;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zarTkLijwIfhb3++coRGP/AsVqk8HV3V1KUfOUgPVtk=;
        b=WNgLVcVLZWK972Uaf1vG1BX6Q873s8Lt1j55wtmlBrEBOcmchzjF91NzMnoHBLNmTp
         mpiYQKk5jSKX33OweGpID+cY+4TpQMmDZy3aUEwgT0IzXKhsNjUzsRdhxN3PhreaI/Kk
         Uz4yEjzKK8lOzSz6o940m2OwUo8zj7+6+aMX2fGW3noI6TmzTfL2iBQ6A3ucVQApvE+H
         2jpvK5qoUke3MJKDOjBhelM07vSKwmAAPHM+icexErOO3oV/eXLSly4qqDuz8GzyaQ6j
         76cka6fQH/atnnmEvVgjg6xJui2rXu0E84te9WGmBeWg7uUlRyMQMKl1VcZNyso6ewA9
         Qcmw==
X-Gm-Message-State: AO0yUKVhwCctnegCH15R8bSdH71o/rT54YhJCo5u4wAE8jGnmGjZk6BA
        UUtqK/WFujRZBDdbNG5XQMs=
X-Google-Smtp-Source: AK7set+zzlSuseUVR2p0H+i3yVkYgwFZudbMm/ifjGFcScl8DRFJsT55wM1RvasPdakrhp0aDQHY1Q==
X-Received: by 2002:a5d:4012:0:b0:2c5:532a:98c4 with SMTP id n18-20020a5d4012000000b002c5532a98c4mr502630wrp.33.1678433624124;
        Thu, 09 Mar 2023 23:33:44 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id bi11-20020a05600c3d8b00b003daffc2ecdesm2023129wmb.13.2023.03.09.23.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 23:33:43 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, erkin.bozoglu@xeront.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 net 1/2] net: dsa: mt7530: remove now incorrect comment regarding port 5
Date:   Fri, 10 Mar 2023 10:33:37 +0300
Message-Id: <20230310073338.5836-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

Remove now incorrect comment regarding port 5 as GMAC5. This is supposed to
be supported since commit 38f790a80560 ("net: dsa: mt7530: Add support for
port 5") under mt7530_setup_port5().

Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v3: Resend so the bot can test it now.

---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a508402c4ecb..b1a79460df0e 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2201,7 +2201,7 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
-	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
+	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
 	val |= MHWTRAP_MANUAL;
-- 
2.37.2

