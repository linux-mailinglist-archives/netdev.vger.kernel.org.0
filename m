Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853A02BB11D
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgKTQ6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:58:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728729AbgKTQ6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 11:58:24 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKGw4la021760;
        Fri, 20 Nov 2020 08:58:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XSMUjnh6ac7r4mLkasnDWq8D8WNdQPmGQfA8RlqNqJM=;
 b=BAbVh7wnIntAV0SpJhaKQjVV2eHgoAirT/Iy4g60Q29q1YqoRq+ts0W2e+30zu4oezoR
 KcxnSIW40iuybHB53NGZnQoBD1tdmUKNpSPH0P2WJzHcfDB5XSvCbdIlDGPJP0IYu07+
 eFTXg66ueRjEq6d5tGTvsrx8o3ZJERpXdyM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wtheytts-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 08:58:09 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 08:58:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mV0DxOUJCGkfiOz4gNTnzTfDNyL6I5mfBfMS/Ua+lQOPPM6GIIACR9I+l2d32AaZ6AZDjt3h82o7GdN9kJQexMbresppuSN+ABKcD8XIz2lKgUNXS7mCepe8iLD5roaQaPt53tGkEUdeLwYV3EG3bfoeaSXkfwSbXv9dQRMVJMJu/MNqMhPzbfrMAnFd+N3XEOsaPVSL5mRBuLqA9Br3k9bJoNGuhW/hgatjIcpsxHEOCPlZbe6Me3wNj1mBhPwLCiW6TEw5DfAEkNzCrgO1zCrcFRiL8kIY9afKi3LysccLol6xGZVT+g3MmHSsfv/dUGzK0wqPJRIN+bY/FNo59Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSMUjnh6ac7r4mLkasnDWq8D8WNdQPmGQfA8RlqNqJM=;
 b=CwueHQMub0rwz3l2h/ab4Vvk+wgPnqsBB4fgBAvAmZLNlQtAw7sVBHVPSCPTwwRevTLazctkI6eF0nRPxMBjQzvl+qf73mUgk6CYpVbCwiSgBjJXY0zFt9juLh7ho3gYKmxHGN2kyhsgPsLI5nsWNYlEyQwRvBz2c/8YnkOwhaeQmhwUPJMcfpyG0RwBOjUAMWA8SAaoTxfvnDQsl0TyR9/UD9f7ry+mcYsQxU8O9kouWrYJZOYNrKvcBKgfxMZaJ4mD/4Lp57GLnnihfY4MkvCxU6mwjgSx0cjcCitv7wD45SGmrPOR5QZ7/MI2AkLYhft1Tz0NGrHGL13lJyJ6Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSMUjnh6ac7r4mLkasnDWq8D8WNdQPmGQfA8RlqNqJM=;
 b=PP6HSbwMbDZ6zoDIj2wcNvPgaJz5FJwSCKPqDw+aXF2dvHggtuZdNT0lZUVdP4cIQ6tLmfXgqCEc39a+t+mOlAJ8MQ8aMQenjF0GOU11eNOEVZ0yGAM/P5pS4nqU0H/vyHR8al8cutc/m/aMPCHsdYFBhuI1PfukylJZKgQfgRY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3620.namprd15.prod.outlook.com (2603:10b6:a03:1f8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 16:57:58 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%6]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 16:57:58 +0000
Subject: Re: [PATCH bpf-next] bpf: simplify task_file_seq_get_next()
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kpsingh@chromium.org>,
        <john.fastabend@gmail.com>
