Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D791C38CCF3
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 20:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbhEUSJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 14:09:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238562AbhEUSJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 14:09:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LHthe1110973
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 18:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=c9uNTmSIbhLmICLtbplONKZlHgZdfQWO9/NPe+HMGV8=;
 b=I/CSkK4CrqQy53AGCwI6HLVvGl+oWaVExlbY+YcQIazkuYy3a63R8ZCtMiuWQV8qCD8O
 d+XYjExIBEatc2S0sr3a70oTbsNuRHBRwl6lZOaiOa77GWkN/L2KiP94BERLAdH6sGwG
 +yWy2zR1TYg6i8c4FJ0wFmWXjJonQJYARr+6iafQI8kYOwRzJDmuXYO9VJJhclYYd9HL
 2vmF6eWQZ/kyu6EDBG/9Ksczn7LHfcHe5ov8K0oCDzK5zt80wncone8vN1CHlLMyXYNf
 JuRy/OTshYzFxqEbIp6LmE4I83A3mOmmbh7SCwI+m3z/Nb3orEnRIDCjZxms4eyN36Vr 2w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xnrbq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 18:08:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LHtgpD010539
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 18:08:17 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 38n4930tdq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 18:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldNLJkyP2YRfJVr74HqvzvW9orWygFcrIOMgLFzbdMr3cBFRpK9ZS76ynCbkO49dQDsLUDRMq00v1nPjkzdoL8PmOU3ubqJuiEz5vA8skXn33qfA9s6nW12m5AJCAbMJrRW89A1/Wsl5uZ2GqIxAF0sO3eG69aKY1C8Nawje32lP1GIRdPCQS0Z9TqFVzepkW9aNB7kH49W2aD/H4h7s3HMoJRKCLdtnFdYYBA6qhmIr6LC/1DQ6snMbLDMysYV6TPXGrkEd8xt2Y0JBw4E/2R/P7vDumYt/TqTVKwnTfYuhrjCyXnxF7ftsorUSRufWNv3I2dV0rYRohJ2ji0JYoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9uNTmSIbhLmICLtbplONKZlHgZdfQWO9/NPe+HMGV8=;
 b=dFJWYYpX+zJq5PnXRBJIx1nc123blv1djM/Ps4QSZcSDtBoxq/57c9Ib1RNwXi+WC+Ko3/bdowtbjRD0m3A/Q07siACP9cC3Ife0LU9bb6VmIxFjzkHiX8qrSN7/HQt/BEfS+1uImuQJMvMCO5b6J04auJDmzpRNL9FDCjZ6X1jkkzlotuLHCq3X3WSWZ1htKmNTYwLXpOsTEgs06ZvKI9K4EKvfvke7mokg/CyGf0vl3lFAAKoGzvwsAU1y0gy/5Lvtzku9gYSMAJEGIRl3LEDDngfUohZyZeyzfKTIvPkhrz+GJ8Mkf46RhTxru+h39cNnqWPy47zY63NdrjoljA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9uNTmSIbhLmICLtbplONKZlHgZdfQWO9/NPe+HMGV8=;
 b=EgRxxfUnlKxhCgQMG5ACc0YJ8uTCcaphAe6e27H1Q2C0Qz81z9NTIVesb1aUxWDwp5aAl5zZTCt/wFTg6gcmDhw+FoBgKehlcK23PzV8o1RnXC3xa6FzflVKhDH2weATRAKtxxPhgUK4OngVI/3ezTl1+R8WsCQpHB50FnyY/S8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB2517.namprd10.prod.outlook.com (2603:10b6:a02:b4::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 18:08:13 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::103c:70e1:fefe:a5b%7]) with mapi id 15.20.4150.026; Fri, 21 May 2021
 18:08:13 +0000
