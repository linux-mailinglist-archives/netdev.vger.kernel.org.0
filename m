Return-Path: <netdev+bounces-4268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8FF070BDA4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD51E1C20AC3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:22:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD1014AA0;
	Mon, 22 May 2023 12:17:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0CD14A9D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:04 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47391BF0;
	Mon, 22 May 2023 05:16:43 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-97000a039b2so112625466b.2;
        Mon, 22 May 2023 05:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757797; x=1687349797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlebeOxwlkH4BlrTKG+sqIzxXmw3yFvwUw1o/jS7CVE=;
        b=CCUVOMg5NOmJkyahPTiVIE7b2Qz5Vgq/LKhxpQjav2u0Up8mDWWHYHm+0NgSpreCKY
         oioifpMAJWedSMwhbyN8jDY9pwgCJGnH7bd4Ygk8b7B9sVPqQtgkc2FCCPFUCBU57ary
         +4BzYdNeuugT1YdEpqBzFbrDvneFS0r+8lPnrweiTEtRITKC7oaLW6cyJ/kwD4d0HzgC
         bNmunD2PsgSccaF0Cl/J7t2B/8ePdkcZBMlRny2V4h2pjYpcAcI8C1aS3NKrJyG5TC9q
         oHAY46EJDa1qCxinrv+tmOSQv/ZrDGNbbRiVZERTjnAeTwNIDVNjrh2Adwcn4nkeV6Lw
         DZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757797; x=1687349797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BlebeOxwlkH4BlrTKG+sqIzxXmw3yFvwUw1o/jS7CVE=;
        b=Lj6ELRdFI7pLiNIS+og3aCb6Z7xwuLNai2VwIGgxMXKfaJ1hshVzMr1L300rpZSt0H
         3h1UyeU0MltKRFk84JPDkVY29ravElPFjPB5S6KMD7mJUwB9vlPNNdLkqIRvmn7FPxd5
         eDk6J1pQALHg5ZEVJDM5cQ5FGehZGrz4HPoxLpQec6acOU+YlBOxEbPtRF9inxP4wREP
         UYUdNw+NLbCKD4EJpKKNbb7eqE2ClnxdpsBAOc/4dG28AdJhhQrnsROywxyRaKp5o2T4
         ClEcvfMjt24IkDuMb+nvshWUJBrn6cAVit65m6vEw/tK1IkLWNi0waFa97QynEIAB9nR
         QXVA==
X-Gm-Message-State: AC+VfDxSK9rrpZPrSpI+gWaWDy7v6gkUqEy+JPVmMUOle73qciGRwQzh
	9UJ4p/U3xogELosCXyfwE8k=
X-Google-Smtp-Source: ACHHUZ5tp5FjFfcmtJpb7cAxVY5NVD2PSNFXgo6ZrgwEF5wMZEr1HL6G4oZxYD/wtw9KZaLVPfXp5g==
X-Received: by 2002:a17:907:7da7:b0:94e:fa56:a74f with SMTP id oz39-20020a1709077da700b0094efa56a74fmr10398638ejc.14.1684757796855;
        Mon, 22 May 2023 05:16:36 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:36 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
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
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 17/30] net: dsa: mt7530: fix port capabilities for MT7988
Date: Mon, 22 May 2023 15:15:19 +0300
Message-Id: <20230522121532.86610-18-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

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
index 514e82299537..f017cc028183 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2533,10 +2533,8 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
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
2.39.2


