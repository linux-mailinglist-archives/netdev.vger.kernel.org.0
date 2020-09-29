Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AF027CFE2
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730676AbgI2Nuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730305AbgI2Nuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:50:40 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C15C061755;
        Tue, 29 Sep 2020 06:50:38 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so3947424pgl.2;
        Tue, 29 Sep 2020 06:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=MlXAP9DOdM5rboXZDAHZkt5aNPDNKAGxxdDFS71/fS4=;
        b=lDgzB7lNyI+d0xcdSiluNMrHmP4y2oKIV2MFbs7Ii4iYESscfh22b7yHwa10pjx8ni
         32lw5yGD1+kRryAi6ncuDprEd8XWj0Uuks8NRlXL+rrYzyHS9bYeVjjKbSn0QPY3sdGP
         JRSQPPC3QOfPQJ+RU1CISPY1ZCI3sneL4csq7g4OdC55vB15VXW55szme0jN1H2N53cf
         92biVcIUa9KK0r0jfoMrAuqREvVog/Zbejts/LpxyJmqrEMPJysX2H9cN5doS4aKxe0S
         QXaEuOIPhoSK3umO2J5tAXJHNZInQB8MWuR+jPpJLj15KxLOT6k/kU3hlQdRRCW7uXTd
         bZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=MlXAP9DOdM5rboXZDAHZkt5aNPDNKAGxxdDFS71/fS4=;
        b=k1MjdJnAgziUp1AJUX7xUUjYVr/r5aIbgBHUmXnt2c50pmk/E6HXQ4xloQGQ0rSZPD
         C78qV8EOPMl0/4sLoR7bQSAORRIpE295hfAVt1vvHv2O/TMY5fpY2g1vGVgBlt+LGDh2
         Qq/4KXxH+YB7rAGJIjYkzoIKaquL7dBKwtiKCE9cXh6ubcvTnZqieR1uUiuNGi/MJ9Lh
         qpavQSQp5iq8Snh5e2lFM7xYueVy1vYN3Im2T5Hv5JII70ME5mdH7I8YVyK+j1Mb99+p
         62s5DzRFLuAGZf+8WH80jt/7MwNRhoTagBz1vbKqHvhqNwCc3kH83PfowV+ZtljtUjDD
         wrcQ==
X-Gm-Message-State: AOAM533qtzOtsfc9yU41wDh+OMd7AS4ODwjXJ+zPTu3w0D8pFsGgSI6Z
        y/96tsdXbGvwidn1tjeu/8C7nJycdSA=
X-Google-Smtp-Source: ABdhPJyEI0Y3i0yTdvBz17yE7tgfwYfJkXiXi0xwK5FhDMdAIDCSIh+vVHFcb/BpGC4O34EZO43qSg==
X-Received: by 2002:a63:482:: with SMTP id 124mr3287061pge.430.1601387437507;
        Tue, 29 Sep 2020 06:50:37 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z7sm5931804pfj.75.2020.09.29.06.50.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:50:36 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 09/15] sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
Date:   Tue, 29 Sep 2020 21:49:01 +0800
Message-Id: <ff57fb1ff7c477ff038cebb36e9f0554d26d5915.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
 <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
 <49a1cbb99341f50304b514aeaace078d0b065248.1601387231.git.lucien.xin@gmail.com>
 <97963ca7171b92486f46477b55928182abe44806.1601387231.git.lucien.xin@gmail.com>
 <ddf990677d003f4d0be245b88f4b0f25d54f26d5.1601387231.git.lucien.xin@gmail.com>
 <ec4b75d8c69ba640a9104158ab875c4011cb533d.1601387231.git.lucien.xin@gmail.com>
 <f9f58a248df8194bbf6f4a83a05ec4e98d2955f1.1601387231.git.lucien.xin@gmail.com>
 <e1ff8bac558dd425b2f29044c3136bf680babcad.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to implement:

  rfc6951#section-6.1: Get or Set the Remote UDP Encapsulation Port Number

with the param of the struct:

  struct sctp_udpencaps {
    sctp_assoc_t sue_assoc_id;
    struct sockaddr_storage sue_address;
    uint16_t sue_port;
  };

