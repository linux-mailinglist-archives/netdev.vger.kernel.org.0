Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CF1327474
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhB1UiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:38:18 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:37648 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhB1UiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 15:38:17 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru F1B58209AB95
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net 3/3] sh_eth: fix TRSCER mask for R7S9210
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <75bbbe07-60c0-c556-41fa-8a4ddd117f5a@omprussia.ru>
Date:   Sun, 28 Feb 2021 23:27:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According  to the RZ/A2M Group User's Manual: Hardware, Rev. 2.00,
the TRSCER register has bit 9 reserved, hence we can't use the driver's
default TRSCER mask.  Add the explicit initializer for sh_eth_cpu_data::
trscer_err_mask for R7S9210.

Fixes: 6e0bb04d0e4f ("sh_eth: Add R7S9210 support")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/sh_eth.c |    2 ++
 1 file changed, 2 insertions(+)

Index: net/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net/drivers/net/ethernet/renesas/sh_eth.c
@@ -782,6 +782,8 @@ static struct sh_eth_cpu_data r7s9210_da
 
 	.fdr_value	= 0x0000070f,
 
+	.trscer_err_mask = DESC_I_RINT8 | DESC_I_RINT5,
+
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,
