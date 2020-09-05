Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D60A25E54C
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 06:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgIEEIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 00:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgIEEIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 00:08:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEFDB207EA;
        Sat,  5 Sep 2020 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599278882;
        bh=+EQ0uWVpdta+XdzJNsINeLHm1iFnRwMKEP0dfE3YxJ0=;
        h=From:To:Cc:Subject:Date:From;
        b=Ia2GUBzcZasLX/dsda6C2QgrIaPepv2qC5mwBUXLlxFuD/KgYLMIc4UphZNz0TI70
         0DWt0ccu6kkub1+nDRZqMH7xZM+vvcQ0WAUjpApajEp+AhteBwvjRG3OHCeIyjELf2
         T6XgK1evnwO9sWaDz6tUns3PwRHWi3yOvL4oz3Zk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        mmc@linux.vnet.ibm.com, drt@linux.ibm.com, tlfalcon@linux.ibm.com,
        jallen@linux.ibm.com
Subject: [PATCH net] ibmvnic: add missing parenthesis in do_reset()
Date:   Fri,  4 Sep 2020 21:07:49 -0700
Message-Id: <20200905040749.2450572-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Indentation and logic clearly show that this code is missing
parenthesis.

Fixes: 9f1345737790 ("ibmvnic fix NULL tx_pools and rx_tools issue at do_reset")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mmc@linux.vnet.ibm.com
CC: drt@linux.ibm.com
CC: tlfalcon@linux.ibm.com
CC: jallen@linux.ibm.com

I randomly noticed this when doing a net -> net-next merge.

Folks, please: (a) make more of an effort testing your code, especially
for fixes!, and (b) try making your code COMPILE_TEST-able, I'm 100% sure
buildbot would've caught this immediately if it wasn't for the arch
dependency.

 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index d3a774331afc..1b702a43a5d0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2032,16 +2032,18 @@ static int do_reset(struct ibmvnic_adapter *adapter,
 
 		} else {
 			rc = reset_tx_pools(adapter);
-			if (rc)
+			if (rc) {
 				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
 						rc);
 				goto out;
+			}
 
 			rc = reset_rx_pools(adapter);
-			if (rc)
+			if (rc) {
 				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
 						rc);
 				goto out;
+			}
 		}
 		ibmvnic_disable_irqs(adapter);
 	}
-- 
2.26.2

