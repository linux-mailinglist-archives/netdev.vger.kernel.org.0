Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944996D88B9
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjDEUjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDEUjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:39:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56A81B3;
        Wed,  5 Apr 2023 13:39:05 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id hg25-20020a05600c539900b003f05a99a841so4776223wmb.3;
        Wed, 05 Apr 2023 13:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680727144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ih5QT8Ee7yYAcHkFKgIrf6VHRThaccKYn0ouyxLK294=;
        b=XWN2t1JqM/F5A/mul8DGE7DcZYG4DiP3Q3YyXwSb0Bc7lunuTE8WZKeNaoGpfrmPID
         goseeJrXh9/ERf6v796J0RjASFbZvZ3nM2SBnJWHp0Czm37pWmluWK/xyeixO8XZwpLg
         eXIUIG+5UNEnMsXiimVXRjPeeUk2OqWzt0hW6X7ODlnG0fHkzRwMaPXBBUctY4clZUp6
         5ImCH1bciRg8/vvpu92DsnXVekn27CO0vttLARxfD76hwq8RjBuVyYkvpxKXxtP8e5B0
         l/xbjm+QXlenZTmyev5Whv64JWjD+UeuVpArdvDI+e1tKapQxCIXGkByJb//OoazREwz
         Tn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ih5QT8Ee7yYAcHkFKgIrf6VHRThaccKYn0ouyxLK294=;
        b=ZofVQ672tiRflR3GT1BEOOSkMK83nCxgU6hA24K2u4a9k6gyTSWvsF0w66cswEDaS+
         cgf4eEj9SBRu+iYh9nEjRlHpdfv6/gcV32wAhJscRwHb0oMI0c5ePFo/k01ndZNXJZVt
         64OMEgTho9XoXRGyS/koyMzVNK4bzjV6RMHFsvRlTMZeWcFKe6ZCA+kNfXBZnN4QOeYV
         tIf+7dBAxgCgX62B/1VHIqtGX57c04sjHLQyplcjjgrfZAJhj5bbPJ8fBxZD04d0YsLf
         DwC6jaFofQ5FfKvV6161lla+d5p8BplR3p5KHop3BXcct0ew8iWUxVO8JGXi2uP7pd72
         9iNQ==
X-Gm-Message-State: AAQBX9cDLVHkDBXnQ4Tjq7b3aQRNV09EW564PfUSEJYSY6PVXQGkjAsP
        A7pKuTLcgw2CzvbwCOuDTZ0=
X-Google-Smtp-Source: AKy350aQpmAuEz4xnXn3BfBxrWaBDey1yEmmuFzVTtpMQ6JQIzXhv+z4Oz1KKsR5jK4vTi7hrPBp1Q==
X-Received: by 2002:a7b:ce16:0:b0:3ed:4b0f:5378 with SMTP id m22-20020a7bce16000000b003ed4b0f5378mr5711811wmc.27.1680727143977;
        Wed, 05 Apr 2023 13:39:03 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c469300b003eda46d6792sm3259867wmo.32.2023.04.05.13.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:39:03 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>,
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
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 0/12] net: dsa: mt7530: fix port 5 phylink, phy muxing, and port 6
Date:   Wed,  5 Apr 2023 23:38:47 +0300
Message-Id: <20230405203859.391267-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

This patch series is mainly focused on improving the support for port 5,
setting up port 6, and refactoring the MT7530 DSA subdriver.

The only missing piece to properly support port 5 as a CPU port is the
fixes [0] [1] [2] from Richard.

I have very thoroughly tested the patch series with every possible mode to
use. I'll let the name of the dtb files speak for themselves.

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

Current CPU ports setup of MT7530:

mt7530_setup()
-> mt7530_setup_port5()

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()
-> mt753x_pad_setup()
   -> mt7530_pad_clk_setup() sets up port 6, rename to mt7530_setup_port6()

How it will be with the patch series:

mt7530_setup()
-> mt7530_setup_port5() runs if the port is not used as a CPU, DSA, or user port

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7530_mac_config()
      -> mt7530_setup_port5()
      -> mt7530_setup_port6()

CPU ports setup of MT7531 for reference:

mt7531_setup()
-> mt753x_cpu_port_enable()
   -> mt7531_cpu_port_config()
      -> mt7531_mac_config()
         -> mt7531_rgmii_setup()
         -> mt7531_sgmii_setup_mode_an()
         -> etc.

mt753x_phylink_mac_config()
-> mt753x_mac_config()
   -> mt7531_mac_config()
      -> mt7531_rgmii_setup()
      -> mt7531_sgmii_setup_mode_an()
      -> etc.

[0] https://lore.kernel.org/netdev/20230212213949.672443-1-richard@routerhints.com/
[1] https://lore.kernel.org/netdev/20230212215152.673221-1-richard@routerhints.com/
[2] https://lore.kernel.org/netdev/20230212214027.672501-1-richard@routerhints.com/

Arınç


