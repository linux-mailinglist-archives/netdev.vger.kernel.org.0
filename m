Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E054A3EF094
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhHQRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:05:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49406 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhHQRFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:05:23 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17HH261S023672;
        Tue, 17 Aug 2021 17:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=x6iSuWgQTz1bx7z109sO4j0Sbv/4a+zUZ0PEfnkzkVs=;
 b=Ja+c1FH6AMW+M/lhzt6XRPF5CLdxUXJbzaPszXr2FDI2OeUP08yX8slENnzmtoNJX0mq
 ia8rZ4KXgUUAabNHxGLkqitSd1IFeitdgDrTz3QasvXstxWdZ92CT5Idi458btdXkTB4
 DBpwQLY/6mZ/8HNFu9mRcMupBHJyhv5DKZnC9Iyi931wxyQRDOFfvOw/O9K0XBKoWEcX
 z/KkLQqb7b/IIn+nxpccFxFSV7b7Y4teJswSgAjloQa5kCv9m2u9+DTDMKWvpmTaGDPA
 WltNOrOIfL4jBujDHcMDr9EgaDaYZAipL4kOg3DxwwRLYfCCQtFEKHztPcMlQUYiNKmB wg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=x6iSuWgQTz1bx7z109sO4j0Sbv/4a+zUZ0PEfnkzkVs=;
 b=gQBHQ4XBBx++XHipXCzqqUqrYFy13nYm9rd+NCerMwWR8MybbtIeemCyFisLNbAh5JNr
 fpl3vKc+7oJPmfJK45Esry6Hz4AG9qMAze3oz/6obPw3eudkxciMwyPuwjIuNg8E4fOl
 k79zbUAL+5ZQPVEFr0ZP4CzUXyzMHp9DVqBk1b5RLX/Y/STdfOpDsho0aKLZIP4HCm7W
 +BVFtOruUqx0A4XQXCtTjfpnsRZeL11dCqLm1+7bEt8TCeYBvKpSfRK5usAuZOfs5bUP
 7q5vsIqpEZGaVkq8SY+wpsD/OCPZe6/gxHlzZXlCHzpQ60BdibhwwOHsqg8edO/dzXXS ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd4t1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 17:04:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17HGskW1006546;
        Tue, 17 Aug 2021 17:04:47 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by aserp3020.oracle.com with ESMTP id 3ae5n7wv06-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 17:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7my+y38MkchQ5shi1/OBvamy82JKNN9tU7xmnIzfnwo/HHJkaa000MQWUElDWbDlMHoV+zJ/VW75PlnfQxf1MD9/SUBroWGxo9aOYjsFNu/PovHAcfZUaaHB15X1XKO+5spagJmiGKbp6PJlyJiSJI+Asqe+vLp+eCEuxdspQFBGNgZsQzRCHq3DRRAh0LGI4RrmNoWDwcpZ2GVN5Ej9HsJ5o7xlU19LTyUbik22HEBhGUGZ7FAnGkFg9SUB3AKZqlcD3h9/HLkXKUQ28gro2ZyvVCRhwP2YgkUyzs6/YP8LsRvwqGkjQHqTLuW8FUoOPmfyvCqe0R6NbNcAUpjPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6iSuWgQTz1bx7z109sO4j0Sbv/4a+zUZ0PEfnkzkVs=;
 b=N0NPmlaVr9T5a/CV1BdT6+HlGx07BDg1i6RWQCQWBmv5P60gLQKKYkVRnJO3zLnWV8mFo6ijVzusbN7cFuWjLisQ9sUdorZqTcEKMC6rb1q09ZVq1WDOkKlUw62/ZmXS6KrWWWpIjo3WFV73vaMgBHLMa5ecghK9w6qBE2eJhlQkYRyB2jD+w7rBd1ybESoXRWUFxR9vE58XOoDkBCDPfP/dYD7VZjxS5x/gv3CqrhXqiZ+r/NQ8uyrm+qUkuPkIX5ejpNGqpqcN3JuqFKToOGTu6bwCslAxDUTq2mwskji4tTPCZgMMz+n9ET6nLfuQ1KzcpvTL9FjwU6MhmWkARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x6iSuWgQTz1bx7z109sO4j0Sbv/4a+zUZ0PEfnkzkVs=;
 b=tjwB3lVd0KoXqZYR+id05JzTlWw1fz2fUs9lLkUFP2vVgTV4vcbct6xGXNeHVHBNs4IG7wNGBe1pZil3pV69GL1JjbHKrELsrRzAiiNbs7to/C0GzRtBsJLJJzth+EOeoHFLjXXUv3xkY1Cltlvgg+HjxZe9HVz7++j7HJg4PPQ=
