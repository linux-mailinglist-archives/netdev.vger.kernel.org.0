Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CC43E4E96
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhHIVgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbhHIVgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:36:20 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769E2C0613D3;
        Mon,  9 Aug 2021 14:35:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id k9so9526436edr.10;
        Mon, 09 Aug 2021 14:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B+LRcXpuFnJyK6gBZgDwQcVUjsT+Nceuc8wbNu08CP0=;
        b=gkxJN15wohSLkl4Va5+/AYBe29ZvKOdSlEFyxZERCUkvpyk7SL8zKdg6GC3FXfx0Jg
         Gry/YjLgNI543U23dVlYLx003jonsl7vy6Ja4JjPBDeglmZE+bbbl4Cu3yqmps1z3bBy
         513YHoS0qUE5CXkfonwCdkWn3qvhLHW8H/z8LLASbK3T7C8yjwiUf5q/2Td0WSkDhZcR
         JqinluwaPd40srFZ6zuB38aUInGfv8pP6rY4chTKHB8mhKEaG8HyBBFWYl9t1tsy8yAN
         ll/1h2edrRgVxVUw7QYKyGRUUiY7p/Nc1f2PS/h3rg5hlm3SSU7nGtHTzanPBXs0MiGN
         wfuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B+LRcXpuFnJyK6gBZgDwQcVUjsT+Nceuc8wbNu08CP0=;
        b=B6GEZ8/cT8LvALii71ax4t1VG2Qd3Gr7V45PkFu0Qxvn8VIhuigqfUTi4RLAnuG7Ob
         jZjxtUTnN6zs5gaQfYmldObPJC4nadFXsDF9CbrXZUNukkLM+dpxW6xNP8K0ePbXxUvd
         1rYvSffn7SOXiY6LMKHXnBX4JMHAGx/S9okX2ajxJHPWaCqXsu9kippKJlYDF4VoSMaT
         dcQEQYNUy95MSEA017UAALE+9/35hdbn2/lGrQNXeLnSwkq/03iQMY32eVkf76GuX40p
         YZoOO0Pgi17m8BVDbZL949KsaCUirvHZmrzUvks1oR2MsuzyeqEHEhehR+9QXSG8gm/q
         E3GQ==
X-Gm-Message-State: AOAM533thcXrrV39tblE30ghkF+4ZURSmhsoPAjD2Y227Qf8rg6R136G
        zfhY8Rk+Mki0gYkLZb+MCgI=
X-Google-Smtp-Source: ABdhPJw2EB1BIggJlJ2IUXocNiyu4x1CM8qSyj0Mi20D5xlK+gwfi4tPlfHlqsfo9fZBtQM/6FajxA==
X-Received: by 2002:aa7:c3cf:: with SMTP id l15mr435786edr.83.1628544958062;
        Mon, 09 Aug 2021 14:35:58 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:688d:23e:82c6:84aa])
        by smtp.gmail.com with ESMTPSA id v24sm5542932edt.41.2021.08.09.14.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:35:57 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFCv2 7/9] tcp: authopt: Add snmp counters
Date:   Tue, 10 Aug 2021 00:35:36 +0300
Message-Id: <ea45c947a8c1ecd59afe82c9c06008e221380c93.1628544649.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1628544649.git.cdleonard@gmail.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LINUX_MIB_TCPAUTHOPTFAILURE and increment on failure. This can be
use by userspace to count the number of failed authentications.

All types of authentication failures are reported under a single
counter.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp_authopt.c    | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index 904909d020e2..1d96030889a1 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -290,10 +290,11 @@ enum
 	LINUX_MIB_TCPDUPLICATEDATAREHASH,	/* TCPDuplicateDataRehash */
 	LINUX_MIB_TCPDSACKRECVSEGS,		/* TCPDSACKRecvSegs */
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
+	LINUX_MIB_TCPAUTHOPTFAILURE,		/* TCPAuthOptFailure */
 	__LINUX_MIB_MAX
 };
 
 /* linux Xfrm mib definitions */
 enum
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index b0d3a09dc84e..61dd06f8389c 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -295,10 +295,11 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TcpDuplicateDataRehash", LINUX_MIB_TCPDUPLICATEDATAREHASH),
 	SNMP_MIB_ITEM("TCPDSACKRecvSegs", LINUX_MIB_TCPDSACKRECVSEGS),
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
+	SNMP_MIB_ITEM("TCPAuthOptFailure", LINUX_MIB_TCPAUTHOPTFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
 static void icmpmsg_put_line(struct seq_file *seq, unsigned long *vals,
 			     unsigned short *type, int count)
diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
index 40412d9ea04e..bee8873423e4 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1043,10 +1043,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 
 	/* nothing found or expected */
 	if (!opt && !key)
 		return 0;
 	if (!opt && key) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		net_info_ratelimited("TCP Authentication Missing\n");
 		return -EINVAL;
 	}
 	if (opt && !key) {
 		/* RFC5925 Section 7.3:
@@ -1054,10 +1055,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 		 * of segments with TCP-AO but that do not match an MKT. The initial
 		 * default of this configuration SHOULD be to silently accept such
 		 * connections.
 		 */
 		if (info->flags & TCP_AUTHOPT_FLAG_REJECT_UNEXPECTED) {
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 			net_info_ratelimited("TCP Authentication Unexpected: Rejected\n");
 			return -EINVAL;
 		} else {
 			net_info_ratelimited("TCP Authentication Unexpected: Accepted\n");
 			goto accept;
@@ -1071,10 +1073,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 	err = __tcp_authopt_calc_mac(sk, skb, key, true, macbuf);
 	if (err)
 		return err;
 
 	if (memcmp(macbuf, opt->mac, key->maclen)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		net_info_ratelimited("TCP Authentication Failed\n");
 		return -EINVAL;
 	}
 
 accept:
-- 
2.25.1

