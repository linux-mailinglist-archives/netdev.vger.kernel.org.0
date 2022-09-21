Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660435BFF57
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiIUN6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIUN63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:58:29 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260197FE52
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:58:27 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MXfzT1hN1zmWL9;
        Wed, 21 Sep 2022 21:54:29 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 21:58:25 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 21 Sep
 2022 21:58:24 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <f.fainelli@gmail.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <olteanv@gmail.com>,
        <kurt@linutronix.de>, <hauke@hauke-m.de>,
        <Woojung.Huh@microchip.com>, <sean.wang@mediatek.com>,
        <linus.walleij@linaro.org>, <clement.leger@bootlin.com>,
        <george.mccollister@gmail.com>
Subject: [PATCH net-next 00/18] net: dsa: remove unnecessary set_drvdata()
Date:   Wed, 21 Sep 2022 22:05:06 +0800
Message-ID: <20220921140524.3831101-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this patch set, I removed all set_drvdata(NULL) functions in ->remove() in
drivers/net/dsa/.

The driver_data will be set to NULL in device_unbind_cleanup() after calling ->remove(),
so all set_drvdata(NULL) functions in ->remove() is redundant, they can be removed.

Here is the previous patch set:
https://lore.kernel.org/netdev/facfc855-d082-cc1c-a0bc-027f562a2f45@huawei.com/T/

Yang Yingliang (18):
  net: dsa: b53: remove unnecessary set_drvdata()
  net: dsa: bcm_sf2: remove unnecessary platform_set_drvdata()
  net: dsa: loop: remove unnecessary dev_set_drvdata()
  net: dsa: hellcreek: remove unnecessary platform_set_drvdata()
  net: dsa: lan9303: remove unnecessary dev_set_drvdata()
  net: dsa: lantiq_gswip: remove unnecessary platform_set_drvdata()
  net: dsa: microchip: remove unnecessary set_drvdata()
  net: dsa: mt7530: remove unnecessary dev_set_drvdata()
  net: dsa: mv88e6060: remove unnecessary dev_set_drvdata()
  net: dsa: mv88e6xxx: remove unnecessary dev_set_drvdata()
  net: dsa: ocelot: remove unnecessary set_drvdata()
  net: dsa: ar9331: remove unnecessary dev_set_drvdata()
  net: dsa: qca8k: remove unnecessary dev_set_drvdata()
  net: dsa: realtek: remove unnecessary set_drvdata()
  net: dsa: rzn1-a5psw: remove unnecessary platform_set_drvdata()
  net: dsa: sja1105: remove unnecessary spi_set_drvdata()
  net: dsa: vitesse-vsc73xx: remove unnecessary set_drvdata()
  net: dsa: xrs700x: remove unnecessary dev_set_drvdata()

 drivers/net/dsa/b53/b53_mdio.c             | 2 --
 drivers/net/dsa/b53/b53_mmap.c             | 2 --
 drivers/net/dsa/b53/b53_srab.c             | 2 --
 drivers/net/dsa/bcm_sf2.c                  | 2 --
 drivers/net/dsa/dsa_loop.c                 | 2 --
 drivers/net/dsa/hirschmann/hellcreek.c     | 1 -
 drivers/net/dsa/lan9303_mdio.c             | 2 --
 drivers/net/dsa/lantiq_gswip.c             | 2 --
 drivers/net/dsa/microchip/ksz8863_smi.c    | 2 --
 drivers/net/dsa/microchip/ksz_spi.c        | 2 --
 drivers/net/dsa/mt7530.c                   | 2 --
 drivers/net/dsa/mv88e6060.c                | 2 --
 drivers/net/dsa/mv88e6xxx/chip.c           | 2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 2 --
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 2 --
 drivers/net/dsa/qca/ar9331.c               | 2 --
 drivers/net/dsa/qca/qca8k-8xxx.c           | 2 --
 drivers/net/dsa/realtek/realtek-mdio.c     | 2 --
 drivers/net/dsa/realtek/realtek-smi.c      | 2 --
 drivers/net/dsa/rzn1_a5psw.c               | 2 --
 drivers/net/dsa/sja1105/sja1105_main.c     | 2 --
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 2 --
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 2 --
 drivers/net/dsa/xrs700x/xrs700x_mdio.c     | 2 --
 24 files changed, 47 deletions(-)

-- 
2.25.1

