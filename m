Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335DC4F6CF7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiDFVkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 17:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiDFVit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 17:38:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2082418C0D2;
        Wed,  6 Apr 2022 14:03:20 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 236KgkMk012570;
        Wed, 6 Apr 2022 21:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : subject
 : from : to : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=X43pQ+H56BfUFdoFsRsk6jBfk+bf5QAG4c6xDaTV//w=;
 b=BsokB46RZz74g3HVDs67CAuoaOTzZ74reaarghIROD88xwnCnQ6XcNGVGN9wRtAcL8gx
 XszolvFU4+4xdzwlc8/blA3j5wtzOZZ9G+fw4hydKYZUV6BDfipY4zcXuii5hO92ZJ4R
 1MXAZtEapGQXOkVZbTzeHcQye2YmfU/3d3+IoxaIXtqKEvKKv6MIvptDgHnuq0Ynd6kQ
 XilOQ/tKXraJSWkSo5U65h6ior0ZZD7zM+oifsLYOoaUq5ErnV0G5R/mKnHMbPq8EH4b
 sl+uJKrroE4mUDsTZ0FIB0t+lhsqCmi1OkT47ttoriBDEW83/mSxxNGiBYFMQynVhta2 Ow== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwchvbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 21:03:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 236L1YvR005652;
        Wed, 6 Apr 2022 21:03:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97tskbmw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 21:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQvGGhLCkp2qaROMolbjmJBuAfR42CV+40aRCTU+NnXQnmB2D/aEmBC1l429CdNSj3O/MmXIh8Z6tZnArkmE1gG0n/pfUDoGxnKpUcuxi6K3CutMzGpxWWoVLPBxtacU/ffl9OQzSpvXGxdd2iZXOUeVJ2f+M9W847r9gTdK4ah6uqzSsf3DVfY0ItssfMP3Zl5meqDmsqZUzQ5CBYWiTvpdcfP1wLLWjy2vag6Zm+kqIdx97MRDEeQMmrHCk1+ib3AjHFqzp1trBWo8h8f08Y2KNwwVYqypS5canbirASVHNVPVrvgA2CAiyg3bHpU+VsqsSw5y6oWQJHQYnfu9dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X43pQ+H56BfUFdoFsRsk6jBfk+bf5QAG4c6xDaTV//w=;
 b=ZiK8YCrRPCWol/GqOUaNkJtpCjSZOCHjifbO3oMIyw0D57b3FS0HFuGsQrqzeeZdXGI+j9QPYlNm7i/bX7EyGl5YXCGuNCCqDXSvr0K7/zK6NtYbNQRtixyEQYSa2Et78Qx85Nvmuvz3EH5GrwTmVjmxQP+AfChMPxiObwMlnSdrxq6md8P4gdXUrTYmYhjrSWWqKgnmGoKkocP7duhEdlyM1Pw27M3pnbYiBkNjjpmL+DmWSMX/4uS7glmH1DGvrfinot/BRKIj/bSUk/Un7xgF9Os60NeRFY2YJf3LMgNa71glAv+XhvflmJEix6gbeEA98eZxXW2GfCJf7fSvdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X43pQ+H56BfUFdoFsRsk6jBfk+bf5QAG4c6xDaTV//w=;
 b=izsFY7N4FXxvQRBNlU+Pf0oIUlDC6ik0aM8Amw+kTFQJ2pfSOugYt6Byjyz7E+IfsVH6QMFRFPaA214y5jv7nRV7QP1DyKMEnscs76gs4ve46PYuxDihl8WMGa6LzysVUcyyu2A9v71Iu1fzudkJBB8MbC04Ob2ebgZo041wTcw=
