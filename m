Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D365360C16D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 03:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiJYBwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 21:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbiJYBwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 21:52:05 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5F7D7
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 18:52:01 -0700 (PDT)
X-QQ-mid: bizesmtp86t1666662716td332blq
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 25 Oct 2022 09:51:45 +0800 (CST)
X-QQ-SSF: 01400000000000H0V000000A0000000
X-QQ-FEAT: +974YfKaBdB4pT5IKv4CV3UEZGEvSdaL/pe+Uou23pOOzCOc5hU+Z19toJE3B
        MbC2b487+WSyuOxQR/MRzStvC1rbRXwTjroHGAjlCPVJc9Mgn9QFEWXm8PO7/ZkTg7Cs5/J
        6vBPAoRtECcheyc2hhHSowfRqSOKYxk7rc1KcH8ZAJHWukaUTjJks6Id38q0CAc+TcWjjTl
        KaLqgQAbofWWsJX/TAKVZnqYb14H1LdvKaznfvoeWUY99T42tj05yXydFQOm0diwenaItsQ
        F3PCRJXDHIHsxZ1Yc8qvP20EibpGZugo+cX9sTw0BddemB4kDMH0nbp9lDkhDPRWwACyVqV
        8waAG56f8iMkesx4lEXDCYk0HpaDgPG0FtD7/vdCKznlAlETfA=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v5 0/3] net: WangXun txgbe ethernet driver
Date:   Tue, 25 Oct 2022 10:02:14 +0800
Message-Id: <20221025020217.576501-1-jiawenwu@trustnetic.com>
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

