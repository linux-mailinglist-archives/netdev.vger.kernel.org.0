Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7558F606D45
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 03:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiJUB5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 21:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiJUB47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 21:56:59 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A06A224A85
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 18:56:55 -0700 (PDT)
X-QQ-mid: bizesmtp66t1666317410tcp9xs1j
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 21 Oct 2022 09:56:32 +0800 (CST)
X-QQ-SSF: 01400000000000H0V000000A0000000
X-QQ-FEAT: uGhnJwy6xZJWDmG6GUHM34FL+A8CgOTQaHJNSBF3DD4BWgL45gUHkm3H3vCo7
        kwDIEhlAd2Fyg2J1hlAYul+9EdM4nA2rL+C0mQGD7+w0lNdFek2CpMJs2nljYw4IRAgBFVP
        fbuVow4cc4RXmW+bO7CmlozweTJvj+omU09VzmFmJRXZxe9k/nfGIBsS7b+tTy/qh51xglJ
        vcXyK5qryebiLaBs4kklEDU24UkFf8QXna3cmdW1TEw8TL3zG5Sra4gZp6Mj7H6MxzTnLW7
        t8o7LN/8pFem4YjSXMOxgrD5AsduqufnMzHnbGlchJ9zWYUW9qyUMc4g4LlvU4Kk9WFvOj5
        q02NLF4rCBzETG1FSc88V6vJjqD2BBbiNvwWkRlTQz85QAxK7Y=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RESEND PATCH net-next v4 0/3] net: WangXun txgbe ethernet driver
Date:   Fri, 21 Oct 2022 10:07:17 +0800
Message-Id: <20221021020720.519223-1-jiawenwu@trustnetic.com>
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
v4: address comments:
    Andrew Lunn: https://lore.kernel.org/all/YzXROBtztWopeeaA@lunn.ch/
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
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 239 +++++++++
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  22 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  99 ++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 382 +++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  33 +-
 12 files changed, 1275 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_type.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h

-- 
2.27.0

