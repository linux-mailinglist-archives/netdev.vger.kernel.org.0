Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2DC2F4F7A
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbhAMQGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:06:24 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28528 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725801AbhAMQGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:06:23 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10DFPvkV022210;
        Wed, 13 Jan 2021 08:05:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=x2JOW2zlRsUtINi/XEwulTn2Kpfd7WaL7NODJGJ3XAQ=;
 b=IdZm+tWekX9tTTCs7kAu/3zG6rFll8PnFEEvL/C1bUnYkF6we5LbcVd/N/hESP1QjVT9
 CNYenQkOMe7vdWAAupaycrleafmAENaojQsNd7ya3e7wvL9HILjkE6j2QJQZ1o0kEnU+
 c4A+0bGkIgYSTNEIEsgwAI4TdWb0dVNAP4Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 361fpe5t7w-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 08:05:28 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 08:05:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUXtwSX/t3KLBvccxqy1r60soZ9MYI+AisGEr+kgZrf4psXLvaSUqWBr5GBStkSiX3MVkVmTu+nq6KOaQOeXL2Mx61xcDzUUAIOlcAZlaE5b7ms8re4heAnqG69yegVRHerc73b0z7eXrnJbLooCu1CRS3l6KNbvhlvk1ayaWA9SrK9gjtIbQacldRB5zeqDHoOX5ihsEe+qQ6iGKVEzkg01hBrCd45ntxd469rnMB8ZF5v72rHulvlcpXXbYLjZJjCqdLY+PC5K+UN3//SFRxcr47UwvQwrSStDTdeDjEv5f2X7L9p4vR+N6UypYyKmhzcFQsM08dA6nK6bBzfBdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2JOW2zlRsUtINi/XEwulTn2Kpfd7WaL7NODJGJ3XAQ=;
 b=RF62ne3S/vBWhGqy9Cm/G+Gb/a6czuc3hnjX3Pm3a+3eb2+aR4IujAS5hfMMQuPRVCGV6eB3LQc6JTyDN2qDaWWLBG7dnWMKfz5QG3vNF3q686VcI2pJwouPhi5GB7SlaHXAgQ22gW+wNCiaKgzQaiAqkeJFC9Y6LvOBmH9bzTwKAopgJ1pMhtR+goeL/JeQ4R88GGJsGFxR5TuulMoeGe+xmjmo3w6gS7NEUsdEtCzV13aeq8iK0qE2vHGq+V5v1uzlmDnlTYO8aMPKJHGgIRIQkVA19oLiN3O04sx/d0XuvzHcpLAeaN102NpIpk5YJv9yGpWleHjk4EltI+cNgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x2JOW2zlRsUtINi/XEwulTn2Kpfd7WaL7NODJGJ3XAQ=;
 b=Vi/IsXqCo2I8cHpxlPYmct5gpXp5WMndGsDScecuhqGBAvpzx3lZJAbe++81o5XOEhgJj2ClYiiy+gXQV5Ob7Y+b2a+Et4oimBHIraSe2p2AKDJW/LrKxQkyal+qNgyiFQYxn9W03D2RykAwlMFTv08HPtP0GCXxFKm6CSJQBtQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3190.namprd15.prod.outlook.com (2603:10b6:a03:111::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 16:05:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 16:05:09 +0000
Subject: Re: [PATCH bpf v2 2/2] selftests/bpf: add verifier test for
 PTR_TO_MEM spill
To:     Gilad Reti <gilad.reti@gmail.com>, <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
References: <20210113053810.13518-1-gilad.reti@gmail.com>
 <20210113053810.13518-2-gilad.reti@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c245e747-85e6-e9be-2dff-064f64555fd7@fb.com>
Date:   Wed, 13 Jan 2021 08:05:04 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210113053810.13518-2-gilad.reti@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e777]
X-ClientProxiedBy: MWHPR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:300:116::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:e777) by MWHPR07CA0010.namprd07.prod.outlook.com (2603:10b6:300:116::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 16:05:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81f4a268-f1d8-4c1b-2a3f-08d8b7dd0034
X-MS-TrafficTypeDiagnostic: BYAPR15MB3190:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB31909BF888D79A13412B4076D3A90@BYAPR15MB3190.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSp1Nwq1o9hsWksmH8mw/hQRo/szP1VL2kM86l1trVJpo1hM4xNav5dK8vFp/dRqJIz2D3UYsp/KuVNZT+BUmkFRoJe+YZgfowIQ3p9GMz8PoFmjTHSrzcM+qPiSrdA49aLAALWZz3D/w30co0tXO42+CmzNALu8WMnQNNIte6g+hrGyhwHnMB+/YRWEbxDDybyqMF310C5qgD1GPqxPHVkc6c9mUjCsCcReBV1562WHTGzcYKS40Ne9lJHS11WNrjGaFsRNKf3hy3jSXudnMu/ZCjsZu38EodebUimkdA39eOnIzg7X6E4eOPjd/s9ne48gRKDLp+Oaen5y+AJJLotVTNcRphJoQt4Z2CJj+5wJx70OOI5HU1MaoyL+YrB4zvYN3vDkdN+GVOvDhWICvoGB7RIoCxP982OXfajNCvzzUh/64VD/W16Q6W6VH7y2XR1v7dEEGGoUYqlDw80bS+kBlGeB+RmsyIQ8IJNgAVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(346002)(396003)(366004)(4326008)(5660300002)(16526019)(478600001)(31686004)(86362001)(36756003)(66946007)(186003)(4744005)(316002)(83380400001)(54906003)(6666004)(66476007)(2906002)(8936002)(6486002)(31696002)(8676002)(53546011)(2616005)(7416002)(52116002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d3Bnc0srcXFUV3pLM09ST0Q5MDhBRkJsdWtrNzNucG45a0tucUhMYjhidTVm?=
 =?utf-8?B?cU5WbHpVQktJNXpmZDJDUi81TDZRUm1UM09rQzFHNDIvWmV6ZWt3RHl3YVpC?=
 =?utf-8?B?VGZuRXNTRUVPbU40bXFqYzI2MlZtTHNsNTM4MXpyc1hqUmIwN0duRlZpNlVB?=
 =?utf-8?B?dFZtekxCOUJYMlpoMStHSVdHWGkra3RwSW1kVFlIdTBIaTE4c2tCQXI3WW5G?=
 =?utf-8?B?bXc2b3BJU2haV1NWMzY2NjM3ZmdCSDBzU0M5Z2Q1SXcyS0ZqWlh5aEhrZWw2?=
 =?utf-8?B?aGJxQVB5U2Z3UlBwYmxhblB6dis2SUZ6UTJwVXViZlhsYXNqVEtGamlGSERk?=
 =?utf-8?B?TUNjMXVOUTdoMHhDTTJOQXhzbDQwQndKNHF3VEJXejBoWUxpdGR4ckdsT2N6?=
 =?utf-8?B?Y2luMkdLQTJBQUJaY3ZwdzBnRkQ4djhDWmFVY3ZtSzV2UUZpVEFZSkVJbDFF?=
 =?utf-8?B?Mm1CRnJHSXo0LytKUjJKRUs5ZU5HOGNHMWxYTHUrcjRrNlFZbklLbm0ycnNC?=
 =?utf-8?B?d3pIb3FnYnQxZTB1eFBIVmhNK2JmNy9UVGpxTjFtQ0dSUWpVcnpEYVI4S2t5?=
 =?utf-8?B?Q2xiV25QQUZnbUlYY2NKK1JNdDRCWUNLRWd6STJNbjl3emNnMThrS05lRjhs?=
 =?utf-8?B?ZmpmaGYrSTRLdTgycFlmbzkrWlZUaHVzbUlwbWd0aXZRWUUzRDBmdjBHcXRo?=
 =?utf-8?B?UWhWbGkzTUZTcndyWmZTNUpRZXRFbzRyQVJMb21BaTFMZXlHSFp6RU40VlJt?=
 =?utf-8?B?Wmw1eVdCOWVJUDI4NEg1UU5kR09EcTl2RDhwcitiRFJocWNld2hmV2RWSnJy?=
 =?utf-8?B?YTJRQUlzbGJtVktoaGVwdzhTVFhZWjdxL2lvbjVnTFMzeENDSW9TUFZIWVdl?=
 =?utf-8?B?ek1ZOTZodTFTdnFvTzZiQmo1ek9IdXlXT2VFamhMNHNWM2NCTzZ3MHFWSFVt?=
 =?utf-8?B?NHQxWEoxU1hXRHYrL1ZsYndYRHBsekFreDljMTFBMFRhdVdNMDA4VThndks0?=
 =?utf-8?B?WFU3eURJc1NKd0JaZCtQbUZVcW5rRG5DVDBaZ2g0WEEyZ1lTRzI2V0tJVkxE?=
 =?utf-8?B?ODk0dk5hZVVvbnpvWE00NzcyZlNvaFQvNCtqOHhoYTlLK1EzUnlZVk1JL0x0?=
 =?utf-8?B?bWlyMjZOOXZsRlVjRjNDQ2MrcWtGRGFaUjgvbnpJUGY4bUE2ekR4UnhUbHAr?=
 =?utf-8?B?VHJJMmtRY0FKbDRTcTNmamdYeUcyUXM0NDBTbEdqL1A3bDZqVWtJNlFuQ2Zp?=
 =?utf-8?B?d1FzcEVqbGtFNEJQZktXdEZvdVlNZi9pSkRocGxlckx3b002d1E0SGpXbVVL?=
 =?utf-8?B?amlYaUVDd2FBMUpNY2xTNWdJU0tyQTZPR3FtZW5xYkxpVzBOQzdqVzNRSFk0?=
 =?utf-8?B?OUQwNmNUT2cySmc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 16:05:09.0770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f4a268-f1d8-4c1b-2a3f-08d8b7dd0034
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/Ytp9wWhei8oJwAnc56wfqKRZFI+jkfPHuWzN2Ce1YbddcwSlCbSsb4Xp+2sS57
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3190
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130096
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/12/21 9:38 PM, Gilad Reti wrote:
> Add a test to check that the verifier is able to recognize spilling of
> PTR_TO_MEM registers, by reserving a ringbuf buffer, forcing the spill
> of a pointer holding the buffer address to the stack, filling it back
> in from the stack and writing to the memory area pointed by it.
> 
> The patch was partially contributed by CyberArk Software, Inc.
> 
> Signed-off-by: Gilad Reti <gilad.reti@gmail.com>

I didn't verify result_unpriv = ACCEPT part. I think it is correct
by checking code.

Acked-by: Yonghong Song <yhs@fb.com>
