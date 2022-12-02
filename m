Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D5640C4E
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 18:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiLBRjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 12:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbiLBRjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 12:39:31 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02olkn2079.outbound.protection.outlook.com [40.92.49.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179CED827E;
        Fri,  2 Dec 2022 09:39:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImZJTIGBjAgHSH+eAnWReGW+lDoSCHqSUzrdRsdLa/eCy5KkVRf8rcDWypJqUoPZThEXGgIu6yLdF43FQ8dIH3vIMIqjhQLptApKF6W0m+IbMOt0VKobaY5p0c9LQxFpN3cj1XXhFNfKSqBpAoI/7Ks88qpfwVLiM65u4Fl5KOcJ0HlAQXaeQQUkeUO2FWJvvC+YqoEy+QU52ZdWZ7MM4FGjQGQMfr0OO1bqkQ5rwM2ZikHZq6IsH6IGVnKrmlBeOeLqiW6kh/EZ32nNA9JliUcnrRLYfQo+I/uw/gLysOa+2c43gctdJdVPnt7XKF8KdTQecN7ogQ4YoIMwCuX9Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gB3WI+kY2EdrfAsx3eK7GyxVFSRbYxd1mNrRaZIuIO4=;
 b=na5OITDPXj3GaRVr16am8hDj5tt6fUbEaLBTlsa1yWyCS1QkgxkTQgBzX/iGCj4MvD/CoabZqNYNeoVkMq5r9MMhBc7ss2J3UJyCGRCqMJrbtqYcqXu3IJMdThPIeqfwlg8LXuUXGfhtqQLEAWz9GoebClYokdiRsdEsWONlLWx+LUeDg5gQSA7fPMJxHDC1Gg4m2CuFZ7GR4SIuzWhA9RVMqsR0Oqlp4UDi5TXfjQP3ifCX8Yk5VslAEuC1F0IezPWKGOlMlDkST8oBLLDeura6auXQTUxbjrgsM+eDhH1n5nZDIlzt1aYkX33gn9Pfet5wWVf8Slx41244uycMPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB3WI+kY2EdrfAsx3eK7GyxVFSRbYxd1mNrRaZIuIO4=;
 b=OYrsRjc0Q7NXjQRHX310bKoF+iWgVbIWP5R391K25D2d0sz7r8Kt57s9Aa8twk7NabwJyKa9RZGXQ0N6y60r95yB5DcyDZtoBxDGbilpAkUDm0mmDUeNS+rx6h1I8UNYcllzojJZ1y1tdV4728LcWPCb8wtWoIoZECU3vn1eAdW0/B+36jijLfqHdcksArJoGpcpa7wkY7rYUtUS7gkMPPXqHBhWF2aJJ9jjAdgJEwjTojOAocg8lxUg3x27xqXUsiE8z/MUtjQNuhfw47jFgBwhS/3Jh9ztJOr4WEsMnaHT4RyXkfD9cBybAR2DS2Nk1bkSbsU51euPhgO63ue/GA==
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34b::15)
 by PR3P192MB0571.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 17:39:27 +0000
Received: from DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b]) by DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
 ([fe80::a67b:5da2:88f8:f28b%9]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 17:39:27 +0000
From:   Ji Rongfeng <SikoJobs@outlook.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Ji Rongfeng <SikoJobs@outlook.com>
Subject: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
Date:   Sat,  3 Dec 2022 01:39:10 +0800
Message-ID: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [DnY83tEvg6Pw9ly1i7loIYJ9eCexNFj/]
X-ClientProxiedBy: SG2PR06CA0190.apcprd06.prod.outlook.com (2603:1096:4:1::22)
 To DU0P192MB1547.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:34b::15)
