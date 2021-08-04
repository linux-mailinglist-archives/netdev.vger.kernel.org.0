Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907B83DFC5B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236069AbhHDH4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:56:32 -0400
Received: from mail-eopbgr80118.outbound.protection.outlook.com ([40.107.8.118]:27110
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236034AbhHDH4a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:56:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWrg2nEBLpmSyYdR5Jiy6zNBR3fWAm2KPdCkI4ryR0cneHhdQ3HxuiZmP2fz+8C9mcOnJ4EvyhaC1FqSlFiimfoV9sGG8QuLysMGeBzAhTQ0kFI44LjKBeCeV4GdL8YHUaeNHPgscmvZrajJrOiD1OhrP/u3EztcnrIzc4UrfLx3k1PMZtHwmiNXcoAmxfj7eLdKlkClIdJFFeiEe8peUPyY/REpBSPPaegfhPY3rxmavuFwp7NgnEOvoYF9dIt53YdoihYqKuuF2//ZvVA+JH4Sp3s/1OX9MKfA99x+qnErW53jbRkju3BLYPUOY5+dF5vU10n5VGIs9SYqdkZNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xo2gd+rzZF+/e9hXZb8afjS3RTViQX8wxnWQo/jaS0=;
 b=fgRosXAfZnCgAq5IQOtuUzdpUtzLetceoIL6g/JrSfVSgRp5WlkPkSZ7a8rfW8AX5BPmwmu/YxXGxMaL7cUo1mdEe1Pv62U9makR5T0jCA2kQtFB8b2M4xzzCLdiRvMwlcpCqZ3YO1env6z1ojxA2uvzHW8upjJpoQkrHLoBcyeDh59Cmn+QVQx0axLmQfp24U484jslKHVN9hFLMEd7ukFq1wUd6zMzDoz1sGf++833deJH34M8CnUz3hFVtRwfMWzCO+yuqV/2eYKSa7irkkOkeWc73NrruV05Mg8b6Wj624aGx71ICkGujA1U/uY5XJjf8sCeNtP4xdYrRA63Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xo2gd+rzZF+/e9hXZb8afjS3RTViQX8wxnWQo/jaS0=;
 b=FFw9+baAbmqDgRxh9smmjlBqvdaeZ280HDDKiiZdQ4sty/GQPOQSda6s/OYzNlq/l5BW9+UemY/TcW68nyeg2y19zW9OQjg+aqyuTzy1WXhLQ2++lou9RgEj5JV8aMwBAemN5xR/A35dJG4MIuIiVURhPf9C6Wqqq78qhKzdpd4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VE1PR08MB5823.eurprd08.prod.outlook.com (2603:10a6:800:1a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.24; Wed, 4 Aug
 2021 07:56:13 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4394.016; Wed, 4 Aug 2021
 07:56:12 +0000
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
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, kernel@openvz.org
Subject: [PATCH v3] sock: allow reading and changing sk_userlocks with setsockopt
Date:   Wed,  4 Aug 2021 10:55:56 +0300
Message-Id: <20210804075556.2582-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0081.eurprd03.prod.outlook.com
 (2603:10a6:208:69::22) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fedora.sw.ru (46.39.230.13) by AM0PR03CA0081.eurprd03.prod.outlook.com (2603:10a6:208:69::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Wed, 4 Aug 2021 07:56:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d41f7e6-9521-4f1d-fd90-08d9571d5428
X-MS-TrafficTypeDiagnostic: VE1PR08MB5823:
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB58238B29E88E26B4D446E564B7F19@VE1PR08MB5823.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuYWarbyTEQb/epBiTmrWev4MjhJR/12KgX2F2sY8ArcZMXsr4kqycia5Mk2MznA6ztsk8bhgct/tiJO+IIsAoz3fTMKmhxdDOUXcPiGlj/LL2tm2XHYlUZmmVniHDBEGzqz27m4s1vX2zOeU/77wAmctt17AEBV3wJoQi9MYV/MNyoRHtEJ9+RcytgYiTzSU98aZ5SostqwnaNt0IpX1r4oSJ1ECtIOdMMDTSpODl4T+9CR1PYb6eaLC7mXCqhuJe/7Rt1RLvd67zSvgAiWJO/3bSanwdUO8bpIvcxHyBQfSnX0MN3rmrsI/uDfTFQfvyvwfzgX85zzRiZg+I3Uih+DL+e/yC5RH9uCvvyUzB7oHUYdXwjrZuSug0D1DIDuxnohyD/eIsJYdXRxCkWy51yYoNJNpFlBoOq5TI1mUhLktNx5ApjdlXPh2iZ+WJy1XdlH3TqvH9D8V0WxGofbJMvI8P0fpeQ4M80Nc94aZcH/RT8P5RPlQrKYA6BkN+GmBTq5eGkSv4BMwYlGIiiTVvNCMydg8xUA/0FmuKWTBvwsIc6aHZrnNsmn5W7DrgKqrpHbIOwiGSPrhuII+DKhAKataZi/nmeEJtlQGKV654MdrNJSPThGberee7xEMdIuz9MNMpenXFCTBorJ8IPmmVjuCOVjQEC5G85bUVEQZWJxn7KBPFoY5fUgirkywibzImkSuxrOdofpiLnJk3Ax5JCn2vwwTrPo4vIRqp9gUu/p0VGH13nE/agcosIenUqvkbGCUI9dtHZQfa+PPygMXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39830400003)(396003)(136003)(346002)(478600001)(966005)(54906003)(2616005)(956004)(52116002)(86362001)(66946007)(66476007)(66556008)(316002)(7416002)(6916009)(2906002)(83380400001)(6506007)(8936002)(186003)(8676002)(36756003)(6666004)(26005)(4326008)(6512007)(6486002)(38100700002)(38350700002)(107886003)(5660300002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NnqU5tVW8AzJ81hf7uKlcZiDrMNyKoTV6nkwoapvctfHmjIpaR0xIt4pY45v?=
 =?us-ascii?Q?qk47uFA7bh/hCXg+Z+9NgKOlAfSo0oKVHylmWTrWJL4ODP8kIPMsQX40FKFW?=
 =?us-ascii?Q?1VryjznKaHIdfdvB+2vRHQDpAfaBISe/B36xa2InJ+bW4wHpC/cIdgdIoYDM?=
 =?us-ascii?Q?+vnaDTmV352mdiS/LGHEpqDbp0vENfhZG4yCK5PPVOz81nurRAygHaHZLHKt?=
 =?us-ascii?Q?5C0lJ2KhbcLGrMtjI0c+sBJ8ZHhjiZMZvxT/bq+eoJeBvo1zRLy96i5fU6fS?=
 =?us-ascii?Q?UIY4ZsRZHbzhYM2Y6HENs5+PYo6qo5xVTwBwHykDGDVaKNv49mfnl7wmkyFt?=
 =?us-ascii?Q?ZaZ2hlhmKHfZ5o5nHeoPn+GMGjulP8IjrmJ0mzoPr8SVAfSSh/mOd5BWpoY5?=
 =?us-ascii?Q?IFPh7eKTINDV836gfIEB8POCctTMpzSkY22fPeuavUPHLhliG6On6nqfIHhO?=
 =?us-ascii?Q?7bR+j5D5B73J7LehZCzklM8mBnAqScQ3NwogXcTzcTrofoL7y+THj8BEPQS9?=
 =?us-ascii?Q?wM+lLOPhW7/Ye85IHanvO00brPKjbeAIgNbG4ScxyPS9h+Avk1+yIxyAuLTh?=
 =?us-ascii?Q?1FXK+H4XyGoIuEtOX1r3MHJ5G2v3W2DnngZR6GmIxqjHj5KiQxpEVT72UUgk?=
 =?us-ascii?Q?efvheE5fLm+CMIH+fJvxM+/16JdhHOWcBu3ufjQWOhggBIpmfgExfalups24?=
 =?us-ascii?Q?Qi8bnAGz8lfeo8Cb9CyeAdPekrKKG+LDUrxZHQqDX2Xlm7bEROYN6N5Hu5sd?=
 =?us-ascii?Q?Sz+OWItc7+aRpsqcHjNXisDKgPXcoWxkFrMdDu4IyItZ7iXSy6LrjgBDYaWP?=
 =?us-ascii?Q?Pfi3zyEACrbeBTa9oga4mrzLZjmAt8aLkOD5pbu8Ftw6gBqzdZXvwmbEl/Bz?=
 =?us-ascii?Q?awxYroaWEpBI8vx2C/0Rag7YP/OdWLSlr+dNh4WG9ewPUJ4lhMKdTsRLi+ck?=
 =?us-ascii?Q?AToTmM88+MJllET+Gsj832usLBGCS0xBfI5pX66qGtt5c7DJpUeIK+JiGMqI?=
 =?us-ascii?Q?81q58QyLOcXK11iEIqFBCkkKYGyX8qSXbVOg9amo8zFJDc4Bwp/zwmAK0sMO?=
 =?us-ascii?Q?nBOlaXg8P2C6wO5vFyFjNV8sCfgDMwAEwrYm4iDYyV90IxJSAIaLRvMQWTU3?=
 =?us-ascii?Q?gPXmBlxXgJIxOOp93QirHjJjMEdRla+3yAjpXal5COGDstFxuIcrts/lNOO6?=
 =?us-ascii?Q?z5B00fFxtM6Lr/SZ+9d67yPl/eA8B9ZJ+57rHQELHwoi9rOex5VnbtKb2JBM?=
 =?us-ascii?Q?F6S7/5+2nrL4qb3g5CD3zMvU3iSbt8TuL6h+EVR3bK4ERzIerZQ9l2PZhjNA?=
 =?us-ascii?Q?v/GgLuMLD3sgwjGY0B4qMgeU?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d41f7e6-9521-4f1d-fd90-08d9571d5428
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 07:56:12.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KyPADTsHD+pNIPYluMYxyCOOsxvv/4o5aZ2f/CGf94VXQpR/5ZD2ve3e84VFvcX8bu1VKWmJD4yY0nJp7xE22a3zO8hLmwmQVVc4u40Fbfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5823
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

Let's also export SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags to uAPI so
that using these interface one can reenable automatic socket buffer
adjustment on their sockets.

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

Note: I'm not sure about the way I export flags to uAPI, probably there
is some other better way without separating BUF and BIND lock flags to
different header files.

v2: define SOCK_BUF_LOCK_MASK mask
v3: reject other flags except SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK, use
mask in sock_getsockopt, export flags to uapi/linux/socket.h
---
 arch/alpha/include/uapi/asm/socket.h  |  2 ++
 arch/mips/include/uapi/asm/socket.h   |  2 ++
 arch/parisc/include/uapi/asm/socket.h |  2 ++
 arch/sparc/include/uapi/asm/socket.h  |  2 ++
 include/net/sock.h                    |  3 +--
 include/uapi/asm-generic/socket.h     |  2 ++
 include/uapi/linux/socket.h           |  5 +++++
 net/core/sock.c                       | 13 +++++++++++++
 8 files changed, 29 insertions(+), 2 deletions(-)

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
 
 
diff --git a/include/net/sock.h b/include/net/sock.h
index ff1be7e7e90b..6e761451c927 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -68,6 +68,7 @@
 #include <net/tcp_states.h>
 #include <linux/net_tstamp.h>
 #include <net/l3mdev.h>
+#include <uapi/linux/socket.h>
 
 /*
  * This structure really needs to be cleaned up.
@@ -1438,8 +1439,6 @@ static inline int __sk_prot_rehash(struct sock *sk)
 #define RCV_SHUTDOWN	1
 #define SEND_SHUTDOWN	2
 
-#define SOCK_SNDBUF_LOCK	1
-#define SOCK_RCVBUF_LOCK	2
 #define SOCK_BINDADDR_LOCK	4
 #define SOCK_BINDPORT_LOCK	8
 
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
diff --git a/include/uapi/linux/socket.h b/include/uapi/linux/socket.h
index c3409c8ec0dd..eb0a9a5b6e71 100644
--- a/include/uapi/linux/socket.h
+++ b/include/uapi/linux/socket.h
@@ -26,4 +26,9 @@ struct __kernel_sockaddr_storage {
 	};
 };
 
+#define SOCK_SNDBUF_LOCK	1
+#define SOCK_RCVBUF_LOCK	2
+
+#define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
+
 #endif /* _UAPI_LINUX_SOCKET_H */
diff --git a/net/core/sock.c b/net/core/sock.c
index 9671c32e6ef5..aada649e07e8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1358,6 +1358,15 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		ret = sock_bindtoindex_locked(sk, val);
 		break;
 
+	case SO_BUF_LOCK:
+		if (val & ~SOCK_BUF_LOCK_MASK) {
+			ret = -EINVAL;
+			break;
+		}
+		sk->sk_userlocks = val | (sk->sk_userlocks &
+					  ~SOCK_BUF_LOCK_MASK);
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1720,6 +1729,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val64 = sock_net(sk)->net_cookie;
 		break;
 
+	case SO_BUF_LOCK:
+		v.val = sk->sk_userlocks & SOCK_BUF_LOCK_MASK;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.31.1

