Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5478D5450C7
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344485AbiFIP1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245649AbiFIP1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:27:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE8B4B86A;
        Thu,  9 Jun 2022 08:27:29 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259CdGW4016731;
        Thu, 9 Jun 2022 15:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Jd30BrzIVfAEDV2es0Zz3Gn/24JXJbqxo/+kSiOvaZ0=;
 b=tmXK6ltKxBZa0P2eVLcY5AIvhnA95oTJgC2ErT4KqMrS5aZquyqELGlzHDIZtg4IFgN6
 QuUJ2tRFnjeEXzZr0e+tlP8fzp2AtcnslrFVSkw+ZjeCZmoWK4/oUf4fcq9A7263tDm0
 DtudoUeGhSfxboDDPydnZkuKhjOtCOuEFNXepE7UKtAjnZpgc9XQKqa4qLReZsg/zxcj
 SWPKtxzedMIxQGLz03nYOVoy57fUrchg+bsxTzGfgkbZkp9yj0FDkXjVnq0ezNsIzgvQ
 mwAaYoPVv1If7qvUNdwbgKbGFgEprh40RL8w/TY+pkYcbn/AZoc34ypaNxRnRCdKTFXa Gg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghexeh2r8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jun 2022 15:27:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 259F6fPl020317;
        Thu, 9 Jun 2022 15:27:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu4sm4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jun 2022 15:27:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCx+G+g2tTvQ/1J+7s+YzWgoO92C+xhKp+ZaJ22ibF/BVrkiJD2rDy5JaJo3EVhuQRQdefbxq6m87+uDDEDvIEX+FzKzki0+PuhbD1fM3jAj7yaXUpctcgpFqKeso0s9aE0tEygj7o89SH2vKMQ+tERp1ZJgJ5APW6OX7yMwUBD8iwKEepDtt3NOkB5hTvSITKEiHDy0hR+ozlfLuJSOR61EdnDEb2PECWl+kSCwMP7HjW6aD6dmpsShKFsl6n2TusRZCoyA9/6AKaL5jLXw9gxPfLoVVLYvdp9JiVpyHDL0eFkq9rXfzSOHW8271ONfuP5COqU5wZ2tXLL9gEg9BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd30BrzIVfAEDV2es0Zz3Gn/24JXJbqxo/+kSiOvaZ0=;
 b=ihy36CJIWWIVYjFJXXHJRkGl51s+ujwosaR7ZnINN3x2XJ4aLjjR9FEn3u2qTk1ldBbIFk5gzfl0c5MV/414DTUX6C/AnhJOx6CGTSoxk8Ht4Xj6hOxbKNWkreu5agcfa0qyEQYHsEPnfLeYIvLEIDVAvnvbOG9fV7vnS8hbrfT9t3OZb+LAEQh7nzZZDkiLI6hT8sf1Ivgufi9xNNeIdITFij7sEmFbcHcSF2T6qgYMVeOO8dCTU5LnCbPc4HvnurAdsmQmIsDs5XY8rD4pzZRZIkqoWB66URNPOrwaVcoLe01NENXpspybu1IxlIojWm2nvvGuF+gFHg3sTgMO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jd30BrzIVfAEDV2es0Zz3Gn/24JXJbqxo/+kSiOvaZ0=;
 b=P32B/9pDRfaBdtXQdjYI+hVIWUYZyy81F1XyjY484TPmbDPzNV31INOTa3HSm3A1vsnC3rKAfq/HBzm/gUaFXwJ02JvOErD23zWSK2ykkSy2KYMpNQqNANrzNKKsFKI76UGqXsWfv7ZnEtUMh7ms9XLMAvDELRLZKdX3qaIvLgY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CY4PR10MB1974.namprd10.prod.outlook.com
 (2603:10b6:903:128::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Thu, 9 Jun
 2022 15:27:16 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 15:27:16 +0000
Date:   Thu, 9 Jun 2022 18:26:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Srivathsan Sivakumar <sri.skumar05@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: qlge_main.c: convert do-while loops to
 for loops
Message-ID: <20220609152653.GZ2146@kadam>
References: <YqIOp+cPXNxLAnui@Sassy>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqIOp+cPXNxLAnui@Sassy>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0065.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::7)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 107be47c-e042-4f77-0a4c-08da4a2c8858
X-MS-TrafficTypeDiagnostic: CY4PR10MB1974:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1974D9157E2795B9D7822DBB8EA79@CY4PR10MB1974.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvDTnXTtOdjJlJ8V8zvtGOPjMhueR9Sz3HoLAnrtdNUF/rU/51ctUH+nlUCV0+q1ikm+lKkCoMKCB5pHQWwgN4rxrVRPfs3JlgMgdeXUSkvKewjV80TTk+kQ4hbn7MMhYo4zZKWXdAowpFy1wG7LyXbOQkklrzHYK+dmcB9lB1ZDxPDxvih7hSuVg9BW2VUH0hcVMomgaIJbEYtvI/FGQreS+GseX2qH9tuAuKZbHty4cma6hjrsT9C+sOsbQpH7M3tQtOUSCoe1UqOYX5m6oeUlYNi1Imn9llq3iWD/txmUj48OLjvRACrU6okzzkbAsjrSiEcAyfXIINlIeKIXaicsxYNeNxAFxGMF0d1XiaG02WSz2BTGUGTfjBDomvd7Zx/OTVO/fh8MVN0X/Jp+lFMCIl3SM1x1eSL3WoOituXAUKDIhyKP/qy0r5ChS64Lco8j2DKKF/VAyVp+EKHOWE5UdAqpvRbKx1GewEZ5Pe0IYDpYNv7rR6P/6WiZtCizSv2mSxmUknqUsbuiV1zv+EuKz5hOcA5mURfMtQSStDgxwbYnib1jtiVeRVBIEUxmo/IehAVhCFGV6J4eN0Wpm7CFDj+yobsG4towPFAKU19XF8t1FhsZE+jMRKiqWqMVYvZMbRBjyR7Q9UaHy0+6W3zxgUHmu7SMdKB+XXOFIddBvXCYM6KMxmPI3Xekg4O2tNs3kBbvToCT1DK+H3QOXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(38100700002)(5660300002)(6916009)(54906003)(66476007)(66946007)(66556008)(8676002)(44832011)(4326008)(8936002)(508600001)(316002)(1076003)(186003)(6666004)(6486002)(38350700002)(33656002)(6506007)(86362001)(52116002)(26005)(2906002)(33716001)(6512007)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fBPuflyvVGonM93BOXPnHD2/Zh6X/eDbNoQyj/0CGfWIN2V6hgPRbVx0oz+8?=
 =?us-ascii?Q?mWUP7j3gp0aAYrtqWgNNcvMAlKNnCJxiOW3afHqjZ76d/htnaMvsfp4Kp5V1?=
 =?us-ascii?Q?G3wxhCGaizJzQDJ+Oz123KRPE2nA3jVyth3jdxoymn+Ik+RdV8zvLYH7ThDG?=
 =?us-ascii?Q?7c+yAbaJID29e/M0BWkyom+1+u9AuHyYoXdB1EfqKjkUaS6ULjXQrT2r9Jeq?=
 =?us-ascii?Q?XGbtVLftlgD16XF8EYmH2ELAhZfhcBmvbmNau1c6iMb1MfYWFui9POx9XRvX?=
 =?us-ascii?Q?/AhquxlL6n22EddNhZP/lGbxU+3cXdpuoyjhiUbHgI9Vn4fO3vKpPekoD0Ad?=
 =?us-ascii?Q?HbyQeXdULhOB8V7Qb0FJvzSfEHoCfXI0jX/tzoDi08VDVxDOJR2pvw8W2d7x?=
 =?us-ascii?Q?yarttkADtzBmQ4axHUzPLJ3PhCAoI++D9SlArFSP/yLm1RnOb9dGKdPWsUWh?=
 =?us-ascii?Q?CydiEjd8YqC1UbLoi5PyREsPY9kMjKziVKOGyzYuJNo/qTH5UGOIJWzYcBPY?=
 =?us-ascii?Q?DsMl/WUUbtD77vT95fjLKm92kN+F3a5uM59nk15spOa1/mC9mCuJZ3TUM2gB?=
 =?us-ascii?Q?8k2wBekzACN1peVNaz7yH6pVIEMMLhemdW3VijoNu6wAIP7fLSsfArrro3hK?=
 =?us-ascii?Q?pqle3gOlyq6OJ2Z6X1lzYwSsv4li98jYxJly/UB+1e0v7t0TDNgMH/YiXfB7?=
 =?us-ascii?Q?ZpGZ8Fiww8t3GUdH3kpTl/7Wxb+uAK4axQqaRArHlqjLTZhQCv8PZ9jHzgR3?=
 =?us-ascii?Q?VygK5HtGIdmCOOCyC86rSJdR7VWjKvAa+xUpuyfB/E9A8Iqr51i8Cf78uN6g?=
 =?us-ascii?Q?kFgOF389Mtpw80Je/eEWk5cV0n71oYVL3tDk5d8R9DLJVQX5/ROCgWykiYGR?=
 =?us-ascii?Q?zAKFFcgBTwc86uNqoed7O/GcnHsSV0m3osCoNHgGekby2dLyXgAA41ApekPu?=
 =?us-ascii?Q?dbbuq0PqZdHRFubca2rrBhQVXcdtJtdZ1k/JiXasv0ZSHHcPP97Q9med4CGr?=
 =?us-ascii?Q?6bRWoSNA3ljONUh8PZkYeejJHv3blFkzq4X8JFZpj2bKu8EB3aIFy3Hapzdf?=
 =?us-ascii?Q?Q1C2vL+OhJv3v/5YkjiD8TmAwTxzqqXqu4uu7yHNdlxhgjB4teSCwo3nl/Ps?=
 =?us-ascii?Q?rq2duKHuBUtdZb6XoGIae5ccjn+Vq3obTu13X1nBEwP+sFSKzkG2QrnTx5Qs?=
 =?us-ascii?Q?zaQx6mCsRdFsHHf8Y+Sb1Q67NiMogu7ivqCLQJiLQIXhwrlfjrRCj93QmNsz?=
 =?us-ascii?Q?JbhLW9Zd9kclk5kKjNrikz2Ui0kkWLoXcqwPw89G9PAZUNxkbk1vccG86rDX?=
 =?us-ascii?Q?6lQkde+rMrhVEzG4AmbYnWQczcLFtMoQazyjacdLkQOihuyJiqG5SDXuIfFA?=
 =?us-ascii?Q?U73IeJi5M6GwzOUgvPZ2FdD8pVU6IBFtHLefXwTyKjlJtZt+4qUvC8uobawD?=
 =?us-ascii?Q?S/EN65+o0j+921k7k4gFRjjWZvDEjWyeaIEA+VYLWg7e3BlKEyZm8k0Ga/Mw?=
 =?us-ascii?Q?5azPQT4+0iDg6XhhyY08R61mFEO1NHcunmrFoYkFOgBpxDb2fPhBeAlOxj9Z?=
 =?us-ascii?Q?J1bmS6HjgT15wG1nP4G1zN/KkzBMwYT2qii22VDXn5CHikQwpm1KnznR1fLH?=
 =?us-ascii?Q?vaM7tX5d38HGXHirQ2RdFBo+rivDMYCV+cgg2Uena7+1zX/UBGRyllwsfmbA?=
 =?us-ascii?Q?9i3DEIb44cPzm2sN6FtqG/30CxNJeyRwO18D59Pn1UoPMEGolu7XvTZBYawk?=
 =?us-ascii?Q?rgvRAvEcLwEmxdNQss2pDRlYo+MMIpI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107be47c-e042-4f77-0a4c-08da4a2c8858
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2022 15:27:16.0333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+JKGZ0IhkMQpxTe+Wjqjt7NfxmwbE5KsXF4lgOsf/eRa+ThX1KQYmefbZlXebOIdkUUkJppTFetq8uZFlSq9mftFSR1SrV+B6VOKjNLn4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1974
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-09_11:2022-06-09,2022-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=956 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206090060
X-Proofpoint-GUID: ji9CPhnqz3ES1U2AOivEXSteVOJq5TGf
X-Proofpoint-ORIG-GUID: ji9CPhnqz3ES1U2AOivEXSteVOJq5TGf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 11:15:51AM -0400, Srivathsan Sivakumar wrote:
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 8c35d4c4b851..308e8b621185 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3006,13 +3006,13 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
>  		tmp = (u64)rx_ring->lbq.base_dma;
>  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> -		page_entries = 0;
> -		do {
> -			*base_indirect_ptr = cpu_to_le64(tmp);
> -			tmp += DB_PAGE_SIZE;
> -			base_indirect_ptr++;
> -			page_entries++;
> -		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
> +
> +		for (page_entries = 0; page_entries <
> +			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++) {
> +				*base_indirect_ptr = cpu_to_le64(tmp);
> +				tmp += DB_PAGE_SIZE;
> +				base_indirect_ptr++;
> +		}

It's better than the original, but wouldn't it be better yet to write
something like this (untested):

		for (i = 0; i <	MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));

Same with the other as well, obviously.

regards,
dan carpenter