X-Microsoft-Original-Message-ID: <20221202173910.11601-1-SikoJobs@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0P192MB1547:EE_|PR3P192MB0571:EE_
X-MS-Office365-Filtering-Correlation-Id: a11e5515-d7e6-4637-1bdb-08dad48c28d8
X-MS-Exchange-SLBlob-MailProps: 70qbaZjg4ms0xzfAGVOuKXynl8t5bcZkmjml5R49hQJeKseRJSf+ksbNRryIv/WNfr88IhuSzMaEf+Abh2HsSlfgxYwRjPRYRe2audmJyEuA7vFdmxZuKlWVBFn1ofBDvtqYphmYehbznu7g0Pko7A3WbtlK1zRc2Tm+cco+h5HP7GVp+TxdUP4RDOnGWEbBv7OgBZY9c6an8dAjbS3bouA3R/bi0+puU9c+x7hO7OEtJLpBUDx+pzJnfIlIfnQIBuLle3th3Z1jbTaRN0O9dgoMVmxAitIrBQD5PvQJJN0lQ/e0ASUjMjomgjr7wLsf4byyy/tNquBLs9yvPOmFxvkh4TsSofE6h0IVMOUwYeedHIl0bEBddLtmhu9KYyZqihOUEHM52JfVvKlz4dEuBdgeZkHmRn5w4DVnW7xyYNhdlvPVP/MecKO9Dfq0pmWuGOej+4gYzLU89mFv7Tv+zClwdyVjvVbJZNQ0ENwO0dj9JMp/GjilsE2+IHVwc1NpwUsA12Slny96krGNmSz8EvPIqD6B3OGTJRu0HAaTqupJpbDMpJM9ZF6XFJYVwHQ+LVI2Sr4JVpJrP5dpNd9NMJEy93nVQuwBNjrbQIM/A4neA+AIjrYRJvUd+h/x7Tl3oj0QyH67n2YbL+iawgEXBJGc6cliQZR9XEHwJRC19otGqZW06SOnfRzWYOcBB1hiQeESqlH/G1zGFPLU1hg3xmAsLxbR+QcF9ynFXQbzHh7wy4DoJ3vsIQ==
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZwinNcKySa5+I23QwAsaamHtCJ+Ln2j5rMIqJLTr0WV6fs0q+q7JjD0bqwy7Egz0oma3UokmP/RvZbAWHvyeLeG5bfPeEKulqKuXe0cDD4WDFkNELCCPTHNEaBy3C9WrnMaW3NlDO3OYh/Y8/ncKA+sehFtn83sC39WkXq6yq9PlzUn/6XBuqMseZXyReCdiLBzrCY/wbLwVQ0jEetHxvR0f4q6N4fDxjYi2ZjoiGGUn9EQBuXGxz1L5KgtE2ksy+miulHtnFOUp+SJM2js3tYQd1tsGB/wkuwWlZs8C8CA2tlP4Jfq9w2YU3H44aZJzVWKGhhsaTMkOfoEoECdmA/TmHzFvoyZTCcNuwuK4QT1vfw0dLrIz0Te9RjI5RKsmdqVUBzHgHjPXak/6iux3ISCIZQ77w7kF5LykWKWflJaUSEEDMSoQ4cIR4+R5S4ywd2Fyjp3Rdso8rit7kbo4egtQYH7KgVpi6dfw9LBjuYIoKNeO5eGthe5HuAn2kqVO1Twnl8sfZeUecgNxRB0B8qagDwZVG0L4zHE7nCn/NVO45Nw6A0MOzxf7Ots7BvQeI208jsR2HobG7cB6CnkJyMbC3azarHtgbHSm9BqSjMAEBMKjJBJtx8t08/ZiCMaSKtZoANQ0KR4rG53G5LJFSQ==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OxrWzM4jyEb/Jx3dKk1ZhttIKCk+gJuTkAPws84lIEd9IF2BgFOF9JD9H8RU?=
 =?us-ascii?Q?FhgnXUWZDjLlWyGLxxK64BKIJ/TVvXVAGQtTfDOVvMFbUhp0eUDbJeQ2n4KN?=
 =?us-ascii?Q?BQHe73iJpnmjuwlviSb6t1wUN0n1KRCGEn6AoRWw6RVXDEbIJpwSfO6D3Vy9?=
 =?us-ascii?Q?5rwyVT7+1AQAzMxwNYvjbbD19AK3WBNEOI+hpTs0p+8x2LQuEJlOeaeqGvRb?=
 =?us-ascii?Q?eMv4TkypL7EB42K6rHQe9FULCffD4dyOEYVsTQHZ1vgBqOcczAD1fAYFdSq4?=
 =?us-ascii?Q?fFZs6zix546L+1GcLa1N5hAqjq4RJ30g/uGNZ6oO+wItT74GKh+NRCXHh4Lu?=
 =?us-ascii?Q?MKTPj4DI534x6OewaLXT/H0g13bNzylFA/+zT23uJy7F1S5ohgcWP/ozhiSR?=
 =?us-ascii?Q?c3r8MzR84hpfXstGOmMK+7yYLq69OTfN8yqmvR2S+0D1vdgW0kFQXYjIRGPB?=
 =?us-ascii?Q?o8wESUB+UCQAHVW9HQMA69w9BRIvfvWJqPF821ZGLycVPyCEAw0JgRCZ0Yrw?=
 =?us-ascii?Q?AM2GtB+PJAJGdi2EjWtzGKvFmRPwCooealAJPS4FrLFslSP5yMuMTIFHwKVd?=
 =?us-ascii?Q?8jwGT8Cx7GimDWKcRxxiZ0ahFObXPYA/cBoaB7St8ALv1ICOpns6adFGiTg7?=
 =?us-ascii?Q?t12hp/UX/nd9iJiP3eyRM9rvdJlXRFCAGoeEYR8KX4OJOJBB2pHvm9XCQ2TI?=
 =?us-ascii?Q?zWtuR4NMZJxF2FK9NTr2pEG7ioXw0BR7L8+zVJm7JfKgW4ep6UOPeO0EqC/2?=
 =?us-ascii?Q?Xp/JN1FYIheQzrJiHvrS9FoUd0CK40klkwGfHpsyU/7EC+RKRul363tBFsGi?=
 =?us-ascii?Q?B1RWvyP3ZkyRt0at4HxQYpVEd+6/cIwnDnIgX0mXlu+kuCxhvN9biGWyQwHV?=
 =?us-ascii?Q?HUD15jcehTzupne95jXxWTVDQ4feyT/QeTCv54OzaxwyaiZ3scUcugE5vZRq?=
 =?us-ascii?Q?c8/nvDICjnWRsKEBJzHKWj6yNNAsGu2WG1lLLT6u7xj2ZH8UiYmqjHpX3faa?=
 =?us-ascii?Q?YNQPaT6xjwI0Iz+JoJD6n4c+PYiw+rKSR8IHrbTRV+LMVk8IZaNBvXPCJGKp?=
 =?us-ascii?Q?OKW5zMZP9B+jhRAvE6u1uNbLLjXxGRYKkQiObwFLdZn8RfWDqrOlWqYmUArB?=
 =?us-ascii?Q?M6ow+G3Fe8oTc16Yd6cPHP966Tfg8oLImOXSiGh7jly/+OX49N7OHHhyJkZu?=
 =?us-ascii?Q?BbnHCkeFgqUqXjhiwBp4ADEKHfvylkawZ7SUQ4p4sihlEy1dKv6NqVfxX3pW?=
 =?us-ascii?Q?+qLLeBgUm2erDgPJu9qCSUJdW6q0c70zrXjrYCJdJg=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11e5515-d7e6-4637-1bdb-08dad48c28d8
