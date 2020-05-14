Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CFA1D41D8
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 01:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgENXrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 19:47:39 -0400
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:42874 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgENXrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 19:47:39 -0400
X-Greylist: delayed 28454 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2020 19:47:38 EDT
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.42/8.16.0.42) with SMTP id 04EFr7Bx026770;
        Thu, 14 May 2020 08:53:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=20180706; bh=ByxiTWojcP8nO60TJThHSdKvQvLtCDC8OM6llgTD9BU=;
 b=oNYlbAPT2w5utI0aMCv03ihCKSHiRKXICa+ELl1uLHLBRiFL+aACNIlTUQbHtB81GMDw
 6kSReKucLYXDmLbWnyZwe0jiwvvcTvjlangyuluh4aTSnj3xCYTHbh909OIdtjSCfVoE
 BzSvb5owLivsS0QWCvlXUOxHEImail5Tc7X6rmx+xiny7NoebT3gUUwAWksR8Umss8nR
 G4bUt38JhCWc0kxzugh13xjLHmnnADxB6T+d9/6v+OYkGtkG9MOXyKfNZppVcgeJMuoZ
 6d5YtCQKMtRadmFF2Yb54zbOACAS8vl4MFo70dkuk/iZk2zpU9Z2jFfn69MXFHxC3Doi Mg== 
Received: from rn-mailsvcp-mta-lapp04.rno.apple.com (rn-mailsvcp-mta-lapp04.rno.apple.com [10.225.203.152])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 3100y2vkym-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Thu, 14 May 2020 08:53:19 -0700
Received: from rn-mailsvcp-mmp-lapp02.rno.apple.com
 (rn-mailsvcp-mmp-lapp02.rno.apple.com [17.179.253.15])
 by rn-mailsvcp-mta-lapp04.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0QAB004UNW4Q0I40@rn-mailsvcp-mta-lapp04.rno.apple.com>;
 Thu, 14 May 2020 08:53:15 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp02.rno.apple.com by
 rn-mailsvcp-mmp-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0QAB00900W39LB00@rn-mailsvcp-mmp-lapp02.rno.apple.com>; Thu,
 14 May 2020 08:53:14 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 8c2cfa5ef70d2018b184af5f7ee0603d
X-Va-E-CD: 1cff3c864f1a206c49923c84ea8132f2
X-Va-R-CD: 196ed5cdc7db62fe5ce70f7e1b5084b8
X-Va-CD: 0
X-Va-ID: ed64e9fd-96ee-4a94-8255-3c08d79f880d
X-V-A:  
X-V-T-CD: 8c2cfa5ef70d2018b184af5f7ee0603d
X-V-E-CD: 1cff3c864f1a206c49923c84ea8132f2
X-V-R-CD: 196ed5cdc7db62fe5ce70f7e1b5084b8
X-V-CD: 0
X-V-ID: b3091b68-8be5-45b6-803e-700050c9ae0f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
Received: from localhost ([17.234.94.63])
 by rn-mailsvcp-mmp-lapp02.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0QAB007AIW4Q8U30@rn-mailsvcp-mmp-lapp02.rno.apple.com>; Thu,
 14 May 2020 08:53:14 -0700 (PDT)
From:   Christoph Paasch <cpaasch@apple.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next] mptcp: Use 32-bit DATA_ACK when possible
Date:   Thu, 14 May 2020 08:53:03 -0700
Message-id: <20200514155303.14360-1-cpaasch@apple.com>
X-Mailer: git-send-email 2.23.0
MIME-version: 1.0
Content-transfer-encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_05:2020-05-14,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RFC8684 allows to send 32-bit DATA_ACKs as long as the peer is not
sending 64-bit data-sequence numbers. The 64-bit DSN is only there for
extreme scenarios when a very high throughput subflow is combined with a
long-RTT subflow such that the high-throughput subflow wraps around the
32-bit sequence number space within an RTT of the high-RTT subflow.

