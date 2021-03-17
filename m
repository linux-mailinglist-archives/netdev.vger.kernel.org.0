Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35CB33F81B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCQS2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:28:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35608 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbhCQS1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 14:27:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HEnwU2160944;
        Wed, 17 Mar 2021 14:52:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Kblu0PdHDwttwuhg3lKUhYdDVPZzOCVzekk5p6aED1o=;
 b=hIe4rTl0HUZ81QxpXQ8ryRmOiHczwkjr5WgdmUl6/drC5hWYeWhwcjUBO1N6DVHyQipV
 yLwTmTXMEY3WcYRVZXF6yTVCHUZsdkX8cdm42nj5Gb6FJtISn0ghVdEYuS87vyZjoiGK
 UPSPUOkm7Qg6HlqrGOlqQ9Q8qc7CeUPC4UouZmM8wPgaMPbXve6iypVEa71SFJRxdBSP
 qXzH2nGAv95I9wkuoZaIuFtFEt9qsSLgcGiUsodazaKxXRqXjFsIAY0yK9Jl79kQFhR2
 kjpsnADtZwohgHfM8o5IqoypiYIhU1YLFrG1BZJAUUPDYA3cv7yqXUU+yMf5kp3Mmeli 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 378p1nvacx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 14:52:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12HEp14T156983;
        Wed, 17 Mar 2021 14:52:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by aserp3030.oracle.com with ESMTP id 3796yux4f8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 14:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtDMI6m8ZNMFCQ7Zx/nGS3B7Gnc/ThA5djja6srT31GGZ2bboBgimLuEeFooqwpax7La6WBxj+KPgW7lMjwAiJdf71Al2azTbFth/6brg4iz8UYmLyOmxioLVe5p8b2hQna2m4i8Xl7ifBnCeCpTDtYE7dQjLOM0HlSFqhzo91bGdzjOtauZez6FOnXqkEzfDUa7/lNO8AgvytdLm/8uURuR/Y6DM8YKU6QVR56gsBuYgyITffWxyYGkHoa70+JQ0nHSyPrpFNQ7aomjoaunXk2l6+rBVhhlJXSry323rF0ycfd9T+kk93cmREZsfOfbk9sXo29+QG+5yZEEoa/EZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kblu0PdHDwttwuhg3lKUhYdDVPZzOCVzekk5p6aED1o=;
 b=AX4xgU7gTflxrtKFCcO8He4/LylQ6GWKFuegct/wFtBuwn1gwaOyVWz6aimweQZtz7IUfTPU8oW7sz1y+uwag1INeLJzeQPrMOYgOe0ndAMpH1GkGRY/R5WzSxOPFnysEpD9YSh6xtTB17DJPBMIfNhVFL7ilYHoSQ24DW1cpUuIzeVPIID++aVKuU/9M1n3bC/zZ7jiKu0Wgg1zbwYeDp+6DUqeuyz4STG0g2q70bsoogJkHAh3DSadVcer2lWmPL3IcV2VHSNeCu+uUNqtqvtQR4TQoDwtrQBOKceMH1n4Eg4VijRL/+kluvwoAih17hseauBVDGxQXnJoiIhn8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kblu0PdHDwttwuhg3lKUhYdDVPZzOCVzekk5p6aED1o=;
 b=pxPudvcdkBfdhNpxdvfHWUNFkrRlqjawVW8Y1RRWlW+ltReeU47Vr9vKwMMDzigyg3kJSy2RrUaPX8JiBix+7P4OnHcm5PwtxVuSN8pYQ1hrb+V6Fn9K/4666NRp9Df9r3rx/YkI/TDcDQEitjAPwW5qDVwZjn+ZFES/n1tQgGI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR1001MB2357.namprd10.prod.outlook.com
 (2603:10b6:910:42::14) by CY4PR1001MB2359.namprd10.prod.outlook.com
 (2603:10b6:910:45::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 14:52:12 +0000
Received: from CY4PR1001MB2357.namprd10.prod.outlook.com
 ([fe80::2419:5987:3a8f:f376]) by CY4PR1001MB2357.namprd10.prod.outlook.com
 ([fe80::2419:5987:3a8f:f376%6]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 14:52:12 +0000
From:   William Kucharski <william.kucharski@oracle.com>
To:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net/rds: correct socket tunable error in rds_tcp_tune()
Date:   Wed, 17 Mar 2021 08:52:04 -0600
Message-Id: <20210317145204.7282-1-william.kucharski@oracle.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2601:285:8200:4089:3dd3:8aa0:5345:aaa3]
X-ClientProxiedBy: CY4PR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:903:ed::20) To CY4PR1001MB2357.namprd10.prod.outlook.com
 (2603:10b6:910:42::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2601:285:8200:4089:3dd3:8aa0:5345:aaa3) by CY4PR22CA0034.namprd22.prod.outlook.com (2603:10b6:903:ed::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 14:52:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be0ea8f0-0890-4a72-dba4-08d8e9543f2c
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2359:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1001MB235943306BE73FA08B1E0944816A9@CY4PR1001MB2359.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VrRq9O8KoTFBdD5WLym8lzixsS972gF4Oum1ZksrOoNN96GQksTzVhMGVaqu93vsZ31pO7xkcMgkTgG48FDZ2brl3VCtqBpi/r7UArbmxxoLdnesgcDMjFWeYrSeovSPVu9N7FZ/HjjSHNytSSndpwPPUWDU9AoSBOExfkOTivrbpoENX2xOElHcvQi6epdJYCeL83iy10h82kJwqVXQHHdvo2yAJqO35FLZncNNgUW6Nb5XT3b1LlUpAMDGheYDNjeX0FROgrePdi3FhqUWvC95rn35Lr0KIJ3tiBd7qysh7XTWpk3YE4Jo1n3SaE/gspYZlAtuyeCiTBHYt6v5lotZK9DEeNPu8i/639cqJg31R356Ypj6a4oUxQH4r1c9B6gRyMrNmq4hiKn3cqHUs31BoaSj1YPtZATo0ql3XeX3ehuDq+pzbA0rVi7oSdL4lMGbUD1xx++ve6Lscqc92+9RZrbVK198B3Q7FLProyCny/hlti9xS55wOUXW9qULgo1054jLXv930Qq4N1wQ4tsS06FknLOcjsYTUrqb7mcN2riyF2reYTn5dGFuewCFW+mL7ju5NiMGONaetU8vo5kqH1oZI/Wfltk5AHt6dsZuEhmGbq8pwXlcKBpq0T+5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2357.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(6506007)(86362001)(6666004)(2906002)(36756003)(478600001)(5660300002)(8676002)(83380400001)(2616005)(52116002)(16526019)(8936002)(4744005)(66556008)(66476007)(186003)(6512007)(69590400012)(66946007)(54906003)(44832011)(6486002)(316002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LPnYoGpGV0z5JdBNMEqMi8EhD2ycrbprkd1pDJLy7e9Va7Kmh/oxHyfiBHYE?=
 =?us-ascii?Q?l8dxHbEOc7u0MphaOfyyJnnH7jMpPh+tnnnUjddYmJa8Y2FQuoYl5/uAxpyE?=
 =?us-ascii?Q?eP9PcydX6CX2Fye9Kce4CorsnYwJfnrqSXgpavFXtXCodkS7lUQeASfKGt69?=
 =?us-ascii?Q?n5E2bHS9kgBx1tVsv4j06zjJl7QhU9+QqRCOtUm9Auxr109IXpKEWYRKtTan?=
 =?us-ascii?Q?BGDcfRq0gAOvnQKedPSgj8/rz/m65TsgFqzSoW2m0fjC7JdA1iPml5lcTqiI?=
 =?us-ascii?Q?WqSFl7gJ+iYeLF/ZsjQWQnKXvxLnNMRc6pz2w2ygSkvtFuXpHLEg0yToGJcn?=
 =?us-ascii?Q?/AfWvJyM4jyv4j+9/ZE2GkcNh4Tg8+YhQ/BIkWJlQU07qfLCEBTaZAzsLx8Y?=
 =?us-ascii?Q?6XY87kw+/t9p9Ul0dZRuLoRhPl6JXaUe+4Byzpl72HOsSVJkkeNGF2pP6oF2?=
 =?us-ascii?Q?Op1lsc9jgPSS2ugJuSEJ77iwjBZ1ilb7PhwWN4xsVLgBWhW5Ph0P0wrFmjme?=
 =?us-ascii?Q?F4Q7SBL/l+pRdHq8BH6s6Lx3aCdBvsn5tJsRrvjQXykHDLDO9QkP49d9kkf8?=
 =?us-ascii?Q?k/Y1APzlrDiaePKxpuwGjcXbXuCUA5o545ESWYwaa5KjS2Yo/yc2UI/AQxOf?=
 =?us-ascii?Q?yDefY8k19lBgh1XoIzjuLszqO5/eCZOwsp3LWYcTNt3DDKjtP+2TYQ5BnEyo?=
 =?us-ascii?Q?c6gb3a4GFr0QVg6NNuj434N+Ae3KyVD35kKPvVN9v8XFvFhcOYrznowtVrtq?=
 =?us-ascii?Q?4/FlVDIXf7SUPVdGjKNfbrPknzuQuiJg/xsbgHitdUEqG5St7S+BlpBypoir?=
 =?us-ascii?Q?jXpwxKcN77M8lHh1CbpuRbv9iA4J7KnjmuolAm/Aubh8QVtCIpvXVrWTKqsY?=
 =?us-ascii?Q?isXh/E7T/uyQ/liauPVL217FHYLKHhDmR9a0QY2wE/VftMm4nJQ2m9A2n8ZE?=
 =?us-ascii?Q?r5R2xrbJx/SJjuvKNhlO2QA9eTJeOKeQJWlWPTrFDaAnmA+judcgZcCcgK0T?=
 =?us-ascii?Q?07Nrq1k+eg+2kLdnL2yohLCta0cXiiy0oR+cCL+D9416PqmDAUQKMJcwejKV?=
 =?us-ascii?Q?x6ab+NTWPfdKb0Km6mJWh80eNyJwHaNvIWmyfkKOXbwVYi9h0IPP65hyplw2?=
 =?us-ascii?Q?XTZ/zEqHdsQwOhn6MhsAjkPOCQn79Qn9OOXrLU/Mtjs1N/E2MVHqZH+hNcCs?=
 =?us-ascii?Q?ZRO2kIxTiG9cxSQTvZFrV2EiUm2JyIkwM8pdEPT5WcKeNTZmkIctK3pLYCG8?=
 =?us-ascii?Q?AIuVzaf6oqBhRlLAzTDn14c5wpSQAbCMgXivrkXKuOnCGievAvgqd9uucdec?=
 =?us-ascii?Q?tcCV2+cJ3h1VIsyPnVUYyqUejnTK+rHISPd2Uy0bVBvnmcjC1XgHBWVK+thQ?=
 =?us-ascii?Q?s8OpDPXBmDJ8f/g1A9U7jfgNH7WS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be0ea8f0-0890-4a72-dba4-08d8e9543f2c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2357.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 14:52:12.2142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zeh2SyydR/KEKO2h2TYfXUMmHwy1sxDKJOY/3M/kJJrDt2jSvnHHtazT3t7vOz/4YsxwvP2KD9b0eVqOUPK2puo/F3HuUW527rysz/up33g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2359
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170110
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct an error where setting /proc/sys/net/rds/tcp/rds_tcp_rcvbuf would
instead modify the socket's sk_sndbuf and would leave sk_rcvbuf untouched.

Signed-off-by: William Kucharski <william.kucharski@oracle.com>
---
 net/rds/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 43db0eca911f..130e5988f956 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -500,7 +500,7 @@ void rds_tcp_tune(struct socket *sock)
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	}
 	if (rtn->rcvbuf_size > 0) {
-		sk->sk_sndbuf = rtn->rcvbuf_size;
+		sk->sk_rcvbuf = rtn->rcvbuf_size;
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
 	release_sock(sk);
-- 
2.30.2

