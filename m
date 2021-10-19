Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF124333C6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235281AbhJSKom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:44:42 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:40092 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234955AbhJSKok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:44:40 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19JAQQpe021875;
        Tue, 19 Oct 2021 10:42:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=ywzSknGkVVIqBQC5auRutOtZaar3V5fb5Zdgs9WMiLE=;
 b=Qb7xUf6q+Wg4E9IacsgPPdvvVl7/CXk8qj4vyBz6aE10slaSzl1I+wMhJmdl0a2QvRNZ
 xCaUIgRBrtyGs4ky8rhnCsA8v58h/6L950GXj9UU1hFSgs++M7sZQPrNUZ4O544ymdQF
 /s2BRXiE6pEuOsrv3w5Hkp4oX9BAmhvrkZm73c7gCsoGerBkYybQMzmgCPbPv4WcXzH3
 BtVHJDfqboUwA6CfxaKYjUrIntX0vGjtcxFhR6Ts/9cRQVR49eqxa+52yEtkPWMi9l3n
 /v8ME3SXcxiDCEE5PkrstfRvmEtEJTe9zyiSG7lhuAARqCUPcDkI/rJcPJ6+nRrsRj6Q yg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bs6hhgym3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Oct 2021 10:42:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhV/Dz44eSJQqImeEHqV3lhm8+AylBKYp5RLG3ulTDdGGl3pJiYDTx484efRwra/qMJ50kLhkqtcQ61iPb0hoFUmiL9F5evUzv6eyIV6r6afgzP+kZHeMMXBvN1UTKuU77S47CFe91BvPql3Xp3qEQYcWMWdrGM+hI80iUzxofUYcnt9Rbs5D6zO9uD0n8gT1+7ulzrRtJs4G+JmKPq4TBDDXwHfc7PTUSgonTYnb72rvf9pXxBbyJqLCQTMaXz1U+EcAfb2yzDNH7+qSrzbXVcuKAhnbojptbw/8AMe4NrbF3uV/Txfebyd0NSvi9Zz/DIyU/hwZMqUc5af6njO8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywzSknGkVVIqBQC5auRutOtZaar3V5fb5Zdgs9WMiLE=;
 b=Tciru61rGoW6GSO4jxMepis9AaUyMuSlmz4EmnBxpRi/SUScaMG2ruoyA5iwqXBeBTiilHsFwshq0ZG1UKH3j3oERqeiiPcV8lcTLq9AReC0gvYSwHRtmClEyzHw3PggrxvpMwyxwlW9hjmwB0DkkXnVTDi3Uym+AcY0NGR1cR8qF48Dl1hE3b2olv1SCUoHRI/GebkhYwzam5G+2b9lvfLBBk/zGHhGEFxmKCpGoLhZsTZfRA67EWZN06vLsKNhyCVF0ULx9BJrdk6+DalsLSaMUvuXOnayD18MUer9GtjNgao+Rr7ZRLkFcwvDXqmS+H0EJg+vSlm0/QTZuBAnBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5111.namprd11.prod.outlook.com (2603:10b6:510:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Tue, 19 Oct
 2021 10:42:07 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%6]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 10:42:07 +0000