From:   Rao Shoaib <Rao.Shoaib@oracle.com>
To:     netdev@vger.kernel.org
Cc:     rao.shoaib@oracle.com
Subject: [PATCH RDS/TCP v1 1/1] RDS tcp loopback connection can hang
Date:   Fri, 21 May 2021 11:08:06 -0700
Message-Id: <20210521180806.80362-1-Rao.Shoaib@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SJ0PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::10) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shoaib-laptop.us.oracle.com (2606:b400:8301:1010::16aa) by SJ0PR03CA0245.namprd03.prod.outlook.com (2603:10b6:a03:3a0::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 18:08:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0853ef9-6d99-4a87-c5d6-08d91c83660b
X-MS-TrafficTypeDiagnostic: BYAPR10MB2517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2517430120DAC32546D370A6EF299@BYAPR10MB2517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uhQRkGGYyQn47PkqGMtnAsEjmg/Sn3ePBhbhqAFlgfIJuUm+3B2TyoIjKcRF2rd9S7tjflwiv3lAPfldNCAZ/YZrZ7mie44OMoOGe6cU/GQqrH2sfQSZIARpkQ3hLnfkQSmcqVW7fiPSnHXfrYd198w6PM7QFxIRUwqHXIJTRVIHwJgPVxeg24ySjZbfGExNw5Imu1bkxIW/kCR3q/2R4b9RMjOkKFXePfDLlzvd+0g7Ocfy7y0GJLJ7h+peJ2cIrfoXHi+TMIAH4zg6FyYemKZasfGK7szy8ctFj43xkI8kclj+Q3+lU8gAlZLTVgCXxocxeq2E3sDsY6MjdZa8d0NpVjvCZN1QXKVLq7psayoS888Eb1v5KqWlQ8pQqO8qahCqRnzI6y30vFPSD2Uw24mdQPGi6ejVwYRDzGyBpfT99XJjfhCpG6GelEuYakWuts/AqySDY91wVqEVHmY5grNToIiGFpUjUAzlXIN8NDhLj0pL3Te4CZRv8JxmJ7KQ+5YIVl3PzOzoVWvRCh79SJtQQNvQoL8nllpFD+JS00YQDBP279JUn56U8za6BtJFKxOR5uogT2zARMgT4Zvj0meib1hFhwa9F5WpbJTRQUk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39860400002)(346002)(316002)(7696005)(52116002)(38100700002)(2906002)(83380400001)(6916009)(6486002)(86362001)(2616005)(107886003)(16526019)(186003)(4326008)(8676002)(1076003)(66556008)(66476007)(478600001)(66946007)(5660300002)(6666004)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RNtXTDodiHfg/Y6iFXEI5N+L9Wf2Mg9o6oow+3gKl863qzf7+IDuYkXtjAO5?=
 =?us-ascii?Q?jJQ3ZEp00S8tBPBEl/CO83KU/seQu0ypd/UX2+GnVbig0gHfDA0JzhNynKCn?=
 =?us-ascii?Q?W2KksmcKQFY0rROZJhWzp6mc1rnWLuaeK5242rRYUcCp5z5afTS88zDXHJs1?=
 =?us-ascii?Q?hNKOJ5FtUb1O4Fn+lwWlqg8GNDksgUU3bOee99DBvHcsWcymUb1quTTLtOTZ?=
 =?us-ascii?Q?cloyVpt31yCa5QPYcfuVROJK6DERXSFJRo32czNYMLe5TspOuqaXTcNDkKEu?=
 =?us-ascii?Q?yH6/rBitE9ofHYviXJESKLKQJzBIlKPZKvIQ3Ius+lgZ+DpQrhBAGt+DawrF?=
 =?us-ascii?Q?cqdgipScaF7w9YA5thnLlcBIpG9TECcbnvigDyoaXNqUq/TfJx++46el1qkD?=
 =?us-ascii?Q?REZwyDuMsnqCJbLVUd0IGwOAB+pplvKkKZ4vmdMvwdZEZjVhvUJ7wWLID1pA?=
 =?us-ascii?Q?7GxIqnJpWbf9hjmbAy6aPF0/ppMCAC6H9ljihup0VHvXmQy2PR7oYRcdLye5?=
 =?us-ascii?Q?hXWZgS39Eil3lW/Q1HQL9aV5sv6A1wx7GRGDvFxYGp/AOt0RCok7VA4lZtNO?=
 =?us-ascii?Q?wrGg4mAk37yqUYCudJI0XQHUSTf8nfvMw7q8ogEgbqPTLaD3ofn230P8UHBx?=
 =?us-ascii?Q?krfg4PvpHJiPobkvh/uVSIgUqsczy1LrSJXC8wJq1nBv5VI4wKn5LZXdjM37?=
 =?us-ascii?Q?xpWTQpDeD8Jru42d0pAPdGp8RWyena1SGFWiq2RebpCt6ywSVRNSTC8JC7Op?=
 =?us-ascii?Q?ENsw+pfImVFcqV9qiGQsGOoni4aK7KNqEwSj42Tk5lr9WOePpKaOSimQA0J+?=
 =?us-ascii?Q?HWNrlPMWw5XqVESHzMOH66KK4WbjkMcWEwO1v+VTI2XqjHVcU1ZmzfyY9ZWN?=
 =?us-ascii?Q?7qMG4PLDwlNyAtLrl2JY6VXWTX7yoq5M+rkzaETnox1x+19ZBsGftYP/x+SB?=
 =?us-ascii?Q?dIGRsCUcn8UVhbNVLDXDBnqtQ99e9arJhW1vrmp+fqYatuF+CzYmmpxC5ItS?=
 =?us-ascii?Q?cPpckITRWNKyw3nzvHwQcm6x7UkLwZEAUl44KLfSYQPqc4hRQwxwqbFFWxbK?=
 =?us-ascii?Q?G1pkQWD02kA4rc3wF2DGYBBWIo8XW/bMJ6/Ai9GGuqg79EZKr+cD7FiJ7WSS?=
 =?us-ascii?Q?5EBpQQ0p4buWTtsBVeg9P6T9o7kcaafvHWb2lrcbjCyS6G3FRE/k3N2IScSO?=
 =?us-ascii?Q?QilWsyY0haI7cEZRV1DA4n1Y/KPe6i39DGIdI2HCD5nCih/ubm8PgmqO1fzx?=
 =?us-ascii?Q?sVf8/ZoI8W6I7CSvVetcSVsJGjHYc7i/9RwpLCwmbNPpmwAHfKkqjT5aCfge?=
 =?us-ascii?Q?cDk2aA54rGZGmXqE8pNPGZzAGJX+FhELmZbJ39bN5gASEA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0853ef9-6d99-4a87-c5d6-08d91c83660b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 18:08:12.8863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MP3i9AI3Mm8pTqC64Cs8pwaH+ObQZcUgEFxCFNxl8h/E3XMi/k/qhlYX8fIqynIHPYC0b/Pynpnu+wM5sPkAJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210094