Received: from BYAPR10MB3158.namprd10.prod.outlook.com (2603:10b6:a03:15d::23)
 by BN6PR10MB2004.namprd10.prod.outlook.com (2603:10b6:404:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 21:03:07 +0000
Received: from BYAPR10MB3158.namprd10.prod.outlook.com
 ([fe80::4dfb:2e30:e6ef:88bc]) by BYAPR10MB3158.namprd10.prod.outlook.com
 ([fe80::4dfb:2e30:e6ef:88bc%6]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 21:03:07 +0000
Message-ID: <47050fe9f6f26f11fc14ff0ac06547f73ec3b81e.camel@oracle.com>
Subject: [PATCH 1/1] net/rds: Use "unpin_user_page" as "pin_user_pages"
 counterpart
From:   Gerd Rausch <gerd.rausch@oracle.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Date:   Wed, 06 Apr 2022 14:03:05 -0700
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0054.namprd08.prod.outlook.com
 (2603:10b6:a03:117::31) To BYAPR10MB3158.namprd10.prod.outlook.com
 (2603:10b6:a03:15d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f97d6bb2-8b54-4b84-2102-08da1810d950
X-MS-TrafficTypeDiagnostic: BN6PR10MB2004:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB20042DE4761292EB4CDE8DFC87E79@BN6PR10MB2004.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pM26n1h+xdrDXeutyP6g3zhlGcX9LN5HFd14oZXb++FS4XW0mwyEbxSGLpSqSbS4k6+lT7o77uJXf6wYqTHmQiPaAw3EdQ/m8ZlTLeMccBhFj3aW65USPiXCio7fIOeClK7b0z3PUkyWrQPssuXkT+cG5FKQudrULZDpNMzl3UV5qEw0qOklstk93wKqN4/HKhZMGcO2f0LXBxQqudj7VEDVHDHonyGGRmh7lkJsfu/C4VesFIxt5qDGC2EJNJaUA30kOcospkwnPsYKEdVxr+VWjpwV8nq82TeFlYYthR7mEitgVLCqnsU418XasMbrufCGph5zSD0/xxc94W+Bc2Vt8oqlYbl7qOoJ/Phv6rA9tgDKp6rVjP1Z4Ig5pv2YdZLJ+C2uaB8uOpzjxgfoDODTbY8TTgHhbJIzsGqq97FausMX3bPyQlB7dge6lewu3U//T2ikSu4wCwII8Fqrtz1FcpBAoG1dtvD4eeCDyVfsb4qDx872mf+ikUxB04Hbve7sdSN7rfdznmffQGr7eQLlZWRdtS7hhy9eRzBqqzw14ZcA0oWo0kZc0Lt3OvtOBuKorWPQeiNaR4vpD11kU3iwO1lDh5rJYEiae+DXZLe0IA/uyihgVQsF8Mp3EaeZ9HDXImximO7n5/T1BlhhBZXe8ZVs/Y8HabD5Qk0hu0kyrWU9QmxBwoSrR/w17KgC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3158.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(83380400001)(186003)(52116002)(6506007)(2616005)(6512007)(38100700002)(6486002)(4744005)(5660300002)(66476007)(44832011)(36756003)(8676002)(66946007)(66556008)(2906002)(508600001)(316002)(8936002)(99106002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-15?Q?vetHEQgjqfu4B4mOYqJSrJogT2tpwWdAFSgWwDn0k6ghqhtqlkTh3YKVL?=
 =?iso-8859-15?Q?DEP5VegHl3hBbuqNKoSL1VfwiXUx2InKs3K6CcBs2FJ3Hps5r8whIs4Yl?=
 =?iso-8859-15?Q?KkY1bmKxMNwO48nHAGMal8lpuMniwu0CfQ3pvCgiizAWmdDLGM4Nm49hz?=
 =?iso-8859-15?Q?zRpDIzuvF9lHhG5Hsbxwjrv+/FqjAnXdbnhtxOTqKYu2S1pA7NrF0pwQA?=
 =?iso-8859-15?Q?CZG4AbIwAOqKcOW2d/xYh+qUftcZjirsXFVA7Ppjqh3w/SgEoB9llLwLo?=
 =?iso-8859-15?Q?d/BpFnQVp6Nwelo1o8XDrtNupOuIDmmmF1RBg8pRqTZYl8C4VRGq5T9rk?=
 =?iso-8859-15?Q?MG9wD+hLNZBKqmIjrVpabBzsuPZ05Nlx84iNHCUHmzWPuveOt/YGRAe13?=
 =?iso-8859-15?Q?1p+5uqsMG3OPibt1FI0UC9Wgt3Ji4InEyhs2zAj3oc+BV3RfrsQasAbX7?=
 =?iso-8859-15?Q?Kdpup3lvGBj0FrvS9YS4JorHvCBF9eQto2/brb48JZ1aP+E0KZ7TAPorh?=
 =?iso-8859-15?Q?kCgmd/ztA/85EYY0fFFzP66aTYU2v7QAmnyZGu+PJ+GOZ+GZGQw6Fdr8V?=
 =?iso-8859-15?Q?7vD+nh6+BPB2u9+GgeazUMuh4/QhjSU5Z65vobXV89DpaNqE6axewSA+9?=
 =?iso-8859-15?Q?g36HVN6ZpW2O01Qn7pCc7P+ALRC3VCgPz6GKojoKuYFOsHvaO2V/3tyX+?=
 =?iso-8859-15?Q?altbM6Iw6fMJv4m2Cb4MKqzkY7Uvj527JH2IVZpr/uUJ/fr7TaQfQXMTy?=
 =?iso-8859-15?Q?S2eOGTKsutMq6CTbD8LhSw34nqtkEjTLFN/QkG1CJAYT+HSxKvr3ktegY?=
 =?iso-8859-15?Q?FID6JEWZaUr3DWp07hTpK46JN/pFHlExcLl+QiDznMPJY/Va7oZyDlfTR?=
 =?iso-8859-15?Q?bpO6gKNFrYAgLmxArKek48BL0SIVoFv4wRwFfMZUGkWFRI/MHVKykT+vw?=
 =?iso-8859-15?Q?+gROGVf5hI9ZYLeZbGb4ega54zZt49TDmzPUOcygboDlAuo1NHfg5gCDr?=
 =?iso-8859-15?Q?t9V/0XivWqs92WJsAiJy2NXzxuitwBc4mZIGQJ/JUcEfZso9AMCOFbHEu?=
 =?iso-8859-15?Q?xywiVafsU4ajELSMqMQmMtDte34bQsejMhZFZjTZ99HIzpcLxkujhmkix?=
 =?iso-8859-15?Q?9Z4N+qh9uCX6rWtl9mERgSxnZ4R49klm8bdOm8Lw0ZbGBRuiuK1YrQiIK?=
 =?iso-8859-15?Q?e1s+cgNV8Ow+65ZBB5qjWeE36sRjcSsnyOAG+fA3RxCXsleJU/l3rj9wj?=
 =?iso-8859-15?Q?uBk45a+mbLtxUB7E/qg/tgd1YGduYdzQQek2LDPb43Oj6TPXzvqWSFdi/?=
 =?iso-8859-15?Q?oSsZf2cf8/G7RM8pEyNxNdMPVFuRyV/0jZbKCiarHQPRUU2cYQ95SfAx5?=
 =?iso-8859-15?Q?OITzAn+bilAXyVqzckwVZmm02yWuQ+3RT0t/JO17KMMs2w8u7l/KmpJee?=
 =?iso-8859-15?Q?IWOzheWoxxT8mTxibg/FCJsmZrWUOvky+1Omr2MTnXZIfemZABT9jO2HS?=
 =?iso-8859-15?Q?vdtMm7y96kEPNim9HSFvcbKTNG3zgbTf5bQkzcfL38ZoNxuqoHwiidjKn?=
 =?iso-8859-15?Q?9Ud3zp4EeftIldnrdtarc7Tl1HrHBPY6ebYqDwpKgGgjcl9dhWqUYn6Um?=
 =?iso-8859-15?Q?jkeuM+Aick5i38tTyZZvsxtN32hi3mJudqxFhf1+M2OWwaPSOno179xSX?=
 =?iso-8859-15?Q?72aXSZ6CTSIazKD2CnNCMXHCC+HlhBza60f+EjP1aEQUSsWTJ1EF33yak?=
 =?iso-8859-15?Q?Mbn0sYeSt0o8jnYGKyqJ1wC1xkZUBlR8Cd9hAunvpPn/f5j4Na6jOwsQk?=
 =?iso-8859-15?Q?YJMSwUO6ANY4Y6YYQWYUepeQJSvBItYLCGfGBr/3S+jKytdtRzbzApTX6?=
 =?iso-8859-15?Q?wSLeqfMNjUgsRNCjCu0HHFJ/7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97d6bb2-8b54-4b84-2102-08da1810d950
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3158.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 21:03:07.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 28J2DQyLq5qrQK2khip56lMVpxK1hSnJnCTnpyW+s5Phy42NI4tU2rh/ydDRDw2ZptNl8Ydq7VlVfnMM9IFkVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB2004
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_12:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204060105
X-Proofpoint-ORIG-GUID: 2982oYPuI_buqlu63NyBv4pwK1tEmtjs
X-Proofpoint-GUID: 2982oYPuI_buqlu63NyBv4pwK1tEmtjs
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cases where "pin_user_pages" was used to obtain longerm references,
the pages must be released with "unpin_user_pages".

Fixes: 0d4597c8c5ab ("net/rds: Track user mapped pages through special API")
Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
---
 net/rds/ib_rdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 8f070ee7e742..9d86d6db98c4 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -256,8 +256,7 @@ void __rds_ib_teardown_mr(struct rds_ib_mr *ibmr)
 			/* FIXME we need a way to tell a r/w MR
 			 * from a r/o MR */
 			WARN_ON(!page->mapping && irqs_disabled());
-			set_page_dirty(page);
-			put_page(page);
+			unpin_user_pages_dirty_lock(&page, 1, true);
 		}
 		kfree(ibmr->sg);
 