X-MS-Exchange-CrossTenant-AuthSource: DU0P192MB1547.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 17:39:27.5718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P192MB0571
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Returning -EINVAL almost all the time when error occurs is not very
helpful for the bpf prog to figure out what is wrong. This patch
upgrades some return values so that they will be much more helpful.

* return -ENOPROTOOPT when optname is unsupported

  The same as {g,s}etsockopt() syscall does. Before this patch,
  bpf_setsockopt(TCP_SAVED_SYN) already returns -ENOPROTOOPT, which
  may confuse the user, as -EINVAL is returned on other unsupported
  optnames. This patch also rejects TCP_SAVED_SYN right in
  sol_tcp_sockopt() when getopt is false, since do_tcp_setsockopt()
  is just the executor and it's not its duty to discover such error
  in bpf. We should maintain a precise allowlist to control whether
  an optname is supported and allowed to enter the executor or not.
  Functions like do_tcp_setsockopt(), their behaviour are not fully
  controllable by bpf. Imagine we let an optname pass, expecting
  -ENOPROTOOPT will be returned, but someday that optname is
  actually processed and unfortunately causes deadlock when calling
  from bpf. Thus, precise access control is essential.

* return -EOPNOTSUPP on level-related errors

  In do_ip_getsockopt(), -EOPNOTSUPP will be returned if level !=
  SOL_IP. In ipv6_getsockopt(), -ENOPROTOOPT will be returned if
  level != SOL_IPV6. To be distinguishable, the former is chosen.

* return -EBADFD when sk is not a full socket

  -EPERM or -EBUSY was an option, but in many cases one of them
  will be returned, especially under level SOL_TCP. -EBADFD is the
  better choice, since it is hardly returned in all cases. The bpf
  prog will be able to recognize it and decide what to do next.

Signed-off-by: Ji Rongfeng <SikoJobs@outlook.com>

