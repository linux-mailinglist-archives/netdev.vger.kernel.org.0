Return-Path: <netdev+bounces-4251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8252570BD4A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:17:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 491D81C20AA6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B6ED517;
	Mon, 22 May 2023 12:16:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223574408
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:33 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A900DE43;
	Mon, 22 May 2023 05:16:07 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-510b869fe0dso10633976a12.3;
        Mon, 22 May 2023 05:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757746; x=1687349746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pq2o/rMDZcveu6CBIBMiqQbVdifVenwYFNXXMqMRjP0=;
        b=aQV+uq9SLVhx0nJCHct8trarx9Dq54SBVdoWRvsuUTTaAnagYq1jKKdRWhzRdICwCT
         7aRHHO0ugQDaIMQ9HZm05aSqhn8hRhtdSuxbozAOw/qQfVSmg+5Du+Wk9hkJ+Bz5coSv
         EkaGK8iVyauuODWx5MPHbpum5+hrbUQ/KdVkrtW4CGQeHB20BeRYtqIf7IBLi1Qj3YhD
         Yzj5y9XTDHwRvRLjC1rSC3vTyDLZd5KbkjU860F0eu9Dn4SyGMXoR8b8T1vsUrsKeLTG
         1lZwICVLVobeoQR5RMcskfakhJDj7w9BfGhGJxPUpVYN9R7U9aBtPibNPRYzl/LcERGK
         M6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757746; x=1687349746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pq2o/rMDZcveu6CBIBMiqQbVdifVenwYFNXXMqMRjP0=;
        b=e1WckEpm1CbER7C9UCi0mN7gg/hXUNuh1rbDHpg9jSlMjH1MFsHqy2PjBwlE5e+1/M
         ATHXoYAPOInZD1eIXrTzaJ/CSKdUprIP07K8eNqJkU241EWJCXDBRpyxIo0chlkGMoMZ
         N87IczFLRpmAvnn14UW6gTAcHBwxY0xhQ9Wm4S7lqdfxCqDpgkflDFg97qahzTI0PsuB
         lsJN+/WKTJgr5gzOkW1PspP3gv9ZAj7vaUOrFuLlCHCS4+NMK/3LvwddHabSRiYITjMk
         eq1UeGZclOoaC9pdg/8DNQj7OpS2pnA8YhqJQLM+z8g1peiLqlUNoIqWPpU8QJ2hjKVU
         iycA==
X-Gm-Message-State: AC+VfDy56WPazjBaqjLNP4xv4j2oPx/z0vHXnmmNdcyEO12cfkrbwHp7
	ir6GGFFvC9R4EhNpByvg2ec=
X-Google-Smtp-Source: ACHHUZ44vhIRy0pCs3PauqSUYry3wOlKBzkbAJKp64q8ULc9bXdwGlhNnnOC2BplkNluNqyP2qH/Bw==
X-Received: by 2002:a17:907:97c4:b0:956:fbd7:bc5e with SMTP id js4-20020a17090797c400b00956fbd7bc5emr9630657ejc.64.1684757745526;
        Mon, 22 May 2023 05:15:45 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:15:45 -0700 (PDT)
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
Cc: Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 00/30] net: dsa: mt7530: improve, trap BPDU & LLDP, and prefer CPU port
Date: Mon, 22 May 2023 15:15:02 +0300
Message-Id: <20230522121532.86610-1-arinc.unal@arinc9.com>
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

Hello!

This patch series simplifies the code, improves the logic of the switch
hardware support, traps LLDP frames and BPDUs for MT7530, MT7531, and
MT7988 SoC switches, and introduces the preferring local CPU port
operation.

There's also a patch for fixing the port capabilities of the switch on the
MT7988 SoC.

I have done a bidirectional speed test using iperf3 on all ports of the
MT7530 and MT7531 switches with this patch series applied. I have tested
every possible configuration on the MCM and standalone MT7530 and MT7531
switch. I'll let the name of the dtb files speak for themselves.

MT7621 Unielec:

only-gmac0-mt7621-unielec-u7621-06-16m.dtb
rgmii-only-gmac0-mt7621-unielec-u7621-06-16m.dtb
only-gmac1-mt7621-unielec-u7621-06-16m.dtb
gmac0-and-gmac1-mt7621-unielec-u7621-06-16m.dtb
phy0-muxing-mt7621-unielec-u7621-06-16m.dtb
phy4-muxing-mt7621-unielec-u7621-06-16m.dtb
port5-as-user-mt7621-unielec-u7621-06-16m.dtb

