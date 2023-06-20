Return-Path: <netdev+bounces-12230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87485736D71
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C194C1C2084C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E9316400;
	Tue, 20 Jun 2023 13:36:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB544156F5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:36:19 +0000 (UTC)
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1DC0B7
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687268178; x=1718804178;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n5hHJ3IV4hlIg4/imPJj+yT/7ki2h2U66LKYBLJFw9A=;
  b=vf/5MqnZOEfshpdXZYEYqeYCaI38n92xwhSMcHpqL1PdIu5LkHqHpmrj
   lbDT1uLd4gd2dBjHQo9ZaXUM+nZOeGM/t9yAAkF50/+kHUdusopjUSUlc
   HUG+IdIkvxGROS0+DW9HMtKTnmAJF6c5qQ2GKoeK+OWUM9SclMiJ9h37c
   c=;
X-IronPort-AV: E=Sophos;i="6.00,257,1681171200"; 
   d="scan'208";a="655210448"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 13:36:10 +0000
Received: from EX19MTAUWC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
	by email-inbound-relay-iad-1e-m6i4x-0aba4706.us-east-1.amazon.com (Postfix) with ESMTPS id 6FA45A2C36;
	Tue, 20 Jun 2023 13:36:09 +0000 (UTC)
Received: from EX19D010UWB003.ant.amazon.com (10.13.138.81) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 13:35:51 +0000
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19D010UWB003.ant.amazon.com (10.13.138.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 13:35:51 +0000
Received: from dev-dsk-darinzon-1c-05962a8d.eu-west-1.amazon.com
 (172.19.80.187) by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP
 Server id 15.2.1118.26 via Frontend Transport; Tue, 20 Jun 2023 13:35:48
 +0000
From: <darinzon@amazon.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	<netdev@vger.kernel.org>
CC: David Arinzon <darinzon@amazon.com>, "Woodhouse, David" <dwmw@amazon.com>,
	"Machulsky, Zorik" <zorik@amazon.com>, "Matushevsky, Alexander"
	<matua@amazon.com>, Saeed Bshara <saeedb@amazon.com>, "Wilson, Matt"
	<msw@amazon.com>, "Liguori, Anthony" <aliguori@amazon.com>, "Bshara, Nafea"
	<nafea@amazon.com>, "Saidi, Ali" <alisaidi@amazon.com>, "Herrenschmidt,
 Benjamin" <benh@amazon.com>, "Kiyanovski, Arthur" <akiyano@amazon.com>,
	"Dagan, Noam" <ndagan@amazon.com>, "Agroskin, Shay" <shayagr@amazon.com>,
	"Itzko, Shahar" <itzko@amazon.com>, "Abboud, Osama" <osamaabb@amazon.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net-next] net: ena: Fix rst format issues in readme
Date: Tue, 20 Jun 2023 13:35:44 +0000
Message-ID: <20230620133544.32584-1-darinzon@amazon.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: Bulk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Arinzon <darinzon@amazon.com>

This patch fixes a warning in the ena documentation
file identified by the kernel automatic tools.
The patch also adds a missing newline between
sections.

Signed-off-by: David Arinzon <darinzon@amazon.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306171804.U7E92zoE-lkp@intel.com/
---
 Documentation/networking/device_drivers/ethernet/amazon/ena.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
index 491492677632..5eaa3ab6c73e 100644
--- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
+++ b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
@@ -38,6 +38,7 @@ debug logs.
 
 Some of the ENA devices support a working mode called Low-latency
 Queue (LLQ), which saves several more microseconds.
+
 ENA Source Code Directory Structure
 ===================================
 
@@ -206,6 +207,7 @@ More information about Adaptive Interrupt Moderation (DIM) can be found in
 Documentation/networking/net_dim.rst
 
 .. _`RX copybreak`:
+
 RX copybreak
 ============
 The rx_copybreak is initialized by default to ENA_DEFAULT_RX_COPYBREAK
-- 
2.40.1


