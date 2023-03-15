Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E506BACA9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjCOJwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjCOJwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:52:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BE27EA06;
        Wed, 15 Mar 2023 02:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678873872; x=1710409872;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pmenu2GVkhSBQ5X5KgWqeKvBL7nngYZy4hgpQatRc4k=;
  b=JvruyRXOKJW5PhYafplz3yyn80YPtg7RCMGyPRHKhd5Q2mfhcZgHv1WU
   jA6lccW/edubAz08On4xbOpABBw1c+Kw9qQ9y5EliCP3KMdm3s2J6Dg53
   amna+3rve9Uj3qZtigRqh2YzFanDfqRKrbGF3mnqbbBBdb7m3ZMfgw5Dc
   iBSCgBvxwnuAvTchWWUQlxPf4QP3J4eaejcrEOl8MIOBFq5f4D+i40yGT
   lMpoSJi8BLy35rcccemr0XEyHOuzuc0WYR4Jll81FC2FZ+eObgmqZSaA3
   U6gd/PveDz6QyuVOBMFtTYJ1cuGIBQylKl0/6jnAAaxkIa/UDy9LuLpBi
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,262,1673938800"; 
   d="scan'208";a="205492233"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Mar 2023 02:51:10 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 02:51:08 -0700
Received: from che-lt-i66125lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 02:51:01 -0700
From:   Durai Manickam KR <durai.manickamkr@microchip.com>
To:     <Hari.PrasathGE@microchip.com>,
        <balamanikandan.gunasundar@microchip.com>,
        <manikandan.m@microchip.com>, <varshini.rajendran@microchip.com>,
        <dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
        <balakrishnan.s@microchip.com>, <claudiu.beznea@microchip.com>,
        <cristian.birsan@microchip.com>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <linux@armlinux.org.uk>,
        <palmer@dabbelt.com>, <paul.walmsley@sifive.com>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <pabeni@redhat.com>
CC:     Durai Manickam KR <durai.manickamkr@microchip.com>
Subject: [PATCH 0/2] Add PTP support for sama7g5
Date:   Wed, 15 Mar 2023 15:20:51 +0530
Message-ID: <20230315095053.53969-1-durai.manickamkr@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is intended to add PTP capability to the GEM and 
EMAC for sama7g5.

Durai Manickam KR (2):
  net: macb: Add PTP support to GEM for sama7g5
  net: macb: Add PTP support to EMAC for sama7g5

 drivers/net/ethernet/cadence/macb_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.25.1

