Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CBA620E83
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbiKHLTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiKHLTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:19:38 -0500
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DFFE030
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:19:29 -0800 (PST)
X-QQ-mid: bizesmtp85t1667906363t160yiff
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 08 Nov 2022 19:19:09 +0800 (CST)
X-QQ-SSF: 01400000000000M0M000000A0000000
X-QQ-FEAT: bQsUcYFpAAa20slScD+S10Q9dZqxeHHnjI5qRAjpWKDJT5znhF1UqV6vzXCrR
        H5E5gj7i0gZx4wUK4ZUrjPr0RLk/Cwy2g51kY5tbANY6SHg+kAtg8d8uV06PdDOV3oOkfp9
        fljPvujkndRIO/xplc3V0yn9qkoVdIQTmPeEg4haxQwyWp9WYAAYXw3CzTzt9WTrBW7cuQf
        kBwS2r1pT8555lckJWfai9DyMeYAn4QjoFS0Mv40NVoExzXKo4omcIZiT8gB5nT0sw180Y3
        AfYSNE8M9ikOaO4kl0txj4DUVCxwqHD/n2hWN15te/QaaL94SBLqH3WXuxEOq2ozn69ULuC
        nRjBOa9gkIhhCD5TP/o8s8WIXja20XBI4yH2XasWse8YKIdhiVcrIrDTd5h2LUWuaucLszV
        yuen+V1QoY8=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 0/5] net: WangXun ethernet drivers
Date:   Tue,  8 Nov 2022 19:19:02 +0800
Message-Id: <20221108111907.48599-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for WangXun NICS, to initialize
phy ops and start service task to check link status.

Jiawen Wu (3):
  net: txgbe: Identify PHY and SFP module
  net: txgbe: Initialize service task
  net: txgbe: Support to setup link

Mengyuan Lou (2):
  net: ngbe: Initialize phy information
  net: ngbe: Initialize service task

 .../device_drivers/ethernet/wangxun/txgbe.rst |   42 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |    9 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |    3 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |    7 +
 drivers/net/ethernet/wangxun/ngbe/Makefile    |    2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |   23 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |   36 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |    1 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  408 ++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c  | 1113 ++++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h  |   22 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  114 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |   31 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 1590 ++++++++++++++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |    9 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  475 ++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  227 +++
 17 files changed, 4082 insertions(+), 30 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_phy.h

-- 
2.38.1

