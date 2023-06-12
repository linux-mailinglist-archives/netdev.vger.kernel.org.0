Return-Path: <netdev+bounces-9992-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C9E72B982
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:00:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 729CA280C61
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59913E576;
	Mon, 12 Jun 2023 08:00:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD9F2566
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:18 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B31BCC;
	Mon, 12 Jun 2023 00:59:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f735259fa0so40606075e9.1;
        Mon, 12 Jun 2023 00:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556792; x=1689148792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PuMrlcx56+CnpFeWS2U/L2wPX3rDgcReVx0X+vMxKQY=;
        b=dCqK7Xvqo1KgYDTh5DRgWt4XVwZtudUzFHHdWumQX7IRp1ous3MXslkHWa1v7McRWF
         kTXuqXbMaL5cnbBYLM+Fm0B3TPQvFlVE2N1l7KwZx2WTYJ20aMqPvA2qUeOx3CIwW/hi
         tzFwlqufSqp6aI6U0nfBbAsHjKZgnEKRLy6vALLFvKyFhzIkc2uBzwBzJaUGKPBYhfQw
         PkbkjzAYtqyVvi6InVOnWzpE/SOtx7bgaeaHE4937dlym4JntxIFPOBKsShCJy6R33VF
         kWOkuDvf/LLlNY0BnY3Gaixvh7PyA8HC8E7jZ9cFU9r78WyWzV478th5i1tRmbDJFUAy
         8zUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556792; x=1689148792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PuMrlcx56+CnpFeWS2U/L2wPX3rDgcReVx0X+vMxKQY=;
        b=Fhh1x0l10qOzAdXyZ9JaBWwJf9Gir3xNXu8hyFECcKEokRBv7Oiu9mly3rOSuFLXcY
         SFa2ykSmhu/JGx1bANQyQIRdj5kc9UK4+XJ9BcglNzP6KcGnefi7B3V0D/0c0FkvlH+e
         SO13Z6GZnqOd3Qbg18IO9TOS0/1KJ8a8yfAsKiRFTUyDuw3BbbGyIhFh1DAHA/fXu1Zj
         98ZvgLppFApgnBkcVDe1hEupE16ACLyrp8EQ1YG2dl7nJRx5sWi9OFtuZsTJ79jI0Sfg
         g/AHVb7xFSexjAD6rmBDVKFFBnUkJPIzCLwbn64XCmFeBbWwuD434R6Wl5MfoUYb1fCZ
         bJKw==
X-Gm-Message-State: AC+VfDyZ0V3L4ZXNehStBu+2kH7fSlX71twuecGYP5F3naK3lnn17jyc
	grqUWFbIujqBBALh/hkRZZo=
X-Google-Smtp-Source: ACHHUZ5nr3fG2wMVO6gw0M10OZlLC7C5kwkd9MI5dkGS963mAL16Zh+3ij93V3XA/Fy0dub8o/Urbw==
X-Received: by 2002:a7b:c7c6:0:b0:3f7:dfdf:36ce with SMTP id z6-20020a7bc7c6000000b003f7dfdf36cemr6733913wmk.9.1686556791399;
        Mon, 12 Jun 2023 00:59:51 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003f7f2a1484csm10552195wmj.5.2023.06.12.00.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 00:59:51 -0700 (PDT)
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
Subject: [PATCH net v4 0/7] net: dsa: mt7530: fix multiple CPU ports, BPDU and LLDP handling
Date: Mon, 12 Jun 2023 10:59:38 +0300
Message-Id: <20230612075945.16330-1-arinc.unal@arinc9.com>
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

v4: Make the patch logs and my comments in the code easier to understand.
v3: Fix the from header on the patches. Write a cover letter.
v2: Add patches to fix the handling of LLDP frames and BPDUs.

Arınç ÜNAL (7):
  net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7531
  net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7530
  net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
  net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
  net: dsa: mt7530: fix handling of LLDP frames
  net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
  MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER

 MAINTAINERS              |  5 +--
 drivers/net/dsa/mt7530.c | 75 ++++++++++++++++++++++++++++++++++++-------
 drivers/net/dsa/mt7530.h | 26 +++++++++------
 include/net/dsa.h        |  8 +++++
 net/dsa/dsa.c            | 24 +++++++++++++-
 5 files changed, 115 insertions(+), 23 deletions(-)



