Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1970537258A
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 07:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhEDFlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 01:41:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:51814 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhEDFln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 01:41:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 303E5B165;
        Tue,  4 May 2021 05:40:48 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     netdev@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Lijun Pan <lijunp213@gmail.com>,
        Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] ibmvnic: remove default label from to_string switch
Date:   Tue,  4 May 2021 07:40:42 +0200
Message-Id: <20210504054042.29305-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210503.134721.2149322673805635760.davem@davemloft.net>
References: <20210503.134721.2149322673805635760.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This way the compiler warns when a new value is added to the enum but
not to the string translation like:

drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
drivers/net/ethernet/ibm/ibmvnic.c:832:2: warning: enumeration value 'VNIC_FOOBAR' not handled in switch [-Wswitch]
  switch (state) {
  ^~~~~~
drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
drivers/net/ethernet/ibm/ibmvnic.c:1935:2: warning: enumeration value 'VNIC_RESET_FOOBAR' not handled in switch [-Wswitch]
  switch (reason) {
  ^~~~~~

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
v2: Fix typo in commit message
---
 drivers/net/ethernet/ibm/ibmvnic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 5788bb956d73..4d439413f6d9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -846,9 +846,8 @@ static const char *adapter_state_to_string(enum vnic_state state)
 		return "REMOVING";
 	case VNIC_REMOVED:
 		return "REMOVED";
-	default:
-		return "UNKNOWN";
 	}
+	return "UNKNOWN";
 }
 
 static int ibmvnic_login(struct net_device *netdev)
@@ -1946,9 +1945,8 @@ static const char *reset_reason_to_string(enum ibmvnic_reset_reason reason)
 		return "TIMEOUT";
 	case VNIC_RESET_CHANGE_PARAM:
 		return "CHANGE_PARAM";
-	default:
-		return "UNKNOWN";
 	}
+	return "UNKNOWN";
 }
 
 /*
-- 
2.26.2

