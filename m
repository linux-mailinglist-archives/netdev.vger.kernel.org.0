Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A9C3AE161
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 03:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFUBlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 21:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFUBlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 21:41:09 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6217EC06175F;
        Sun, 20 Jun 2021 18:38:55 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id x21so3106921qtq.9;
        Sun, 20 Jun 2021 18:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Obdj9ltH6wJ3mq4k9NVNNJBDzJeuUIf8SKZG5jI26bQ=;
        b=I3jGU1X9x+Z+TigcbrHXopsQvgkE+aK5CwPeoH4u3MxGFGK7F519fjFV4KOWUlVxnK
         zv5fm0BaB0RpTtawV0AzK1aKsw2r0OqjPlZEevJa3jZaZzMHxRnYA1REGZZdJAdyN/S9
         XY75J2hGwpMxB97H96gw8+HEDAIlx0YX48q8eLYUZ8PD/Z3jrXWHFfSwVPRQbZ1NhCRc
         KEv1QzjnAFewoqL4mbpTuH7jg/rOTKu4rA5WeUeEDaXZJjl5b0KReskGX7GeXbaBYgjP
         s8EOEfXtjNddjGDomkVd1bogyLavTaWRFOZ04kZGGwS9O9KRlyh0cAcdWsh1jn+tP8U6
         QPBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Obdj9ltH6wJ3mq4k9NVNNJBDzJeuUIf8SKZG5jI26bQ=;
        b=ljP/CMVKCNoT7sfPXFzyyDV3RMvWH+w5n/wHPOwnmvdVlj1GkEuW1DTvU6SjV6nB/X
         aX5Fz3NTwWsEzE8CtwoeXuOwqJDPXOWjMa+qpPyYGMCFLKrxjfjgUsxK7t0O8wNhgXYN
         S5DLCv1+03rddZzYqW/fS7KgNj6SE6Ivpy1AvUK3rjtxM1a3jrIa4j539obC9HOi/x21
         rO0fYUtl6uwBIrrIpy043nLH3yvXX6pyEbTC/djIxwS+5E6KkfinxohTr8gWD3lnp3fF
         At2O62TAY+q2HgHNCykUzFPRgssy+vZTdX149imDbbPqpq0sKiEUh1JHXQRhOet80qdr
         HEFQ==
X-Gm-Message-State: AOAM531UrawcD3+Z6fjWbo++GlXNhCOEgbm8gKrbittDfyZFAYWbzD67
        xZKVpCIg5RTGrDBF1dASzDlRlpfX6NuldA==
X-Google-Smtp-Source: ABdhPJyjbXSevFGaHiVZSCGnH9yyrx3T966bvwcJbD5DYx8Wv3+JvvjDpATb98uDbAqDMxJtosVzMQ==
X-Received: by 2002:ac8:44ca:: with SMTP id b10mr21667483qto.224.1624239534425;
        Sun, 20 Jun 2021 18:38:54 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id b8sm4454620qtr.77.2021.06.20.18.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 18:38:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCH net-next 03/14] sctp: add SCTP_PLPMTUD_PROBE_INTERVAL sockopt for sock/asoc/transport
Date:   Sun, 20 Jun 2021 21:38:38 -0400
Message-Id: <f7ad5ee7af232bae59786ca7522f4e238af0ec93.1624239422.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624239422.git.lucien.xin@gmail.com>
References: <cover.1624239422.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this socket option, users can change probe_interval for
a transport, asoc or sock after it's created.

Note that if the change is for an asoc, also apply the change
to each transport in this asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/uapi/linux/sctp.h |   8 +++
 net/sctp/socket.c         | 118 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)

diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index cb78e7a739da..c4ff1ebd8bcc 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -141,6 +141,7 @@ typedef __s32 sctp_assoc_t;
 #define SCTP_EXPOSE_POTENTIALLY_FAILED_STATE	131
 #define SCTP_EXPOSE_PF_STATE	SCTP_EXPOSE_POTENTIALLY_FAILED_STATE
 #define SCTP_REMOTE_UDP_ENCAPS_PORT	132
+#define SCTP_PLPMTUD_PROBE_INTERVAL	133
 
 /* PR-SCTP policies */
 #define SCTP_PR_SCTP_NONE	0x0000
@@ -1213,4 +1214,11 @@ enum sctp_sched_type {
 	SCTP_SS_MAX = SCTP_SS_RR
 };
 
+/* Probe Interval socket option */
+struct sctp_probeinterval {
+	sctp_assoc_t spi_assoc_id;
+	struct sockaddr_storage spi_address;
+	__u32 spi_interval;
+};
+
 #endif /* _UAPI_SCTP_H */
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index d2960ab665a5..aba576f53458 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -4481,6 +4481,58 @@ static int sctp_setsockopt_encap_port(struct sock *sk,
 	return 0;
 }
 
