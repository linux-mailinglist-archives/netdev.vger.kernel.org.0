Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5865F971
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 03:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjAFCOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 21:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjAFCOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 21:14:49 -0500
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12BA61473
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:14:46 -0800 (PST)
X-QQ-mid: bizesmtp69t1672971281tmlfynaq
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 10:14:32 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000000A0000000
X-QQ-FEAT: c42nD1GNGyn7STNizz2PS7BKeW9hxP+EEhHpR84/cf99wQRsSJeihbHCLPVHW
        8jh4zVYC6najDrsoBvoD48xBheKTD8v80bBXH4+kx4eZRA7z9SjtKJR7M9YO+GmIgxWBy1X
        F99pPHRt5F1LqeDqAMi2BOAfO1jFuh2mKsS7Nzb1uPAazyn8B0VfdpPv978UxatLHHpNm6r
        ONFKsiaIGP/Tkzhjf7wYKq8i1iJBASjrIc3KmM8zqpPI9HWPTlwYxILRVXPSlUDf2vIsaPC
        Au9ImqRiCQw0HVyiqsLlGTI0hnKcut3NmBwnV9FLBKH4wasPY6nfnjjoEr47KiuYA9MMJv/
        4Xw2+lYAXw2s9Hfan+zzNa9EmtxNdvPhdtXbcO1
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 0/7] net: wangxun: Adjust code structure
Date:   Fri,  6 Jan 2023 10:11:38 +0800
Message-Id: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
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

Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
And move the same codes which sets MAC address between txgbe and ngbe
to libwx. Further more, rename struct 'wx_hw' to 'wx' and move total
adapter members to wx.

Changelog:
v3:
  - Change function parameters to keep two drivers more similar
  - Add strucure rename patch
  - Add adapter remove patch
v2:
  - Split patch v1 into separate patches
  - Fix unreasonable code logic in MAC address operations

Jiawen Wu (6):
  net: ngbe: Remove structure ngbe_hw
  net: txgbe: Move defines into unified file
  net: ngbe: Move defines into unified file
  net: wangxun: Move MAC address handling to libwx
  net: wangxun: Rename private structure in libwx
  net: txgbe: Remove structure txgbe_adapter

Mengyuan Lou (1):
  net: ngbe: Remove structure ngbe_adapter

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 504 +++++++++++-------
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  37 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  72 ++-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  79 ---
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  47 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 300 ++++-------
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  68 +--
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  23 -
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 112 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 326 ++++-------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  26 +-
 13 files changed, 702 insertions(+), 902 deletions(-)
 delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h

-- 
2.27.0

