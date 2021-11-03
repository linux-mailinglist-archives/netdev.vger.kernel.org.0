Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43E5443B65
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 03:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhKCCdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 22:33:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20734 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhKCCdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 22:33:51 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2LbONk021784;
        Tue, 2 Nov 2021 19:30:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=e9iakA+09xQ/33b5FnWGjrBLiVaI2cv8zaHF1ZYTUw4=;
 b=geHgn+e020bS6j7eJPvmXI5zt+5io+QBl/ZbAfkt/DGE/t9bm0QgLvsyabbhx+CjGsZn
 clfAcFiLFzuDR8utCwqCecywuO0+sdQZXe8m4blHJwlkQN3xMzxjQrnO1dX7r0I30Gmu
 VF3xm36jJLEAwC+CGwwQAwXoohX6dlIXpi8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c3ddbskep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Nov 2021 19:30:51 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 2 Nov 2021 19:30:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQtFh/53oU+UnIp+pIoCLXOfPG2YR7MOWE87bjWFrv5THsV09amHqCYZ6w5jsFhhZ43LDlpQtzTttDo0pR0F1gkeCzNwBQJL6XPd1QTlARzOFAZQqvXOtwyfXJGYF5pXj0VMKR77ZExKG1tcMhte1xDbb263j9ffoFU+4wXcY1zqLY7LC/bMts8rDGdFglwajrFvqipPZkO/4dg9fPF3Q5rxoOv9U1Srl4hW21AEGoK7ktGxUIs3Mp6snAsDWLB9rzZHdYiIOXAi6sWcgiSs/yd9MCpRJXj56Zn0dVfInGwgF2+pVx5gU69TkrhlwRVksnVxoXMTunBaC4szN7W/Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9iakA+09xQ/33b5FnWGjrBLiVaI2cv8zaHF1ZYTUw4=;
 b=A/4doQ1WABuQFyB4iKac47efkazAr/f9K61V8ITBjo3pApuOR3wnvcb+ahP5urk+LHKiq+Oyk1vZB14eqQGVHHx4g3cdRReu1DBWQVoWtVAdIuu29KvmxIBAaxBMEHFEawFWyt1zlpR977OktiwCMGd6jweb50xfdnG2iPrfPUYfj7EsvQX1qnGhcUPkFmSlQO7CUnOJDKgc2RST9XcYkwa/yTgz2npIdVfIEiI7lU8pQzRco9Jildg2D0ZdglMB4AGX+3CNahk4YUxRyxKZB/wHDZKLztugE0YyL1lNtazYfGOls/G+iyJaD+TbiRGbWsgoGTv22LYLcZlY2iAteA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4014.namprd15.prod.outlook.com (2603:10b6:806:8e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 3 Nov
 2021 02:30:44 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 02:30:44 +0000
Message-ID: <e2aa81ef-2fd8-52c0-2b23-09addc3e4aa4@fb.com>
Date:   Tue, 2 Nov 2021 19:30:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next] samples: bpf: Suppress readelf stderr when
 probing for BTF support
Content-Language: en-US
To:     Pu Lehui <pulehui@huawei.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <nathan@kernel.org>,
        <ndesaulniers@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>
