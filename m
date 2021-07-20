Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D263CF665
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhGTINF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:13:05 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7128 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234692AbhGTIJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:09:51 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K8gSW8024346;
        Tue, 20 Jul 2021 08:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=hzC+dJeM+zmIjh49M1hPhxJ7xspnEfeZ6hyQqrHoyXg=;
 b=ZrKL2SEtFIKyS4AhqlN0n3k6B31hKDoVbcgcwXIze1mNOf89GAeq41rMxTJV9dde0yYS
 qBs+SdWykW34Nw4k9QbdWaaHEFuAS8l+NUhFyj8szAuzbYSN86jg0ZE8Q7uiphjxK401
 fTKfV6OEmLIWCpVcf/nxltS6UxdkqGjOk2HjbvGMHc6LZr2Ai/ho/o87lqO6gWghm1B5
 3PFAWog8XFsLY8vd1cD6RLGGSFaTuB8J9pt2yhL8B50nYFC0Ou5mFqXvevM6o9g910eM
 5YOcejMkn07oEAOngBTBc9A60zYsvXjY4vEXjxZonaAtpL+2cntRtTsijRJirqIma1DM lQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=hzC+dJeM+zmIjh49M1hPhxJ7xspnEfeZ6hyQqrHoyXg=;
 b=hTmOgAb29ChzUhaegBZlfyETpnXwmA0nB7wRhtdNhACJBg9QPax1zOF23rRx4mhkc9fT
 PKcpmKZCG0FqmtrhAu3FN2+Vvd038BgIHKcqyOokOQzFToGqgw2CWRq+BGKC8qZY+akb
 76w1iVCFaM1q3B5w/bFc5eQVshC7RczT9RYhyE42S1eMgprWiohclrfsXim5PJpiS4gT
 X/RTlUemKSgQUnVtRjA2xQgZRUKXjQ8Ar1IIMPtuQ3jR/GJivDHSY9nCOeGwz4RYQRAh
 KWNvsjgwv6QfO9+GRbWPRHLJWonWScUkeDif12PUiJzSHeZN0ecyQP2G/LN9oWRV/hHm eA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39vqm9bbt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16K8f5T0175319;
        Tue, 20 Jul 2021 08:50:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3020.oracle.com with ESMTP id 39uq16f59u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl/3mcb1C9DOWpz6jxA48CDVqfHWIBlCFZuiNvMz4WzUgcQGpPxIiOtk1xBDVNBlzHlbn4fFng1dmkgFOK0kJ8z51ExhKGZhKjz8vEeAuPibzlteD5/3lFQxEMPMV2xV32ChEimIa6EyCHleIGRvXySjNzY4lOyKG8DMys0WcxHTipdXfPLlQV2m6r1bW7nUAYJxiXqREGdenN/gxpzdpZ6tljTIf6E/4gTttQ+kv0R6kgWXDYm/vFH/yCqmlFtO52RH+Pdwic3+L31og3EllxdWGR/qBLtsd9rzaiNZT7RulWbyf3Wy9xqyFo1l4NF43CNAKJ0RhWQcKj3+gk5OWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzC+dJeM+zmIjh49M1hPhxJ7xspnEfeZ6hyQqrHoyXg=;
 b=ffzoB1hwGzK/Be6YNs8g53B5SJl+IWBNf9DBJd9uhCZZ9zBK3jKlKSUJfW09d7/Xy9bf/fi8ELwbs2m7K1V+f0sgNvmWUBhNbbMJ170pKqSqAVqCnNzV641IN3KZNJrSHlE+fOiuHqFnrZuFXB07sj+iwTy2lKyxqNt8c9BDg9HBLeJY8CPtKacJYfCv8PlhwO5DqYlUeVREObolMWsV7wr7ee+mGL1TIZxbDKi+o5NgRYTSprmEXE0KTotXNeUYpHeZDqezYY7SsriRUf+3k03fxLD67KVC9P87A7sBun/J1S0O+/N7+mHHQqLBF3LFBsAWk6GExfBQ6YOSFrlW4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzC+dJeM+zmIjh49M1hPhxJ7xspnEfeZ6hyQqrHoyXg=;
 b=qNMkfmqbLlmKhu/ZrAxHUskHemEs1FOzcxumMDhqrofY3F7WBoXE+JyjH0R98QDc14immDjmfNpMTA7YZKTaXpWRq+otjpLb7TM21oUopZKNYdSMq6+Sye17O3j/gGlrNHSwSuOBQCTr0Ui7T3cEFfcvoBJaOZDIKivX6l5Rxb8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3246.namprd10.prod.outlook.com (2603:10b6:208:122::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Tue, 20 Jul
 2021 08:50:06 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 08:50:06 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/3] libbpf: btf typed data dumping fixes (__int128 usage, error propagation)
