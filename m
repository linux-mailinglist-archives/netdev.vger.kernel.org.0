Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1C6575E1B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 11:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiGOIuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbiGOIus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:50:48 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D627B823AA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:41 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id a9so6749146lfk.11
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0L6cELyn7jvpoaX0deTVVc+dWskWPIjbhl9EKXQMb1o=;
        b=Kt8R6I1PuFUBffIBgqNZBnpQOYHhVItlnRTdxNrnr5lRw3hbimOCwO44clT2b2K000
         kGLvEiYvFMDviW86zkrJrS1dUooT5Zqrq7QBFIo2QDSVf1a5Qgk3dOZFOfib8C75Qv2y
         iY42VXFxFqUZnULVf0GOlGIP7fho1/If41i+w81UOjqfLL8FeW1kQw4Xogm69g8WVV6n
         PZws8mg+tB3FgXthGdzkGPlUicJk1qVbIt+WA3axKUCeQ94F4YPY/jnnVAEOphUbdwJl
         4VRD4QRacv730iubjTfAztBa4pG4rdCOGoY7HPLNLHZVMk9pHj6SC62GTm+gvn2DAvAs
         rfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0L6cELyn7jvpoaX0deTVVc+dWskWPIjbhl9EKXQMb1o=;
        b=jHrBnNpgS2vpd7jZHoNnSeK6GoEnMlfpAbX3N9YReiJMgh7ixQFcGiF0F4fCR5Khsu
         1nI1ZZNQ1QcD7Hs8DPzjEztZt6FEaudxVYcpi7fOfvvvS8t2e8BqlqgvDzC8oZawx0Wd
         fi+zMXP6UtwYI+ouzaELYvZ1t2DT9fpYrYq//Pjrnc+KbmPjh8x6Dw9LfmBLRdNUyMEI
         ZftfhqmkB0qR2cTA8kZUKGOMU1DXbuvzStwe8+V27yuyifNKqsi+yFs9a/47TVMU9zn/
         A5XSrwQLvicbLFJg06nQbpj4gkiRDklfLcVVwiX80MbOmKt3qbynTDFvWQK+bWlCcGZh
         ROcQ==
X-Gm-Message-State: AJIora+P0JHzocX54kSdnCLGtIP1u02DNq7S41u3N3aZAN/raK5V8w6I
        VQJmCOxG77IACet5RwyT4slxfg==
X-Google-Smtp-Source: AGRyM1vqKZl8Z6F8ovOnVdk5GvmZ1W9G+FpqJ213NmovMavpUEN59ihFQZtqiTv7PuPjA0WpGZcM9w==
X-Received: by 2002:a05:6512:130f:b0:47f:bf0b:234 with SMTP id x15-20020a056512130f00b0047fbf0b0234mr7753030lfu.351.1657875040038;
        Fri, 15 Jul 2022 01:50:40 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e4-20020a2e9e04000000b0025d773448basm667846ljk.23.2022.07.15.01.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 01:50:39 -0700 (PDT)
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
Subject: [net-next: PATCH v2 0/8] DSA: switch to fwnode_/device_
Date:   Fri, 15 Jul 2022 10:50:04 +0200
Message-Id: <20220715085012.2630214-1-mw@semihalf.com>
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
As agreed, the ACPI-specific patches were kept aside for now,
until the MDIOSerialBus is submitted and accepted in the ACPI
Specification.

The patchset addresses all comments from the first version,
mostly related to usage of proper device_ helpers. Also,
as it was suggested, fwnode_dev_node_match() routine
was taken out of the network code and introduced as a generic
one in drivers/base/property.c

The details can be found in the changelog below. Any comments or
remarks will be appreciated.

Each patch was tested on:
* On EspressoBIN
* On SolidRun CN913x CEx7 Eval Board

IMPORTANT NOTE:
This patchset is rebased on top of the one from Russell
(https://lore.kernel.org/all/Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk/),
so a care should be taken, when merging to the net-next tree.

Best regards,
Marcin

Changelog v1->v2:
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
  device property: introduce fwnode_dev_node_match
  net: core: switch to fwnode_find_net_device_by_node()
  net: mdio: introduce fwnode_mdiobus_register_device()
  net: dsa: mv88e6xxx: switch to device_/fwnode_ APIs

 include/linux/etherdevice.h                     |   1 +
 include/linux/fwnode_mdio.h                     |  22 ++++
 include/linux/of_net.h                          |   6 -
 include/linux/phy_fixed.h                       |   4 +-
 include/linux/property.h                        |   2 +
 include/net/dsa.h                               |   2 +-
 net/dsa/dsa_priv.h                              |   4 +-
 drivers/base/property.c                         |  22 ++++
 drivers/net/dsa/mt7530.c                        |   2 +-
 drivers/net/dsa/mv88e6xxx/chip.c                |  57 ++++-----
 drivers/net/dsa/qca8k.c                         |   2 +-
 drivers/net/dsa/realtek/rtl8365mb.c             |   2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
 drivers/net/mdio/fwnode_mdio.c                  | 129 ++++++++++++++++++++
 drivers/net/mdio/of_mdio.c                      | 111 +----------------
 drivers/net/phy/fixed_phy.c                     |  39 +++---
 net/core/net-sysfs.c                            |  25 ++--
 net/dsa/dsa2.c                                  | 101 ++++++++-------
 net/dsa/port.c                                  |  70 ++++++-----
 net/dsa/slave.c                                 |   7 +-
 20 files changed, 328 insertions(+), 282 deletions(-)

-- 
2.29.0