References: <20201120002833.2481110-1-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1c8b7242-7236-b3ce-a0f2-c2fe651ab079@fb.com>
Date:   Fri, 20 Nov 2020 08:57:55 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
In-Reply-To: <20201120002833.2481110-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:f0a]
X-ClientProxiedBy: CO2PR06CA0054.namprd06.prod.outlook.com
 (2603:10b6:104:3::12) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1688] (2620:10d:c090:400::5:f0a) by CO2PR06CA0054.namprd06.prod.outlook.com (2603:10b6:104:3::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 16:57:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cda08d6a-53b7-4a60-1e23-08d88d756ebe
X-MS-TrafficTypeDiagnostic: BY5PR15MB3620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3620525C7854800FD6275EDDD3FF0@BY5PR15MB3620.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FmAh/0zlPhgjNQ/iD4VUiBXgyaU/5sffMwKNgQveYiRb0LwoVRPo7imGKfA4WTSAdnQkwWLecGC6jo7UeYcJmdLnaLlNFBJEbFFej70a68rjdoNXts/vGo2w8nOIN36OXH0ksfA4RMyt+BKnGMmLDje6IzsqvzDRS6IYITobSW0pMoypMtg9n0bSBoJwD2pl7TWqxPcW3HaIKormzMB3YcikEEoM4F0c6PFo3c6XIyXrNxqE+uHGjsXtVbf9zPAsQO8pverKHxcngAGo9EtMjHzaAmfiXvn3ADKG15QkoF4y7hetWari2/nJ+70VovNucU4nJt2sHh0coiVKuH0dL6GxTez6ht8JI5hpX6NFjSpQ6bBHx9h/z1hRwvwdgB8c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(136003)(39860400002)(396003)(8936002)(2906002)(36756003)(31686004)(53546011)(8676002)(4744005)(52116002)(5660300002)(86362001)(66476007)(66556008)(66946007)(31696002)(16526019)(186003)(316002)(6486002)(478600001)(4326008)(83380400001)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8ps8dljKV+CIWCmUDIwprwRPPvhFhzr/PvUgnjP9swrhKxIlsChzklO0cYIYzFb06eZNf9YQ/sWqvO3J1TIOv19/DOym4pCuU9MlpfAT1JiMqfmtuUcy0hyT0M1DuldvuCLC5u6Lqggh/pWUhDyT5OSkEvW5fm2DPTa2GO88YVKmGOnz7PQLvvctkwZqgIJx7KB+Og6B1ZmqgZjbDly9Xy6z7c46nPHT65y4hJfcH5mV9DmafJdr6bPWELXsHU2Wt+Hv+W+JovQYgRFbNQlyHObxs5Wy3k9/BChhzwyqNLuQHNSGxLvwANXDoqlV2a3PByYOqX0kaEZj9dvnXK/2Lspj9IqwSNwS3oTMIoL5DUG1wHDY1Tnx95DU4XIddGBsmeoCwg5Pl+ZA7+/gdbmlXX6sPl4KRRT7/AxKBjwvPWr1oU4iwQ2WmwMrZoLO4btbSDX9JcT7GMunUD7j75JwtVtKLdzyGOWUS2Ylhy/WE6xNEvTyzgIcDtgG/uznaK6xCugvO+w5xexpgEI8R5lkmcVYy7XBGMyonJz394PAfzpVC0xKMCLsm8Yu/2EDr0bRmY0ibzvEE7KLY0pKAcsKi5E5Dp8UFiZHaWl1xNW4VXCUz60/qnHzCuBiZjDxmc7OB1b8nXoeSyzNN7c7lVQYpmvCYUefJSu9iGDaZ/X24UJG9KQJkB7gxerTfmR1f1NRwwnkRUodDjvZe6saX0ZvOU34BPzg+CmPYTPg485U16/U/Q3pskYhZ+lUjHkjEkZNt0YrqFEPOmwYrGlgI1zaMk67BRJQbq9HKur0rvWWi7TAd+0y0tDhiW2SnGtld1Y3SS8SmZ4MV7HHotRxVFKL/r3399BWBVTq2fzWeuLjTaheyA+uA/XAkIC/S7TYcjffn9uMTK6JqOprkAMak1lJJAiSoRi+RbogHPO2AswH4tg=
X-MS-Exchange-CrossTenant-Network-Message-Id: cda08d6a-53b7-4a60-1e23-08d88d756ebe
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 16:57:58.5916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/WuYSGi3+LT9+JaYjXlNvRC4p4yJZ33KGEuxlhKkt8hyFfPpjSI2sSWmoKIkWke
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_09:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 adultscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/20 4:28 PM, Song Liu wrote:
> Simplify task_file_seq_get_next() by removing two in/out arguments: task
> and fstruct. Use info->task and info->files instead.
> 
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Thanks for the refactor. The new code is shorter and cleaner.

Acked-by: Yonghong Song <yhs@fb.com>

> ---
>   kernel/bpf/task_iter.c | 53 ++++++++++++++----------------------------
>   1 file changed, 17 insertions(+), 36 deletions(-)
