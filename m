Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665C7488567
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 19:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiAHSyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 13:54:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53222 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229805AbiAHSyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 13:54:14 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 208IrC59027333;
        Sat, 8 Jan 2022 10:53:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=gNczDbnhtSzJknYHnSAnW5ZkYLYDSKYYY2oq/7jpE+0=;
 b=T19UTvi56sJFyzdsOErNncHy/j954D9/OJxytzkHfEgeLOu47KcitfFrKtsFWfa1lZNZ
 OZv1+csGO0H5knZYo9gxfNJvuvhhkHl+QpvEf12thEB2WwsR1uLDsLvSC5pTuolygi5D
 Aiu1bt7Il9vEXFbETCanEkv1MsqxwbH5ggU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3df915sgju-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 08 Jan 2022 10:53:55 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 8 Jan 2022 10:53:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TopbYHbpkR4YM0hPPpB9ievLtxzyE+TGo6Rofyx7mfsq78u1EckV/Q5cu8SVL99MjSzVdtqMKD00T48qlJL3Iq1bA4qIYCPT18dKroThCGSVeYjRHk2ZM3aTwkXMl3GP+Ayk3JUxYadvr8Rx1dsn8fmEeM3So8ZZnciynS3IuF9stu1PIb+UppH2/GZnskuFbjbIAxKinkJNF5wyW3H/dTmLt6erVczfNT3zRHZgIsKsIIHiiDOQx7bYX9AEU8yJKV5eHMOZEEXZ0J1jaJ6XhlUYWngQc44HxeRZ0JXW49offpIiAS1AdM7qWmKhC4ZMZ8MbyJr6fDvmNQ3KAjAaUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gNczDbnhtSzJknYHnSAnW5ZkYLYDSKYYY2oq/7jpE+0=;
 b=FWasakzUYLlblMNLxlUrMNV1d3rQNoDecR52iQKYOxykXXe7QiqPInmIDYj2Txr4PLvFbqzQlKJla8wXrfvEnuiOHDmwuH8/awAZ9dVETh3JHBca8HOEdn3VVSy92/2SdrImnib5EZqJ81+rHLWHjuzxxrb/+y9y7ZKlCsViKEs09yhNl+ugbC3+XGJW3M2OcVfdvU2mTP8IsstZfbPGLsftm09byMzFWPAp+xaaAOuQmabpHFHDZbQfPoDT4pbZfwXrtoSHYT6Zv7rAZ79QWcCGDq68rc6OlhDYYZCoNL1fQMWiB8JGeEqLUAPO3QljMkxoRToaLeRNcs+AJNqVXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4224.namprd15.prod.outlook.com (2603:10b6:806:f5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Sat, 8 Jan
 2022 18:53:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::ede3:677f:b85c:ac29%4]) with mapi id 15.20.4867.011; Sat, 8 Jan 2022
 18:53:53 +0000
