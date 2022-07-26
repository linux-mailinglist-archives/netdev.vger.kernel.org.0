Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9564581C2D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiGZW6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 18:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiGZW6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 18:58:30 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2058.outbound.protection.outlook.com [40.92.99.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1DF64DC
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 15:58:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HL5rmQ1fWc+0Pk7l0m5QFvErk4if+2FKQ5vJJpuEOKGwpcxzB0dG37R6fklske1xSuCc4T4zboewriG4SSTDMsD9smhojVhQpjQZBOuQhI8Aal/QHGrH68sXa1aCu3J9ZMXdqOCoKsosDm8zEoZRoj7pvX+JxPV9QvCKxQhxqWUWWmSUz3zA2v+DaePtpDrBAVzjAMPhHf08CCtz5MU8Z941/MjUGbMf1aAbQc/w43A6AsB+NAXFMJLQKoAgESkZf8lp5p0qJN7FBOqG1AFFZScj4AhNGBTgQXtjl2KZVsMikIggIyXRntej1ZJpHWfhq9+Il4N6CBIaVzup1bBPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=seReebFxqlKFI9B00p+FxXcV5Me09PZPPRuHbj0q9/E=;
 b=Iu7v+RydrAoSq7UKZsg7W6rA5qrqWHcRPWROUSY/KteYWee2NVwPmNAT24QrtljelImTFf/smdjEWsbWFUoIvfGj/ivYPQjZGytCv+JV543unfY/GwwvYgnpxs4Ptcz+diDlVbCG4sdAJkjgXkAtE+y3KcaMnAZ++RTyxV0ZuNCWp6jONqLNoGTXbjXQSrMzOQepBCWwuP+RbLUGkuxuqZuJlxEABVGiFNcTAQFZzzn1h7KnpRYVzEJQ2Ypw9s8QAqrU+OA3pHl8NffzH9u4npd1Ylv39ijc2tWocQSTKrO/brJ47cEM6hwkRpawFokrP1Z7Gcaa0NBgTAngdlzLoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=seReebFxqlKFI9B00p+FxXcV5Me09PZPPRuHbj0q9/E=;
 b=rJb8EOPX5zkt3GJr1HewnduYE+mvb0azMNIzw8AiVraufbcjuom0sN5g3PQpPnjHjXJmUDPn4dCpahV3fINdBPAjzPJIu9jS9ghkxZWiccF5+naSe+ui9YK6t8bJAXgTVCFYn58YvqzhJO4V2t8R21166fsEuWyxBW5uiD0Fq0tRnHU7ApBAdI37YLBauwIAuuqrENxU6ZEkQ/W+0tHNOT9AnplYor8fNUE/70YzznOxKTYVzeqYlBncW1BsE1wpHPgBuhefImI8LIFB2SuHd90tQc6jfpGMAvkJf3zMu40PEVQxVdzwF/3O2xydcvZX0vly2Eda5q8iCXH4AY/1iw==
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:11a::9)
 by TYCP286MB1040.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:9d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 26 Jul
 2022 22:58:26 +0000
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::4518:830:6e3:1024]) by OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::4518:830:6e3:1024%9]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 22:58:26 +0000
From:   gfree.wind@outlook.com
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Cc:     gfree.wind@outlook.com, Gao Feng <gfree.wind@gmail.com>
Subject: [PATCH net-next 1/1] tcp: Remove useless acceptable check because the return vlaue always is 0
Date:   Wed, 27 Jul 2022 06:58:03 +0800
Message-ID: <OSZP286MB1404946FF81173281D3BF67695949@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [LoO3PKAjYq1pQbrnXpzoktl3mX28LiOL]
X-ClientProxiedBy: TYCPR01CA0163.jpnprd01.prod.outlook.com
 (2603:1096:400:2b1::8) To OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:11a::9)
