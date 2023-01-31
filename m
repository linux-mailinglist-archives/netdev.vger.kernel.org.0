Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952E26829E6
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjAaKGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAaKGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:06:05 -0500
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22607DBC
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:06:00 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159553t3f1vvqf
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:05:43 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: G3NsQplooNFiZEKgQerUPIrY3maNTHuBJzDv3CwTBE8D6WilN3eSG8tvSY1je
        n/bNsrwL1L4M0gd+nlmSq4o+fHFc3KX74tUN7RU0pH0ToTvl+RjYoQbvWbB6nISCU6e5NsT
        wYW9a/MDVHiRnmaAliq1V7Nsj2b7s/AWbQwdFTkCVDbAuviCIZvARFaE93yCmWOFNWU2oxe
        yw7WrjX0KgFpPRs//UJDEG2uWMa96AF0jKj5UQ3+v3eHdMTSOXTyDUa5KeYN0YID2jNNM74
        1p3IZtn5E4shWxIjQavAZPyBtHA8tKg//4kl911bDzyeKKnXBXIcc3Tf3aj1QNshQ3xE0Vq
        WJ+QRIEXoIwYEtDRRK9vaNdA5GFqNXZuOcKpHK20ljrOpmnKBRozVSNOo2KsT9PnNoMGMSD
        SW4eaxduguy6xltwXJrxFA==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 00/10] Wangxun interrupt and RxTx support
Date:   Tue, 31 Jan 2023 18:05:31 +0800
Message-Id: <20230131100541.73757-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure interrupt, setup RxTx ring, support to receive and transmit
packets.

changes v2:
- Andrew Lunn: https://lore.kernel.org/netdev/Y86kDphvyHj21IxK@lunn.ch/
- Add a judgment when allocate dma for descriptor.

Jiawen Wu (5):
  net: txgbe: Add interrupt support
  net: libwx: Configure Rx and Tx unit on hardware
  net: libwx: Allocate Rx and Tx resources
  net: txgbe: Setup Rx and Tx ring
  net: txgbe: Support Rx and Tx process path

Mengyuan Lou (5):
  net: libwx: Add irq flow functions
  net: ngbe: Add irqs request flow
  net: libwx: Support to receive packets in NAPI
  net: libwx: Add tx path to process packets
  net: ngbe: Support Rx and Tx process path

 drivers/net/ethernet/wangxun/Kconfig          |    1 +
 drivers/net/ethernet/wangxun/libwx/Makefile   |    2 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  675 +++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |    5 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 2009 +++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h   |   32 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  315 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  249 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   18 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  271 ++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   21 +
 11 files changed, 3580 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.h

-- 
2.39.1

