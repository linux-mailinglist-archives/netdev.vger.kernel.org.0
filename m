Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5244925D6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfHSOD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:03:58 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37750 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfHSOD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:03:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id 129so1233537pfa.4;
        Mon, 19 Aug 2019 07:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=bRT+aGzu1dS+aveh1Q0GC6Xy4sPSE+m73pDCsptsOe4=;
        b=cXUZMs1/dLKB7pwvfHfJf/6bVQ6L/YzBkedWs6Xk1QGzsHjGOy5Te2n4Ht1Oig/82n
         or8cAq3B2lnfeVqRPVSL0Zjfq+jpd+0Uc7xFYb6kHFGiaXYDWfA1kLOCKETO+q38tP3E
         pTnil//fmvIxkbNzgEIwCm4hHMINGRcnAt19Ki58BgccHtqfHYv/K0UyqBpIgrSLpdAF
         O49nz7EbtKmibztlKAFT90mTXDgq2nGeruqFdLkAtFBdvCxC8br8gYoo998RRcz5s4MA
         QcOt9khoqNKGu+2fmFSAo5P5wbKHSKEtASYcNpnid1tjXJ6QigPJ4rH0tg9LBQWJ8J59
         YXyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=bRT+aGzu1dS+aveh1Q0GC6Xy4sPSE+m73pDCsptsOe4=;
        b=KxgbgfpJ3cKNUW8ldTnyLHU6tSHGMhuh8ARXrSxBiQvdY52fRRjsfHfSuDzYPsVAe2
         OYyYDlba/2dfiPHW3Y2JlccgMpM6dLV3pKEGQczPwVedLagynlxiyjJ+oMVHU57reayX
         lE5gM8/gKBivDHt6JvMtvoXnvKQPznBqwGMAI/BzcP7ebvnbAaXF89WJs4c+4xnz7VSg
         x9sgspUjhTs/S2q8V0McPQFm1ZMiv+sh3iIDu+e0nC7BYriN47C4FX0B0+KOPDaANAhT
         Pxqly7PY2Tw0Z6hK6umT+T+i6xKM6LBTRJyhh7cTtzzHR5vPtQPXAn6Fm+vNTMdExumY
         zmEg==
X-Gm-Message-State: APjAAAVQ3e6XZM7fdRCOlzTg9mGOxuEANGzeAT0kR4qtCMfaN0G/Xsh3
        g72uLFL9DJabI2Ka5xNmhjXSIPvNSTs=
X-Google-Smtp-Source: APXvYqzVjIxvdqkbfUuuvGuq9ID+D1h6wf1rIKoUhlfIPq+qvudRTp5Gb4ORwYf2GddEqbyMjVPqVg==
X-Received: by 2002:a65:68cd:: with SMTP id k13mr19960173pgt.411.1566223437315;
        Mon, 19 Aug 2019 07:03:57 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 16sm31085742pfc.66.2019.08.19.07.03.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:03:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 7/8] sctp: add SCTP_AUTH_SUPPORTED sockopt
Date:   Mon, 19 Aug 2019 22:02:49 +0800
Message-Id: <b45828d4f886e9d1e92a8b68c1932af9ff80b562.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a2e37d8eb5b502e747eca1951e21c3d249bacf06.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
 <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
 <db032735abcb20ea14637fa610b9f95fa2710abb.1566223325.git.lucien.xin@gmail.com>
 <a2e37d8eb5b502e747eca1951e21c3d249bacf06.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP_AUTH_SUPPORTED sockopt is used to set enpoint's auth
flag. With this feature, each endpoint will have its own
flag for its future asoc's auth_capable, instead of netns
auth flag.

Note that when both ep's auth_enable is enabled, endpoint
auth related data should be initialized. If asconf_enable
is also set, SCTP_CID_ASCONF/SCTP_CID_ASCONF_ACK should
be added into auth_chunk_list.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 86 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 9b9b82d..62527ac 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -135,6 +135,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_SENDMSG_CONNECT	126
 #define SCTP_EVENT	127
 #define SCTP_ASCONF_SUPPORTED	128
+#define SCTP_AUTH_SUPPORTED	129
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index dcde8d9..82bc252 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4520,6 +4520,46 @@ static int sctp_setsockopt_asconf_supported(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_auth_supported(struct sock *sk,
+					  char __user *optval,
+					  unsigned int optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	struct sctp_endpoint *ep;
+	int retval = -EINVAL;
+
+	if (optlen != sizeof(params))
+		goto out;
+
+	if (copy_from_user(&params, optval, optlen)) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		goto out;
+
+	ep = sctp_sk(sk)->ep;
+	if (params.assoc_value) {
+		retval = sctp_auth_init(ep, GFP_KERNEL);
+		if (retval)
+			goto out;
+		if (ep->asconf_enable) {
+			sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
+			sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
+		}
+	}
+
+	ep->auth_enable = !!params.assoc_value;
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4723,6 +4763,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_ASCONF_SUPPORTED:
 		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
 		break;
+	case SCTP_AUTH_SUPPORTED:
+		retval = sctp_setsockopt_auth_supported(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7746,6 +7789,45 @@ static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_auth_supported(struct sock *sk, int len,
+					  char __user *optval,
+					  int __user *optlen)
+{
+	struct sctp_assoc_value params;
+	struct sctp_association *asoc;
+	int retval = -EFAULT;
+
+	if (len < sizeof(params)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	len = sizeof(params);
+	if (copy_from_user(&params, optval, len))
+		goto out;
+
+	asoc = sctp_id2assoc(sk, params.assoc_id);
+	if (!asoc && params.assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	params.assoc_value = asoc ? asoc->peer.auth_capable
+				  : sctp_sk(sk)->ep->auth_enable;
+
+	if (put_user(len, optlen))
+		goto out;
+
+	if (copy_to_user(optval, &params, len))
+		goto out;
+
+	retval = 0;
+
+out:
+	return retval;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -7951,6 +8033,10 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 		retval = sctp_getsockopt_asconf_supported(sk, len, optval,
 							  optlen);
 		break;
+	case SCTP_AUTH_SUPPORTED:
+		retval = sctp_getsockopt_auth_supported(sk, len, optval,
+							optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