X-Microsoft-Original-Message-ID: <20220726225803.623490-1-gfree.wind@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ec9e74d-4bf7-4742-548d-08da6f5a5920
X-MS-Exchange-SLBlob-MailProps: qY7UPrLqMbZPLiil6/Zcl9DKvxJb/Y6FEEFH9/FmPc3alYgeQ7wk32cokelBJEIDXx+v14qONyuE7furdjyq4FLjdhSxtYkQPNzuJb3l9ZpXVn3fmmDksPtqBf7hWgSvPrB9v7i9c7UsI0qjEUoh5F2w7g0YIA1KC5AP6bsd5jyhn1nYLWQMbl4NgMZQww+N6zptQqhqbiejCCXpNAEiHJC5slKABS8RBoORdkgt4JSRDw5NB4miOFE4ZxyyadBzePmM6x7sqrJK1gOl7V1btqI7bwtffPvWTt5/gsgPniRMRpbFerGGvHAZT73mpnpyCMGCQavumgTpgOmD73xMxp98i9zmAhkjaays39/iBo4Co7Ebr7cp21aqK0lnAU0Z7ZOiI+I/1XT5lmNQUilXYTwCac0NtuEK9FIke0IDc9NyDSQuwzqKksqykiYzNQ/LfNnr7IpamL5HWlavq/kVNzHi2fqCqfF/RgfwWEgfP3A3EAwzInvZB3956U6xiHrzxGu/iRQWUc9PuaQP9PL5gGPbQaGYbps7GR8AZO2dfvXAubXdoNFR5XIOcSn75Hn5Gav6prry3EsglqdszNYvtNnJU5S8yC9iuomte1Ima+6LVlHBEycpIR2aIQ+++aJnZm427CltG/9Xl30dT0MlgD2bUf82uD1PBI1Vrygp0KRQ7tvL2ye2BndgscGKyXPRIjkNBhV7h1Tt5Ajql6Qkvw==
X-MS-TrafficTypeDiagnostic: TYCP286MB1040:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCm43k6ApfIzdwvH/VqHN0qAITszXRZx/Ws+fzLZ8R6AQhTb6NlAgkVh2w4LRi3FiFrs6+tOEpZcB13rl6spdBtLkm45Nm8gK5BLYup5zAwukC1ByLrJhhZf29+36hfWnrtw0b6ZTC+TiR6+4n/zvS5/6yebPZhYmmRDA/KH1P7NYe85VFu5U20mQCxL1vonI8+5wVyXPTPHvKizU4nxvyHA2KTnzwo3aPfQUxhwVm36K3JmWxLXEYEI1DHFAWf0j7BWK0kCL9h0eb6stcAcVmU98rivFHrGFjeWNyos+3WgWI2ZzvoiSuQGqRLjfdw3OAOWTkde4WPm1qauKLWY5l0cygAVtj9oRmivhtQb1RNijzr/cekhPoSgyHkNaQ1KBOLF+yWFps4dT25TjYMYXM0VtC9BXH4fe7yOWgKAO9MZiYwro9N4JhLw0a0s6STJw60P3zvcTmAC+v0Pgo4CHce2eR3KHkUOKguf4onY5K2IsgLyBH9wtuXLrGC74W9+AZdlZFXK519Eb8gXBBgj7oMLdJ19KD0KLjFLDgfqYU06a7wl03psYsbODu/ljZxymAIZDoKxHOjY+b3x8IUdAJLfYMlp68rFyhF9ptXaKAH7HtDJd1YfaFqucv6H5LXyX95Trnqf7zbonDhyTQqO5A==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fqmfoWkh4YbikPC4kOOByoLQA7tBNe9R+KMS9wytIqeyztW1FY4C2FmEydW4?=
 =?us-ascii?Q?osen7OMtpt+ja8krMvOLUJCsr0THWrEFCT+es+6JrOfRo9cOskGhVXcnLeEn?=
 =?us-ascii?Q?/9s5BNKvsRgH6mSqHj6Cu+MRqkMIpkiXJNrCaU0x1euZvXPMCqnxrof1Eimz?=
 =?us-ascii?Q?bl2fIbBXEl9wHsso9BhRJtXURrNgk8h6n/GzC7be7YLQspmh+b752tOG70ZJ?=
 =?us-ascii?Q?AyWytlx2HrthHCjfv/RAyVHM8g5vT1YdFlZ6Jg2WrjhoPoECLRP/O5j2v+2g?=
 =?us-ascii?Q?BfWgr/6/ZocYEPnMWZwB5CrrRaNqWC4HnGAJcQXwsqr95YuzXxnl8wqDZgq8?=
 =?us-ascii?Q?3JyrWZ3vJdOKYAuGB/JLYMXPUSOXV1+mOc4QPRjtU7sI9cuEe6CHGMA/j5QP?=
 =?us-ascii?Q?szk2vBuZnyQRTESRcykoFR+eQYVRNY+I9HgDx4os1Tiee4ww4O8U9+pqkNUK?=
 =?us-ascii?Q?VW5cSzQY77EoFzPn5KA/2l6Zazuz/SKd9bgH4+deg9lzlODzXe1ltNERDaCJ?=
 =?us-ascii?Q?fDGyQUVFcPu//NrhnGUilieoVIP3SYf9lCcX7+iZQT1e0IEZxvWJdUgyuwlM?=
 =?us-ascii?Q?MJsAyn5hlZF3aU3ctRUvvr3qEH2cHmB9PMKhWkR0MtntfsoAqzaLd2m3we66?=
 =?us-ascii?Q?X3fCS9qiETJeEwLH7ICydU0PkMfIkL4LaMhxtRn7RwF+lr/qxFAlWulcw7j3?=
 =?us-ascii?Q?gy7xA5VU3rZyuVpRWVxHVR0E6xf0O8rKIqfX00zpnM7eqOTkaT0t7kLj8ABp?=
 =?us-ascii?Q?SEFReRnVaTWsFcdqMyU2mK5HUXwpxgINdGpjCRBbvbWNuEokRIrcPq3V/TAA?=
 =?us-ascii?Q?m2l9cGOu7iHrHqBOebIEdoUvGlm8NszwpiqSJwCfQ2JIMgGBbefwfw+WJWqH?=
 =?us-ascii?Q?4YubRwPbFsChQrzyCeIT76WsRFcIw3Rend2C5P4CEM7I7+hdkRyuZkMXe497?=
 =?us-ascii?Q?JyxheDXY7T5O9X0+zX+tPwIs+Pn5x/7e7uvC7YwR8Aid9iuvkqxn2gveE1BN?=
 =?us-ascii?Q?ec2WkKa3HWeeZGKFvrhUEWoHGcDaJ4mTyQkLi+pTrXWF3SarugT7yMBBY4W+?=
 =?us-ascii?Q?XumV1POAM4uTtCoDn5rVhCISz1uqnY58dxlGEOp2+vHgB4gs1oYAsO15dEf6?=
 =?us-ascii?Q?2ZU45AbvDe5gNNnVCdDQUnmXjEKsc8yOOUk4FIImEnTUX0lN4M22GYGSYVIn?=
 =?us-ascii?Q?qJYlmxK1mi9E/CDxJW2045ga6TTmVyjxmXKiNfe1j0Q1AwF/2k3KTJnuh4uw?=
 =?us-ascii?Q?klDgFXk9nCEiVlMVIubSIidtRwYL8+TTWBeP9eiRfA=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ec9e74d-4bf7-4742-548d-08da6f5a5920
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 22:58:26.3273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB1040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gao Feng <gfree.wind@gmail.com>

The conn_request function of IPv4 and IPv6 always returns 0, so it's
useless to check for acceptable.

Signed-off-by: Gao Feng <gfree.wind@gmail.com>
---
 net/ipv4/tcp_input.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3ec4edc37313..82a875efd1e8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6453,12 +6453,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 			 */
 			rcu_read_lock();
 			local_bh_disable();
-			acceptable = icsk->icsk_af_ops->conn_request(sk, skb) >= 0;
+			/* TCP's conn_request always returns 0. */
+			icsk->icsk_af_ops->conn_request(sk, skb);
 			local_bh_enable();
 			rcu_read_unlock();
 
-			if (!acceptable)
-				return 1;
 			consume_skb(skb);
 			return 0;
 		}
-- 
2.25.1

