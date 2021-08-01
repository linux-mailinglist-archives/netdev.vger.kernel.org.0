Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8E3DCAAC
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 09:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhHAH5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 03:57:35 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:65490 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229642AbhHAH5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 03:57:31 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1717uu7H023150;
        Sun, 1 Aug 2021 07:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2021-07-09;
 bh=y/vlpQYCk0dAC/JItRvpdiusETo5O+aLGWXIKPwqEeQ=;
 b=YS+CuAVeAzJFQJiKJRf06vwzFqrWs19wRhmERYZJk+08E0+un57TOlOfUH2PhAipcTw7
 /rX1v4oEsgsQHMPnKrY78+VMAsLbqzcgn4daMXul+G9QqkkKT33A7CIfIUOkDu+f9kki
 tY+j377af8DION5n5aa0K1vVaQ0c0y00OL1mAkx6U1DNdyRxhlnMiM746+3zSfOUo6fp
 pSNE3rMw6mErcPaXoIj2mGghDXdMKc12U23sLD22KvY3WtWgthGzq9hqTAwCh+zqXBIV
 mtLz83cd47kRILDbn2F3GKDjZsxvFk6OPjlo7HJM1FZrv14qYGL1+vT4F4oSmGF2IHjq 3w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2020-01-29;
 bh=y/vlpQYCk0dAC/JItRvpdiusETo5O+aLGWXIKPwqEeQ=;
 b=m3iO8E/Oe9W1sHcvKWiJsgsyIwW2AJmr5MGQUw/USlhJiFGS1CNFiZG16l+Bku69T4y6
 ph+Uk2uijMavdOsBMAhr6wabpsfvTRLTTItdG87+8g+H3EGaYqBly+9VHqpEWBwkK2GH
 5ZBX0ZVonKkfPS0XCg2mMACUyDZZ5A7hCwxPwU7C8lmhE+X7+yb1vCJIg+BuY1XswmRl
 aaOyxdy9D+QfM/rVHMr6FfZQeI3qeB10iJkr4AIdFvPXLcwpB8lZU93akPSZnQ5hE24Z
 7IB1FRLBJa7IP6FlqcQCUjpcTAippeeB7K7UNdDhY5SuaR9W5zn7RJ5/dzaNfMo1sbVh oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a4w41972g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 07:57:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1717tkOQ124563;
        Sun, 1 Aug 2021 07:57:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3a4xb37b8f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Aug 2021 07:57:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlCJTO/HiDvcItJIuuMtzZA2b6JQ/MIoRK3utsZQ9awcPmeIdXpW2xN/nBAOAXv9DQ1HNRUTXCj+2tfiOktULrBf/60A1mf7tC3EwunJswyfJefkhwbj9YVfYNYTdxhsR3hUUpA9B1Ltg5E7w7UxfN+Ty929sJu9mRTOn1Pk9q38eWX2gaLBNBg88/P1jFTxicV6MEZ91N0TvbQR8g2CnjgEnMmFt3qqBPaRdl1BFXsIBbCGescprIkDMWGIwm8V0nmzxWVjjckRf7FGv5kIWpTiWrhek8e92dibrxeNDiYFTZhhOiZeEBAJu2vakC8BLh1gOWIzk1GkoRhSt7Mv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/vlpQYCk0dAC/JItRvpdiusETo5O+aLGWXIKPwqEeQ=;
 b=geUD0jBSb5PSRYPPl5iSennYOIb+ao7GsC8++xffyKRpMQcRfypPirZEjMkV7+gLnrLwoFo8A0ZVHuV8WKniGuUWJdSG7FJX+wByUrliah6gY6Nj9qJOy7RAvr5Z3nYPR15aR0lC8FAXeg6tJAxM48CrCYdNx+HQkeyFoUPz/5mLVsv5eMF6L9dn1CsBAj+b9yzM64/tybtyj6w4kuJREUExWtJY8uPIyMTNdlrplYIosLrvlt/4FVCyyOzk076Nz/UZ83g3nC2oQdVrUhwguEzSOFATunsCgamtOIULqjGjDT3OOsyFobEweDTtvvsVNTuIwMSPd1BQbNo4+uGtRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/vlpQYCk0dAC/JItRvpdiusETo5O+aLGWXIKPwqEeQ=;
 b=C4cbGOemi3A9i7IDO8Dz5lDVSb3uwoJVJUgTPrgE4EI/nS5OKTYnWvqs/JwLf8yxsHjfATxNsS1+PPKB8tY3AE4JLsEhyNfb0V/U1XKaT9OUz+h0Fnrb5ARgckJ1fr1sB1k3ZIeRRiYfM94wQEM2Gt3rs9JMreRT5ij1u1qGC5s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB3382.namprd10.prod.outlook.com (2603:10b6:a03:156::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sun, 1 Aug
 2021 07:57:16 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::5de5:d174:9459:6d21]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::5de5:d174:9459:6d21%6]) with mapi id 15.20.4373.026; Sun, 1 Aug 2021
 07:57:16 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        rao.shoaib@oracle.com, viro@zeniv.linux.org.uk, pabeni@redhat.com
