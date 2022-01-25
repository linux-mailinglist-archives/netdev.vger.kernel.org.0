Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB649B34E
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 12:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378386AbiAYLwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 06:52:19 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45938 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382543AbiAYLrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 06:47:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643111220; x=1674647220;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m4Gv1rOAy5HlJVDw0q1CXJc0eAXjL2pwC1xJtKAjLv4=;
  b=C13MyxsfYRKWrUuVbFbFHOROs4WHvmLKmOcd3H0JfQIOaAhxisWLLKXu
   kCFZomaD1mQSnPkRsU+2UEZE8kOr2HXdglxKNOz8i4Abaf5Indigpyt8l
   dzw98Eeq+9xdPzQEFNtFW8lWAJo2RJhXsPwXsB71SYftfJGJHWzvobgG6
   bJbk7DExAb6T1i2h7+9bvLmeDpGxfACAXbhED8lAJpwCWr5p9ThTfN5uU
   xahDbeSm3jRGCwbZ7pfHmeP4cEeyJFIP6JQEPCbAZfEOLcuxq44Bc0Wmg
   WaradRGKhAjieVFEzsvV8DiB8YSEuHhVjt2qW4HsdLKeWfUQ920yeFQd9
   Q==;
IronPort-SDR: 45/87QssTidJaG6Ujr1gtughVqjgTz/MxAh/GzrCGrDSOq0PvRkI0vwHKDRwgd+4yig5A266uI
 xrjosW7U/IoGAJCMkjEN6CHeau4D7jdZqqeWnVdGAobRBM1iLe83Sxn9RqozwYQ/Bu1WsmeABc
 lmHo6gFGAgZTNXiGLPIQHPb7CS3uFi8YqpJL5qvdYQ7GIDqw3384LL8x8IMxWAkw+NuGTWOiyl
 6B3evHwzkcBrvHtFdUxobCXbz2ZPld02O0I7nd1Rhmf7x5B+dFLBSAhR7dfAG/PQ0EsqH9iSUE
 JQOLvmmARwEY26JEBFqo2Oqy
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="159880539"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2022 04:46:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 25 Jan 2022 04:46:57 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 25 Jan 2022 04:46:55 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 0/2] net: lan966x: Fixes for sleep in atomic context
Date:   Tue, 25 Jan 2022 12:48:14 +0100
Message-ID: <20220125114816.187124-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains 2 fixes for lan966x that is sleeping in atomic
context. The first patch fixes the injection of the frames while the second
one fixes the updating of the MAC table.

v1->v2:
 - correct the fix tag in the second patch, it was using the wrong sha.

Horatiu Vultur (2):
  net: lan966x: Fix sleep in atomic context when injecting frames
  net: lan966x: Fix sleep in atomic context when updating MAC table

 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c  | 11 ++++++-----
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c |  6 +++---
 2 files changed, 9 insertions(+), 8 deletions(-)

-- 
2.33.0

