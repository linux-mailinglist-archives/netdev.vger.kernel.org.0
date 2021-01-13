Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9BA32F4F90
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbhAMQHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:07:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726110AbhAMQHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:07:53 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10DG3QrQ010708;
        Wed, 13 Jan 2021 08:06:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DIiceqYDML+OZZdgEDt9022/VUGobr9S0GbCjnBd1K8=;
 b=oA7rPouW8vHqPFHuPw6n9VojfVpalbJPKEhqnc0Cn/Xu80iSRC66xL7xVVKGem1TPQEm
 ayFc1uKRDUEzN7poiGFo4YsuwKQBMczd1hREgbZ0YQiz4IrrMfCHON9pcUqspOasX82H
 pCkUEHPFT1INH1/JksN6JWBl4nIPpz5WVhk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 361fp3nua2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 Jan 2021 08:06:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 08:06:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzOAk0OX+GsGa6skjPBZR2L5T6TuYlM9rsJ9be6+ue7z9CaH99Jvuhuac8VoLP+tO7cyyml2Hyar5KBVgKLZAHhF7XvYiNVQ6v0SGRzDCCr86j9aazpBP4GQRvx5IYMf1+cJa7pEQjMQl7aBuPzRZsz0XSnK772LI4x7Y4FFtHa9ETpuoKLgqnaAFmQrFBI7Mp0g5ufEGhaxSlZFJp/T7NP7dUJECpyTWVKLuT1ls6U1/mik9pOWvcB+LXs0fgNmZEqPewlZ1segPOXvmFcnUEHhUcoz7N/WbEZH63NtYVfRok/OhIekYAXn/JaOdRthld3OPrPhVs0BBZUTDU04rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIiceqYDML+OZZdgEDt9022/VUGobr9S0GbCjnBd1K8=;
 b=JuphJ67V8mP0jYYUiyaAb+OSNV4/9jakPGMBs84ZBJoeYhVvrfdTX2+eHdwKELDCvY5cWZ40r593H3qK1MQFBZmMIgrSrUw5btCQElj5JHrs+AOVtJt/B2ADnXgkwjC01vHse+KUd9TEP7bJUfkOCmb/4dq227BwtIlHEGMI5zSBohGuIvkl4TnWo55Pts4pVhWqObrtu099v5Nf+/+swIobgYTIoc8b4XGwuUVWv0SPmI9zODH1FY3DW6FtX2yjuFH8SqD1vaBp8ZUQWTn5xSDavieaxuD50lEUOn8xnMNP/Mu4H5Rz5zHX8cS5u5G8X7qWBIYLGtGRN6Joz+E1tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIiceqYDML+OZZdgEDt9022/VUGobr9S0GbCjnBd1K8=;
 b=GFx4fdcY3XlpKRdbOTyGLgtFvEoro2VKfLPqcSfv7Perb3f+YG2Nn1eVm0VMIIzCbspBQnVOAIW05bxVw20MYbjuYB0tXJZ1+ha7vuR6+t3bhqyntjkgrZTRMeeLlT+vLv3zDZeTGIhYEWoc/76IrFsiNMjWIeO8GGO0SWtr1ZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Wed, 13 Jan
 2021 16:06:07 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 16:06:07 +0000
Subject: Re: [PATCH bpf-next 1/2] trace: bpf: Allow bpf to attach to bare
 tracepoints
To:     Qais Yousef <qais.yousef@arm.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20210111182027.1448538-1-qais.yousef@arm.com>
 <20210111182027.1448538-2-qais.yousef@arm.com>
 <8ef6c8e8-c462-a780-b1ab-b7f2e4fa9836@fb.com>
 <20210113101606.lpsn4scnsecdfxwr@e107158-lin>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <98738d92-7679-5ed2-71c8-1ba71d7cac6e@fb.com>
