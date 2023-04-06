Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8286D97A1
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbjDFNJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDFNJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:09:24 -0400
Received: from mail.pr-group.ru (mail.pr-group.ru [178.18.215.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF85135;
        Thu,  6 Apr 2023 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=metrotek.ru; s=mail;
        h=from:subject:date:message-id:to:cc:mime-version:content-transfer-encoding;
        bh=G79lbWH8CPCUsL1PA3+WCtub2L63ls1iJ37POigO2Gw=;
        b=gO+GHHTgwJKiF7YkHbUDSAzulMZFckTiv3nlGwdwQ6uGX1R0mj+Ia4gxRcrhKd+jq16Q1zj6kHmMZ
         OXMQxLD/CDWrq/WmP75LitGeui0RRMAO+SCLbvAc7VhnQLT5cVkVmW5YIfn/1Os5gGSEaWYWH4XJ6J
         sOECUTnwDbUTyixFoISe4G2yvv4vgCz2NbmnpXZKkMN0my0MCuM0Txk9OSRV7BRAds84CSb4dk1q6l
         C2zB8zAHU3Zc9/zQXIygFSuwZ1poQLH6zyqEa87K5t/7D5zTH7xSnn9k0pJwWGZmMRiq8Ghx+uWdKE
         CIzsXwEvS2f1PqRX7UXdZ7lkptIroBQ==
X-Kerio-Anti-Spam:  Build: [Engines: 2.17.2.1477, Stamp: 3], Multi: [Enabled, t: (0.000009,0.005049)], BW: [Enabled, t: (0.000029,0.000001)], RTDA: [Enabled, t: (0.135792), Hit: No, Details: v2.49.0; Id: 15.g4r6p.1gtbauivb.1mh; mclb], total: 0(700)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Level: 
X-Footer: bWV0cm90ZWsucnU=
Received: from localhost.localdomain ([78.37.166.219])
        (authenticated user i.bornyakov@metrotek.ru)
        by mail.pr-group.ru with ESMTPSA
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256 bits));
        Thu, 6 Apr 2023 16:08:57 +0300
From:   Ivan Bornyakov <i.bornyakov@metrotek.ru>
To:     netdev@vger.kernel.org
Cc:     Ivan Bornyakov <i.bornyakov@metrotek.ru>, linux@armlinux.org.uk,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, system@metrotek.ru
Subject: [PATCH net v2 0/2] fix EEPROM read of absent SFP module
Date:   Thu,  6 Apr 2023 16:08:31 +0300
Message-Id: <20230406130833.32160-1-i.bornyakov@metrotek.ru>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patchset is to improve EEPROM read requests when SFP module is
absent.

ChangeLog:
v1:
https://lore.kernel.org/netdev/20230405153900.747-1-i.bornyakov@metrotek.ru/
v2:
  * reword commit message of "net: sfp: initialize sfp->i2c_block_size
    at sfp allocation"
  * add second patch to eliminate excessive I2C transfers in
    sfp_module_eeprom() and sfp_module_eeprom_by_page()

Ivan Bornyakov (2):
  net: sfp: initialize sfp->i2c_block_size at sfp allocation
  net: sfp: avoid EEPROM read of absent SFP module

 drivers/net/phy/sfp.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

-- 
2.39.2


