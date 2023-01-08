Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE5E661488
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 11:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjAHKgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 05:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjAHKgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 05:36:07 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC25CE0C6
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 02:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673174166; x=1704710166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tp8YrA/QmF9BGSvmkOyBb6k+v1Soq/Sj2/zR8dpdDGM=;
  b=KP2YBycWQJ8Ur1kPK0LrEDEvmLMNkcXISNj6pLPz5MEOwJbm1vf+SFan
   T4xVA0qmgJqkz+Q4dCqrURq+2qVI6jipcSTf+wTmMvFAySIik9/w1yDkC
   lXp+iQnmrmbzLHs/s0WhSDruW+ldOevMymFYIQxXouXJDb2b2LcD1ohOB
   g=;
X-IronPort-AV: E=Sophos;i="5.96,310,1665446400"; 
   d="scan'208";a="168893040"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 10:36:04 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id F312881155;
        Sun,  8 Jan 2023 10:36:02 +0000 (UTC)
Received: from EX19D002UWC002.ant.amazon.com (10.13.138.166) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 8 Jan 2023 10:35:58 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX19D002UWC002.ant.amazon.com (10.13.138.166) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Sun, 8 Jan 2023 10:35:57 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Sun, 8 Jan 2023 10:35:55 +0000
From:   David Arinzon <darinzon@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     David Arinzon <darinzon@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH V1 net-next 5/5] net: ena: Add devlink documentation
Date:   Sun, 8 Jan 2023 10:35:33 +0000
Message-ID: <20230108103533.10104-6-darinzon@amazon.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230108103533.10104-1-darinzon@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the documentation with a devlink section, the
added files, as well as large LLQ enablement.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
---
 .../device_drivers/ethernet/amazon/ena.rst    | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 8bcb173e0353..1229732a8c91 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -53,6 +53,7 @@ ena_common_defs.h   Common definitions for ena_com layer.
 ena_regs_defs.h     Definition of ENA PCI memory-mapped (MMIO) registers.
 ena_netdev.[ch]     Main Linux kernel driver.
 ena_ethtool.c       ethtool callbacks.
+ena_devlink.[ch]    devlink files (see `devlink support`_ for more info)
 ena_pci_id_tbl.h    Supported device IDs.
 =================   ======================================================
 
@@ -253,6 +254,35 @@ RSS
 - The user can provide a hash key, hash function, and configure the
   indirection table through `ethtool(8)`.
 
+.. _`devlink support`:
+DEVLINK SUPPORT
+===============
+.. _`devlink`: https://www.kernel.org/doc/html/latest/networking/devlink/index.html
+
+`devlink`_ supports toggling LLQ entry size between the default 128 bytes and 256
+bytes.
+A 128 bytes entry size allows for a maximum of 96 bytes of packet header size
+which sometimes is not enough (e.g. when using tunneling).
+Increasing LLQ entry size to 256 bytes, allows a maximum header size of 224
+bytes. This comes with the penalty of reducing the number of LLQ entries in the
+TX queue by 2 (i.e. from 1024 to 512).
+
+The entry size can be toggled by enabling/disabling the large_llq_header devlink
+param and reloading the driver to make it take effect, e.g.
+
+.. code-block:: shell
+
+  sudo devlink dev param set pci/0000:00:06.0 name large_llq_header value true cmode driverinit
+  sudo devlink dev reload pci/0000:00:06.0
+
+One way to verify that the TX queue entry size has indeed increased is to check
+that the maximum TX queue depth is 512. This can be checked, for example, by
+using:
+
+.. code-block:: shell
+
+  ethtool -g [interface]
+
 DATA PATH
 =========
 
-- 
2.38.1

