Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D1724C07B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgHTOVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:21:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgHTOVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:21:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KEJWbg022686;
        Thu, 20 Aug 2020 07:21:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=I3QzPAp8sGHRZXjEezRn5b4Kscfq5wicJNT7+PJFaS8=;
 b=Cz2DO5oPY8tdb1VpkszP8BK8cWPHHR2m9/E5b0BM9wzATX9sbfKd8k2inEvhdB2cBMy5
 rhtLKySKFn00e/WjLQEvfjVJ/uIMrAuTDLcfrjeAeM6T6FfHNM5VmCwf7b7O1ES6g4Fi
 mKQIRUU+KPN9i8YvCHDaXO18C2nf2DGpD2c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331crbbfqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 07:21:20 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 07:21:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2G/67Ng+N7jZWN6OtwJTFDR6V13JCiHXmj6nHSWcx3XGOHNZMHBxB26y/N+mi2Yav03cbnUp8fbUTdltODRDPNMKjCkWotwnHvTReAoskyLICighz+woYhaDZEH5FcdPvbPwNJ7eB55qKogEOdCD6twcTXeJhpZDlhw+Lrsb3xHcrpeNyu/ozXyCs8scptFwljtBb0BVvDZ46/0cDGO4ONvtxhS3JTcRWoVW4MLa/53C8JxtLhg5RlZk5K8Fus7Fh+O9v98Jf2QJqZdyo7J/jL4H6RSoPoI7vzHx1sHTUaPSg0Wsul1ifP0WbO5flkiD4WTr1h6RAVv8glUqVO8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3QzPAp8sGHRZXjEezRn5b4Kscfq5wicJNT7+PJFaS8=;
 b=Y5dHwpm7jveQp2yvg+ky6pl2dTfV3p5tutBJNVLK0y/AB3itTjt00zvuGhFv5abG1CkQN6LUL2zrSwn8dKrLayhGhV0BbSuBXt+pjAKySxhYCfgwvsasEzb7WyYE3Hs/oVSynFkNBBqO88oAEc7MK7l+oQwmrA3SuXc5vdqbr4pgn34JuJFOR4i0kNv7PR+dIcgmSyogX3S7nI0NOOhSU/vlhQKZGgRZYFVkH0ajkYkG2wE3VMa4n3NLYX79sCP+pnMG2lEPDoxEF8VSW8AdxYB3qNpLtS1J7totPW99sxYSdZGqRLyy+z6STMKr7Ox5d+Fsxv2FVE63GSCFJRG5uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I3QzPAp8sGHRZXjEezRn5b4Kscfq5wicJNT7+PJFaS8=;
 b=TEPLNZuV+0mFMVU+XiPVizONNEjGt65DTFJ/4fdpoLooxz1dpbXmR4jeVWcKi0eERIDz/uE06fJ4i7gaTzcGb/ueeKLjEhxfK+rPdtH4M1UN8XxjeaiegyPzSQEtUIDOwDAMCrHZ0uVRVDo5EXeuBchr6l2BeqDLJk/xQKVozfo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 14:21:18 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 14:21:18 +0000
Subject: Re: [PATCH bpf-next 2/4] libbpf: fix libbpf build on compilers
 missing __builtin_mul_overflow
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200820061411.1755905-1-andriin@fb.com>
 <20200820061411.1755905-2-andriin@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <e145cd71-8432-59d0-81a5-b253935385e1@fb.com>
