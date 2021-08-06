Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1673E2D1E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243246AbhHFPFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:05:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21806 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241898AbhHFPFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:05:10 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176F1xeu029257;
        Fri, 6 Aug 2021 15:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=68PZoTYjTjTUGTTL1c6eNfbE2wthoxm+WjNYV3OMsdY=;
 b=fCqFqzUOQVcwCPZyWBLTTw0SZwSQrQJIVaQL5qJqltY1WM0HgXCj7gEO5hvn6auFKCA2
 UoTCu8vvfaj2Jcge5nuHzI1L+Tu3FrXtr1oRyv9D4N2ucLTUQgRBD5tCItMJvr0iAOQY
 Ep/ubu0HLlBOpysBm2XDpRjZc80NQYHLnJ/46LIiprKtimKHtt0aNbc7Ec3jiomgmLde
 X6T6eXO7VmVgITfOnQGnjcAFs4M+Nn6ckDt8xIagTVpvpnp4mS1emD1wihS9oPeuNIWR
 9pXm9n5/phTbkYCucGV+TLryAdZsCEfvdn6Q+6bLRbt0LXljpA9r25XYvYM2aBUatrwM PA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=68PZoTYjTjTUGTTL1c6eNfbE2wthoxm+WjNYV3OMsdY=;
 b=iwCzZAIzArSKma4nj9g4LS/B7OV28CF9uiUT9RDHen/GjU9bhlYwSu52DdEmUi/Fc45S
 dGjk8QYyFHtp4kGR4ltz34KoBuc8yAY8UApZsWLxtnDGrgQXo2KIXJUYW6Ozl1+kubiu
 QCZy4sflpckenuPfjpyOxoxjah5dk1ug5nzcY+TnfFqVLYt7PGNqh4okQL05YhJf4fd8
 krZyacACTF40HnF9TGST4jKaAQXPeG+B9Zpjd19EGegxpnHjpMZKzyZKY/r4RqN0V4Ou
 hl1W9s2ZnD4a6fih1MvSKsFLuwAPBCjdt1AK6yiaPAmExxz7lkKGbEeYsxOqXz3yJh38 dw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a8vy3sbu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 15:04:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 176F1dDp084923;
        Fri, 6 Aug 2021 15:04:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3a5ga2ddqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 15:04:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLPgUZS8UvjVYLF8aFuHb304oZrtujXHN33lJeCR103TZ/WuGpLXlM91jNad9OxuEssdjFKyacd2WWotZPM87W4QWTKsJo0OZyWBcCyM19OHaklfzAwZpZtXTE148jJEQeZxvhUb/YaqHWVD8SnI8WujbM23urW6yN9b36izNA58icMPX3EDd9EEjimGY4oKQOEv6njyjI4lvwOh0313wnoSrK03ajgv7NcRkZtx4fW12MWhu5nxYlTgPpeaw+XjeTihJi5EAWXDEqpNcNnLAP+Tffqu3N/bpqZyZ7KJdP5PkWo1mmwxhY2LLlAdjw+rO+mQsR3ZHhlftD9qs1rWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68PZoTYjTjTUGTTL1c6eNfbE2wthoxm+WjNYV3OMsdY=;
 b=CNJ1r35TTxjDq0uAFOQmBKXkIAOvqwYfzbCm+egUC8CU58wY7lbVmBbLWXampOfVcMzzT8ODHz0VzVu/S3/yBx4279zUnAT4bsbd3it0tqrppA/YIpsBXsnr4AH/3FbnovWwln66qrw0U3zMxdvDWAGQ1W6MDvVnXO8XPQbd8lZwBGFZr8j8mWg2FJiZPBqwGQasxyg9BxMm4poggjWX5IxkLuJ81Q8gWX7XNg6ie9OIcLIY02qf36vNkoKlqRw0y7KvVPJxZZYU7ceBOVyk4RxMoWXk9ux1zPqOy0Ag4mgultpsPqNXsfY/PGmlqYaABVRGWIPVAeTxGvKAJVxxIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68PZoTYjTjTUGTTL1c6eNfbE2wthoxm+WjNYV3OMsdY=;
 b=kSdbMSr3mUlxuM5PYSNj5zfqeY/55h/52kOyjes6r5ownbJdmwegWUHDpS6hikVLfWnitXfpl2FlvfBp15aYC1R7JtNKgtL/8+bTOu4H+hGtAUzOGGURmC1RD9yrLp45DXtGopQpvfey23b1YgT5OvS+n0P15aibAY3PtBngMeI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2159.namprd10.prod.outlook.com
 (2603:10b6:301:2c::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Fri, 6 Aug
 2021 15:04:49 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4394.020; Fri, 6 Aug 2021
 15:04:49 +0000
Date:   Fri, 6 Aug 2021 18:04:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     David Ahern <dsahern@kernel.org>, Vasily Averin <vvs@virtuozzo.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] vrf: fix NULL dereference in vrf_finish_output()
Message-ID: <20210806150435.GB15586@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::24) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 15:04:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ade088f-84f2-4113-f7ea-08d958eb896a
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2159:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB215958F941FE606E5F8C2B6A8EF39@MWHPR1001MB2159.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iF+B/CGJlsO7300Mzk67InTDm9jLdSM0w6jKXg5ZI7dbFmE3LHzM98nkn52GSGk0jRxLf1gXebbTl05yrCwm9Zmjrer9Cbw3yMVimigCcx4xJ9cC5WCSbD5oGDWZIvGUov/DpT6oqTyJAP7WN2/XFD3F3u2gRxkyHCxVXhxn3RYXlc+0w4kleJdnJydzxBu/v9r/iyo97pnOtMYrhgzojs5CAETacF1TkvoFe71JrmSGy+fMoZAesV2KnErGyy1X0bjzdQ0PZDvShGIZTmnK4oaa6ZljWMjOR5PKmH6MZ5Z0lKZitbqLUv9TEr9ftKeeZnJxgQRIwxQPoF87ZcyTqZ14TeVDNL7IEt92uW5jlK8N228G7kBMffl30YKg5aKt1AhUWrc5x6KyDsG/K07uUNnChQkfA75cqh5nBY6NUspl672ijo/y5jKRTb8WxIu+3TZ0qfWd3qnmIdyIj6xKI+5Pdab37OQTWcT545Jc3q8s0j2wBq6Y0nuUrThNbSTZLrpNBiM4f7vusb4/OXHAeEcRow+pXL73uPLXWpGHHO0iwbSpsXMklziWtOs5GhneF1xWEWBi+6ISsQUWzcvzGWjSxq8Irh+pCaeb+713if5w2ZCZyKUFnQlyVVdrYLsWPaXdEty+WVrbr0Cdt8fSLrTS1u46xxK7erzI/f9GD09tJsTH7ykuWtyPgfQaYvqIVcFXavyKVoEU9H9Apq8mKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(6496006)(52116002)(8936002)(33716001)(316002)(4744005)(33656002)(2906002)(8676002)(38100700002)(86362001)(38350700002)(5660300002)(508600001)(9576002)(6666004)(186003)(83380400001)(26005)(55016002)(9686003)(44832011)(1076003)(54906003)(956004)(4326008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7w/KqAQXKc3Vl1ZsTGXIURWX9ZWdB71AGxGKf4s1SUkv4xkwkeQvBgoT+gKD?=
 =?us-ascii?Q?A6EW0mXte5w0P+q/E/6Jm97V7Katb+Hs13d8fdfHFsceh+zChC4m+HadhT5r?=
 =?us-ascii?Q?OgM4K3HnKKLzkYvtbU/qT2KzVkXMvnVbDSvyuzs1brXYWWsCnxCIi1+8s0hG?=
 =?us-ascii?Q?+3mFwRVLw2zT3p6DHBRjgzO/egciKqUs0WheHSrumZI9wExxKe1sOunQZfdG?=
 =?us-ascii?Q?0mrLFfCMBWKyme945pDPRdYmisWUhoVRoRE+5tNspryvdzn7YvVQIdOta+Sv?=
 =?us-ascii?Q?OtvnUQo1WJv2n7KkW2qkTa7b+wnxb81Rle4uY9mEzV7vKE0ryw4ZrtJAoRxr?=
 =?us-ascii?Q?VpNydFfFeXXwPtBxYQSLRg8aZxg9B/2shdG7rnVHLPGXT00+FAIjloQlB/Dr?=
 =?us-ascii?Q?KzJc8DQ2PyKCVuZaiGQUqaDj2XiMba7y9UCtWeELizOIlDEtwDTmpYN0PH4F?=
 =?us-ascii?Q?TXuamZmoi4KUGV0uFitJVcjDXpjCY09053DlS/NCjR0tITiXmVbERyZv0U5Z?=
 =?us-ascii?Q?A2ty7/GLfQh9x6MpHvhDcJ4JalCsyChJXy1thOQUkeIt2EKyzH7u/eupz+yD?=
 =?us-ascii?Q?uEJnDBba7NA7slWeG56rZIJFsIJ/W1M8V6y2m3gDY1KLbn7K5XuWZn1uKSii?=
 =?us-ascii?Q?YUPi93KpIbjgIMe412u/EfkR6RCtUvq4pQC54VqOneb/MruLzHhRpw/o9u11?=
 =?us-ascii?Q?WbhwTlZA7DpSqtrccWzxT2wLqO5D+gdVYmROrOLdJHxP1HsHu9foawcOYhpE?=
 =?us-ascii?Q?omCm+eOelMGovPq8fat6rbbkeCbBMz2yxiz1yE6lZmSXGZf1jHxZLftMAXTe?=
 =?us-ascii?Q?cMdf9AWgBLPUU7y6DmrLXIPRolh+dHDKlMN55JB0prJhFqUwz8PNA+8K8Acx?=
 =?us-ascii?Q?l2uGdQXd+z5Wu3CpZJQzVoAJyX/Xc589Eg1neJym0jQJt7I1Ur2twkQu+QA+?=
 =?us-ascii?Q?gxJ+oHwZLVkGTyqI1AHsJasEno9NqHW2PJNW1xT2QSUP5AJA3uQuk0EcgoRM?=
 =?us-ascii?Q?3IavvZdtmu6uwuUSZLgWgmV0A0AJKvrFKTBQPDu9mbuabtoVAj58pmcDiaad?=
 =?us-ascii?Q?T9/1leIQmoilQSua9fRySLAT+zjMH/YDrT9fCp9hbGH5r3gejHxw2aGiqTE/?=
 =?us-ascii?Q?zDPQnxSCUK7ZMqDNSxWkxaQ6nZV92tGGET8daX3GgailvzTboQ7YGlnMUFTL?=
 =?us-ascii?Q?nzZka8diuxMzyrerDJbWOdV6HVhisg4jJ4sCpZHuu636fyYBb1TDQoTSAC6P?=
 =?us-ascii?Q?7UntvNJXZEikrBLhU2FJxmp4Z1tjY02c7vlCD411zu6u1gRaQ12IgFTkCqGM?=
 =?us-ascii?Q?nHKec0JHQ+VUBtHCw8MNEkXJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ade088f-84f2-4113-f7ea-08d958eb896a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 15:04:49.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Xt634/BuQm4T+0vMg800fKYG9XUtUe6TRgSi1/K019vyDsnMMmCXjhKxz3iGYx6b98BN9i31elHIW2BizC3yysABGy9FG2HUgBPQCiqXAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2159
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10068 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060104
X-Proofpoint-GUID: iIruhTj36ZzysvYVL6E3urMIS6spyi-2
X-Proofpoint-ORIG-GUID: iIruhTj36ZzysvYVL6E3urMIS6spyi-2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "skb" pointer is NULL on this error path so we can't dereference it.
Use "dev" instead.

Fixes: 14ee70ca89e6 ("vrf: use skb_expand_head in vrf_finish_output")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/vrf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 726adf07ef31..662e26117353 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -864,7 +864,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
-			skb->dev->stats.tx_errors++;
+			dev->stats.tx_errors++;
 			return -ENOMEM;
 		}
 	}
-- 
2.20.1

