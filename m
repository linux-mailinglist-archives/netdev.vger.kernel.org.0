Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3313649336
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 09:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLKIpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 03:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKIpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 03:45:05 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A17DDFC3;
        Sun, 11 Dec 2022 00:45:04 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BB6jRGV015337;
        Sun, 11 Dec 2022 08:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=0t+5Zv1W3aD2R4Ebr6eP+axBbcGNw5ggeuo2oOxENVQ=;
 b=XK7EgWOF8PbJeAmgqImL+L59pExqClaFDc7RDw9OGGM+YVU9WM8T7Yt1YRLYZmEOn6yK
 1+f7OD/0mcxS5lBI6DPXrQX8GmixcHhKZthYd7+PGfn1c7TLmMhx34xl2mdl5s7SXvwz
 78xIK/038IrO7xGuBoQ7zFx7KkrcaYSE8m8tLoOVwHbX2NpYVg+KFWwQq6OYWV5Gtro2
 DmmHY+71zjB/Dq27HaL1eicdhIVVowxl6Rrr8NalQVWxvKvC1nCsFTV+KJi37sLTApwK
 +A17+UK6DVnn+CkLuzo/dbcT1koxoPJqSsK+KakdD6a36/mYCs5Ax3PRCM6kAW7hsjPU qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3shxtan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Dec 2022 08:44:41 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BB8ieFN017015;
        Sun, 11 Dec 2022 08:44:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3md3shxta7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Dec 2022 08:44:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BB12xAb007894;
        Sun, 11 Dec 2022 08:44:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mchcf187x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 11 Dec 2022 08:44:38 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BB8iacc44368144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Dec 2022 08:44:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E882220049;
        Sun, 11 Dec 2022 08:44:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2CBB20040;
        Sun, 11 Dec 2022 08:44:35 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Sun, 11 Dec 2022 08:44:35 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Breno Leitao <leitao@debian.org>
Cc:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, kuniyu@amazon.com, netdev@vger.kernel.org,
        leit@fb.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] tcp: socket-specific version of WARN_ON_ONCE()
References: <20221208154656.60623-1-leitao@debian.org>
Date:   Sun, 11 Dec 2022 09:44:35 +0100
In-Reply-To: <20221208154656.60623-1-leitao@debian.org> (Breno Leitao's
        message of "Thu, 8 Dec 2022 07:46:56 -0800")
Message-ID: <yt9dlenes51o.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BZgq7nMdeAAqcHY__5dyZycxX7JwhY4U
X-Proofpoint-ORIG-GUID: tc4yxaiE8-F7n2e8ayWK0usAiBEj7MZJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-10_10,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 clxscore=1011 phishscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=834 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212110079
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Breno Leitao <leitao@debian.org> writes:

> There are cases where we need relevant information about the socket
> during a warning, so, it could help us to find bugs that happens and do
> not have an easy repro.
>
> This patch creates a TCP-socket specific version of WARN_ON_ONCE(), which
> dumps revelant information about the TCP socket when it hits rare
> warnings, which is super useful for debugging purposes.
>
> Hooking this warning tcp_snd_cwnd_set() for now, but, the intent is to
> convert more TCP warnings to this helper later.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/net/tcp.h       |  3 ++-
>  include/net/tcp_debug.h | 10 ++++++++++
>  net/ipv4/tcp.c          | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 1 deletion(-)
>  create mode 100644 include/net/tcp_debug.h
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 14d45661a84d..e490af8e6fdc 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -40,6 +40,7 @@
>  #include <net/inet_ecn.h>
>  #include <net/dst.h>
>  #include <net/mptcp.h>
> +#include <net/tcp_debug.h>
>  
>  #include <linux/seq_file.h>
>  #include <linux/memcontrol.h>
> @@ -1229,7 +1230,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
>  
>  static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
>  {
> -	WARN_ON_ONCE((int)val <= 0);
> +	TCP_SOCK_WARN_ON_ONCE(tp, (int)val <= 0);
>  	tp->snd_cwnd = val;
>  }
>  
> diff --git a/include/net/tcp_debug.h b/include/net/tcp_debug.h
> new file mode 100644
> index 000000000000..50e96d87d335
> --- /dev/null
> +++ b/include/net/tcp_debug.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_TCP_DEBUG_H
> +#define _LINUX_TCP_DEBUG_H
> +
> +void tcp_sock_warn(const struct tcp_sock *tp);
> +
> +#define TCP_SOCK_WARN_ON_ONCE(tcp_sock, condition) \
> +		DO_ONCE_LITE_IF(condition, tcp_sock_warn, tcp_sock)
> +
> +#endif  /* _LINUX_TCP_DEBUG_H */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 54836a6b81d6..5985ba9c4231 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4705,6 +4705,36 @@ int tcp_abort(struct sock *sk, int err)
>  }
>  EXPORT_SYMBOL_GPL(tcp_abort);
>  
> +void tcp_sock_warn(const struct tcp_sock *tp)
> +{
> +	const struct sock *sk = (const struct sock *)tp;
> +	struct inet_sock *inet = inet_sk(sk);
> +	struct inet_connection_sock *icsk = inet_csk(sk);
> +
> +	WARN_ON(1);

Never looked into the details of WARN_ON, but shouldn't that come at the
end of the function? If one has kernel.panic_on_warn=1, the kernel
would already panic in WARN_ON, and the lines below wouldn't be printed?

> +
> +	pr_warn("Socket Info: family=%u state=%d ccname=%s cwnd=%u",
> +		sk->sk_family, sk->sk_state, icsk->icsk_ca_ops->name,
> +		tcp_snd_cwnd(tp));
> +
> +	switch (sk->sk_family) {
> +	case AF_INET:
> +		pr_warn("saddr=%pI4:%u daddr=%pI4:%u", &inet->inet_saddr,
> +			ntohs(inet->inet_sport), &inet->inet_daddr,
> +			ntohs(inet->inet_dport));
> +
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		pr_warn("saddr=[%pI6]:%u daddr=[%pI6]:%u", &sk->sk_v6_rcv_saddr,
> +			ntohs(inet->inet_sport), &sk->sk_v6_daddr,
> +			ntohs(inet->inet_dport));
> +		break;
> +#endif
> +	}
> +}
> +EXPORT_SYMBOL_GPL(tcp_sock_warn);
> +
>  extern struct tcp_congestion_ops tcp_reno;
>  
>  static __initdata unsigned long thash_entries;
