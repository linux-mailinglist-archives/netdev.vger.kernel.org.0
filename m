Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF625A5C98
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiH3HJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbiH3HJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:09:23 -0400
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EC1C59FE
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 00:08:40 -0700 (PDT)
X-QQ-mid: bizesmtp76t1661843119tofhr02z
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 Aug 2022 15:05:08 +0800 (CST)
X-QQ-SSF: 01400000000000G0T000B00A0000000
X-QQ-FEAT: DQ0OCu3gog2k8ysNRdw5j6DDCepEanttkn2OVnjFEBI9ZrUxkF36E6rc5N5+v
        desX4/7yK+pHOY8VMzOcAbiiCy+EdYYvPD2nQSiz85ID9M4X1gF96xfrFuqlB9F+FgZsnDi
        BNw1B9bvcDzvWVdE0rgXNPX5V7fnJGt6tuSgJ5SsSGPAUW1ups2xbSMOcbRlAPtnCX8OT/i
        PJH394s+rX/zw0gZ/Sc6S+XGR/Zz4yLAbNzw/B/GRIfvRAkgokci+GkQlimSMn09Brmzd8Z
        EQkoLle7/RArTzim2R9HZvvbCbtmU91uvnD55TLfwKs9BtdjaNhOde8bhpdrFhB1buxatmU
        OSRWN1+gpeIHeWK+AIKq1YH6ofGoP0A4BclyoTJ1bO1Z5uFaqc=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 00/16] net: WangXun txgbe ethernet driver
Date:   Tue, 30 Aug 2022 15:04:38 +0800
Message-Id: <20220830070454.146211-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for WangXun 10 gigabit NIC, to initialize
hardware, establish link connection and pass traffic.

Change log:
v2: address comments:
    Andrew Lunn: https://lore.kernel.org/netdev/YvRhld5rD%2FxgITEg@lunn.ch/

Jiawen Wu (16):
  net: txgbe: Store PCI info
  net: txgbe: Reset hardware
  net: txgbe: Set MAC address and register netdev
  net: txgbe: Add operations to interact with firmware
  net: txgbe: Identify PHY and SFP module
  net: txgbe: Initialize service task
  net: txgbe: Support to setup link
  net: txgbe: Add interrupt support
  net: txgbe: Handle various event interrupts
  net: txgbe: Configure Rx and Tx unit of the MAC
  net: txgbe: Allocate Rx and Tx resources
  net: txgbe: Add Rx and Tx cleanup routine
  net: txgbe: Add device Rx features
  net: txgbe: Add transmit path to process packets
  net: txgbe: Support to get system network statistics
  net: txgbe: support to respond Tx hang

 .../device_drivers/ethernet/wangxun/txgbe.rst |   84 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |    4 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  552 ++
 .../net/ethernet/wangxun/txgbe/txgbe_dummy.h  |  301 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 3751 ++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  174 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |  463 ++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 5399 ++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |  365 ++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   52 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 1562 +++++
 11 files changed, 12680 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_dummy.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

-- 
2.27.0

