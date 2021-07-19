Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FE53CF02F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359409AbhGSXAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:00:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34208 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1388649AbhGSVBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:01:21 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JLa5uU004799;
        Mon, 19 Jul 2021 21:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=45zME6t38Eq/k1Tof9zkIRVj5xrSgYApl7a7+3UheF4=;
 b=yUKYLzrmfQFGywdeKca4UUw1kJ44boQHzRlw6L+sOdRn1Cu0SxEpJRkjHJLPabH6srFd
 W7grhe5fyckRveZY7MVTn44t4k5ZHdel+zflp8KPQovLnk+e9IfgQiDFV7AHruoZnU1/
 /BVFRnQ6Do++iVoK80Vh77KRgpkmPnhu+BiXWIMXHRx7LaaDYI0vD4hVl86Pki1rBG4j
 Thm+GJm8BkTLLVVipQ8mLb26D7B4jlVRxkD+YVG3xHYSFBMYVw0ocEHq39hhaSzTQNyn
 O4imzfriKaEMJapz9wjxb2m9gfrmzZSuY5TvPfRmcCe04eexG06/LJU2XSgrqxawHmvA ew== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=45zME6t38Eq/k1Tof9zkIRVj5xrSgYApl7a7+3UheF4=;
 b=VGFGJr8aH9Kuao+uX1/sz0k0OH8GSkGVt/4vu5+MPbQ/00hHjXE7qMouokVwy4FnfxbU
 AI4syFuagpYSGYvl2jG7oFlGVH+HzkXFIPii3O+WNIhphuZiC+4JEeBtcr89H8avHO/H
 MrcFmXEzZll7MHpTzOulOxK76fof7kXANimQt35Mh5uKwCZ0KI88mhvgYKYYdC12qpnH
 LPGvKtSV5Ejioghtmuv50gTlxsdMCgsac9djor3exHgZ9rVI4SjQElBfHZYPsbeSjJ5m
 IRduwJ6tfbVfkUiACbmlfz/Q+q8T1gBi5LA97KvFEw+5RsPL3VosjvXvGPQgwyEMW29/ uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w9hfs67e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16JLeFJr112838;
        Mon, 19 Jul 2021 21:41:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3020.oracle.com with ESMTP id 39v8yth85k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 21:41:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TmbHmKylNj6uHV88wQj/FsO8m42svBpDWDxxmYMvAnB2T47D1pjpri68DyfK4TsUUXLb6NdQCAKNqa0m1KMpz441XcFtrpuf8CI03AoThaBinDguzGk6EA1yBnHp/SK/qN1qoDCwFYAAgk+pwTfv4YXnMyrT4gtFhT4iWmYJTmemmVJ8o7s9n3/Z3NO4S1AZmSGJIuS1EjIjB8R8/ndCenk+scE3azFdFcWOPVLlZFMe9+k9UyuUtxZDe7xfsIGZRRoNkXZMBdlPXKzagNyY9MlTi5QQfjJ1i8Xme4QH0lPbF9A4+BhXKakFO3Q9uiOH3B2lBOTk4yC33w9TnsCKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45zME6t38Eq/k1Tof9zkIRVj5xrSgYApl7a7+3UheF4=;
 b=BOHHScV2FGHdVW6H4A+OAX3nIY0d51NlgToXsy8hogVOBr6p45s8dUgo6zp7y1tttjiUjgWQfeoSItSybYr6L/qnRZvFkcVIZk2b6W2RLblZBrBZzDdWL0V/d3RK3hwYqdQRgmxAzYWdQ+09vcwDVxgAzqevVgRA8miBya5TTMZcn+IJO1lIB7m8tOv9tgqSIQdW7t6JjluLwfg7OeSXuT5hFyCemjKqsJXYjwdEj2R03RIajGcy6B5zJ87lZdJZyh+wRv2A07hCoi7pd29+ooVzORmpuE8d0B8RhRdN96WSUXA7cuTug48eYhWUVtqlUCje2aid+xNVjlbNadE97g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45zME6t38Eq/k1Tof9zkIRVj5xrSgYApl7a7+3UheF4=;
 b=O7SA0yt42adOsXgc8ZZgvuYcOQ7yyHwmRvLnzBgujBIVjZLhFHZbGnYkxL9CHRSfRKoDjZ3lLsP0Dbzhil2PKMgUi0wgqIAxiE/ZJ0j2eMwtg8mMF4y97glDsQdeyakasqkfZxaBx8zVKNYB5q68Kr0Ew9aBGdhLA0UX9B16rQc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3614.namprd10.prod.outlook.com (2603:10b6:208:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Mon, 19 Jul
 2021 21:41:35 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 21:41:35 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/3] libbpf: btf typed data dumping fixes (__int128 usage, error propagation)
