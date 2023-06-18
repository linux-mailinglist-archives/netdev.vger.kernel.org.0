Return-Path: <netdev+bounces-11770-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ACCC734648
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42B1E2810DF
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 13:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF7B1C03;
	Sun, 18 Jun 2023 13:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8067F184C
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:23:12 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2BD12F;
	Sun, 18 Jun 2023 06:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687094588; x=1718630588;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FVlwepFy/UglT5MUNxy17NwDKspoxGIR9qfU/vyDNtI=;
  b=GI7as7+xH50gOW8GpW0dmvfKQGVqPxveId98UYLOSX4iBmV86b3IPY7K
   jF3lXRDcDuqpMfT0foXa9Ri5LIql4tulS0Zw+4DyYOMKsRfCJWjnHaAhE
   Sk0slrRu69AxAK46/felmUvjhFeDA/X/asCjRk9ClUKVTfA63g/J5U936
   Bvvt8Ux84ZEsWQbK8iEJWdTIgHJThWukbGFJj0B8M6V00C1KvpISWAACk
   SJJY2t/YWgBZGemP9V5cvBirb+iej/JvUlh5XKCLr6A5iEPE/wr1J0s3a
   ZAUy7+1Go2eJzfXzivfD1KPZCoXa1bGYNcmZPHBuTacT8HZi+8JR2aueq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="356967032"
X-IronPort-AV: E=Sophos;i="6.00,252,1681196400"; 
   d="scan'208";a="356967032"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2023 06:23:08 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="747146720"
X-IronPort-AV: E=Sophos;i="6.00,252,1681196400"; 
   d="scan'208";a="747146720"
Received: from unknown (HELO localhost.localdomain) ([10.226.216.116])
  by orsmga001.jf.intel.com with ESMTP; 18 Jun 2023 06:23:03 -0700
From: niravkumar.l.rabara@intel.com
To: Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Niravkumar L Rabara <niravkumar.l.rabara@intel.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Wen Ping <wen.ping.teh@intel.com>,
	Richard Cochran <richardcochran@gmail.com>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	netdev@vger.kernel.org,
	Adrian Ng Ho Yin <adrian.ho.yin.ng@intel.com>
Subject: [PATCH 0/4] Add support for Agilex5 SoCFPGA platform
Date: Sun, 18 Jun 2023 21:22:31 +0800
Message-Id: <20230618132235.728641-1-niravkumar.l.rabara@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Niravkumar L Rabara <niravkumar.l.rabara@intel.com>

This patch set introduce the changes required for Agilx5 platform.

patch [1/4] - Introduced compatible string for Agilex5 board
patch [2/4] - Add reset and clock header and yaml file.
patch [3/4] - Add clock driver for Agilex5 platform. This patch depends
on patch 2.
patch [4/4] - Add device tree files, socfpga_agilex5_socdk_swvp.dts is
used for Virtual Platform (SIMICS) and socfpga_agilex5_socdk_nand.dts
is used for NAND Flash based board. This patch depends on patch 3.

Niravkumar L Rabara (4):
  dt-bindings: intel: Add Intel Agilex5 compatible
  dt-bindings: clock: Add Intel Agilex5 clocks and resets
  clk: socfpga: agilex5: Add clock driver for Agilex5 platform
  arm64: dts: agilex5: Add initial support for Intel's Agilex5 SoCFPGA

 .../bindings/arm/intel,socfpga.yaml           |   1 +
 .../bindings/clock/intel,agilex5.yaml         |  42 +
 arch/arm64/boot/dts/intel/Makefile            |   3 +
 .../arm64/boot/dts/intel/socfpga_agilex5.dtsi | 641 +++++++++++++
 .../boot/dts/intel/socfpga_agilex5_socdk.dts  | 184 ++++
 .../dts/intel/socfpga_agilex5_socdk_nand.dts  | 131 +++
 .../dts/intel/socfpga_agilex5_socdk_swvp.dts  | 248 ++++++
 drivers/clk/socfpga/Kconfig                   |   4 +-
 drivers/clk/socfpga/Makefile                  |   2 +-
 drivers/clk/socfpga/clk-agilex5.c             | 843 ++++++++++++++++++
 drivers/clk/socfpga/clk-pll-s10.c             |  48 +
 drivers/clk/socfpga/stratix10-clk.h           |   2 +
 include/dt-bindings/clock/agilex5-clock.h     | 100 +++
 .../dt-bindings/reset/altr,rst-mgr-agilex5.h  |  79 ++
 14 files changed, 2325 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/intel,agilex5.yaml
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5.dtsi
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5_socdk.dts
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_nand.dts
 create mode 100644 arch/arm64/boot/dts/intel/socfpga_agilex5_socdk_swvp.dts
 create mode 100644 drivers/clk/socfpga/clk-agilex5.c
 create mode 100644 include/dt-bindings/clock/agilex5-clock.h
 create mode 100644 include/dt-bindings/reset/altr,rst-mgr-agilex5.h

-- 
2.25.1


