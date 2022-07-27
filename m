Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C4E58203D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiG0Gno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiG0Gnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:43:43 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5412D371B4
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:40 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t17so13496136lfk.0
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q0JdbbZEALmFTCXsfz74/9NIeFXKFHwfHwSewzxmkTY=;
        b=et464ncc41hVOY+Ln75ox4QXAf3bDhymWPXbtstVszSs6Gt3al0ovWXBjq0jDSLbwE
         kwgkaX3zH8PfMvs0Pi0XQlRmxJqV4BqJni9KaxJTKEwxLArGWLYKJu0xiwRmjBkmVbQr
         BjiQfLbjAdCK2r4/nj8umMCuvn8gfEs+/PVbPXL2mFlWdeh9aaf1CxOP/ZI8U2xIvAjh
         T9lJV2u9HosVf3Zmfgp8sLQkrpp2vDSbtNb7cYX4EfB6qGG/suZ2yu0nutMm2wNQ93RO
         ZwQjKX2+suuf12kajWbxg5XVnrJlFwy5SqXhEbOLMt9opL40afwIKrbQQD4fe2JRov1W
         mh/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q0JdbbZEALmFTCXsfz74/9NIeFXKFHwfHwSewzxmkTY=;
        b=s0m2E5pgMMNmSLImZoEpo3TyQtEB1Ai0X/OsPud0mZbbbCZOqXsmZiKOqwRBvhpPsR
         rjGIC1XwTzaWtNxJ82/3kjm1PULwyN8fquE4g1ud1oRlQ7lcg7ZDkPIyXFcFTekTpF/l
         1SB5IDSKZu7EEmsMt4azKORJxqY0SQedMLSFcx3moNYyKmOAUOwXkFw7wkZurPBDiGzM
         Mv7/jrAvPUkVOyi34A91lyGd8/E4oIrUjGpFN4kU9Y1PWui8A7zftHXvFtBOSdtEs2bY
         7ky7D6ZYUxrWYVVdwxAYVw0H5fER7Rg64SjoLck6dKIVZmE/vZNWOWAfh1MXFpnzrJ8Z
         FM1g==
X-Gm-Message-State: AJIora+z3fANXLvunVEa7AeMInEnB9oN9Mr5ZfxsJp66YN2ohBIMzrHp
        sCp+6/DJ12EZrrcpshXqtIJHMw==
X-Google-Smtp-Source: AGRyM1v1WIbUMI1g1LqOtJYJ+bBl8s/81qsQT2ZXWASD3ZzKWTRX1TQIwsrORCPUFww1yUZ0b8UKjw==
X-Received: by 2002:a05:6512:2314:b0:48a:2c31:d9cd with SMTP id o20-20020a056512231400b0048a2c31d9cdmr7766736lfu.491.1658904218229;
        Tue, 26 Jul 2022 23:43:38 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id w19-20020a05651234d300b0048a97a1df02sm1157231lfr.6.2022.07.26.23.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 23:43:37 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH v3 0/8] DSA: switch to fwnode_/device_
Date:   Wed, 27 Jul 2022 08:43:13 +0200
Message-Id: <20220727064321.2953971-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a re-spin of the DSA migration to fwnode_/device_ API.
It addresses all comments from the previous iteration - the
details are summarized in the changelog section below.

This time the patchset is based and tested on top of
pure net-next/main branch. Each commit was checked on:
* On EspressoBIN
* On SolidRun CN913x CEx7 Eval Board 

Any comments or remarks will be appreciated.

Best regards,
Marcin

Changelog v2 -> v3:
1/8:
  * Replace forward declaration s/device_node/fwnode_handle/ in
    include/linux/phy_fixed.h
  * Add Florian's RB

* 3/8:
  * Extend lines width in the commit message.
  * While dropping dp->dn fields in the drivers, switch to
    fwnode_ API in the updated places.

* 5/8:
  * Update routine name to fwnode_find_parent_dev_match()
  * Improve comment section
  * Move the definition adjacent to a group of fwnode
    APIs operating on parents

Changelog v1 -> v2:
1/8
  * Drop unnecessary check in fixed_phy_get_gpiod()
  * Improve line breaking
  * Use device_set_node & dev_fwnode

2/8
  * Switch to fwnode_property_count_u32 and fix comparison
    in if statement.

3/8
  * Drop dn usage entirely and use dp->fwnode only. Update
    all dependent drivers to use to_of_node.
  * Use device_set_node, dev_fwnode & device_get_named_child_node
  * Replace '_of' routines suffix with '_fw'

4/8
  * Use device_set_node

5/8
  * New patch

6/8 
  * Use device_match_fwnode
  * Restore EXPORT_SYMBOL()

7/8
  * Get rid of of_mdiobus_register_device 

8/8
  * Use dev_fwnode in mv88e6xxx_probe 
  * Simplify condition checks in mv88e6xxx_probe as suggested by Andy

Marcin Wojtas (8):
  net: phy: fixed_phy: switch to fwnode_ API
  net: mdio: switch fixed-link PHYs API to fwnode_
  net: dsa: switch to device_/fwnode_ APIs
  net: mvpp2: initialize port fwnode pointer
  device property: introduce fwnode_find_parent_dev_match
  net: core: switch to fwnode_find_net_device_by_node()
  net: mdio: introduce fwnode_mdiobus_register_device()
  net: dsa: mv88e6xxx: switch to device_/fwnode_ APIs

 include/linux/etherdevice.h                     |   1 +
 include/linux/fwnode_mdio.h                     |  22 ++++
 include/linux/of_net.h                          |   6 -
 include/linux/phy_fixed.h                       |   6 +-
 include/linux/property.h                        |   1 +
 include/net/dsa.h                               |   2 +-
 net/dsa/dsa_priv.h                              |   4 +-
 drivers/base/property.c                         |  23 ++++
 drivers/net/dsa/mt7530.c                        |   6 +-
 drivers/net/dsa/mv88e6xxx/chip.c                |  57 ++++-----
 drivers/net/dsa/qca/qca8k.c                     |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c             |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
 drivers/net/mdio/fwnode_mdio.c                  | 129 ++++++++++++++++++++
 drivers/net/mdio/of_mdio.c                      | 111 +----------------
 drivers/net/phy/fixed_phy.c                     |  39 +++---
 net/core/net-sysfs.c                            |  25 ++--
 net/dsa/dsa2.c                                  | 101 ++++++++-------
 net/dsa/port.c                                  |  68 +++++------
 net/dsa/slave.c                                 |   7 +-
 20 files changed, 329 insertions(+), 285 deletions(-)

-- 
2.29.0

