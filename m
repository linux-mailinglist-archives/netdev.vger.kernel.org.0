Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE15FB944A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393582AbfITPmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 11:42:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45126 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393522AbfITPmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 11:42:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 02BC081DE3;
        Fri, 20 Sep 2019 15:42:20 +0000 (UTC)
Received: from asgard.redhat.com (ovpn-112-68.ams2.redhat.com [10.36.112.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69CEB60461;
        Fri, 20 Sep 2019 15:42:18 +0000 (UTC)
Date:   Fri, 20 Sep 2019 17:41:55 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: [PATCH net v2 2/3] uapi, net/smc: provide fallback diagnostic codes
 in UAPI
Message-ID: <fc576e49d8e5d44e464f91183bc6784e5c338843.1568993930.git.esyr@redhat.com>
References: <cover.1568993930.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1568993930.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 20 Sep 2019 15:42:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the values to which these codes are corresponding to are already
exposed via sock_diag interface.

Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 include/uapi/linux/smc.h | 25 +++++++++++++++++++++++++
 net/smc/smc_clc.h        | 22 ----------------------
 2 files changed, 25 insertions(+), 22 deletions(-)

diff --git a/include/uapi/linux/smc.h b/include/uapi/linux/smc.h
index 10561f8..9fbf365 100644
--- a/include/uapi/linux/smc.h
+++ b/include/uapi/linux/smc.h
@@ -17,6 +17,31 @@
 #define SMCPROTO_SMC		0	/* SMC protocol, IPv4 */
 #define SMCPROTO_SMC6		1	/* SMC protocol, IPv6 */
 
+/* Diagnostic codes */
+#define SMC_CLC_DECL_MEM	0x01010000  /* insufficient memory resources  */
+#define SMC_CLC_DECL_TIMEOUT_CL	0x02010000  /* timeout w4 QP confirm link     */
+#define SMC_CLC_DECL_TIMEOUT_AL	0x02020000  /* timeout w4 QP add link	      */
+#define SMC_CLC_DECL_CNFERR	0x03000000  /* configuration error            */
+#define SMC_CLC_DECL_PEERNOSMC	0x03010000  /* peer did not indicate SMC      */
+#define SMC_CLC_DECL_IPSEC	0x03020000  /* IPsec usage		      */
+#define SMC_CLC_DECL_NOSMCDEV	0x03030000  /* no SMC device found (R or D)   */
+#define SMC_CLC_DECL_NOSMCDDEV	0x03030001  /* no SMC-D device found	      */
+#define SMC_CLC_DECL_NOSMCRDEV	0x03030002  /* no SMC-R device found	      */
+#define SMC_CLC_DECL_SMCDNOTALK	0x03030003  /* SMC-D dev can't talk to peer   */
+#define SMC_CLC_DECL_MODEUNSUPP	0x03040000  /* smc modes do not match (R or D)*/
+#define SMC_CLC_DECL_RMBE_EC	0x03050000  /* peer has eyecatcher in RMBE    */
+#define SMC_CLC_DECL_OPTUNSUPP	0x03060000  /* fastopen sockopt not supported */
+#define SMC_CLC_DECL_DIFFPREFIX	0x03070000  /* IP prefix / subnet mismatch    */
+#define SMC_CLC_DECL_GETVLANERR	0x03080000  /* err to get vlan id of ip device*/
+#define SMC_CLC_DECL_ISMVLANERR	0x03090000  /* err to reg vlan id on ism dev  */
+#define SMC_CLC_DECL_SYNCERR	0x04000000  /* synchronization error          */
+#define SMC_CLC_DECL_PEERDECL	0x05000000  /* peer declined during handshake */
+#define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
+#define SMC_CLC_DECL_ERR_RTOK	0x09990001  /*	 rtoken handling failed       */
+#define SMC_CLC_DECL_ERR_RDYLNK	0x09990002  /*	 ib ready link failed	      */
+#define SMC_CLC_DECL_ERR_REGRMB	0x09990003  /*	 reg rmb failed		      */
+
+
 /* Netlink SMC_PNETID attributes */
 enum {
 	SMC_PNETID_UNSPEC,
diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index ca20927..db6a78f 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -28,28 +28,6 @@
 #define SMC_TYPE_B		3		/* SMC-R and SMC-D	      */
 #define CLC_WAIT_TIME		(6 * HZ)	/* max. wait time on clcsock  */
 #define CLC_WAIT_TIME_SHORT	HZ		/* short wait time on clcsock */
-#define SMC_CLC_DECL_MEM	0x01010000  /* insufficient memory resources  */
-#define SMC_CLC_DECL_TIMEOUT_CL	0x02010000  /* timeout w4 QP confirm link     */
-#define SMC_CLC_DECL_TIMEOUT_AL	0x02020000  /* timeout w4 QP add link	      */
-#define SMC_CLC_DECL_CNFERR	0x03000000  /* configuration error            */
-#define SMC_CLC_DECL_PEERNOSMC	0x03010000  /* peer did not indicate SMC      */
-#define SMC_CLC_DECL_IPSEC	0x03020000  /* IPsec usage		      */
-#define SMC_CLC_DECL_NOSMCDEV	0x03030000  /* no SMC device found (R or D)   */
-#define SMC_CLC_DECL_NOSMCDDEV	0x03030001  /* no SMC-D device found	      */
-#define SMC_CLC_DECL_NOSMCRDEV	0x03030002  /* no SMC-R device found	      */
-#define SMC_CLC_DECL_SMCDNOTALK	0x03030003  /* SMC-D dev can't talk to peer   */
-#define SMC_CLC_DECL_MODEUNSUPP	0x03040000  /* smc modes do not match (R or D)*/
-#define SMC_CLC_DECL_RMBE_EC	0x03050000  /* peer has eyecatcher in RMBE    */
-#define SMC_CLC_DECL_OPTUNSUPP	0x03060000  /* fastopen sockopt not supported */
-#define SMC_CLC_DECL_DIFFPREFIX	0x03070000  /* IP prefix / subnet mismatch    */
-#define SMC_CLC_DECL_GETVLANERR	0x03080000  /* err to get vlan id of ip device*/
-#define SMC_CLC_DECL_ISMVLANERR	0x03090000  /* err to reg vlan id on ism dev  */
-#define SMC_CLC_DECL_SYNCERR	0x04000000  /* synchronization error          */
-#define SMC_CLC_DECL_PEERDECL	0x05000000  /* peer declined during handshake */
-#define SMC_CLC_DECL_INTERR	0x09990000  /* internal error		      */
-#define SMC_CLC_DECL_ERR_RTOK	0x09990001  /*	 rtoken handling failed       */
-#define SMC_CLC_DECL_ERR_RDYLNK	0x09990002  /*	 ib ready link failed	      */
-#define SMC_CLC_DECL_ERR_REGRMB	0x09990003  /*	 reg rmb failed		      */
 
 struct smc_clc_msg_hdr {	/* header1 of clc messages */
 	u8 eyecatcher[4];	/* eye catcher */
-- 
2.1.4

