Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB1348735C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 08:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbiAGHMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 02:12:31 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51456 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232122AbiAGHMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 02:12:30 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2072lPRX011035;
        Fri, 7 Jan 2022 07:12:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=PDZN883zYs4dq9Y+Xn0tK95iHAS798QJFVlVRvCyIrY=;
 b=a/5T0l6R/KuZRfWs/zHxeXGp40wl8sZcR4rWheZkEEojV6l7UKv7lhSCOnb9BOwqUvIU
 AvDE/VHRgGXF2I0h9BvUrsi6dBn4ffItnKXWbWfy1r+aGgEEEtFaPzVyNNJQe6oFvMXi
 3PQF4W+59Gjlh3cKOXB46+1ve+qAhsVLNEs+UmJNA7KxkZa9Lqepy/kx2YgFhW0dea6z
 8e4ZJ8S+F9+CRABN7VAlwncz0lr4HDcugRcNvEcLGLr31dbBCMJXKUAnNC3CzkGnheuv
 FaudTySZEgEdLa3IpgqNHqFDGcuTgYxhg75wm8xmJih6dJfi+1fpLr01/eMexEKOxR6A DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4vb99tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 07:12:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20775N3u073453;
        Fri, 7 Jan 2022 07:12:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 3de4vn7huv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 07:12:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwpbFadD6mGSiMpoX7GIQIAt33+v+ukDANTEH5BwwAAlgYKLmxKi0YJuEvPya0Kit5ZzdNldPWjfsRsJWEM4mhJXhshWEW4eOWC5a06rQ0pqCeT1ir5fm/dy3BsRcnqYZzSDizO68xY6CSlKViZFCmdz08rL11aL+WHwFhwk0AscMZU3lCNUiYN49S2y+14OweHur9FmmjcUgp6WOjDG+0IdtOPkX7eHCj8IOZZqfR9LB9GOB9Bzt0s81W/07Yhyvyht3eH5Nj3GtDhseRY+b5fYY8w0a9Yjn5RmWSZAbEqHxZMb4aD15R3G6aSpDGmR3CeIneGE7lYdpM6zQ/vD3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDZN883zYs4dq9Y+Xn0tK95iHAS798QJFVlVRvCyIrY=;
 b=T3V5F4COCr4mpUrsSX6w3/oZdPqh7suGANTZ1dgeTraKPUFjaYfF7rf2lZLkbxU0K7dNmi+RwHIaysf8bzXalP7l3Ma2YKI568+OAs+NCLrDAGwi1qLGRMOOj0SFRWNKMroe+VVUJ00p5o7mG1omYS0n2UsdcY+33Tl/XQj+DuCIc6PKiFaoIswr1ouvkkOmegmrrZsl8kxSpwDEVclMafhU+wvUVI8ag97v/xGHzk6H4pYT3zgHkUbTYWaYsrCyACdd+95qA+eKSmyuoMhWdcWFLuPX5XKtg0vcQASM9B4VuEidiLxa/iucoD61keeS8jeSF8gKa6XmOdRjBxvC2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDZN883zYs4dq9Y+Xn0tK95iHAS798QJFVlVRvCyIrY=;
 b=CI7CKYFQdVn6nnQEwo1uWZKKl55RtSQJtX2BpOSU9TJo+Kj8XQIPp8yVFO2cSGb/EtcI+GJYwFDAo9wLRFTrwOXWMUGhZ9pG8AKjiij3q0l3j0NSu7ZCMHUMyaHEnG/Ax4YxYG/qrl7V+b0WLo6zTZGNjqAecmSLHXjMDscNerg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW4PR10MB5679.namprd10.prod.outlook.com
 (2603:10b6:303:18d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Fri, 7 Jan
 2022 07:12:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b889:5c86:23c0:82b8%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 07:12:20 +0000
Date:   Fri, 7 Jan 2022 10:12:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ralf Baechle <ralf@linux-mips.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] netrom: fix api breakage in nr_setsockopt()
Message-ID: <20220107071209.GA22086@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0193.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::23) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbd5e6c9-dda3-48d8-7044-08d9d1ad0b80
X-MS-TrafficTypeDiagnostic: MW4PR10MB5679:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB56797702235B2B9FB99277F18E4D9@MW4PR10MB5679.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YolkiP4CtL9+3kKjv4rMbFYB3IB+zqmVEbTvaUkaMC+wKSWL3gwxPnhWIk+Zt1IxGigz3UDwFAxG0+sKaDUfBRsV9DhMksTZNIV+q+CtnhqhX9CWXCRfMSEWjQN6KC3iD3QTXLnIBdrDKH534+8hq7e5x0s7MR5EqC/tHbUja5bOsH6mNP1Mrg07tPsfLld92InoMrwgYkzJ3y0pl65Ms6fwaGw+snYzIiXwdRfRdpwVwTcCBhHL/NADaSjw1WDYHl5yMp5x2RJYO+JAUe+OjKmbfSFyD6KgjHkAiIN5nt88UQ477caV5VjXQhSszTtm/8avLr/INkMrkweqvcc6dUaaZFPgMrA/37hIXxeW3/J+oYvl1FDMGGDrdDaEflCsaRm9/HSnou+hgI6TAFHTJ7p+HKlW3E/QlCcyuQy2GB4LWxud/o9up87Xc01pF4SZqzf0KKKQrDZ9cOVAUXbIk+4AE30NIwgbKwogOlQP8kbEKNLNfbqM2RE8hjR5rhL3PSGQZB0O8I7RRwq7cxNBQo2y9IFk/MYLuPB6oDJoWsKTzzjB/qwEaVrzNyDvOdJ652n1jhZP7itVCJcWT7Aq2oa6ebmBTA9SvnbGZAVqVx0jje4pHk5EKO0/2/R5pB/p7JPRKS4g5uq2elaen/qfsEZicz5BNgBqnhHBXqtZo4DTignWc9+9Vrmt4eO4fRjigvvMJiwmkR0sIfB95BJPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(366004)(66556008)(66946007)(6506007)(83380400001)(2906002)(33656002)(54906003)(9686003)(66476007)(1076003)(26005)(33716001)(6512007)(8676002)(5660300002)(86362001)(44832011)(4326008)(316002)(38350700002)(6916009)(508600001)(52116002)(6486002)(186003)(38100700002)(6666004)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XhOiWyrY/fIT7jYbsQ4lSaQNsfP6y1ICwqe+vy9DyVHA4nyX4PJadB4Dbn/V?=
 =?us-ascii?Q?ekHAS2hVIqjXqR8OcdfhgaSf3Trv4pBM8vqHv6ejrWQE4boh/lYYQdGD9bpW?=
 =?us-ascii?Q?BlbiPnXA605ii801CanScPAXyoQ2vaTvwA1n9CTMNwZXjCL5SEPkF5h0E1rl?=
 =?us-ascii?Q?I1U5QB57FMOed05zXnKY+B2vdcj7QVxFCd5AG2P74OzK6bcUovGHH7p7CMsw?=
 =?us-ascii?Q?qBSekgeEl19G9Hx+Vmb9DbwzvmqDZiqOoYE+/3D7UBB2Daet0CPQASWi5cT6?=
 =?us-ascii?Q?j/WwCqGN5B4UKxL3uRmJg6Zc6jBebbs6VFBBARhq+jeanaWJs77HwPpJEurx?=
 =?us-ascii?Q?mon/gRCNgMt04lAtTKUePjCUbX1LyNs//bqTsQwgsbq6U6ywEFav9EK6QQqY?=
 =?us-ascii?Q?ytJFCy3qf1jYNWTvvmG3a5SLGqK+y8vR4jLZMt75WM8vIwSIjmbn1QkGhfoX?=
 =?us-ascii?Q?xc5fC7hzKwHTkK13xK9SNLZzQvWxK1yqKdmL4NQSLHQ+IS2HOOHeikHyQcty?=
 =?us-ascii?Q?yXLfV47uW67uDN4SOz2IwIwGzpFm80UnxLoqpAc4+YWhJCUzebIVPOcyTGVg?=
 =?us-ascii?Q?AUvP7TQUKSntOSPEQ4XEfVNAHyGZvxhVUbrhGOClHK05iY8yRbwO8IJl5nZQ?=
 =?us-ascii?Q?qEGobB06Q7QXTHfauZuECMOkYZ7pyH6pmwlUbqsClGcWRdJM1bPn1FUTYL+r?=
 =?us-ascii?Q?o0uvOk1dqsoQP06zuSB+YfFn7swjJmUFMcbSFIYpNYOJzSr6w21w9tBLMlX9?=
 =?us-ascii?Q?0XuKP/Wxtqqz7ctJK6PiocGliN+Hng3IaDApCnL1SuiT4/pOqKX4xlUoTS6P?=
 =?us-ascii?Q?sVb9C8WKcDltXsu90037R0ifUf19/P7XxtS9//77rt8jOz4kbW+jUIDPmbnw?=
 =?us-ascii?Q?u+yHhEuGqsa7NQ76TbDhpBLNcq3GO3QH3dJYHZ0T7Bk5T00Ft5XY8A62RBjj?=
 =?us-ascii?Q?MCJ0X9Il2v0O0788BySnz/fPjqYy6HdAu/IA8ZLwBNItoHDaTVhd5uvOqIw8?=
 =?us-ascii?Q?yXZhpKbOssQrQBJBzvZs1Gt/QeifXiuax8ZpHY7xWICdpxRrDnPMfOuQJRit?=
 =?us-ascii?Q?2jhMFQ0i55ZA9c+2EiwSffuirawN6Xcsf+sgFoG5zJvyV5T5DcUk4WiKCWQO?=
 =?us-ascii?Q?irr4y4AA0iXgQLmV4h50auH961lZFADZDnL2FymgBLd8HP+29itFYxAJrgwg?=
 =?us-ascii?Q?dIVeBzjwsoOtHrRvMB+lh4TMnz3qs7bcTEOK8cVnHI9qzDR95ZPekbRO2AMJ?=
 =?us-ascii?Q?dxQ9hCWAW3lbAmMOTJ+jCXmBHvmVOJVPtXSCHgJ3hd0psXGsGWW235rVYeuM?=
 =?us-ascii?Q?xxx3K+sIXUljrm2pnf00FsjRnzsa6zMPBBLCiJgqCDV8QUQAjF3sOX3JZ5te?=
 =?us-ascii?Q?PTnlChvBHIoNJMPTQJ5tqPweYXKmE0CEstSpKvR214z/lyoUKO0Jtt9NQeHE?=
 =?us-ascii?Q?oIN/KdGL1icblZrADWnCxh7PRDgonGvJtTFMj7OQ2l2FU8kQNjit30rCsynK?=
 =?us-ascii?Q?fJxUOWX4Aw1oD9dDl2vWC//rCDmeOXRuB6ToC8VxmDAsnI/MDVd9Cq93jDya?=
 =?us-ascii?Q?XAjP0XgCi4QBx2ULX27d8x7hJJXBW2HHPnRGsIcJtGH9zd2WWlN3P3dWpTFH?=
 =?us-ascii?Q?KNepIWGzyDx+cWdzdFJT9x3Bl3XXc0hsuLIelysjt++ap5grNCEhU4HeaESI?=
 =?us-ascii?Q?pLnmPIT9WhkuiK1SqQI6ln02RCw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbd5e6c9-dda3-48d8-7044-08d9d1ad0b80
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 07:12:20.4962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jL8v/NrwYKbYir/vsPtxh3b1MZ5gNrLO0HcAtzUigRdvTvYxY6m4Rr9p97z80qnY1TsUEtR5rNGCsoiZRvvsn4v7jeTE15HudB934A+fOKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5679
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10219 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070051
X-Proofpoint-ORIG-GUID: OK1mOG0WhsefiEewy8fAbox89yUb8Zti
X-Proofpoint-GUID: OK1mOG0WhsefiEewy8fAbox89yUb8Zti
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This needs to copy an unsigned int from user space instead of a long to
avoid breaking user space with an API change.

