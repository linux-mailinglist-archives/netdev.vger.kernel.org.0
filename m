Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA726B07FE
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCHNJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjCHNI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:08:59 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D2C3E0B7;
        Wed,  8 Mar 2023 05:07:34 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id q16so15319578wrw.2;
        Wed, 08 Mar 2023 05:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678280844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JuDmDmY4IV0QLoJ1ArzJ4ijcazQ7ZD0u2S2wBUytaV4=;
        b=Dkuy4VDXieLUfg8wLyjcvVyTG3cxdXmVVcyqAjQzY2ESFnznZGMWvTKoAogOrf1tZO
         7xFIAbyFOk3M03a449PZz9nPzsMnohAks1WHPKOutMHa6yvON9XXqpZkhtj4mhjSDvHT
         qGr9G2v6GtndN9sStm89LaOEeRN8glr2KZYlqUVRc8DjKLZa1zJ5g0dZtwMq4vZ3aHaV
         tNSz8ouiBbvLnReajtgAptfEXBDdlO3tj46vruxT+vCOb/mu5wwLW29zEdvmVRTdd3kZ
         MGBHUv0ZH1sPVkbN+1wH0xCoPsT7v52aAFl9QHEMPSUWsnAq1Ooz0/j7KlSuLQucpvjM
         EWow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678280844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JuDmDmY4IV0QLoJ1ArzJ4ijcazQ7ZD0u2S2wBUytaV4=;
        b=SiQkTSsoPib01Ie0zR43kSMNBXvehNZfLHfrRKfwZ6piRXqhZwgN6rVtRWbjNVdiRh
         KtrYQpDfoRMWi98bGOhwXg5cGZ7nlIvKx5rbeBgYBOXqysbkDotxNNQfksgBACJtIMUG
         Mltg3u9vCAexP+FH+IgZtkiHSjF/2LUyC41fhnzpJKAvGeZEBZUhhqiWJ1BQDxWLHhLG
         e0JZjdJPpvmgiJJfm70t7R825fa7p8ebXsBqzX7/R/ChB4VofVJG/zMreScZ0ernlH6v
         nsNv9BrFHnlerICcFn3G3Gt58ZL0vtkejCyd+Fg6vR04U2RTijZgmmyBPDnyvNlDPOT5
         btZg==
X-Gm-Message-State: AO0yUKW6p5EAhoQXPO+uBnqEmC7H3BFnuzZgxg5r1IQIRfliSfTbyC16
        W2ra5ouo4Nlzik5OYE900EM=
X-Google-Smtp-Source: AK7set/96yytF4lJdh5dq0MUq0uqJPsADOci+FXLCWrgSJ+F8EsYh8DcDuDj9WyArHHVFVjqlneYOA==
X-Received: by 2002:adf:eac7:0:b0:2c7:161e:702f with SMTP id o7-20020adfeac7000000b002c7161e702fmr12307060wrn.47.1678280843674;
        Wed, 08 Mar 2023 05:07:23 -0800 (PST)
Received: from arinc9-PC.lan ([212.68.60.226])
        by smtp.gmail.com with ESMTPSA id b3-20020a5d40c3000000b002ce37d2464csm11461328wrq.83.2023.03.08.05.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 05:07:23 -0800 (PST)
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
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 net 1/2] net: dsa: mt7530: remove now incorrect comment regarding port 5
Date:   Wed,  8 Mar 2023 16:07:14 +0300
Message-Id: <20230308130714.77397-1-arinc.unal@arinc9.com>
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

