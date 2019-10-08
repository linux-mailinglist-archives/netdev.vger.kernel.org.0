Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65C1CF815
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfJHLZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:25:56 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45610 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729876AbfJHLZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:25:56 -0400
Received: by mail-pl1-f194.google.com with SMTP id u12so8320569pls.12;
        Tue, 08 Oct 2019 04:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=zVQ3GWd6CEvtezxejMAg9YPBu8RORUmKekzHYCzxAco=;
        b=imDv4ZDFntKRNOb3zw4UZFmQejhYHcEZ4svnUMtU6mXDTxRTUdnkUlxvrZ6f+aQuPW
         lu2lRqjXwranlsmEvLU3qpKaLI9KWZPTcb6doLdiVO2uTF1SSXXS+H6mLUuLxm/OEYas
         Qp6ZnoGcvSruVP8fZNZG8l593rbk1Lhfo9Djk+iN2uBSloons9YHKMyHK5fWtvUoqERx
         JtbE2YyMtSos6prGAjX4vAilhq7CBZDjcZEqV+7/GUKWb89PrtuyPCgaSKJSAWPOUUwf
         ALi+rvJemMdYUNgQZmuPs8pXlBbE2VlKpciBkO5uANgaKf1hnJO5HTFpC/efOqs1MwhE
         3sfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=zVQ3GWd6CEvtezxejMAg9YPBu8RORUmKekzHYCzxAco=;
        b=gowhJi4N6qcKM53B3k/3WlPSc9w3Zk1SLTLMS2krIfd4YhbQ6KwPsLnJdnwl4sLBZp
         T2BaQuXFyLt0jGIu6FgtxUDijGTYAAqZq4I6Qed/zuyLhypnd5+0sQtrqPNKh+izzXP9
         J0lmvpn/0+a96u4Eml8U2/VHsCZob2jXVfyb6V59PeZecbb4xWVJkWuzICByAFbKQLTW
         EqCGDEVu6U+s+F1KKYHznMbjGCqjDCrKxPSXGFCetrWDupAzIoz9+0jqdYKVhcqXrLjw
         YOpb1rQQh0NUkzSeAK5VwpbIYlQ6p/cNWNgu2ksqmocfl9076LgTsrEfi1xBCIb9mt4K
         GCDw==
X-Gm-Message-State: APjAAAV2ky9NcySzExEpMkNJIO2GbCbf1lsprgjZp1LQ2aaW5vh/tKn1
        564V9n9f/D+/oW+2vFIcBpyoPxn4
X-Google-Smtp-Source: APXvYqzrfmrmfCCXtTK0aLca2O5dbeG4EZRPBn0g1Yazaw3Sc3XtjDOXrrcf+/HcXSFtfXFmhRMidA==
X-Received: by 2002:a17:902:7b84:: with SMTP id w4mr34777611pll.63.1570533954970;
        Tue, 08 Oct 2019 04:25:54 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j26sm1634456pgl.38.2019.10.08.04.25.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:25:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCHv2 net-next 5/5] sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt
Date:   Tue,  8 Oct 2019 19:25:07 +0800
Message-Id: <8edae913e18b328101bbadec7c7face62d630b6c.1570533716.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <045f7763d7b6bb2ccba3bfc78202b0a28131c6d6.1570533716.git.lucien.xin@gmail.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <bca4cbf1bee8ad2379b2fe9536b3404fc0935579.1570533716.git.lucien.xin@gmail.com>
 <8fcf707443f7218d3fb131b827c679f423c5ecaf.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <045f7763d7b6bb2ccba3bfc78202b0a28131c6d6.1570533716.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570533716.git.lucien.xin@gmail.com>
References: <cover.1570533716.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Section 7.2 of rfc7829: "Peer Address Thresholds (SCTP_PEER_ADDR_THLDS)
Socket Option" extends 'struct sctp_paddrthlds' with 'spt_pathcpthld'
added to allow a user to change ps_retrans per sock/asoc/transport, as
other 2 paddrthlds: pf_retrans, pathmaxrxt.

Note: to not break the user's program, here to support pf_retrans dump
and setting by adding a new sockopt SCTP_PEER_ADDR_THLDS_V2, and a new
structure sctp_paddrthlds_v2 instead of extending sctp_paddrthlds.

Also, when setting ps_retrans, the value is not allowed to be greater
than pf_retrans.

v1->v2:
  - use SCTP_PEER_ADDR_THLDS_V2 to set/get pf_retrans instead,
    as Marcelo and David Laight suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h | 10 +++++++++
 net/sctp/socket.c         | 54 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index a15cc28..7974257 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -105,6 +105,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_DEFAULT_SNDINFO	34
 #define SCTP_AUTH_DEACTIVATE_KEY	35
 #define SCTP_REUSE_PORT		36
+#define SCTP_PEER_ADDR_THLDS_V2	37
 
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
@@ -1071,6 +1072,15 @@ struct sctp_paddrthlds {
 	__u16 spt_pathpfthld;
 };
 
