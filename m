Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1A65EF230
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 11:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235025AbiI2JgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 05:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiI2JgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 05:36:01 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FD82497F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 02:35:36 -0700 (PDT)
X-QQ-mid: bizesmtp88t1664444131tai8l380
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 29 Sep 2022 17:35:22 +0800 (CST)
X-QQ-SSF: 01400000000000G0U000000A0000000
X-QQ-FEAT: Wp4pj0u9TIcrbNuY5LESaTg3nCdgFECU90lB6+J1E0jy6RZi4iKss5oaAgPGo
        TyZnTvlGNmxWzmq2oE4TsUzyes93mIqZxiEFnWGSotM7pa0Pb/vBsU0xBAkmHLqLZjxjpT/
        UF5z1K6iMTwPZ9UiRS/ZudHfVfumqqEpLu6980vPlpZ4NZVscXSUT0yzkzjZ/qID/lIjlpA
        9jlc9WwWThJF6IoLabhupJ0IF8+7NIQCOXZ6YIPlgWl7KYKA5+JOuTflqg0/lOLVNnv+i/g
        Sc9tCEcXGRQR2YTbMhx9Hil4998uhxgH3cl3MOah5Bzs0rWadwVX8D+NSw9N0Q0wYinj4TN
        iDbYCsSyxofxOKNLWeIk9uvaDvZo7J4AsOSnaxVqqebSAVUVblzQTp/jMG5Lg==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 0/3] net: WangXun txgbe ethernet driver
Date:   Thu, 29 Sep 2022 17:34:21 +0800
Message-Id: <20220929093424.2104246-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for WangXun 10 gigabit NIC, to initialize
hardware, set mac address, and register netdev.

Change log:
v3: address comments:
    Andrew Lunn: remove hw function ops, reorder functions, use BIT(n)
                 for register bit offset, move the same code of txgbe
                 and ngbe to libwx
v2: address comments:
    Andrew Lunn: https://lore.kernel.org/netdev/YvRhld5rD%2FxgITEg@lunn.ch/

Jiawen Wu (3):
  net: txgbe: Store PCI info
  net: txgbe: Reset hardware
  net: txgbe: Set MAC address and register netdev

 drivers/net/ethernet/wangxun/Kconfig          |   6 +
 drivers/net/ethernet/wangxun/Makefile         |   1 +
 drivers/net/ethernet/wangxun/libwx/Makefile   |   7 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 475 ++++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  18 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 237 +++++++++
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  23 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 153 ++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  10 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 449 ++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  40 +-
 12 files changed, 1403 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_type.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h

-- 
2.27.0

