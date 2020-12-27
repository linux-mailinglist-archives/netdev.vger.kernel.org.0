Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEBF2E3139
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 14:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgL0NFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 08:05:00 -0500
Received: from www.zeus03.de ([194.117.254.33]:37816 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbgL0NE7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 08:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=tmWbHOXfMeP55apGt7ZxVbzXHAl
        N8ghGe1G17Q/QG3k=; b=AmVLBez7RFGgQaZlq3yBYEMYESI8XGJtVibMbJ2eLh7
        JIsnMJb3OJs7v9sLGQan8nKupgiOkTnceBmDany1CqVp4ALqI/LBf1WZOhor/kPa
        bgdbIDzxK7Defc76nfdi/7z3diRWDugxozTlgkYARQDyazqTPPOC2EwHVZ8qlUog
        =
Received: (qmail 1501056 invoked from network); 27 Dec 2020 14:04:17 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Dec 2020 14:04:17 +0100
X-UD-Smtp-Session: l3s3148p1@y8yIy3G3YMEgAwDPXwIpAOUwDQytQs2L
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: [PATCH 0/5] v3u: add support for RAVB
Date:   Sun, 27 Dec 2020 14:04:01 +0100
Message-Id: <20201227130407.10991-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the series to enable RAVB on V3U. I took the DTS patches
from the BSP, the rest was developed on mainline tree. Note that only
RAVB0 could be tested because the other ones did not have PHYs attached.

Also, the last patch is a workaround. 'reset-gpios' cannot be obtained
currently which makes the driver fail. The problem is that
pinctrl_ready_for_gpio_range() returns EPROBE-DEFER. I hope Geert has an
idea because I got lost in the GPIO and V3U pinctrl details there. It
seems more of a PFC/CPG/GPIO problem to me.

Without the reset-gpio, the driver binds to avb0 and I can ping the host
successfully. So, I think at least the first three patches are ready.

Let me know your thoughts!

All the best,

   Wolfram


Tho Vu (2):
  arm64: dts: renesas: r8a779a0: Add Ethernet-AVB support
  arm64: dts: renesas: falcon: Add Ethernet-AVB support

Wolfram Sang (3):
  dt-bindings: net: renesas,etheravb: Add r8a779a0 support
  clk: renesas: r8a779a0: add clocks for RAVB
  arm64: dts: r8a779a0: WIP disable reset-gpios for AVB

 .../bindings/net/renesas,etheravb.yaml        |   1 +
 .../boot/dts/renesas/r8a779a0-falcon.dts      | 195 +++++++++++++
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi     | 270 ++++++++++++++++++
 drivers/clk/renesas/r8a779a0-cpg-mssr.c       |   6 +
 4 files changed, 472 insertions(+)

-- 
2.29.2

