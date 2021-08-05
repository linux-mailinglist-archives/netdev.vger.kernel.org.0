Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392453E12C0
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240505AbhHEKi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:38:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60118 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240464AbhHEKi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 06:38:56 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175AWLUP007819;
        Thu, 5 Aug 2021 10:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=aCkmGjN/SUcd3uIChK0SdmtWxUb5IfG/b8THqHHCRXI=;
 b=xh02pj4xZRt/VV0LEh16ext3wynVMSZzllj1uhBVmNY/lbNF7LIsGz9cwqqo7WYPIZ9+
 ZH5jGR1ZX0nXV6nfB9o4pxywgxlTzTLHAX14b3zXa7ygsVBjr3NTA/riPAauxMivXbNJ
 aTMm+p+xq9s7azLarzmG7xQA0GED4nPP75dj0/FPlctk2FUdGtKE3LDyRBhV0nS9dbxY
 /6VOb/58KICDFLuvLe7d5Al1kAfwT9ODdMqlmX5ylZDlMk72HQoHlhMsvt1+Te9Srplu
 /FcXeJrCCzyiC+9r/rm78Z0uu1Hv6VsSdOKOdFLdX4hKDdEj0aItlZBLno//mlzmQSUy Lg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=aCkmGjN/SUcd3uIChK0SdmtWxUb5IfG/b8THqHHCRXI=;
 b=JZJjfgBnymOC1lpLBejMHxbtfSK1gsl5XBTr4CurWqTb215xGc6oLqAPUnY4zYFkd+E0
 AXEsdSENMblkk48lmeoo+k59UT/3xJDw+Cpk+JG366AJAh2vCCBiC6e/BP9HCN2jNkMU
 gTKBPz9IWrmnRrUiPkeL24XEmRchOd8lcBTnP6MiIAMQPo0X1yoi4WCnPhWwEdgNMLQ+
 Iv8GiW0cP6w7xpKv+Rd939KmycFLbPrRqLqEZZhEQZ1O3pLzgUFhSIgCseLGuP03wKPI
 eChpuaCUagxfdbU6MDtEqumjW5K6HPS2GKkuiLCGhLJSII3sOY1miXBIMbHLJ/BUhhlG rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a843p92h9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 10:38:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175AaUTI189263;
        Thu, 5 Aug 2021 10:38:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 3a78d8cu0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 10:38:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKPx3vjTVS408JXGYk0/nXRpHvK6BvLFCDg9s5qvdgEnlsJcmY1tzPQnr/KGs+HL8EGlq9yAAfACYxhQ6GQoWhoQfGkmO1qXImg0xHC7GjlIB1h4LQ1FBHnQ6AGJ0P6m+FUU/APbVQiRMfsDwNlEqBdhjFcQEd/ViHQoELCLBSkRsk2gXJdmFMhULWWj4+GpUFI4Hz70DcLn6v8JwUhFeEGACykrAjWpzl245FTNEMFBm8/Dq1byNnx3O1lS75Q2olF5Yzf6ZWVQjKmzwsWfxCgUK9WcMr91uj0eyXWhfMKdZygRhDRUQ1ur+X/fdLzRHTJ1OJeStyZoBLAV8v2aUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCkmGjN/SUcd3uIChK0SdmtWxUb5IfG/b8THqHHCRXI=;
 b=nZ70EQINCgLQ+fw6PMNC8kfehiMV6E/0HWYjwmgqeJezKEtaLShA4HROVLvOSKgXiKpOba4c838feTa5KXl/i30GEmkGo0LRD1AV6c9dbyUV25ynMEXSHFsFhx4gqrXyOBFWi6hiTsBAd74SxQf8XRFVCVgweNMnNWIUamMPwGQm7JNQwjnPvHBOyTIDRlkwxEmGeD72d1zP0/hxjlwFQ8eVHeD1cuFj5/NJdV2EwcWAx8CaQL8b90hPLfdz99rz30H+MhUyLlEs2i4Xs9pMp7Lv5+b2xdcm9tqTg6VkmlzxXsuc3vJ7dDCfvPkABKNroLFQuN4EzguenVYSfYYrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCkmGjN/SUcd3uIChK0SdmtWxUb5IfG/b8THqHHCRXI=;
 b=zb/Qb6gjE5y2nXcNMqhWg7IzIPOOCw6E9NajvQLJSgANrUxxsLYoVZ6ApiYmTAgJ9V4XbA6cv5nVeI5d1H3ntKk1hmNP/ByXgNpLMSQOYX7rjgbKy/UXdwOVC6l4MeueIe+JVeC68DhB40eaAT0qLPOx+Wkp0clEHdwLwXdPwe0=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2318.namprd10.prod.outlook.com
 (2603:10b6:301:2f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 10:38:38 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4373.027; Thu, 5 Aug 2021
 10:38:38 +0000
Date:   Thu, 5 Aug 2021 13:38:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] bnx2x: fix an error code in bnx2x_nic_load()
Message-ID: <20210805103826.GB26417@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::13) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kili (102.222.70.252) by ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Thu, 5 Aug 2021 10:38:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab2f3d0b-0d06-44ef-f8fe-08d957fd2f38
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB23184BDF68820A14055182FC8EF29@MWHPR1001MB2318.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jkZrwBJUEIdyXYVeqT5q+ZtmDUkRtGXPF+TnArgedgTgrbXx7d7ire/WVs80eRtk+Vb5T1z0kUIq6kYPP9cUqmCeJZYuFmajwQp9aFFMrxyYOgNn7rGY7J8v84OXf2QcV96GWsUJ0Kpj1ZD93THgfJrCOVj3NjqSmTeD6J2CzyPqazTIQEqZ6oSNaRFv51MFLkExlTp/LbMXe7SrH/PxERUmGrgG7ji2KffL/DQRNfXVLfHtBP0ddd9F6kh2HEQVGgLwjiTLCERRBtec0v+cnAHzdS4aQ3fw/h4LdPJVoH+EhxVcyY+QEk5Zjlc/KcHluHLgKbXfXqz1gSgCY91J/IUr+XHKks1pF/xZtAw507WxjWYp/T66zI7ljuT67Wb4ywAcqYBizwME5DaAQTkJRL8yCSVzueQdg7wS2mJTsxzTkHG8UF0lw9r5UA7mEe0K0YDWbvInxck6KtKJyBALIquvZuyp9UeAOBaKXtIEYpOUlIlMzya09i5RxcssDeUrW7YPphB/3ZX2BKG+SQSnTLB/BYbjtCFfl2cGwP68Mm0dWuDGSd5LU0gl7SuNEW1+YL7JXK8KzusuFzFvy/COvhoRS0NUJk/taeSWQ0m/J7bjPQ/6ppH9LzmJnCLkmVyNWFZwJA5hnVbkcR3vRn0/YaO0GYWTGcpyDi7Hjf595Srkz6mPwkDtVXSGa2HkAtP12rRJy8J7t4+qr5FHWWebag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(38100700002)(66946007)(33656002)(66476007)(956004)(9686003)(8936002)(55016002)(2906002)(66556008)(86362001)(44832011)(6666004)(38350700002)(54906003)(4326008)(52116002)(9576002)(6496006)(316002)(8676002)(83380400001)(33716001)(4744005)(478600001)(26005)(1076003)(5660300002)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ew6LrkdaLVGcO3M70oWMH8CWsHkuqP82z0SaYR//RjvOHqcj0c5CN2+NI7au?=
 =?us-ascii?Q?nuF28XebTKNCgofwvxXSFtcet6nnhgJNff4y4u90OrqY87yc5gIczaiTyGBf?=
 =?us-ascii?Q?vJUYEuERg9TVVrNcH7NmETdxkljpAtOW39JY01JpCJQvyQJ+/u/fLnWZ3zzi?=
 =?us-ascii?Q?POXeFHwiOF0HfFTJTp9AV72RYNlRbTBuCXCbNBqJZKoag533PUbt3ufNW2AX?=
 =?us-ascii?Q?Q14dArRIiUNagZxObeM6zEKGlkNj8L/5VvlVEYJ+LSBrj+JWTZ3/bjgsoCwT?=
 =?us-ascii?Q?HH64BNxIu9Gc1BPjyADnD7B8DgbVttj2SICx+HeHROwJlIlDB+IbzmBCAiP9?=
 =?us-ascii?Q?T4WCkxa57aE7Od5JH7OqOj4Mdw6mqCswsD7nOn+PqChHldB71b9wNHVKGEDj?=
 =?us-ascii?Q?2csyBd2z7V6NUMk/Is4aT/HB8oEKm4h5CA9EZGKHL50xLGBRADDW+g4c66M7?=
 =?us-ascii?Q?u4akw1ZzIk0k68ti0nbGBcJAwcWUWsa3s4/sBePItIgeOWN4BpwDmmjiKKUU?=
 =?us-ascii?Q?etmdjJTL5di/meSAhqw2kKTl/OUSamg772NIHty7YqhtSTgDxefrMrMWoiD5?=
 =?us-ascii?Q?FbSfCq1vHT+vrgI7vUsakAmbqifUGQxaI3NpbzJaEwyT2bJfABbxvFuWJN7U?=
 =?us-ascii?Q?h5sV85ssxYPWm0fWkVrVFpa7AbJedZreUhtAL9dV0dL3IuMYyGHuw/2oiWv5?=
 =?us-ascii?Q?s+0y9/pPnYNKHFWIsj11dFFocw1ovjyW50vigEl0sIk4EkgihYySQgnhJEVQ?=
 =?us-ascii?Q?bfIazqwAcwO+j+1RoCce5eBPzahbo50TyNYOtTztXTF1X5Be2i0JWQVDNJbI?=
 =?us-ascii?Q?9gdWU5rhyIUzOE9PRoyTH29RuY6z3tdCZLPKb8aRpk9TlEDr60AKqDomrH6S?=
 =?us-ascii?Q?XkQqeDLdBGP5K0jZvrwo8BQh0j54S2zRgmijAqt9goKzEo4bT0E4zELOd6EA?=
 =?us-ascii?Q?TwCCxbCffmx7OmmGjFoMc5j6rUoL4KCUBcT/8ol9VLRGJxz6wIuqgoAgTN5T?=
 =?us-ascii?Q?Phn12PA3ikfSvuIK1Pj93AFQwoGlspMAlsCpQkrAi5Smlp7xuRAgb8d45hPk?=
 =?us-ascii?Q?v2wUqO/UldFSdBm8k1D9LnXxbiawhAjo/xXzZfOF3kABx29qq/D457v5WzAg?=
 =?us-ascii?Q?jtP2vGFmR8N418hB+d65jxu2V4IXZnQBNoaT6e2/V4kM5ZBKZ2Csv1WRxPqU?=
 =?us-ascii?Q?sfZ2xEfGKdNBf+OtTGxFEDnOSAzwXJ/g1pdClkoDQalJSs4HYdtu0kdOVa0k?=
 =?us-ascii?Q?IacNMF5eX9SXX2RDxyapdzyM9ow4F5Z0/leUcePNmQ1irZ/wkH2OWDj4wpc7?=
 =?us-ascii?Q?tA7lStr6Y4qG50RWZzqG7yTw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab2f3d0b-0d06-44ef-f8fe-08d957fd2f38
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 10:38:38.2130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uujEERszzNnPxY/gs3EpNaz4Meqc5HX/vI7JbFzEH3i0ClwoAtDBGtED1FI+L/qkD3/BNjXSZZBL+V51qF2Ru00KhEygigpolB02D6ABVbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2318
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10066 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050063
X-Proofpoint-ORIG-GUID: hY0sQcgZxjl9yrLWKlRfM5zjM9_GLMok
X-Proofpoint-GUID: hY0sQcgZxjl9yrLWKlRfM5zjM9_GLMok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the error code if bnx2x_alloc_fw_stats_mem() fails.  The current
code returns success.

Fixes: ad5afc89365e ("bnx2x: Separate VF and PF logic")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1a6ec1a12d53..b5d954cb409a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2669,7 +2669,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	}
 
 	/* Allocated memory for FW statistics  */
-	if (bnx2x_alloc_fw_stats_mem(bp))
+	rc = bnx2x_alloc_fw_stats_mem(bp);
+	if (rc)
 		LOAD_ERROR_EXIT(bp, load_error0);
 
 	/* request pf to initialize status blocks */
-- 
2.20.1

