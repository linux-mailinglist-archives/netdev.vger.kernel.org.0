Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D967C3CBF73
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbhGPWvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:51:02 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8632 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231846AbhGPWuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:50:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16GMg7oi018444;
        Fri, 16 Jul 2021 22:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=ZaPpinlUCrZXa+z0sqakKCJLDC0jSDEorhttUQIgDao=;
 b=HV9yov2ko7WoTH++l6nWMa3i1GJjoLy37P/LKyIDpXZAHiPUSt0fIm8vnWQTvbJfHbYq
 UNJ/7GA8RFQ+6qOR9kJgzAcRpXOMvHTKvfMZjOCRCSt/9c78BUlp9Y0tMR+9pDDtU5UF
 B58+fwkj0GMm75bNaqzvwkPa/Y77PgYHim6NYGXsKxu2MKL1AAFZ/KHawX1afTH9vQHQ
 TQEkszPHJk7EbpOm3Fag13wqg8drE1/8HO+CZChuvQ+tNesaU48DYlx4R7T52bIwBVX3
 H43S5vhlGuXBzU3CtHRfKN5VlHK8F5GgofzJHBGlZEA5j592b48xnKqfDkiK0qj706br gw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=ZaPpinlUCrZXa+z0sqakKCJLDC0jSDEorhttUQIgDao=;
 b=RNKi8sDclrh9me6HhubTStor0OXdQbGSmO8rklDeMk6wEjlufAjzUW6/smm0ugLURSxc
 CvYzUPUwkskG7bxzz/n7ca44I4kGqzgctgfOG6UVSpiNUDHHZX6fpZu8SzGzfa/4QKVX
 UNJBfGWXi2mWtllv7UlGSWVRf8mx+ZdwJJeSCXG07z8TFUNZgpN0RAhVkUhmO1n++n8D
 DzVagGdhrZi8I5fB3I3V1LCTnNkKiqeoXShZCZYXkbbL6pYrU2HeDpqvGdwgwe3ikBOn
 QhcCYf46zlGfILXxng/r7eCWYj5dYthyh4wcNZU5dLAvx7x5tSnsXzynVcWnsWveW+oz cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39tw31aa8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16GMdtdD186272;
        Fri, 16 Jul 2021 22:47:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 39twqrx98t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6HV3uErT/VKcmi5PPtpJ2ptqweyF3dLhrGWA6FAd0+XrLPniIBppGoToNV2uyDCEYl/AbR++v/c5d32gyEIpWFGI2r8KKJ2/alUwu/34DEoZ/7jz4P+zVrdyeuJtrh2wJEur2MRTsNKgiPJOkQJcyP+UBekI+oHgllPfQ6sIZdgTq/GMWaxDxgamNEfLsT91Gy27LNcpnzE4ElID3FueYnowTjkmlNcSy973gtxg/kPfqNVmLOyMidLn+45sbRwthNU15ok920foLvbDBjB31SRgzP8Ohsxn3Z5MSrstFq1CopmXMfL96t8gdrgEYU48vdWOhj0QiuRGtpGSibsGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaPpinlUCrZXa+z0sqakKCJLDC0jSDEorhttUQIgDao=;
 b=OUj2g83ys1IiySq8zbh/GmUXoJEP5228S8vyPcmYg6hoFJgCsZKR2570XSV99pfe0BcZhntpKM3DBoq6Zxvt3NDd43ZwXoxV6LV7IYxSyibP0KNKoG1G08LIB4+yVCxzgYEKEZLTnSbe8Ej8cjW8RzkUsb4X00wxleT7yAj7ppiRCsVKJDE0kWArTtvcjBEsQRtSwjgh8BJXF6CiAiHy9y4JJY4dimMsY37Y0m0X6J4N8GJ4y7koWpOvBRzsD0UHYmXnb1a4aDpgfU/Odx+mWzDmcaa2Ps8zkmBls6rYun4gtqEvo24RVTxtUx1Jo49RLeGH0bfnKtvWTlIzg6XHIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaPpinlUCrZXa+z0sqakKCJLDC0jSDEorhttUQIgDao=;
 b=jO0SdmLiVj3rxkuLee1GlHGhx+pGl79e1upoIw+Q5cbk5jVG8jroWSS7WdrORmJU/5YPSBI8c3VKMnqVlE74CI6HXBmdiHNuRmZUdY+07+vuGzT9HRiEaZ/OeXx/rBIH+IsOWcg1Az/GQcQqe9LXzm6i70I0ljgMlpBzUCWGtdk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5378.namprd10.prod.outlook.com (2603:10b6:208:328::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 22:47:09 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 22:47:09 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/3] libbpf: BTF typed dump cleanups
