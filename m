Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F214238FE
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 09:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237546AbhJFHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 03:36:01 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21140 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237384AbhJFHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 03:35:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1966aq6P029511;
        Wed, 6 Oct 2021 07:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=aHenArHQYJGlzudTQtXcBG3Kh4cCqNc21LB6uy6/KDI=;
 b=GbTrTY9npmbgp6c1qRcpc4RJ50z87QHukMB1wB/aK3S5wjVBJwh00h9nWjkc5FfsYbms
 AimdNZV5OrDTyrdJHEfnggcYfjcYQ7ZjhEq/07AxFHnI5JI+YQsMhCbd0anXZRTUEw50
 VWSRM8MbfdkVnsw2Djfrief4SgxYwpSdx6MuqyeMs/J6JQaglT6mwmfzduhl8U3+DrhR
 QgC4+qcY5fdFgNIozsI1GyMucPnnHLegYNkeS9MPOHScEgpDo2XmfEgvP6Nh5vo7cjSK
 4XWQ/z2HvHCwLTXV7gdYiTetzLfYn5Ffr5GhHQcJi6uTyT34MwmRYX6CdR99uw0HPpa0 3w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bh1drsnrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 07:34:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1967QgxN069714;
        Wed, 6 Oct 2021 07:34:01 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 3bf0s7xpx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Oct 2021 07:34:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1dHUN/mYWo5nzToYlPUXZ+GvzOrXKyKxBteppMhBCYNnaQIrKeEmVFi5uMKCXtfT7yHsQ6OtC1IExFfxu50lKqorWkU+GvoyRB8m89FTjEBGyqaLMNGtSI0gWQ1aioFEg9SARfrME7/grmuk5AIGDkEATII1pRG7h7IXSU6akvKTiT3NkU/lhrKRaU3ZKVGIJb/vAaEQ21LkubsKejdL6276eyUce6jb61/5U5XSViBL4hDuUEUishx3+1CqJQHoFBLTqUca4jZO95Pe+UzlkGbVzjAUPqsL2SifxNrptrZVaxynp3luUiA3yUqxFjiJ1t8qf7IyYZ2gvxvF2pncw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHenArHQYJGlzudTQtXcBG3Kh4cCqNc21LB6uy6/KDI=;
 b=RLFYqfjJI3xt7OtBCVVB49Jk/tqxYRiFZ+V2J5qCkrtsI1OJeGNvSHPf0kfHqwhndx+MVTK8FEkVgROP2KzEFk3iUD/OOxEKgZbsgFkQ112BbeOrVAeTqDKrtoMPkdhB/KLv5zLZf3Qv5mduEyGZvBOlqJRYvbn/vK+wczUfqqV/2+F3Oif6E8lfbL3sIeKZNzxm61rT32Yrax5979qFLhf1sgMjh3uoqehJKukV4JBeef4Ao+mHFgcBCsHPPzPRulUkUYfHVlr1rKOgzuRpnVEthNWq7Md0duD6Uyl57hqFYYGEAdSVBnpruvCBLOy4aSrFl7QnZDVeW+1Ru/JkAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHenArHQYJGlzudTQtXcBG3Kh4cCqNc21LB6uy6/KDI=;
 b=fDfrhmN0eViEanQIBWKDtmPZIlUH8KfDckJOu4vaF+SFd4xkeHfqy1ig/i/zpMSBhlZgRc6RAKjDZFYiBASMkjCfn29sjFybJ7mivAilJkkMf62DDsfW6fWvm5YUf2f0/LqDvTVAXIAHzvCh9K6Cv2fYuKacNDSXjRVlvD1Ow0w=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4546.namprd10.prod.outlook.com
 (2603:10b6:303:6e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16; Wed, 6 Oct
 2021 07:33:59 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4566.022; Wed, 6 Oct 2021
 07:33:59 +0000
Date:   Wed, 6 Oct 2021 10:33:47 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] mlxsw: spectrum_buffers: silence uninitialized
 warning
