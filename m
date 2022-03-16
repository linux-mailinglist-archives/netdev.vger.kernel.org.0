Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86F24DB9B0
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358080AbiCPUux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358051AbiCPUut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:50:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E723F5A5B6
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:49:34 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUaaL-0003qj-9B
        for netdev@vger.kernel.org; Wed, 16 Mar 2022 21:49:33 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8F4974CB65
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6ACF44CB5D;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id abd5405b;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/5] pull-request: can-next 2022-03-16
Date:   Wed, 16 Mar 2022 21:47:05 +0100
Message-Id: <20220316204710.716341-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 5 patches for net-next/master.

the first 3 patches are by Oliver Hartkopp target the CAN ISOTP
protocol and fix a problem found by syzbot in isotp_bind(), return
-EADDRNOTAVAIL in unbound sockets in isotp_recvmsg() and add support
for MSG_TRUNC to isotp_recvmsg().

Amit Kumar Mahapatra converts the xilinx,can device tree bindings to
yaml.

The last patch is by Julia Lawall and fixes typos in the ucan driver.

regards,
Marc

---

The following changes since commit 231fdac3e58f4e52e387930c73bf535439607563:

  net: phy: Kconfig: micrel_phy: fix dependency issue (2022-03-15 12:28:56 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.18-20220316

for you to fetch changes up to c34983c94166689358372d4af8d5def57752860c:

  can: ucan: fix typos in comments (2022-03-16 21:41:40 +0100)

----------------------------------------------------------------
linux-can-next-for-5.18-20220316

----------------------------------------------------------------
Amit Kumar Mahapatra (1):
      dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML

Julia Lawall (1):
      can: ucan: fix typos in comments

Oliver Hartkopp (3):
      can: isotp: sanitize CAN ID checks in isotp_bind()
      can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
      can: isotp: support MSG_TRUNC flag when reading from socket

 .../devicetree/bindings/net/can/xilinx,can.yaml    | 161 +++++++++++++++++++++
 .../devicetree/bindings/net/can/xilinx_can.txt     |  61 --------
 drivers/net/can/usb/ucan.c                         |   4 +-
 net/can/isotp.c                                    |  72 +++++----
 4 files changed, 203 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt


