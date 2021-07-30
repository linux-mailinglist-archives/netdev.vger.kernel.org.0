Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E304B3DB775
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 12:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhG3Kye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 06:54:34 -0400
Received: from mail-vi1eur05on2108.outbound.protection.outlook.com ([40.107.21.108]:32693
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238383AbhG3Kya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 06:54:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNvp61XbEc+mEd93wnxTi4oFTTlSO475slngOBaH5KAKEbC3CgU3fo+CscYnV5bqyjRnO+bhAtEyOaI8ntdl15tlBD5G9YA2D4+opBXazGqRH027dyfnyNzyKu4xLO+mGDUAnZWN8buqNFc0/m+twhg4ZY8s6kPJymGGgXiMKR7HMlxLULdzWT7/N+qnV7JvJmoUBCvAGX/kiH8lcuQV6idm7p4yIMORV8iN8nBPq0sV65TBSZCOSU1enuYJJmhiTBykBp5FT1gUg4uoSI7Pyyvwr2IqDLYYmMWZZKmOo18khMwDssADTSDcyVpUQF5Ho30ytQwjHyneaYWa9pF1eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTpOjemCEesseaiWSKgeTXEqbENhG4LCitDCqtpHPtk=;
 b=lZwqJ8J3q6lRP1iP1r2PBH4ws+IKqxevYgT5Ndj9dYPhyKdqhCzC7OqMRVSYwzpqAFCEnXu2kR5KPJMD1EkV0Ab59r9vxUKihuWEpjY987lJ2KCGsz/mTkhctXDYsqQobfMDyYvkrrGHftkVGYwCPQjSi9YmTi/tgFWNCYtYDRe6gF3M9X5pD7PRJQnb5L6DW/OdXuknJ0PBOATHavReVz+ZEwsr2vtvH+ECvFaQ/XEu0+NnHTIBMMdu8/EqVh1gCr8e5+nYV1mSmbXWCL6Qsy08hHOoM9DRmVP77OfIqpPlckxXgg6VaZSA38RGeUBRLy4XzUEJ5oni4LARWEhElw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTpOjemCEesseaiWSKgeTXEqbENhG4LCitDCqtpHPtk=;
 b=u7wBewbkPMTrXfwsDJeJl/sg8moU4E38GKGkDX+6SpdLW5Zi05P1EqRHrlyjfKxI0LBV9T/RsgJjvISo4OfEyNhK3uxq79/kxNCLGkAOplc/oaUBS2Cr2KLmIKNp5fc6JiW4dOyyWIDULCZjbi/gsDlPzjviBk4gpoXzBQCLfCk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VE1PR08MB5694.eurprd08.prod.outlook.com (2603:10a6:800:1a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 10:54:21 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 10:54:21 +0000
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH] sock: allow reading and changing sk_userlocks with setsockopt
Date:   Fri, 30 Jul 2021 13:54:06 +0300
Message-Id: <20210730105406.318726-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0017.eurprd09.prod.outlook.com
 (2603:10a6:101:16::29) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fedora.sw.ru (46.39.230.13) by PR2PR09CA0017.eurprd09.prod.outlook.com (2603:10a6:101:16::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Fri, 30 Jul 2021 10:54:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 043ce6f3-75bf-4d3f-2ab4-08d95348630d
X-MS-TrafficTypeDiagnostic: VE1PR08MB5694:
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB5694E767F683E5C91B616CDCB7EC9@VE1PR08MB5694.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yQHmbwpZCw8+GxdSBdeBghuxdzkYNiE/glFjRo2MnOtXvkanOZTlFDoNODf09utF8hOziCYYg6xCJERSjjhsa9DwhmijOMU1WRls9r0v9zOtGiJhc1A/boWDcV9S3cNig6pRbjAhG8/tSRrwVzSwnHhg+JyXmK7doweQMUq3wSeoKjggoSwX8Nc1dtZWr6+4c0T3htZmcT8A0wbbW6e3TQ5wqsdesIE5V+WmGT5ImztXNC07G6inqvDYVkJjTdPyNU/X+Bw+X3RLf8kad6W7VfklsYSPBOe9gVGCulvKAdlU3XG4mH3jnnixQrCyxbTNJYPOJuh9Yvq4WxAO4APTR9cx1gUXkaFtJVyTjJsi5mCRaXs4r4Qxp38qiSa8c5yqb5ImByn5cLaqJaQZhckMV96nQZfqSeHSKypwXVglZ032H8wt+e+n1v6f9PX2t9KzJmxUtubBmKjVodo4s2rOqcxtxiR7mZ5CliHE2vjZcYEcIC54Ih2+0KTVBlQi6onAS2sz3xGx+eKOPYdKrOXPvVXry0MPWxfxStJBaE6i48Xz5w/7blhloZ3XOI9+rqCHHxOcQCSaxQQpwCk/UUg26x4211b5lp97AWEkcBGffki60nHRF4voW1QAcQ9QeYI2sSAlV69A4arBJ2VBl7eTETH40BZQo2pTsuVmqr8nstQ7nYnabLgb6Nq0jxjnHha9OrVbH1+96XyNjOrk8R7yynRC0XnFjAaslJ5eRDSCrkRqgXxLVokC4mbpnBneA5ee4mjUnlfp6WXzYYLkZQAHLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39840400004)(376002)(136003)(346002)(366004)(966005)(2906002)(8936002)(83380400001)(478600001)(186003)(86362001)(38350700002)(5660300002)(6916009)(956004)(38100700002)(66476007)(66556008)(66946007)(6486002)(107886003)(6506007)(7416002)(26005)(54906003)(4326008)(2616005)(316002)(6512007)(8676002)(36756003)(6666004)(52116002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LemC+54JyMGw81PoMbs3kqxw+nk66+LSKsu869Dl0mIukn10jhBRR3IaxBJm?=
 =?us-ascii?Q?zbWvo8B0Y7aZ6/efu1qBLgKFuFcnyoe7+0SPAl9xf6Ft3id2/pvf++dTqCvj?=
 =?us-ascii?Q?sYA0nxBhDb7fBAa0Vsihsc4QLKAZ6bOCfgW7m2jlCopjf3UBpd4NDSwGRQjX?=
 =?us-ascii?Q?Kx/5RffJ0tEm2doQDwKmlPiF4FHvjOp5RtK1WsHvHrfJotUKHfuGCwq2quw8?=
 =?us-ascii?Q?8w4te2UES6HJcd6mcIA/UlyaIgzQHp6M43B3wYz63F9CDozdTdnp+uAwN9D0?=
 =?us-ascii?Q?wmY7uM28I6Hsd9M2x0Jo0uRoPeUVVw3cCcDjMmo/ifovvYlqGR4ipks9N8IE?=
 =?us-ascii?Q?s6Z/7xvlxQEnTn1cO+jJhDr1JIULd1P+glZ/sllIRZfgRcpR+VuwJMG7xma4?=
 =?us-ascii?Q?0NZVRWgVjYmUS1KkanuEdysfL5usGaeqp4zmzmzfK+2hWckiFV19M5YhozAc?=
 =?us-ascii?Q?0kYeTuJR79pkiFcdJKSOrX041DRYVLTDKG94TgCDaZ3bu1VVBQjKcWGU7Gnr?=
 =?us-ascii?Q?ZP7ZVCfTI+x+dWoe5eULVLBb36kTIeuFqzn0Xp51G9WtoEwt/FxteZflsEVM?=
 =?us-ascii?Q?CsOsECdUbkf6kWnOlzV+XskJsfkKNYOi9Bbi1PgZcj9k6E+2KmSwBxQc3fL/?=
 =?us-ascii?Q?ELgiwgvqqDrPSipjFb5/+dNSnqMFMdi8RE75JCsu+TtljhWZeVApBAjOPG65?=
 =?us-ascii?Q?p6BAAn1rCxGRhbA0gjo7NBiFaFqgsKKYI6UM+2K3k2vGQy4fkXPktxOl7QzP?=
 =?us-ascii?Q?NTY5zp7nKA5tczAD8KwKXTSx2myoueEcrCl6hsDFS2dhsZBVdbX+kVPEbF5T?=
 =?us-ascii?Q?S0I3wldsBiSVwzjXWYQANhpi2UMUGHSmAg/Ldvukt4u9aArL61AmfKoxEZAW?=
 =?us-ascii?Q?sFiBcpy93SpOzT31sTFXx2ABrcLk4K1zNVa536ULamY0myetDsd5vgoiE6X5?=
 =?us-ascii?Q?KW3XvDLNkLh5h3hs8nN6mT0uKS/kz6hIW9OKTMZpief5mzhinSIDoEO0Lcjw?=
 =?us-ascii?Q?64cG6kbfgluAAcy9MWCzmrgLM7Qfr5zWwApPWfLFJLJkoBWi8K8OUje8szfV?=
 =?us-ascii?Q?6GPLvIGjyUqthMtmM2418nmWMsth0gbSgh1ir7siAJlkk9i9f0qidZvsAChf?=
 =?us-ascii?Q?m0RjzIk4xOj1nyvQfKWm0oTI9PIpbh5u2irBkuo3gzpctqF8klArqvVUCrTR?=
 =?us-ascii?Q?9QtKOudL8djOZsmxgKLD/lqKXjlFOvvjYWZGmwBcTglykvTkxGkCfs8+WUDy?=
 =?us-ascii?Q?BSdooQPb8OZbZFAXN44DyIbelWyS12r2SdhPb6fuwpJl3VlmzHgaee1Cnz8S?=
 =?us-ascii?Q?1uz12Vboyd+fgO+AUmNNUWDM?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 043ce6f3-75bf-4d3f-2ab4-08d95348630d
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 10:54:21.6242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDEoMa+iCpnvIF9ZlHSN6Jegq2GycJ43MFVMPKBJywawmTPsKKrfsHJ080J+saAyRGVlsb1GtfwaOo9aDrqFF8XXyE69/EjD3OCnRoSmbtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5694
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
tcp_sndbuf_expand()). If we've just created a new socket this adjustment
is enabled on it, but if one changes the socket buffer size by
setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.

CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
restore as it first needs to increase buffer sizes for packet queues
restore and second it needs to restore back original buffer sizes. So
after CRIU restore all sockets become non-auto-adjustable, which can
decrease network performance of restored applications significantly.

CRIU need to be able to restore sockets with enabled/disabled adjustment
to the same state it was before dump, so let's add special setsockopt
for it.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
Here is a corresponding CRIU commits using these new feature to fix slow
download speed problem after migration:
https://github.com/checkpoint-restore/criu/pull/1568 

Origin of the problem:

We have a customer in Virtuozzo who mentioned that nginx server becomes
slower after container migration. Especially it is easy to mention when
you wget some big file via localhost from the same container which was
just migrated. 
 
By strace-ing all nginx processes I see that nginx worker process before
c/r sends data to local wget with big chunks ~1.5Mb, but after c/r it
only succeeds to send by small chunks ~64Kb.

Before: 
sendfile(12, 13, [7984974] => [9425600], 11479629) = 1440626 <0.000180> 
 
After: 
sendfile(8, 13, [1507275] => [1568768], 17957328) = 61493 <0.000675> 

Smaller buffer can explain the decrease in download speed. So as a POC I
just commented out all buffer setting manipulations and that helped.

---
 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/uapi/asm-generic/socket.h     |  2 ++
 net/core/sock.c                       | 12 ++++++++++++
 6 files changed, 22 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 6b3daba60987..1dd9baf4a6c2 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -129,6 +129,8 @@
 
 #define SO_NETNS_COOKIE		71
 
+#define SO_BUF_LOCK		72
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index cdf404a831b2..1eaf6a1ca561 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -140,6 +140,8 @@
 
 #define SO_NETNS_COOKIE		71
 
+#define SO_BUF_LOCK		72
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 5b5351cdcb33..8baaad52d799 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -121,6 +121,8 @@
 
 #define SO_NETNS_COOKIE		0x4045
 
+#define SO_BUF_LOCK		0x4046
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 92675dc380fa..e80ee8641ac3 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -122,6 +122,8 @@
 
 #define SO_NETNS_COOKIE          0x0050
 
+#define SO_BUF_LOCK              0x0051
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index d588c244ec2f..1f0a2b4864e4 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -124,6 +124,8 @@
 
 #define SO_NETNS_COOKIE		71
 
+#define SO_BUF_LOCK		72
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index a3eea6e0b30a..843094f069f3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1357,6 +1357,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		ret = sock_bindtoindex_locked(sk, val);
 		break;
 
+	case SO_BUF_LOCK:
+		{
+		int mask = SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK;
+
+		sk->sk_userlocks = (sk->sk_userlocks & ~mask) | (val & mask);
+		break;
+		}
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1719,6 +1727,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val64 = sock_net(sk)->net_cookie;
 		break;
 
+	case SO_BUF_LOCK:
+		v.val = sk->sk_userlocks & (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK);
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.31.1

