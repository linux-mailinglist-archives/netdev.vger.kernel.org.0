Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6408E393138
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbhE0OqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbhE0OqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:46:07 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02424C061763;
        Thu, 27 May 2021 07:44:33 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1lmHFM-0002jz-2V; Thu, 27 May 2021 17:44:28 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net-next v4 0/4] add 4 RX/TX queue support for Mikrotik 10/25G NIC
Date:   Thu, 27 May 2021 17:44:19 +0300
Message-Id: <20210527144423.3395719-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

More RX/TX queues on a network card help spread the CPU load among
cores and achieve higher overall networking performance.
This patch set adds support for 4 RX/TX queues available on
Mikrotik 10/25G NIC.

v4:
    - addressed comments from Jakub Kicinski:
      - split up the change in more manageable chunks
      - changed member order in structs for tighter packing
      - fixed style issues
    - reverted to calling napi_alloc_skb only from within poll
      as before
v3:
    - fix kernel-doc complaints on comments as pointed out by
      David Miller
v2:
    - rebase on net-next master as requested by David Miller

Gatis Peisenieks (4):
  atl1c: detect NIC type early
  atl1c: move tx napi into tpd_ring
  atl1c: prepare for multiple rx queues
  atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC

 drivers/net/ethernet/atheros/atl1c/atl1c.h    |  25 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h |  34 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 546 +++++++++++-------
 3 files changed, 368 insertions(+), 237 deletions(-)

-- 
2.31.1