Subject: Re: [V2][PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Roman Gushchin <guro@fb.com>,
        mkoutny@suse.com, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211018075623.26884-1-quanyang.wang@windriver.com>
 <YW04Gqqm3lDisRTc@T590> <8fdcaded-474e-139b-a9bc-5ab6f91fbd4f@windriver.com>
 <YW1vuXh4C4tX9ZHP@T590>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <bf88f85b-59a4-e2de-8b3a-70871e63adf6@windriver.com>
Date:   Tue, 19 Oct 2021 18:41:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YW1vuXh4C4tX9ZHP@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR03CA0050.apcprd03.prod.outlook.com
 (2603:1096:202:17::20) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR03CA0050.apcprd03.prod.outlook.com (2603:1096:202:17::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.13 via Frontend Transport; Tue, 19 Oct 2021 10:42:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 980fec80-e956-4e27-c542-08d992ed1911
X-MS-TrafficTypeDiagnostic: PH0PR11MB5111:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5111C8004FC64CC4235E76CAF0BD9@PH0PR11MB5111.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eg8NUae96IHCerIOqgmWD6N48GGNG4Ss47Wh9DQXJ6Z6bcd3go57215ZLwwDs9tNVLqzZsLNxs7SUkAFXpje0BlwWssYBtgblZGKWc55FwTySp/Jtcs4+EO6lhybINRX4KX4K/3nQt5lhc9zrFuEwJx9D0Vdt3T9VfKRUCrykkYWa4W9L0ltpYgOJWJjMiUGmcZxeGOHW5U2Rze0aQQxa7BaORA4a1LVtlYQrcEWBvYCA/tAPykyH8NaUKdZIU3VdSkIXodREHcyF49WCvRz/gO31qSIDK74xqn/3tXpp8hU0f+/W9yutDTCpPxwwatMfnSK1H1z8sjhMl0Cov9gmv453qwxWpZMy9j7RkcPrzjS7BMfU27Eedb24b0re4VeJ21MxZrgbEdXrc6pNh8MY4zif5uxjWTQk/ikpm4XyRynAdBpqmEQZD0TINmOQnMxbVPd7TCMLEseLxnd3GLIx5+9cQ8RC1ICm3cX2fy6okCXFMCwTHbpjKZ70XSq4RLLjY2f0ylUexlmpYraBzWD48bvkYXRlHHQD89MlrN0BzYnjPKDDUBVOfWsOW5buUxSrV94WPPkBvXsZNlSpmjOKF5iJ7HlxjBmKgPdoj+G4rIJm/5w7Xt8GljPV6++cN6oNuneXInZJL7sndbQyT3UUgHLDDBox5poW4508qr01Yv0xcd2fW+a7fqbne2GC8BekkpqSlYatdLb8Kq5+rWcyMjqRpsTh//Z8zqnAOjlUV4G0/pwQAcDiE14RLvsB3qQX+4QX+Zsv7NOzQzDdJVECjd/pHrqwys2A04VfdoRRnY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(86362001)(7416002)(2906002)(4326008)(6916009)(26005)(6706004)(508600001)(31696002)(6666004)(956004)(66946007)(5660300002)(31686004)(36756003)(316002)(44832011)(54906003)(6486002)(66556008)(2616005)(16576012)(52116002)(8676002)(66476007)(38100700002)(186003)(38350700002)(53546011)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGcwZTNwZlRVZEQ1NVZzTTczVk1HRzM4NmxOL3diS3I2Tk9kcXVEM0dGR1Rl?=
 =?utf-8?B?bFI1dUZqWjZPQ3hlK240SW0xZWtVNHNtZkFmamJoSjB0RE5rSVpnaXhvZ0JB?=
 =?utf-8?B?MUFlbEZsN2Z2MlBBSlRnZzBHNG8wTlI3UmxIcjhrOU51ajVXMGpCdStwckI5?=
 =?utf-8?B?SkgyVm9yREhTczQ0SmlHTldtQy9nblNaR3NqT25QbHZkRjVTZjhYQlBwb1BO?=
 =?utf-8?B?azg2TEhPNHpucXJhMzJ5RTR5cUFLN3gvcTZSZVprV0laSHM0VEhCL1g1K2lR?=
 =?utf-8?B?TjA1eDBOY1d1QjJlVytTbW5SSWk2R2VkRHJKSWJrUWFBTThYQkgrMXh6R2ls?=
 =?utf-8?B?dEFncEpES3JoazgyTDhkUGlFTnpxODlBci9nditWc2lpQzBDRmtJZHR3Yzk2?=
 =?utf-8?B?M1RmaHB6b1pFbFJvcHlORzhzTXZjeTVNeHV2eHpMbFY3UjByeTBORXhVZlpm?=
 =?utf-8?B?UjZNcVd2SWdXeS9TWTJPTDZKandsMkF6bVppVXhhZTVGOGNOVFdDamJYbTlK?=
 =?utf-8?B?UDdlTjVFaHlDSVZYNXVZYWFOVStXMmg0Nk4zTEtDekVOazQ2MFJZNmNaS1Zm?=
 =?utf-8?B?Q0ovUFo5NDB5QU9yemYrSnhEMVZWZ2EvNXdyVFlHVEpvVmFSY1AzNEt0RjJ1?=
 =?utf-8?B?dHN6Q2NrcEoyYnhQNU9PN0hMUU1KTjBnQjY0d1Z1eFBlZ0M4OTNKZ0pHcWRM?=
 =?utf-8?B?akEvcDJGR2poc3MzQTVwVFBQOElJd0tac1lXVUg4dnJleGtMMlEwUm9zbnM1?=
 =?utf-8?B?Q1RkajVzYnRHdDJmbCtMdlJLejYvUnBRSHlpR2wzZStlSDhqallOTzRxNkZv?=
 =?utf-8?B?Z3hmWDFYOFUrTmxscGFVd2NGdHVHazR2dFI1M1ZoRTZCcHR0NzVKc0NaNStz?=
 =?utf-8?B?N1VsQmxLMW5JL2xYOEQvcHJGZHdIY1R1SnNLZ0l0NG9TNEEwTUtUN2U2VDcx?=
 =?utf-8?B?NktGeUZPcHAvV2lxeVpiZitndXl0S0VXVmtSK2dDVWVYeWVCUFFrY1JPMWxk?=
 =?utf-8?B?M3ZXc294SngyK3dMb1d4NFd5Z053TnY3K3NNa3R0RVJUd2RGeDFXYnBjaXlm?=
 =?utf-8?B?NDd6cUVHNCthcDNHdlVLY3ZCWXZWak1BNkRSRUxSRUNPbUQwZmRsYXcvZk5s?=
 =?utf-8?B?LzRwdlEvR2Fhd1FIZDl5N3NnZ245c3VpOGNnbnBlT0RDSFhuditSaytlRFY5?=
 =?utf-8?B?NzBXRGtIZ3ZWaUtiY1AzUVN3b2g2SVNUTUVHajl4QjJNcGdYenh0SUo4QmJG?=
 =?utf-8?B?eGFUVlV3bVR2MlV3aER2SHJQTnBENWxxSHd5RUdWNXJmTHZiMDRSUkgwWTZN?=
 =?utf-8?B?aGp0SnZhZDZvSFNJZi9hVlVXd08wT24wNEU0aVRhYmNIcWNzamZReVJkbW5H?=
 =?utf-8?B?R2VGSmowTG1pa1p0ZDhDbGx4M2FRM0hpSmNiRWVWdHlidWYvNGdYQXRKZXRW?=
 =?utf-8?B?U0JMeS8wTUJlWkNHQUtpc1NRc1c3WjBkV25TWmhkNHU2MDFSWGRCNXc0SWRV?=
 =?utf-8?B?OHVoZXc1M2J1blcrWVptWVNiSDY5SVk1Ky9wSlgxL1drRnRoQWhZbjFHeG0y?=
 =?utf-8?B?ZnoyWmdOSnMzZ2ZCV2I1MThkSUljVml1SDQ0UGh3ODl3WXBPeU8zQTBpZ21K?=
 =?utf-8?B?R0VDVkE1UG9raHdhejdNOXJSeGZHa1daaE5wQUhrL0dCS29TS1FUTnUyWTM4?=
 =?utf-8?B?NTAvZHV4cUlvbUljVWtpYm00U2EzcGJweklEbWE4ZHBaMWN6QWgvRVJVRS9U?=
 =?utf-8?Q?doYkzuIHLa5nNw8Ra280ScHExKgab4nAIUhEJfS?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 980fec80-e956-4e27-c542-08d992ed1911
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 10:42:07.6190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jdsx7o/skDkgXx8r84prbJiNYZzoR4wuU1Bx2OWtpVmopPGO00NSBgoPzHKNe4jN4rlzAKk+ZnfnnQpLOM3dqNSmi1JWNfz7Kn79dobFbuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5111
X-Proofpoint-ORIG-GUID: B2dOhPHdR6ZC-YaiKSt4KK1kQnBoj14V
X-Proofpoint-GUID: B2dOhPHdR6ZC-YaiKSt4KK1kQnBoj14V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-18_10,2021-10-19_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=947 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110190065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ming,

On 10/18/21 8:59 PM, Ming Lei wrote:
> On Mon, Oct 18, 2021 at 06:06:28PM +0800, Quanyang Wang wrote:
>> Hi Ming,
>>
>> On 10/18/21 5:02 PM, Ming Lei wrote:
>>> On Mon, Oct 18, 2021 at 03:56:23PM +0800, quanyang.wang@windriver.com wrote:
>>>> From: Quanyang Wang <quanyang.wang@windriver.com>
>>>>
>>>> When enabling CONFIG_CGROUP_BPF, kmemleak can be observed by running
>>>> the command as below:
>>>>
>>>>       $mount -t cgroup -o none,name=foo cgroup cgroup/
>>>>       $umount cgroup/
>>>>
>>>> unreferenced object 0xc3585c40 (size 64):
>>>>     comm "mount", pid 425, jiffies 4294959825 (age 31.990s)
>>>>     hex dump (first 32 bytes):
>>>>       01 00 00 80 84 8c 28 c0 00 00 00 00 00 00 00 00  ......(.........
>>>>       00 00 00 00 00 00 00 00 6c 43 a0 c3 00 00 00 00  ........lC......
>>>>     backtrace:
>>>>       [<e95a2f9e>] cgroup_bpf_inherit+0x44/0x24c
>>>>       [<1f03679c>] cgroup_setup_root+0x174/0x37c
>>>>       [<ed4b0ac5>] cgroup1_get_tree+0x2c0/0x4a0
>>>>       [<f85b12fd>] vfs_get_tree+0x24/0x108
>>>>       [<f55aec5c>] path_mount+0x384/0x988
>>>>       [<e2d5e9cd>] do_mount+0x64/0x9c
>>>>       [<208c9cfe>] sys_mount+0xfc/0x1f4
>>>>       [<06dd06e0>] ret_fast_syscall+0x0/0x48
>>>>       [<a8308cb3>] 0xbeb4daa8
>>>>
>>>> This is because that since the commit 2b0d3d3e4fcf ("percpu_ref: reduce
>>>> memory footprint of percpu_ref in fast path") root_cgrp->bpf.refcnt.data
>>>> is allocated by the function percpu_ref_init in cgroup_bpf_inherit which
>>>> is called by cgroup_setup_root when mounting, but not freed along with
>>>> root_cgrp when umounting. Adding cgroup_bpf_offline which calls
>>>> percpu_ref_kill to cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in
>>>> umount path.
>>>>
>>>> This patch also fixes the commit 4bfc0bb2c60e ("bpf: decouple the lifetime
>>>> of cgroup_bpf from cgroup itself"). A cgroup_bpf_offline is needed to do a
>>>> cleanup that frees the resources which are allocated by cgroup_bpf_inherit
>>>> in cgroup_setup_root.
>>>>
>>>> And inside cgroup_bpf_offline, cgroup_get() is at the beginning and
>>>> cgroup_put is at the end of cgroup_bpf_release which is called by
>>>> cgroup_bpf_offline. So cgroup_bpf_offline can keep the balance of
>>>> cgroup's refcount.
>>>>
>>>> Fixes: 2b0d3d3e4fcf ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
>>>
>>> If I understand correctly, cgroup_bpf_release() won't be called without
>>> your patch. So anything allocated in cgroup_bpf_inherit() will be
>>> leaked?
>> No, for now cgroup_bpf_release is called to release bpf.refcnt.data of the
>> cgroup which is not root_cgroup. Only root_cgroup's bpf data is leaked.
> 
> You mean that cgroup_bpf_inherit() allocates nothing for root_cgroup?
> 
> If yes, I agree you can add 'Fixes: 2b0d3d3e4fcf', otherwise please
> remove it.
> 
> 
> Thanks,
> Ming
> 
