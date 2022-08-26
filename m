Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05BA25A2A49
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 17:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbiHZPD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 11:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiHZPD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 11:03:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF1BD9E93;
        Fri, 26 Aug 2022 08:03:56 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QDccBl006811;
        Fri, 26 Aug 2022 15:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=lQDGpIsIqEf1gxRXqFxM7t+a5T863++LojWinDC8JB8=;
 b=Q8/R358v5oA7VV4vKxEVATGqoZzXXVWgwj+kC/GLm9ZVrY59+m6MW1pLDJ79PFqGPZ6B
 9qkmMmkFscw/m2gXDQdnIkkDyl1sucTxMazc/JZn3MS96kxjtjhsbaBrrJhRKj/5+wHy
 WuawStKeW54SG/tuKLxXTLQpzF8rI8ZTpkc4TLLcBMVbqVQZQh/CcWQmwt5inq5OXNdv
 cg8GR5syMstHq+fmYpC5uzv+RXcR1bIv9OUCvKn1slM23ueQp2WenNle47EsQzLZGC5q
 t8Hn/McWfciqXTB3JS/SX7N1EjpIefwnMZZNLnTuTgzJn2gqt78My5E8AqmAXWN6aQVO Eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w241w3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 15:03:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27QDqItZ028265;
        Fri, 26 Aug 2022 15:03:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4nx8cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 15:03:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rc8btwjLH/yFOAEHnE9zaKiYHVduTjaU/l0t3dNWh9+G84m4MvV9ShFR4fNuZDYQdginChVGlGZJiSu5hf2O9LZH1u8sZ5zcxJPw77ugllskyMWnzp+VDxhlL1jB/SBXrlOsWihhmSGw8aYzLYw1zWDzsGJn5cPlJ9lueQ3iluX5jjs+LAuLjJR5vvS3IvDtgVGUwM4V2m+s/YjVo4NnhA4E1dPiEqq5cEiSxPGnoUj6f8/NxMgHiMVHbPPAPvDoxmkGLMQspCL7fdzSBiv8npdUB6jmRxrzTmpxSvghNtr59YmBrzqYLSnSmjJY7AP0QaN+4Mpn0FkZAaIf6mzZTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQDGpIsIqEf1gxRXqFxM7t+a5T863++LojWinDC8JB8=;
 b=PXV7nygksu7fAbjYaXbDyTORSK0zdbhJsTAmtYBeS6LA1+mDEKF/cy36TJ7tCVKnDQy+d3KedUx4d/OkryM/oQYaFZWYnQPf61rraHF91zdNOz2jKkMMoaSUvFpTU4T0T4E23sgGcKpnrB24Oh+/lpOUJBnF/aIBS8Xzi29biaJaosFV1rzQ3LC3dmpC2j+Dvi9WyW9BDnXCjUNpW7oe3W5b+3YGQu63I5xDH+fky9b3aY+5KqbtwNqHQezyJ5K/v8uPF48AW0QqaBI7u0xuUzqea/M6PjGrw+DG9HNJSfU9BemLWXz8moWs+f2V3WBCLP3rqZn5sN5UXkVmO1wi/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQDGpIsIqEf1gxRXqFxM7t+a5T863++LojWinDC8JB8=;
 b=eP+ApUuZGYGk4QhwsW3WnyAdMe1UVUMIq6myIN32/l3tF/CekkKZp3wlRzRjyJDjSHbIRuIRym+u+W7fDjx8RS5tlWzFDmZOeNedFDERwdkhjur1ezs7wJOMTH937Qx20vQKkNpWxUQ0ZCarfTvzH1O3ZKKmrxVj1hIP/Vrbfe4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1389.namprd10.prod.outlook.com
 (2603:10b6:300:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 15:03:41 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 15:03:41 +0000
Date:   Fri, 26 Aug 2022 18:03:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>
Cc:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] mlxsw: minimal: Return -ENOMEM on allocation failure
Message-ID: <YwjgwoJ3M7Kdq9VK@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0071.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7d4683b-6202-4a3c-9699-08da877429b4
X-MS-TrafficTypeDiagnostic: MWHPR10MB1389:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sfOcO77H3rZ2Pg6X6V0aF0FbrW+IsTK1HspWHJIgllhDBwGoJ4RBZAG59NRrfmmCddbLCO9DYmOta524ONdtRvcSbFZF+bTJK3PhGu/FkEwe2OffUd+8EgfyiFXsmwAzY4LLs6HWsyEaVFChjkccaW2knCHfZnH+uL1ZWRDfnUjGLyNKRrz22e9zOGJfEFA0XkL+5JE1Z3EfXwtCyyUQA56hj6mj5JFPLV+wpdtM3z/xu6A14IuGMgaPoBf6DmJRcYghQFJr0L9YYbeRMDMTih2rlWbeiTPNTvZ7xdVpYVGHxU8h+qptxK7GJ5irRCYJ9NBpCAAUpNCY1tGro+D8qELlKNs3MCK6/jBupa6oTeqTG2YuLY4SyebHjhP7Xd22n8ZMJR76CuqGb7pGcGtdApuzJEKfxIQyDU0qc+D7BtHtZyl1oLstJ7nVDlF+DmhEtFzEMAx8U4EwRSzuSrjA9TLoMQpIYaLoEEC9edSq/o3g7lT6d6BkMwlPBoUVy4XU7aSv1Do0w8X1n86N0Hco/NCWWz0psX4vpWkksmA6tMYBAgaRFkjj3GQVYl2ONzYkisTluUXe8rwiFbkwZQ/OUKVqsYOxui3afpit2tFKmh9Me4c3yVtUrYESq/8oaVWDW6OQcg7j/NaZpjdiOqsD4Cg1OyAEGoNuLQx3TzpunKWrp2lpIg4rhaHtF36joHQNBWooNcAglF3IQbu43f8e7kKLMh/OuQUWEjRoGPOyOamRSOO43R1dbzbNm0YDTW4oQ2dIEu/Ris+WeSlH+S0G2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(39860400002)(136003)(396003)(366004)(9686003)(26005)(2906002)(6512007)(110136005)(6666004)(6486002)(316002)(54906003)(478600001)(52116002)(6506007)(41300700001)(86362001)(8676002)(83380400001)(4326008)(66946007)(33716001)(66476007)(66556008)(8936002)(5660300002)(7416002)(38350700002)(38100700002)(186003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FSbO9gkE7LA/cNWMRhjmKh8qlQBneSH/tRwx2o2FoHPW/C9AcFjBcaPv5C+4?=
 =?us-ascii?Q?USuQCRB3W3e1537RWEpfx1Q19Wca5ZJI0rKAfcWxge0Onl4dvj7F1emDrNwF?=
 =?us-ascii?Q?C8g443XtxbVcdjmY9WnOxu9hqrUnAbvsVzRFAe4ddQPM2eWxyrltJ8FUzrP7?=
 =?us-ascii?Q?jCu1JTnZupFiOJBWrmoIUm5C53WJQkXYk32jpLjuFaeGpx7GpAHjmUWoSWlB?=
 =?us-ascii?Q?HnnE22ZSgOZb2ogzw8OPwXkzXxC5LNVXBFOP9io9YVQHe3SJ2eUUtqNPBcGk?=
 =?us-ascii?Q?H6CAqMJMtpNESNhPamR2do52ptuFgXfaZ5x7rsRYdDthK6t2GBB+DeguskKS?=
 =?us-ascii?Q?MnK6epIKiJf50EA3CqK02uWcI81dtCRi2A2GRn3Xbb9v8t5JJKkT3/4WvijQ?=
 =?us-ascii?Q?P2iH8nWVZ+2Aigr9t4aqQI2jHQp/3RWwslQvXQALGmX+G6um1lPEK4v7OCO0?=
 =?us-ascii?Q?Ys1cuN1HnBoQpuZkSG0CTcIoqMRBr9YJILGLZkHLPACP16zSAOwxnJ3swCNM?=
 =?us-ascii?Q?ap4ZDY3lGrwNeIAvEMAYeH2sYByg6Va29FeulmsFH6xzk/uArDn2U42AzZ2z?=
 =?us-ascii?Q?MNxA1zIidss6Qq29EPN45dLNMUyZx0XxbpL9rm4yyLxf6sQz7ZuVJ03d9eKf?=
 =?us-ascii?Q?B3/eNooZCUu/lOZaFYuXVPySNKp1tmwIaU1Zg5WyJvpg4jGH7XsQuzFdcszY?=
 =?us-ascii?Q?0BbZxl9ZHOede39wfNYYr2YORJA8YRLp94J5mohBDHoIsXgX+bW+Sk+PP1Ju?=
 =?us-ascii?Q?wMcLpvsR7kTcQKpsOIHT842wBm2xGe0cr8QZ6wA8kg05hC0m6kNP/vLZB1qu?=
 =?us-ascii?Q?l5uX5PZhQwEelDr0Btdy6XZo/BLNrnx6BRlrseEjOjRyfajsIeRxn4cMZhsu?=
 =?us-ascii?Q?55W8IVnWidbdYLTXTiUt8msCVh33ilETlfNmvUiQ2zB6b+Uk7TecRyVrFBnx?=
 =?us-ascii?Q?CM62q7JhQi+6SIm9X8Ke8xr3NFyzi6CWpmcgPiGVC4v9K85nchFsiAPJDgtv?=
 =?us-ascii?Q?BX/43vDEjSoFTJxwSk5nwAWTNiDgwLFdHzQJPWDppls6PVdoa+XE8pPFwK15?=
 =?us-ascii?Q?Ll7NlcVOkSzb9/TO9ojzuJEyNxfu7c7iuLevRTTgshOwwFwRN61E+a+f2MjG?=
 =?us-ascii?Q?GFHH0Jy3Tq1SXKRT3VkIQ1PRS/xKl5bnKO8h34+veMIcDet91poRrKjJx1iH?=
 =?us-ascii?Q?SJo6CCR78oZFboorHP6SY6ji3I83GNEq7+V+gsU0WhWXFF5qonmn1wuGl3+C?=
 =?us-ascii?Q?U1p8jtYBvHHD4qLzn6X5FEVH4O4nWc16r1FZ2DY91h/uRJcQGuht8TZMUehi?=
 =?us-ascii?Q?zPyaDLZ6c76PDfRCWoVV6RTL+fjJ0PXxb5Qh4rritr+XgvuEBKmdJvC+bU76?=
 =?us-ascii?Q?HsvGoh1nixnJZc0FDA7QVf2fcXlbIBY/uxMw8UcOcO4QpBc2uPoUNQQ0inKL?=
 =?us-ascii?Q?/DLn+hBNlA+scRPjb2KRvsMTAgDg/9P1rIGRDaFk27HGltzznOog59YK4g7x?=
 =?us-ascii?Q?Z6RH8zou/ge1Hqbp07J4lAStA4xzh+NdTnQTFyjckZnbUQHPZ0W1911w6Ii1?=
 =?us-ascii?Q?Y2CdcANIWtShKX4TTI+UI2DOj5PiiIcE72qd781r11okqvrfKnfsuycwYqFZ?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d4683b-6202-4a3c-9699-08da877429b4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 15:03:41.4815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTX7U9FO+O4Ay95w0Ph8nZVLnxVlD4cIjg17/dnxdaF7HNcIkXtPdHtrPzZWLy2azTnIsH1gAl+fUHBEHpoZdgyV6YDFGhKFlz49kZDxsC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1389
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_08,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208260062
X-Proofpoint-ORIG-GUID: g-fcJm4ZqbsSVBY5AaxDCMesQTT4N8Es
X-Proofpoint-GUID: g-fcJm4ZqbsSVBY5AaxDCMesQTT4N8Es
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These error paths return success but they should return -ENOMEM.

Fixes: 01328e23a476 ("mlxsw: minimal: Extend module to port mapping with slot index")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index 7d3fa2883e8b..c7f7e49251f4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -404,8 +404,10 @@ static int mlxsw_m_linecards_init(struct mlxsw_m *mlxsw_m)
 	mlxsw_m->line_cards = kcalloc(mlxsw_m->num_of_slots,
 				      sizeof(*mlxsw_m->line_cards),
 				      GFP_KERNEL);
-	if (!mlxsw_m->line_cards)
+	if (!mlxsw_m->line_cards) {
+		err = -ENOMEM;
 		goto err_kcalloc;
+	}
 
 	for (i = 0; i < mlxsw_m->num_of_slots; i++) {
 		mlxsw_m->line_cards[i] =
@@ -413,8 +415,10 @@ static int mlxsw_m_linecards_init(struct mlxsw_m *mlxsw_m)
 					    module_to_port,
 					    mlxsw_m->max_modules_per_slot),
 				GFP_KERNEL);
-		if (!mlxsw_m->line_cards[i])
+		if (!mlxsw_m->line_cards[i]) {
+			err = -ENOMEM;
 			goto err_kmalloc_array;
+		}
 
 		/* Invalidate the entries of module to local port mapping array. */
 		for (j = 0; j < mlxsw_m->max_modules_per_slot; j++)
-- 
2.35.1

