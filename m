Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8931B3F6B2D
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 23:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbhHXVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 17:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhHXVg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 17:36:26 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855F4C0612A4;
        Tue, 24 Aug 2021 14:35:40 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id x11so47312413ejv.0;
        Tue, 24 Aug 2021 14:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mtZSbw8HLITma1TU3JWQnbsxubjtqK24FcLaQAPzwRs=;
        b=ZdrSNVVHF3uTYO38fDMTP53g2Y7aOkllymRPI0qy6M8aXAmxZjCYrq4pNqRIG8f5cp
         3vMIaFThiVxjahvM9Gp+SngoIUjdaJJk9Ih3dz0VE8m729XLsaGmbpKmcdZThDg4+ytp
         Aks7maD69H65CYB9D7g/Fs9/6s9JhPntehP4R72PKSbN9KTdyv4+leamJ2sbAEuOnvTm
         vJBdxLvZUL3XysTJLPvuCij1l3yG3cDNGLYyGdjfzdtpfN8s5kj6mqDyfCMu/jfoVPt5
         tIkzz93DNVjxoy1ZmOSzaL8dvZK0wrcarHKOo1ytBCQABWaWJnw4hDbZY9uGVn3PNPs2
         uCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mtZSbw8HLITma1TU3JWQnbsxubjtqK24FcLaQAPzwRs=;
        b=gNQKPgj7GqD+wQEq50gtKx99qt2sgGLxIpNzOrkL3n9DIfomKNWzDnll0SqM63dG9K
         nhWk6m2Fr1YY8ZzKUoC21hMrdnWhW22n4Sr6BuvPNLm5CSSuNeBQEqp3TPgb2kdFS4vp
         xJfo8Ib/B6sDh/19a661iCKkvmFrGZK4e3/58kpBogEVdgYw9Q99SJu/2ieIF9fmfriQ
         u2KqJLsB4/aWNhTu5MeQ5kOAYXMFt356H0XwxAiPvatEh7In4sGOklIsZwYvpZa4z85H
         UxRr56lYYFm7rWRkzB3OQ5haoaitJY830yXIOg0Sx5IELMzOI92ahSwUjlZzPXqHyJwv
         Wgbg==
X-Gm-Message-State: AOAM5325HYNO7aiboCJKNP5BXSTfdvxgWL0PRjC9B1ozW+9jepNuyeeN
        xQqeN0Jte4KzQSevYcK237k=
X-Google-Smtp-Source: ABdhPJwS9pUz2dqkn6uYWVXxT1CkSObiFDV6M7mI0mucqQUvAonZw6gcWhidi+IgkGZAM3NyFJmNhw==
X-Received: by 2002:a17:906:1385:: with SMTP id f5mr28493098ejc.134.1629840939179;
        Tue, 24 Aug 2021 14:35:39 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:1d80:ed0a:7326:fbac:b4c])
        by smtp.gmail.com with ESMTPSA id d16sm12348357edu.8.2021.08.24.14.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 14:35:38 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFCv3 08/15] tcp: authopt: Add snmp counters
Date:   Wed, 25 Aug 2021 00:34:41 +0300
Message-Id: <46371eff47ae9917c76f2719d984ba2cd23f9a00.1629840814.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1629840814.git.cdleonard@gmail.com>
References: <cover.1629840814.git.cdleonard@gmail.com>
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
index af777244d098..08ca77f01c46 100644
--- a/net/ipv4/tcp_authopt.c
+++ b/net/ipv4/tcp_authopt.c
@@ -1071,10 +1071,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 
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
@@ -1082,10 +1083,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
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
 			return 0;
@@ -1099,10 +1101,11 @@ int __tcp_authopt_inbound_check(struct sock *sk, struct sk_buff *skb, struct tcp
 	err = __tcp_authopt_calc_mac(sk, skb, key, true, macbuf);
 	if (err)
 		return err;
 
 	if (memcmp(macbuf, opt->mac, key->maclen)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAUTHOPTFAILURE);
 		net_info_ratelimited("TCP Authentication Failed\n");
 		return -EINVAL;
 	}
 
 	return 0;
-- 
2.25.1