Message-ID: <ff77b4e7-49b5-61d8-12f1-b5927eb671a6@fb.com>
Date:   Sat, 8 Jan 2022 10:53:49 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] bpf: btf: Fix a var size check in validator
Content-Language: en-US
To:     "Yichun Zhang (agentzh)" <yichun@openresty.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>
References: <20220108022212.962-1-yichun@openresty.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220108022212.962-1-yichun@openresty.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0100.namprd04.prod.outlook.com
 (2603:10b6:104:6::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5dea2bf9-5983-4221-bd52-08d9d2d8376b
X-MS-TrafficTypeDiagnostic: SN7PR15MB4224:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB4224F0B9E810B258D790E3F3D34E9@SN7PR15MB4224.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSqcDiCY5tkhdM2b+ZmkktprpzB5XLEoaPAe1M22C8ivsK+jj/R3tL9rSJ2nPsnoBREX/dzIVyVU9+9eCfU2NdTjFOQUlNbOsLj7mAlzxw2pjWFu0sWNhlTY+uwTd+4pVEmYPgXe4P4R8fG+Yj3JMMqg0jUQAQ5fB4eFYn9C8lXM9M2e8Aer8StGIikmaafZRg9f+7vGFuc+oo3VEk8IixQhXYE/CgL3YzLh5dn0h0ym2bEx2XSSJR/fJmikrAZKmsLIxIiprMWu++6vhz1TVOzQG3IMyaBhKyld6RpvVieqX0M0OZ08vLPWnDjjBXeVBx28PcZ+DUfzT6hQ1afK4HlaRaAyp2+1rJJOtPBVJ0mpipB+8AKcVKm8RGb1sPjP2UmnSA2dQQk0jQhyqJsSyrolerLzYzv4EPn1Eql/2mnUpcxBHqCry6iVffTEAR6UjeFn3UVXovzADUUt7411k026Y+JxVr9OlcAADG4vBAwnMBtV/ziOG0zmIzM7EPeQJ9U3tTgGs/bk4TC1qP+UG0gir68v4KzWHOzbr3oX0JceuFVL78MdvQ2mDYn1ar37kZSfOIcLfdKaqy7vLNuc2nB/xHa9e9mHgR365X0YTrmQ2rNv8IPgE27d/rKqZD+PNaHfKP2lYJVSX9fTZMrxf360IkIZxZ1wZeLoyiDPKRmV2LfihiBTTCPHpgHhcI/hibJkwlDCP14VRJv9OfbNfVSi7E0q2m/RWU2pkAMjgGM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(86362001)(4326008)(36756003)(54906003)(66476007)(8936002)(8676002)(6512007)(6916009)(38100700002)(6486002)(2906002)(66946007)(66556008)(31696002)(7416002)(6666004)(31686004)(53546011)(83380400001)(316002)(508600001)(5660300002)(186003)(52116002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVFpY1FPdXZ2UWN3THBpdUUrSEw1LzB1cklvRUVqV2pXTDJpZmRBbm1iWHpL?=
 =?utf-8?B?dGtINnN5SUN1dFNEZ0VibzFYWExmYk5MUi95TkNSR2FydUZXSlpYNEtBOEgx?=
 =?utf-8?B?c0tScDl1Yy9FejZBZkJIazhPcm9reGFzaWxCcGFHM3hoZ0NLRVJRL2lwUTdI?=
 =?utf-8?B?R2RWeXZLL0d0WFAxKzc0d3ZLODI1MHlxd1ZRWmd1VzVQM0JjVk1iWmxIUXVu?=
 =?utf-8?B?R2s3dHc5VU9JcHA4Zko3b2ZCM0V2MnF6cTlIZHFBSzViU3dwR1F6KzkxMHRk?=
 =?utf-8?B?bEpTRHRuSjR2MVVyMWJLMTNHa0FZWGEydDVnMlIyVktRWUhSQWV2ditwbEtB?=
 =?utf-8?B?VkZZNVRLa2hZcTlpRWg1NndjTFJ0eUxpS0t0OW9YdFZtK3pxUFNXNFNqVmRs?=
 =?utf-8?B?U1VGR2xQejBJRVhYeVNueVEyaEdGb1dyT0hUTm16MGF5WDJHSk8va0gvTXlN?=
 =?utf-8?B?bTFkdjBsaFZvUzhlS0VVa2hNTVkwRzRydkJ5Y0Y3bCtOUmJsQUxEeThUdW03?=
 =?utf-8?B?SmF6MWdyTkFjQkwya0w0Ly9MS1JuNk1PeDErZXFST3dRSVZPVURaUm9aZ3My?=
 =?utf-8?B?M0ZsRVV1WkpwREFXbXhwUFRobUtoR1E4MDVQL2NyZVBvSEEzRHpQU0Yvcnoy?=
 =?utf-8?B?ZEkzdUJpeUhwaENETlRWYjNsZWJzVWtIamxQYzVpUUdLVHdlbWEzQ0xqUHBq?=
 =?utf-8?B?ajB3dGppTzJqZ2hqTWwzMllVK1IvSVVCUkMwQ0JUOWhIaDRpbGltNkdta1hJ?=
 =?utf-8?B?bGF1OGVxendNd2hVSDVxeDRNVXZGVEh6ZHpiSmMzNiszSUdsdmZVMFFBckda?=
 =?utf-8?B?Znd2Y0UzM3RNSDMrVW5QMnQ1U3Fzd0YxSTdwQS8vM0NRRm5QbnlIZVhaeW4r?=
 =?utf-8?B?TlNETDh1M0RwWnRwQnh4a1QwdS9uemMzRHRVdU5MSmVkazI1cDJsdFdaUnlR?=
 =?utf-8?B?cGY1Kzkxc3FYVm1RbTRtZ2RIdW84Qmd4VUpEUmJWSU5CcnlXSkpHSWFUWUpo?=
 =?utf-8?B?NHRlL3RnWG5KQTJzaDFJOEQ4QzkrNGgxaVBFTlN6SjRmUkgxbDFxTjl3Q2Ux?=
 =?utf-8?B?dlRDTFh1alJRQ1cwL25nSTgwKzlobnZ1RE1CbTV0SW0vUTBqQmtWNVh1dnZu?=
 =?utf-8?B?WFdCRXlUUVZxcWxudjZkV3VxSUU1SHZ1SVY4cDFkanEwM0dqeTBmaTlHMWU3?=
 =?utf-8?B?QytmeEhRcVhGOG9PT1g0aHpjNFgvV0syL1VHQmdFQlVpS2ZhQkZlTWQ5UHJn?=
 =?utf-8?B?VGROWFJzSTJjNDE2UnoxVGJzNUZlWVE0bnJQeENSNFdXWHltNFFHQ3M3d1c2?=
 =?utf-8?B?bGlHOVhvL3YrSnlrakIvbVEycmZUcHNKbTRGSGorSk9iMFhwZlp5WnJmKzNF?=
 =?utf-8?B?ZkorWFBqZStkZC9GUGdTWFZicnJiUUU5U0UrY05pUmExd3BRbHRPanF5SWMw?=
 =?utf-8?B?K0NxbXVSZnQ5dHBYdVpMOTNleVVaNFp2a3pWN09XaFZsUnBXcE0ySWVwRDJx?=
 =?utf-8?B?YkRCQkRkcENFMEpQMS96emhnQlovQVZVSldMbGhTMVlzOVZoYjN6T29INFVV?=
 =?utf-8?B?ZHhpcFY3Zm01aStUWE0wT3VoNHU3aXVmKzUxd3lWRnVSKzR3ak16ZzJUZFZ0?=
 =?utf-8?B?MkliRDNHWTNRTEpiRUEwK1k1SDBiSHh4eFk0aXgvOG5NTkt2OFhXMS9mNGZK?=
 =?utf-8?B?TmNlWGVtYTNIVW9TN3hmeEVIVi9sdTljM0FUZzUveUY0M0JmWCtPNFQvYk1C?=
 =?utf-8?B?QklTQ2ZwUlFiOGFTcU5iSUJQektpdHFqUUt3TFNPVVkrOElabmp6WE0rNzc0?=
 =?utf-8?B?ZGdXMFhranpaUHJPMTNDYm5vdlV5WXVSK0pVMjlmNTd3TEgxaE5vNEdUK3Za?=
 =?utf-8?B?VUtHejIzM0VvRzNGZ2Y3dTNFUmZ0eXZyejhhVCtQZGwxUnUyYzQ2K3VCR3U4?=
 =?utf-8?B?Qk5QajlJa3U4UnJVRDB1QlBNRWM1SmZvM2tkZGF2Y1VGTFMyczVHcW1EOENQ?=
 =?utf-8?B?Tnk4ZVNQZ3hZdFR2YmRMR3I1Mm1lV1JTV2NzVlZBU1Q4ckwyL2c1Z1dMU09L?=
 =?utf-8?B?SU9wZDIwb3Q0SGxBYXhoMzk0RXFjZDJhOEVJMjd4VGRFSWU5TUQ5MUZUV0lv?=
 =?utf-8?Q?X6UbtpEWi/cOx7tKhjXQzCyl2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dea2bf9-5983-4221-bd52-08d9d2d8376b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2022 18:53:53.6868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7B20lmSTJULkEolJD4ppEf/5kDDHbsS62x2WeqAmSKyIbqE5Hn7EZHftRfi4yGQX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4224
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: NbI48dCtOMdW11qwbmPu2jR7sCQqHk94
X-Proofpoint-ORIG-GUID: NbI48dCtOMdW11qwbmPu2jR7sCQqHk94
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-08_07,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 phishscore=0 clxscore=1011 priorityscore=1501 mlxscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201080143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/22 6:22 PM, Yichun Zhang (agentzh) wrote:
> The btf validator should croak when the variable size is larger than
> its type size, not less. The LLVM optimizer may use smaller sizes for
> the C type.
> 
> We ran into this issue with real-world BPF programs emitted by the
> latest version of Clang/LLVM.

Could you give an example to show we have variable size is less than 
type_size?

> 
> Fixes: 1dc92851849cc ("bpf: kernel side support for BTF Var and DataSec")
> Signed-off-by: Yichun Zhang (agentzh) <yichun@openresty.com>
> ---
>   kernel/bpf/btf.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 9bdb03767db5..2a6967b13ce1 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3696,7 +3696,7 @@ static int btf_datasec_resolve(struct btf_verifier_env *env,
>   			return -EINVAL;
>   		}
>   
> -		if (vsi->size < type_size) {
> +		if (vsi->size > type_size) {
>   			btf_verifier_log_vsi(env, v->t, vsi, "Invalid size");
>   			return -EINVAL;
>   		}

The fix is incorrect. We do have cases where variable size greater than 
type_size. For example,

$ cat t.c
struct t {
   int  g;
   char a[];
} v = {1, {'a', 'b', 'c', 0}};

The type (struct t) size is 4, but the variable size is 8.

