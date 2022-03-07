Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C0F4D00D8
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 15:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbiCGOOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 09:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiCGOOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 09:14:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E1270920;
        Mon,  7 Mar 2022 06:13:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227Bgf7L008819;
        Mon, 7 Mar 2022 14:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=x9flMIYPGvWnxgRN+P3LAjmMkzhhsyi/JwnzVTQ85TY=;
 b=ZtA1LxlKg/H9yJiyaEmp4YiIiJ/zcu/Q9tbYe4xgFqZ1I5Yt9XKeKlZ2kae/zG+SmEfq
 fp6zysnhJHLp/DWqYyhoDCIT65hxyNG6Dq5LCMhzoBJYZQCTjsAXaMCiVhA/dLuJOwFy
 p0ZQyNIqTSPWPqV+p3uqv4CC3SSyeX3Kdl9tmQrIpG0wv1cE0fKQ64r0xpO5/1fWpN2M
 S5pbQoe2x41BsDP1It1UYCe1H3dlaZmqppmolYSWtzk+90hc8vmtkn8j46TFCDZZ0oFS
 AdOJcLtXt2rY9ZIyybVSlL3sj/0aGjRogslT5lfGed7UZE+A0NFi222KpVRrEmeSlHHm Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0kymg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 14:13:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 227EB5Cv017627;
        Mon, 7 Mar 2022 14:13:35 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2174.outbound.protection.outlook.com [104.47.73.174])
        by aserp3020.oracle.com with ESMTP id 3ekyp16x61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Mar 2022 14:13:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2ckesF/fw0nHD58ZCtjmvSmYtKWJQKcF7uj47+WOcDdSxviPVkYgdvKnvqprUwVv2QOQ0gjOfEDa4scaYKCaCZBtxdqLq0l8MslJnYUW4c1wfgsNWyFjU/Yksly6KXycJAavDXSPWp3K4n5ASJKqnbiJ37v8cfeYUUiO6Izwm82OYQ1Jabl9Jyg4aHHUQNVYbBfbEtqklWv1RpLuFg6tkZG+d7ifkQPb3k5dILmVFFOyCeXf76kzDUIqFmMfmlnefylmvXccwoWz4D1kLhAPW2ok02R7QUN6yVgK3ODVBMRhkRvuIVinW4CVgCa3wKIweCqzVYAcU08IuUkNWECig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9flMIYPGvWnxgRN+P3LAjmMkzhhsyi/JwnzVTQ85TY=;
 b=IGy6NOLpPCv61PjOT8NgVJ/mDlP6q0fF3GxpGDzrpFyoxTFsAOqm2+j4RtT92dPXug6K0ie3thFZdrHTI6O4LSBMlGdvd7rBR+u7DIsZq0TmCxE/rOKV0JtuYo/x0akzH2tsZn0N9E2kw0TbB92Fh1PM0GrCVxzI8umS/X5Ap6Q+vc2C5JNvt100zgl4wa/KM/1HiOpinnO9k66uLGfvD4VH+VudeqB5EwZuET9SzVkknUQxt4JaUGJPP2795KI01p2J0vJdT0SILFFOanKjC1CbNUykAjOaARmnU8CFskzNSiaDYin2/6PW26pxDFJI9heHdqk5753akkVRHHMv2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x9flMIYPGvWnxgRN+P3LAjmMkzhhsyi/JwnzVTQ85TY=;
 b=ODsFxdVCOJDw1PBeEJ8wRq0hWJfFolaDjTfGUYZPc5Ol+yYS+zBlBts82NXhmi9ba6widAeeJCo5dss5tq+NZ2p/x9BjVi3SAqF9V0dnmjoLL2MmM+UQcsEbscXX09THHkC6Y3epBwGgJfMM8e+ThNFocR/SYtujmdz9PDdUSvs=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB4242.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 14:13:33 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 14:13:32 +0000
