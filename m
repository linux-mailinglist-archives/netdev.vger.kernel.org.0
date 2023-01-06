Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0612365FA67
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbjAFDmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbjAFDmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:42:00 -0500
X-Greylist: delayed 5206 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 05 Jan 2023 19:41:57 PST
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA436A0F7
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 19:41:57 -0800 (PST)
X-QQ-mid: bizesmtp76t1672976511toc2qjq2
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 11:41:41 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: CR3LFp2JE4nDZ2qZuaxOsJgCTlqLNgC2UHD150vqMjkeGk3W9bzryjPqfmmrU
        FZ+VB9RSwNqQCF7AdnJ8INkHhJTp2IODlZjK1Xm+Nu150v7kL7i6/zVFflqgNfGh9M57Vbo
        Y3HJ8gSxKKaqvJ6481j4awad/h8371SREAWNbKa9uIRYxo1Kgc0onlNanrIwXi+KZWn//bK
        TEZig0TCYqz3Gcl793i5TNHK5XHn0gVSo+7Sl6eLlbEKO50AKr6cQR5n+7HT0Bb+0hb1anq
        3pJ5u8QTqJ6ROGSKr7AXI+UyWLuXFIfRvGXOGeO4JWGOMh/q+DMvp5xhxXyYwIf4TUoSV5O
        Oqs7hDayGBs4ZK5JahxyNPMQSFsX3ZruZVjRiC9ujTUwB9KUVokWVM7dGwzrn1FWj/XLle+
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 0/8] net: wangxun: Adjust code structure
Date:   Fri,  6 Jan 2023 11:38:45 +0800
Message-Id: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
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

Jiawen Wu (7):
  net: txgbe: Remove structure txgbe_hw
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
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  43 --
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c | 116 ++--
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h |   6 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 335 ++++--------
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  14 +-
 13 files changed, 704 insertions(+), 921 deletions(-)
 delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h

-- 
2.27.0

