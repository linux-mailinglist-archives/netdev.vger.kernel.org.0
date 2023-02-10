Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B1C69246A
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbjBJR3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjBJR3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:29:07 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C063735B1;
        Fri, 10 Feb 2023 09:29:06 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lu11so17810846ejb.3;
        Fri, 10 Feb 2023 09:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f8L1vudNKgvkP5IiC7LA/V+jiXwTiR2CGl/rNd3NChc=;
        b=SUisEb0INdY6qQxg082OsELGjB4grFuSp4ezRrzYr+NowLPN4P7WEOExHG+IBsq4ZU
         FhBjlMjxA2gz5XFuELdL19F0qwk51WtvWQZHMyzFM4mh61py6JircSTD5AH2XjL5FXej
         ntnlBqtyMHQq5CytsbgKaMU6no1FbFBFnoLpBx0Xlr6kWEGMa2WGHljv6mY9hIa7ZzeW
         tKpWeQY6LQSjTUq2wFXidkHq1cXwQAf1ZQD5UHDVsADaesytDLQ8MqZsMnUVYJWLFaBm
         dPmtkOch2VMpQFmgJM/zDAAwAXhW8+oOjvzN+GhAsVK2l/5ek7VAvFP0hEquEhb5Ukbr
         v3hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f8L1vudNKgvkP5IiC7LA/V+jiXwTiR2CGl/rNd3NChc=;
        b=MsyCxxAcrA5/l8+NY0cq+jfo17uBO6lmjMQRq+Q7JhuSN4AxKuRMuAAIMhgi30kJ/8
         KYb/uIZ/2pbnfVJAkXAuOTuV7oN6PFCcSQpRCd+yAnuweWjTQUeG7z+7XeWu9T0io4vx
         WhGHJm0ktrCxHrw+lhmEVNtbTYddgtk6aCB+E9GojVNcKd474NxNhmYRklSUONgFOaIa
         Gv2+GHPdlOPZul535Bu5hPiUIdJhw+2uzuufC+Uxt7vH3kdGWKWUTaJPT7EZXkJNqYvS
         rfOIHCfAMSBHQZ9DlOzhFTthoIcbDS3U+G/+c81dCWYQ+V+tAp6+ZhhfhgMIdLoUVhk7
         WgIw==
X-Gm-Message-State: AO0yUKWwNtJjQBJGz1HJA+AZ8n4H5CaozOnCv81vYzYOwjoHHdqFJRR0
        Hni8w8pRpI4BKaUsLsHndzw=
X-Google-Smtp-Source: AK7set9jllG4EL32KZNRFeGz5GqklmGGkaV2tsT1Te4UbaEdKLFVlJ2sVqr/p9Z6ZST975z60DjcAQ==
X-Received: by 2002:a17:907:7295:b0:8af:2cc6:bf74 with SMTP id dt21-20020a170907729500b008af2cc6bf74mr11319203ejc.0.1676050144571;
        Fri, 10 Feb 2023 09:29:04 -0800 (PST)
Received: from arinc9-PC.lan ([37.120.152.236])
        by smtp.gmail.com with ESMTPSA id va29-20020a17090711dd00b0089c72982de6sm2629302ejb.160.2023.02.10.09.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 09:29:04 -0800 (PST)
From:   arinc9.unal@gmail.com
X-Google-Original-From: richard@routerhints.com
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
        <angelogioacchino.delregno@collabora.com>
Cc:     Richard van Schagen <richard@routerhints.com>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
Subject: [PATCH net] net: dsa: mt7530: fix CPU flooding and do not set CPU association
Date:   Fri, 10 Feb 2023 20:28:23 +0300
Message-Id: <20230210172822.12960-1-richard@routerhints.com>
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

From: Richard van Schagen <richard@routerhints.com>

The original code only enables flooding on CPU port, on port 6, since
that's the last one set up. In doing so, it removes flooding on port 5,
which made so that, in order to communicate properly over port 5, a frame
had to be sent from a user port to the DSA master. Fix this.

Since CPU->port is forced via the DSA tag, connecting CPU to all user ports
of the switch breaks communication over VLAN tagged frames. Therefore,
remove the code that sets CPU assocation. This way, the CPU reverts to not
being connected to any port as soon as ".port_enable" is called.

[ arinc.unal@arinc9.com: Wrote subject and changelog ]

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Richard van Schagen <richard@routerhints.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3a15015bc409..b5ad4b4fc00c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -997,6 +997,7 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 	int ret;
+	u32 val;
 
 	/* Setup max capability of CPU port at first */
 	if (priv->info->cpu_port_config) {
@@ -1009,20 +1010,15 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Disable flooding by default */
-	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK,
-		   BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port)));
+	/* Enable flooding on CPU */
+	val = mt7530_read(priv, MT7530_MFC);
+	val |= BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) | UNU_FFP(BIT(port));
+	mt7530_write(priv, MT7530_MFC, val);
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
-	/* CPU port gets connected to all user ports of
-	 * the switch.
-	 */
-	mt7530_write(priv, MT7530_PCR_P(port),
-		     PCR_MATRIX(dsa_user_ports(priv->ds)));
-
 	/* Set to fallback mode for independent VLAN learning */
 	mt7530_rmw(priv, MT7530_PCR_P(port), PCR_PORT_VLAN_MASK,
 		   MT7530_PORT_FALLBACK_MODE);
@@ -2204,6 +2200,9 @@ mt7530_setup(struct dsa_switch *ds)
 
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
+	/* Disable flooding by default */
+	mt7530_rmw(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK | UNU_FFP_MASK, 0);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-- 
2.37.2

