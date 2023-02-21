Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F9E69DCC1
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjBUJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbjBUJVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:21:21 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6293E241C1;
        Tue, 21 Feb 2023 01:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676971280; x=1708507280;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pmenu2GVkhSBQ5X5KgWqeKvBL7nngYZy4hgpQatRc4k=;
  b=FBqzYs2fVX0cdx/5ql/O++mPfe/G3pVab3i4kqBURIOdp/Qybm0ZkEJo
   8vUa6l9UmyS8jq8BUR53FRIxnkZohy6KarVqEXtx8IcwWmMh+L9gm4CS5
   sKOg7NX8ikEN+l8RY2tWQFuyTb/wqY7CS22JgggN5XOd2u6pDA2apCmu8
   aixpBlccHBHDH9RgzWYYe9cGJHPsYc6bk534wNxr0dwMgE61b+Eah+8fa
   c8Mhmb7lfaNQ9Xpd0Cs3N4P0aVx9cdeTe17s/u1MngGZcOHhiNjYCAj3i
   3e3X1qPs1lLaHPFh4ldZSwoTIiosrh6YjXF3g9isDJsIKL2xaDw6HnU7A
   A==;
X-IronPort-AV: E=Sophos;i="5.97,315,1669100400"; 
   d="scan'208";a="197955817"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 02:21:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 02:21:19 -0700
Received: from che-lt-i66125lx.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 02:21:08 -0700
From:   Durai Manickam KR <durai.manickamkr@microchip.com>
To:     <Hari.PrasathGE@microchip.com>,
        <balamanikandan.gunasundar@microchip.com>,
        <manikandan.m@microchip.com>, <varshini.rajendran@microchip.com>,
        <dharma.b@microchip.com>, <nayabbasha.sayed@microchip.com>,
        <balakrishnan.s@microchip.com>, <claudiu.beznea@microchip.com>,
        <cristian.birsan@microchip.com>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <linux@armlinux.org.uk>, <palmer@dabbelt.com>,
        <paul.walmsley@sifive.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>
CC:     Durai Manickam KR <durai.manickamkr@microchip.com>
Subject: [PATCH 0/2] Add PTP support for sama7g5
Date:   Tue, 21 Feb 2023 14:51:02 +0530
Message-ID: <20230221092104.730504-1-durai.manickamkr@microchip.com>
X-Mailer: git-send-email 2.25.1
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

This patch series is intended to add PTP capability to the GEM and 
EMAC for sama7g5.

Durai Manickam KR (2):
  net: macb: Add PTP support to GEM for sama7g5
  net: macb: Add PTP support to EMAC for sama7g5

 drivers/net/ethernet/cadence/macb_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.25.1

