Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED06125724
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLRWpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:45:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:57860 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfLRWpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 17:45:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 14:45:31 -0800
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="210247085"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.200])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 14:45:31 -0800
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>
Subject: [PATCH 2/2] ether: Add ETH_P_AVTP macro
Date:   Wed, 18 Dec 2019 14:44:48 -0800
Message-Id: <20191218224448.8066-2-andre.guedes@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218224448.8066-1-andre.guedes@intel.com>
References: <20191218224448.8066-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the ETH_P_AVTP macro which defines the Audio/Video
Transport Protocol (AVTP) ethertype assigned to 0x22F0, according to:

http://standards-oui.ieee.org/ethertype/eth.txt

AVTP is the transport protocol utilized in Audio/Video Bridging (AVB),
and it is defined by IEEE 1722 standard.

Note that we have ETH_P_TSN macro defined with the number assigned to
AVTP. However, there is no "TSN" ethertype. TSN is not a protocol, but a
set of features to deliver networking determinism, so ETH_P_TSN can be a
bit misleading. For compatibility reasons we should keep it around.
This patch re-defines it using the ETH_P_AVTP macro to make it explicit.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 include/uapi/linux/if_ether.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 0752281ee05a..c75cb646ba08 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -47,7 +47,8 @@
 #define ETH_P_LOOP	0x0060		/* Ethernet Loopback packet	*/
 #define ETH_P_PUP	0x0200		/* Xerox PUP packet		*/
 #define ETH_P_PUPAT	0x0201		/* Xerox PUP Addr Trans packet	*/
-#define ETH_P_TSN	0x22F0		/* TSN (IEEE 1722) packet	*/
+#define ETH_P_AVTP	0x22F0		/* AVTP (IEEE 1722)		*/
+#define ETH_P_TSN	ETH_P_AVTP	/* There is no TSN ethertype, we define it for compatibility reasons */
 #define ETH_P_ERSPAN2	0x22EB		/* ERSPAN version 2 (type III)	*/
 #define ETH_P_IP	0x0800		/* Internet Protocol packet	*/
 #define ETH_P_X25	0x0805		/* CCITT X.25			*/
-- 
2.24.1

