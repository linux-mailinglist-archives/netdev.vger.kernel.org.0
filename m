Return-Path: <netdev+bounces-9888-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C248272B0D4
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B5AE1C20B37
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA4946B3;
	Sun, 11 Jun 2023 08:39:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13BB1851
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:22 +0000 (UTC)
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1267D2136;
	Sun, 11 Jun 2023 01:39:21 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-3f6e13940daso33942265e9.0;
        Sun, 11 Jun 2023 01:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472759; x=1689064759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9j3iXG/+YIeIlBiX2ev/WXgDLETwZWLu0s0Bz1N8MY=;
        b=VBvm6deGpIrnUDuHQsBhx87/7cENCwfiv7ugbBaKS+nD2Vh3bICsdVDewKoVLSf5CE
         p7L2LwgCS5KAo8lGprswXe4z+MwRCGxGEeY0str18HcPWWdW4QE21B/pMq6ypZ4h5Ce1
         mXkHBIr2xUIGBlGlwN73bSDI+GsBQxNB86U7wImqvKTb1U16M0B0sbTOuNjcHQSmbBDe
         fH3QsLGffgYm/Af4LiaKmKAI9MfTsRkTcA1FfaoU9DaZ+ICHNt4yiUPdY1R5LsYCBr/b
         a7JTHLpZlS/ZPEMNDi2DpnDKkrMSRDKa/3l4BjK+7UnY1Ahd61nTjMUh4tBOzAPR9xy7
         GGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472759; x=1689064759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z9j3iXG/+YIeIlBiX2ev/WXgDLETwZWLu0s0Bz1N8MY=;
        b=Mwd+x1O3OL27nU2RhNgCrVHnJItY9kWMZ/IuREhBczSI3devM4EM9zzhULUFxXhqtD
         vb8g/vtFJP7yBY+B0I+iOw3a+bAAlTUjPTZ+iuwy5Z0i03SMmm+s39TQbsDWu5Dar6OC
         /2zYvRN2dlU3EsxMiopWdQsN7sFNvcE93GaLlDN0U7XTz6dTRo1WzmRUxJxijx3Y9SPk
         Jrj8JTMIv2sXU4mspWlrU71ErELgwrcZkty3lbvotSE1dkJfIdK7XRms9PpHGDWZoNiL
         eqQRJQNuPlrnBGX/fUWydFZhOh0ahTPMguRHDzb60v1BVQIqmJpW5XSjCNcELma8+oS/
         ngVA==
X-Gm-Message-State: AC+VfDzi/XozRd1u54STnqgz02wOWBGZc6FCoHG4DaOLb02flRzQKAwC
	C/YhG6Dfih8RMJa7I9fpfwU=
X-Google-Smtp-Source: ACHHUZ7F9dpaBW0sH8kWcHCa32BYNvf/XftPiwhq9yO4GDpfJXuk2Iic9fnIavexjkFbsXiQ2J2uJw==
X-Received: by 2002:a5d:6347:0:b0:30f:bafb:2478 with SMTP id b7-20020a5d6347000000b0030fbafb2478mr1213207wrw.42.1686472759367;
        Sun, 11 Jun 2023 01:39:19 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:19 -0700 (PDT)
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
Subject: [PATCH net v3 0/7] net: dsa: mt7530: fix multiple CPU ports, BPDU and LLDP handling
Date: Sun, 11 Jun 2023 11:39:07 +0300
Message-Id: <20230611083914.28603-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
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

Hi.

This patch series fixes hopefully all issues regarding multiple CPU ports
and the handling of LLDP frames and BPDUs.

I am adding me as a maintainer, I've got some code improvements on the way.
I will keep an eye on this driver and the patches submitted for it in the
future.

Arınç

v3: Fix the from header on the patches. Write a cover letter.
v2: Add patches to fix the handling of LLDP frames and BPDUs.

 MAINTAINERS              |  5 +--
 drivers/net/dsa/mt7530.c | 75 ++++++++++++++++++++++++++++++++++++-------
 drivers/net/dsa/mt7530.h | 26 +++++++++------
 include/net/dsa.h        |  8 +++++
 net/dsa/dsa.c            | 24 +++++++++++++-
 5 files changed, 115 insertions(+), 23 deletions(-)