References: <20211021123913.48833-1-pulehui@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211021123913.48833-1-pulehui@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:104:6::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::198e] (2620:10d:c090:400::5:deca) by CO2PR04CA0091.namprd04.prod.outlook.com (2603:10b6:104:6::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 3 Nov 2021 02:30:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6fd0252-c40b-442e-be96-08d99e71efcc
X-MS-TrafficTypeDiagnostic: SA0PR15MB4014:
X-Microsoft-Antispam-PRVS: <SA0PR15MB401407AA887E4DFD899AC95ED38C9@SA0PR15MB4014.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:214;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGh1iu5W/+wf/+mCho4yLXeBI3oHY1z4hbKDes42ONVsSk6XgMgbwU/LQQhg8C4FYOyOG8BWGnemhDg01RTyjt2+5vGzRBVeBW85VFD7X1ahBzrl/NeF6SEGQ1TyMUqszvyEYaBP0y7qLnhGPtYNxVNGradPJJhR1igrLMLzNhVvYJdn76n2WX3IBoA5zDG+r6dUfHbqQT09wG8mntgIKkt+9xcs7E9m/FsQmlmu5mQ3PoyMZtEXPfl5yKbKBBRrHSfCYtQMAEaT+a2hqxNRs96OkYo25Pm1Xpyc/T3d45SH+Kf7+cGSpdmdi+ls0YTO5spY8wwh0ZXxexWROMGh8p6zdAzSznJM1fQOXPl6TdRDXllIG15yE9luO3qWcE6++bmwhYjpWTEWPpPEdNr71LJtmdJ8xTY3BtxxD2K3UTfFix9hUHCW+/34yfnE26itgks77apD8YH+u4Owm5u8oeY3RbX7kUcW/GGiuXrEIQSQgB4l98rcv16DuqIrUBVu8Em+MgvjdbUppITAppge441jKzrwV7OuDqsz8Lz32V6s3L9hskSHU87g/rfTFl7TsqBuP5x7vkoIzeKt5g5rZgrI1aUQLllkhdpCv4zs51QoD8hJwBibkxPKHUP/4J7B6BYgP3dKZza45fC2V+aXievm3GsgyCMvTAuJC4CqUhr9hFYc/rJuThVo7Ub0TqST6dBVDttQe7/SAIZ8vYHPCnQw535VxBQqSP7absT5xalZ6xwob/TK4EoSSUPknXzY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(2616005)(921005)(66556008)(4326008)(52116002)(6486002)(38100700002)(31686004)(66476007)(66946007)(508600001)(53546011)(4744005)(8936002)(186003)(7416002)(86362001)(2906002)(316002)(83380400001)(5660300002)(36756003)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnh6N3UzdlJMUEdQL1hZR2xlMFhUMTRXQXBZaGZxVnMzZlV0Nm5wTGhnSTNV?=
 =?utf-8?B?bFV6VUVWU3krdHBqdENsamFTR1VyYjllQTYwb2dqNmR6MFo2d3Z3MnNqT1B6?=
 =?utf-8?B?cXNZVW5NMHhCYUFlTFV5NGMvejIrQmJOZklIaVJ1ZHVTYklXdWdxQW81Z1dM?=
 =?utf-8?B?cnlIYlhxdlRkbnpucW5PZit1b1NHblVWVmZjZ2VTVUhHVjM2bnRhYUkzY1dP?=
 =?utf-8?B?R0cxYXpsOE5OMWFpQW9Ia0Vwc3hsWU5rMEhGVXdLbXhpcXRuZWJ3bDZpdEpa?=
 =?utf-8?B?SkU2T0krR3hFb3NxYk1ab3VLcFlINHRmMExPcCtZZ1V6L0FZNmJ5Z2M5TjQ2?=
 =?utf-8?B?VUVRZzRYLzRVc0JRZUZHN0VPWkNmRE91RU9XZmRseEhsWDgxeE1OcURlMkJw?=
 =?utf-8?B?RTdhZC9UR3FQZHh2eVlJdmFXU2Z2VlBqNWtPUFR3dWZnTTJNSFpWQkk1SjNI?=
 =?utf-8?B?ZURlcS9SR21wY2JSeVljdUl4TEpIQnplL3JHSzhKRkRwNlZEcm9NM2k3WGpG?=
 =?utf-8?B?R2RCdUp0QXJDY3o0NDVaL3U0eDRkK0ViKzFYZEo0aFpuWUpKSGxJd0VsZTFk?=
 =?utf-8?B?dWUzdi84K3ZCM2MzU0hOVjJHSTVHY1hEUytzZVlHV1hWbnRhNGtqMS9IQVkw?=
 =?utf-8?B?OXdpeDJ1ckM2dThzRmNQY3dVVWt1NVMzVENiRnhrbEJjS1phVlk0TUlFcFRu?=
 =?utf-8?B?VDdJWHhubFVWQzZ5djY5T3FnTGZ6U0tYcTRGelllOVFnR1JQblNhWThrRHYx?=
 =?utf-8?B?YkFrM0lPditkckhKVXJ6NmlXK05veTdoSFBaZzRyK1dZdXRqbUlRREI1YWw5?=
 =?utf-8?B?Q3hVMUU5NWl0VUpsbjFobzJBTDBnc1g2VDF0NE9zdDJtN0Jzc1JGSGswQ1pu?=
 =?utf-8?B?MTRxT2NPNzhIRVBzWktIUDllRGswcVlNZlJhWU51czJQcXE3dTNRSy82dVVj?=
 =?utf-8?B?dzU4RVZtdFNYT0xjTXhkcTdXNENVdUlLVnVvQlBVT2FhcjlmMnVKM25iRHZq?=
 =?utf-8?B?dm5NYWJqNEFQRGNzalNMdVZPUzY0MHFRNXdEYm1EcXFGZ0tiN2FzWmoxL3NR?=
 =?utf-8?B?YU8xdTVGaDhjbm9zeUNKcFNFRGhrc3NTdzFiY2g0bGRqZ3hCT1NQMnY5Qkcw?=
 =?utf-8?B?NXBRL1FHbS83MXRTeStDeFozSU84R3lidUE2RU5samI4M0NlWGxXc1o5T2lD?=
 =?utf-8?B?cTJGYXhZQzg3SW52RmJrRW1RQU9hMkkwQmJOV3dRMzRlSHFIRWxXWDM1d1VQ?=
 =?utf-8?B?RzdsV2V4aGFjZEZXdkpWekJqaW1XNVZwNzV5cE5CME1GOGpYcmxEOVB2T3RP?=
 =?utf-8?B?WlVCWGhOTUJQSEFjenZ1VVlPbHJNTUJpb2UxcFVyNCtDYmZ2R1lwYWxPZjJr?=
 =?utf-8?B?a0NST09vV214Q3piMzZvdHdKVEpCMk9TU01VRmdkeUpKOXFhL0s2UEFSWnBV?=
 =?utf-8?B?d2xadmJkRkNLNUtIN3VJSEpRR04wb3orTnU2aXM0ck4xZm11RWR0UHZlZkpi?=
 =?utf-8?B?VExiSmlZYnFEaUhDQTVzNUdTVGVRN0k2UVA1eFQ4RmZZNlRTeGY4cElneURP?=
 =?utf-8?B?OFllajdiZFNkdmpSSlQ5Q1JmR1FTckgwMFZnMnNLRmJjK0NMVndzZi9kemo3?=
 =?utf-8?B?SE90RGk4cC9Ednk3S1JnVSt1c0YyTWRuNVBOTEZmU3BwajBqR21CNVN6MjZq?=
 =?utf-8?B?eVY3aE1USE54NE8zUkpYUXhVR0dFWjdjV1ZuNnI5SGdaNWdOS0xtRU9xZE0x?=
 =?utf-8?B?QkZFT3lnUW9VTHMrRTlKRXFQdHJjS25HVGtacDl0cmtBVUVSZTNuV3JYTzZH?=
 =?utf-8?B?bkcvMk1mY2lyWHRpZWwwQkhTNHY1a3QraWZsYTRTOTB0U2EzdkRDM3Jicll5?=
 =?utf-8?B?WXJuMVBreTd4NnBpNGEyQ2U5ckFsSlpyS1ZsM2VTUDFGUmpYSWRsMjhNRjRR?=
 =?utf-8?B?ajgzVHpkU2lDbSt2NmpWcFZwTFVKOEV0bUtJQ0hvV3hlZXNCRDZ3VnppemtX?=
 =?utf-8?B?c3hiWWhOZURnR0p1MVdNV3VuZ0FvelorR09CNEhqUFhyMkkzbVVhVUZvYTkr?=
 =?utf-8?B?K0VlV2FBYmx1ZjM1cnM2T0RYcGlmUjFrb0JyRnRIM2VwNDNUMEROdWVLTElt?=
 =?utf-8?B?VTB5amdQMmpZSExBZGV5SkNjUStXSXp5anpLR1piS3R1cjNiQ3U3MVdQODl0?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fd0252-c40b-442e-be96-08d99e71efcc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 02:30:44.2870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBQDzDoY1A7gy6E7bMwVEGl85V+TOJitoRgfjSh/khbPZrqbjqLdZh8hCKpjbexy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4014
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: FbsciHefN2KnCHse6HkesbPzITli76p6
X-Proofpoint-ORIG-GUID: FbsciHefN2KnCHse6HkesbPzITli76p6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_13,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=975 adultscore=0 clxscore=1011 priorityscore=1501 spamscore=0
 malwarescore=0 impostorscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111030012
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/21/21 5:39 AM, Pu Lehui wrote:
> When compiling bpf samples, the following warning appears:
> 
> readelf: Error: Missing knowledge of 32-bit reloc types used in DWARF
> sections of machine number 247
> readelf: Warning: unable to apply unsupported reloc type 10 to section
> .debug_info
> readelf: Warning: unable to apply unsupported reloc type 1 to section
> .debug_info
> readelf: Warning: unable to apply unsupported reloc type 10 to section
> .debug_info
> 
> Same problem was mentioned in commit 2f0921262ba9 ("selftests/bpf:
> suppress readelf stderr when probing for BTF support"), let's use
> readelf that supports btf.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