It is thus a rare scenario and we should try to use the 32-bit DATA_ACK
instead as long as possible. It allows to reduce the TCP-option overhead
by 4 bytes, thus makes space for an additional SACK-block. It also makes
tcpdumps much easier to read when the DSN and DATA_ACK are both either
32 or 64-bit.

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
---
 include/net/mptcp.h  |  5 ++++-
 net/mptcp/options.c  | 33 ++++++++++++++++++++++++---------
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  |  2 ++
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index e60275659de6..339eb36cf508 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -16,7 +16,10 @@ struct seq_file;
 
 /* MPTCP sk_buff extension data */
 struct mptcp_ext {
-	u64		data_ack;
+	union {
+		u64	data_ack;
+		u32	data_ack32;
+	};
 	u64		data_seq;
 	u32		subflow_seq;
 	u16		data_len;
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 45497af23906..ece6f92cf7d1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -516,7 +516,16 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		return ret;
 	}
 
-	ack_size = TCPOLEN_MPTCP_DSS_ACK64;
+	if (subflow->use_64bit_ack) {
+		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
+		opts->ext_copy.data_ack = msk->ack_seq;
+		opts->ext_copy.ack64 = 1;
+	} else {
+		ack_size = TCPOLEN_MPTCP_DSS_ACK32;
+		opts->ext_copy.data_ack32 = (uint32_t)(msk->ack_seq);
+		opts->ext_copy.ack64 = 0;
+	}
+	opts->ext_copy.use_ack = 1;
 
 	/* Add kind/length/subtype/flag overhead if mapping is not populated */
 	if (dss_size == 0)
@@ -524,10 +533,6 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 
 	dss_size += ack_size;
 
-	opts->ext_copy.data_ack = msk->ack_seq;
-	opts->ext_copy.ack64 = 1;
-	opts->ext_copy.use_ack = 1;
-
 	*size = ALIGN(dss_size, 4);
 	return true;
 }
@@ -986,8 +991,13 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		u8 flags = 0;
 
 		if (mpext->use_ack) {
-			len += TCPOLEN_MPTCP_DSS_ACK64;
-			flags = MPTCP_DSS_HAS_ACK | MPTCP_DSS_ACK64;
+			flags = MPTCP_DSS_HAS_ACK;
+			if (mpext->ack64) {
+				len += TCPOLEN_MPTCP_DSS_ACK64;
+				flags |= MPTCP_DSS_ACK64;
+			} else {
+				len += TCPOLEN_MPTCP_DSS_ACK32;
+			}
 		}
 
 		if (mpext->use_map) {
@@ -1004,8 +1014,13 @@ void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts)
 		*ptr++ = mptcp_option(MPTCPOPT_DSS, len, 0, flags);
 
 		if (mpext->use_ack) {
-			put_unaligned_be64(mpext->data_ack, ptr);
-			ptr += 2;
+			if (mpext->ack64) {
+				put_unaligned_be64(mpext->data_ack, ptr);
+				ptr += 2;
+			} else {
+				put_unaligned_be32(mpext->data_ack32, ptr);
+				ptr += 1;
+			}
 		}
 
 		if (mpext->use_map) {
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index e4ca6320ce76..f5adca93e8fb 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -290,6 +290,7 @@ struct mptcp_subflow_context {
 		data_avail : 1,
 		rx_eof : 1,
 		data_fin_tx_enable : 1,
+		use_64bit_ack : 1, /* Set when we received a 64-bit DSN */
 		can_ack : 1;	    /* only after processing the remote a key */
 	u64	data_fin_tx_seq;
 	u32	remote_nonce;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 009d5c478062..f22dad482cd4 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -661,9 +661,11 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 	if (!mpext->dsn64) {
 		map_seq = expand_seq(subflow->map_seq, subflow->map_data_len,
 				     mpext->data_seq);
+		subflow->use_64bit_ack = 0;
 		pr_debug("expanded seq=%llu", subflow->map_seq);
 	} else {
 		map_seq = mpext->data_seq;
+		subflow->use_64bit_ack = 1;
 	}
 
 	if (subflow->map_valid) {
-- 
2.23.0

