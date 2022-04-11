Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D8D4FC05E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 17:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347828AbiDKPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 11:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243902AbiDKPYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 11:24:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA542314E;
        Mon, 11 Apr 2022 08:22:04 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BDIqj0018439;
        Mon, 11 Apr 2022 15:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=ZZ3T19M8VZ+/w3+aNbLKHhxC/LwnuaazWRJbWNBiMyE=;
 b=YePEd4fhWwe58SsnSZSSaUtTZBH1u/NYTi9MZ0rXQrfjDQvp+PzqZjI2MgCQ0+FjsoH9
 Z3Osvv8oAWGo2hMDT/OguJFWdKZhhcPwIdgKK+XkyNqwCco87nA6JhLI5fSUQyR8zpXP
 L6w/jjmL1a3XR4qNyaBlR8nOmOTKtTzVxfFPhuIWpEIOBGYA/GuY8p4IN52Cx7c59F8M
 oZDgGE2+vidZv2pxp8GCvFha5KTLBftsScoQnXtOmbRztgmHC5tuomi7rbQoPGTtl1Pw
 X6R8eD0UnRCJ7oF6Gwr3IJY8gXmm9Km3DUceSYhhV4Mphmznxps/lLDzpB3FXxdvnMfr Kg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1c248-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 15:21:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23BFGNC3030733;
        Mon, 11 Apr 2022 15:21:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck11qf07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 15:21:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPqqvJtx5D+z3VWFBaGBW2xbEeTD60D5DaC4rExZrmfDbsDB+78X8WAwkpFmaje0YQ+STBDdx7yuvh5SmBTVjEvEV6eVeau4+9jed12fw0tofta7i2vehFWphxWOKET6I8iE/drkIcqU0xkMbPnvTu5TilEassHzSXqSAN0nJu7CZdlvoiozIkeUl/MYu6ISIWL3Ef+uG/m6X2we8HPhpnDImkrS9iwdOg07PikP2bepZFLROa4+Y1Glf+w8ol7fyWrJszFMCGcSv9bcl4uGbZC9HGXgHTeXLHEJKB2WZ+pIEObDQFjQ1H906HUIBxVI/yd3WkwJT0/3Ivx9foOrPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZZ3T19M8VZ+/w3+aNbLKHhxC/LwnuaazWRJbWNBiMyE=;
 b=BTSJJSBg1kwsPo6NB9NKI6CUn8ibf5Gq8G5MtIp4jelK7QibDUngHT+8hnvvco9JF0QdRtUBfq4baah0dcb3hPMxibYR7V1bW61r8ahDwuK4ZSWhYysdiFB2v0zwzW4oKAbWqexe7Cl35Pgxdorvh03JL4bMj5xruOi+zocn+qF5f2K7365/ZM0h2cxq+tAuCn/Opgn3bdyOsMPU+gryZcbfyZV5fyUuqATyXEmpxw6RzM2+0LmCegtKV1l7tPsPZ+d/dgs7twTwc+t0mxaFTptusr7Bb7M12T15aafoY0IjZy8V6d1BA/tNJfloJV/tfJQJOA5gxRlr1raKUH5Zyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZZ3T19M8VZ+/w3+aNbLKHhxC/LwnuaazWRJbWNBiMyE=;
 b=pKZ0W0NYri6mReq3ZRVCsVS0EfyKwxyYwAJ8urZqQHhmCxNhMOddX6X8mZbRxOIPSy7WwDyZcqn/s9/b9ValdnrP74LkNrKJ/VZdqcG94UurJau/DjI4uBJg8+3akv1WD8/J1y2x9+1HSxgwiSizojfuI7kD/cZraKkU7DQH0JQ=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CH2PR10MB3942.namprd10.prod.outlook.com (2603:10b6:610:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 15:21:43 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%4]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 15:21:43 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     iii@linux.ibm.com, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/1] libbpf: usdt aarch64 support
