Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821EE4472CE
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 13:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhKGMH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 07:07:27 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:4390 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234600AbhKGMH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 07:07:27 -0500
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A74GFx2021509;
        Sun, 7 Nov 2021 04:04:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=proofpoint20171006; bh=SI9cKQSvS6cr7Jt6EhWAcns+ZCJ+BCjW15vJi5cem64=;
 b=Xa4OpYeCQmck6sCl8XSaGo/mHwV0hLaNEDCXISudMX44noM0i/0JMNkdz70kr1KCSunl
 bC+Qq7XQaMBhMJwYyv9Cjbiyum6chtpaaQDjUc4r4nfGM05tUi+MR5OTfVv81h8j4NRV
 m7UwUK7t622D29wHtfePaLi5BMKGNlNfWgYa9cXIEWXFQjYnkV/Lfs7igg1j15bfN52v
 i3ybffCQi3Fe0iy+kEZtKsoKvxPdmjGjyDiwSYE2lZvM7FTMx318M386LvOE2/YLtt3b
 461sWl91e9Ps23uSCeWtqAxcZdbvqgps9eBIm9edaJw+xnXd80vE2npCUnD2W3DmJdit yQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3c5p1vshsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 07 Nov 2021 04:04:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkVQ5m9mbo/QGeJKA7KkeqShDQ6jY/mXppqDhkrl6KO5BCOGIgn+i0AmgSsdbz/qoGprGt9KHFjBNqT931iDIsZw3VKm9sZfCmUhuGXkl8AcnTQSZf3NcDQasAXvHh9r3DSRlpMpaXX27EkSLQbVyh2OdM0ysGZN+k3u26HQ2brKsTUScF+Pm107RgyjZlZyUL1Xe/S094c1FDaif9Sar3h8HyIVXTAu+ZbeHu9MgHrccVVeTYv5d6C4cRDsjCHcfNoR5nZ6ThV12sUqYPyq2VTekdruID/irClcI7rYfn4ESHkZQ8UUdi6/MjVtdS53Y8pHT9PsMSNvkUo1os71xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SI9cKQSvS6cr7Jt6EhWAcns+ZCJ+BCjW15vJi5cem64=;
 b=bXvuHSW665NzN1ww02cZgL3JXO1CSwU1KDZndUgDau+BBLZ0cUwFfNx0MCvP4dZvK4ZPmHfXVpvfwDy61bw6PyQpIHtn+iDO/WZyxHaQTqv8uc/4LuNfxPXm0+yVCQBdhTD+tTudSv6RlzvyoHDuR3bKBr8PhaB4z0PMvv7piJu4oH1XVzSQ5PzGRusR+o3UqEQFkJghwr0JmLeqbtzO3Gh5vGQEegx15TSS5TArnmDToa4oAKEjDieoPRvtfI9Jx4ga4TKKKYkS8urKkEGmWCix7Mek+kyJ2MJXkUx4na8Yzg4IdFyI6zparS1iBpZGMQX/CaAZPqFbb8YvJium7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nutanix.com;
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH2PR02MB7046.namprd02.prod.outlook.com (2603:10b6:610:8c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Sun, 7 Nov
 2021 12:04:37 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::6448:2a3:f0a9:a985]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::6448:2a3:f0a9:a985%5]) with mapi id 15.20.4669.015; Sun, 7 Nov 2021
 12:04:37 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [PATCH net] vsock: prevent unnecessary refcnt inc for nonblocking connect