Date:   Tue, 20 Jul 2021 09:49:50 +0100
Message-Id: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DB6PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:6:43::12) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DB6PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:6:43::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Tue, 20 Jul 2021 08:50:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa60c34f-106b-410f-475c-08d94b5b5f48
X-MS-TrafficTypeDiagnostic: MN2PR10MB3246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB32465B544F9D46FB86996C49EFE29@MN2PR10MB3246.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PViJ+jjV7BYMIHNyfqhOItOAxKR/idikhZPrYLUjNwpz/n9bxb79SEeQyimpV8CfWuATpJmhscksHSopiUD0vwr4N3R6URbkTNy1uUPsgkgid3K6XOOnLEjDhDobk4B1BWftUAIlvXBJhwtmBFZHZAxL05P92OqOI7xe74B2O9D76jeEMqRc+IfWmdgjrhMGPGSOUQSMmR9UxA6u3MjYwt3jAied5YmraoGR9LeE840P/qfLL3TLyyBaPv2ktZTDYtrXVx42vZzBueYpsNQft8PZZfzxgyws1uTWNN039BnKWUB7UzfGiMC5KhR4v7MZyhFJoeoVgFhXNTAqaQlVt7NyEAxK6z2yETp9E4TxFTR5dxoLxKIAFWrG+pnu7aFPab1cs8pAPDLoFaCgc/75XGeDXobdjGFbZ0VOeM9cnQrwUf6TtxMXYJwotWQHkoykTBVflnsdHRISFk7JJu+vactDJW9o0ldJdtNjjreOzSIa7TYqPKh8dsfwxArM1W8UU2hG4vfVwBS5/74Ami4HbMnbmDf6hdcYXWU65TAK6Olg5Q/IIj0CrzGVZ/s7Kby5d0GlfQdaW3/iznum/egdMbg6exP8BSgfdKt5h0n+QpOJAzT0bCGl1JrELSVMnDwYDM9axflIPQkRd4A02+eP9nL89l+2bNXGPWPm6DRhredS2JqZt+e3RVnIIgcMN9sa+APWHfpXhkP3PQyazl/aXfVgr4INx2mKaxYyIszweumE9ZjZL8zFN5RYGqoN7Oa5yMPgheDwhEboFDRbvzEL4GD5cj8iU0ospM9Flqs1I48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(52116002)(6486002)(26005)(8676002)(6512007)(6506007)(38100700002)(38350700002)(508600001)(186003)(36756003)(6666004)(316002)(2616005)(66556008)(66476007)(44832011)(66946007)(8936002)(107886003)(83380400001)(7416002)(2906002)(956004)(5660300002)(966005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o0eMUIZzbI2b4al1vdAQ0AI+1IGnDy3Qj29A31Ljjl54evLfV8KFbS/JzCrY?=
 =?us-ascii?Q?j+pp4DQEIpOAHbglwvpxd3F7szNnu9o/buFcLmLfsW3O3hCHpKdsj/A6Xb8B?=
 =?us-ascii?Q?G6IcrYcI+r48ESeu0Fna02ZRARwEecpWvAEjmMZr3kEb8yn61XnmaENpGsEH?=
 =?us-ascii?Q?3Tb9nDrHYd6KU7avu2KLw1yW1tfhq71liQH+TM1CB+t2/QM05/N+Kjhy2ZU3?=
 =?us-ascii?Q?xlXMlk2Byf+1ftCjp8UgZq50sUCaoeDxOS7jBzusQcFBUGqtnApM8FeLTrCN?=
 =?us-ascii?Q?oAtIjWPjauz3gIUS1ehIdJnguI/wZg2rAvXrnKMlbYtV4m9orseqXD4on3Pj?=
 =?us-ascii?Q?195ozHWGsTShDuxsyJaJIAYCpLXMTcDJNRGiKnhGFjO80PkmmhoNTGhN2Mz7?=
 =?us-ascii?Q?n03eG2qWyiUxOm98iJVgFMj5wCO0+mFxO0DYq52QfiiSsNSTFCmM/V3hgnIj?=
 =?us-ascii?Q?ERhljFL4dOvsiXNxfClF8tgc5aB+ykl4mQSju0EYFMEQ1/fbkppVkopLKtlm?=
 =?us-ascii?Q?cOS8m53LrVXgMqw2p+DBPHw6gd4g2rwqnGx9RtjRLs4KBTUX4KktiIhjFYY8?=
 =?us-ascii?Q?X2EtQXznkKnhbvWUDdashb9iPhMAQEIvL8d/GQfgjfsByewoGXbcQBFa6PuL?=
 =?us-ascii?Q?+JaDJZGs7GGPOMQC9M70wsJkhXqt5KENRrmd8WJ9g8/GeWgT59z9X6cnVohm?=
 =?us-ascii?Q?FY784XOCfh6V5FrOeuCO7A4uxXv1HZb+BAu0S+rKNiGXLH76hb7tTlHotsXq?=
 =?us-ascii?Q?sg/CtQbl2IImQdRBdZdxgU7iDxGYcI0dJ2ZrdxwSWpGx+VlniAukqJqyXEpk?=
 =?us-ascii?Q?IaEoGhIWR8Z4T2Tnq/23Y/Aw9DgCE8CspeEjx7rFwnFOKSph1quAAVdTtx8v?=
 =?us-ascii?Q?bWiDVGIjz1WF949wu3F7vxylgFXB6tm3RxOI2iN2hgA8lPz277d8gFwOciJ8?=
 =?us-ascii?Q?T/MKl3GT+17Xs4qgpLU8ShflHsju+XbkQ6+RMXkTBRraqwubfyZePlXSvYlv?=
 =?us-ascii?Q?aexpFLvM2cce8G5n37/zTqNlOyt01w5gD2oQjChwIg6IG4djtbpZDsqf2XV/?=
 =?us-ascii?Q?J5xGA7w9EDNzhKx2f41xksl1CBb/e6EjQa5p6aUYIIrP7K4cJt1qplCF3ZfH?=
 =?us-ascii?Q?e4/iHppHklnVLIyBooR1cAdPJotZbh0bCpUM/7egAqiAE3ulHnnT7xFu9zKO?=
 =?us-ascii?Q?YHBJgDB2vW2h90bxtCZ+sTMvy43wvKg2FZ3E9a4BdAl0KXxt3kkL71sHZxad?=
 =?us-ascii?Q?VFYJiLkj6DRs52ewiKD1giOv64pr3vnnY45Bl/7XJk7u84yWtMSd77VCrgdD?=
 =?us-ascii?Q?1k/jbANhXekN9CBbipPzSeca?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa60c34f-106b-410f-475c-08d94b5b5f48
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 08:50:06.4346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOjA0L65inLJmEJ3hGpRQcA4pDQeXWd22Dr14DoYD9hp8YEKZv1woBeEPCe6anL8mbZtAnwBG/HQRm36dk6YPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3246
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107200052
X-Proofpoint-GUID: L4nQCP633gBXo5bvGA0pd7yn-aMLqIYd
X-Proofpoint-ORIG-GUID: L4nQCP633gBXo5bvGA0pd7yn-aMLqIYd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to resolve further issues with the BTF typed data
dumping interfaces in libbpf.

Compilation failures with use of __int128 on 32-bit platforms were
reported [1].  As a result, the use of __int128 in libbpf typed data
dumping is replaced with __u64 usage for bitfield manipulations.
In the case of 128-bit integer values, they are simply split into
two 64-bit hex values for display (patch 1).

Tests are added for __int128 display in patch 2, using conditional
compilation to avoid problems with a lack of __int128 support.

Patch 3 resolves an issue Andrii noted about error propagation
when handling enum data display.

More followup work is required to ensure multi-dimensional char array
display works correctly.

[1] https://lore.kernel.org/bpf/1626362126-27775-1-git-send-email-alan.maguire@oracle.com/T/#mc2cb023acfd6c3cd0b661e385787b76bb757430d

Changes since v1:

 - added error handling for bitfield size > 64 bits by changing function
   signature for bitfield retrieval to return an int error value and to set
   bitfield value via a __u64 * argument (Andrii)

Alan Maguire (3):
  libbpf: avoid use of __int128 in typed dump display
  selftests/bpf: add __int128-specific tests for typed data dump
  libbpf: propagate errors when retrieving enum value for typed data
    display

 tools/lib/bpf/btf_dump.c                          | 103 ++++++++++++++--------
 tools/testing/selftests/bpf/prog_tests/btf_dump.c |  17 ++++
 2 files changed, 85 insertions(+), 35 deletions(-)

-- 
1.8.3.1

