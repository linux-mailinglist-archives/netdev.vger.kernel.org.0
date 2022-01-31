Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3658F4A4D5F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350315AbiAaRhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:37:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18014 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245413AbiAaRhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 12:37:10 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20VGnOFk020421;
        Mon, 31 Jan 2022 09:36:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JR2e2Ippa0hkIvoREqUqPJJ8HSrKC62/GxIf3Ue0ZA0=;
 b=nyZNARVvFYSrzCFa3Z16Nd942MkoYAnNowrRDhCzd8qK7si1CKU+xAZtZe+uTTlFsLuX
 Jfjw6LtkebYS1awLFqc3xPP7/cC7tdzjVFfabG1n/T+3/z+MnNrpvvYiooN4YeovyIlE
 SM6i2Ej2RfeIWjJSvEOG+TwEoSsmsYNzk+s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dw472j5jn-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 31 Jan 2022 09:36:53 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 31 Jan 2022 09:36:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUh7O3+WXswatM5A28uhrU15HV/KBxCu2wxdrtzKueZVyqiOzP97oclaJVbyPFwKtlRUCnSZurO/RtK/m/26P4lCejVA9xjOkeA1kYwKNhUhOVOHmvt6fNYGkZ91Y6qInSqU4C6ArynlKYo8rre3x9aCuyY57JWiatzFMOB1zlaaZHkFNtvvQ5xCaR38rbf2ZmyJ4Ez99grrdXVBemnoz2IxaKqgFbKsixXngR7HXgthwBg9orX32jLJFXUBVKQtTJHSDfVlpZBee5OynC7h3S2XsWDQWBfc9GYAgRxKJ6vY20LjaKU5XgY1jmhCJnD90pBuAOH4i2FP2sOo3XtjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfq5lWwtR7MDWhpnYY+QjTm0xYcCP0Nfi9lpFEJ1Vnk=;
 b=FTDphT+vC26c17i+Hwg85ZHGePzMf1yQ+siA+MrQeVuBBzgN9FIHw2lY0yH6GDqM6eAJ6oJuHv2TKkSCFS5WcUEwwCriPUdrutrlKGb0MKQUgnEucDDBYj+drskFFfORkyBjWiLag5ShibWBmIsQ0um9uaR23GobrBH2kTMaD8osQ71dx80+TIq1QCgzyvhx3H3dfwuWCsp0X18DFPATypbYZ33fIgELD8GyOFSxHZL0ByAnIOIVwSDzB1yUgDMCwI3tZS9gUWeJ92HiM9Xd0QKgwh25N/c6/CzoCP0aQGS7/qu+6GUNYW4RMqeuO/QPoSPD8YStqG7ns6rAIzyXMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN2PR15MB3152.namprd15.prod.outlook.com (2603:10b6:208:f2::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.22; Mon, 31 Jan
 2022 17:36:48 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::11fa:b11a:12b5:a7f0%6]) with mapi id 15.20.4930.019; Mon, 31 Jan 2022
 17:36:48 +0000
