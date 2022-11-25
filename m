Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F7A638694
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiKYJs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiKYJrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:47:32 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADBC43842;
        Fri, 25 Nov 2022 01:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369567; x=1700905567;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dhMKlCa5dFSVKnu5rDneVOws/l/QKdOe1lykoTi8K1c=;
  b=SRYcS4s5+MFkOPugwfMh8xE0C3ZymzqrZUPNJsaysOGlhBfvLtF/v8HS
   /PGWetzRv0yITERfA6qCQlOTzNImoel/1gp4IjizcM9b0BdnwEVbiTiZ1
   YCgYsewZCNDjqXL7AV4+280GfAgsig+ydyJ2t/D6VsUx1ARnoXGpTBary
   n8jajrNiXtIuN9FHDucaxaRTr/odsJIrh0w+dYIGN6LABR11hw1F9j4ZI
   gTgJO9/arK2vMlLMz+HmVxbZszuL/498qwmn2N8znNAaFIaLbJhGq1+O+
   PGLgSEOhfgV7dQ6ZftMRqX3fZqc+EeTvFa+qbjd5vz9hTXmz8rN8Wg511
   g==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="190494935"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:06 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:03 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 0/9] Add support for lan966x IS2 VCAP
Date:   Fri, 25 Nov 2022 10:50:01 +0100
Message-ID: <20221125095010.124458-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides initial support for lan966x for 'tc' traffic control
userspace tool and its flower filter. For this is required to use
the VCAP library.

Currently supported flower filter keys and actions are:
- source and destination MAC address keys
- trap action

Horatiu Vultur (9):
  net: microchip: vcap: Merge the vcap_ag_api_kunit.h into vcap_ag_api.h
  net: microchip: vcap: Extend vcap with lan966x
  net: lan966x: Add initial VCAP
  net: lan966x: Add is2 vcap model to vcap API.
  net: lan966x: add vcap registers
  net: lan966x: add tc flower support for VCAP API
  net: lan966x: add tc matchall goto action
  net: lan966x: Add port keyset config and callback interface
  net: microchip: vcap: Implement w32be

 .../net/ethernet/microchip/lan966x/Kconfig    |    1 +
 .../net/ethernet/microchip/lan966x/Makefile   |    6 +-
 .../ethernet/microchip/lan966x/lan966x_goto.c |   54 +
 .../ethernet/microchip/lan966x/lan966x_main.c |   11 +
 .../ethernet/microchip/lan966x/lan966x_main.h |   18 +
 .../ethernet/microchip/lan966x/lan966x_regs.h |  196 ++
 .../ethernet/microchip/lan966x/lan966x_tc.c   |    2 +
 .../microchip/lan966x/lan966x_tc_flower.c     |  262 +++
 .../microchip/lan966x/lan966x_tc_matchall.c   |    6 +
 .../microchip/lan966x/lan966x_vcap_ag_api.c   | 1608 +++++++++++++++++
 .../microchip/lan966x/lan966x_vcap_ag_api.h   |   11 +
 .../microchip/lan966x/lan966x_vcap_impl.c     |  550 ++++++
 .../net/ethernet/microchip/vcap/vcap_ag_api.h |  561 +++++-
 .../microchip/vcap/vcap_ag_api_kunit.h        |  643 -------
 .../net/ethernet/microchip/vcap/vcap_api.c    |  116 +-
 .../net/ethernet/microchip/vcap/vcap_api.h    |    3 -
 16 files changed, 3321 insertions(+), 727 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
 delete mode 100644 drivers/net/ethernet/microchip/vcap/vcap_ag_api_kunit.h

-- 
2.38.0