Date:   Mon, 7 Mar 2022 17:13:18 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] ptp: ocp: off by in in ptp_ocp_tod_gnss_name()
Message-ID: <20220307141318.GA18867@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 06b57d80-7aa5-4478-1d1f-08da0044a960
X-MS-TrafficTypeDiagnostic: BY5PR10MB4242:EE_
X-Microsoft-Antispam-PRVS: <BY5PR10MB424202F0B2C09ECEE9FDBDC28E089@BY5PR10MB4242.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6T8jCHluEgRTbKeUW70z0zxm7wHXKtS8OYmZuZND3z7WqKwGeSy7ISGVPUsk5YRsemvNHtYMxTVcL5sEcRB4SLT/SuaTeoY18Gzm9GtQg+R87g0EycNHFY8DhLWfhJaT2uFve+fyuwK6aQPwXI6l7ookEm4ao/iwikWDTQc4c4NIUAVa0lRF3namkWnMXkGwd1H18nQROoJiZs7FbgcItsDaadOLX1a/Km7PfZkmiRMTr2C/yTsKtsIzflBJQSnbpH6Tv8FtMxrslggXbl1CAo503pMJfXQ8Ov8Z1qyykKlxaZtbTKNCHbVmWTURmDHDstpzOiwC+tkM3zZCb1Hhq0tiWRTzuZ3sawqk5Mg6Jz+eNPKM3mlGIdQzzXXNFp57LrNfUq5YXbDXSr2YSKiEzrENqzSYxYAKepfllNPKYZKyjdhtV562lGZMN9lgczyqVlkAaoCc49ULDgXRv18ms3qPFlbAzB2+4eENr5toz8kiQmkGSICWgM1C64M+9/Gu39kFoIFeEClwd+JM0X71qJO4Jdaieg0a5fnk0u0T5oJEzzvYBWNqABzPCrtlzYUm/82AiTz2fBZ8Yt9r2bbqkVS8sb/+8t0B6OBm0IFl8Qz8j9Hl8EGd1/2nusMZym1To5hf+BDE8T6BYhxBv1oPhEt4J1hy3Buq33cXCUBp9aldePUuoEV9j+mfl7FYhUsiCrL1CcTY7I5MxnCAYEvNPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(52116002)(6506007)(38350700002)(33716001)(38100700002)(83380400001)(2906002)(33656002)(5660300002)(66556008)(316002)(54906003)(26005)(66946007)(6512007)(9686003)(8936002)(44832011)(4744005)(6486002)(86362001)(186003)(1076003)(6666004)(4326008)(110136005)(8676002)(66476007)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HI6mv/lYItnjmYcJUYRPEKYA7waN0Iv/BHtFLwiIU+/W7vXKhVZJ5tTbBaQO?=
 =?us-ascii?Q?x8Da31yw7vMNsHsXJnqAnH8gD1ntFwwGAznTfeU9wxaRNX1uA0VW5pBnxVxB?=
 =?us-ascii?Q?6qryvYZUL7eGqzEOoK/+TriaNV8KMYVDw/1JF9o905AyzYffQhQgRa7Gsq6u?=
 =?us-ascii?Q?nMndIIgd186qK6HM91Yoi0OA5VwCved6JZ39HjExhgMeT41824gPDNx5YbHl?=
 =?us-ascii?Q?6pP33mmHNjPcp/gZeEZ5rHRh0oG6I38L2MuIYWkKjAwrLj2e/bItvF2SPNzV?=
 =?us-ascii?Q?ezEu2xCrWcRg7RhrsO7AN+iU22ZYHYI2e/p4sSKRDHw1AgDkniwAYhOsvc8C?=
 =?us-ascii?Q?L6UVo48P+f0jySqJcgLSgJt98+C/ApXJXrkYMsUS6Rx/QcaSkqZe2MRqCY6X?=
 =?us-ascii?Q?B1RoRxbQNlP1MO00Bbktvy6cLNv8DhUn291kTnni9/w5plMAf3emn/htyCc+?=
 =?us-ascii?Q?SKPCyO/7rVahz+H1Bdm/6ViHjsiPbNUPzIaItdNDXzxMuVRgW+H34J6Y4y0X?=
 =?us-ascii?Q?GwOV0K8UC7G6PscovoZk+PMaAcp66orxaJ4Hde0qHw4XQqlzhO9mVDbXcnbQ?=
 =?us-ascii?Q?pgIpUXkhRZ2/G2adUFkTTdVmrUcMQnLSU+TehOseFlD4geBe0J9VvFih/YOr?=
 =?us-ascii?Q?98N7ZxSrVaevdPImari9j2FAs6oahd5W+uXogSsInMtNUAq3pTvt/QGa7Q1v?=
 =?us-ascii?Q?F55/7YCGggjBd86GeszDcwm1A7B9gY124g/v08dATwVuH9MF4hv/h2dyO6H+?=
 =?us-ascii?Q?Nz/17wT0qje/OTJQzodiH5s60eDVZkbxLrJT9LgzWOhO1JGIM9r10KfR5QWQ?=
 =?us-ascii?Q?LgTnJU7Bn6Hx/y69XVKoNPepUsaYjbCMxsHArBwxBdPeidqRN3B3JG+yPhIx?=
 =?us-ascii?Q?Pd67R2EJnEPcDD5prpE/94E72hkZ1DXO8RVGtFkbHJL7FUWwtUMSAHDS4cHL?=
 =?us-ascii?Q?YXLcspYv25H39kwiTr2ub7RqOtduL17BCNjLLHxKb/6cVO1EVD2xPAgAEyay?=
 =?us-ascii?Q?Nh7pyCIxCTqZ+oTKolbRDXwAL93MDce+uPc2OX2byF2do3WYqHGt4H/bxDiT?=
 =?us-ascii?Q?MjO2XpIhIabdvtkgqKpJ5D1SooJcu3fjhrdlBMStanYtdolTeJVjBaEmBBEU?=
 =?us-ascii?Q?BNr1cpPpcemhx2XUZFxmYQ6hvhZnmEgP21L3FBvbuoiA7PJtCwypusnz44Pw?=
 =?us-ascii?Q?Gl0nxtNZupOLLjOTxQruPgPo1QADbTHV9ZQ6iZcqgXoB+4omYmVZzqScq6Pk?=
 =?us-ascii?Q?bbzMmLwgwgKxhEJKx4pfc/L7l6aUp7JGoph+SKPhXPFFWK5Eu5GSIWqhEElQ?=
 =?us-ascii?Q?xs8SLfQNGfruhRf9BOTnPedB2vbOCv2WRL7+qYbKgJpOG604ayN0qhNYVitR?=
 =?us-ascii?Q?dEvTH28xFXwbR2pbAgRW+wuzD4+7wUZNa2lWnACZPJN6/HWZ+yGiC+lsUmum?=
 =?us-ascii?Q?xS19G42Rgowz6mdKZ7gtMfzafZXbdLCtFYa+KMwXmTAYbnPOQgZ2pauqRjIU?=
 =?us-ascii?Q?Q6n6PGO5vNIjNGenD4ZL1AyvjbnbDPk4ct+wCa0vXzzTuGoJiNq4gUyAlrj7?=
 =?us-ascii?Q?zJCKfjj51nGJz12yC40K5PClLTYVxqOLo4NPW5uLPpc3dv9iFhAyInRWLlWa?=
 =?us-ascii?Q?L53RolI8BegLtxS2wGGt2TXd+1l8OdIHCkYE2oUzoAadsEORXScPiXW9fl6w?=
 =?us-ascii?Q?u4chDw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b57d80-7aa5-4478-1d1f-08da0044a960
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 14:13:32.8114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/m0HiYNhC/0TFHp/k9ghqiaO7SBhIKxFs5h8TdnWexEoyYYowbhr9/vyE2PNigmFWYpkbVRHmqs2FOEkcBY9N6uoM/3WN9rsAi+TpB7IhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4242
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10278 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203070083
X-Proofpoint-ORIG-GUID: dXjUWZ3lm2ireJPSrjRl0CfkqFN4UOKm
X-Proofpoint-GUID: dXjUWZ3lm2ireJPSrjRl0CfkqFN4UOKm
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The > ARRAY_SIZE() needs to be >= ARRAY_SIZE() to prevent an out of
bounds access.

Fixes: 9f492c4cb235 ("ptp: ocp: add TOD debug information")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 608d1a0eb141..300de2ff5657 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -914,7 +914,7 @@ ptp_ocp_tod_gnss_name(int idx)
 		"ALL", "COMBINED", "GPS", "GLONASS", "GALILEO", "BEIDOU",
 		"Unknown"
 	};
-	if (idx > ARRAY_SIZE(gnss_name))
+	if (idx >= ARRAY_SIZE(gnss_name))
 		idx = ARRAY_SIZE(gnss_name) - 1;
 	return gnss_name[idx];
 }
-- 
2.20.1

