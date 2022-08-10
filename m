Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A21058E91B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiHJI43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiHJI42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:56:28 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D5A6D544
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 01:56:24 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660121779tu9hvxj3
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 10 Aug 2022 16:56:06 +0800 (CST)
X-QQ-SSF: 01400000000000G0S000B00A0000000
X-QQ-FEAT: gTLdG/Pttc11Pc581g4oFdPB5dj0iFPcQwKMyJF1xrrAy+gX7t7o3f6gAoTpU
        8LKXtClDNUL1UIvGfVfQj+gVJ3GbX1dgqPsgxkrLCmBkwJaf2qUCrKwV4kV9NY1wwJjo6Qc
        WbXVTsKMlG0G9lA02q8FM7rGrqNOwJWPAQlp9CzAS5Qam1xh4GwycWQNF1GJjIXcXBdrRJC
        wBed3euNtfv0MLGlubpKblE04Og12im/2hES6n0ihQqRsEKxWGFCDig0vNH6jO1nRJQIAVF
        94OkQCFiXjqU/8H5rpZOxm3jekYv389bT4JHW0ejS1XwRfCNiEG/dC5bQN3ClYivDRYJpMi
        clUxCh7XdS7mW7iVnI3CHQEu9r42OMYsg4Hoi0E3LHitxPDp65XoLS9Kprx0Q==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [RFC PATCH net-next 00/16] net: WangXun txgbe ethernet driver
Date:   Wed, 10 Aug 2022 16:55:16 +0800
Message-Id: <20220810085532.246613-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for WangXun 10 gigabit NIC, to initialize
hardware, establish link connection and pass traffic.

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

 .../device_drivers/ethernet/wangxun/txgbe.rst |   83 +
 drivers/net/ethernet/wangxun/txgbe/Makefile   |    4 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  594 ++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 4023 ++++++++++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |  179 +
 .../net/ethernet/wangxun/txgbe/txgbe_lib.c    |  463 ++
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 5505 ++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    |  418 ++
 .../net/ethernet/wangxun/txgbe/txgbe_phy.h    |   55 +
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 1791 ++++++
 10 files changed, 13088 insertions(+), 27 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.h

-- 
2.27.0

