Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31E26EDDFF
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbjDYI37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbjDYI3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:29:55 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8B549FA;
        Tue, 25 Apr 2023 01:29:54 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f32588c13so784765966b.2;
        Tue, 25 Apr 2023 01:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682411392; x=1685003392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NqprM4j549SEj5PGLmZ1hb+z7DxjMV0RONCnIDIKuDU=;
        b=pEkw7S14spvkt5NISAw0C4+oNzPySVYl/MvbEPKRwfGL7imGuTnZO2B21h4xyQJaRG
         ooGEXHxCDQT/1Q/nM5Z/zLpm+DNWSx1CN82hydEqLaX2NxR+xuboylmDUEJV84X+2ctF
         Xz8EvODtFQ/iSDOyR8RYAI3WOwIdKlHJs4SmMMLrvzqRIsnRwlV+0d0iDwk/ujwgUKRD
         IMWRq4XDQ3kWXrlPjcPtk4L8pIAqPiG/B160N9oWTgH4gj8wgX3oh6vhOy4IhjBz0faA
         UCOQewOydBCZyzhJaYyOkIP7UPOf+tPZzylDkkyj2Exj9bb/pT03SppSeJNoOVt55QKX
         IEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682411392; x=1685003392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NqprM4j549SEj5PGLmZ1hb+z7DxjMV0RONCnIDIKuDU=;
        b=ZuxroPBCnUe8udDFbazMTyc65hzGc2vV0n5iZvhPcJdJBnjK9vWMgedJtgaPF2dCrn
         4iw8I1TkKh75O7LlWC5pYZG5WPDFP7XsIMNJ4C4Cutpnb0fRA3Sxp18gJILGVyS0ZGZ6
         Hfbk/k/AadEtanertbxU29Q/ySs4X7lCV+JcgAj6Bki0EhdSzlW3ougOY4KdKNKDawGj
         L45PKA6AYepdEdjiCIPO2PXNm+fKmy4xlEp0vgsdJqc6L7iNOFnTWk3OlJFfvEbf/fX2
         YSis+OKlg4Q0uZe0MmwyV1Ak7+MZxhG/RZ0OkJaKy4m+r7lF5VhOUCmlTd5Uitx5KyP4
         xVcQ==
X-Gm-Message-State: AAQBX9dic1VdHyKsW1ufGUnjV/+SRE3pvGRCr2pSyj2gGXRiDVik7a2s
        or1RXiARP6l47BVkU859cFA=
X-Google-Smtp-Source: AKy350bmAiS/zfdqkRBA3U7z2tq+V3Tcvi18IZiqM8unXqQQDybRedf1t8QhcIPwUjxRt222iBPK/w==
X-Received: by 2002:a17:907:8a18:b0:94a:5c6d:3207 with SMTP id sc24-20020a1709078a1800b0094a5c6d3207mr16112893ejc.44.1682411392225;
        Tue, 25 Apr 2023 01:29:52 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id mc2-20020a170906eb4200b0094ca077c985sm6439028ejb.213.2023.04.25.01.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:29:51 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Bartel Eerdekens <bartel.eerdekens@constell8.be>,
        erkin.bozoglu@xeront.com,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 00/24] net: dsa: MT7530, MT7531, and MT7988 improvements
Date:   Tue, 25 Apr 2023 11:29:09 +0300
Message-Id: <20230425082933.84654-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

This patch series is focused on simplifying the code, and improving the
logic of the support for MT7530, MT7531, and MT7988 SoC switches.

There're two fixes. One for fixing the corrupt frames using trgmii on MCM
MT7530 with 40 MHz oscillator on certain MT7621 SoCs. The other for fixing
the port capabilities of the switch on the MT7988 SoC.

Currently, using multiple ports as CPU ports won't work properly. I am
working on fixing it.

I am leaving this information for the record, as I have not received any
comments on my RFC series regarding this. The register may need to be
protected from being accessed by processes while the operation that
modifies the MT7530_MHWTRAP register on mt7530_setup_port6() is being done.
I don't see this being done on mt7530_setup() but it's there on
mt7530_setup_port5(). My tests haven't shown any apparent issues but if you
experience any issues with port 6, this is where to look first.

I have done iperf3 and ping tests on all ports of the MT7530 switch with
this patch series applied. I tested every possible configuration on the MCM
and standalone MT7530 switch. I'll let the name of the dtb files speak for
themselves.

MT7621 Unielec:

only-gmac0-mt7621-unielec-u7621-06-16m.dtb
rgmii-only-gmac0-mt7621-unielec-u7621-06-16m.dtb
only-gmac1-mt7621-unielec-u7621-06-16m.dtb
gmac0-and-gmac1-mt7621-unielec-u7621-06-16m.dtb
phy0-muxing-mt7621-unielec-u7621-06-16m.dtb
phy4-muxing-mt7621-unielec-u7621-06-16m.dtb
port5-as-user-mt7621-unielec-u7621-06-16m.dtb

tftpboot 0x80008000 mips-uzImage.bin; tftpboot 0x83000000 mips-rootfs.cpio.uboot; tftpboot 0x83f00000 $dtb; bootm 0x80008000 0x83000000 0x83f00000

MT7623 Bananapi:

only-gmac0-mt7623n-bananapi-bpi-r2.dtb
rgmii-only-gmac0-mt7623n-bananapi-bpi-r2.dtb
only-gmac1-mt7623n-bananapi-bpi-r2.dtb
gmac0-and-gmac1-mt7623n-bananapi-bpi-r2.dtb
phy0-muxing-mt7623n-bananapi-bpi-r2.dtb
phy4-muxing-mt7623n-bananapi-bpi-r2.dtb
port5-as-user-mt7623n-bananapi-bpi-r2.dtb

tftpboot 0x80008000 arm-uImage; tftpboot 0x83000000 arm-rootfs.cpio.uboot; tftpboot 0x83f00000 $dtb; bootm 0x80008000 0x83000000 0x83f00000

Arınç

Arınç ÜNAL (24):
  net: dsa: mt7530: fix corrupt frames using trgmii on 40 MHz XTAL MT7621
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
  net: dsa: mt7530: force link-down on MACs before reset on MT7530
  net: dsa: mt7530: get rid of useless error returns on phylink code path
  net: dsa: mt7530: rename p5_intf_sel and use only for MT7530 switch
  net: dsa: mt7530: run mt7530_pll_setup() only with 40 MHz XTAL

 drivers/net/dsa/mt7530-mdio.c |   7 +-
 drivers/net/dsa/mt7530.c      | 372 +++++++++++++------------------------
 drivers/net/dsa/mt7530.h      |  35 ++--
 3 files changed, 145 insertions(+), 269 deletions(-)