Date:   Mon, 11 Apr 2022 16:21:35 +0100
Message-Id: <1649690496-1902-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0189.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b337ebf4-0b51-46e4-2d84-08da1bcefc3a
X-MS-TrafficTypeDiagnostic: CH2PR10MB3942:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB3942D10EB3CBA087CD59C118EFEA9@CH2PR10MB3942.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XPcAU81crmrqXeFskqkXsCbpjh7GDUDu3L/907am17T+r570U2hESh5u6GaBQXGrX86jR/PnZxbN8rfGjxSlzCU5ODp4awzzOe2RNoK8VLSouDeq7fizW4TpGprM8KLRq+73g71iBLqjKnQULpjEkzb19XZZvCfOJOHmiORIUxINZrqP+ns3Fg7vO+vbdeAdqReFjKNWBHeWMT/cnkEN6KIv/IN1EIJldEJ5yj3z00rbkzcCyIfOL2wdo06XMzOlsa1pdf2/OV4ZulMDhlQgD03/7UboBvxkI6ki3ji1/Up1JfQvT0xtzDtfO3A042ARRQiEOCRcD408DbfevoM1srIA0NIjRNfjssW24pvONSNqMLbDzMhIt605gm8lMVB0xtwmfelFJCj4oM/QAV60LeldcUOn1zBDvydw8PNCjzro2tkUB6XFeSWQp1g7V6flOV1GLlpUz9Pk9wPo80XlRuxJt6bzZ7vPLuTwe/cvdN1pM+QM6zviimKw5SERQQ3Kh1E6GjaCBrsQejUdy0prAQFyA7KzXosWmYKQbOCA87o+AJe/mHoF7t8AGSpbKKVUaR2RM4GeeiVDmv0KEPJ6grXbgBntcL/XfdkgXf63uy4/0F/J+7Xl65gaf+Yr/4+eOnljv8C5aC53breUYhQUPyQvqay1IM0WSc+4T833CcGOmRuQzywsUy/UAyiMVIXthIHDNe4UfRiKoXvcs9gmuVjULG9epajHrbfqfqApRORZ/H2vysRyDYbgFdUA6sTVsR1ib1Rgmm1mRt8qO1UwOM/K7R+SR4Nfr9oT2+0TcYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(316002)(6666004)(6486002)(966005)(36756003)(38350700002)(38100700002)(6506007)(107886003)(2616005)(52116002)(6512007)(44832011)(2906002)(5660300002)(7416002)(4744005)(8676002)(66556008)(186003)(66476007)(66946007)(8936002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mYdIWv6Q54+cpsvz9/cbvbbqCFoRGlr7uJTwTwVHomttDO2Ym98+AOUI8lo7?=
 =?us-ascii?Q?jzgL4h4egNU3vwV4hvOK/j1nDYlFq00iYlQugshI3ijkR7EMMGvzGHkJ/hll?=
 =?us-ascii?Q?frkTYmwraYy+lrMx8/GGZsTLba0GqeIsyjuHZNYNFB1A1U3Vx4oLILYGWRHE?=
 =?us-ascii?Q?YalH53S353bYXM490QZEM/irImbdXHUIBd053/wkEBnTA/w6HtqbRlrhwC/W?=
 =?us-ascii?Q?dUCGlnfy23jivMsKDscyusYPvI2JyMmptvYkvoTCc9uY7VVXwQD1y3zV8ZOw?=
 =?us-ascii?Q?fvlvRnwXH69qefOcjYNOoYHKbVd10LzYxJMKQwXJn2qh2hDZ2xuJ00zFk0KL?=
 =?us-ascii?Q?WEULXyHawgUPoKbHrupGNqDYGbs80B7wnFhuAztABTOORt2iOwGso/Nd7xpX?=
 =?us-ascii?Q?ET38CpiDG8lu2gi+nEVD53MMjPFtb+fbzB5ALgHV0E/uheIwdYoon+7pRgch?=
 =?us-ascii?Q?oGE5Ezu3oElz2L8wSM1pSJGYjS5VxUPIaUvzfXz1Vt9TOJedCmuA9p+SkmsQ?=
 =?us-ascii?Q?uiiUY7DNO4x0yfksIbkilQt8ARDRl1YrTu6IQFV8rOPU4DH1lCLXOOmJhua6?=
 =?us-ascii?Q?IUpuaM2c0NL6Lh55nBwnENl4/HDx8UoGare/aGKih4Ie71Nuf/7VEKiJVann?=
 =?us-ascii?Q?cFuYiSlzvWf5YRHfCNVH3steqFcpjGDFnqgWccttSmMeIB1qTjwVFkPyoKD8?=
 =?us-ascii?Q?Dn+Xt5QPCHQNUzKPyz3bZD6OvQeqBfeNnJgtHQCfJMKtKNg8yRLjJLnq/Ybf?=
 =?us-ascii?Q?Lvbfv5UoyKtd+Ox+nGNJoCLdXx07W/Qusg2+ztVncmVCxhKRGZMIp1cnk9o7?=
 =?us-ascii?Q?Eu2U4iE7awwD0gCSBIvxOpl99boRcDu7RIxTv4X4rfjOLRkGaraPEA77ta5B?=
 =?us-ascii?Q?LelqsJCPwYECu3UFE1DIY0CaEW45Ox5eOjRbkIZkXJZvvI9L6kBSIfv5FXxa?=
 =?us-ascii?Q?QGKEBddf28dg/9Caaq7zgz0YTwE7LgfnTxPztSmNzXqULN9QuvE9HK3+N/Us?=
 =?us-ascii?Q?5oCCA/PcymzeE8PHrIFoNPsMSzlYFBHr2WowDa1qYtKE6KQE6/bcwvU8hOYt?=
 =?us-ascii?Q?8RDBKQ6qecJVHz4ZQmVFDhmahSGNEgOM6Ul4Itpi4/qgShigxPmWQFDeJ4+9?=
 =?us-ascii?Q?7VAt8NTEmo3W+QYqn0uQ4I3k1LjpuurLEa8OEUiMz7d17CDrZcbB1JLU1tGz?=
 =?us-ascii?Q?rrmcZdfPKVHEd55+tcSqlxRDIhGIvYrItJ3YL/W6/kDb3hInCTB9ivJpVoj1?=
 =?us-ascii?Q?9mFcaug7ecE+hFYon1aj5aACJyS1m4mcB8KxOE1sT7xSSqeMxOenAc32rayG?=
 =?us-ascii?Q?g4Z1UKm7WwDR7AOmKswC+eMzT1jvwHU5nua4/KNPmnuvgGMlDdo00fJSGqYN?=
 =?us-ascii?Q?D9RnBOvL+NmV9loPum+B4/02QS9WCp0TP/OVTubHDfmad1X1yzFL5DlSkbjc?=
 =?us-ascii?Q?2kAnrDKrsjT2hZ9GUSmOWkb1dAuAc5B/610/hdtIr+lw21EKvh/dg15HhubO?=
 =?us-ascii?Q?k3XDpPAYcvckgayj0keT8FhN/gZ/tcm88lrGQk+dwvK7M1kniWIfYrpuVdNw?=
 =?us-ascii?Q?cs8mSaJwNubjVId3fUeIjg8tGpuorY3RiPD3wXtKBcBm7N8VLxnCQuYAArav?=
 =?us-ascii?Q?EiKmVBE4+DMUry6B5co/ihH/mUnjMuuMY11dkR4LG5logBoHazq3Sg9azwnq?=
 =?us-ascii?Q?D1aGSkCwrmCv54BmjypGcbGt4FFI/+DW4fKgozdEU+G29ia/FTj2m90laVYt?=
 =?us-ascii?Q?cgGQYPlrX8aQylM3dLfqTR3MhSVFe8o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b337ebf4-0b51-46e4-2d84-08da1bcefc3a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 15:21:43.7417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhgjOsn0kq3ELOUf5SKDLWnA5FVMHzz4ZEq4O18oWfxbVoKpx3pHM3hpjpyy+BeIRISe588uuLzVSI6xrdrEbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3942
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-11_06:2022-04-11,2022-04-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=559
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204110085
X-Proofpoint-GUID: MUKLecx_HfVB0WNgO4NuWSza9K9hPFKT
X-Proofpoint-ORIG-GUID: MUKLecx_HfVB0WNgO4NuWSza9K9hPFKT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USDT support [1] requires architecture-specific handling for translating
from argument strings describing each probe argument to appropriate values
that can be made available to the BPF program.  Determining value size,
whether it refers to a dereference (and if there is an offset from the
register value), a register value or a constant all have to be parsed
slightly differently for different architectures.  Details of format
handling for the aarch64 case are in patch 1.

Changes since v1:

- dropped patch refactoring all arch-specific parsing (Andrii)
- reworked sscanf()s to separate the two register dereference cases,
  made register parsing match [a-z0-9] in all cases (Andrii)

[1] https://lore.kernel.org/bpf/20220404234202.331384-1-andrii@kernel.org/

Alan Maguire (1):
  libbpf: usdt aarch64 arg parsing support

 tools/lib/bpf/usdt.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

-- 
1.8.3.1

