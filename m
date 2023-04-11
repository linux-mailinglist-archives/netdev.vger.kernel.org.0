Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21756DD6A5
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjDKJ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDKJ2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:28:19 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E6FC3;
        Tue, 11 Apr 2023 02:28:16 -0700 (PDT)
X-QQ-mid: bizesmtp91t1681205292txy17sc8
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 11 Apr 2023 17:28:03 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000000A0000000
X-QQ-FEAT: jXjag1m6xl5p/4UuOm9gjOZlz1oGxrg02oepOJqXg/7lpWHvsZpyeXenMTnAj
        5uDBcoFBjYtO6NOFM3D9FiukSmIwUp3bfnqSbm+TMT1vlQr3vV/+I6ejTe+muZJL7QlkeiZ
        q5Sw3kJhw6j8yv15QG/uBU9zSdEZ6JtEnsXELpIo0jRbW7HqG8mDWuIlui6Q37InHoxNbj+
        AdOGV/XKi/FQnP7KabOAeSTnpqblx38PDZEpYIrc3VrhKS3Iev7/omguP+wFmQKX+y2d0/7
        T0rssqgoWvO/YZhfLyO8SMWCG8uDhVOWEQBCWfvqHIDnux7CHK2dMPwyBL0GP21ZrgyWVwA
        Ny9BLw4Hdhc9AtlMJqp3s4rAtF7vnMUl4dCg7a4rpg6zW4WfXg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 11647374356623900767
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 0/6] TXGBE PHYLINK support
Date:   Tue, 11 Apr 2023 17:27:19 +0800
Message-Id: <20230411092725.104992-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement I2C, SFP, GPIO and PHYLINK to setup TXGBE link and switch link
rate based on optical module information.

v1 -> v2:
- add comments to indicate GPIO lines
- add I2C write operation support
- modify GPIO direction functions
- rename functions related to PHY interface
- add condition on interface changing to re-config PCS
- add to set advertise and fix to get status for 1000BASE-X mode
- other redundant codes remove

Jiawen Wu (6):
  net: txgbe: Add software nodes to support phylink
  net: txgbe: Implement I2C bus master driver
  net: txgbe: Add SFP module identify
  net: txgbe: Support GPIO to SFP socket
  net: txgbe: Implement phylink pcs
  net: txgbe: Support phylink MAC layer

 drivers/net/ethernet/wangxun/Kconfig          |   5 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   3 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |   3 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   1 +
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  34 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  58 +-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 980 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 157 +++
 9 files changed, 1219 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

-- 
2.27.0