Date:   Wed, 13 Jan 2021 08:06:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <20210113101606.lpsn4scnsecdfxwr@e107158-lin>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e777]
X-ClientProxiedBy: MWHPR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:300:116::23) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::13f6] (2620:10d:c090:400::5:e777) by MWHPR07CA0013.namprd07.prod.outlook.com (2603:10b6:300:116::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 16:06:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24b5c8f2-483f-4d2a-76fd-08d8b7dd2307
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-Microsoft-Antispam-PRVS: <BYAPR15MB258284388293C733E4BAE3AAD3A90@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ehn6wTe/tGQUSbvnLfiUa7CBl9vmCvLLqALPODvHBrzLWD5N454D4SW3BQSJGJV/OdykPpardgfIL2agO8pItgqypqeo7ambFuxFr6+O8PDiKhbXtQ75SfWksARTRfBzczT/CM7nodnP6BRPr2P8sJmJx/LqFGCTdjhA+KcMnGhYqPMJXavB9NVrwVHKIAO91puN973Oj/raVjbTkJ5znPDTpsKzFyd4NZVrZMMOhgqSz7UiA/2RV4yylJ9USIV8WCXjwLRDnL/sNpk7zkFiY6nzl1Q69/rhLTb7V75BLRxwZDwkuRNznE8KBSzCq1iv5F3Hm4amY0hkdb7dLKyPYJS0I8UQDnUMfVxf0nj9raTMbBJ4xRCwLHpFwtblmmHccS8MP/lut1/GIKvqH6bn/wFdE0wXVmnmxFrqhQIAbOJbzWpy4ApY05NYsFPYeLb4duIP3aGmLaVid0TEXvbkW2UCTRBi4h3Y/ZGAfT4Kvxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(36756003)(6486002)(31686004)(54906003)(2616005)(5660300002)(52116002)(31696002)(8936002)(8676002)(316002)(86362001)(66556008)(4744005)(66946007)(16526019)(186003)(66476007)(53546011)(2906002)(83380400001)(4326008)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M0RISEpCYzdoTWx0bUVoVkdsZzdEZzRtejZUNTdXOWZOL0NrTFM2K2drMzl6?=
 =?utf-8?B?bU5JT21PTFFLM1lmNGNDNmtIa25NdWNwWnJyMUtZb2tIOWMwT1E2V1VMUnNT?=
 =?utf-8?B?SndqTXBrTjNUMmRoT1oyLzJVUXBmN0ZkazU5cDJJN0pzb0s5aG1rRWZNK1Yz?=
 =?utf-8?B?MDRtUWVreXFUOXdrTmd6d2g2RGp5THpFeHVqWGFvRzlJbGtqbVRXR0o1c0hn?=
 =?utf-8?B?V0pwYzRSRFpYZVJWWDJEL1Y2Z1ZNTjQzNzJpNlVjaXJoODFuWkczbjdaWC82?=
 =?utf-8?B?S1BtYmxYaTRrMXRXRFd5eC9SNi95bmNvM09OOHd4c2NMY05vRVI1Y3prS2FQ?=
 =?utf-8?B?ZnIvYUF2VFZlbi9ENHI5WExJTzErc09yQzJvaFhPcVpVWnhoaVJkcjFacHdC?=
 =?utf-8?B?WDZFcVN0d2pCeXZ1VDFHTFhGY2ZIbGxmK3h1UTNQMHVjOGVYV291RkZLd0h4?=
 =?utf-8?B?K1lsVGt3eGVpTVJCNlc3RlBXYUdPNnFxSWliaUtSd3dKK0ZRSHo5WkUzSGRi?=
 =?utf-8?B?YlJxMjBBNk9SNGdreDdmTWJrSmRpSG9Nc0dpdmpYWTlyL256bUFtWFZaWkI1?=
 =?utf-8?B?RHNLZUVXT2c5b3VmTkppTC9BTW9tUDIraUNnMGVhT0FuUml0UGdselYwMm9v?=
 =?utf-8?B?MFdxcGlrYUYrY3VTOElSODJWS3dVQlZ5ME53QzV0Vk8vL3pTZUJkM2FSUVg0?=
 =?utf-8?B?enl0QmxqdTNSSDBGeHNEdzZ0eHB0Sy9oRVpCV2ZYZWtsSi9yS1pPeUR6M2k3?=
 =?utf-8?B?ZUhoS24vRGljaXJING1Rd1d3cFdPZzhmTHNUN1Y1dFdWWW8vbmZSNVN2MGF3?=
 =?utf-8?B?aUFRRW5XdHBLUjVKQlR3T2xlK20xVmdzcExpMXdRTE9pL3hmOEt5cFZ2bUo3?=
 =?utf-8?B?YXVzbS9OMkwvdERtTkhrM0t4TjFLL1ZSMGlBMG5GWVdYZXRmdlMxT29oaGZJ?=
 =?utf-8?B?Z0dQVHlYTlgzTTQzSndva2Z6MEczUzE1OGcvMElnZVVpL2tvRkFVL1hsQVZE?=
 =?utf-8?B?TjZNZHB3SmJFQW1qVW5JTUh5emYwc05kVFJrWC9haEl6dFlObGZaVDF2dUtr?=
 =?utf-8?B?VGRVNVdGMDlMRXhWK1hXZnV4Tm5QcExOdTlna0R3ck03QnN4Q0pyVWxxWGY0?=
 =?utf-8?B?b0JWZFNoWENybGRjZVEwM0lBekFJL3hlQUVLRzJWTUZDTHVnb09CeG5ES3Jv?=
 =?utf-8?B?YWZFNXcxZC9KeUNmZVJ6TXhZQ1dXMTdzSmhsdStOQkQzcWNYa2NaTGxkRkZX?=
 =?utf-8?B?ekd2T2dqRUJQQWJHRlQ2U2VTdVlQQW9wN0Zhd1BwUmtZM3IyMHVsczIrVG5G?=
 =?utf-8?B?QU1tYVhERjZjQTd0V0pBY1A1ODZYSnRJRndFQ1RLS0pRM0pyOEh1VytSS3ZN?=
 =?utf-8?B?RUZ0RWdVdjlTT0E9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 16:06:07.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b5c8f2-483f-4d2a-76fd-08d8b7dd2307
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ekok6t9OA4dsnKs6doPvo9WyNVvdAAtlDupkRTiPEH640mXn6qnIvJzzjty5wmQK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-13_07:2021-01-13,2021-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=938 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 mlxscore=0 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/21 2:16 AM, Qais Yousef wrote:
> On 01/12/21 12:19, Yonghong Song wrote:
>> I applied the patch to my local bpf-next repo, and got the following
>> compilation error:
> 
> [...]
> 
>>
>> I dumped preprecessor result but after macro expansion, the code
>> becomes really complex and I have not figured out why it failed.
>> Do you know what is the possible reason?
> 
> Yeah I did a last minute fix to address a checkpatch.pl error and my
> verification of the change wasn't good enough obviously.
> 
> If you're keen to try out I can send you a patch with the fix. I should send v2
> by the weekend too.

Thanks. I can wait and will check v2 once it is available.

> 
> Thanks for having a look.
> 
> Cheers
> 
> --
> Qais Yousef
> 