X-Proofpoint-GUID: Z3Q44PFvseSoarncbKifiX4CNMoj7C2M
X-Proofpoint-ORIG-GUID: Z3Q44PFvseSoarncbKifiX4CNMoj7C2M
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <rao.shoaib@oracle.com>

When TCP is used as transport and a program on the
system connects to RDS port 16385, connection is
accepted but denied per the rules of RDS. However,
RDS connections object is left in the list. Next
loopback connection will select that connection
object as it is at the head of list. The connection
attempt will hang as the connection object is set
to connect over TCP which is not allowed

The issue can be reproduced easily, use rds-ping
to ping a local IP address. After that use any
program like ncat to connect to the same IP
address and port 16385. This will hang so ctrl-c out.
Now try rds-ping, it will hang.

To fix the issue this patch adds checks to disallow
the connection object creation and destroys the
connection object.

Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
---
 net/rds/connection.c | 23 +++++++++++++++++------
 net/rds/tcp.c        |  4 ++--
 net/rds/tcp.h        |  3 ++-
 net/rds/tcp_listen.c |  6 ++++++
 4 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index f2fcab182095..a3bc4b54d491 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -240,12 +240,23 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 	if (loop_trans) {
 		rds_trans_put(loop_trans);
 		conn->c_loopback = 1;
-		if (is_outgoing && trans->t_prefer_loopback) {
-			/* "outgoing" connection - and the transport
-			 * says it wants the connection handled by the
-			 * loopback transport. This is what TCP does.
-			 */
-			trans = &rds_loop_transport;
+		if (trans->t_prefer_loopback) {
+			if (likely(is_outgoing)) {
+				/* "outgoing" connection to local address.
+				 * Protocol says it wants the connection
+				 * handled by the loopback transport.
+				 * This is what TCP does.
+				 */
+				trans = &rds_loop_transport;
+			} else {
+				/* No transport currently in use
+				 * should end up here, but if it
+				 * does, reset/destroy the connection.
+				 */
+				kmem_cache_free(rds_conn_slab, conn);
+				conn = ERR_PTR(-EOPNOTSUPP);
+				goto out;
+			}
 		}
 	}
 
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 43db0eca911f..abf19c0e3ba0 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -313,8 +313,8 @@ static void rds6_tcp_tc_info(struct socket *sock, unsigned int len,
 }
 #endif
 
-static int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
-			       __u32 scope_id)
+int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
+			__u32 scope_id)
 {
 	struct net_device *dev = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/net/rds/tcp.h b/net/rds/tcp.h
index bad9cf49d565..dc8d745d6857 100644
--- a/net/rds/tcp.h
+++ b/net/rds/tcp.h
@@ -59,7 +59,8 @@ u32 rds_tcp_snd_una(struct rds_tcp_connection *tc);
 u64 rds_tcp_map_seq(struct rds_tcp_connection *tc, u32 seq);
 extern struct rds_transport rds_tcp_transport;
 void rds_tcp_accept_work(struct sock *sk);
-
+int rds_tcp_laddr_check(struct net *net, const struct in6_addr *addr,
+			__u32 scope_id);
 /* tcp_connect.c */
 int rds_tcp_conn_path_connect(struct rds_conn_path *cp);
 void rds_tcp_conn_path_shutdown(struct rds_conn_path *conn);
diff --git a/net/rds/tcp_listen.c b/net/rds/tcp_listen.c
index 101cf14215a0..09cadd556d1e 100644
--- a/net/rds/tcp_listen.c
+++ b/net/rds/tcp_listen.c
@@ -167,6 +167,12 @@ int rds_tcp_accept_one(struct socket *sock)
 	}
 #endif
 
+	if (!rds_tcp_laddr_check(sock_net(sock->sk), peer_addr, dev_if)) {
+		/* local address connection is only allowed via loopback */
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	conn = rds_conn_create(sock_net(sock->sk),
 			       my_addr, peer_addr,
 			       &rds_tcp_transport, 0, GFP_KERNEL, dev_if);
-- 
2.31.1