I have updated all the integer overflow checks from ULONG to UINT as
well.  This is a slight API change but I do not expect it to affect
anything in real life.

Fixes: 3087a6f36ee0 ("netrom: fix copying in user data in nr_setsockopt")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/netrom/af_netrom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index f1ba7dd3d253..fa9dc2ba3941 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -298,7 +298,7 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 {
 	struct sock *sk = sock->sk;
 	struct nr_sock *nr = nr_sk(sk);
-	unsigned long opt;
+	unsigned int opt;
 
 	if (level != SOL_NETROM)
 		return -ENOPROTOOPT;
@@ -306,18 +306,18 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 	if (optlen < sizeof(unsigned int))
 		return -EINVAL;
 
-	if (copy_from_sockptr(&opt, optval, sizeof(unsigned long)))
+	if (copy_from_sockptr(&opt, optval, sizeof(opt)))
 		return -EFAULT;
 
 	switch (optname) {
 	case NETROM_T1:
-		if (opt < 1 || opt > ULONG_MAX / HZ)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		nr->t1 = opt * HZ;
 		return 0;
 
 	case NETROM_T2:
-		if (opt < 1 || opt > ULONG_MAX / HZ)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		nr->t2 = opt * HZ;
 		return 0;
@@ -329,13 +329,13 @@ static int nr_setsockopt(struct socket *sock, int level, int optname,
 		return 0;
 
 	case NETROM_T4:
-		if (opt < 1 || opt > ULONG_MAX / HZ)
+		if (opt < 1 || opt > UINT_MAX / HZ)
 			return -EINVAL;
 		nr->t4 = opt * HZ;
 		return 0;
 
 	case NETROM_IDLE:
-		if (opt > ULONG_MAX / (60 * HZ))
+		if (opt > UINT_MAX / (60 * HZ))
 			return -EINVAL;
 		nr->idle = opt * 60 * HZ;
 		return 0;
-- 
2.20.1

