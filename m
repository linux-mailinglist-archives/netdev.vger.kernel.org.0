Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F32D98DC
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 14:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439503AbgLNNcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 08:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439495AbgLNNcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 08:32:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1970CC0613D3
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 05:31:53 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1konx9-0003Kb-LJ
        for netdev@vger.kernel.org; Mon, 14 Dec 2020 14:31:51 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5D23F5AD29E
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:31:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E5C7B5AD28B;
        Mon, 14 Dec 2020 13:31:46 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 934e8ee3;
        Mon, 14 Dec 2020 13:31:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-12-14
Date:   Mon, 14 Dec 2020 14:31:38 +0100
Message-Id: <20201214133145.442472-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a series of 7 patches for net-next/master.

All 7 patches are by me and target the m_can driver. First there are 4 cleanup
patches (fix link to doc, fix coding style, uniform variable name usage, mark
function as static). Then the driver is converted to
pm_runtime_resume_and_get(). The next patch lets the m_can class driver
allocate the driver's private data, to get rid of one level of indirection. And
the last patch consistently uses struct m_can_classdev as drvdata over all
binding drivers.

regards,
Marc

---

The following changes since commit 13458ffe0a953e17587f172a8e5059c243e6850a:

  net: x25: Remove unimplemented X.25-over-LLC code stubs (2020-12-12 17:15:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.11-20201214

for you to fetch changes up to c6b734892420f00fdc3c49b8c1029aa5bf0790b9:

  can: m_can: use struct m_can_classdev as drvdata (2020-12-14 14:24:17 +0100)

----------------------------------------------------------------
linux-can-next-for-5.11-20201214

----------------------------------------------------------------
Marc Kleine-Budde (7):
      can: m_can: update link to M_CAN user manual
      can: m_can: convert indention to kernel coding style
      can: m_can: use cdev as name for struct m_can_classdev uniformly
      can: m_can: m_can_config_endisable(): mark as static
      can: m_can: m_can_clk_start(): make use of pm_runtime_resume_and_get()
      can: m_can: let m_can_class_allocate_dev() allocate driver specific private data
      can: m_can: use struct m_can_classdev as drvdata

 drivers/net/can/m_can/m_can.c          | 206 ++++++++++++++++-----------------
 drivers/net/can/m_can/m_can.h          |   5 +-
 drivers/net/can/m_can/m_can_pci.c      |  32 ++---
 drivers/net/can/m_can/m_can_platform.c |  40 ++++---
 drivers/net/can/m_can/tcan4x5x.c       |  44 +++----
 5 files changed, 160 insertions(+), 167 deletions(-)


