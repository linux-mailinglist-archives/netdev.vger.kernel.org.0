Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6D56EDE35
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbjDYIdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbjDYIb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:31:57 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7498F7ECE;
        Tue, 25 Apr 2023 01:30:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-94f4b911570so816954166b.0;
        Tue, 25 Apr 2023 01:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411451; x=1685003451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhSDmARWK3jKhREdryVEpo1kzcrG/J9lPlnEWmEYZtA=;
        b=b0Cn9iBrAx9Y/MQc9dApT/Mb+Khuke3PLQx+DLda2w7yO7TrHfxjKosXEJIZq3udq2
         Y3Xu4lTFlFaf2s9fJUESiELrqMoSC1H6nLhsuk+KSN/SUSh36qMk90ABwu5MBOGzgjRW
         GA8TINC8OSr7Frby9GwROuBWoeQC9KQjDldpU1ZGNHn161Y4KVh9EuRwZ0pOX7rD2fdS
         L7bxsHZNkr2nL4Xa1JB20lkb3qeEVrc2IqcUw9vglud9IHnWwH0jby6lLWvhHyJ+2hdZ
         sIKcw+81v8PwSoHbKQkdkCXjx2okk2zNngQP0gcBbW+NvNMHP3GbR1gAPHgoAl1IxBQw
         glQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411451; x=1685003451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhSDmARWK3jKhREdryVEpo1kzcrG/J9lPlnEWmEYZtA=;
        b=bJckyGrE/EHiF4t1AqOHGHQmXtJPTk7mZNenxkcmcp+47BIzmd+ZhEgkZMVKUR+VDw
         EZWDbuLqSAGU08TwB8DVSFl8ZYEoyPpC3S7WQAqk4GGCbFUEtBIB7Tzf5k3HgXFREVrG
         SuZy0ehHB4tbtE8khPXIjiX/vDHNtor6F9zkaqdyRw0OFsxIo3x4cyvA5BHWM9Te8kpE
         pWrNqC2dT2B8NYCXvUoF1F55SnsZUJ21fB/GEUlySxFN0NIq2jt7AcLNJVz/9LXkVH7S
         AnWeI3O5hfYklYRHA0yGek+7e01ieOrhNfORQovKT8YlIKGPe3ShzEHkP7E3h1HqpWcB
         WBSA==
X-Gm-Message-State: AAQBX9e49qdl+u+F02xNBfe7C7BwpweYneBuQrU1bxDq1zTl/sYNRY+N
        1esnPw4ySfrrKJEK33KOhXI=
X-Google-Smtp-Source: AKy350avauxmrnYt7UbqavTFPzSEGaHeYx46xHxOTFeoHvbIj67bh5ZnlSK6IQpI8XT4eqilpC/oCA==
X-Received: by 2002:a17:906:8687:b0:94e:e1c7:31b4 with SMTP id g7-20020a170906868700b0094ee1c731b4mr12182480ejx.48.1682411451338;
        Tue, 25 Apr 2023 01:30:51 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:30:50 -0700 (PDT)
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
Subject: [PATCH net-next 24/24] net: dsa: mt7530: run mt7530_pll_setup() only with 40 MHz XTAL
Date:   Tue, 25 Apr 2023 11:29:33 +0300
Message-Id: <20230425082933.84654-25-arinc.unal@arinc9.com>
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

The code on mt7530_pll_setup() needs to be run only on the MT7530 switch
with a 40 MHz oscillator. Introduce a check to do this.

Link: https://github.com/BPI-SINOVOIP/BPI-R2-bsp/blob/4a5dd143f2172ec97a2872fa29c7c4cd520f45b5/linux-mt/drivers/net/ethernet/mediatek/gsw_mt7623.c#L1039
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 62e55df273cc..e079b45fad07 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2206,7 +2206,8 @@ mt7530_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
-	mt7530_pll_setup(priv);
+	if (xtal == HWTRAP_XTAL_40MHZ)
+		mt7530_pll_setup(priv);
 
 	/* Lower P5 RGMII Tx driving, 8mA */
 	mt7530_write(priv, MT7530_IO_DRV_CR,
-- 
2.37.2