tftpboot 0x80008000 mips-uzImage-next-20230519.bin; tftpboot 0x83000000 mips-rootfs.cpio.uboot; tftpboot 0x83f00000 $dtb; bootm 0x80008000 0x83000000 0x83f00000

MT7622 Bananapi:

only-gmac0-mt7622-bananapi-bpi-r64.dtb
gmac0-and-gmac1-mt7622-bananapi-bpi-r64.dtb
port5-as-user-mt7622-bananapi-bpi-r64.dtb

tftpboot 0x40000000 arm64-Image-next-20230519; tftpboot 0x45000000 arm64-rootfs.cpio.uboot; tftpboot 0x4a000000 $dtb; booti 0x40000000 0x45000000 0x4a000000

MT7623 Bananapi:

only-gmac0-mt7623n-bananapi-bpi-r2.dtb
rgmii-only-gmac0-mt7623n-bananapi-bpi-r2.dtb
only-gmac1-mt7623n-bananapi-bpi-r2.dtb
gmac0-and-gmac1-mt7623n-bananapi-bpi-r2.dtb
phy0-muxing-mt7623n-bananapi-bpi-r2.dtb
phy4-muxing-mt7623n-bananapi-bpi-r2.dtb
port5-as-user-mt7623n-bananapi-bpi-r2.dtb

tftpboot 0x80008000 arm-zImage-next-20230519; tftpboot 0x83000000 arm-rootfs.cpio.uboot; tftpboot 0x83f00000 $dtb; bootz 0x80008000 0x83000000 0x83f00000

Arınç

Arınç ÜNAL (30):
  net: dsa: mt7530: add missing @p5_interface to mt7530_priv description
  net: dsa: mt7530: use p5_interface_select as data type for p5_intf_sel
  net: dsa: mt7530: properly support MT7531AE and MT7531BE
  net: dsa: mt7530: improve comments regarding port 5 and 6
  net: dsa: mt7530: read XTAL value from correct register
  net: dsa: mt7530: improve code path for setting up port 5
  net: dsa: mt7530: do not run mt7530_setup_port5() if port 5 is disabled
  net: dsa: mt7530: change p{5,6}_interface to p{5,6}_configured
  net: dsa: mt7530: empty default case on mt7530_setup_port5()
  net: dsa: mt7530: call port 6 setup from mt7530_mac_config()
  net: dsa: mt7530: remove pad_setup function pointer
  net: dsa: mt7530: move XTAL check to mt7530_setup()
  net: dsa: mt7530: move enabling port 6 to mt7530_setup_port6()
  net: dsa: mt7530: switch to if/else statements on mt7530_setup_port6()
  net: dsa: mt7530: set TRGMII RD TAP if trgmii is being used
  net: dsa: mt7530: move lowering port 5 RGMII driving to mt7530_setup()
  net: dsa: mt7530: fix port capabilities for MT7988
  net: dsa: mt7530: remove .mac_port_config for MT7988 and make it optional
  net: dsa: mt7530: set interrupt register only for MT7530
  net: dsa: mt7530: properly reset MT7531 switch
  net: dsa: mt7530: get rid of useless error returns on phylink code path
  net: dsa: mt7530: rename p5_intf_sel and use only for MT7530 switch
  net: dsa: mt7530: run mt7530_pll_setup() only with 40 MHz XTAL
  net: dsa: mt7530: rename MT7530_MFC to MT753X_MFC
  net: dsa: mt7530: properly set MT7531_CPU_PMAP
  net: dsa: mt7530: properly set MT7530_CPU_PORT
  net: dsa: mt7530: introduce BPDU trapping for MT7530 switch
  net: dsa: mt7530: introduce LLDP frame trapping
  net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
  MAINTAINERS: add me as maintainer of MEDIATEK SWITCH DRIVER

 MAINTAINERS                   |   5 +-
 drivers/net/dsa/mt7530-mdio.c |   7 +-
 drivers/net/dsa/mt7530.c      | 470 ++++++++++++++++---------------------
 drivers/net/dsa/mt7530.h      | 107 +++++----
 include/net/dsa.h             |   8 +
 net/dsa/dsa.c                 |  24 +-
 6 files changed, 289 insertions(+), 332 deletions(-)



