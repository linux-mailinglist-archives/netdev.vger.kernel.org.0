Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75E46D77FC
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbjDEJZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbjDEJZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:25:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8AB46BD
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:24:59 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pjzNx-00046k-ON
        for netdev@vger.kernel.org; Wed, 05 Apr 2023 11:24:57 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BE3EA1A7129
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:24:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 347D71A7121;
        Wed,  5 Apr 2023 09:24:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3e90eda6;
        Wed, 5 Apr 2023 09:24:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/4] pull-request: can 2023-04-05
Date:   Wed,  5 Apr 2023 11:24:40 +0200
Message-Id: <20230405092444.1802340-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello netdev-team,

this is a pull request of 4 patches for net/master.

The first patch is by Oleksij Rempel and fixes a out-of-bounds memory
access in the j1939 protocol.

The remaining 3 patches target the ISOTP protocol. Oliver Hartkopp
fixes the ISOTP protocol to pass information about dropped PDUs to the
user space via control messages. Michal Sojka's patch fixes poll() to
not forward false EPOLLOUT events. And Oliver Hartkopp fixes a race
condition between isotp_sendsmg() and isotp_release().

regards,
Marc

---

The following changes since commit 3ce9345580974863c060fa32971537996a7b2d57:

  gve: Secure enough bytes in the first TX desc for all TCP pkts (2023-04-04 18:58:12 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.3-20230405

for you to fetch changes up to 051737439eaee5bdd03d3c2ef5510d54a478fd05:

  can: isotp: fix race between isotp_sendsmg() and isotp_release() (2023-04-05 11:16:37 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.3-20230405

----------------------------------------------------------------
Michal Sojka (1):
      can: isotp: isotp_ops: fix poll() to not report false EPOLLOUT events

Oleksij Rempel (1):
      can: j1939: j1939_tp_tx_dat_new(): fix out-of-bounds memory access

Oliver Hartkopp (2):
      can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos
      can: isotp: fix race between isotp_sendsmg() and isotp_release()

 net/can/isotp.c           | 74 ++++++++++++++++++++++++++++++-----------------
 net/can/j1939/transport.c |  5 +++-
 2 files changed, 52 insertions(+), 27 deletions(-)


