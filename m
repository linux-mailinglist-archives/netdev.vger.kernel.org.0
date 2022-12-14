Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162D164C3ED
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbiLNGnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiLNGnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:43:52 -0500
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ECB10B63
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:43:48 -0800 (PST)
X-QQ-mid: bizesmtp70t1671000223tp2d13u5
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 14 Dec 2022 14:43:33 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000B00A0000000
X-QQ-FEAT: ZkxZBO9qcf7jaEkQ93zhTzli7kp/N2nOjtCb1z4hloNRDEWlMWDkMBlCvWksI
        ftiO2UpLp4bcExZZNp5uVD2gPelGYk6qFWMdZT2q9ObdQ36FV67rX40N4zjl0t9IRODviez
        rq1S6UKMUxgOGPB7tcIfW7BxJuobCVCc60dNV6meSUplyGIq/xSoqfji2+UDzUdF9sVXeK1
        kKYV2ji9QNbjjuWBJdQEUvuIDLB1ePj+JPLK3I7Be//i6ar9IsjLgmpfjEwVv77lE9t+Z1e
        ahQekSUQj/3ITylWC0UR5LL7gognZF3Q06kILgS0N0N+IEWlytB6BjANJz3H9tfCx/HtH7C
        bqLF9MSpH5inW1XBd75kCH4c5jwcwrrIpgIvkFo
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net v2 0/5] net: wangxun: Adjust code structure
Date:   Wed, 14 Dec 2022 14:41:28 +0800
Message-Id: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
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
to libwx.

Changelog:
v2:
  - Split patch v1 into separate patches
  - Fix unreasonable code logic in MAC address operations

Jiawen Wu (5):
  net: txgbe: Remove structure txgbe_hw
  net: ngbe: Remove structure ngbe_hw
  net: txgbe: Move defines into unified file
  net: ngbe: Move defines into unified file
  net: wangxun: Move MAC address handling to libwx

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 116 +++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   5 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  12 ++
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      |  79 --------
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  21 +--
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h   |   4 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 125 ++++---------
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  58 +++++-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  43 -----
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  36 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 174 +++---------------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  22 ++-
 13 files changed, 296 insertions(+), 405 deletions(-)
 delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h

-- 
2.27.0

