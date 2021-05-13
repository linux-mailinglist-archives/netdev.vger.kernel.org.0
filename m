Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6537F6FB
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232696AbhEMLo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhEMLow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:44:52 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B513C06175F;
        Thu, 13 May 2021 04:43:42 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lh9kb-0007HF-7O; Thu, 13 May 2021 14:43:33 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v2 0/5] atl1c: support for Mikrotik 10/25G NIC features
Date:   Thu, 13 May 2021 14:43:21 +0300
Message-Id: <20210513114326.699663-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new Mikrotik 10/25G NIC maintains compatibility with existing atl1c
driver. However it does have new features.

This patch set adds support for reporting cards higher link speed, max-mtu,
enables rx csum offload and improves tx performance.

v2:
    - fixed xmit_more handling as pointed out by Eric Dumazet
    - added a more reliable link detection on Mikrotik 10/25G NIC
      since MDIO op emulation can occasionally fail

Gatis Peisenieks (5):
  atl1c: show correct link speed on Mikrotik 10/25G NIC
  atl1c: improve performance by avoiding unnecessary pcie writes on xmit
  atl1c: adjust max mtu according to Mikrotik 10/25G NIC ability
  atl1c: enable rx csum offload on Mikrotik 10/25G NIC
  atl1c: improve link detection reliability on Mikrotik 10/25G NIC

 drivers/net/ethernet/atheros/atl1c/atl1c.h    |  3 +
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c | 35 +++++++++---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |  8 +++
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 55 ++++++++++++-------
 4 files changed, 75 insertions(+), 26 deletions(-)


base-commit: d8654f4f9300e5e7cf8d5e7885978541cf61326b
-- 
2.31.1

