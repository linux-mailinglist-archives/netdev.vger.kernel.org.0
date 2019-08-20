Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A385096328
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbfHTOxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 10:53:47 -0400
Received: from vps.xff.cz ([195.181.215.36]:60010 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728283AbfHTOxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 10:53:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566312824; bh=py02IQSJ2y0fP6mE701P/T7DLz5rHrBBsdi+SrYtmAQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ihT3jfMZjyNKOOmCAeVt8DagRKcxrgxjzBtMNrrsWuA2kW/0aWuyGUxkSeqV3zmDF
         DR8RbXPdWB0aunx4ASN4un+qj3dbjsy6VQ9bOV82+6a5KJ1i6hIjs1eEfFfqrBW1cW
         4zQmFKTHoUOoKsCOJgwVFpzgGDvjG2WzldaFI9rU=
From:   megous@megous.com
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Ondrej Jirman <megous@megous.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 0/6] Add ethernet support for Orange Pi 3
Date:   Tue, 20 Aug 2019 16:53:37 +0200
Message-Id: <20190820145343.29108-1-megous@megous.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ondrej Jirman <megous@megous.com>

This series implements ethernet support for Xunlong Orange Pi 3 board, by:

- making small cleanups of existing dwmac-sun8i code
- adding DT bindings docummentation
- adding support for phy-io-supply to dwmac-sun8i code
- adding DT configuration for Orange Pi 3 board

For some people, ethernet doesn't work after reboot because u-boot doesn't
support AXP805 PMIC, and will not turn off the etherent PHY regulators.
So the regulator controlled by gpio will be shut down, but the other one
controlled by the AXP PMIC will not.

This is a problem only when running with a builtin driver. This needs
to be fixed in u-boot and should not prevent these patches from being
merged.

This evolved out of the Orange Pi 3 patches series, as I didn't want
to stretch that out any longer.

Please take a look.

thank you and regards,
  Ondrej Jirman

Ondrej Jirman (6):
  dt-bindings: net: sun8i-a83t-emac: Add phy-supply property
  dt-bindings: net: sun8i-a83t-emac: Add phy-io-supply property
  net: stmmac: sun8i: Use devm_regulator_get for PHY regulator
  net: stmmac: sun8i: Rename PHY regulator variable to regulator_phy
  net: stmmac: sun8i: Add support for enabling a regulator for PHY I/O
    pins
  arm64: dts: allwinner: orange-pi-3: Enable ethernet

 .../net/allwinner,sun8i-a83t-emac.yaml        |  8 ++
 .../dts/allwinner/sun50i-h6-orangepi-3.dts    | 40 ++++++++++
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 74 ++++++++++++-------
 3 files changed, 96 insertions(+), 26 deletions(-)

-- 
2.22.1

