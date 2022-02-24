Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772D54C2EDA
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiBXPCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiBXPCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:02:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFCFA94C1;
        Thu, 24 Feb 2022 07:02:04 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OCYY1E016893;
        Thu, 24 Feb 2022 15:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=KFk7YYN3/CO7VhAJPl6bpO5cj2MiTv2Y21AibOF9lyA=;
 b=LpB75/N3H1yk6HPMpoN5wx2u842fZUedw9ie4MbYgEk2Pb+QScUsXfPtDL9m3hXjUfY7
 mFn3WtOpYX7rEJniT/BIPXfOzI4DgTD7q27G4wSDSfeoZlhfD0Hqm+2a+XEOSaFv4SkB
 jByVhQDgB8W9rZSG0Qq/a2jBwFmvIa0tPt42X+xlKkUy6akBAWE/kn7LEuDoFM4T2qcg
 CgnKrjK+h01vVg+mTkB/cRNSKw3mjW1KyGTDVqbN18cGckTnXYsJIPxy/FPG0ZzEzxmW
 9ugtGr7mXUbb1LymOCHI/z01Mz2Y5VjeeOJsI2J4lJX/a87La7bABiu89bdc9SDZ9Jyc Aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cqeqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:01:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21OF1g7P180557;
        Thu, 24 Feb 2022 15:01:45 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3030.oracle.com with ESMTP id 3eannxk106-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 15:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LtkJtrDFpT/LRfY2tkHdkOzT1pR6SdRudb3KXTr1IOIKnNDRyAiAKFvUsrbQZd3AQK6P7v8cOKsRmRlibfS3PlPjEflXHvKGI09MiFsbnHRr9XlxczV+hTPd0iZOrPwOgcIi7XWuqwN9BW+7GcUBkSEWS4ItA3p47n1VFm48319qT0QMBWGrXSQHOLgkuNBFTrdeEEsh6vZGzEz5PJGk0aIzzRr0ExViSDdqbt95o8qK88ihvEWldyTXfPpChEKtm31MItk0Gy+GJPFtgPmayi5iE0fhwRZsndvcHZ6f0Jf0iPu0SlgPcy3BsLmxYxt4sez460akf/l8j4Oa4o+l3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFk7YYN3/CO7VhAJPl6bpO5cj2MiTv2Y21AibOF9lyA=;
 b=luHiohdVUAve+z+aeb8ntIbRvbRGXCE0OKJzgwUk7XUr7k7bzjPgdgXPmPpzPIw9jSv3M97zszWXeJzO9GOihluF36mt6W9Fle4k7DHnP6HldjhZkBlm2+eSkrBfpscIYQp2byChdwL2iFpXgQo6nfAfTB1Y4Z38Iimvs4ACp1+n8TEXMjfkqCx1XlhNdPzFuS35gS7mzGckcGABdvjNphCYfP7RAMX1qFVxkMk1kRH2bbJVIMgoQMTfFKv9Qss5BrHrW0GebOsLW2Mhvwx8GvLuhdu+GUI9X/nM+jwl45l8T/jPbHPE7KZuruK+BFmX+Xs3nLxQymhRn3/DQ/3PPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFk7YYN3/CO7VhAJPl6bpO5cj2MiTv2Y21AibOF9lyA=;
 b=AadbWmeB7SvonWDzkowV7QtJ4T8/KdOG31MRAcCAitSvPCI9ugJ2uyTmsmIE9vfwMyc8Ijbjua2qEyh6cBtCeJHG4uYxebDvrQ1yNomvnGvbzuYVjtHPYzQqiIdTOA54Y+eN9I2ff1m66Z3D6XfrU0UUOEymJyszS6Kzso7oYEU=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN6PR10MB1250.namprd10.prod.outlook.com
 (2603:10b6:405:11::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 15:01:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Thu, 24 Feb 2022
 15:01:42 +0000
Date:   Thu, 24 Feb 2022 18:01:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] netfilter: nf_tables: fix error code in nf_tables_updobj()
Message-ID: <20220224150130.GA6856@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0070.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb55d314-79fa-4595-2a95-08d9f7a6913e
X-MS-TrafficTypeDiagnostic: BN6PR10MB1250:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1250352E602364398F95E2308E3D9@BN6PR10MB1250.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4c/679se3DFP2EOLIy1+i1tj/kXlA29RniEygDa3CO5KV0NzqID19KQYHJzGBdl/cUH5jMbvKtuPjOxd/d3gFe790YfSfu1hbEpii5ph987DiOzhM33J5FvQ+MvYud7VzsyP9LujWSZPkyqPegSzRGDV9W8JZ39S70nvJCizhDOH2VGF/anuK/hbkScrybtSMNRQ7twdQXt3u9PoH15N59wysCcmQgiMNbb66BB//IHIDyRDcwX01Gs2IJ6mn6fQKxVUoe9DMhsHPCbNW+0AS5HR4/8M0HtVe0oWqCK4n0u755rFf0QOKssZltEqjEfyylYEa4iJkrpGhU8rJ44SwkLSmPoDOUywmRVapJ0d8eUmfjCo+YOUaFh1ih6aWwFk9ahboZEU74GPDieN5m7IW1HUeIh2odp2wuGdcZUsielHb8B0NUQdjSwcXuBbHwohAV3uEN3XE9D18HwPS5V4/lFZG8FO8qc4hkUh5Oyyc+1kei3aAnlIQJ+qiNyDBi/UIyFUz98IfsXV1sw1fWGrIjqZNssyrB52X+AXWiAbPacqQbquMUb+xWgu6gG5DxF8+G0Pa1vX/+ZZpEkPb2UURgEfdaasQz3NLIMyNJpCukYSpWFvuKvuycgVISJvlYsnOgDffuc/F1bkekYgxSSAePdnFMt4SjkLMhC0syoz25nwFQiL3wOGPPW1uadPetHUgAQjfxAWvU5HE8Qi1It+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33656002)(1076003)(4326008)(66946007)(66476007)(8676002)(66556008)(110136005)(26005)(54906003)(6512007)(6506007)(186003)(6666004)(83380400001)(33716001)(2906002)(52116002)(9686003)(44832011)(6486002)(38350700002)(38100700002)(5660300002)(508600001)(86362001)(8936002)(4744005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkd4Sl5ow7zgzQrf+mgGXpzKZyzBQCr8w9bE0dCMw+crHTWXVQxnFA7HW+E2?=
 =?us-ascii?Q?W0c8DdJPf0pEOnIusBFXJB20L73Ud5ti9ctg7ZwCdaAgy6dZbD2d1Qa3IU8r?=
 =?us-ascii?Q?Z+4onBIpm7BnXjQ4sipRJc+RVLKqFQkd83zEP09613AhEk3y//9mX4XhYqgE?=
 =?us-ascii?Q?A9kFmO6SJZtPB9daM/V69QHMu65dk1tU4eIkX7fTlXeViN76HUTmZFBO9luQ?=
 =?us-ascii?Q?Jxavi9IexZda57nNViXftS79MyndBGVMAj98U54VVtgyl4tNsn3E7OjHItAE?=
 =?us-ascii?Q?SoPqw/kSdiiPtoKNXFTMz+B94uu0zb2M9rOSEtj9il7QPahpEZUN6NV3SZY6?=
 =?us-ascii?Q?ETXf6tXkh29y4zjK3tW2H6hrnGpYbQpQ5BSGAvxye0GVYJlTRNfFN4YicK7Y?=
 =?us-ascii?Q?l1yMj/Yg2KhkjntbmfNAjqY1XYgPfNO1yK2gC0huWMw1vEdNEUcm6W5tNLYS?=
 =?us-ascii?Q?ZuZXMrxWB1xQ55WsF/iefFmsWMW8uaqSnnBssY9Av7MMIQkEc2867MjJLwe1?=
 =?us-ascii?Q?F6yjZQn3zMElPcmmG+wW7pL0gkeBydwcRN+ahfyHIOU3aPetX+1GZU0vAo1K?=
 =?us-ascii?Q?QAJwsbk/r9ele8xM4wqN28JEzUNOJ+55Imc2dfcig4jwaj9v1kkozlE5dZjO?=
 =?us-ascii?Q?kAKOel4KgTiBz9x7vGVmoe5luy/DtnlXftaCOdLFaAfCtdG2CBloFWW1K5es?=
 =?us-ascii?Q?pVJvOBHBXe0wVI6ble89EdOURTG8quwojA5svaCu+4C9eLG4pZHqVc4eSjO4?=
 =?us-ascii?Q?pWB2/0g2tePFIIigaktxxTt7+HJcUj1Jmsj10YbK6qfKa8vC/fDOnzzt7/vS?=
 =?us-ascii?Q?XZaFlFwBt0xeSrp/5d369vzq7zkXoj611VVLKwlR1eVNC+qo7hmaiGz+NpYn?=
 =?us-ascii?Q?gcKhLMNMqKJW57DP/AoviWup3NhC7+J531FwMT3Mx8QYgCx1o8cVC05NzBXd?=
 =?us-ascii?Q?JQD6RfHsoojk5ODoUyYVDPLhyWFvCU0efQa4LFb1yQTeD5MAxfP+qbN1D2Uk?=
 =?us-ascii?Q?YxfnKBGf1w12ak/F9ZSR6OuYnni2lC3TIkxOajArHRNyNMFAhShw/ifIcTtZ?=
 =?us-ascii?Q?TAPbNGKCnGU5potvYViGAHlqZPTk0i/ypY4xY7hE0Lw9O3/DGenXFfV1G8su?=
 =?us-ascii?Q?KiiG8MT0IME4UOXXSx7aQo8uXXQRKADjXLK8YrKrq2cof+4z6O+ZD5qr8yW0?=
 =?us-ascii?Q?34MDa9/SFdG+t8jmCqyMbA/neP/rS5CuGiD0WDDMx39qRuu9Sb+0RdpwfX1k?=
 =?us-ascii?Q?ZjA6PcpigQ8EETp/VBgWpE3ogbZXq9RgqNHirjcf7memAR8GZribXp/M2LgI?=
 =?us-ascii?Q?VlUZDs1HqQbd/rRJdaMcGgZaimLfmC9SKxQlkA3YSWDkuybuYpiLV1ln1aly?=
 =?us-ascii?Q?3oPuVJKxVM7Fgfh0gwQdkuPK1qbWkirpXxKNcYFPG1pgmF1vve1b+R2Ph1Y8?=
 =?us-ascii?Q?9NVOUkuGL/LjrDZAF+0Ufz9cH3LrVw07GV5d5/piPZDPxJb1XZduARfF4Myd?=
 =?us-ascii?Q?WnVv9zlJru6UkU88eqVU+5KulwugmiuqP0ya6RQsTbv6JhuV91x0Cm2wNK+L?=
 =?us-ascii?Q?ls0Fdo4cct3TE6yssSV+8vAM0U8s3+Jiqb1lG+YjXgjEBDhfPQCtAQak+d1z?=
 =?us-ascii?Q?tRxTo81QltxZPnDwRB8WOJc/PhIX/izmEED3TBS1tfeOdLD068DsGIaSor0e?=
 =?us-ascii?Q?nHy2sw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb55d314-79fa-4595-2a95-08d9f7a6913e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:01:42.4912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8DsPjpuPoddHigmg+jMZewBd7lnvK9z9iwRe4uDqG1Hyb1svDPhn+tNgUvduslf74R2tKOvzpaCI6ux6/eNaTXHBOiXFttNoTtSR1AAiMLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1250
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202240090
X-Proofpoint-ORIG-GUID: lNHusckupJSTSQZPucjHvUhFMJ5E2_0f
X-Proofpoint-GUID: lNHusckupJSTSQZPucjHvUhFMJ5E2_0f
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the error code to -ENOMEM instead of leaving it uninitialized.

Fixes: 33170d18fd2c ("netfilter: nf_tables: fix memory leak during stateful obj update")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This presumably goes through the netfilter tree.

 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 49060f281342..d0d2339e7c89 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6558,8 +6558,10 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
-	if (!trans)
+	if (!trans) {
+		err = -ENOMEM;
 		goto err_trans;
+	}
 
 	newobj = nft_obj_init(ctx, type, attr);
 	if (IS_ERR(newobj)) {
-- 
2.20.1

