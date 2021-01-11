Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEC92F0BB5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 05:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbhAKEGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 23:06:05 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725824AbhAKEGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 23:06:04 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B3tfvG001385;
        Sun, 10 Jan 2021 20:05:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1ndZnKKcXOZP7HKVchjqEhMvXAalo/YrcQOXedJbgn0=;
 b=HJFaKf7qha59zIoE2dEYeB4DZ5rtyxfeQQWwglhnkeprIYdsXy/f43BVWwCZQAqBYH3s
 sweBG+LsPzgeWnk1errFKsCkkbk8BLZwvOZW7c+nRj0abKGoPcRd1us338ULfMcqWgzh
 VrspR2STcuA+ymk+lGL952DNG60FDLCCBi0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw1pasyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 20:05:07 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 20:05:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2CsWd7wj1WVeRNhqLDCRPo9bPPsFCMXwbQgiaPEcL/84ArlnLxSR/LuWLNREo4J+c/ct5WB/An9jxDbRU41yN39b6VOEq7Hw6ixdUp6A0KfFwGxMLgnh0OyX8LREakV/Kwy2MpBaRm0U+YBBvGrVCCDEShhA9LqhReU1he47+7kBTbbROKSr3Igtzm3XN6qLIRq9OpLheBORu9Tj0UOKqg4hQDD80vYOxcyNXyVnP0JuP5eeafViszNcqh9sC92ZBLahhGIhA4reJXxirzxjrJENMmV+WTMZLXOZ7ylvZyKVMuLC0y0T00/pAlS1Oqiv6dD1slGtGU5bXX0ohpyDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ndZnKKcXOZP7HKVchjqEhMvXAalo/YrcQOXedJbgn0=;
 b=ZbcTWt1HegTtNMgml7aI2uET1SFSBUUGaBVChogQhiJ+rqrLR5Yvx8E8nm+K2GW6Co/Um1r8QGWqAvqHzJMeCoF1V8njnLIHVfGkMlEpHOuw4Bc8tKAodbu6kQacFeKjQvNSLfXfaIbE3eXgUHuFTrmtaG/E+dZrC7GtM5LlVRUFYBovfY6IHkG9BYe5j71FRnj4FtalPyBcA6Un8aePWQHo9nollqDN8H5sXgntuOAE6R5juIBWHS1HInjOcVTDz1080ktAUREzh1UsCrXxY8qlHVctAhSsWe5z8pQM7xZqnSJSzkBYWa6Ty+mqtjoCwVzMExsMPo0DHaxqElEpgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ndZnKKcXOZP7HKVchjqEhMvXAalo/YrcQOXedJbgn0=;
 b=T9mjobRd4DJe+zFKPrdGToefs08RpBZWtdikZUB+x7JqQo69sLRQVKxc92YQsMcGLK8XhODFMLliAE9OAKUpFJZsYZArLMtsjcuw5dr4uqitsWm3KC+BVrJ1wKuwfFbhYY1aZW41czu02qf7YR9DezTRvjAEvCbqq1M3DfCRcOc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3415.namprd15.prod.outlook.com (2603:10b6:a03:112::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 04:05:05 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 04:05:05 +0000
Subject: Re: [PATCH v2 bpf-next 4/7] selftests/bpf: sync RCU before unloading
 bpf_testmod
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>, Hao Luo <haoluo@google.com>,
        Alexei Starovoitov <ast@kernel.org>
References: <20210108220930.482456-1-andrii@kernel.org>
 <20210108220930.482456-5-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2e7a9040-6b16-bb9f-0cab-73161899e1f1@fb.com>
Date:   Sun, 10 Jan 2021 20:05:04 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108220930.482456-5-andrii@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:b212]
X-ClientProxiedBy: SJ0PR03CA0195.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::20) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:b212) by SJ0PR03CA0195.namprd03.prod.outlook.com (2603:10b6:a03:2ef::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 04:05:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3294d1ac-4941-4f20-b3a0-08d8b5e613fe
X-MS-TrafficTypeDiagnostic: BYAPR15MB3415:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3415DCA7CC673F3CE5F7798DD3AB0@BYAPR15MB3415.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HaCN+4olVgM7x5/uappKmPEGSt/pGFE9O5Sy/M1hfuT5kQ9s0PpI5BB10B610aWjhsAn1oIV78/C5D9z2fIt3efJQ/QAZWz8kf1ZKlcJ33O1BIbneAHxAka3KI+qe71MatY6MMTmSYM+d4SDO7ThRadX3EziWX08pPYUvTd8FwBN+aoC8NYPjeR+SBI7yWjsSC/JOL8T3Vk1wdR2/e/ThFhJlaUUzOzTb9Q8RMzw84mOrOwy+JiNk4vnsAz+CF7w6eb9PLj33qG7QCl4t7Rwqc5duU1TD3dNiRCdPmGOChVpxmB81eRvtXwsl3y0HRTt+qNZkJiqRSX8+V1pJDQ8Xk5Cw3L5w/Lquaegf3XTeKVF7Ncxza/NbYMoM2xM1d1vVP8ERBEy3Xdnl9SuoSHdQkZWKOP8BAvDIWAUXukq5pM8EvSPHm6CwG5830hQ6s0N4pA3OzhmeqK1XF3j+g/PSp12vY6BEWeqKgrAU7v43I0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39860400002)(66476007)(31686004)(66556008)(8936002)(66946007)(2616005)(36756003)(4326008)(31696002)(4744005)(8676002)(6486002)(5660300002)(316002)(54906003)(2906002)(186003)(16526019)(478600001)(52116002)(86362001)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NEdScEZoUHFscXp4ZDM3MWdNMWg4Vlk0Z09IamdXQUZtWEJzWDVHUVBmUHph?=
 =?utf-8?B?SjNmbWlvM0xBZG5EZ1E0WDJIR1BCWVhkM0JQTHJ0c1RzTnUzS3RGb0JYZFRQ?=
 =?utf-8?B?NCtINWZ3Mmc4aDhlUDJZVHVSL0s5UzdSdXhNT3NiNnVTeCtJeUs4NUVFemhT?=
 =?utf-8?B?MHB0ZXUxdFdMSkptZGttd08vWFpXWGRIdTNLUmNKL3ZUd0w3R1hvTUh6YmZJ?=
 =?utf-8?B?S3l3OTZoTldLQkJiVUhvVm1YRVhDUGtndGVVanM5aEx0TXR3YzZTUHdtZERE?=
 =?utf-8?B?b3R5R2VXV0xWb29iTUxXRUhMU0NvTitaZExLZXB6VU81NzVCQUhRY2lwb0hY?=
 =?utf-8?B?YTJEcU5qZHJGeTFaMmFSY1dzZzltVnk1YjFBSkhrT3FEaXdzajJaekFhT3pR?=
 =?utf-8?B?SEtGMzhkNksvVHNkaUlIc2dnTm5QNVZNbjNUNjNVQTd1YVJVS1BTU2tzWUNy?=
 =?utf-8?B?dzl2cjBaUDJaWjQrNmYrSzFCZzB5dis4bnBMTFNLQnZBaldHM3hjOUQ5MVdN?=
 =?utf-8?B?TmhTME1nelVmU3gwRWtGREwwaWxBSDdGa2dJVHRtS3N4Vmx6K1AyV1RIWEow?=
 =?utf-8?B?QWtabVBZNnJ3T0NWUkIrUkpSOUZxbHFJeFh5WERZMmtuRk1jWENhVFVVeUVy?=
 =?utf-8?B?YVorZDFGOGlyY011RU1zRE1NdmRWbHQ5cm5LZEZPZ01MVVZkYWI5Mm5yWFBX?=
 =?utf-8?B?cGUwbTMrNzQ0TGhlbnNTMXcyWUoxb0J4TTVDcmVYUTI2VEQyTWcxSjdxSmN1?=
 =?utf-8?B?L2VwOUdZNDBQN0pYa2VFQnNxOTM5dnkrMHBFbUtUUEM4bm8rUjY0RDZFdXZw?=
 =?utf-8?B?UXVJVjE5Z05lNW5ESFRxTUdRQkx5MnFNeFF4SXBwOTI4WXo1cmxOOUZSV29o?=
 =?utf-8?B?Rjk5emc1VDNNQmU2REpxa2g4WjN5Q1JmK3prbUh5UWthTWNwdExNcHR0UUVn?=
 =?utf-8?B?S2ZrS01SVWFyOEw4UFFWQkVuMEhCdEt3Z3ZjZ2NrZ3NpQXZBMUhoaUZYZXNy?=
 =?utf-8?B?V0RxSHVPcXJ0eXlMd3E5N0hkNy94Kzk0Rzh6eWNtREE1NzZCT3N2c2ViODFK?=
 =?utf-8?B?ZTBwY3JDS25qSTRrWEkrNFBxbDQrV3hSM2NNVWJVYW4vN1k1dkM5N2V5d2FN?=
 =?utf-8?B?cm5WZEtlWGJSalAreUJkZC85WktpejNEUVdtQms4dHNOcXVPME1meFJ5RnhW?=
 =?utf-8?B?NTUwcmRWWEZuc08vcis1NXBSZEFXQzhDM1pPUmVIWEYwa2grdVVTd28rWkRn?=
 =?utf-8?B?dU1haUJiZUc1WGcxSGNXa1Y5c3dFcVhmbnJlVmFXTmpyeFYwbDZ0ZDJLQ2VN?=
 =?utf-8?B?b0JYMnRTSEsyVlpBd1pjREE1R2NJVUxqYkV1MHZjUDl0WVAxQUJYb1BtOHFP?=
 =?utf-8?B?d01KdUVxc3NST3c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 04:05:05.5250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 3294d1ac-4941-4f20-b3a0-08d8b5e613fe
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZLNgngcKYR0sEB6pwmIHEmPMCov5oRTAdrmzBMH8A/C6f9uGqfRNv0N5Yr7O/cP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3415
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 2:09 PM, Andrii Nakryiko wrote:
> If some of the subtests use module BTFs through ksyms, they will cause
> bpf_prog to take a refcount on bpf_testmod module, which will prevent it from
> successfully unloading. Module's refcnt is decremented when bpf_prog is freed,
> which generally happens in RCU callback. So we need to trigger
> syncronize_rcu() in the kernel, which can be achieved nicely with
> membarrier(MEMBARRIER_CMD_GLOBAL) syscall. So do that in kernel_sync_rcu() and
> make it available to other test inside the test_progs. This synchronize_rcu()
> is called before attempting to unload bpf_testmod.
> 
> Fixes: 9f7fa225894c ("selftests/bpf: Add bpf_testmod kernel module for testing")
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