Date:   Thu, 20 Aug 2020 07:21:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200820061411.1755905-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:208:d4::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR04CA0017.namprd04.prod.outlook.com (2603:10b6:208:d4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 14:21:16 +0000
X-Originating-IP: [2620:10d:c091:480::1:7ec1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2034f4b7-3b84-4e96-92bd-08d845144db2
X-MS-TrafficTypeDiagnostic: BYAPR15MB3047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3047B4C6C43768297A582C8CD35A0@BYAPR15MB3047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WXR8+CvGosYYxbDk7XRrBbKGywnyXalgghg2xGwJCwWzvKQTumE860OqVQtb6xaSjTBuCfwVCt3xDegSkTex46zm6AJ3f3TpQ9Xw37sxQzsDjyvS6ZWsUkDOZqckSnd03+yDSRYcVJ945PVX99mYSJRs/qoXjl1pObmL8b6pWwVA4RlC1FqiGJlOYNf6kROjnRLjRShlMfS3+cA6EVRn7tNVZXQDWvhf0YfJIgqpzg+geqb6Sc5xxV09xPdHjkRVqCa9juH+4JWXET5NmpWlnDbmtV9eyzN5AcSzD1f1agXjNFOiFKsN68UQ49NXmaFD55M2chezm8XfkvgpW0cKZJzPj8L/C7aKSqKHr3AiBav22fdDlo+7vCaM9oJboOi1WtWEGBsM4cJaQQtWY0I02xBFlgnffIQ6M2f53/zpIYU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(4744005)(36756003)(478600001)(956004)(2616005)(2906002)(8936002)(5660300002)(8676002)(66476007)(31686004)(4326008)(86362001)(31696002)(66556008)(66946007)(110011004)(6486002)(6666004)(186003)(16576012)(83380400001)(53546011)(316002)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: I0yzOQI5rO3oUsvh8oIa+PsnwTsp8NeGobB1ub0BqSLSAOdQr+2FskxfuVBwUoPo9w8kmZ1LAtbYFpaEc93BcLjeJ/iKI+1Fr1+JZwfsCGcKZAadwLXlNRtc7xDtiSUdcnK8ORLE7qZ7ooEkDtK7X6zjbDqdHqCvSV5I20M2eQwBfyW6844cSAl/wqVJ+h0JDu/VVmWE2NEq2tmP124qFQ05HijlKHQHcEXOgZI6m5LwIxMDY7qv2VHPmMV/1CpmJ75X/xPHYjT1zqCbKHgR5YA+CB68qhLQppqzayN2MZIfBr1/bpeG5lSyhP3VrzRmVDoZidPd9/LSW4kLPwVSXNyNn+Gw83H/21EXuwcKOdeiwBUQLGS0jnDvwv+KCOSGrCuBKwONQyTy5ge8RaCd4SCaMWVQYaHWGasUsWnBc09CiAiFXUwegDvLkasj1s7mclC9OVcTpa2G0WszSwzdxRdPnym1zSdtRaB00aRKYyAz1+Dc+WgTwTw+FG3dq3hA+L+eVv6SR2Mgxzv4jwZiqnud4kJl3CrMVheceu9XhY+tWTp0wm4QBSABPdnNY+xltokBGA9xAUE6/xoGlC2EiTOionZXTbkRLDioIyw/f6BbO9sQVEbkywxVnmilpV0X0FJ/lwMDTyIuTsoo0y7H3hVnx3XXqAMNkbr7wwOdSYZxPoyH9bRK9AcUhvDEpcyP
X-MS-Exchange-CrossTenant-Network-Message-Id: 2034f4b7-3b84-4e96-92bd-08d845144db2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 14:21:18.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPn1q9cKXwcRUABrJlTInl8IVcyh3xQUacwi9XBVo1F+1zpkmRW5y9c8Yab9Z3hB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=867 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 11:14 PM, Andrii Nakryiko wrote:
> GCC compilers older than version 5 don't support __builtin_mul_overflow yet.
> Given GCC 4.9 is the minimal supported compiler for building kernel and the
> fact that libbpf is a dependency of resolve_btfids, which is dependency of
> CONFIG_DEBUG_INFO_BTF=y, this needs to be handled. This patch fixes the issue
> by falling back to slower detection of integer overflow in such cases.
> 
> Fixes: 029258d7b228 ("libbpf: Remove any use of reallocarray() in libbpf")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Yonghong Song <yhs@fb.com>