From my point of view, changing these return values is acceptable,
because most of them are designed to be shown to the bpf prog
developer only and rarely shown in production environment.

I'll send another patch to update documentation in a proper way
after this patch is accepted, and add some tests if necessary.
---
 net/core/filter.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 37baaa6b8fc3..44440b7d430c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5050,12 +5050,12 @@ static int sol_socket_sockopt(struct sock *sk, int optname,
 	case SO_BINDTODEVICE:
 		break;
 	default:
-		return -EINVAL;
+		return -ENOPROTOOPT;
 	}
 
 	if (getopt) {
 		if (optname == SO_BINDTODEVICE)
-			return -EINVAL;
+			return -ENOPROTOOPT;
 		return sk_getsockopt(sk, SOL_SOCKET, optname,
 				     KERNEL_SOCKPTR(optval),
 				     KERNEL_SOCKPTR(optlen));
@@ -5105,7 +5105,7 @@ static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
 		inet_csk(sk)->icsk_rto_min = timeout;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOPROTOOPT;
 	}
 
 	return 0;
@@ -5169,7 +5169,7 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 			   bool getopt)
 {
 	if (sk->sk_prot->setsockopt != tcp_setsockopt)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	switch (optname) {
 	case TCP_NODELAY:
@@ -5194,7 +5194,7 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 		break;
 	default:
 		if (getopt)
-			return -EINVAL;
+			return -ENOPROTOOPT;
 		return bpf_sol_tcp_setsockopt(sk, optname, optval, *optlen);
 	}
 
@@ -5215,6 +5215,9 @@ static int sol_tcp_sockopt(struct sock *sk, int optname,
 		return do_tcp_getsockopt(sk, SOL_TCP, optname,
 					 KERNEL_SOCKPTR(optval),
 					 KERNEL_SOCKPTR(optlen));
+	} else {
+		if (optname == TCP_SAVED_SYN)
+			return -ENOPROTOOPT;
 	}
 
 	return do_tcp_setsockopt(sk, SOL_TCP, optname,
@@ -5226,7 +5229,7 @@ static int sol_ip_sockopt(struct sock *sk, int optname,
 			  bool getopt)
 {
 	if (sk->sk_family != AF_INET)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	switch (optname) {
 	case IP_TOS:
@@ -5234,7 +5237,7 @@ static int sol_ip_sockopt(struct sock *sk, int optname,
 			return -EINVAL;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOPROTOOPT;
 	}
 
 	if (getopt)
@@ -5251,7 +5254,7 @@ static int sol_ipv6_sockopt(struct sock *sk, int optname,
 			    bool getopt)
 {
 	if (sk->sk_family != AF_INET6)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	switch (optname) {
 	case IPV6_TCLASS:
@@ -5260,7 +5263,7 @@ static int sol_ipv6_sockopt(struct sock *sk, int optname,
 			return -EINVAL;
 		break;
 	default:
-		return -EINVAL;
+		return -ENOPROTOOPT;
 	}
 
 	if (getopt)
@@ -5276,7 +5279,7 @@ static int __bpf_setsockopt(struct sock *sk, int level, int optname,
 			    char *optval, int optlen)
 {
 	if (!sk_fullsock(sk))
-		return -EINVAL;
+		return -EBADFD;
 
 	if (level == SOL_SOCKET)
 		return sol_socket_sockopt(sk, optname, optval, &optlen, false);
@@ -5287,7 +5290,7 @@ static int __bpf_setsockopt(struct sock *sk, int level, int optname,
 	else if (IS_ENABLED(CONFIG_INET) && level == SOL_TCP)
 		return sol_tcp_sockopt(sk, optname, optval, &optlen, false);
 
-	return -EINVAL;
+	return -EOPNOTSUPP;
 }
 
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
@@ -5304,7 +5307,7 @@ static int __bpf_getsockopt(struct sock *sk, int level, int optname,
 	int err, saved_optlen = optlen;
 
 	if (!sk_fullsock(sk)) {
-		err = -EINVAL;
+		err = -EBADFD;
 		goto done;
 	}
 
@@ -5317,7 +5320,7 @@ static int __bpf_getsockopt(struct sock *sk, int level, int optname,
 	else if (IS_ENABLED(CONFIG_IPV6) && level == SOL_IPV6)
 		err = sol_ipv6_sockopt(sk, optname, optval, &optlen, true);
 	else
-		err = -EINVAL;
+		err = -EOPNOTSUPP;
 
 done:
 	if (err)
-- 
2.30.2

