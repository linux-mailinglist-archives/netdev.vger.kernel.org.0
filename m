Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9229589DD4
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 16:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiHDOoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 10:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiHDOoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 10:44:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8041A100C;
        Thu,  4 Aug 2022 07:44:36 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274EbjVk010008;
        Thu, 4 Aug 2022 14:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=miI5On+bQ0TMN5BiCnYymXmTwZxpY2gGgl07e07CZeU=;
 b=1yoaWY1z/KZaAY1UlbvlddaLM5cnCXAaXb71tvRHfbmADbhpIG0w+sqmYXFGWgMOSh7G
 S6NMhejuCAyhPtNei4M2+iy7Nl0z/Z4WOuE9brkSYjJmUSTqgDSuLwRispv0jn4EXXts
 RabtoKN0oo23Ch/a7tlOweHx9M5eudmbr9QqCoTugo0Dr+rX/mtV8nr/MOkwfMDbtSEl
 BsXr3v4i4BCI+FwEZ3CtfW1cXSiB9UJkXjRz8b2sm7WHzNyzKxa/tK8CNDJOG7MTzuO/
 a0AfxS5kQG95aGtr9TqUspQB+2o8p37sWGdMYLIJfYKJSJrQ0AMSUsFsEPwuuFkp1KYK hw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu81538b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:44:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274DQV4Y002978;
        Thu, 4 Aug 2022 14:44:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34cb6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 14:44:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5jTULWh+WI8g+b9f5bIQFRIcc6AqeDDs9Z/8ETlekmUeC9aSfvx1VfUKzBq7M5cenDouZ6U0Yd4krW3VEHrSytqb30+TYr+jGhgdqK5cpM4x3GLZvzFcxmsTSj3OrJ8crh7fmuyi6aVBeiarjECwAXkregqn5kTCp+Nzfmnuin9V62rM8Q0lXFlP8F0uC9zAfj42ZaBMWPx7D63B5+skDdqyKeGnTEXYsu+Z2NveUHopNeF1XS5l3SgRHxkosJdfCXmNcg3MrKx+pEpGJgKj+oEupaBgUdZzcSh7//XBRLWU8ykWelPbRtvLAGjjTgnaChGdibm6nq3o7K1Urt5Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=miI5On+bQ0TMN5BiCnYymXmTwZxpY2gGgl07e07CZeU=;
 b=NLQYjUdkUWhRBoPt72zwlT2l9SDLJ7Wd82GFsGw4OZ4ZJ69mlBRcby+xThXQZLGZIn3CLIQDfUlohBimjlNeLxj2Xl6WCWif5iHuJmIjRnfQkDZGUYRjCK9O4L9pT2lmSDCgNbl+JbaIj1ge8YM9/msPSOYgNdEmSBWBVknyJ89J/fnxcQYVLP5aELS3W6hqkx8UB4z4BCMM9OKx4rBkMNDLFTfxVJrG+DMLfT6ozGFdNkl+8u+Wkfl8niXIM6eUc1Dzjz/SYQ0OJpDQOqoiSiABOhLeCuEI5zse2KSoWBN41+F2DH6jXn9wpTW55DXtUCjY1IG2hHexZyP+okgZNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=miI5On+bQ0TMN5BiCnYymXmTwZxpY2gGgl07e07CZeU=;
 b=0Hk3wEKkx1gMKzS08p7QLcpKNaqwPsioTjEOFvA/scuMQGq8Q7Jc3vgx7VH/6a8V3IdoEMvpeL1Cnx+DBzRgx+rLBRRSKkLmDpqRuXR6ilSBrY+e/O/6upBYR1xOlyT8F3LAtl5sLPqslMqFKvR77IrpHpPgbGINo+2j8buWFFM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1475.namprd10.prod.outlook.com
 (2603:10b6:404:44::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 14:44:25 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 14:44:24 +0000
Date:   Thu, 4 Aug 2022 17:44:07 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Pismenny <borisp@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net] net/mlx5e: kTLS, Use _safe() iterator in
 mlx5e_tls_priv_tx_list_cleanup()