Date:   Mon, 19 Jul 2021 22:41:26 +0100
Message-Id: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DU2PR04CA0278.eurprd04.prod.outlook.com
 (2603:10a6:10:28c::13) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DU2PR04CA0278.eurprd04.prod.outlook.com (2603:10a6:10:28c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 21:41:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 180a276e-eb28-4bfb-143a-08d94afdfb1d
X-MS-TrafficTypeDiagnostic: MN2PR10MB3614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3614180C373ED7501C4DB3C7EFE19@MN2PR10MB3614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoVgjEVXkATHOohGe2XSD3CtbUaVRACgjm1MSrCc3WNNE1PqlhB0Lx7n7UhXZpZaJfn0Gcis+us1F2DyzkH3ofMa6ljuCXZcUs2SLWAFoyblwhnnF/WU6+AoYS17nu36C14ct27nUyryqgcLepuoV8fQW4lsgNmPSnPdmuMvsGWDgQwOcb/qsop5YmN5j+KWEGmu3Mzv0XTS0aqo8TYKQWXjk+I60TYkvUepA1lPxppN59eZILlqnkqhVO8zNifKUac06LPcCXIS7YKx0Uaiz8j47EWSun1f2mSW6CUPMTFZ+hSkrgfVgoionqI1OQRvxV2rZJVsDyWW4qcwdgLu0GnYpQdehCHuEKIySKx3WpCE7SXSC6CPwAX2x1cxYPzm07bYkXh7dbu+PZCNuDFKTJUJXj5X66ZowJtRJnFJ1j5tQ4XwDlt+/++enjE6/m3C9/DZupJ6UttO6yJthGcDaZ5N0HYpiXmy1FES0oBlZBS10S80H56LnQvb1u6OJFLwb8UXU3EPCxGjyDTBqAFrWhtV2A7l8zY9pGx0/f5Co+FMVPyPREJqjf1GKm2nm2rEYOGc9OoicEXjFMUXvB53XP0/C+h5/4/nWZbNhIpP2BHhj34993fVlsE9fr5dyAPylMMu/UBKUUIVA7Chn1nL812T+82MbXucFxJ+QRh2G7NaHxmoa4g+R4wqLM4Go1PE4LlMz9EhyPthVcwROsyf4teNkdChWNNvGi9Mv8G+/lho/sGbuHJt0CyZBBPCNbQeD/xkZNUvJrV5TtQFt4HjeyaKU9EwGOg/UHOqvjdmJ/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(6486002)(478600001)(316002)(107886003)(52116002)(4326008)(966005)(8936002)(38350700002)(38100700002)(6506007)(8676002)(44832011)(26005)(66556008)(86362001)(66476007)(7416002)(956004)(2616005)(83380400001)(36756003)(66946007)(6512007)(2906002)(186003)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lBV7+hj4sV/OBgLsFkhMKqNY0ECKAOTGyAryDedfWjlyxxYv+9gzN3dIX+Hi?=
 =?us-ascii?Q?aeuu8LTQqOo0igXJElgJvRJp367Nlf34r9FLeGkgOX/+q2GmR5lLlybWZfUX?=
 =?us-ascii?Q?vHO7d23GLrBPX728y+mlHcvolf8kmxioS5Tl4jWxnEcsYhv/a48ZmAc1idiZ?=
 =?us-ascii?Q?rFvKxRkpLykEzkE+uuBSowoTG+5xXjH+CDDxu3AXWNJI2ajv1uenUR9f5sYX?=
 =?us-ascii?Q?bnegDuCbsd/M07G0JoHclDv5PYV94UDVNhk2d4BLupFsxQHHR7m7ZD/W9zXv?=
 =?us-ascii?Q?NuarGZpO84L/CGoC5x0XsoR9u0X/8gAwRoDYYEdnPX5IoU1hX9um8Q40NVDk?=
 =?us-ascii?Q?IEceIAOS4kgvVHA7e57adTQ+pVQGypw6U6KWO3L4R00WFBPaJ9O1QS4hyEc0?=
 =?us-ascii?Q?ErFKrYc4Vwt4f22/wm+ISyqGyXyMz2eShg2s7lIV4nWVS3jZQHsYmQDGVKvF?=
 =?us-ascii?Q?dX8tlz31cpeKwlqGbcqbU8E71P3qhk1pvIuhnhyusq+4RzK6PQj1ej+SUsyy?=
 =?us-ascii?Q?mbyFWSEtLDhtIkWZY7M2Tl5H7BJ0xPFnYuA7dMfd7SzZYebjnmOi8OgYRKxX?=
 =?us-ascii?Q?ThSp1koPDP9uYLFs6Swo55ziR03TZGH/DJLSf90wIXTjay16lz6GpqcZFq0a?=
 =?us-ascii?Q?1L9vc8PR77HIuiDxscH1rGDz1bHnirr77HKZvIS18uVsQxGIuscAH1KjLKCN?=
 =?us-ascii?Q?bctl75/WV3X+uTzlMasCO4bTZFPOLmWrFPLUIksP8z9SfFc2Qn7cMoNkRk1r?=
 =?us-ascii?Q?3TBoOFRsNl03Ap/+njuacEvSf3iYpzSbtdGHfy6qZncXZ0epnUR9bdZIT5AG?=
 =?us-ascii?Q?kAnSxo21Va1Mfh1RZ4J5AZVRphcyeiPWwVensMM2nXwsCLYbX9+s/kw02Qho?=
 =?us-ascii?Q?MYRnOFsrqy2msJnJY6BOFuSk2hUoyURdAW6uUyR07W+0mE+hsSkKIg/4xCk4?=
 =?us-ascii?Q?Wa/QYeieWAOwbkMtuexSgfXZHJ1SgTATUgSFF12GM3Ig5degc/VTl531Vd1R?=
 =?us-ascii?Q?B0WnZvfcOFu3axJ+KweBHWLBZYf5BQe6TTgoTLEgSkAHy1d6VlVIKIbA7SVj?=
 =?us-ascii?Q?4XhuOKa1jir3kuNW1c/V/at68sWEoRhzw367I6WZd5irD6aLOTv6WvS6dZpX?=
 =?us-ascii?Q?rrkc8Ani3+LAv5LlnYQoZ28DnZtXIhcUPJiJclOKcGC7oAHN4X8NHExw6ap3?=
 =?us-ascii?Q?7Pck8UX8m9rS/fuF6Lwy1b5q8rVz8iJEQphVYbnYaAk9WTnC9zYj6wOYObeO?=
 =?us-ascii?Q?2puSU0DzQNOu+EjrdAXR6gOru8vNe7pc/4g+HKAhAXiyoyvfKCipHiU3JiU8?=
 =?us-ascii?Q?q95e7WIIXm/ci+zVYWNAlLPD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180a276e-eb28-4bfb-143a-08d94afdfb1d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 21:41:35.1446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztC0ADBECf+bvQl/uzIW5WrNMJQWaypEjnLftlmSj5clLDMp96ZUok+vr/gqRkju3ac8S6m4a4drwtsNHOpIuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107190124
X-Proofpoint-GUID: bfNNAkuFhYX2czUsCMyID7MSd0gvgFan
X-Proofpoint-ORIG-GUID: bfNNAkuFhYX2czUsCMyID7MSd0gvgFan
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

Alan Maguire (3):
  libbpf: avoid use of __int128 in typed dump display
  selftests/bpf: add __int128-specific tests for typed data dump
  libbpf: propagate errors when retrieving enum value for typed data
    display

 tools/lib/bpf/btf_dump.c                          | 67 +++++++++++++----------
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 17 ++++++
 2 files changed, 55 insertions(+), 29 deletions(-)

-- 
1.8.3.1

