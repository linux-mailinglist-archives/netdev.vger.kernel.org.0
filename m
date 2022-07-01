Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB0C562C25
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbiGAG6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbiGAG6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:58:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3780A6759C;
        Thu, 30 Jun 2022 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656658726; x=1688194726;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9rml+Sm/loPs16VC7h+57zxkeT7atJLmjKj6lEjZoi0=;
  b=YAH0/0OhYJ44r/EtSP0jzfoYhuCNvEvqC+6etKlLui5ioC3+oacj8CGA
   vHbR+ts6fd492ogPjxGLNaA7moZEiO2bFTVpMSEdjn8XHj/BDFPA5Ti/c
   zhiVOq3DUR5kY6VHHzqbnjaLrwG/etEoQ0HC7y+89rEP3OTYQ1ffAJ7tm
   Nao4vHfWJb4GXrRneBIb2xzYRvB6/er7dBj2on3FJISrou3De/lgaTDyc
   BQeZNvqVq/s+LSvaBrxdGJPlcu9/VPnhpt00ezZSlWGbdz79PJIoid1SB
   iPix44ujl/dTghkwqO3UAXpPuKIac6tU+EsaAGgdgV8r4lDE2bOQvTs4C
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="165961228"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 23:58:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 23:58:44 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 23:58:41 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH RESEND 0/2] PolarFire SoC macb reset support
Date:   Fri, 1 Jul 2022 07:58:30 +0100
Message-ID: <20220701065831.632785-1-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey all,
Jakub requested that these patches be split off from the series
adding the reset controller itself that I sent yesterday [0].

The Cadence MACBs on PolarFire SoC (MPFS) have reset capability and are
compatible with the zynqmp's init function. I have removed the zynqmp
specific comments from that function & renamed it to reflect what it
does, since it is no longer zynqmp only.

MPFS's MACB had previously used the generic binding, so I also added
the required specific binding.

Thanks,
Conor.

0 - https://lore.kernel.org/all/20220630080532.323731-1-conor.dooley@microchip.com/
Conor Dooley (2):
  dt-bindings: net: cdns,macb: document polarfire soc's macb
  net: macb: add polarfire soc reset support

 .../devicetree/bindings/net/cdns,macb.yaml    |  1 +
 drivers/net/ethernet/cadence/macb_main.c      | 25 +++++++++++++------
 2 files changed, 19 insertions(+), 7 deletions(-)

-- 
2.36.1

