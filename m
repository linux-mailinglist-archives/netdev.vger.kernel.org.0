Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F86A6C2100
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 20:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjCTTNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 15:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjCTTN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 15:13:27 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5922ED67;
        Mon, 20 Mar 2023 12:05:53 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id t5so14052800edd.7;
        Mon, 20 Mar 2023 12:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679339133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Y7VIwiwR8mYFvMXmw8WabjmcLf41P6ODn3sZ1KC//g=;
        b=Ke9n3tf24nDhytBbM5nKug+UhgUHofhXF6YpmH8LkLRMt2uoapYyPdQCvHrRpXk6KE
         aOiUDfl7n4Y21fozpsvFbY0l1InVhsZdNNT87DjZDi+I+kGnpI1BGeVx0zAhtkIGKEY4
         YNnd9fvpL5QWUgNaxNrsO18qChp5dB10qq4jNziDFPRpS6dSEdJJGyogcn4CkkksJhvM
         fvNWZlapv6X7aYC5i9tbEuwagNxoNuvqa1mTSEE0hzngeLk1f2iOo8pKrCrtBEwSuH1b
         Q7KOlpNHlsaEV7j69eDrbvmwVm8d+ka6yqF7WbN8t7vBUa3Wv8fElUOEAygc+yXw2a/0
         B+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679339133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Y7VIwiwR8mYFvMXmw8WabjmcLf41P6ODn3sZ1KC//g=;
        b=RxxtqgDAzNBguPydK59wYr923tZCOttpUMmCE8g9qMz4pEtKSrdYEboRcGKQ/Rs74/
         mJ+HTNyhduTln+6kJfIwRwI5oo1PnbAGgh4M8aYx/q/gp0k5qA7or0+NrdJaSiybzGfC
         7j1WkwJWIKk3Pr9bhBwDfqp+GZRPs/MtUf6QSq1nK7v1j3Y1IYu8O2JqIj3WBD0HkVOX
         rRGntGSYIDCe/Pw47p5Cz/eJlHZLcx6lM6oFKMiiQwOSoTOcQsk5HBjHPE0hd0jx+MFO
         +s0aE7ykiLN+EgCTVndLV4srzbe90ItqcvifWrlflQrqVU03mTxJc88YeR9lbViY/mq4
         4TXA==
X-Gm-Message-State: AO0yUKVNvpgQ1u7Ulbgi9lk8nL+W/SsvCVbWCEm2KKF6+TLnYYFoqSGw
        OTbSanQ2TvbMAlwgDZpJ8Fk=
X-Google-Smtp-Source: AK7set/rFIX3ueZxLx34fqzCZdEqcOjqOw7rlu8tPXk89/wUsmLyw853TaLRd/DB8qbKg5Ps65b/tA==
X-Received: by 2002:a17:906:3b12:b0:88a:1ea9:a5ea with SMTP id g18-20020a1709063b1200b0088a1ea9a5eamr88426ejf.65.1679339133426;
        Mon, 20 Mar 2023 12:05:33 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id hy22-20020a1709068a7600b008e53874f8d8sm4717848ejc.180.2023.03.20.12.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 12:05:32 -0700 (PDT)
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
        <angelogioacchino.delregno@collabora.com>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net 3/3] net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case
Date:   Mon, 20 Mar 2023 22:05:20 +0300
Message-Id: <20230320190520.124513-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230320190520.124513-1-arinc.unal@arinc9.com>
References: <20230320190520.124513-1-arinc.unal@arinc9.com>
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

Move setting the ssc_delta variable to under the PHY_INTERFACE_MODE_TRGMII
case as it's only needed when trgmii is used.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8831bd409a40..02410ac439b7 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -441,6 +441,10 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		break;
 	case PHY_INTERFACE_MODE_TRGMII:
 		trgint = 1;
+		if (xtal == HWTRAP_XTAL_25MHZ)
+			ssc_delta = 0x57;
+		else
+			ssc_delta = 0x87;
 		if (priv->id == ID_MT7621) {
 			/* PLL frequency: 150MHz: 1.2GBit */
 			if (xtal == HWTRAP_XTAL_40MHZ)
@@ -460,11 +464,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		return -EINVAL;
 	}
 
-	if (xtal == HWTRAP_XTAL_25MHZ)
-		ssc_delta = 0x57;
-	else
-		ssc_delta = 0x87;
-
 	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
 		   P6_INTF_MODE(trgint));
 
-- 
2.37.2