Message-ID: <8d17226b-730f-5426-b1cc-99fe43483ed1@fb.com>
Date:   Mon, 31 Jan 2022 09:36:44 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: BTF compatibility issue across builds
Content-Language: en-US
To:     Shung-Hsi Yu <shung-hsi.yu@suse.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <YfK18x/XrYL4Vw8o@syu-laptop>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <YfK18x/XrYL4Vw8o@syu-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR20CA0020.namprd20.prod.outlook.com
 (2603:10b6:300:13d::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a6f7866-2eb2-4ef4-b066-08d9e4e04247
X-MS-TrafficTypeDiagnostic: MN2PR15MB3152:EE_
X-Microsoft-Antispam-PRVS: <MN2PR15MB3152940B32FA50A09576572FD3259@MN2PR15MB3152.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vl3eHkGCciLzTTm00k1mHmL3f2I/D0Qshcke8wjrxag2Xl7CVsc5FhzactWSoEqnWizqQVMvvyevxkXqrvbnhtJdXayzpzjfE67nnB61n2PP+AiKvpuXia0pNmgRPZmBRTw34zDt3YEh6kRqZ1lyfip7IbxJnZvCXgCciF7PreoJYSB6yTmg9yY32KKR085FmkaUaLJRRpktBvAdqZsM2O0aRTfPEnxUuCCaxq9+T/235v4/oKET9JEKCptwJ5+LHG18wIP1oiYIfoij90jSaODcJUW5WmafAHRaXXOKVfWW7vqqJHyQmx6osNiw8E8ZGgSnc4C6ZqsLV/lgKns4+WE4wR3QWymIdQxYRg2jvXjN+XHIlMR/SQyjmvjhaV3fJw3yGW4i5hd4dReX+NiNf7KpQ9KtD1BPzirGoux7qXxGesKXPq32lAFczti0X8VmqEBU8Cd8PikACQsgh8C2miAZrNVaqvHh3FbrAGoucBjMIRdsDx2GCELTsnbbVo21fiqn+iUIK/EO7guOQVTwPOqHbkCzQb8bU6lShfukNNvABUd3fs/sdrvRKl3GqWEHPLa40PglwxuESO0NJRr4UVq0u4svorChrWnt1RfE67RRvfgi+9AdsxrLJW1L9R61cNpI8J0XC677Yuq5HDFCsiParOWNqI2s3q/n+1UgvXQsoBx0tCcXBHB/yL9AKU6mKuaAAU2UVPoIsy85PkqtXmd1XfZiZ/7/VkkKzV0vv2tpTnnakn7MUb29AaBK+nIdaSPcd9oLBrVyCIOmY99r8sA9p1sZ4EF+t7dK0ch9KSzHLFd2AEJVEuqp4NCn5kO4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66556008)(83380400001)(31696002)(8936002)(66946007)(2616005)(186003)(31686004)(5660300002)(36756003)(4326008)(966005)(6512007)(6486002)(6506007)(508600001)(53546011)(52116002)(6666004)(316002)(8676002)(54906003)(110136005)(38100700002)(86362001)(2906002)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGZMcHBwQUd4SVdYaTZCc2NPUzFUWWhZOXQ2Q0tFMnNZK1k3TW53Zi9UaG1B?=
 =?utf-8?B?aE40cWJkR3lEeVRVWExnQ2k5emxCU3pVTXlOdHNZZUErb2o2Y1dZZWgrSUlS?=
 =?utf-8?B?cTVaRmdmZXRhenRybFV6djVaSGNqclNkeFJCd0FEVHVubjkyY1Yrb0FJc3h5?=
 =?utf-8?B?NVhoKzN5YVNLR3Z3MGZ6citTd1YvYTl0WGpBZEZxNmgrN0pyQlJpL3N5clFo?=
 =?utf-8?B?WjcvbzFEVy9ZY01vWlhzeFFkVVQ4MGFjcVZSeVhGNnFSdUZSNkhxMDVzbEEy?=
 =?utf-8?B?aGlxb0hncmYxczhqaDdnaDRnNVlEZ2t5cjduaVdlZXB3WWd3V1VHM3F6blli?=
 =?utf-8?B?UWZsa0VLU1Y0RzZMNVRHMjE3V2RhbThHWk1hb0h3S0JqUUNUQ2hLeTFHdWo0?=
 =?utf-8?B?RVQwZWtmVzVsWHlnQWtMYzhsYkxCVXNzd3lLTndweFFYUlBtL2RVZno3RXhV?=
 =?utf-8?B?RHI4Tm5CMlowdmkxY1VOc2F5TjRhT3FCdGFTUWFTc3psb2ZNcFAraWNkSUFz?=
 =?utf-8?B?NFpQVkdzQ3J3VWNxZm5pRi9kLzVjc2UrOFFhK2tZVk1DYk85c2xOa1A5Y0lO?=
 =?utf-8?B?VGtIVGxyT01xdE5zNVVJTysyZldlR3ZhSkwwV1lRRE1oTmV1eU5HV04vcnp5?=
 =?utf-8?B?UU5qWG4zSkZaaGVjcDhicm14UkFuVW00L0ZEdERRdGN1eDdXVnk2SVd4dy9B?=
 =?utf-8?B?bStONFQxelNKVTZLRlJqeEJuT2lncHdoR3ZvUURNQTVtSzlJd2N1dXJRb214?=
 =?utf-8?B?a0ZxRVZ5Y1JLTURobDRPSDhuYnJObGE5UWtRMTl1WGhCbjNYRk5velk4am9S?=
 =?utf-8?B?WmczOWd0eTlENk4vaktXeVpQZ1dSdVcwc3Z2ZXJqbWxZWC8rUDRtQ21LK0g3?=
 =?utf-8?B?emtVYjBFRjR6UGFLL21pS3RNam43aVpqeHZUWlNFdUttck1QNHZNRkZxMW1M?=
 =?utf-8?B?cERnM3hqWmZ0azNJTzRadHFyZVMzLzJBa1lzVmdYaHNNLzhZbnpoZ05STzk0?=
 =?utf-8?B?TmN4RERJTHNwdkNneTZvQ0xwcU9FeVlzU1pMZU1QOXZzMmcxWDhCVW5RaVJS?=
 =?utf-8?B?MjM5MG42bjZMTFBsTTFUbU5rQVRzRHVDVGJDOXJXYTR2YXlSUU5MZWJ2ek8r?=
 =?utf-8?B?dXZBY0h2VzlKdDl2VVk2bjFNaDdvcVR5QkY4WFpMVlpGcGNRVk1SNFZxSWM3?=
 =?utf-8?B?TEVJSTZMZCtOd3ZiU3JoMU8vN3JxMitXWVUvd1FSMi9OTnpKZ2p4eXJkS09S?=
 =?utf-8?B?RmpjUFlISDFiZzgveXJUdGFvSTViLy93Q05jNjJRMGQvL2NjeXg4azFWSzky?=
 =?utf-8?B?ckNMUWtpV09KK3gzbU1PeEJWY3pjZDBUdzk4d2ptTmh5RjZsVUF6Wk1QMm5i?=
 =?utf-8?B?RXN3M1Jack1NTzN4VWZkNmJjSHN2RWxibjNTOG84WUFRdC9FY050UHpxOS9a?=
 =?utf-8?B?OVRnTWJjeEdPUCsrRmFCdElYODB0VXM4clVRQ2kwMi9kT1JZbkFJdFdQY3pK?=
 =?utf-8?B?cXhKT2JyV0tETk55YmFUdkZwV1BxWEFOTUlubnBXUCt1VE4wOWxKQTlMS2pk?=
 =?utf-8?B?bEZXbm9xMHJna0VCZEg2aGgySmp1T09CRnpPalpBZzBDay92Z2RsTm83eWVZ?=
 =?utf-8?B?MW15azBkRTFtZDh6TlVVZFFSS0ZGZlg3bkhMaW1hWHBUOVFreGNldmdOay82?=
 =?utf-8?B?N0lsVHVBVTBKNGR4MWlvRVRhY09IaFd1TzlCMUtYc3Izd2p3NEdidWQzc2Nu?=
 =?utf-8?B?U00wclNwakZ1MmcxWkN2UW4xb21RZ0JteFU0SEZXT3IrRm1mK1RkcWFWVGlE?=
 =?utf-8?B?cFJocUNncHl2d1ZlNjRVeWxlRHBsR1o3dXR5MWlxaVYzR0ZwZzhyNTVpcnVo?=
 =?utf-8?B?eEo2dmEwVzdvdW0yWmpoMzVKWWlOOHZwMDlYbGIvSno2SlBIeGJHdVJ1NGFh?=
 =?utf-8?B?SmJZV2VEN0hKR3R6WVY1RFM1djJZdEVmVFIwdmplUWlJQk1UYWl2QWVSWnhL?=
 =?utf-8?B?djZFaFc0TVJsOEdWa3ZsOXNTUjZ4MGFWZ3pmaElEYVdrL2VBdFgrejZXd3JG?=
 =?utf-8?B?UHZqZE1DanVZLzNiNGVocDJDck9aT2ZheUVOVE1ldWQrOVM0eFp4Y2Y4K1Y0?=
 =?utf-8?Q?yLFxq0S4z2kN50U9xTYLq5Ip/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6f7866-2eb2-4ef4-b066-08d9e4e04247
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2022 17:36:48.7156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Ybn83vlzPHd8nZmCw3WTCAL6nZZcvA/HBDtkHvBeb9p1cXQrF21oFU1I6VxhCAq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3152
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: JpG7TIH_HNDrA21yjaBDnKRRY0gST7Wt
X-Proofpoint-ORIG-GUID: JpG7TIH_HNDrA21yjaBDnKRRY0gST7Wt
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_07,2022-01-31_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=999 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201310114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/22 7:10 AM, Shung-Hsi Yu wrote:
> Hi,
> 
> We recently run into module load failure related to split BTF on openSUSE
> Tumbleweed[1], which I believe is something that may also happen on other
> rolling distros.
> 
> The error looks like the follow (though failure is not limited to ipheth)
> 
>      BPF:[103111] STRUCT BPF:size=152 vlen=2 BPF: BPF:Invalid name BPF:
> 
>      failed to validate module [ipheth] BTF: -22
> 
> The error comes down to trying to load BTF of *kernel modules from a
> different build* than the runtime kernel (but the source is the same), where
> the base BTF of the two build is different.
> 
> While it may be too far stretched to call this a bug, solving this might
> make BTF adoption easier. I'd natively think that we could further split
> base BTF into two part to avoid this issue, where .BTF only contain exported
> types, and the other (still residing in vmlinux) holds the unexported types.