Message-ID: <YuvbN3hr1F/KbeCh@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0198.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f488ae2-ced0-45b1-d5ec-08da7627d32e
X-MS-TrafficTypeDiagnostic: BN6PR10MB1475:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwR/K/zf/VX6Q5d+ArffSe5V1/Vh1HEklvaN9zqfxb6raKE0LrGYEnYjuL9sAfDV1aNJHhbdGuavjtah84YEa5xBVw8TEOwzgI0eF2KEEl/DNpf4bcdIpJjJSq83nAdtCR8TfFSrTZJJIVBmgu2lWHBcrLmc/C7+RMfRyV0mKHi3PHopyw8vfLFA/pZsfgEXhUTL/AM1iiREV+WLWgEH9lGMxZZoobkEtM13S4xFNhpVdrJirJ+OhjYaLx6UcxCqEp5bcqzECo9aVgnu/cJTrAWrcrp/2Iva63HwFtQBxAL/PNHKi9/MjfEdZOf4LGl3y5qn0DZYAJfLpPVRW9lQaMnW15WI1BZ9DSxnWj/JrU3mOH3TuZPJXMdlCsCyaGEvXuCOCe8PmQaNYtTq0IN6bwk194iieAbKaEFpJQzrt02hg5TilWgEd2pO67TVG47Pc5PNLUT2BtNsgizB6nzWZrDksC5fwEd/Ed5lDIQfS6NGo1+MWcAegK1t0jkUuXW2I3+NFIVaFpbdmfDONZAA9i6690Cp5gxEES92wxCDm7U7nh1xy1vtsTfv6ObohIlu4RVpjh2K0qYwUkAhxTDFMJf3OtM5PkcxnaZesDF6gr1c6OICCO3EPCzeNdBtCQXQQVNZck3d+XHWDwd3vCH7q9quW1zKYj+WXiBLomAljJKE1Y6+UyZMg6DehkFw+AejPG0clikBVf+VuU1gXgAvfKiiqHrkeX3rk2abcUBbJoRyFWq1VtJhOZbK2pDucMb7ettLvWB56Sax4M1kBjAyzuQPKPNeJrD7sOkVt3JzDUws51pfQHi41BHMKZh6+6BO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(39860400002)(396003)(366004)(376002)(38350700002)(2906002)(6666004)(6506007)(86362001)(52116002)(8676002)(66476007)(66946007)(7416002)(66556008)(38100700002)(41300700001)(8936002)(4326008)(5660300002)(6486002)(44832011)(478600001)(110136005)(54906003)(186003)(316002)(6512007)(9686003)(26005)(83380400001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xFcfiu5IOGBQ1zFRTJfPNzg51e6CWMCpHURIwxadAGR75DshQVuxWS+jujaT?=
 =?us-ascii?Q?Mp/aqz7JHyj/AcWe1YvqGGEOuzy8GTTB/DG30kM0EmmIzLAfsp4hc8S85zDK?=
 =?us-ascii?Q?96P5t9GTu6R7sHHVJyKGgu2RefBpo3vhxZ+a2tP91RoeyqlIxajvdEJmnnm6?=
 =?us-ascii?Q?kWUFIp/1Oi3oFJyV7bNoxUj/ErLOR+SbRIkNTSXlXMlRHxijjK1c/sWMvyGb?=
 =?us-ascii?Q?6+ZKC0CFHUEK/Py07pyws8jn+JRyk41a0hDAHX+RgCAIF8cTBgN/hf2wVSt7?=
 =?us-ascii?Q?VNMPWuudKe8vXNS0MbMN52F0cxGSM7KWYV5/Od4BIJL3NeLS9+rd5g/r6OBD?=
 =?us-ascii?Q?bkglLvD+v5VByD6ifUFzOQCQOuxIMQ11g/sUBbOr20qPqfeiNx9/E32umCfg?=
 =?us-ascii?Q?r/IIoRZ2aZRU9a3Qe/qNFz8dVZ3WqiCfIC8/0goqJUHgN+6nw+KR80swoFEX?=
 =?us-ascii?Q?1IgKoJvh3xzuNMGXy+wJmRVeDcpSjlFufatieKxxjNX6Heoxw5xhcMKAZ3OL?=
 =?us-ascii?Q?tYyNA9G71/JSBDKKQY4Q2xjQ2LBfeWYVkP/rDLmzpzCO8rPizzgPspA374HE?=
 =?us-ascii?Q?VI4xgxQ/ixzz9QAUDWcPhZ3ifAPkR+BaVPwkrzDajfhgQvxv2FSqumKoJksG?=
 =?us-ascii?Q?Llmx+wqs6D1J9vgorRMDRgztKW9LT75LxIhQRMWfcC7Yz7rb/cwX2Nr9CpYo?=
 =?us-ascii?Q?Ux+wNo5DG1OdCPQdnukEFbgDn9oaRA2TQdoOt0xxei/eKNKoWuZjmi50W72K?=
 =?us-ascii?Q?/x+iFqchMBRonNI3wX2rZnbOLPrY60CNGModW9+i/o6NhSoQj5xYOrNSv2uF?=
 =?us-ascii?Q?srqwKtJvDV/2uvO4dfX39OyyfSS/5YRGRtROvnFf9ZOow6isi18HuIrYJskk?=
 =?us-ascii?Q?e1xgzX+SzqijR/Mg37WHbS4JDymdC/NK2FNAM+JkbBkPLbPtTEQO6K75tULY?=
 =?us-ascii?Q?Xu9AROS6D78svcPm5y/9lFDISs4RZny1SMD7upAiVgn903YeeOWfAGmnKqL+?=
 =?us-ascii?Q?LAczcnTKKghxeu8Jo1SLyXU49gvoiPuNOB3BocZFjup7g3shLV93pFMimdFp?=
 =?us-ascii?Q?ZFp1sWFePzf4kTaTf9j6DwUoouDfD2QNg6WRiztzSw6OWmZVUEXkv7JTiEa1?=
 =?us-ascii?Q?ugWi2KLP38J82tW0EU6Rk/pb6fpyaGxKzPELQ7V2bpasQsGfGHnwNf0hfi0b?=
 =?us-ascii?Q?3Hp6QKLXEqpUUvubNuOB8Y+6Xkuy18f394DhtrD+Lisg8lYqGZr2Rd2h+2eH?=
 =?us-ascii?Q?SrFoXAUUvPkQQSuvzQqu+3Gi2XI2q04Zfp3Xpv9H/2ygUYwKtVzrXBJhkLSy?=
 =?us-ascii?Q?X/+nZOxvQNDxi7zpFEKjB6YdxNkLKFJnYQe267v8ZoQiWUWYr+EUJErrnv9o?=
 =?us-ascii?Q?HzcHIllwxOnKUXK0TAE65iCpsQdxE7VY82FC1sRBObfS54JPdPPWjXkV2A5i?=
 =?us-ascii?Q?a6CL8cE2R3lUxdg7957CuQV0FnKvcJ1wbvH6vpGaTBK5KVSZU34IstrVhSIc?=
 =?us-ascii?Q?GQ62xi/HNFSaLrAKa+ZjabqjtG2IFnVmaEtvyH8lo1FdQZobGvtcXLXI4dvO?=
 =?us-ascii?Q?Eve2v81EldSaBiqpinNXsklPt9+ZhDkLFtiGM14zn7kdTx0cXCdU3fbSgmhs?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f488ae2-ced0-45b1-d5ec-08da7627d32e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 14:44:24.8335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7cKXwWbxbqYMmylRx93I7fbUauYMpRx9dCHyBXDK1A4ofxDoIdcXumevd2tqljufxxcyYP7UfcvU3R1FJfLsvYJFEOxbL+SGssSg3xePak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1475
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040065
X-Proofpoint-ORIG-GUID: QDVZOVncFKFOdYY_JZsxFUhGOMoyPzRR
X-Proofpoint-GUID: QDVZOVncFKFOdYY_JZsxFUhGOMoyPzRR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the list_for_each_entry_safe() macro to prevent dereferencing "obj"
after it has been freed.

Fixes: c4dfe704f53f ("net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 6b6c7044b64a..e6f604f9561d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -246,7 +246,7 @@ static void mlx5e_tls_priv_tx_cleanup(struct mlx5e_ktls_offload_context_tx *priv
 static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 					   struct list_head *list, int size)
 {
-	struct mlx5e_ktls_offload_context_tx *obj;
+	struct mlx5e_ktls_offload_context_tx *obj, *n;
 	struct mlx5e_async_ctx *bulk_async;
 	int i;
 
@@ -255,7 +255,7 @@ static void mlx5e_tls_priv_tx_list_cleanup(struct mlx5_core_dev *mdev,
 		return;
 
 	i = 0;
-	list_for_each_entry(obj, list, list_node) {
+	list_for_each_entry_safe(obj, n, list, list_node) {
 		mlx5e_tls_priv_tx_cleanup(obj, &bulk_async[i]);
 		i++;
 	}
-- 
2.35.1