Date:   Fri, 16 Jul 2021 23:46:54 +0100
Message-Id: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR0501CA0058.eurprd05.prod.outlook.com (2603:10a6:200:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 22:47:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46b6e288-b046-4eaf-90f3-08d948aba50e
X-MS-TrafficTypeDiagnostic: BLAPR10MB5378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5378455B849AA46A436D4EA4EF119@BLAPR10MB5378.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: puWHPAxm3V7xRydZj+xdSA0ulXq/eZQkk92e6b4jaGuqVPcsYxGXIb5RCdYByzLFXTPPbwYuzTbiIcDoI9JMgimluATIHIe8lcBEU8i/mtQ4kmTs68kPcJRtO4cxqMnrC+7VLCoHnCSaNEU3J7UhD9DVqvQFnncIPekSWuPQF+izB8dEwK7NJhNkufzJWG3UBN3T9Mv4SCXqGhbZRCRruOumtkB7KR5YWEmWMKWmq8tW+lE+nsUxFeNeJEbv45xST53hnBUPO3sTIWAf9508BqoqJlZg+j9cI8C0VHNoJGL6jNtuqppbqL0UbjePKLGe+kiFHv3oXDfnqUI1mCcog8yFMFF3/oakcfJyvfwx33lS2ZxOY1t6symxuEmObL4nxNoVtdpfHRqHZg082UE4mh1PNYJDRxogS3twDY/bI6+HgI7I1pCYAxdK5lMAgveiQb0pXuLR6JXmTxW9a8vvXMz+wqJ+79Rp2sPB+ErfU9VyC3JVxGJPieyguYawyhi4A3s+YEX1gI4I1cuFWK/VUqmf2TkpJ0ZkrMs17vf+svXX6WxwoeyGdlT55vUoNMirF/2qikomGGPjCXk8ueBB7egcYFsZBO+yG77RQKjdPnSglrbnTDNkQe+TzuILKMx4pbXbp0hAii87Jl/PCddNRXuEt5wYoM35K06wW4EmmCFI8ZvG5R/MsGXOpQkia2ge9itXXrblHpYI2VU/Vzsxig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(83380400001)(2906002)(6486002)(8936002)(36756003)(107886003)(6666004)(4326008)(5660300002)(316002)(4744005)(44832011)(86362001)(38100700002)(478600001)(38350700002)(2616005)(7696005)(956004)(52116002)(8676002)(186003)(26005)(7416002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WDBAaGg5qNfivfGtQe5tPpvf2O1rEiKmehpAR6v0iJKVlKxn1DDBEgjeG2Cq?=
 =?us-ascii?Q?NDLxy8kWqLHWbBlDLtBZHcfWl+JUU3+G6/42eyAlAPU+pEdY9Cr0ZoGh4X0e?=
 =?us-ascii?Q?u0EDvkHSm2+uH4HkKnJNEoqylhdoZ1699hXbHTT7Abi8W9J/vGd80gEMYowE?=
 =?us-ascii?Q?5DtaFGtVMbt6z2B3vhQo8IsrSSiBAl8HSVjgXNUf7ElDcWVIJVhDvGcCz74j?=
 =?us-ascii?Q?9Hzbsd2OJaVly0p8uRu8Djf/nK7WKOrZx5JXB2z0V7sXW8nOKV1/Q380YG5q?=
 =?us-ascii?Q?s+HUetOL3RbMQFNPP4YmprcA3wFt86EI6bt2D3ANyl87g4C+TYkrPXwwU8Nq?=
 =?us-ascii?Q?z5EComr556s2q5vy9GNZ+4kf5HMJcjflqa1v5GVWWHzpZaD+1CXG91DTyLXF?=
 =?us-ascii?Q?ESCHaLfCkWcAq/wBhpKPYJiU5sqTmLdQP1qLix53JRwFKYhjzYbfTNyDyKh2?=
 =?us-ascii?Q?N6+n8lMMs0SeANMQXO16SVNf9sh9u6e6Z5w9QiPCdYhVArjmXUC2noVvomqI?=
 =?us-ascii?Q?XpWzAf4iHuEWFlMM7DDs9LBuP7m0uaij6NWst02CdtA5443r6lLbgHL/dnEN?=
 =?us-ascii?Q?HCmCBvdfLCvKgJjaVnQ94v9ruS6N/7TA9Cv+mZA/F+bvM2l8+tQTSe6lwAuH?=
 =?us-ascii?Q?4nsYhf3Z6uL7z72Bqlhmg3vgT7XVHVbuNO8lMxapMzz0d7FCRMRxca+5cHx2?=
 =?us-ascii?Q?/FzyaR1bUjtuaWdAIzbECrjqP3AALTWi3C0POK6b2C1FL3lrcEpOkWyUWis6?=
 =?us-ascii?Q?X926MjPblSP0fIzIl9931Kwvbi0YIjZPWVV/33AOoDpYbJzmwjABzSeAe3WJ?=
 =?us-ascii?Q?oUUrNRZ57HwMKi+W9qN8sNWIcixX6XNC3mofn8nYh27rlkeiN4oFF4OyZv+m?=
 =?us-ascii?Q?sxJobGx1DwPGbnsWrPFeb5Ib5XMcntWT59rfilLQrO1TUl8+6J11/YM7w88D?=
 =?us-ascii?Q?686bzlfiDI62HPzf3ilFIvKuTPF0H5nFJtJsch8nktCZpPeTQcdX8CmBUDsS?=
 =?us-ascii?Q?zesJLLWImjFImw3Lconn8qELpTz5Znur4ldZ9s/3G4eN39IACYG5D1CVTVtv?=
 =?us-ascii?Q?WDRWCw627wAEdeJAhLubh4HwDifg4abGlIQi3prJATcuqRSLkwnHNMILuWfj?=
 =?us-ascii?Q?bMLTLgviTH23VeQBS0y8zQtuQncmnJLA5nyJ8N7pHYo8U4fuQfNsSzeGLzKI?=
 =?us-ascii?Q?uHM+b8d07LWq+pE6PXJMHZCTODTwuR7kdNPMo3iIto25Ion9FyH6l1Jn7tqs?=
 =?us-ascii?Q?EvbIQyK2dvV6ldnWIvcdDnQJn9F8vu9zje80wwZrMbbMdfOnMacB9r96k3bj?=
 =?us-ascii?Q?3AezA0Z7typMuoHI6LPhuT3g?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b6e288-b046-4eaf-90f3-08d948aba50e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 22:47:09.7648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wh3ARFSfsOxRg/1Tc7ZZM6xJ8fl7+bGHYkVECme0FT0nhO+Ldzth5nmGEKQ2TDIstMLHK6z3GENAQAXQcrWmHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5378
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10047 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107160145
X-Proofpoint-GUID: GahLvEBtrWLrjPL-fuIuzgEjzkeE4Qvh
X-Proofpoint-ORIG-GUID: GahLvEBtrWLrjPL-fuIuzgEjzkeE4Qvh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix issues with libbpf BTF typed dump code.  Patch 1 addresses handling
of unaligned data. Patch 2 fixes issues Andrii noticed when compiling
on ppc64le.  Patch 3 simplifies typed dump by getting rid of allocation
of dump data structure which tracks dump state etc.

Changes since v1:

 - Andrii suggested using a function instead of a macro for checking
   alignment of data, and pointed out that we need to consider dump
   ptr size versus native pointer size (patch 1)

Alan Maguire (3):
  libbpf: clarify/fix unaligned data issues for btf typed dump
  libbpf: fix compilation errors on ppc64le for btf dump typed data
  libbpf: btf typed dump does not need to allocate dump data

 tools/lib/bpf/btf_dump.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

-- 
1.8.3.1