Authentication-Results: oss.oracle.com; dkim=none (message not signed)
 header.d=none;oss.oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3158.namprd10.prod.outlook.com (2603:10b6:a03:15d::23)
 by BYAPR10MB3592.namprd10.prod.outlook.com (2603:10b6:a03:11f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 17:04:44 +0000
Received: from BYAPR10MB3158.namprd10.prod.outlook.com
 ([fe80::a116:b514:b312:c2d7]) by BYAPR10MB3158.namprd10.prod.outlook.com
 ([fe80::a116:b514:b312:c2d7%7]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 17:04:44 +0000
From:   Gerd Rausch <gerd.rausch@oracle.com>
Subject: [PATCH net 1/1] net/rds: dma_map_sg is entitled to merge entries
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Message-ID: <60efc69f-1f35-529d-a7ef-da0549cad143@oracle.com>
Date:   Tue, 17 Aug 2021 10:04:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0131.namprd11.prod.outlook.com
 (2603:10b6:806:131::16) To BYAPR10MB3158.namprd10.prod.outlook.com
 (2603:10b6:a03:15d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ib0.gerd.us.oracle.com (2405:ba00:8000:1021::1046) by SA0PR11CA0131.namprd11.prod.outlook.com (2603:10b6:806:131::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15 via Frontend Transport; Tue, 17 Aug 2021 17:04:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5578ad05-f0ba-4048-1f92-08d961a11c48
X-MS-TrafficTypeDiagnostic: BYAPR10MB3592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB359223526C832597FD759CE587FE9@BYAPR10MB3592.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:293;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5g7iBvk/i6TNvU4nc3MVwa2gamd3ARI7CZWUu7DD7AId/ZO3PX3ocmsZyrj2NqknDAFecYw1201o56UDfwHRFcjpqyoSBF52+Khxzz9yxO2Eq8QEzJaI6g4Jmoct6C6kxrIwBTDs917/OMrIDH3a5Qwyz/p3stgD39qmWJUn4twDqP1BlJy0dn7Q4SVQ/DeePsM4Bg4jvRmj4LyQ28C9P89wrOjDzjDHCtLssqsIuo4s+SjeJZjFpurqjW2us9WENie9chMTSgE+pght7x204OPzgA6l4yT7kZShdMBwZl1rLu/QLif45LHevKs8+3fzDlVnf3hGINgNcfyng5oqOVlElOJek4YiVk5btnmusebgfdAU199QcCoPNkss/41IHNK2dOBO2Tnnp4Y/SY7uEkIOk9Q1mib7VoDow3DtIjH8lnGtCn6bVBkIkuoq/pk7E1M2a5lWvwddJ+UfrmiaR2LqJLTr/6AQxTH7fW3oyUELh/XDeGcDUnLPNBthMcO1tTg4WdNz0WZFTdebL2BlwQvWodSjhveX3OOIYuh86ds6paN5E2elpcVwnauCVaUxxwPaYCJP7R8Zd6hRvW3oMuOpfutQvFefY8VdKC6x8SpmBri7FW4giw3co9r19ceh7YI1Z1bPbILSfVMRlm+YLt/nThy1zZGEeIvFqPP5QLCOUM/liy/+IDV44MRDhEfN9sQkscAEwxZbuE71lN4PKSmQQmSQthTY4kn3jnVUzU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3158.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(136003)(396003)(366004)(2906002)(83380400001)(6666004)(52116002)(5660300002)(44832011)(8936002)(66556008)(66476007)(478600001)(2616005)(66946007)(7696005)(36756003)(6486002)(31696002)(86362001)(31686004)(186003)(38100700002)(8676002)(110136005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?Windows-1252?Q?MSNlgqRuMS5M9BMx0wX52yIvDLjpxcBLfomKbPUzgTiuvFRt53RDvYrf?=
 =?Windows-1252?Q?irUwymVLOmAr4NElxt9S8yzWI3sZL187Sl9Wie3cU+Kw8EJqbdE3rLia?=
 =?Windows-1252?Q?LSyRrRbtwA5N16AFs7RmYKlgW7y52c8AxrVA3XH9Kgjfbc0qPiOTC7eE?=
 =?Windows-1252?Q?sdBKbIy2+DX082vxVUuAjQPZlbuEmMvWHN23aIY/VkYvQJwkVVQJ+hDz?=
 =?Windows-1252?Q?P8bO/4AY26krwGKxDgaRP1EFosR1oTyLhyLwIbmllYkYRkVNDGi1Wdw9?=
 =?Windows-1252?Q?VqvblLLLhMircriH19cWS5eprxszJCZA34Y5jh2/xT58AV4h3VA8Y4Kr?=
 =?Windows-1252?Q?5IegI0N2TmmW7flZFI446cZLaNafJcaPcuNR4+k3Eefj1ju4N75QY6Qn?=
 =?Windows-1252?Q?WC4ZJtFJ/IF9X9mw9u0AfaK8mmKGCZiQQrdGqlbSuKn4Sjg4ZwYmRR8k?=
 =?Windows-1252?Q?295DfN0nDoNt6N47/Sao3/inSumoujKeOTx+a3QXHm20UnKJPRcHMSCD?=
 =?Windows-1252?Q?sOw671c2BsaoUCG5Mj0V8/XfNm8zBizsQ4Ae7bsw09w7ttpeHKMJNKGs?=
 =?Windows-1252?Q?EcysUASSBEJ3emTmvlveas5uzfTPSMt7AkMXLN5tWsG2bgfwDvMu2fBH?=
 =?Windows-1252?Q?5FcVNPuAaSQ5YA1qc/hY2k/sZhG3f2TpeutWmFLZrfdP8c3J/oP+ocNF?=
 =?Windows-1252?Q?Kgc2lK8JiyqCVBFwcpXmzePpB0QjKaMs2+vt1/7r1+Zbe507dRPjdg+c?=
 =?Windows-1252?Q?/tAKHFJlwXT1GuxYL+yPvbI1+e5bB+EjAf6TIXJdJQ1AW9L2+q5jggMA?=
 =?Windows-1252?Q?WDxHtNpvE9riVjwVViWPDwPHWk6CxTkZlvHNeR+NQPbPfZM3Q56ww3qZ?=
 =?Windows-1252?Q?GMRHnHy05if9iBDKsW1how9gO9Wwfl8H2OaiuzAw2/wk3+ALRnzLqWo8?=
 =?Windows-1252?Q?WDuBOWsbAAD2fg4iJMdkrARnUx2Ah3V5wnPfHm2rUBiW42L2wtKxSJSW?=
 =?Windows-1252?Q?SHVXJiEnTNibCWYkKXFRmXDDRxCnwH52rpc6ceMNvpu+7AzPw43R/TrZ?=
 =?Windows-1252?Q?+lB2OBcxx/4WXqzXvsgFxExB7tL/5+0HnL4Xj1whnNUKrwgzShO04jUV?=
 =?Windows-1252?Q?qqjKhcbnBH535dPS1g9rCdrL68VYbc+Sy9mQCZoarT7y1g3qDXxj5RrO?=
 =?Windows-1252?Q?NnZF2xbt+41M3pMwkHO9q0gwKFasfgckdJHQzxMNyEayNIJsCxHjqUlE?=
 =?Windows-1252?Q?Anj9Z8hIFUS2Zw6jSiTV+4pdKyIlHT9MM5sdRVf5sKq4NMWSh/i2TBgc?=
 =?Windows-1252?Q?Zf41K+lkc+XmNjOCKn1LImaeenOtacvSfIkrVgqoj2WcE6RgsME+6kHQ?=
 =?Windows-1252?Q?Tp2zpt8Np2dBMyrZJbS3u3V//nRL7nf3K2r9KDM8g9QhaKCOjMm0eSHI?=
 =?Windows-1252?Q?z2byawgxzdn1yjLVarhl4A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5578ad05-f0ba-4048-1f92-08d961a11c48
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3158.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 17:04:44.3292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YI0STzT/k+j3Y8e+wKR1j8cvjjO2twXZneuzBdB2sdEh/V0kZJXZKE2ftOBXZgjwM+LpAPyUfg7y4ojnOxiitg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3592
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10079 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170105
X-Proofpoint-ORIG-GUID: r6r7tWDR5zUGIw8w-Q31jbGHQoCuFdav
X-Proofpoint-GUID: r6r7tWDR5zUGIw8w-Q31jbGHQoCuFdav
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function "dma_map_sg" is entitled to merge adjacent entries
and return a value smaller than what was passed as "nents".

Subsequently "ib_map_mr_sg" needs to work with this value ("sg_dma_len")
rather than the original "nents" parameter ("sg_len").

This old RDS bug was exposed and reliably causes kernel panics
(using RDMA operations "rds-stress -D") on x86_64 starting with:
commit c588072bba6b ("iommu/vt-d: Convert intel iommu driver to the iommu ops")

Simply put: Linux 5.11 and later.

Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_frmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 9b6ffff72f2d..28c1b0022178 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -131,9 +131,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_len))
+	if (unlikely(ret != ibmr->sg_dma_len))
 		return ret < 0 ? ret : -EINVAL;
 
 	if (cmpxchg(&frmr->fr_state,
-- 
2.24.1