Subject: [PATCH net-next af_unix v1 1/1] af_unix: Add OOB support
Date:   Sun,  1 Aug 2021 00:57:07 -0700
Message-Id: <20210801075707.176201-2-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210801075707.176201-1-Rao.Shoaib@oracle.com>
References: <20210801075707.176201-1-Rao.Shoaib@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0021.namprd02.prod.outlook.com
 (2603:10b6:803:2b::31) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SN4PR0201CA0021.namprd02.prod.outlook.com (2603:10b6:803:2b::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20 via Frontend Transport; Sun, 1 Aug 2021 07:57:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a95ca9cf-4efc-44e5-f510-08d954c1fafd
X-MS-TrafficTypeDiagnostic: BYAPR10MB3382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3382DBD04C08CCA0146D2319EFEE9@BYAPR10MB3382.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /CEAfYh4i4waCun0/sPT2kdC7B2R7psX1NnOo4t5CUA8NhJEXTyft2A++xhxosA/LUBnvp3r1B4tJi7M1zjp/ea4162rhyFEmPKZWEhtS7ie7u0887y9VOXjDu/a8wtnV5gAklrOVPwAWBRlNsC7eXg/9dkRwSpVoBP4dDfvW5TBjWiGpPwZJQ17IziD2Ds8ms8JfpwF9BWXN2gPHZE6Zt6CchA/5enqLGACd6JkkzCdnoeI5z0ygU/lOTDLzs9SRyst1WK8QeUg3icTnWG38xVVDceC/idocRfbUczS9HAQhqIp2TgEzAGPFwTbib0Va50kenImmHXwtKbf/eTD/JlGh2E7WeXKcanxG33uwzN1QbnlY1uRTmGXWlFwfBJpR6I35D4zjxDjXqz6+1oFBKFNkwn9DNpRTZ9T43WGGXRLoQiHIPHhBwh4MVDFQWrvWJb66NfEF/rz8w4Uf75mPKgAXhNG7vTRwNR0IqI2jkeaqitYCgurycLhCeu/ZWGu+N4XELChbXzFWe6a6qrkI9KdIqk1k38sfhdb7z3vGG9RwzCVjB/g2HJ6FWrukjw24nPab9gpg/U7d0SVz1rwnhi6jQY0MnY3IM3a1kYOH6nMR0OVAGYCyLHseAaW3PrKmVrJI7kle7You0bQEreMxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(7696005)(52116002)(2906002)(6666004)(66476007)(86362001)(66946007)(1076003)(508600001)(66556008)(30864003)(83380400001)(5660300002)(186003)(8936002)(2616005)(8676002)(6486002)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RdsqezpqUJ8qO77nmnPjvN1cgAULQv76pcanibtHYOymhNaDA7qW7lwvisU4?=
 =?us-ascii?Q?nFcls79VyVgZVu03DIbpDZYxwrefbqum44M8/9HqChjrlOe3xNGzbO25tBzh?=
 =?us-ascii?Q?1LxYdjB/V4FLlP8Is5l8mK8fV8RpZM6+Y1nhrUHB7hJphuXIRZgG427q+RG6?=
 =?us-ascii?Q?T6BbKEF4MX+/bbuqFgUoeDwDmawLl+zrC5q0EbvyVbS9ZlUA2VNXOJvOGvAL?=
 =?us-ascii?Q?69K+Tl64sTB1D+3iuVHSWPJch18avpT2Da1CuCT/E8BFUXgWm943cBvaDU+/?=
 =?us-ascii?Q?Pcd8fRioZmFboyU/V1E0tMgRw5iOb5UqXZqXvqeh6HSWzTfYF6STXhiQcJ55?=
 =?us-ascii?Q?r+ADGnIbhveTqBkm8npIUHqPh0ZogV7j5KTpZSKLAHnhlB0GOM4AgK6t+chT?=
 =?us-ascii?Q?SRqaTQj9divYlh536OptKhrA5bojdjO5OgzlhurqDRCkehtNSzVspN4GjBgw?=
 =?us-ascii?Q?78+T86V+J9I75gnugv+aBxbzJqfMv0Lc0gw8SQy6vVggoBcsU5sCmf8VyTWc?=
 =?us-ascii?Q?cftKar1V8doUPAidGymDKfkvCq9+kTCUUsqZOm6MoBibuWk3VxVPYbDHRaqV?=
 =?us-ascii?Q?i8ePCXHPrP9y0Dl17/j/9NpY59K1V/dtTC8I/k4Hgi2qaEtN96TOJpuZVT+s?=
 =?us-ascii?Q?fMsJNc8sDWaNmVxIkgOrGOy9y5k+ZjiSSfG2cNgIGOpxoR1TYi2lZgpErcal?=
 =?us-ascii?Q?Gicop5VvlsMwPZgBsdD52i+8JrCdwQ+bPy6+4lVLDkYyOj6VGBQrXQ9swnQl?=
 =?us-ascii?Q?LeZ+GQ9KGgmQHvLbyYBASxVHjMz45qwPBe9c8yMNzR3Qpig29pAZrqXHD3mt?=
 =?us-ascii?Q?PHdSii0c35mlWd6QPIdYg5Is4oq+XQ22PRPPXm9QqtKjCJzu/xFX6T71WO/J?=
 =?us-ascii?Q?FEI5oXT2Q81DlA8TYMnskPTnpAKnm9n71ntqE97+gMl0oyBGXt8smwAEQOVf?=
 =?us-ascii?Q?xqrvQhWqnGKpvKYzrZLaW8QNWerGXPaT93qF9ySi/dzFxuPpGw4rO39s6Xpe?=
 =?us-ascii?Q?9ukxAYFVnFTyOj79vuLFRWoiChTHspeIs4lW67lM+UVWvXVkQCJSFLJjuIM6?=
 =?us-ascii?Q?0esYcUWXZMWaTbrdizYexb3fe+G6tVRS5X6kH3xdjNnTRDbdR/BwZoVAvdEb?=
 =?us-ascii?Q?ZsTJb3fMF1RV68M9ZWik8J0ju/B0hu2gSB0W2GrkdpbsMpG2QLc1EF0rfNEW?=
 =?us-ascii?Q?0W4BXdMEunXwvHW1gxusQgDwQ2W8cFQvnSoOaFpKrNtm9f5MsphPaLPQOXQk?=
 =?us-ascii?Q?2LMR3Y9rFp8u43vIJQrVZ6LZGtLfrQwj0eUys/hS5uUXQp2Xn0WkpVViSkcV?=
 =?us-ascii?Q?ThgFZAXbmY/AXUPX4K+DH5NMsnX+kkdtqtzHkq/P1Vf6XQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a95ca9cf-4efc-44e5-f510-08d954c1fafd
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2021 07:57:16.8563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ej/ifxSWRrOiQgtjeOF/07niMm53FpzTFvf08FlMHjdqmRWBvkIFrNmetI6CsY1cez6Og14hhQU9JxZCSMg7cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3382
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10062 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108010058
X-Proofpoint-ORIG-GUID: FIXL4lxtfDpamyg6D5bmEkJMIJVVGuNP
X-Proofpoint-GUID: FIXL4lxtfDpamyg6D5bmEkJMIJVVGuNP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

This patch adds OOB support for AF_UNIX sockets.
The semantics is same as TCP.

The last byte of a message with the OOB flag is
treated as the OOB byte. The byte is separated into
a skb and a pointer to the skb is stored in unix_sock.
The pointer is used to enforce OOB semantics.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 include/net/af_unix.h                         |   3 +
 net/unix/Kconfig                              |   5 +
 net/unix/af_unix.c                            | 153 +++++-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   5 +
 .../selftests/net/af_unix/test_unix_oob.c     | 437 ++++++++++++++++++
 6 files changed, 602 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/net/af_unix/Makefile
 create mode 100644 tools/testing/selftests/net/af_unix/test_unix_oob.c

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index f42fdddecd41..17965c8d6189 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -70,6 +70,9 @@ struct unix_sock {
 	struct socket_wq	peer_wq;
 	wait_queue_entry_t	peer_wake;
 	struct scm_stat		scm_stat;
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	struct sk_buff		*oob_skb;
+#endif
 };
 
 static inline struct unix_sock *unix_sk(const struct sock *sk)
diff --git a/net/unix/Kconfig b/net/unix/Kconfig
index b6c4282899ec..b7f811216820 100644
--- a/net/unix/Kconfig
+++ b/net/unix/Kconfig
@@ -25,6 +25,11 @@ config UNIX_SCM
 	depends on UNIX
 	default y
 
+config	AF_UNIX_OOB
+	bool
+	depends on UNIX
+	default y
+
 config UNIX_DIAG
 	tristate "UNIX: socket monitoring interface"
 	depends on UNIX
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 23c92ad15c61..9435a17487bb 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -502,6 +502,12 @@ static void unix_sock_destructor(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (u->oob_skb) {
+		kfree_skb(u->oob_skb);
+		u->oob_skb = NULL;
+	}
+#endif
 	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(!sk_unhashed(sk));
 	WARN_ON(sk->sk_socket);
@@ -1825,6 +1831,46 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
  */
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
+#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
+{
+	struct unix_sock *ousk = unix_sk(other);
+	struct sk_buff *skb;
+	int err = 0;
+
+	skb = sock_alloc_send_skb(sock->sk, 1, msg->msg_flags & MSG_DONTWAIT, &err);
+
+	if (!skb)
+		return err;
+
+	skb_put(skb, 1);
+	skb->len = 1;
+	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
+
+	if (err) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	unix_state_lock(other);
+	maybe_add_creds(skb, sock, other);
+	skb_get(skb);
+
+	if (ousk->oob_skb)
+		kfree_skb(ousk->oob_skb);
+
+	ousk->oob_skb = skb;
+
+	scm_stat_add(other, skb);
+	skb_queue_tail(&other->sk_receive_queue, skb);
+	sk_send_sigurg(other);
+	unix_state_unlock(other);
+	other->sk_data_ready(other);
+
+	return err;
+}
+#endif
+
 static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 			       size_t len)
 {
@@ -1843,8 +1889,14 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		return err;
 
 	err = -EOPNOTSUPP;
-	if (msg->msg_flags&MSG_OOB)
-		goto out_err;
+	if (msg->msg_flags & MSG_OOB) {
+#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+		if (len)
+			len--;
+		else
+#endif
+			goto out_err;
+	}
 
 	if (msg->msg_namelen) {
 		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
@@ -1909,6 +1961,15 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		sent += size;
 	}
 
+#if (IS_ENABLED(CONFIG_AF_UNIX_OOB))
+	if (msg->msg_flags & MSG_OOB) {
+		err = queue_oob(sock, msg, other);
+		if (err)
+			goto out_err;
+		sent++;
+	}
+#endif
+
 	scm_destroy(&scm);
 
 	return sent;
@@ -2247,6 +2308,59 @@ struct unix_stream_read_state {
 	unsigned int splice_flags;
 };
 
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+static int unix_stream_recv_urg(struct unix_stream_read_state *state)
+{
+	struct socket *sock = state->socket;
+	struct sock *sk = sock->sk;
+	struct unix_sock *u = unix_sk(sk);
+	int chunk = 1;
+
+	if (sock_flag(sk, SOCK_URGINLINE) || !u->oob_skb)
+		return -EINVAL;
+
+	chunk = state->recv_actor(u->oob_skb, 0, chunk, state);
+	if (chunk < 0)
+		return -EFAULT;
+
+	if (!(state->flags & MSG_PEEK)) {
+		UNIXCB(u->oob_skb).consumed += 1;
+		kfree_skb(u->oob_skb);
+		u->oob_skb = NULL;
+	}
+	state->msg->msg_flags |= MSG_OOB;
+	return 1;
+}
+
+static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
+				  int flags, int copied)
+{
+	struct unix_sock *u = unix_sk(sk);
+
+	if (!unix_skb_len(skb) && !(flags & MSG_PEEK)) {
+		skb_unlink(skb, &sk->sk_receive_queue);
+		consume_skb(skb);
+		skb = NULL;
+	} else {
+		if (skb == u->oob_skb) {
+			if (copied) {
+				skb = NULL;
+			} else if (sock_flag(sk, SOCK_URGINLINE)) {
+				if (!(flags & MSG_PEEK)) {
+					u->oob_skb = NULL;
+					consume_skb(skb);
+				}
+			} else if (!(flags & MSG_PEEK)) {
+				skb_unlink(skb, &sk->sk_receive_queue);
+				consume_skb(skb);
+				skb = skb_peek(&sk->sk_receive_queue);
+			}
+		}
+	}
+	return skb;
+}
+#endif
+
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				    bool freezable)
 {
@@ -2272,6 +2386,15 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 
 	if (unlikely(flags & MSG_OOB)) {
 		err = -EOPNOTSUPP;
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+		mutex_lock(&u->iolock);
+		unix_state_lock(sk);
+
+		err = unix_stream_recv_urg(state);
+
+		unix_state_unlock(sk);
+		mutex_unlock(&u->iolock);
+#endif
 		goto out;
 	}
 
@@ -2300,6 +2423,18 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		}
 		last = skb = skb_peek(&sk->sk_receive_queue);
 		last_len = last ? last->len : 0;