+static int sctp_setsockopt_probe_interval(struct sock *sk,
+					  struct sctp_probeinterval *params,
+					  unsigned int optlen)
+{
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	__u32 probe_interval;
+
+	if (optlen != sizeof(*params))
+		return -EINVAL;
+
+	probe_interval = params->spi_interval;
+	if (probe_interval && probe_interval < SCTP_PROBE_TIMER_MIN)
+		return -EINVAL;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	if (!sctp_is_any(sk, (union sctp_addr *)&params->spi_address)) {
+		t = sctp_addr_id2transport(sk, &params->spi_address,
+					   params->spi_assoc_id);
+		if (!t)
+			return -EINVAL;
+
+		t->probe_interval = msecs_to_jiffies(probe_interval);
+		return 0;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, params->spi_assoc_id);
+	if (!asoc && params->spi_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP))
+		return -EINVAL;
+
+	/* If changes are for association, also apply probe_interval to
+	 * each transport.
+	 */
+	if (asoc) {
+		list_for_each_entry(t, &asoc->peer.transport_addr_list, transports)
+			t->probe_interval = msecs_to_jiffies(probe_interval);
+
+		asoc->probe_interval = msecs_to_jiffies(probe_interval);
+		return 0;
+	}
+
+	sctp_sk(sk)->probe_interval = probe_interval;
+	return 0;
+}
+
 /* API 6.2 setsockopt(), getsockopt()
  *
  * Applications use setsockopt() and getsockopt() to set or retrieve
@@ -4703,6 +4755,9 @@ static int sctp_setsockopt(struct sock *sk, int level, int optname,
 	case SCTP_REMOTE_UDP_ENCAPS_PORT:
 		retval = sctp_setsockopt_encap_port(sk, kopt, optlen);
 		break;
+	case SCTP_PLPMTUD_PROBE_INTERVAL:
+		retval = sctp_setsockopt_probe_interval(sk, kopt, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
@@ -7906,6 +7961,66 @@ static int sctp_getsockopt_encap_port(struct sock *sk, int len,
 	return 0;
 }
 
+static int sctp_getsockopt_probe_interval(struct sock *sk, int len,
+					  char __user *optval,
+					  int __user *optlen)
+{
+	struct sctp_probeinterval params;
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	__u32 probe_interval;
+
+	if (len < sizeof(params))
+		return -EINVAL;
+
+	len = sizeof(params);
+	if (copy_from_user(&params, optval, len))
+		return -EFAULT;
+
+	/* If an address other than INADDR_ANY is specified, and
+	 * no transport is found, then the request is invalid.
+	 */
+	if (!sctp_is_any(sk, (union sctp_addr *)&params.spi_address)) {
+		t = sctp_addr_id2transport(sk, &params.spi_address,
+					   params.spi_assoc_id);
+		if (!t) {
+			pr_debug("%s: failed no transport\n", __func__);
+			return -EINVAL;
+		}
+
+		probe_interval = jiffies_to_msecs(t->probe_interval);
+		goto out;
+	}
+
+	/* Get association, if assoc_id != SCTP_FUTURE_ASSOC and the
+	 * socket is a one to many style socket, and an association
+	 * was not found, then the id was invalid.
+	 */
+	asoc = sctp_id2assoc(sk, params.spi_assoc_id);
+	if (!asoc && params.spi_assoc_id != SCTP_FUTURE_ASSOC &&
+	    sctp_style(sk, UDP)) {
+		pr_debug("%s: failed no association\n", __func__);
+		return -EINVAL;
+	}
+
+	if (asoc) {
+		probe_interval = jiffies_to_msecs(asoc->probe_interval);
+		goto out;
+	}
+
+	probe_interval = sctp_sk(sk)->probe_interval;
+
+out:
+	params.spi_interval = probe_interval;
+	if (copy_to_user(optval, &params, len))
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
@@ -8129,6 +8244,9 @@ static int sctp_getsockopt(struct sock *sk, int level, int optname,
 	case SCTP_REMOTE_UDP_ENCAPS_PORT:
 		retval = sctp_getsockopt_encap_port(sk, len, optval, optlen);
 		break;
+	case SCTP_PLPMTUD_PROBE_INTERVAL:
+		retval = sctp_getsockopt_probe_interval(sk, len, optval, optlen);
+		break;
 	default:
 		retval = -ENOPROTOOPT;
 		break;
-- 
2.27.0

