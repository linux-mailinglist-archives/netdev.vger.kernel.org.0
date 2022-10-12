Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF08D5FC3D2
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJLKgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJLKf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:35:59 -0400
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB2153D0C
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 03:35:57 -0700 (PDT)
X-QQ-mid: bizesmtp64t1665570953tmkeypje
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 12 Oct 2022 18:35:43 +0800 (CST)
X-QQ-SSF: 01400000000000H0U000B00A0000000
X-QQ-FEAT: PS/N6jJLnDZDVMly9xJaXrKEKSPe/gA0lgpJ2s3tO+j3KLzJMBv2Hms36SaxQ
        /qVLPkl4nsCt7BdRh3NnuT36mTk7MMaeMd2ydKjJDl0X2TZEbJsUtpRgMYXA0YX4MUrDmYN
        gGPu9HU5Y0PXScYCjFOB8i6h0/myEHOuuuZTh5oPu3KvLAw6mE8HUAWtcQcuWsK3VqNT8tp
        zwaXjCuuAMp7xahVcCoKmAWW4gmKvTAhLQpLPOmpPyDdaidA4/bd3g4+RizRERn9Cd7XZ5F
        JqJECLe5PoRVd8gdCy8N1skIZlsgNjob8KdFE2mNpaoz+stES45CRlPi1QM+Q4Yqn3RRnOv
        ILizFNJIezZnuRjJTIcfTkSmee4fMJkKZRyjUGT16l5YLtUQXR4jtMtfY/sog==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v4 0/3] net: WangXun txgbe ethernet driver
Date:   Wed, 12 Oct 2022 18:35:30 +0800
Message-Id: <20221012103533.738954-1-jiawenwu@trustnetic.com>
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

