Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142ADAE006
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 22:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391726AbfIIUpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 16:45:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:33440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbfIIUpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 16:45:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C19ABABB1;
        Mon,  9 Sep 2019 20:44:57 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Juliet Kim <julietk@linux.vnet.ibm.com>
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        John Allen <jallen@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/ibmvnic: Fix missing { in __ibmvnic_reset
Date:   Mon,  9 Sep 2019 22:44:51 +0200
Message-Id: <20190909204451.7929-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190907.173714.1400426487600521308.davem@davemloft.net>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
adds a } without corresponding { causing build break.

Fixes: 1c2977c09499 ("net/ibmvnic: free reset work of removed device from queue")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6644cabc8e75..5cb55ea671e3 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1984,7 +1984,7 @@ static void __ibmvnic_reset(struct work_struct *work)
 	rwi = get_next_rwi(adapter);
 	while (rwi) {
 		if (adapter->state == VNIC_REMOVING ||
-		    adapter->state == VNIC_REMOVED)
+		    adapter->state == VNIC_REMOVED) {
 			kfree(rwi);
 			rc = EBUSY;
 			break;
-- 
2.22.0

