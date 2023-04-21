Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618836EAD10
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbjDUOhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbjDUOhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:07 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66C7C654;
        Fri, 21 Apr 2023 07:36:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-956ff2399b1so215365866b.3;
        Fri, 21 Apr 2023 07:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087815; x=1684679815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D5CVRuG0AkI1whb77i+Oe8Xqsts657oAGXoFJ4Cxpuo=;
        b=qJhQ6rEyPc2fkWSA3OfsymjYtkl2SVP1W11ajjrzyqR0HT5CfgnDdtedf9wBvDYSN7
         pPJun0w5fy/zr6H+jAtw1z3OnCr22AqoPmwISuqBtLQ1jAuEq1UVR/CuaD9xyIxWP6ZL
         EWGbU6f62rq0GguVuxkfilu2u5Rb5X4barj7cnbz9KbwZWF8mA+rbyRyhV7DWRVIw6TS
         Y7+vnVq8Cox5LROMMOKdNrFWFL1NLG8SeHESR5cnSxN/VBjMyPoO6VYu4ZCICvKMHUsg
         Gm9h8byaskPIkyW28lJWOXSBEoQyVdDw0Id6j0jesh4QlPpigY8EIB1Lb1iyyHNZ2LXM
         cpdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087815; x=1684679815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D5CVRuG0AkI1whb77i+Oe8Xqsts657oAGXoFJ4Cxpuo=;
        b=WSMD8W8/jYVOyFCgSYo0Ail0TMill6JXfkEDFuOlYeIKzvSXUSPOzTNABNZ5q5N9nR
         RPWYvcD0STFNqQ/SRE018L/H5aPKlnhDC0wPeJ0HVLo1FuaPCly5xgSPt9NMusLr57gZ
         itoX6R//xMYSN8CTWHtxSS9SMstQvT06GhRDPl6hDP5jDpnUslv4CWQvMxFAj+28jhuB
         w1+52C1VQPRUSALJeOQam2Dcgl9PSw1wSee7cgLP9BWk/TG/e+tW2EjiuMZHqet7C/an
         7NzR3OYO6It6LIbBL7lZwZ8sithcxtgRcjB5zo4a9RveiJ82bycdfQ4JuP6dLzRRpYTt
         7eHA==
X-Gm-Message-State: AAQBX9eMM2AhzRFecJnw9d03JXViPHpALFf+t1VfnDBgUROx9tykj1+0
        Aw0c0B7TdYYlkABOep7aMMU=
X-Google-Smtp-Source: AKy350bG/pBS/ZMJcgrEd1gKDYlBFcy5jEFdaeZYNySZLVF3YaKe7Jv6ROXswYKibACjieK4vRraBw==
X-Received: by 2002:a17:906:32c9:b0:94f:7d98:a32d with SMTP id k9-20020a17090632c900b0094f7d98a32dmr2657525ejk.10.1682087814841;
        Fri, 21 Apr 2023 07:36:54 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:36:54 -0700 (PDT)
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
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 00/22] net: dsa: MT7530, MT7531, and MT7988 improvements
Date:   Fri, 21 Apr 2023 17:36:26 +0300
Message-Id: <20230421143648.87889-1-arinc.unal@arinc9.com>
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

There's also a fix for the switch on the MT7988 SoC.

Daniel, can you test this series on the MT7531 and MT7988 SoC switch?

The only missing piece to properly support multiple ports as CPU ports is
the fixes [0] [1] [2] from Richard.

I've got questions regarding patch 13 and 19.

For patch 19:

Daniel, does the switch on the MT7988 SoC require the register to fire
interrupts properly? The code uses an inclusive check which was untouched
when the MT7988 SoC switch support was added.

For patch 13:

Do I need to protect the register from being accessed by processes while
this operation is being done? I don't see this on mt7530_setup() but it's
being done on mt7530_setup_port5().

I have very thoroughly tested the patch series with every possible
configuration on the MCM and standalone MT7530 switch. I'll let the name of
the dtb files speak for themselves.

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

[0] https://lore.kernel.org/netdev/20230212213949.672443-1-richard@routerhints.com/
[1] https://lore.kernel.org/netdev/20230212215152.673221-1-richard@routerhints.com/
[2] https://lore.kernel.org/netdev/20230212214027.672501-1-richard@routerhints.com/

Arınç


