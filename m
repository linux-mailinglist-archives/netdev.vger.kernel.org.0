Return-Path: <netdev+bounces-9895-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7357072B0E4
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA0841C20B6F
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:41:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB3F538B;
	Sun, 11 Jun 2023 08:39:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40229BE5F
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:48 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E337E3589;
	Sun, 11 Jun 2023 01:39:42 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f6d38a140bso23659895e9.1;
        Sun, 11 Jun 2023 01:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472781; x=1689064781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIVXF0NWT+mxXgpNldoq9Ep8Ze5GWaI0IQCYTwDNGis=;
        b=fyj5u9TgodvwQiPlaW3l2gBOlGMjw4nB4gyrbVYsdzQuKc6KYDmX3RflBr27L3Mf/p
         0l7NqqFFR/f6Y1znVmuMCzv332atRp7QEdAeP0jWlZNIVL2oK6w5QYRjyRE4s7Pxo3Qc
         IdOBKbwjtK/zI9+ecW+xixlC48lJBSXEvpgPwLDaYE4peCcAREuZv1tzr9vwPiEDEmZL
         g0wYFZwWp7AN3JclhU0F9/mEDe0s5kfJNsur+8KuPqh8YEQInF0H++V4pWKxDj7Xxv7U
         He6ga3IhvbLH1pFSFocLaq35lqSGTDuLpdVCA3hlBFEUjXBVs/q4fXLxWq214BjsDFYs
         Uw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472781; x=1689064781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIVXF0NWT+mxXgpNldoq9Ep8Ze5GWaI0IQCYTwDNGis=;
        b=OwSrdvC0JKtUCjRpfmbavDx579bxoCDfHlGXgutEGUUIinlLZFy289aYDwzAyIZEn+
         gliCKEKShHV60/PxgmmZbphx+v41B/uGiSUbGMvriYhJM9QKwgQ7w931rQ2hVctyS90f
         7mHSXBWmffOzVme8vkzjaLztpix5eTvY64NYpQhC1lJe4T8xK/vxLCCNq1RJF40MfKP9
         mVIIX91wee12s7H8dR1WtgYNGls+ArZsX0LgXCq5/pTilv3IfFoeQe21Y5elT7CEESDv
         n4aqGbpRTDwUnFwABC+k48AVzh3C5TlvNsVJwI9iu5iY5vKgwL6TdSeyCJ5v2Kxq0J8s
         Ym7w==
X-Gm-Message-State: AC+VfDzwShlt9M0h6A+PPjRd7EJrjHYug5bEIxwy6I9H+U8DzGueec/J
	Z/RnjLD6bBkD7bP+VN250lg=
X-Google-Smtp-Source: ACHHUZ573Z43w980OoHuSFbgqdWgSkSlzAF1vEzQjNCHRAk6evwG2lmA/378fvU8tBQfx7HmyGZLKA==
X-Received: by 2002:a1c:7204:0:b0:3f6:d90:3db with SMTP id n4-20020a1c7204000000b003f60d9003dbmr5029112wmc.3.1686472780674;
        Sun, 11 Jun 2023 01:39:40 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:40 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
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
Cc: Landen Chao <landen.chao@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net v3 7/7] MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER
Date: Sun, 11 Jun 2023 11:39:14 +0300
Message-Id: <20230611083914.28603-8-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230611083914.28603-1-arinc.unal@arinc9.com>
References: <20230611083914.28603-1-arinc.unal@arinc9.com>
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

Add me as a maintainer of the MediaTek MT7530 DSA subdriver.

List maintainers in alphabetical order by first name.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a73e5a98503a..c58d7fbb40ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13259,10 +13259,11 @@ F:	drivers/memory/mtk-smi.c
 F:	include/soc/mediatek/smi.h
 
 MEDIATEK SWITCH DRIVER
-M:	Sean Wang <sean.wang@mediatek.com>
+M:	Arınç ÜNAL <arinc.unal@arinc9.com>
+M:	Daniel Golle <daniel@makrotopia.org>
 M:	Landen Chao <Landen.Chao@mediatek.com>
 M:	DENG Qingfang <dqfext@gmail.com>
-M:	Daniel Golle <daniel@makrotopia.org>
+M:	Sean Wang <sean.wang@mediatek.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/mt7530-mdio.c
-- 
2.39.2


