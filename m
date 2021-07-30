Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171153DBCDB
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhG3QHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:07:40 -0400
Received: from mail-eopbgr60104.outbound.protection.outlook.com ([40.107.6.104]:4442
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229581AbhG3QHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 12:07:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEkaPM/52XHfIJzT64CvSkHv+Ogwh5aXycMXBVCYA+29Sm8xx+0eEHMrUWDl2Tp1a1UA2KHCTlUcXAwFPTllK5Pqk2WVF+lZm1U+zgm7x6HqaHwg+94CTmSvcvk8MHh97XMtX3lfHIAZeSAHtafoyExYwO8wKeTnHIvlq+NpK45n5FjwwDwcNU72Oejn0LOizLDRUEn2PO4LkMCI4UAxCsk5Q/Bz0UVoOLxh/DTB3jbuUjGWKpTTWD0MOojRT9224ETyJRXW7GjymroFWd4YAWk7uHuiJLVIhFDAr+6BLMghSo7oTodyJcjTiuzNJTjfEmGSWKIJsSDIQAoOAX3q3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jh6J86aOfAIBVogN4IlKBvEVrOj1jW+gLb69bLO87g=;
 b=RIXVyzpuxQT8QpIz+RboNr6arYr8Jzg3LfRTiam+3aig8u3ZLzqtSreU21HxTGDdLs/Qu6e5WQ9ajfc0bihrUrfRHjF+GbGBVMjS7H1pZSEwNyJFHzvrozmDqc+LqbXEyDbfcg891970xYCC3gbW5hicOZTuoGiJdENA8AN6S/yrwEujA8c+w1ryB8fY6G9Emo9Of+AKDU8jysVQfH47wxLw7t0piLAh0ZgkXH49XSD6j/h9f0dGmC55+JpAqRYRCFUomR2+pJWQSRnLhue/ADcY/J++mwMmEE6aKrV7WuZT+NiOlCVqlizx8eRe/sJzDZRT78vsZ0eY5uXYlat5/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Jh6J86aOfAIBVogN4IlKBvEVrOj1jW+gLb69bLO87g=;
 b=jlI1IS9/ABnSF+NuSfNgBSSF1/aFVw+e9V4nfg49aLsKtQRC3epk5b5nhh9bTex63158Mr7KZOmeSeur8A6koqX0ibVtKROC7aWFFRF1Cz7btsSWpF8tRa6Y9uNrhSehzo2zXjndsCXTYeG9jzQCUY1yAk3PP4XrPqlKJULAeto=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR08MB5373.eurprd08.prod.outlook.com (2603:10a6:803:131::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 16:07:29 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 16:07:29 +0000
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
Subject: [PATCH v2] sock: allow reading and changing sk_userlocks with setsockopt
Date:   Fri, 30 Jul 2021 19:07:08 +0300
Message-Id: <20210730160708.6544-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P192CA0007.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::12) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fedora.sw.ru (46.39.230.13) by PR3P192CA0007.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.30 via Frontend Transport; Fri, 30 Jul 2021 16:07:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bb13873-4bd5-4d89-5d58-08d953742150
X-MS-TrafficTypeDiagnostic: VI1PR08MB5373:
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB5373D5C29EE059483C8C5804B7EC9@VI1PR08MB5373.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gXbX5W1p6WAXUMlcOATPH/QdbqofevzMOd0nt5UPvlxbkE+3MRNSGaBeTkCVzxWSvVaA6znVT8qS02jRPLA0wONXDOLyrsMRR+A3EVBBUaFF9ydQ8bIaM8/eJalEuExeZN0hOK6jJV7qWJgDMCZOIuBO9CLXEbehQ9izwVTixuPDaUgoIZL7b5Zk86jDIMpXIdNa4IalHuiTsMzOVPo4mX/7rnMOYL4nSjPSF8hdzKbMr2bVBbHI5/uYBZxOPmD5PBkaaelQ21AzaoTUGdFZBOu53oiGh+Os/2hS/aN3z9eKvBNGxqXtvIMtgAWBpKKHHa/AbzuE6HGkNrHvc1P4+kffSq8o8P9Yu5M2TLWukYoorjRPBNiLas3gchzzhfTmgMZF/WCeG7McgoFdM+hk6i1rX4paGqdHf5R68ej0mbK2dzWxbkuUgB8ggiLzFcfwy/oEDrzv6d6HB1C3EOPO7feCqGGFSc1KXDjv77xQAPDUXUGYDcjzWiUF0Rut6rzF87jQXNAqpMVl8rCSsfbFzea47vdr6J9J9VE0+oKwlw/I5qRPWuORyN1KpAUqK7kTQr6F8FndnczqUk9iYCjNKCG+xaertXxOZHOR8BOYQ0s+s9qOcQ1darrBQFIP5b1JiBUcJOmeEKhHldAluqztc6rIfF2Xjp79+y+MmCPKETkaKav5/71AOw6D1dC4NjJSwFWo3n+D6JRLnouS1ZJGTRV3oDdFjHkOTU9PqdzFSRk1EbaM5xhpkreh+5YwkCHpV/9QgLJ+BGnZ9kV8CE4Sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(366004)(376002)(346002)(136003)(7416002)(66476007)(66946007)(66556008)(52116002)(186003)(86362001)(38350700002)(2616005)(956004)(6512007)(2906002)(6506007)(5660300002)(38100700002)(8676002)(54906003)(26005)(4326008)(8936002)(36756003)(966005)(478600001)(1076003)(6666004)(107886003)(6486002)(316002)(83380400001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NVARfGi7opEvlvD5qvXSJoNixzBvqydNAZxFLb9qe83K9t3ud9KCro9CZzpE?=
 =?us-ascii?Q?Yp6LLSB+61QYA9nbidaoM/URedMXJzDoXsYmht7geGyC1Gse7siXRz4zB3dt?=
 =?us-ascii?Q?ldKG0kxIcKaL4aP6jtbz7/0FkxYNogTGQI2JID1R5j4UJLjF3Zv+xHK5uYgI?=
 =?us-ascii?Q?vuvm9uEWp4TU8kqmpZ2Zm9x8i8BHku9rjYMSWJvSRi14OSUBFZ38WYTWI4wG?=
 =?us-ascii?Q?D3j051/JvhPhAA60q7710AcX819gJuAWGtMirj4ti2/u0ZUEPKlyHI//FduW?=
 =?us-ascii?Q?wifY2JckvjYryqXF/g9BgAvLdR/pN1mre4BB8mDn8cXVA8KINwp/ifMGL9rN?=
 =?us-ascii?Q?Pib1Di6QtJpW+9JjHbgEPXxesn23M5/2g058q0iMmpY89hV809yQz5yNGkoO?=
 =?us-ascii?Q?IVzdmL0k5xKX0rzBSz4b0uTmvP8ne/fD5ofCvNMtrwA9m9d8tPtCYhwucp9+?=
 =?us-ascii?Q?P4h1DZg4J2pg9R4Gkq2SNy4DIxjznbWIGUqq4A2cJTKFJMfw2VTbvLHEIn8d?=
 =?us-ascii?Q?/a8KtsHK5g3hlzsQkQs5AeVw71HZY6+GbB0w+/SNGgZj6K8lmsqOKOd8ErAg?=
 =?us-ascii?Q?fmhqYggisRt/iFapefsLzkyrSqGA/b39WDBKzZz7CPPb4oVYO1j43SEX45rA?=
 =?us-ascii?Q?P+w14GoNbUns5P7SvwiAx+ihvmASkVlotk2XyZMG6U3PJxGgCAg1VTAx9jL7?=
 =?us-ascii?Q?YegPiigUV1KuXJ2s3WQ8L0OWmqBczKjmZJHflc0Dis8or7+s1W5b7YUhjqB/?=
 =?us-ascii?Q?0QtcRgz9mATHF4NhwQhpCBU1W7dh+1UckXQ7dzq+jW5Qu6gEjmInpAWN27gb?=
 =?us-ascii?Q?UQsYfFVSgf6AF5opbZ/GIMTy9FLGneJrHhabT4ow4NlGJBkGJldjD+utfprs?=
 =?us-ascii?Q?57NgpaPgTuYy8/418h2kG4vWHBrNPfm4d6f/NeUnEtFOfHw4E3gXkmhlJvpL?=
 =?us-ascii?Q?vmOOo30KmcVFWCAf1WthHw7/h+VftBCQFQ/PpVHk8gPpowSaYo67ZibcEZYr?=
 =?us-ascii?Q?NKwxkjpvW2oL3lktxu6F+L4pOQKN1hJ4icUFi8tRIqq8gAOBnAPirA0eiriC?=
 =?us-ascii?Q?v5g87YAciQXjA/jF1h3rbb355f36tcULZ0l/BuadVB3ZWJ3lead5e1lU24tr?=
 =?us-ascii?Q?7jtSFhdmUtOeDUCX74A9jBZgMEwItp/Y2jKTeYWQX9rjWh//QDvJRBF08TNi?=
 =?us-ascii?Q?0ckj24X20qnYPZg5nqwIZ2wczVtjcLTx8vzI+Z9LqfZFz2DNvj9Ee4aAIo4Y?=
 =?us-ascii?Q?4rR4zX6l8sYlF95tgwBfyKEJqQa364dzpcP3Rpw1KEWMrWtQdhcINf01/7iU?=
 =?us-ascii?Q?yNQxdh1PGoBenZCJBDDpbk3w?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bb13873-4bd5-4d89-5d58-08d953742150
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 16:07:29.2261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u5MRMVn145sOVaDE+SvdqQzbAxRAqxYhevzVylEmDmudhdPHSp85ZaWwNqBrlRS/CjFTkf7b4riCgFAQcpsd1gC8gaH0tZZ+mneiTXibS6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5373
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

v2: define SOCK_BUF_LOCK_MASK mask
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 include/net/sock.h                    | 2 ++
 include/uapi/asm-generic/socket.h     | 2 ++
 net/core/sock.c                       | 9 +++++++++
 7 files changed, 21 insertions(+)

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
index f23cb259b0e2..a6fb02f39cc4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1443,6 +1443,8 @@ static inline int __sk_prot_rehash(struct sock *sk)
 #define SOCK_BINDADDR_LOCK	4
 #define SOCK_BINDPORT_LOCK	8
 
+#define SOCK_BUF_LOCK_MASK (SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK)
+
 struct socket_alloc {
 	struct socket socket;
 	struct inode vfs_inode;
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
index a3eea6e0b30a..c8c994e48b76 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1357,6 +1357,11 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		ret = sock_bindtoindex_locked(sk, val);
 		break;
 
+	case SO_BUF_LOCK:
+		sk->sk_userlocks = (sk->sk_userlocks & ~SOCK_BUF_LOCK_MASK) |
+				   (val & SOCK_BUF_LOCK_MASK);
+		break;
+
 	default:
 		ret = -ENOPROTOOPT;
 		break;
@@ -1719,6 +1724,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
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