What is the exported types? The types used by export symbols?
This for sure will increase btf handling complexity.

> 
> Does that sound like something reasonable to work on?
> 
> 
> ## Root case (in case anyone is interested in a verbose version)
> 
> On openSUSE Tumbleweed there can be several builds of the same source. Since
> the source is the same, the binaries are simply replaced when a package with
> a larger build number is installed during upgrade.
> 
> In our case, a rebuild is triggered[2], and resulted in changes in base BTF.
> More precisely, the BTF_KIND_FUNC{,_PROTO} of i2c_smbus_check_pec(u8 cpec,
> struct i2c_msg *msg) and inet_lhash2_bucket_sk(struct inet_hashinfo *h,
> struct sock *sk) was added to the base BTF of 5.15.12-1.3. Those functions
> are previously missing in base BTF of 5.15.12-1.1.

As stated in [2] below, I think we should understand why rebuild is 
triggered. If the rebuild for vmlinux is triggered, why the modules 
cannot be rebuild at the same time?

> 
> The addition of entries in BTF type and string table caused extra offset of
> type IDs and string position in the base BTF, and as such the same type ID
> may refers to a totally different type, and as does name_off of types.
> 
> When users on build#1 (ie 5.15.12-1.1) installs build#3 (ie 5.15.12-1.3),
> and then tries to load kernel module, they will be loading build#3 module on
> build#1 kernel; and with base BTF of the two builds different, name_off of
> some types will end up pointing at invalid string, and the kernel bails out.
> 
> 
> Best,
> Shung-Hsi Yu
> 
> 1: https://bugzilla.opensuse.org/show_bug.cgi?id=1194501
> 2: my guess is rebuild is trigger due to compiler toolchain update, but I
>     wasn't able to pin down exactly what changed
> 
