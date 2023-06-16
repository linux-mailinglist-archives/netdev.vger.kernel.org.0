Return-Path: <netdev+bounces-11273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A655B732576
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6120C2815E8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 100B0EC0;
	Fri, 16 Jun 2023 02:53:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CB01110
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:53:47 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728652D5E;
	Thu, 15 Jun 2023 19:53:45 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f8d5262dc8so2172205e9.0;
        Thu, 15 Jun 2023 19:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686884024; x=1689476024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AIVXF0NWT+mxXgpNldoq9Ep8Ze5GWaI0IQCYTwDNGis=;
        b=TH8+LNShLJl+lN5lR3SXIDRE6PtqXnSRNJweWN236P/MIEYjkQOt20OHZTs3m/gqdE
         zGyNyeyEJdBx+dDNx5guLPyWxxlKbcQrK1dGm0+PRkP8vzVZw0VR7U/siln+azfbtHPU
         k93f+NVbO2n6Ef4quOJ7b/4G42caGRJ8M0l1r+m2XLHiEIMAilxsHB2VBBCWgSjsAv+J
         JoShn7VsdcB0zX9lG+rpOb42TpOo2PyDg8xI9398Pw/0HZsklD6MIoo3T/YdEK6YwnkO
         iFKCeCEe3kJHnVKxPkYWlJLdwtg+3HJhzQbeW4Kv0g16bWumcpwS8EEU7sq6Sm2Lq7lu
         sqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686884024; x=1689476024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AIVXF0NWT+mxXgpNldoq9Ep8Ze5GWaI0IQCYTwDNGis=;
        b=N0tB3VB246iK866MCD/wVuTcy8BQL0iMHtrLfEZgcqeQytDw2qPHxzh6fGG07rycvG
         z3x+jQMoNYh/2e+wG1JktvXm4i2CwDpTkfZryNH+Ye2Bv+H2h7vPva3DL4N4L6Iohddq
         wm8Kt1sffY3myA1RXKtWHbc9Mc/nwPxHJ2M5ys5O9tS71njJTZE37T1iSzRNLn2F9u3g
         psavJgjhEK4Bj6zivWRj7DnUlFEw/CRs9opxva7NLRhWAnDDsyG4f/B/oHP6xNJw1vV/
         9xOYDnuvUWxlJyRmZlf5Fw9egiddFK8EtIKyiOKB+5hdYdwteD4bZiVCkGJ1J2E6ul2b
         c6IQ==
X-Gm-Message-State: AC+VfDzrBX0Myi8ExcrZi2rii4dm7IjdlpsoR+3L7oSDi0LPf+Nrm/iH
	z58QnMhfDtT2hH47w4paBKM=
X-Google-Smtp-Source: ACHHUZ5eszUdRCoqVl0XnO8o0Flzro58U4rSrS2wesjQ3rQNHV27XtmHlB1V/EdEpBfOJF4FMCoUPQ==
X-Received: by 2002:a05:600c:3657:b0:3f6:8ba:6ea2 with SMTP id y23-20020a05600c365700b003f608ba6ea2mr410986wmq.15.1686884023787;
        Thu, 15 Jun 2023 19:53:43 -0700 (PDT)
Received: from arinc9-Xeront.. (athedsl-404045.home.otenet.gr. [79.131.130.75])
        by smtp.gmail.com with ESMTPSA id v15-20020a1cf70f000000b003f8d770e935sm890328wmh.0.2023.06.15.19.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:53:43 -0700 (PDT)
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
Subject: [PATCH net v5 6/6] MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER
Date: Fri, 16 Jun 2023 05:53:27 +0300
Message-Id: <20230616025327.12652-7-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616025327.12652-1-arinc.unal@arinc9.com>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
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


