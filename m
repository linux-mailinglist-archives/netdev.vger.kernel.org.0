Return-Path: <netdev+bounces-9892-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D53972B0E1
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84FAD280F9E
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 879FC846C;
	Sun, 11 Jun 2023 08:39:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD5B5226
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:34 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FEF26B0;
	Sun, 11 Jun 2023 01:39:33 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f7fc9014fdso23691875e9.3;
        Sun, 11 Jun 2023 01:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472771; x=1689064771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FQB4VuigsMedHCtX/KwIwxZ3hq2ZGXrdSk/vXxwDWOc=;
        b=A/0zUzEiWv8PMoQ/ihdeZFYygXwdSne9zmBgI5K7ovfCCxWSobu1Mwppkhy2w8glNu
         MYhdVuRgTCRIdlSFHClY/yvO1AQspAksVr3tyaKl+LQiylhN5CxMK8aEbajYniuGMWK9
         Z24Y6XvKM0Ck6/2rnuAwrTA4388TWF8iwVX8hCuQ5uIowGEko8jll+8Xwvk/WeXEc1CH
         vbT2UEvkBK4pTh8WcD0CKAxmuN153lL5HPdQbIxfzKx3SPIbkZikXvyGnUbp42KIYi0o
         Gtyr5196ivwP34HfIM4ebUzOzxEF5Ka3P7Lo82AvpkpllHEn6mWDBRQDOgykuy82ZPKr
         uOEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472771; x=1689064771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FQB4VuigsMedHCtX/KwIwxZ3hq2ZGXrdSk/vXxwDWOc=;
        b=UOzHwLVIf0IKhOWa9MTIVdMYyH2FS+0dmX3IlgccEtllJhsBC4IWBDbG+GMTMClAKR
         xzkjaD3WR1skFbpoZy595HzM2cfy+3MacUhoxsZ6vpcv53J9GHzTo/ITZEH17Fgedv0n
         n6MacAzHynQ2DBuZVer6FIPP/ohlzhqcKcFzSpEA4XWu8HKGqmGRtkSWGFuKe3tQzY5v
         5KCfl3uAxUljOL5yCr83CgBYotMtarCW3hW4ZCQ4SEK0lACXWIytkbN1bfM8iLZEa7Rw
         ZJcbJiBdYwzUjHpAHQrQk3NrpCs/ZsAW0LILeZh4M83jhOMyz9JL9eCF50jT4Wfe4Oba
         fgEg==
X-Gm-Message-State: AC+VfDxL58VKE81Po2GgPeYFq7Q8fKkSvFT7NIfzj43RSYVUeYK4bEwb
	yQusMJvLy3+4LFsjbSzXcOw=
X-Google-Smtp-Source: ACHHUZ5WmPo6ky+0h5mL3oF6BdInjOv/GMMzhWmmzV0x6rKPo/vlw11QC42WnHwwdN9ge9Z26AQ7IQ==
X-Received: by 2002:a05:600c:2190:b0:3f7:395a:c9fa with SMTP id e16-20020a05600c219000b003f7395ac9famr4721374wme.4.1686472771675;
        Sun, 11 Jun 2023 01:39:31 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:31 -0700 (PDT)
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
Subject: [PATCH net v3 4/7] net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
Date: Sun, 11 Jun 2023 11:39:11 +0300
Message-Id: <20230611083914.28603-5-arinc.unal@arinc9.com>
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

BPDUs are link-local frames, therefore they must be trapped to the CPU
port. Currently, the MT7530 switch treats BPDUs as regular multicast
frames, therefore flooding them to user ports. To fix this, set BPDUs to be
trapped to the CPU port.

BPDUs received from a user port will be trapped to the numerically smallest
CPU port which is affine to the DSA conduit interface that is up.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---

v2: Add this patch.

---
 drivers/net/dsa/mt7530.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index df2626f72367..c2af23f2bc5d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2259,6 +2259,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
+	/* Trap BPDUs to the CPU port */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-- 
2.39.2


