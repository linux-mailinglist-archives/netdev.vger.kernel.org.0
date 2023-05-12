Return-Path: <netdev+bounces-2132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BF89700708
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:42:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FF191C211C8
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BC0D519;
	Fri, 12 May 2023 11:42:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA9EBA56
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 11:42:23 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4A1BFB
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683891740; x=1715427740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j1COhsDcE+zZ7+9KqjZTgPVlGDY5moRYhu17lspBH4M=;
  b=q5uAC3xlCkxn70KxKoizLDnrPZSLzFPfVpawneOluapuqmOZBQL2omx/
   qq/aV1Pk2L405Gxb/XHfxJqS6dOKHH6fi1pWxXTz5glUsT4zpuPlv1sIU
   Nwq7jb6rJmxgoy/NtRTb+LmTKkmoIs/e2RT3gndgXbvzb+jOqvkqY8srQ
   6fAh672QKzCgwYPqzRN7mx6tQWvuvd7uZvaQEUUL6nqSMcJ5wGfoeXxN9
   1/I24PakVs7yWS3Q2UNXLim+dBJ5wzvJGhM+B4WggYbVts1EyEQclxQ7n
   SSL7Ro2Q5OIqy6iTD14DXLHmgsztPPLD0kTp8FZSev0wx4VhgPzhmdxaB
   g==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677567600"; 
   d="scan'208";a="151722082"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 May 2023 04:42:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 12 May 2023 04:42:14 -0700
Received: from daire-X570.emdalo.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 12 May 2023 04:42:12 -0700
From: <daire.mcnamara@microchip.com>
To: <nicholas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <conor.dooley@microchip.com>
CC: Daire McNamara <daire.mcnamara@microchip.com>
Subject: [PATCH v3 0/1] Adjust macb max_tx_len for mpfs
Date: Fri, 12 May 2023 12:42:08 +0100
Message-ID: <20230512114209.2894459-1-daire.mcnamara@microchip.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Daire McNamara <daire.mcnamara@microchip.com>

Several customers have reported unexpected ethernet issues whereby
the GEM stops transmitting and receiving. Performing an action such
as ifconfig <ethX> down; ifconfig <ethX> up clears this particular
condition.

The origin of the issue is a stream of AMBA_ERRORS (bit 6) from the
tx queues.

This patch sets the max_tx_length to SRAM size (16 KiB
in the case of mpfs) divided by num_queues (4 in the case of mpfs)
and then subtracts 56 bytes from that figure - resulting in max_tx_len
of 4040.  The max jumbo length is also set to 4040.  These figures
are derived from Cadence erratum 1686.

Change from v2
- Remove pointless check for existence of macb_config.

Change from v1
- Switched from using macb_is_gem() to hw_is_gem() as macb_is_gem()
  relies on capabilities being read and these have not been ascertained
  at this point of the probe routine.

Daire McNamara (1):
  net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs

 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.25.1


