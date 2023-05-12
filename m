Return-Path: <netdev+bounces-2140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 129ED7007B1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 14:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 323F22819E9
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 12:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75916D535;
	Fri, 12 May 2023 12:24:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6652CBE54
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:24:55 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E61329D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 05:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683894266; x=1715430266;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1dsjrPdVx17z9TaloSz3K8PkxwumtyX+xbqID0MYJ5I=;
  b=vAxvDZmqwPkTbobJgUQmj+tyEa7BjHn7HsZMg1z7ca/lU8i3JZHzqI9w
   YsghO3yQiVdvodm8xnrdz0YdEgTyCMohGQKyb5j1XEUP4YUY9FJ34r1FG
   ckPE4ZAOcadzNi92qNAAhsA9alpysnearteeHtlVpIzRSek7DlcbRJN/U
   AZVFnbh7PxcstFGewcm5+0WtX7YAlylx1reyPh1M/AsEb91sy+4gz9APE
   9MsDbgYDChRue1Ma2+HtCWuGwuNkj9FFf2NaXcWppUkzi10Nuu8mTYog2
   VEGyHxFauXS1BpkXtnl36+9eAr/hJ6IifOHQgCyejWl9/m2LzffupYIOB
   g==;
X-IronPort-AV: E=Sophos;i="5.99,269,1677567600"; 
   d="scan'208";a="213590200"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 May 2023 05:21:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 12 May 2023 05:20:37 -0700
Received: from daire-X570.emdalo.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.21 via Frontend Transport; Fri, 12 May 2023 05:20:35 -0700
From: <daire.mcnamara@microchip.com>
To: <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <conor.dooley@microchip.com>
CC: Daire McNamara <daire.mcnamara@microchip.com>
Subject: [PATCH v4 0/1] Adjust macb max_tx_len for mpfs
Date: Fri, 12 May 2023 13:20:31 +0100
Message-ID: <20230512122032.2902335-1-daire.mcnamara@microchip.com>
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

Change from v3
- Simplified the if/else ladder

Change from v2
- Remove pointless check for existence of macb_config.

Change from v1
- Switched from using macb_is_gem() to hw_is_gem() as macb_is_gem()
  relies on capabilities being read and these have not been ascertained
  at this point of the probe routine.

Daire McNamara (1):
  net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs

 drivers/net/ethernet/cadence/macb.h      |  1 +
 drivers/net/ethernet/cadence/macb_main.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.25.1


