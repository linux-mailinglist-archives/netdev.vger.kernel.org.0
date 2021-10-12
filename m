Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABAC429DA1
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 08:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhJLGYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 02:24:54 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:38998 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232963AbhJLGYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 02:24:51 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19C6MPqk016422;
        Tue, 12 Oct 2021 06:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : to : cc
 : references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=y9SYHQEGPJEHcZD/n698B/66roamsmBxCIlLSiqPXps=;
 b=RDFXCm2pW+n3LCDWG4yA3X+fq8fsShv1SMl5S99K0jNGKRSDVRi0KNEh4KoOwryW+Yvt
 s0c/wB7YJ/J1pGio5GjUg+xbGiHqJxycnFGVfG6JQJqzospjpI+ffi17aH6Jvs64THvg
 /e7+1p2jTJx2Mdyc0XZiCFTLh6sgNjaSFUZQf+EaaLEhcZbdrLruFZ8yWSADeahl9eyQ
 ReDd1xShiLK6QF39Wyx/G5mLVPlK9f5T9ViW+hOLSp+OlixVn3e3I/KyDJYIi+9QRgX/
 V6NNAqI0C+b5ImGfBmm3Lkoh7sXJU/j3KUTtrubHjLVTtnwBjwR+rG2/GC/rk7l7aF7a 6A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 3bmpp7rk78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 06:22:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0OLpSRXD1yYNY1wRhBJhzOfeX6UhL117fIyXzDL9XJdQiRUq8mMRrf1V4/56bQ2ceQco+aA5X5pJDkQKF3blhz0kSIh4N2VjulCXZEtxkHGJT1dNsnFdjAryngvJgsrHVLQT4ZK1E2KIWY8b9lFlfltdxgDpKY34cehTtEf38V9vrK1foY0DjB9Utp8NMxwQDsaYWfxxVaqIz+K59Pn/+RDICi4DBy3h/iDk3nGpnE768xxbTPBPTYr5DlzPgu/TOnkmN/TuSKF3A5sNM7ZK9laRcIuXT+qo3bSzdzkRKBHodIoeXWp16KJc5Ow1yGyY5bzeHITtOipe5ynZVWh2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9SYHQEGPJEHcZD/n698B/66roamsmBxCIlLSiqPXps=;
 b=PRveI5nMtr0TEyWQjUJoJvWBRjoSOYztvGijXwyN2HsrDrU+eGvuLRmvffv2hWbs83TXZCwCPvtBUOjCtSa7sq8Z8AH4cdkvyuLoDSAuh5uEOoAQUabui6vwznOSk/krNDWoDaR1ByDOFSMOYAx9vmmrkhnO5u26tFLYGknV50wc4pnMuyw9F0puAIJgo17PD422cm1B1/INAixclTuSpzFKw/58TuMQysWPdJ+bOzutaub79sPMTqXmCGMBpqUx1gHsP4bknP4C4iqubhsltHok0qbEgN0Zt++vrcozGjbdhyUlxoRj3kwKnMOPtvUd/MrKMm53/VLov0bXmT9OXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from PH7PR11MB5819.namprd11.prod.outlook.com (2603:10b6:510:13b::9)
 by PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 06:22:22 +0000
