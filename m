Return-Path: <netdev+bounces-4281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 762A570BDFD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:26:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31BBE280F1F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93AA010780;
	Mon, 22 May 2023 12:17:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8931D168AB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:38 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E38D1FEC;
	Mon, 22 May 2023 05:17:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96f588bc322so587774666b.1;
        Mon, 22 May 2023 05:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757836; x=1687349836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SG7TaztQuB5xH4PvogAkuq91yKarYjtMle5JWo2W3pY=;
        b=EO7b3IAzP1SXc9MmJGIcSSe7861+cIi3CHEghbiJcKaGzWX+L98AMOPbdutsRySWL5
         EJrXsEovtZWyh9eA1nnQk0qsqqPN1J3Xuw8I6LdGVAXKfjyBlTmJEgH6zVShFDGmpRZn
         XkOx+uWN50aPNXztlw8xmKqXj0XhEju7M2jefqZiSvvu0iLYoZD26BzrDluKb95vmhLp
         amdPqR5k6kucItLpP2MP+QGqJGz2lNC5A5f2rUs3pnyPLRVqsXU7wOZJaaUNBSUK9MPw
         PQXBHyWWhrTJ7AMsZx/eAJT4OWw4BPQ9X8ZSt38Dr66aw+A/LIAmG4Jv72WN0UNf7d0G
         Mk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757836; x=1687349836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SG7TaztQuB5xH4PvogAkuq91yKarYjtMle5JWo2W3pY=;
        b=T29EEf7LmCyre83Ld/47Bj7guxdHYWMIIx4RxnZZGBHl8MgTHXnUW27WO6mgCZ6Xek
         m5YZ8Ggk7f5QwpEJ552W7swzhMQu/uU46Fwzvy/ItgL5WMv1xrHyhoiKYPpdv6be7USv
         rfWy3D2uhi0pVF1W5q3DlI0OiASVZutBiz1b54myZ17uQMjkTqJdZCm+7rmgSLthMJeA
         wJULiO36jXybULGNASqaVkT8HGf2W6pxdHWW4RpM78RCvztPE19faJ2pP11h4hmwmRuj
         ZgRYTcD9tiy/bcPro3+x+UuBjr5cDKoumHVo8WIRru8tnUSZ1CezL5qYPC5Mwfh2rIFH
         PR9w==
X-Gm-Message-State: AC+VfDw+GiASgJBvCefjBtc+dg0cjgX/q8LTZrYrcKxNeEO1K8gopdmI
	YPKO7J3VDyF/GVtLeq1QTuU=
X-Google-Smtp-Source: ACHHUZ6ILsyx6GlzQ/rNkEbarGHyNFwGSGGr3EMybRgtPQv7aSowIU1Ar1v0dmHaogkEZpVZCkAldw==
X-Received: by 2002:a17:907:3f1c:b0:96f:c46f:d8fa with SMTP id hq28-20020a1709073f1c00b0096fc46fd8famr4292186ejc.1.1684757836353;
        Mon, 22 May 2023 05:17:16 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:17:15 -0700 (PDT)
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
Subject: [PATCH net-next 30/30] MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER
Date: Mon, 22 May 2023 15:15:32 +0300
Message-Id: <20230522121532.86610-31-arinc.unal@arinc9.com>
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

Add me as a maintainer of the MediaTek MT7530 DSA subdriver.

List maintainers in alphabetical order by first name.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e2fd64c2ebdc..51e8d30651a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13254,10 +13254,11 @@ F:	drivers/memory/mtk-smi.c
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


