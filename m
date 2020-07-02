Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD1A211F70
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgGBJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:06:26 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:48754 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGBJGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593680776; x=1625216776;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Im2GebTOIZZlfmKOsTFK9uOSEjefyN+E0CBRHkuUtUQ=;
  b=G+P84OiFBEkNQBm6xwwO7kKJOGOoFq/QHmiKRtH4HCYOcOn4FEUNlRaN
   mHkz/sKtZnQPr0Z3cQr4rkHjMMpMSKLd9bemHXHFUeaOmTzGOPWsrdEtW
   EyB9BeVUQuyccd/Y5S4QFmvX176HxNMxFgROlhDpA8NZHuKqhJ2+G90Kr
   1F8/GO1MDPMeRVEcK9RFOhzfzYOvcU1g0n/Om0SJ/5bPFeTbUr2g12Zbf
   /d7ozCJvXgH1BvvmuIUqKv+RDVcmaXfxRjeBFjiEORLk8yFsuDluWd6rU
   a+B+f40Y1u2V/bkWCbNJXxq9qRMCI9kmH8l1Ks6gtb68ab82KBYN1GAUE
   w==;
IronPort-SDR: Rldi/T+er2aa75mk4m/MIXj9YnxqLXN9NZNZXBL5iiwdPCEDkAm+gSzpR4sMP44yRppWvKqDG1
 8ruw30SRlaSDIv6ZFlQFVm4+kr0YmQP2AaKsaMNQUYk6x/zy68RUP+Y1QczoMP0fStI5VxZXLD
 AkvUo1/MOizZTSqQNkLR/iArDDKyRJ+U8UgTWuYYye66ADaPKE7wMHWmIwHClr2E1qbg0OG3Al
 cycxX5sWnGgCGDUwA4q1Uyw92XHiDOBd9szuRNa1C3tPbz1zfFGEKxXcsRvzD9GwBHVI8yz+xH
 akY=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="81642875"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:06:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:06:15 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:06:12 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next v2 3/4] net: macb: do not initialize queue variable
Date:   Thu, 2 Jul 2020 12:06:00 +0300
Message-ID: <1593680761-11427-4-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not initialize queue variable. It is already initialized in for loops.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7668b6ae8822..c31c15e99e3c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1467,7 +1467,7 @@ static void macb_hresp_error_task(unsigned long data)
 {
 	struct macb *bp = (struct macb *)data;
 	struct net_device *dev = bp->dev;
-	struct macb_queue *queue = bp->queues;
+	struct macb_queue *queue;
 	unsigned int q;
 	u32 ctrl;
 
-- 
2.7.4