+/* Use a new structure with spt_pathcpthld for back compatibility */
+struct sctp_paddrthlds_v2 {
+	sctp_assoc_t spt_assoc_id;
+	struct sockaddr_storage spt_address;
+	__u16 spt_pathmaxrxt;
+	__u16 spt_pathpfthld;
+	__u16 spt_pathcpthld;
+};
+
 /*
  * Socket Option for Getting the Association/Stream-Specific PR-SCTP Status
  */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7dfb2c5..7cd9387 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3943,18 +3943,22 @@ static int sctp_setsockopt_auto_asconf(struct sock *sk, char __user *optval,
  */
 static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 					    char __user *optval,
-					    unsigned int optlen)
+					    unsigned int optlen, bool v2)
 {
-	struct sctp_paddrthlds val;
+	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
+	int len;
 
-	if (optlen < sizeof(struct sctp_paddrthlds))
+	len = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	if (optlen < len)
 		return -EINVAL;
-	if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval,
-			   sizeof(struct sctp_paddrthlds)))
+	if (copy_from_user(&val, optval, len))
 		return -EFAULT;
 
+	if (v2 && val.spt_pathpfthld > val.spt_pathcpthld)
+		return -EINVAL;
+
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
 		trans = sctp_addr_id2transport(sk, &val.spt_address,
 					       val.spt_assoc_id);
@@ -3963,6 +3967,8 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 
 		if (val.spt_pathmaxrxt)
 			trans->pathmaxrxt = val.spt_pathmaxrxt;
+		if (v2)
+			trans->ps_retrans = val.spt_pathcpthld;
 		trans->pf_retrans = val.spt_pathpfthld;
 
 		return 0;
@@ -3978,17 +3984,23 @@ static int sctp_setsockopt_paddr_thresholds(struct sock *sk,
 				    transports) {
 			if (val.spt_pathmaxrxt)
 				trans->pathmaxrxt = val.spt_pathmaxrxt;
+			if (v2)
+				trans->ps_retrans = val.spt_pathcpthld;
 			trans->pf_retrans = val.spt_pathpfthld;
 		}
 
 		if (val.spt_pathmaxrxt)
 			asoc->pathmaxrxt = val.spt_pathmaxrxt;
+		if (v2)
+			asoc->ps_retrans = val.spt_pathcpthld;
 		asoc->pf_retrans = val.spt_pathpfthld;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
 		if (val.spt_pathmaxrxt)
 			sp->pathmaxrxt = val.spt_pathmaxrxt;
+		if (v2)
+			sp->ps_retrans = val.spt_pathcpthld;
 		sp->pf_retrans = val.spt_pathpfthld;
 	}
 
@@ -4775,7 +4787,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_setsockopt_auto_asconf(sk, optval, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
-		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen);
+		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+							  false);
+		break;
+	case SCTP_PEER_ADDR_THLDS_V2:
+		retval = sctp_setsockopt_paddr_thresholds(sk, optval, optlen,
+							  true);
 		break;
 	case SCTP_RECVRCVINFO:
 		retval = sctp_setsockopt_recvrcvinfo(sk, optval, optlen);
@@ -7213,18 +7230,19 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
  * http://www.ietf.org/id/draft-nishida-tsvwg-sctp-failover-05.txt
  */
 static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
-					    char __user *optval,
-					    int len,
-					    int __user *optlen)
+					    char __user *optval, int len,
+					    int __user *optlen, bool v2)
 {
-	struct sctp_paddrthlds val;
+	struct sctp_paddrthlds_v2 val;
 	struct sctp_transport *trans;
 	struct sctp_association *asoc;
+	int min;
 
-	if (len < sizeof(struct sctp_paddrthlds))
+	min = v2 ? sizeof(val) : sizeof(struct sctp_paddrthlds);
+	if (len < min)
 		return -EINVAL;
-	len = sizeof(struct sctp_paddrthlds);
-	if (copy_from_user(&val, (struct sctp_paddrthlds __user *)optval, len))
+	len = min;
+	if (copy_from_user(&val, optval, len))
 		return -EFAULT;
 
 	if (!sctp_is_any(sk, (const union sctp_addr *)&val.spt_address)) {
@@ -7235,6 +7253,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
+		val.spt_pathcpthld = trans->ps_retrans;
 
 		goto out;
 	}
@@ -7247,11 +7266,13 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 	if (asoc) {
 		val.spt_pathpfthld = asoc->pf_retrans;
 		val.spt_pathmaxrxt = asoc->pathmaxrxt;
+		val.spt_pathcpthld = asoc->ps_retrans;
 	} else {
 		struct sctp_sock *sp = sctp_sk(sk);
 
 		val.spt_pathpfthld = sp->pf_retrans;
 		val.spt_pathmaxrxt = sp->pathmaxrxt;
+		val.spt_pathcpthld = sp->ps_retrans;
 	}
 
 out:
@@ -8131,7 +8152,12 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_auto_asconf(sk, len, optval, optlen);
 		break;
 	case SCTP_PEER_ADDR_THLDS:
-		retval = sctp_getsockopt_paddr_thresholds(sk, optval, len, optlen);
+		retval = sctp_getsockopt_paddr_thresholds(sk, optval, len,
+							  optlen, false);
+		break;
+	case SCTP_PEER_ADDR_THLDS_V2:
+		retval = sctp_getsockopt_paddr_thresholds(sk, optval, len,
+							  optlen, true);
 		break;
 	case SCTP_GET_ASSOC_STATS:
 		retval = sctp_getsockopt_assoc_stats(sk, len, optval, optlen);
-- 
2.1.0

