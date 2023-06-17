Return-Path: <netdev+bounces-11683-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5E1733EB4
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDBBB281937
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E484C7C;
	Sat, 17 Jun 2023 06:27:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243276FAF
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 06:27:22 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEFFE66;
	Fri, 16 Jun 2023 23:27:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51a2c60c529so1910064a12.3;
        Fri, 16 Jun 2023 23:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686983237; x=1689575237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIVXF0NWT+mxXgpNldoq9Ep8Ze5GWaI0IQCYTwDNGis=;
        b=hMBy/DBGMMhKjgj4TvwZGAL6qHd6IBXDB3RDWrOdOSy+rj/i9cPRGEqtOlYC3JsZBh
         5+yU+K4HJ8jIrYvzovdn8DDvzEX3N5yemPVyhdzG9TDH+0ym9tppqwZRtw4B69X05g9f
         81szHbTxo+P0zKLrdq7STupOPzGA3mFskVZ7M66uwXRq3MqR9WnLpnZwvnLYiScvlEbE
         xiNoaxR55FHW6aQvvtBOah9pmuHrvEZgLiWV0x+JIo5Hc84GF/BlL2RY1pNR83nlMzH0
         C+CCporkgq6zO++bOwNtbCPPBP9wrkHJvN0q8RP38tswYG4vXVSK70hGb+ZMEXHjEgBs
         9PHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686983237; x=1689575237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIVXF0NWT+mxXgpNldoq9Ep8Ze5GWaI0IQCYTwDNGis=;
        b=NLKt/qsgrcY5opQ3o+1DYITZ0dPDE50L4aGnv0Jnijv2KtISiDqKb05Rwh36q6clSf
         36M1dYmEF+TX83hKatTGjSscgPLk9L3TsylgOo2VURl2QGXE7O3q5kbpNSr7GPlTeYYn
         rr8D94S8DM0/cZfB9+OPRp2G++1SaP+tPgJt9WENIx9c3e/dTG/cQvWv1gTdmRkgM0hn
         P3uav1VtdUk5KQMeE/5xDAhnJQkd4EVzHgFzMSYXe7lRcbCsQtN7vOvpuktQohggc92v
         VDsUSiLVQDhob7Bl5+1NDhgvlQ0B8oRyL0WOpAY42kib28ukqWWifsdHCHfO00jYMIku
         ghdg==
X-Gm-Message-State: AC+VfDxTA4UrX4E4DYIQrt+9cZhkYYMYNktrQWk9FRJ+ETelJCJxeEdT
	qEvOYrjRMImIRruvp1ntWiU=
X-Google-Smtp-Source: ACHHUZ5AWBGrll0vvLcPazt97hroaD4i3taa1f8HY5D2SOh6aex4tQMbuG8SSe5+r0QCoqQHZtUoIQ==
X-Received: by 2002:a17:906:fe0e:b0:96f:f19b:887a with SMTP id wy14-20020a170906fe0e00b0096ff19b887amr3628004ejb.56.1686983237211;
        Fri, 16 Jun 2023 23:27:17 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id n6-20020a056402514600b0051a313a66e8sm1799638edd.45.2023.06.16.23.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 23:27:16 -0700 (PDT)
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
Subject: [PATCH net v6 6/6] MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER
Date: Sat, 17 Jun 2023 09:26:49 +0300
Message-Id: <20230617062649.28444-7-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230617062649.28444-1-arinc.unal@arinc9.com>
References: <20230617062649.28444-1-arinc.unal@arinc9.com>
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


