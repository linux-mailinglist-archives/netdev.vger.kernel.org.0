Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2616B925D0
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfHSODd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:03:33 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38950 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfHSODd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:03:33 -0400
Received: by mail-pl1-f193.google.com with SMTP id z3so1022744pln.6;
        Mon, 19 Aug 2019 07:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=OjEJEENg/P3M/Cft3nyKqPbtotn/dVOoN3cFpY/LwK0=;
        b=uzJ8mgmXwTOM1BVmtD9jOhCkX6G5WaPnTe7bYuwEdOvTUi5Mqz+HbgSLPm/DRtP9Kp
         iiBADKl4/o3Jf8AfvF3H2cvPXAWMOH9GOHG31zXU6X6cC+sLDUqnDZxj0N919tcf+rL8
         xN8lpv2YqXQiIHytoOQbWwtI5iestPpRY0+3sqUBJZYxyNGzYEjn5dGxVTK1LI/cUeO4
         EHMjgWZouYRGSsCbv8zDK+5rAa8PDAIPcSFfgx5dwKMGJsTAl8xqBDewp4FZvwhqrpmK
         OCJMeOONNNe181hLu3zm9Kk3xgHlWPfso46G3l5nrwUJ1Lc0fuSVIzTYaUi6IES7dESP
         Ll8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=OjEJEENg/P3M/Cft3nyKqPbtotn/dVOoN3cFpY/LwK0=;
        b=VzXPwqKzQ8QX21biNOLQG13mY45qNIkG7jyiphbnDmDv+tpqrbSS18Nrf2qNH+72GT
         x0Bc+zkQkrAoiXIEpSRsEKVKOtlF2IW+cMG1ykfmgiFlzCFEkSCwasFr9b7hx+HClXAL
         NY482jqd5Dze6N00nZsuuD3uwCmkWTnAmWxjLDcCj/XAFwfmkpu0cPRJCbShdoJz5Lse
         DKLpM9kY0VGIsbO0IisiOYEg2A8D7qX5HgTDu1d8wZ+kK9/AsGpZ61BaK3M17jD1XqgY
         mRmS6ckzyw0waGXirTgKy+Juh/DCpImqTlbxaczOE4gxg1j7f1x1Yh6uH623szePRflE
         rzcg==
X-Gm-Message-State: APjAAAUmX3ltypL7bnvEgQs0OHwdmdmn5wZ0SOElsZKbd4Ks5uEm5uaf
        U942t99HOWUAEf1YfUB3Ffu3EOmE7Oo=
X-Google-Smtp-Source: APXvYqyMeIURecMJxWGl9WctRqO7xVr8uf47XDDKvfC8zO4AGzyuRsu9MZ5g3k4S/YD4Bfj9Ou9elg==
X-Received: by 2002:a17:902:2bc8:: with SMTP id l66mr23037803plb.222.1566223412267;
        Mon, 19 Aug 2019 07:03:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t9sm13376861pji.18.2019.08.19.07.03.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:03:31 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 4/8] sctp: add SCTP_ASCONF_SUPPORTED sockopt
Date:   Mon, 19 Aug 2019 22:02:46 +0800
Message-Id: <f4fbfa28a7fd2ed85f0fc66ddcbd4249e6e7b487.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
 <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SCTP_ASCONF_SUPPORTED sockopt is used to set enpoint's asconf
flag. With this feature, each endpoint will have its own flag
for its future asoc's asconf_capable, instead of netns asconf
flag.

Note that when both ep's asconf_enable and auth_enable are
enabled, SCTP_CID_ASCONF and SCTP_CID_ASCONF_ACK should be
added into auth_chunk_list.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |  1 +
 net/sctp/socket.c         | 82 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index b8f2c4d..9b9b82d 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -134,6 +134,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_INTERLEAVING_SUPPORTED	125
 #define SCTP_SENDMSG_CONNECT	126
 #define SCTP_EVENT	127
+#define SCTP_ASCONF_SUPPORTED	128
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 559793f..b21a707 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4496,6 +4496,42 @@ static int sctp_setsockopt_event(struct sock *sk, char __user *optval,
 	return retval;
 }
 
+static int sctp_setsockopt_asconf_supported(struct sock *sk,
+					    char __user *optval,
+					    unsigned int optlen)
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
+	ep->asconf_enable = !!params.assoc_value;
+
+	if (ep->asconf_enable && ep->auth_enable) {
+		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF);
+		sctp_auth_ep_add_chunkid(ep, SCTP_CID_ASCONF_ACK);
+	}
+
+	retval = 0;
+
+out:
+	return retval;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4696,6 +4732,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EVENT:
 		retval = sctp_setsockopt_event(sk, optval, optlen);
 		break;
+	case SCTP_ASCONF_SUPPORTED:
+		retval = sctp_setsockopt_asconf_supported(sk, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7675,6 +7714,45 @@ static int sctp_getsockopt_event(struct sock *sk, int len, char __user *optval,
 	return 0;
 }
 
+static int sctp_getsockopt_asconf_supported(struct sock *sk, int len,
+					    char __user *optval,
+					    int __user *optlen)
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
+	params.assoc_value = asoc ? asoc->peer.asconf_capable
+				  : sctp_sk(sk)->ep->asconf_enable;
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
@@ -7876,6 +7954,10 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EVENT:
 		retval = sctp_getsockopt_event(sk, len, optval, optlen);
 		break;
+	case SCTP_ASCONF_SUPPORTED:
+		retval = sctp_getsockopt_asconf_supported(sk, len, optval,
+							  optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