the encap_port of sock, assoc or transport can be changed by users,
which also means it allows the different transports of the same asoc
to have different encap_port value.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |   7 +++
 net/sctp/socket.c         | 110 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 28ad40d..cb78e7a 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -140,6 +140,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_ECN_SUPPORTED	130
 #define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
 #define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
+#define SCTP_REMOTE_UDP_ENCAPS_PORT	132
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
@@ -1197,6 +1198,12 @@ struct sctp_event {
 	uint8_t se_on;
 };
 
+struct sctp_udpencaps {
+	sctp_assoc_t sue_assoc_id;
+	struct sockaddr_storage sue_address;
+	uint16_t sue_port;
+};
+
 /* SCTP Stream schedulers */
 enum sctp_sched_type {
 	SCTP_SS_FCFS,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 9aa0c3d..d793dfa9 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4417,6 +4417,53 @@ static int sctp_setsockopt_pf_expose(struct sock *sk,
 	return retval;
 }
 
+static int sctp_setsockopt_encap_port(struct sock *sk,
+				      struct sctp_udpencaps *encap,
+				      unsigned int optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+
+	if (optlen != sizeof(*encap))
+		return -EINVAL;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	if (!sctp_is_any(sk, (union sctp_addr *)&encap->sue_address)) {
+		t = sctp_addr_id2transport(sk, &encap->sue_address,
+					   encap->sue_assoc_id);
+		if (!t)
+			return -EINVAL;
+
+		t->encap_port = encap->sue_port;
+		return 0;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, encap->sue_assoc_id);
+	if (!asoc && encap->sue_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
+	/* If changes are for association, also apply encap to each
+	 * transport.
+	 */
+	if (asoc) {
+		list_for_each_entry(t, &asoc->peer.transport_addr_list,
+				    transports)
+			t->encap_port = encap->sue_port;
+
+		return 0;
+	}
+
+	sctp_sk(sk)->encap_port = encap->sue_port;
+	return 0;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4636,6 +4683,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_setsockopt_pf_expose(sk, kopt, optlen);
 		break;
+	case SCTP_REMOTE_UDP_ENCAPS_PORT:
+		retval = sctp_setsockopt_encap_port(sk, kopt, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7791,6 +7841,63 @@ static int sctp_getsockopt_pf_expose(struct sock *sk, int len,
 	return retval;
 }
 
+static int sctp_getsockopt_encap_port(struct sock *sk, int len,
+				      char __user *optval, int __user *optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_udpencaps encap;
+	struct sctp_transport *t;
+
+	if (len < sizeof(encap))
+		return -EINVAL;
+
+	len = sizeof(encap);
+	if (copy_from_user(&encap, optval, len))
+		return -EFAULT;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	if (!sctp_is_any(sk, (union sctp_addr *)&encap.sue_address)) {
+		t = sctp_addr_id2transport(sk, &encap.sue_address,
+					   encap.sue_assoc_id);
+		if (!t) {
+			pr_debug("%s: failed no transport\n", __func__);
+			return -EINVAL;
+		}
+
+		encap.sue_port = t->encap_port;
+		goto out;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, encap.sue_assoc_id);
+	if (!asoc && encap.sue_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		pr_debug("%s: failed no association\n", __func__);
+		return -EINVAL;
+	}
+
+	if (asoc) {
+		encap.sue_port = asoc->encap_port;
+		goto out;
+	}
+
+	encap.sue_port = sctp_sk(sk)->encap_port;
+
+out:
+	if (copy_to_user(optval, &encap, len))
+		return -EFAULT;
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int sctp_getsockopt(struct sock *sk, int level, int optname,
 			   char __user *optval, int __user *optlen)
 {
@@ -8011,6 +8118,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_EXPOSE_POTENTIALLY_FAILED_STATE:
 		retval = sctp_getsockopt_pf_expose(sk, len, optval, optlen);
 		break;
+	case SCTP_REMOTE_UDP_ENCAPS_PORT:
+		retval = sctp_getsockopt_encap_port(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.1.0