Message-ID: <20211006073347.GB8404@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM5PR1001CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::28) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by AM5PR1001CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Wed, 6 Oct 2021 07:33:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23e77300-16f1-4543-7ded-08d9889ba94a
X-MS-TrafficTypeDiagnostic: CO1PR10MB4546:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB454601D369034063A50A5F698EB09@CO1PR10MB4546.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KzAOkplbd8zb7tFNVj4rnAjuFoiu1itXlACVP/82Psd7xsTTa81lx6j+nn1fHpGko0+qOVF/inRFJjAEPg9E/6H+5gGElm/bR/YmvFeGMUcoEhG41MF+9lpMUGZiWmg/AF3vxQ5Jo2TSKQYRcTYamjaBC7bIcuwxaT0RhEzcUHGKzEXb1OvDqR6Yq2mn94/e93FWfe9/1eEZ7z6lpHVVKEXpnkUSYJCwsSAZj4DIWnrYTBEpSSOT9UA2M7EOKsor6r39dJc9kky0rSLBkZwxLg9TiTOfaviLi0JoSJVUqc74FTMRGkUMM/oMj3eWHPRuq7IIxgF/3xiXpLsprFHjt1ffNTOW/WBfAkFhlu6zuaAPfMVTYfN/Td1sgxQh1yJHGDpAIl6PD1tnyuNmQNaJyXECS4iaSKY0bDqhPwks8vBxQDDW3R0wAi97Zh9Ulz2sYroebKUTMJrmXlW+b6t9BRSBJ5oxnMPBRq2oHpUIw+cs0is46Ped1hnCZ559fvfuf/L+A+PBwgEjkUV6OVquXcUUCKlH8Oy+7C07nTEcZ6l5GklMpuh3aZ3CBNqGGrGDcUbv5kdSi6DHVpx3ut6OPkONoi3iBAkVWr3GhXJ7dVeqqjGGJneqcz7zrjdCm+W+BfERg2Hy6+KW4zcxLKpVnxeAOmj2WjCOKZJhXbud/ZVGrpXa1o4Dk/E08t+1V+eda8iXvS/7PcRk03VuEO0ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(86362001)(6916009)(33716001)(1076003)(26005)(508600001)(6666004)(44832011)(956004)(4326008)(186003)(2906002)(38350700002)(52116002)(9686003)(6496006)(66946007)(66476007)(66556008)(8676002)(316002)(8936002)(38100700002)(4744005)(33656002)(55016002)(9576002)(54906003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d316P4/zJc5ARCxHjTwMgtmtZZiaQaSaoxGjJxFwZe4uNlw7ZZG97ZmDBkFG?=
 =?us-ascii?Q?VMJQHbgPx2t20UMDN17LsJAmbGXA5geTUw+MrDjV7vt44n19kMUhqCmm2KFC?=
 =?us-ascii?Q?3dJIGPDFbQkRkAC9xiY7GqXiA35SLpMHr1ukF3DKOnCADJe9Mc6EBwEsq51J?=
 =?us-ascii?Q?StihTDiZMmwpC1bf3BX6uE1jr0eHsboJ/hAt2r1Nmims5xtRb/cG3ci81GZw?=
 =?us-ascii?Q?NXZSGPQcPl72D6UUAUjobygOMvh45JgRQsUHQ7nogQpozms1U3oJCH5PuD7X?=
 =?us-ascii?Q?b7FOgsfEVr5Rwe/KYfy/62Sb4Lr0XEWY7gtMu+A0H5gxgjkX/z9XoFfdayQt?=
 =?us-ascii?Q?9bl11GYEkuKUQg6Tno8XO7xGooVCgrq36UNOZtKTdrGsYEm8enoS+BT2RJH6?=
 =?us-ascii?Q?3bn0xWat+iS5QEK+77pi5G9WLJh1OlXutVNAKkpDBS6hpHdJ7oV1ClyTUXns?=
 =?us-ascii?Q?ai/o/ltnKNlxSS+Z7HQhkwgyIhZMyLgFsRe9mxAEGnrPT+leJUB/ba/T37Oh?=
 =?us-ascii?Q?1mdbLFAg5XzYs7R/eh1yvixspXsOab+OUTsqtKDJiKOb9fV/Zjh7Qy1UUgXI?=
 =?us-ascii?Q?3gDPV4pm04iO7bssfX+5FCulms++XQmzgytANKtlSwptR7ZJ0wSxT1mJZPiY?=
 =?us-ascii?Q?8iDDMqsjjP7zIMrLGMeHSS3fOm788O+fcMgtYGwaqv5SLxNo8h7u856ytn9k?=
 =?us-ascii?Q?E/xTFQSFjB38yfaU5h3xfyRqopjViehs4s0/+rhZutNSmsuIG+b4xFIU3YZy?=
 =?us-ascii?Q?v5swb80LBM8yxEsQ2c787pfBfjaS2NZun1YdhiinmjCD+7fiyO0eBZWbAl5P?=
 =?us-ascii?Q?wpm6vHocksqsFOkcmLG7AmmsZhf4dMjUnvwA/5RMxx3W27PK2L9MUko7bHOb?=
 =?us-ascii?Q?wZFkF8cFC/Pd7cSLA4tKRYnchIrO1dchA/4syROTue4M62J+PIRxwZQJ2Kq2?=
 =?us-ascii?Q?0LF7To/nNm0L2AAsJ0otvdI5bq+t97bQxc6pfQOPqe6LgOHyJUs8F/GXbb4K?=
 =?us-ascii?Q?SpS4ZWZyfpyDMnvxvdIxXqM5SQtHeEKky1OjKkDQYnqbPs5PN3gtvIgc35Gl?=
 =?us-ascii?Q?qcwjggG/tf1LcCJahBmni+aAPJDn6v3pt5hUgWCJaOHIKsfgLWvM9RRZ9dM9?=
 =?us-ascii?Q?N9X637XGip9nMRTudzuF50bWnUKZ9DE+R/Opk44kGgHeLk+RQPee1HF0XKCG?=
 =?us-ascii?Q?Al1G09s4MDBujsXEp4yZulc2ADTFP1RLMLZxkWhpGdxaxA0VD8UMmvVjZF/4?=
 =?us-ascii?Q?OfYKicsHBP9LWcLLf1ePR5/CR7s15X2y/inmnOgzmUFZaDkjmQTAqGWV/DF1?=
 =?us-ascii?Q?pAELvZd602dsytXtkYy7vjCT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e77300-16f1-4543-7ded-08d9889ba94a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2021 07:33:59.2145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZufiYtfJBJ2Uc0+z4PQDgliL0S+putq63AqvG6E2RO5+E6Ac34f+UHChP1hrNgJLURVM6GMHu4w1T0Njm+ZMglo37WR8yO/iq0OMud95jMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4546
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110060046
X-Proofpoint-GUID: 8YXwFIA0oj-EL_1BCdyuNhyd3cwVuVTm
X-Proofpoint-ORIG-GUID: 8YXwFIA0oj-EL_1BCdyuNhyd3cwVuVTm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static checkers and runtime checkers such as KMSan will complain that
we do not initialize the last 6 bytes of "cb_priv".  The caller only
uses the first two bytes so it doesn't cause a runtime issue.  Still
worth fixing though.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 9de160e740b2..d78cf5a7220a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1583,7 +1583,7 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	struct mlxsw_sp_sb_sr_occ_query_cb_ctx cb_ctx;
-	unsigned long cb_priv;
+	unsigned long cb_priv = 0;
 	LIST_HEAD(bulk_list);
 	char *sbsr_pl;
 	u8 masked_count;
-- 
2.20.1

