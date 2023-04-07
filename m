Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFC66DAE53
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbjDGNuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjDGNsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:42 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF6FC15F;
        Fri,  7 Apr 2023 06:47:11 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-54c0c86a436so96806517b3.6;
        Fri, 07 Apr 2023 06:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+AqGSZF4EpWmaEiD6n9MEgNnwi2D/MewQMHt7iSnW7E=;
        b=VX1EimEtMOkTO34wFtMJvKbArCSU19G6a8AO8Tz072/+hogV/MxTYryk/0IIRbEJyU
         c4bkZ8NytwXSMR7PMxJEw6GJlvohD3aFZs7GqodN3O5MGOKROvE9YpzYW+rKcsBsUgt1
         oAdVR1mwmTFw/NMwT+fl0T1EBA8E+5IiPDfipqm3T5P4W4tpncM9vsZezV/+v35OmUQ8
         Avf9RkcO57XAkmtvLnc1ZFK26tJr3pYpf8GWWArjfDRj/CZdztOdxsQ5P2h8MIutoq8I
         mlwKkL8DAkSFPQMLMHqicpotaJr+W+LeLkWV4i/HthJe1+/NtHjqnckEm1KFGHHHbun1
         3Ydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+AqGSZF4EpWmaEiD6n9MEgNnwi2D/MewQMHt7iSnW7E=;
        b=cAC29ipmZgH/QsA7duiXdNPPvVjrJvq0WfcqbMr65j/PDskodRv71TlZAUs2IEc2NT
         cqMVgitHytuF+ZE3zzn+GUr+GXpbczYZs6M5abSKqF8iUf0jxpHIosJJSLEwdqGlhmpB
         wax7y9yJf6+DGCcidTChfaguG3vc2KQdbysXv2gs0f6NnO+DEEwrMv74X93dzcFaDraf
         E2q7KJzLLeEeL7Gi3fc4D0ORLgrEd7qQteYNgzyr7mghYCVzMXoiJAu66nOBePWp1o5e
         wK5gam6fWtRXSGrMOvMv5tyY8W3q1Ijo/h8hgdP+k8gRdyAQPtVBgchBlBwNnJDRfW4o
         /toQ==
X-Gm-Message-State: AAQBX9eUAQOpvSh22SugGYISs3meTFAA0UbQ5+Y4d1EbRId8vglNNN3g
        115RHBBkzu+bzMAQ+nwdWVY=
X-Google-Smtp-Source: AKy350bd4rVgZF/D5/SVxr84kIeTaWh4xVjOO6pj5hSbNZF7BBMQQiqrS+1ZBAKqayajatlpTyx9jg==
X-Received: by 2002:a81:7055:0:b0:54c:3ab:dd3e with SMTP id l82-20020a817055000000b0054c03abdd3emr2076162ywc.13.1680875227214;
        Fri, 07 Apr 2023 06:47:07 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:47:06 -0700 (PDT)
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
Subject: [RFC PATCH v2 net-next 07/14] net: dsa: mt7530: call port 6 setup from mt7530_mac_config()
Date:   Fri,  7 Apr 2023 16:46:19 +0300
Message-Id: <20230407134626.47928-8-arinc.unal@arinc9.com>
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

mt7530_pad_clk_setup() is called if port 6 is enabled. It used to do more
things than setting up port 6. That part was moved to more appropriate
locations, mt7530_setup() and mt7530_pll_setup().

Now that all it does is set up port 6, rename it to mt7530_setup_port6(),
and move it to a more appropriate location, under mt7530_mac_config().

Leave an empty mt7530_pad_clk_setup() to satisfy the pad_setup function
pointer.

This is the call path for setting up the ports before:

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()
-> mt753x_pad_setup()
   -> mt7530_pad_clk_setup()

This is after:

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()
      -> mt7530_setup_port6()

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index fc5428baa905..c636a888d194 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -401,7 +401,7 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 
 /* Setup port 6 interface mode and TRGMII TX circuit */
 static int
-mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
+mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 ncpo1, ssc_delta, trgint, xtal;
@@ -473,6 +473,12 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	return 0;
 }
 
+static int
+mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
+{
+	return 0;
+}
+
 static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
 {
 	u32 val;
@@ -2583,12 +2589,15 @@ mt7530_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret;
 
-	/* Only need to setup port5. */
-	if (port != 5)
-		return 0;
-
-	mt7530_setup_port5(priv->ds, interface);
+	if (port == 5) {
+		mt7530_setup_port5(priv->ds, interface);
+	} else if (port == 6) {
+		ret = mt7530_setup_port6(priv->ds, interface);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
2.37.2