Received: from PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c]) by PH7PR11MB5819.namprd11.prod.outlook.com
 ([fe80::3508:ff4c:362d:579c%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 06:22:22 +0000
Subject: Re: [PATCH] cgroup: fix memory leak caused by missing
 cgroup_bpf_offline
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <guro@fb.com>
Cc:     Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211007121603.1484881-1-quanyang.wang@windriver.com>
 <20211011162128.GC61605@blackbody.suse.cz>
From:   Quanyang Wang <quanyang.wang@windriver.com>
Message-ID: <6d76de0b-9de7-adbe-834b-c49ed991559d@windriver.com>
Date:   Tue, 12 Oct 2021 14:22:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211011162128.GC61605@blackbody.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR06CA0020.apcprd06.prod.outlook.com
 (2603:1096:202:2e::32) To PH7PR11MB5819.namprd11.prod.outlook.com
 (2603:10b6:510:13b::9)
MIME-Version: 1.0
Received: from [128.224.162.199] (60.247.85.82) by HK2PR06CA0020.apcprd06.prod.outlook.com (2603:1096:202:2e::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 06:22:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96c82c30-d45e-4309-22a7-08d98d48a673
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:
X-Microsoft-Antispam-PRVS: <PH0PR11MB58321E10A261BF0CD59718C2F0B69@PH0PR11MB5832.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a55roGCCuskMqiu4COnHtOApUQeyJz0YQRu8JwJQbJ4t75jNF2YsLCGQodFlcchWAR9MFKfFRcMxFAscU83Y59W1hGn2C2mAPEasK0/gNMqpUFdnDKy+ib+WjOVAKcAWxiedzcV6d5gQif/XWSefmjRk8aZbD+eh1LiRKOFHVJgT2T1fbcXt0175LkltHB60C0wa1Lijg70+sb2XKadsKGW+e3TdMvYQ4AI+YFpWtaYmTLhTff1SlS43vN5vntmcqKm+XDGMc+r7Xv2EWnyo/3xmevH23YDSzx3PxLVbxPZ2DzQ9OqNVIGU7Avh1d2BZRdGCn/w+U4+x6L1f+r7TLCXcfLP4YzbJpNdZ6Wl0moX0rXxlIOTGt+axJY1uXGO9dHQ4Ik/UzyzIKcImYrGP0Qsxh/z/QHgVxVAr1hRnSaJJHiQHO57yAxRno3vH8WCJT7790euT1Tu9rx7kARMmja/EEBKFd22wbHLODQUpe21f4nE9C3uJEGViCnmaPhGtpcVar8nIo8+/GgwLnQnA0mIR2sgtc1ka/xyo924Qvps+xMJ2aixfhEm6+wygOF+hwzf0YKCKKRIHDLMdQ2XS4Pm9g8fNKITr4yCuuw2rVbPHh1iQzTcpdcM7L/Kzryvnd519h78Wtv9450jNBjm4Nxzzfy7r6SuTE2/b0zlzT7I35cMQI40ud46l0Kt/1bby/8TIw1fnU7dtfjCnjmQWznZgs1UPO9gD7xLNQ2ozFaWrJSVTvjA6ZjUc+PSosZpREkrbmLu0TrEc5Rb7OcioVVZmwcM+wrvHs9rZi671yws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5819.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(956004)(508600001)(8936002)(2616005)(5660300002)(6706004)(110136005)(66556008)(36756003)(38350700002)(16576012)(6486002)(54906003)(38100700002)(66476007)(26005)(31686004)(66946007)(31696002)(7416002)(8676002)(316002)(44832011)(4326008)(83380400001)(2906002)(86362001)(52116002)(53546011)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnA0RkFkRzNBMHRqRUw2ZDlDT2FVRzhSRW9qSE41am45NWxUODNiYTNMa0pH?=
 =?utf-8?B?SDBpdDg1MndZazE2dlI1bmFLbmJtMXRRc1gvZjU2N1JtWXIyUDJ0R2x4bHhY?=
 =?utf-8?B?NmxOdWV1akhTYVRRSmU0TU5sUlc1aGJGaUR3NmoyYmJQcDZaVHhZR3dLdGdZ?=
 =?utf-8?B?RUlKRnNWaEF1UHJhcWJaS3NsOUtjOFBET1BITUJSbEM0eVYyQkp5YWNSNm95?=
 =?utf-8?B?NjgrSEFqUXl2dkhtQWRqTENxNGJqN0dzNU1kQmRZeDQ2NDB3UEVsL0RVNU1m?=
 =?utf-8?B?U0x4ZzFWKzFVMVcvd1JpdEJ5cmNlNWNCNGRyUlVOVUp0NEpLbStsMUJ1TldQ?=
 =?utf-8?B?MVl1WFZITi85WElBN083eEwza2FIbncxUXdwaWRNSldpbkYzaitDdU1ORFhV?=
 =?utf-8?B?Ujh3VEpGRktjNmk1VEF1bnQvTGxCWlZCbWcwVzZZR2JNRjFVUDBoOUxGR3pQ?=
 =?utf-8?B?eVlTd1EwdFhEMVZJVkxGRE1yZDM1YUdGcVZ2WGxieFF2RFBXS00vWVYwbEIz?=
 =?utf-8?B?d0x3SWpEeTRnaUpYeGpQRzlCSVg5YXczQUVyUTQvVkVtZ2pVQUJ6Y0taa2ln?=
 =?utf-8?B?bUFFbVU1SDNsY3NLamJjN2U2eFBmQXFydkFsditpZ2lhZXJpR2ZpSXZWZ3lm?=
 =?utf-8?B?OHVzbUFaaVJYZTcvTGRjYUFheHRIVWg2V0I3QzVSR2JlcGtKWjh5TWx3ejRs?=
 =?utf-8?B?Q2pRbWFxRHhHWlRIR0RQaEZOWklSelpjQm5pTWpKL0N6MlNYVnFLZXJmQW5I?=
 =?utf-8?B?ZGpyMzVxZW9LdVBIOVVKMWZ1NmhCeHpSV2IvRGFLeUhRbTRGS0FhNUtpaS81?=
 =?utf-8?B?RjRaQnFvTEEzc2c2S2ZsUUh3c2dLWFIrcmQvLzZ6bXZEYzBGOVhIUElqOUxu?=
 =?utf-8?B?R04zRjhQM3NyanZ2UCs1d2UyN09wNnE4bXpmcytzZCtFSDYzTEpzdkRUQXZD?=
 =?utf-8?B?eDBzVzdnVmh0dnc0QjE5ckowY3U4UGpQUXR1b2xYYUkvRUxGWWpLakJ4Wm5N?=
 =?utf-8?B?Z0VJTVYwYWQ4MlkvbVpQQ2VVU2RsMTZQZTZDSkwwcjRIQVBxTnZGNDI2VFQ0?=
 =?utf-8?B?MUR5RldWd0V0TCtMeHhabFlyTnpiMS9nWDh2UUt2YXM2QUNiMDd0MVVhT0RR?=
 =?utf-8?B?bUlpbG1QMmd6NXNNR3JmZStXRWxRTjZRTzJYeTFHSVI4V3ZEV0JEZ0w4d21J?=
 =?utf-8?B?Z1Z0NW1XMEpRUmFMVmVzVHpQK2FtTFc5WVJOcmcvM0p5QmNsRGVrWWRpMDdJ?=
 =?utf-8?B?M0IxVEJJNGtRUTREbWpyMWhDM0lmVGVMeWF1ZkRzVTZXQW8yNjZ4MzBWK3I3?=
 =?utf-8?B?NlV1UGhibHNlT3VzQjZwMXl6WTdUd2dKYVROdDRISVM2MFJGSUo5dDRyVCtT?=
 =?utf-8?B?R0xaRjByTDJxQm1hZVorTGp4cWhtZnhIMS9nWXVyRWNkdXI2ZUhKZE5vY3N5?=
 =?utf-8?B?N3dpNjZmaWJRVm9TcDU5cERHVUluN2lOYklQNkdFN3JtWDNEU3M1akQxajdi?=
 =?utf-8?B?Yy9sTGVKUGtPb0tjTHNWdkhEdGdhRUtrVHR0dTNhdmdPamdqeFpONUQ0dUxR?=
 =?utf-8?B?R0xzNzJhQnBYRzJmRWM4Ty9JTnFvUXc0VXpIZmhVKzFMZUQxYjVRdGJJTGR0?=
 =?utf-8?B?cCtTc1h1M251QUl3UkNlQllOVC9SazNYWjdwNXhQOFNOd1FlVWZxUk10dk1H?=
 =?utf-8?B?ejhNN2pTSGlWY0RSWkN1MVJkZzE5d0pkMXdVVkdPOTVvb3g4ZktNVmQraGc1?=
 =?utf-8?Q?07JPvfoVDD0CS4Lf8UBXm7KA0G2Nol0EjovMS1N?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96c82c30-d45e-4309-22a7-08d98d48a673
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5819.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 06:22:22.0944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEJKT6Jaqr2PPw6TGtK6QrgRBwHYZnQteZQqYpTJl4zjzNuFQAG43ZieW2oNZhbLIHyzYEwg17OvYViK0qkeYc1d5o7JleBso4KzoTECbkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5832
X-Proofpoint-ORIG-GUID: 4QV1b6JuRfgYoZNpvAW9C5qk6vgAQvQz
X-Proofpoint-GUID: 4QV1b6JuRfgYoZNpvAW9C5qk6vgAQvQz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_01,2021-10-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 clxscore=1011 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120034
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal & Roman,

Thank you for your review.

On 10/12/21 12:21 AM, Michal Koutný wrote:
> Hello.
> 
> On Thu, Oct 07, 2021 at 08:16:03PM +0800, quanyang.wang@windriver.com wrote:
>> This is because that root_cgrp->bpf.refcnt.data is allocated by the
>> function percpu_ref_init in cgroup_bpf_inherit which is called by
>> cgroup_setup_root when mounting, but not freed along with root_cgrp
>> when umounting.
> 
> Good catch!
> 
>> Adding cgroup_bpf_offline which calls percpu_ref_kill to
>> cgroup_kill_sb can free root_cgrp->bpf.refcnt.data in umount path.
> 
> That is sensible.
> 
>> Fixes: 2b0d3d3e4fcfb ("percpu_ref: reduce memory footprint of percpu_ref in fast path")
> 
> Why this Fixes:? Is the leak absent before the percpu_ref refactoring?
Before this commit, percpu_ref is embedded in cgroup, it can be freed 
along with cgroup, so there is no memory leak. Since this commit, it 
causes the memory leak.
Should I change it to "Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime 
of cgroup_bpf from cgroup itself")"?
> I guess the embedded data are free'd together with cgroup. Makes me
> wonder why struct cgroup_bpf has a separate percpu_ref counter from
> struct cgroup...
> 
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -2147,8 +2147,10 @@ static void cgroup_kill_sb(struct super_block *sb)
>>   	 * And don't kill the default root.
>>   	 */
>>   	if (list_empty(&root->cgrp.self.children) && root != &cgrp_dfl_root &&
>> -	    !percpu_ref_is_dying(&root->cgrp.self.refcnt))
>> +			!percpu_ref_is_dying(&root->cgrp.self.refcnt)) {
>> +		cgroup_bpf_offline(&root->cgrp);
> 
> (You made some unnecessary whitespace here breaking indention :-)
Thanks for pointing it out. I will send a V2 to fix this.

Thanks,
Quanyang
> 
>>   		percpu_ref_kill(&root->cgrp.self.refcnt);
>> +	}
>>   	cgroup_put(&root->cgrp);
>>   	kernfs_kill_sb(sb);
>>   }