+
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+		if (skb) {
+			skb = manage_oob(skb, sk, flags, copied);
+			if (!skb) {
+				unix_state_unlock(sk);
+				if (copied)
+					break;
+				goto redo;
+			}
+		}
+#endif
 again:
 		if (skb == NULL) {
 			if (copied >= target)
@@ -2635,6 +2770,20 @@ static int unix_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCUNIXFILE:
 		err = unix_open_file(sk);
 		break;
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	case SIOCATMARK:
+		{
+			struct sk_buff *skb;
+			struct unix_sock *u = unix_sk(sk);
+			int answ = 0;
+
+			skb = skb_peek(&sk->sk_receive_queue);
+			if (skb && skb == u->oob_skb)
+				answ = 1;
+			err = put_user(answ, (int __user *)arg);
+		}
+		break;
+#endif
 	default:
 		err = -ENOIOCTLCMD;
 		break;
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index fb010a35d61a..da9e8b699e42 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -38,6 +38,7 @@ TARGETS += mount_setattr
 TARGETS += mqueue
 TARGETS += nci
 TARGETS += net
+TARGETS += net/af_unix
 TARGETS += net/forwarding
 TARGETS += net/mptcp
 TARGETS += netfilter
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
new file mode 100644
index 000000000000..cfc7f4f97fd1
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -0,0 +1,5 @@
+##TEST_GEN_FILES := test_unix_oob
+TEST_PROGS := test_unix_oob
+include ../../lib.mk
+
+all: $(TEST_PROGS)
diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c b/tools/testing/selftests/net/af_unix/test_unix_oob.c
new file mode 100644
index 000000000000..0f3e3763f4f8
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
@@ -0,0 +1,437 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+#include <unistd.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <errno.h>
+#include <netinet/tcp.h>
+#include <sys/un.h>
+#include <sys/signal.h>
+#include <sys/poll.h>
+
+static int pipefd[2];
+static int signal_recvd;
+static pid_t producer_id;
+static char sock_name[32];
+
+static void sig_hand(int sn, siginfo_t *si, void *p)
+{
+	signal_recvd = sn;
+}
+
+static int set_sig_handler(int signal)
+{
+	struct sigaction sa;
+
+	sa.sa_sigaction = sig_hand;
+	sigemptyset(&sa.sa_mask);
+	sa.sa_flags = SA_SIGINFO | SA_RESTART;
+
+	return sigaction(signal, &sa, NULL);
+}
+
+static void set_filemode(int fd, int set)
+{
+	int flags = fcntl(fd, F_GETFL, 0);
+
+	if (set)
+		flags &= ~O_NONBLOCK;
+	else
+		flags |= O_NONBLOCK;
+	fcntl(fd, F_SETFL, flags);
+}
+
+static void signal_producer(int fd)
+{
+	char cmd;
+
+	cmd = 'S';
+	write(fd, &cmd, sizeof(cmd));
+}
+
+static void wait_for_signal(int fd)
+{
+	char buf[5];
+
+	read(fd, buf, 5);
+}
+
+static void die(int status)
+{
+	fflush(NULL);
+	unlink(sock_name);
+	kill(producer_id, SIGTERM);
+	exit(status);
+}
+
+int is_sioctatmark(int fd)
+{
+	int ans = -1;
+
+	if (ioctl(fd, SIOCATMARK, &ans, sizeof(ans)) < 0) {
+#ifdef DEBUG
+		perror("SIOCATMARK Failed");
+#endif
+	}
+	return ans;
+}
+
+void read_oob(int fd, char *c)
+{
+
+	*c = ' ';
+	if (recv(fd, c, sizeof(*c), MSG_OOB) < 0) {
+#ifdef DEBUG
+		perror("Reading MSG_OOB Failed");
+#endif
+	}
+}
+
+int read_data(int pfd, char *buf, int size)
+{
+	int len = 0;
+
+	memset(buf, size, '0');
+	len = read(pfd, buf, size);
+#ifdef DEBUG
+	if (len < 0)
+		perror("read failed");
+#endif
+	return len;
+}
+
+static void wait_for_data(int pfd, int event)
+{
+	struct pollfd pfds[1];
+
+	pfds[0].fd = pfd;
+	pfds[0].events = event;
+	poll(pfds, 1, -1);
+}
+
+void producer(struct sockaddr_un *consumer_addr)
+{
+	int cfd;
+	char buf[64];
+	int i;
+
+	memset(buf, 'x', sizeof(buf));
+	cfd = socket(AF_UNIX, SOCK_STREAM, 0);
+
+	wait_for_signal(pipefd[0]);
+	if (connect(cfd, (struct sockaddr *)consumer_addr,
+		     sizeof(struct sockaddr)) != 0) {
+		perror("Connect failed");
+		kill(0, SIGTERM);
+		exit(1);
+	}
+
+	for (i = 0; i < 2; i++) {
+		/* Test 1: Test for SIGURG and OOB */
+		wait_for_signal(pipefd[0]);
+		memset(buf, 'x', sizeof(buf));
+		buf[63] = '@';
+		send(cfd, buf, sizeof(buf), MSG_OOB);
+
+		wait_for_signal(pipefd[0]);
+
+		/* Test 2: Test for OOB being overwitten */
+		memset(buf, 'x', sizeof(buf));
+		buf[63] = '%';
+		send(cfd, buf, sizeof(buf), MSG_OOB);
+
+		memset(buf, 'x', sizeof(buf));
+		buf[63] = '#';
+		send(cfd, buf, sizeof(buf), MSG_OOB);
+
+		wait_for_signal(pipefd[0]);
+
+		/* Test 3: Test for SIOCATMARK */
+		memset(buf, 'x', sizeof(buf));
+		buf[63] = '@';
+		send(cfd, buf, sizeof(buf), MSG_OOB);
+
+		memset(buf, 'x', sizeof(buf));
+		buf[63] = '%';
+		send(cfd, buf, sizeof(buf), MSG_OOB);
+
+		memset(buf, 'x', sizeof(buf));
+		send(cfd, buf, sizeof(buf), 0);
+
+		wait_for_signal(pipefd[0]);
+
+		/* Test 4: Test for 1byte OOB msg */
+		memset(buf, 'x', sizeof(buf));
+		buf[0] = '@';
+		send(cfd, buf, 1, MSG_OOB);
+	}
+}
+
+int
+main(int argc, char **argv)
+{
+	int lfd, pfd;
+	struct sockaddr_un consumer_addr, paddr;
+	socklen_t len = sizeof(consumer_addr);
+	char buf[1024];
+	int on = 0;
+	char oob;
+	int flags;
+	int atmark;
+	char *tmp_file;
+
+	lfd = socket(AF_UNIX, SOCK_STREAM, 0);
+	memset(&consumer_addr, 0, sizeof(consumer_addr));
+	consumer_addr.sun_family = AF_UNIX;
+	sprintf(sock_name, "unix_oob_%d", getpid());
+	unlink(sock_name);
+	strcpy(consumer_addr.sun_path, sock_name);
+
+	if ((bind(lfd, (struct sockaddr *)&consumer_addr,
+		  sizeof(consumer_addr))) != 0) {
+		perror("socket bind failed");
+		exit(1);
+	}
+
+	pipe(pipefd);
+
+	listen(lfd, 1);
+
+	producer_id = fork();
+	if (producer_id == 0) {
+		producer(&consumer_addr);
+		exit(0);
+	}
+
+	set_sig_handler(SIGURG);
+	signal_producer(pipefd[1]);
+
+	pfd = accept(lfd, (struct sockaddr *) &paddr, &len);
+	fcntl(pfd, F_SETOWN, getpid());
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 1:
+	 * veriyf that SIGURG is
+	 * delivered and 63 bytes are
+	 * read and oob is '@'
+	 */
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	read_oob(pfd, &oob);
+	len = read_data(pfd, buf, 1024);
+	if (!signal_recvd || len != 63 || oob != '@') {
+		fprintf(stderr, "Test 1 failed sigurg %d len %d %c\n",
+			 signal_recvd, len, oob);
+			die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 2:
+	 * Verify that the first OOB is over written by
+	 * the 2nd one and the first OOB is returned as
+	 * part of the read, and sigurg is received.
+	 */
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	len = 0;
+	while (len < 70)
+		len = recv(pfd, buf, 1024, MSG_PEEK);
+	len = read_data(pfd, buf, 1024);
+	read_oob(pfd, &oob);
+	if (!signal_recvd || len != 127 || oob != '#') {
+		fprintf(stderr, "Test 2 failed, sigurg %d len %d OOB %c\n",
+		signal_recvd, len, oob);
+		die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 3:
+	 * verify that 2nd oob over writes
+	 * the first one and read breaks at
+	 * oob boundary returning 127 bytes
+	 * and sigurg is received and atmark
+	 * is set.
+	 * oob is '%' and second read returns
+	 * 64 bytes.
+	 */
+	len = 0;
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	while (len < 150)
+		len = recv(pfd, buf, 1024, MSG_PEEK);
+	len = read_data(pfd, buf, 1024);
+	atmark = is_sioctatmark(pfd);
+	read_oob(pfd, &oob);
+
+	if (!signal_recvd || len != 127 || oob != '%' || atmark != 1) {
+		fprintf(stderr, "Test 3 failed, sigurg %d len %d OOB %c ",
+		"atmark %d\n", signal_recvd, len, oob, atmark);
+		die(1);
+	}
+
+	signal_recvd = 0;
+
+	len = read_data(pfd, buf, 1024);
+	if (len != 64) {
+		fprintf(stderr, "Test 3.1 failed, sigurg %d len %d OOB %c\n",
+			signal_recvd, len, oob);
+		die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 4:
+	 * verify that a single byte
+	 * oob message is delivered.
+	 * set non blocking mode and
+	 * check proper error is
+	 * returned and sigurg is
+	 * received and correct
+	 * oob is read.
+	 */
+
+	set_filemode(pfd, 0);
+
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	len = read_data(pfd, buf, 1024);
+	if ((len == -1) && (errno == 11))
+		len = 0;
+
+	read_oob(pfd, &oob);
+
+	if (!signal_recvd || len != 0 || oob != '@') {
+		fprintf(stderr, "Test 4 failed, sigurg %d len %d OOB %c\n",
+			 signal_recvd, len, oob);
+		die(1);
+	}
+
+	set_filemode(pfd, 1);
+
+	/* Inline Testing */
+
+	on = 1;
+	if (setsockopt(pfd, SOL_SOCKET, SO_OOBINLINE, &on, sizeof(on))) {
+		perror("SO_OOBINLINE");
+		die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 1 -- Inline:
+	 * Check that SIGURG is
+	 * delivered and 63 bytes are
+	 * read and oob is '@'
+	 */
+
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	len = read_data(pfd, buf, 1024);
+
+	if (!signal_recvd || len != 63) {
+		fprintf(stderr, "Test 1 Inline failed, sigurg %d len %d\n",
+			signal_recvd, len);
+		die(1);
+	}
+
+	len = read_data(pfd, buf, 1024);
+
+	if (len != 1) {
+		fprintf(stderr,
+			 "Test 1.1 Inline failed, sigurg %d len %d oob %c\n",
+			 signal_recvd, len, oob);
+		die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 2 -- Inline:
+	 * Verify that the first OOB is over written by
+	 * the 2nd one and read breaks correctly on
+	 * 2nd OOB boundary with the first OOB returned as
+	 * part of the read, and sigurg is delivered and
+	 * siocatmark returns true.
+	 * next read returns one byte, the oob byte
+	 * and siocatmark returns false.
+	 */
+	len = 0;
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	while (len < 70)
+		len = recv(pfd, buf, 1024, MSG_PEEK);
+	len = read_data(pfd, buf, 1024);
+	atmark = is_sioctatmark(pfd);
+	if (len != 127 || atmark != 1 || !signal_recvd) {
+		fprintf(stderr, "Test 2 Inline failed, len %d atmark %d\n",
+			 len, atmark);
+		die(1);
+	}
+
+	len = read_data(pfd, buf, 1024);
+	atmark = is_sioctatmark(pfd);
+	if (len != 1 || buf[0] != '#' || atmark == 1) {
+		fprintf(stderr, "Test 2.1 Inline failed, len %d data %c atmark %d\n",
+			len, buf[0], atmark);
+		die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 3 -- Inline:
+	 * verify that 2nd oob over writes
+	 * the first one and read breaks at
+	 * oob boundary returning 127 bytes
+	 * and sigurg is received and siocatmark
+	 * is true after the read.
+	 * subsequent read returns 65 bytes
+	 * because of oob which should be '%'.
+	 */
+	len = 0;
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	while (len < 126)
+		len = recv(pfd, buf, 1024, MSG_PEEK);
+	len = read_data(pfd, buf, 1024);
+	atmark = is_sioctatmark(pfd);
+	if (!signal_recvd || len != 127 || !atmark) {
+		fprintf(stderr,
+			 "Test 3 Inline failed, sigurg %d len %d data %c\n",
+			 signal_recvd, len, buf[0]);
+		die(1);
+	}
+
+	len = read_data(pfd, buf, 1024);
+	atmark = is_sioctatmark(pfd);
+	if (len != 65 || buf[0] != '%' || atmark != 0) {
+		fprintf(stderr,
+			 "Test 3.1 Inline failed, len %d oob %c atmark %d\n",
+			 len, buf[0], atmark);
+		die(1);
+	}
+
+	signal_recvd = 0;
+	signal_producer(pipefd[1]);
+
+	/* Test 4 -- Inline:
+	 * verify that a single
+	 * byte oob message is delivered
+	 * and read returns one byte, the oob
+	 * byte and sigurg is received
+	 */
+	wait_for_data(pfd, POLLIN | POLLPRI);
+	len = read_data(pfd, buf, 1024);
+	if (!signal_recvd || len != 1 || buf[0] != '@') {
+		fprintf(stderr,
+			"Test 4 Inline failed, signal %d len %d data %c\n",
+		signal_recvd, len, buf[0]);
+		die(1);
+	}
+	die(0);
+}
-- 
2.31.1

