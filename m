Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACB0D5B23
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 08:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730004AbfJNGPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 02:15:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38919 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729992AbfJNGPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 02:15:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id p12so123044pgn.6;
        Sun, 13 Oct 2019 23:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=SCegqBu7obP4C1vjXUQ/JwtpNhLhgLmaqkRllXH+g2g=;
        b=pFAO7Y88cx+p1YGzFqlD3kntFfK83ZFBnqD9n7x28N5VyC6iWxHeJdSe15cfCMQavD
         bRiv6FrGC+WZd8ulwzPIzj/FFaNIKOZrvY6NfZ0HjVVUPhfHyTq4f4YFeS8TVk9acBIq
         20Eb7e4SiGvGJCx0ZSGh2hRBk5Ow3JOsyD9Y68Zcrk/xYnd7zGvKGLaAnIZiloxQRFjJ
         04r2P7C93Y95rhsB9vLMOBk8xKcPg2b4lrhCuAm1tSHgZ4jU4apw0QBgjC3b0YELPvjL
         mkI3kHizLVVsHtICp8dCEFVILIKpnX4VgO9YuX85VpZ+lMh7eIs4quMB81E6eOV/389W
         WnRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=SCegqBu7obP4C1vjXUQ/JwtpNhLhgLmaqkRllXH+g2g=;
        b=YW8eHVoOrg7b27jEAysJjW3XnNHSq4tTzhoaU0v2suoES+FXkrxxlCM2JnZJjU+dtZ
         xF/icG7g67mFnU4i+3ChK3fslDarJuXE8jZdo1E2wichc6VapI0TQSOxMMNpduqdO2cG
         vchGTeV1Ushud00cewMTwDQQD0aXSfXtFjkJp+/NQ3ditrKLy0Q5aGw9CqpZ0mrELPwX
         aVtAsyieh9hXGlfzY79vJ1+J2dRl07fc50O9Dj+bjJHGJUU5eERReM29iMW5z8awQLBV
         FrMkGdFBq/S0lpKWsiz9EjD8oZaws07HQwnPBo7rUr0rmE72z7trS37cypdqD7QzVlFi
         90ZQ==
X-Gm-Message-State: APjAAAXRwFAlMZS3CMBo+1H2v7OsgxjpFbPZrbRVs6KWE00qKrm38T3W
        Qv6BqcMU/Uo3ubipID6y0YK1scBz
X-Google-Smtp-Source: APXvYqwixdMLac6Y2mXmOJxReEZ9eHx/3CoqDD5e7ETvzfZTo4CLn5NZE3asm412WRHo8Isf8ET2LQ==
X-Received: by 2002:a17:90a:246c:: with SMTP id h99mr32893290pje.127.1571033739574;
        Sun, 13 Oct 2019 23:15:39 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e17sm17035659pfl.40.2019.10.13.23.15.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Oct 2019 23:15:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        David Laight <david.laight@aculab.com>
Subject: [PATCHv3 net-next 5/5] sctp: add SCTP_PEER_ADDR_THLDS_V2 sockopt
Date:   Mon, 14 Oct 2019 14:14:48 +0800
Message-Id: <a84343c091cefe579a71b344aecab6f18b27c37d.1571033544.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <06d05b274999621fef3e7a006444ac76dadb7725.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
 <7d08b42f4c1480caa855776d92331fe9beed001d.1571033544.git.lucien.xin@gmail.com>
 <f4c99c3d918c0d82f5d5c60abd6abcf381292f1f.1571033544.git.lucien.xin@gmail.com>
 <eedcaeabec9253902de381b75ffc00c007fcd2b6.1571033544.git.lucien.xin@gmail.com>
 <06d05b274999621fef3e7a006444ac76dadb7725.1571033544.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1571033544.git.lucien.xin@gmail.com>
References: <cover.1571033544.git.lucien.xin@gmail.com>
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
v2->v3:
  - no change.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h | 10 +++++++++
 net/sctp/socket.c         | 54 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index a190e4a..28ad40d 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -105,6 +105,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_DEFAULT_SNDINFO	34
 #define SCTP_AUTH_DEACTIVATE_KEY	35
 #define SCTP_REUSE_PORT		36
+#define SCTP_PEER_ADDR_THLDS_V2	37
 
 /* Internal Socket Options. Some of the sctp library functions are
  * implemented using these socket options.
@@ -1087,6 +1088,15 @@ struct sctp_paddrthlds {
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
index 38d102b..3d2bad2 100644
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
 
@@ -4778,7 +4790,12 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
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
@@ -7217,18 +7234,19 @@ static int sctp_getsockopt_assoc_ids(struct sock *sk, int len,
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
@@ -7239,6 +7257,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
 
 		val.spt_pathmaxrxt = trans->pathmaxrxt;
 		val.spt_pathpfthld = trans->pf_retrans;
+		val.spt_pathcpthld = trans->ps_retrans;
 
 		goto out;
 	}
@@ -7251,11 +7270,13 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
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
@@ -8135,7 +8156,12 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
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

