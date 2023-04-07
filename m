Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AF56DAE3B
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 15:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjDGNsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 09:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjDGNsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 09:48:18 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15656C168;
        Fri,  7 Apr 2023 06:46:42 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5416698e889so797274367b3.2;
        Fri, 07 Apr 2023 06:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680875195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XSQ8CwRJARJdNn3d372Sa3h0H25OGpm6RIALsbHSCvk=;
        b=Cc+m6KB9/1gAqZjVwHmMnNhDh3qukj0A3EnNEElUvSWEvI006nzP3vUlJ2PHZHE1K8
         iaclDwR8dwBD14OnQP+WMeY0p2chsyNyhjdrCUptUvN9nrwJSiKWFsAkyQKi/jrEBkTN
         0NGEskvXAkzoqq+1583dltgOFm/gGK2PEYQdfecDdZufuDOZoFBB1FwokTAU7fvKqK8r
         jSGkC5NU5UQ+hlSsE10bA2S/9VEJrrGVuChwgxQDpSEx7VDOV6EkwqjglD0JKYvIMTcb
         w5Ys1AYk+BA9RU13xXQjaRy95379Yd3YT0rK83EvOmdPdEH1FTcnYdkx8HNJoCiiPckq
         HEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680875195;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XSQ8CwRJARJdNn3d372Sa3h0H25OGpm6RIALsbHSCvk=;
        b=XJMV/X6GhX2IQ3Om+uNuBFNOKtTC/QSItDcyIaBgzOzvio0rBxeU8iwUn/OrgUOS0C
         XRavL0/boc8qa+8WSbt6s5T+Mn2EEudjPw55o3XAVWET+urJzO+FOth0Td4CC52CWtnJ
         7mVMTdwLT63IVAMA9EgCbeVxSDs0UL7qUDCCsvdYCsDm5vJ5813RV15o0mhWQV247BhH
         JTSlAHsmqFpn0+ZZ9MGZOcsC1GXCSmF76GmDrQEpEUeIW7fbtgrK5eQA2bchJFDqhHKh
         KId3RN3iNL3KgyshT4BPGLbLJv2NsrNednb1LP8cHDgmwGAX8N1HpfWKzoPkpVT8jVrB
         majw==
X-Gm-Message-State: AAQBX9cC4MfNF3TzMkEmMNA6PDLGOnha8v/81XUXfeLbHspmYCoK18km
        eXcDAHqmUOCg6iL6WdiiNaw=
X-Google-Smtp-Source: AKy350byX8+PXrGTWDleGcK8/T9jbK3Y6VoJ04nlkswlyzNUZ5imNF5mTzMuSo6ZNoH1PaJFbt9L5A==
X-Received: by 2002:a81:6c8d:0:b0:545:6342:2610 with SMTP id h135-20020a816c8d000000b0054563422610mr1884574ywc.24.1680875195383;
        Fri, 07 Apr 2023 06:46:35 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id 139-20020a810e91000000b00545a0818473sm1034317ywo.3.2023.04.07.06.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 06:46:35 -0700 (PDT)
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
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH v2 net-next 00/12] net: dsa: mt7530: fix port 5 phylink, port 6, and MT7988
Date:   Fri,  7 Apr 2023 16:46:12 +0300
Message-Id: <20230407134626.47928-1-arinc.unal@arinc9.com>
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
setting up port 6, and refactoring the MT7530 DSA subdriver. There're also
fixes for the switch on the MT7988 SoC.

I'm asking for your comments on patch 4 and 9.

For patch 4:

If you think priv->p5_interface should not be set when port 5 is used for
PHY muxing, let me know.

For patch 9:

Do I need to protect the register from being accessed by processes while
this operation is being done? I don't see this on mt7530_setup() but it's
being done on mt7530_setup_port5().

There's an oddity here. The XTAL mask is defined on the MT7530_HWTRAP
register, but it's being read from MT7530_MHWTRAP instead which is at a
different address.

HWTRAP_XTAL_MASK and reading HWTRAP_XTAL_MASK from MT7530_MHWTRAP was both
added with:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit?id=7ef6f6f8d237fa6724108b57d9706cb5069688e4

I did this to test it:

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 46749aee3c49..7aa3b5828ac3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -404,7 +404,7 @@ static int
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, xtal, val;
+	u32 ncpo1, ssc_delta, trgint, xtal, xtal2, val;
 
 	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
@@ -413,6 +413,21 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
 	mt7530_write(priv, MT7530_MHWTRAP, val);
 
 	xtal = val & HWTRAP_XTAL_MASK;
+	xtal2 = mt7530_read(priv, MT7530_HWTRAP) & HWTRAP_XTAL_MASK;
+
+	if (xtal == HWTRAP_XTAL_20MHZ)
+		dev_info(priv->dev, "xtal 20 Mhz\n");
+	if (xtal == HWTRAP_XTAL_25MHZ)
+		dev_info(priv->dev, "xtal 25 Mhz\n");
+	if (xtal == HWTRAP_XTAL_40MHZ)
+		dev_info(priv->dev, "xtal 40 Mhz\n");
+
+	if (xtal2 == HWTRAP_XTAL_20MHZ)
+		dev_info(priv->dev, "actual xtal 20 Mhz\n");
+	if (xtal2 == HWTRAP_XTAL_25MHZ)
+		dev_info(priv->dev, "actual xtal 25 Mhz\n");
+	if (xtal2 == HWTRAP_XTAL_40MHZ)
+		dev_info(priv->dev, "actual xtal 40 Mhz\n");
 
 	if (xtal == HWTRAP_XTAL_20MHZ) {
 		dev_err(priv->dev,

Both ended up reporting 40 Mhz so I'm not sure if this is a bug or intended
to be done this way.

Please advise.

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

RFC v2: Add two patches related to MT7988 to the end.


