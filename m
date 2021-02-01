Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD230B344
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhBAXSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:18:00 -0500
Received: from mga12.intel.com ([192.55.52.136]:51849 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhBAXR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:17:59 -0500
IronPort-SDR: Ch2kReqYYY0A1+Y2nIGn+9iFqHYhsKzTphWDyPygASQ8mHaeh3E8dbiNPjSMBAYG2EFwriylLw
 pZEbrHuCJO9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="159934350"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="159934350"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:28 -0800
IronPort-SDR: tkA4IcTl2R4edi6Rw64cVNv5c3S14bR9YScekM9sRkZ5D3X6mN+iaU6pkPBgROebVmnmZ4U4LE
 /yjkk1KuLXbw==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="391188480"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.7.131])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:28 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliangtang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 14/15] mptcp: add the mibs for ADD_ADDR with port
Date:   Mon,  1 Feb 2021 15:09:19 -0800
Message-Id: <20210201230920.66027-15-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
References: <20210201230920.66027-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliangtang@gmail.com>

This patch adds the mibs for ADD_ADDR with port:

MPTCP_MIB_PORTADD for received ADD_ADDR suboption with a port number.

MPTCP_MIB_PORTSYNRX, MPTCP_MIB_PORTSYNACKRX, MPTCP_MIB_PORTACKRX, for
received MP_JOIN's SYN or SYN/ACK or ACK with a port number which is
different from the msk's port number.

MPTCP_MIB_MISMATCHPORTSYNRX and MPTCP_MIB_MISMATCHPORTACKRX, for
received SYN or ACK MP_JOIN with a mismatched port-number.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/mib.c     | 6 ++++++
 net/mptcp/mib.h     | 6 ++++++
 net/mptcp/options.c | 4 ++++
 net/mptcp/subflow.c | 8 +++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
index 8ca196489893..3780c29c321d 100644
--- a/net/mptcp/mib.c
+++ b/net/mptcp/mib.c
@@ -29,6 +29,12 @@ static const struct snmp_mib mptcp_snmp_list[] = {
 	SNMP_MIB_ITEM("DuplicateData", MPTCP_MIB_DUPDATA),
 	SNMP_MIB_ITEM("AddAddr", MPTCP_MIB_ADDADDR),
 	SNMP_MIB_ITEM("EchoAdd", MPTCP_MIB_ECHOADD),
+	SNMP_MIB_ITEM("PortAdd", MPTCP_MIB_PORTADD),
+	SNMP_MIB_ITEM("MPJoinPortSynRx", MPTCP_MIB_JOINPORTSYNRX),
+	SNMP_MIB_ITEM("MPJoinPortSynAckRx", MPTCP_MIB_JOINPORTSYNACKRX),
+	SNMP_MIB_ITEM("MPJoinPortAckRx", MPTCP_MIB_JOINPORTACKRX),
+	SNMP_MIB_ITEM("MismatchPortSynRx", MPTCP_MIB_MISMATCHPORTSYNRX),
+	SNMP_MIB_ITEM("MismatchPortAckRx", MPTCP_MIB_MISMATCHPORTACKRX),
 	SNMP_MIB_ITEM("RmAddr", MPTCP_MIB_RMADDR),
 	SNMP_MIB_ITEM("RmSubflow", MPTCP_MIB_RMSUBFLOW),
 	SNMP_MIB_ITEM("MPPrioTx", MPTCP_MIB_MPPRIOTX),
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
index 63914a5ef6a5..72afbc135f8e 100644
--- a/net/mptcp/mib.h
+++ b/net/mptcp/mib.h
@@ -22,6 +22,12 @@ enum linux_mptcp_mib_field {
 	MPTCP_MIB_DUPDATA,		/* Segments discarded due to duplicate DSS */
 	MPTCP_MIB_ADDADDR,		/* Received ADD_ADDR with echo-flag=0 */
 	MPTCP_MIB_ECHOADD,		/* Received ADD_ADDR with echo-flag=1 */
+	MPTCP_MIB_PORTADD,		/* Received ADD_ADDR with a port-number */
+	MPTCP_MIB_JOINPORTSYNRX,	/* Received a SYN MP_JOIN with a different port-number */
+	MPTCP_MIB_JOINPORTSYNACKRX,	/* Received a SYNACK MP_JOIN with a different port-number */
+	MPTCP_MIB_JOINPORTACKRX,	/* Received an ACK MP_JOIN with a different port-number */
+	MPTCP_MIB_MISMATCHPORTSYNRX,	/* Received a SYN MP_JOIN with a mismatched port-number */
+	MPTCP_MIB_MISMATCHPORTACKRX,	/* Received an ACK MP_JOIN with a mismatched port-number */
 	MPTCP_MIB_RMADDR,		/* Received RM_ADDR */
 	MPTCP_MIB_RMSUBFLOW,		/* Remove a subflow */
 	MPTCP_MIB_MPPRIOTX,		/* Transmit a MP_PRIO */
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index c9643344a8d7..331d460d82fa 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1024,6 +1024,10 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 			mptcp_pm_del_add_timer(msk, &addr);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADD);
 		}
+
+		if (mp_opt.port)
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_PORTADD);
+
 		mp_opt.add_addr = 0;
 	}
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ebfbf6a9b669..280da418d60b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -207,8 +207,10 @@ static int subflow_init_req(struct request_sock *req,
 				tcp_request_sock_ops.destructor(req);
 				subflow_req->msk = NULL;
 				subflow_req->mp_join = 0;
+				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MISMATCHPORTSYNRX);
 				return -EPERM;
 			}
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINPORTSYNRX);
 		}
 
 		subflow_req_create_thmac(subflow_req);
@@ -431,6 +433,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			pr_debug("synack inet_dport=%d %d",
 				 ntohs(inet_sk(sk)->inet_dport),
 				 ntohs(inet_sk(parent)->inet_dport));
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINPORTSYNACKRX);
 		}
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
@@ -702,8 +705,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 				pr_debug("ack inet_sport=%d %d",
 					 ntohs(inet_sk(sk)->inet_sport),
 					 ntohs(inet_sk((struct sock *)owner)->inet_sport));
-				if (!mptcp_pm_sport_in_anno_list(owner, sk))
+				if (!mptcp_pm_sport_in_anno_list(owner, sk)) {
+					SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MISMATCHPORTACKRX);
 					goto out;
+				}
+				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINPORTACKRX);
 			}
 		}
 	}
-- 
2.30.0

