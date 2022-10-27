Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E3D60EFE9
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 08:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiJ0GLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 02:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiJ0GLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 02:11:51 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5588B43AD6
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 23:11:49 -0700 (PDT)
X-QQ-mid: bizesmtp87t1666851103tehj6v4r
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 27 Oct 2022 14:11:35 +0800 (CST)
X-QQ-SSF: 01400000000000H0V000000A0000000
X-QQ-FEAT: BgumqXFIWLaKapb//q0T/sbk4UqbUKIyDWkm1RvRt1YVzvvh63tbd2ZsPwipD
        Ka61e6zFLyZHDpmFdhu1PlR5ufGSUFsZ2yvWQjmjJGqV8F1BA9iZz4MgXejiu14WnjDN9JD
        HHHSKJjU1Tq5hbqdHO7+SseGD5GSihgd4jESTJnj37qafbSi7UwjaNfiQYJpsy7pzoYInGm
        x/glQ4CR2VP7foP4HfzgolP7e+wW5YSzcH16gddH0lV9e6PpFNP4IG5xSwlhMb1k2BjtadI
        0zwhHNcPU9QxKBdQK5L3Afta02drAAhZiKF4rNY3Q0yBLoSFTzBwyC2bQahmWNdZp2M5xqw
        75eBuCq5bE1QqRDdVrb53l38FqjXmGKo4GJ3yh+J9WvFUQmZ57H498d8hkucg==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v6 0/3] net: WangXun txgbe ethernet driver
Date:   Thu, 27 Oct 2022 14:11:13 +0800
Message-Id: <20221027061116.683903-1-jiawenwu@trustnetic.com>
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
v6: address comments:
    Jakub Kicinski: check with scripts/kernel-doc
v5: address comments:
    Jakub Kicinski: clean build with W=1 C=1
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
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 237 +++++++++
 drivers/net/ethernet/wangxun/txgbe/Makefile   |   3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  22 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  99 ++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 382 +++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  33 +-
 12 files changed, 1273 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_type.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h

-- 
2.27.0