Date:   Sun,  7 Nov 2021 12:03:04 +0000
Message-Id: <20211107120304.38224-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.9.3
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:40::42) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
MIME-Version: 1.0
Received: from eiichi-tsukata.ubvm.nutanix.com (192.146.154.244) by BYAPR04CA0029.namprd04.prod.outlook.com (2603:10b6:a03:40::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Sun, 7 Nov 2021 12:04:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7386f9ba-e045-41bf-d579-08d9a1e6c51a
X-MS-TrafficTypeDiagnostic: CH2PR02MB7046:
X-Microsoft-Antispam-PRVS: <CH2PR02MB70466DA027EBD5727C615D0580909@CH2PR02MB7046.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xfaqCLCd/ePPFVdFwj/Cd/I8BdsbLTsFPAOS1MfbyVntJs3HNfvx28vzvyxWtSyKrvGCGdFMHKTaNhKTtvUHIt6vZ4MCiMZM0gcM1Zs94sziSNkePUMsDjejyhuPjGesTg361tCZ+LLQBSzYIASsqHXpksQHZlvsuFVcWdpCXqbVpOb/mX/hefluQ1AeetG1Y0SGT1n89Jb4W0aym8/C3mwY40cXyJ/0FZVZYwjEsx0yN5Y+HRPpH7mXr1gTPq2CQLHM8hfUzJL9aHkCBRtqVxlQ+IlWjDBAdMcSInfYffgYWtckbm5IS7Cf9BqHgsBxZvrs8M2V5LGTYwQT9yAppgK89IxcJ3q0XTmR+PpkzD+l1xUlVmCCOh6v8WFX/Sa17BumgpcMPrjlPc/+h/EJ5iBvccTlBvclvtz0fHCYJ6sYSMciPPadPnBJwkc5+/1pnhZb0jSRiSsXSibtVk/879QK8PaY3/+eFKHXH5KI1x2phD6NY4RezqfXLsTElNItQWuLUPP8rktsyWyJGw5uqYHqVaa5W769YJMHzmzm4WLM14HkCMDZmNbQa8kh0pRC3iHT0OAS6/HB5why/nK2DY/I6mwQ3oSkuBFmZvAB+IugN22jLFW8Rndoh5YsCq1SQt1sHyIrr8GvA7pjTq8atU/4okcOJRKWD8g94lDJYLFYhdIfSAA5ZFaPsiNvstk2L/8Mi+Dt3jZj3bnZ0Lxu/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(66946007)(4744005)(52116002)(2906002)(36756003)(316002)(26005)(7696005)(66556008)(66476007)(86362001)(107886003)(8676002)(5660300002)(1076003)(44832011)(6486002)(83380400001)(508600001)(186003)(956004)(2616005)(6666004)(38350700002)(38100700002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tuTMez+XieEExYjgLVcpvj80l6mz2NEwtnRVqzZZmH3xypcj+ZPQZA1uixhY?=
 =?us-ascii?Q?hOsOcqOd51ttFCvgu8VXKecWPknDhBES8TfhXWN/ckXeBEhS2ffor8t3l1ge?=
 =?us-ascii?Q?WApyd1G50QLUj8Nfc5E8bNT2asZLXNl1hhYKWZrTU9bdVKW+Rv+WWIHJpqtI?=
 =?us-ascii?Q?R4wTRp89peBBEHr/4qyX89bM9IG9WYxnjRV2Df2lxIJ3F+QjVhJvD7lJRnDJ?=
 =?us-ascii?Q?tyYkiM7LKX+07qDGpIyB/xDoLGySijIgVNC6fobbn76VhqcP6vKPYiHSefvl?=
 =?us-ascii?Q?fj+MP4I7Y/PH39U1aHMdMwiSx77pllqwTEFXpSpEeTyLQ0wZoAVqXneky4t2?=
 =?us-ascii?Q?i3qzeA1Trput9ABLBPIHfxv71mI7eUIuQBCaPcAxWYOqaknbpiLIRu2viwFN?=
 =?us-ascii?Q?K9iWJ8dX+MmG34UcPLExkXcwZkbsaA0T0vOkH56jXTLFp12+U9DbERxQ3xGV?=
 =?us-ascii?Q?zZtwRGACfZNo10+Mb9b7VIL3hcGQaXy2uyC2ui7zh3x4r3p9EfyYOWmveOc+?=
 =?us-ascii?Q?I0qZJuf796RBfqM48FqPEHTMYe9hbCIxoSQ5LFQ2gC6zx83OrK+H0zoWmDpr?=
 =?us-ascii?Q?4RZh+cZfv716rdZ2R0+A1clWEpv8mYAAoY24M85+U5AHy7mdbB5qOBNniQhp?=
 =?us-ascii?Q?n80cz5wIbogjAoqJ//9fN+9PtgMC4MKbpF1B++aij2tqgJSvOHrBZCkpfPQt?=
 =?us-ascii?Q?BDZZefhigcIUbpfLNUwIYUVaf3Lg8+uPbKYhkZEg7ulB/mWQpA86gudssWNy?=
 =?us-ascii?Q?MKMnnMN8Af1o7aHEhYfhmJ0NSSeBabhZKwZv4m6xXI3AxA4cTboMT8k3EBSq?=
 =?us-ascii?Q?vguvX4P98NNZGZYUxQ/y6R6WC4uXThjCxJuXPMFnVGASWuulESzzaxdR08Q+?=
 =?us-ascii?Q?76C/PLhhRVWgynEygEGxC9QASHrZSsr6sZ5QECTAN6mq0uX8HIiXQC0+Vmr0?=
 =?us-ascii?Q?ge80uS0rBMb6sNyVh+9yG3rQM/8qqHL4Ny6pIL7HI/j8D3PuJAx9w6mfi63u?=
 =?us-ascii?Q?c1GkI+gscCC0EdfP893IXasPV8vX293/5nOGEL7Qneq5qanQUoSV6oyRQ+0x?=
 =?us-ascii?Q?+vngxH2XdXUPKyS9OBxwPV+auE2kdWz0T78HXetNy8+i7Q/q+NyTHX/MRfzy?=
 =?us-ascii?Q?CBgcz2qlT5k3/38lZfNAZju8e+FPEYStSmTWZUXEsVH6kBkJ6V0alhrM2Z0M?=
 =?us-ascii?Q?2Eu+MLsw7RXu85OtwVA8//Pb/+nROca6UiAnWYwsvvlgeSWMVoEkCksmtbra?=
 =?us-ascii?Q?CNVtBInX/p6iDecIQV/GAv6HmX0HmQFKO/HT/abkSjjTv0pIhDMSjj/C5wa6?=
 =?us-ascii?Q?AZv8//P7icX2FAsmkHF5Paclo1a9BmNhvSe0jZ8ZUmvV0UMgf5cmN/BGmEym?=
 =?us-ascii?Q?W0V0akdSsjEO5NluOQKUlcdRFoVqZgIktKIDG+N7utCK5pWvs5BmFqD4/9v+?=
 =?us-ascii?Q?mQDTO/tM4ebqWmuR4Fqmj3u8UW9gBdTjNcMKmn1ANw6MLzeK40MRQ87HBkN9?=
 =?us-ascii?Q?t1YUxwHDw9Yt58t9UAkbef3TxeqkOr84+FTcqeRg0XIvYyt27YNETUT3DgmY?=
 =?us-ascii?Q?uA4Lm2vStMkp5nyKkJLVXe9pM5zJrIrbfrN/3Jw7kXy7gRDtSiGzz8atyJWd?=
 =?us-ascii?Q?pkt9Mz2IZtMH/4bOpMr78h21lmp2HYn9H8o7P+VhnNE+/G/Av8iJiTsDwvuC?=
 =?us-ascii?Q?4OfcNy+F6FiPXX9E9EMMgilVkKs=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7386f9ba-e045-41bf-d579-08d9a1e6c51a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2021 12:04:37.3206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvFZdYMACGMhBAXiD4yyJtxEn+lxY2w6m8F8+dlnwbLAHPgT7pbSewlqmFvbCkPGFhErokjNGHXlFWMfRXyWZZKGoipf6J0fFII0h5gn8tY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7046
X-Proofpoint-GUID: KShWEJux4iNfJbuCtbg0YSuyL4ze5pg7
X-Proofpoint-ORIG-GUID: KShWEJux4iNfJbuCtbg0YSuyL4ze5pg7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-07_06,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently vosck_connect() increments sock refcount for nonblocking
socket each time it's called, which can lead to memory leak if
it's called multiple times because connect timeout function decrements
sock refcount only once.

Fixes it by making vsock_connect() return -EALREADY immediately when
sock state is already SS_CONNECTING.

Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 net/vmw_vsock/af_vsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7d851eb3a683..ed0df839c38c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1322,6 +1322,8 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 		 * non-blocking call.
 		 */
 		err = -EALREADY;
+		if (flags & O_NONBLOCK)
+			goto out;
 		break;
 	default:
 		if ((sk->sk_state == TCP_LISTEN) ||
-- 
2.33.1

