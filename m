Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160E53138FC
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 17:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbhBHQLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 11:11:46 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35008 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbhBHQLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 11:11:20 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118G5hkS115071;
        Mon, 8 Feb 2021 16:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=B3kdL79sexcCiph+SXBE3C0x6f72f7gYXLZnM4D9gPk=;
 b=R7iqv/9zc7+kX2y6290By93hAUBNsKew0n3LxO9ErBJTRwp+AQ3A5jlvXt6bovSGotlF
 PMHXXx1vrImLFIQmpDgcEWc6X6obEORpQ7w0+7LQ3ps3CXKudS+xJhLPky4zK0vINuYV
 1gmiMoSLerNON6YgEwVgNjdMJkIaPocoD4pUBK9PpmFAys/HhSQUvjyGh9OEZRn7aiXp
 QXCg1FE1sDnwFMOuf0ORkO96YkX+r5nQ79njeB/+1vReTjbQY/p0gTDWFNuUuNtfgJMQ
 LcXCb/hL/f879odKguvGIGIpj6MbuJQz6mmk6lLF607AbKkyhyZfKkwUlK2pqu9gwuEt LQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36hkrmvc7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 16:10:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118G9rR7066237;
        Mon, 8 Feb 2021 16:10:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by aserp3030.oracle.com with ESMTP id 36j4pmhjxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 16:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtZN+4SZYgZ6Q6snewcnhKmnAS8Qd/s11jnTvDHFoXEobltSlEyituCjruTOHgtDa1M2k5QjOcOnQ1R5aOCmDsHtdgLPRCOr/Ehk86yJ/JheSJIz+qdmzE+R90sL+tLVAdBw0f5tTyK3DkC2h38ZpvM+rPVHIBodwqWhhrstdui6AbV2vLoWOqMqukZa75Kccgo+U8WbnyyGNnxRlXONe9xSiPOVvO5lJu/+zgkVSsjO1M7KSKOwXIdXahR8Mi6cQZanbwZO5cLTkBN491rsmQsMCT/3hZSpkw3IxtudjU4wLpFLHkAao/mZdhpFydppS4+2o00xWmp8YWcc62j+iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3kdL79sexcCiph+SXBE3C0x6f72f7gYXLZnM4D9gPk=;
 b=YOeT+4eYHECun3ehVz/ZXCB8j3Agl1n3nIDrMOEqHTSSheGebS4nqyNOsKFipjz+jvMUq4v4xkaj9Y/pZOAn/9Jgwv7wji+smxs0yzyJ17uWgLXKFfZimfJd3U4V4jIhwH5ZzV0CsF0s9oMabj4/THPI/jw88Rmnd6cREHxTmO1OwDS4bj6etjGdjMlOhDizQnrVNHFwWhEK7+cZsJCIgmix5FsETOgBhsCrwjeCxm5jT5iVEER7KlMVqabD/VUFJ5CGqJ53wtsXuKnoHDL++xoHNtCUIBWwbdHUqZEaGA4UUJ+FSL5p75PH/dtM3gONHvdX3gwzoE+yqpR4kGbNAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3kdL79sexcCiph+SXBE3C0x6f72f7gYXLZnM4D9gPk=;
 b=BkCEwLmY6WyiNyVtAF8hhwpnjCPz9e1cLksxXFTrSX4LHtphx+8qikAeUJMbx0q7quWZLfsvO5H6AulLicqqoe75aKqEwZ9SJ1/v3Vd0DfbsFBQ0VofSEuAAj7JVXIH/FL1+2YYDvH0vBB8MP7CtBMXO8cmC3ATrjiFSsknrLIw=
Received: from CY4PR10MB1717.namprd10.prod.outlook.com (2603:10b6:910:c::16)
 by CY4PR1001MB2071.namprd10.prod.outlook.com (2603:10b6:910:3f::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Mon, 8 Feb
 2021 16:10:24 +0000
Received: from CY4PR10MB1717.namprd10.prod.outlook.com
 ([fe80::96d:fd40:560c:3b0e]) by CY4PR10MB1717.namprd10.prod.outlook.com
 ([fe80::96d:fd40:560c:3b0e%11]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 16:10:24 +0000
Subject: Re: [vdpa_sim_net] 79991caf52:
 net/ipv4/ipmr.c:#RCU-list_traversed_in_non-reader_section
To:     Dongli Zhang <dongli.zhang@oracle.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        lkp@intel.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com, aruna.ramakrishna@oracle.com
References: <20210207030330.GB17282@xsang-OptiPlex-9020>
 <3f5124a2-6dab-6bf0-1e40-417962a45d10@oracle.com>
From:   Joe Jin <joe.jin@oracle.com>
Message-ID: <ebd163a2-c8a8-2cb5-b46f-b0e5346c6685@oracle.com>
Date:   Mon, 8 Feb 2021 08:10:21 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <3f5124a2-6dab-6bf0-1e40-417962a45d10@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2601:646:c601:8dd0:b10f:9496:f02d:f7ab]
X-ClientProxiedBy: SJ0PR03CA0184.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::9) To CY4PR10MB1717.namprd10.prod.outlook.com
 (2603:10b6:910:c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2601:646:c601:8dd0:b10f:9496:f02d:f7ab] (2601:646:c601:8dd0:b10f:9496:f02d:f7ab) by SJ0PR03CA0184.namprd03.prod.outlook.com (2603:10b6:a03:2ef::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 16:10:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fc1382b-9ead-4e6b-6d52-08d8cc4c0aa6
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2071:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2071A157767A84E1B28143F5808F9@CY4PR1001MB2071.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5rqKb0Ud0RLG5xv38rS59UeDI0Axo+wYp1847NUskkqrsvvyUcBef5ptjTrqb4X/oABYZg9Fibk98KIXbAl2O3Jss2kFM2w3T3xHL/dtmt80xtAvATadCQyDoJKeQeRSYEtvkGdDwM+sm/9DK8R6mvzi0ie/Oma81XagpmfO4NVHL8Ho4yo29A/LbOtp6uByCOb3l8GNNePKOD1GDqB1FcvBFmp+g7WwjvFtZR6oJbygh76vrPzTYRJXPB6U0JPl97+6qCXkrvGzkv2T8reUBf8wsWkCJNy0OvgD4/jBRuc2HOhr+UKJBtQxdQSKF4yZXnRUbtHprgv12SN43vIk7R7YxgdH589gDIpIdR9ozPM1vt9N1VCr2cjK4fnhK+LWXGzAD2Tu+bbD+yK9Vb/rF4NdtZtD16LVw0WZTV+AcBxrXszPXEwPOEBGsd1/9m48jQw+3A/0OmRTFCojqvNoQHrhMJTRJTigS9N1ChZw2mQLwTDqI6jnQTiL15uhYqW8b26/pZEdg6blK6yppga09qxcrh2AmrEk5OcRLEEpDMgaWz/JUlO3zB9gwnfQs/kCVvHZe7wZOkTvzdhO9BXhlh5xEKxypIKqCYssa2jO1P7pZbLGnH862CzPYnGakYJCV+gvcbw0sdE6C7v+EnFoc2XEBsCLm3vD1D6Vec0pX1yUh/T8ab9lxb07l0xk1500
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1717.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(346002)(39860400002)(4326008)(2906002)(66556008)(31686004)(107886003)(966005)(66946007)(16526019)(54906003)(31696002)(8936002)(36756003)(5660300002)(316002)(66476007)(45080400002)(53546011)(186003)(86362001)(110136005)(6486002)(2616005)(478600001)(8676002)(7416002)(44832011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Ylh4dlZZYTBwcTZCTjV6RS9JUk0zd0RTY05MNmJEK1VaTm40L016a2RJRk1x?=
 =?utf-8?B?NklORkgyZ1FKTG91M08ybjhGRDNNSGptZGFidU5RdVhUUFFnMnEyYVJSNEhn?=
 =?utf-8?B?T1hpcGQ5MXExMWZISUFQckxDaEpRa3p1L3U3YkZuZXFWbS9qd2lNM001UzdO?=
 =?utf-8?B?WkgydjVtb3lkZ2NMM2dMcFZJUEorZ0RvUVBCZnZxYkQreXNPUzZBWTJXVlR0?=
 =?utf-8?B?T0R2U0M5SXd5am1iYzljR2YrSHJIQ3IwaUpTK2E2eWNqZ2F5VFhrWWcrSUFy?=
 =?utf-8?B?c1dkU3Y2c3I5SnVPNlJhc0EvNVlXRkZMaERMY2hya1NxMEJSdDloNTBoTGZB?=
 =?utf-8?B?UlVGbGlIU3JEclBOeG1uMS90TmdFc3BEeXhNOXl3WmJ3OEpwcC9ucG90dmQx?=
 =?utf-8?B?ODdoV013RU5IQlhKOTFqMWVpUUhvcjlOL1RZTm1meVk1Y1R3WWxYS1I0MFc3?=
 =?utf-8?B?WXpycklKQVlneW9ndnkwUlhRdFo0RGhIYzA4OFJGc0pQRVd3elJteUQwN294?=
 =?utf-8?B?dWVlMEJ6c3ZlM0JVWmJ0SkRzR3JQSngvSmdmMTkrSklWYllmVkFtMFpnUk1p?=
 =?utf-8?B?UVZ0aE93ZTR5NWkySE4yVERpOElsalhpcVNEODFqRjBjUWZZQkMzSkNkVXZy?=
 =?utf-8?B?Tk41YkhKKytuZUFxdmI3K2cwVlBsN0cyWDU3bGx1OWNRTlp2RXdUUE0rMXhT?=
 =?utf-8?B?VG00SjhNUUJoQkpYSXhELzhxZ0gwUDlmWi9CY1hBQ2VRUUM4UUJPRWEyK0ZD?=
 =?utf-8?B?RGc5djY0QWx4U1JZWlNzb3RibnZrdEJCTURPcEVDQXM5ajNCTkpDaW9JMHRU?=
 =?utf-8?B?WURFNmozVUtVYWhjVzNYNXB3cldWM0Y5eXZQcmdqTkpmS1VlQ0kwZDFEVEt1?=
 =?utf-8?B?R0g0eGZwSURrMlNMd3NSWWl4VjdYTWVMNnM0NU1CN3NPcFlBNUFnNUY1ZTF6?=
 =?utf-8?B?RDkxRFBqbndCR0NmT01CUW1DMW5QclpvMDFvZ3JhczJGMHI4c1cwcXNxVTFD?=
 =?utf-8?B?ejdPRGk2dGxHRG5UU1hsOGM4YUhOV2k1NzJzd0dTSWxrWmREY25ZdVB5R2U3?=
 =?utf-8?B?Y3M0blljczhqN1JqeW9paFp4VE02RDRNaklKQTMzQkJYLzd4R1YwZnZRTzlR?=
 =?utf-8?B?eDE1Z01TdUxNTTlrRkZtOUw2Y2NBUE1FMnF0TnBmUHM5bE5LMXBETEQwVWRo?=
 =?utf-8?B?NUdSdkZubW9rbktVZ0grQzJ4Ulp2dVBpSkJEZTloMU9ESUZRYnNvTXlFaFc3?=
 =?utf-8?B?b2xvMUpsTGQ1bUVJUUNOUU0rNFJKblFQWG5zOStYenFUZTVJVmxNT0FxSEk5?=
 =?utf-8?B?R1ZWNEhaYTNOSmFmYXEzeHpuQzdaRDNMeG1iRmpvb0xpaSttWDF5ZWhoWDN6?=
 =?utf-8?B?dG1RaTlyTllVcG9SbThVeTN3eTEzdExuY1FjbWt6U2JlQWtjSSthZkVucUJu?=
 =?utf-8?B?cHhFU1o4MkNQVFQwUllLVENsVVBHdVBQS0paWXo2RHNaK3diRENRRUZ5cGEx?=
 =?utf-8?B?MmVyTHRNQmJyTmxJc1E2YW9XdmFiZ1ZqSitXdGprb2h0QzdyQk9zSzdKaEh0?=
 =?utf-8?B?bDBPS29ZdklXdDNrMUpFck9vcTRVK25hbmgyMU5vN2puY2JaTXNoTDBSWS91?=
 =?utf-8?B?d1lFdldtaS9mOFNJQ0QvbFcxTzVKdVVEalY2M3pnTm11YnR0blBmVEkxOTE1?=
 =?utf-8?B?TzN6VkllaHJpaE53UUhuWjM3WnRzTExRK0JTRG42VFhmV2VmUVRiSmhES3ha?=
 =?utf-8?B?aW9nZVdpcHhVZHkxcS9NY01tbWs5ZVE1MEdnWDAwUU9Bd2hCZFVTeUFBSjZY?=
 =?utf-8?B?c2Z1eEo1aGc2emhNRDBrTGxJUC9yOFU5SFNDMmRsUVhaY05SOWxmelVieGI0?=
 =?utf-8?Q?acrHINSDYjp2W?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc1382b-9ead-4e6b-6d52-08d8cc4c0aa6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1717.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 16:10:24.3544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5b9rw1RtliC7Tqu1rRDZ6NyVi1EjTL3FRtijJFR+Er2OBS0kR3U09iBZRgpz6VzQzq4JVcl4Sr5/VOz2Z9VYGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2071
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080106
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/21 12:15 PM, Dongli Zhang wrote:
> Is it possible that the issue is not due to this change?

Looks this issue does not related your change, from dmesg output, when issue occurred, virtio was not loaded:

[  502.508450] ------------[ cut here ]------------
[  502.511859] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/vkms/vkms_crtc.c:21 vkms_vblank_simulate+0x22a/0x240
[  502.524018] Modules linked in:
[  502.539642] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.11.0-rc4-00008-g79991caf5202 #1

>
> This change is just to call different API to allocate memory, which is
> equivalent to kzalloc()+vzalloc().
>
> Before the change:
>
> try kzalloc(sizeof(*vs), GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
>
> ... and then below if the former is failed.
>
> vzalloc(sizeof(*vs));
>
>
> After the change:
>
> try kmalloc_node(size, FP_KERNEL|GFP_ZERO|__GFP_NOWARN|__GFP_NORETRY, node);
>
> ... and then below if the former is failed
>
> __vmalloc_node(size, 1, GFP_KERNEL|GFP_ZERO, node, __builtin_return_address(0));
>
>
> The below is the first WARNING in uploaded dmesg. I assume it was called before
> to open /dev/vhost-scsi.
>
> Will this test try to open /dev/vhost-scsi?
>
> [    5.095515] =============================
> [    5.095515] WARNING: suspicious RCU usage
> [    5.095515] 5.11.0-rc4-00008-g79991caf5202 #1 Not tainted
> [    5.095534] -----------------------------
> [    5.096041] security/smack/smack_lsm.c:351 RCU-list traversed in non-reader
> section!!
> [    5.096982]
> [    5.096982] other info that might help us debug this:
> [    5.096982]
> [    5.097953]
> [    5.097953] rcu_scheduler_active = 1, debug_locks = 1
> [    5.098739] no locks held by kthreadd/2.
> [    5.099237]
> [    5.099237] stack backtrace:
> [    5.099537] CPU: 0 PID: 2 Comm: kthreadd Not tainted
> 5.11.0-rc4-00008-g79991caf5202 #1
> [    5.100470] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.12.0-1 04/01/2014
> [    5.101442] Call Trace:
> [    5.101807]  dump_stack+0x15f/0x1bf
> [    5.102298]  smack_cred_prepare+0x400/0x420
> [    5.102840]  ? security_prepare_creds+0xd4/0x120
> [    5.103441]  security_prepare_creds+0x84/0x120
> [    5.103515]  prepare_creds+0x3f1/0x580
> [    5.103515]  copy_creds+0x65/0x480
> [    5.103515]  copy_process+0x7b4/0x3600
> [    5.103515]  ? check_prev_add+0xa40/0xa40
> [    5.103515]  ? lockdep_enabled+0xd/0x60
> [    5.103515]  ? lock_is_held_type+0x1a/0x100
> [    5.103515]  ? __cleanup_sighand+0xc0/0xc0
> [    5.103515]  ? lockdep_unlock+0x39/0x160
> [    5.103515]  kernel_clone+0x165/0xd20
> [    5.103515]  ? copy_init_mm+0x20/0x20
> [    5.103515]  ? pvclock_clocksource_read+0xd9/0x1a0
> [    5.103515]  ? sched_clock_local+0x99/0xc0
> [    5.103515]  ? kthread_insert_work_sanity_check+0xc0/0xc0
> [    5.103515]  kernel_thread+0xba/0x100
> [    5.103515]  ? __ia32_sys_clone3+0x40/0x40
> [    5.103515]  ? kthread_insert_work_sanity_check+0xc0/0xc0
> [    5.103515]  ? do_raw_spin_unlock+0xa9/0x160
> [    5.103515]  kthreadd+0x68f/0x7a0
> [    5.103515]  ? kthread_create_on_cpu+0x160/0x160
> [    5.103515]  ? lockdep_hardirqs_on+0x77/0x100
> [    5.103515]  ? _raw_spin_unlock_irq+0x24/0x60
> [    5.103515]  ? kthread_create_on_cpu+0x160/0x160
> [    5.103515]  ret_from_fork+0x22/0x30
>
> Thank you very much!
>
> Dongli Zhang
>
>
> On 2/6/21 7:03 PM, kernel test robot wrote:
>> Greeting,
>>
>> FYI, we noticed the following commit (built with gcc-9):
>>
>> commit: 79991caf5202c7989928be534727805f8f68bb8d ("vdpa_sim_net: Add support for user supported devices")
>> https://urldefense.com/v3/__https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git__;!!GqivPVa7Brio!LfgrgVVtPAjwjqTZX8yANgsix4f3cJmAA_CcMeCVymh5XYcamWdR9dnbIQA-p61PJtI$  Dongli-Zhang/vhost-scsi-alloc-vhost_scsi-with-kvzalloc-to-avoid-delay/20210129-191605
>>
>>
>> in testcase: trinity
>> version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
>> with following parameters:
>>
>> 	runtime: 300s
>>
>> test-description: Trinity is a linux system call fuzz tester.
>> test-url: https://urldefense.com/v3/__http://codemonkey.org.uk/projects/trinity/__;!!GqivPVa7Brio!LfgrgVVtPAjwjqTZX8yANgsix4f3cJmAA_CcMeCVymh5XYcamWdR9dnbIQA-6Y4x88c$ 
>>
>>
>> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
>>
>> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
>>
>>
>> +-------------------------------------------------------------------------+------------+------------+
>> |                                                                         | 39502d042a | 79991caf52 |
>> +-------------------------------------------------------------------------+------------+------------+
>> | boot_successes                                                          | 0          | 0          |
>> | boot_failures                                                           | 62         | 57         |
>> | WARNING:suspicious_RCU_usage                                            | 62         | 57         |
>> | security/smack/smack_lsm.c:#RCU-list_traversed_in_non-reader_section    | 62         | 57         |
>> | security/smack/smack_access.c:#RCU-list_traversed_in_non-reader_section | 62         | 57         |
>> | BUG:workqueue_lockup-pool                                               | 33         | 40         |
>> | BUG:kernel_hang_in_boot_stage                                           | 6          | 2          |
>> | net/mac80211/util.c:#RCU-list_traversed_in_non-reader_section           | 23         | 15         |
>> | WARNING:SOFTIRQ-safe->SOFTIRQ-unsafe_lock_order_detected                | 18         |            |
>> | WARNING:inconsistent_lock_state                                         | 5          |            |
>> | inconsistent{SOFTIRQ-ON-W}->{IN-SOFTIRQ-W}usage                         | 5          |            |
>> | calltrace:asm_call_irq_on_stack                                         | 2          |            |
>> | RIP:lock_acquire                                                        | 2          |            |
>> | RIP:check_kcov_mode                                                     | 1          |            |
>> | RIP:native_safe_halt                                                    | 2          |            |
>> | INFO:rcu_sched_self-detected_stall_on_CPU                               | 2          |            |
>> | RIP:clear_page_rep                                                      | 1          |            |
>> | WARNING:at_drivers/gpu/drm/vkms/vkms_crtc.c:#vkms_vblank_simulate       | 9          | 7          |
>> | RIP:vkms_vblank_simulate                                                | 9          | 7          |
>> | RIP:__slab_alloc                                                        | 3          | 3          |
>> | RIP:__do_softirq                                                        | 2          |            |
>> | RIP:console_unlock                                                      | 6          | 3          |
>> | invoked_oom-killer:gfp_mask=0x                                          | 1          |            |
>> | Mem-Info                                                                | 1          |            |
>> | RIP:vprintk_emit                                                        | 1          |            |
>> | RIP:__asan_load4                                                        | 1          |            |
>> | kernel_BUG_at_kernel/sched/core.c                                       | 0          | 1          |
>> | invalid_opcode:#[##]                                                    | 0          | 1          |
>> | RIP:sched_cpu_dying                                                     | 0          | 1          |
>> | WARNING:possible_circular_locking_dependency_detected                   | 0          | 1          |
>> | Kernel_panic-not_syncing:Fatal_exception                                | 0          | 1          |
>> | net/ipv4/ipmr.c:#RCU-list_traversed_in_non-reader_section               | 0          | 8          |
>> | RIP:arch_local_irq_restore                                              | 0          | 1          |
>> | RIP:idr_get_free                                                        | 0          | 1          |
>> | net/ipv6/ip6mr.c:#RCU-list_traversed_in_non-reader_section              | 0          | 2          |
>> +-------------------------------------------------------------------------+------------+------------+
>>
>>
>> If you fix the issue, kindly add following tag
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>>
>>
>> [  890.196279] =============================
>> [  890.212608] WARNING: suspicious RCU usage
>> [  890.228281] 5.11.0-rc4-00008-g79991caf5202 #1 Tainted: G        W
>> [  890.244087] -----------------------------
>> [  890.259417] net/ipv4/ipmr.c:138 RCU-list traversed in non-reader section!!
>> [  890.275043]
>> [  890.275043] other info that might help us debug this:
>> [  890.275043]
>> [  890.318497]
>> [  890.318497] rcu_scheduler_active = 2, debug_locks = 1
>> [  890.346089] 2 locks held by trinity-c1/2476:
>> [  890.360897]  #0: ffff888149d6f400 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xc0/0xe0
>> [  890.375165]  #1: ffff8881cabfd5c8 (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0xa0/0x9c0
>> [  890.389706]
>> [  890.389706] stack backtrace:
>> [  890.416375] CPU: 1 PID: 2476 Comm: trinity-c1 Tainted: G        W         5.11.0-rc4-00008-g79991caf5202 #1
>> [  890.430706] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>> [  890.444971] Call Trace:
>> [  890.458554]  dump_stack+0x15f/0x1bf
>> [  890.471996]  ipmr_get_table+0x140/0x160
>> [  890.485328]  ipmr_vif_seq_start+0x4d/0xe0
>> [  890.498620]  seq_read_iter+0x1b2/0x9c0
>> [  890.511469]  ? kvm_sched_clock_read+0x14/0x40
>> [  890.524008]  ? sched_clock+0x1b/0x40
>> [  890.536095]  ? iov_iter_init+0x7c/0xa0
>> [  890.548028]  seq_read+0x2fd/0x3e0
>> [  890.559948]  ? seq_hlist_next_percpu+0x140/0x140
>> [  890.572204]  ? should_fail+0x78/0x2a0
>> [  890.584189]  ? write_comp_data+0x2a/0xa0
>> [  890.596235]  ? __sanitizer_cov_trace_pc+0x1d/0x60
>> [  890.608134]  ? seq_hlist_next_percpu+0x140/0x140
>> [  890.620042]  proc_reg_read+0x14e/0x180
>> [  890.631585]  do_iter_read+0x397/0x420
>> [  890.642843]  vfs_readv+0xf5/0x160
>> [  890.653833]  ? vfs_iter_read+0x80/0x80
>> [  890.664229]  ? __fdget_pos+0xc0/0xe0
>> [  890.674236]  ? pvclock_clocksource_read+0xd9/0x1a0
>> [  890.684259]  ? kvm_sched_clock_read+0x14/0x40
>> [  890.693852]  ? sched_clock+0x1b/0x40
>> [  890.702898]  ? sched_clock_cpu+0x18/0x120
>> [  890.711648]  ? write_comp_data+0x2a/0xa0
>> [  890.720243]  ? __sanitizer_cov_trace_pc+0x1d/0x60
>> [  890.729290]  do_readv+0x111/0x260
>> [  890.738205]  ? vfs_readv+0x160/0x160
>> [  890.747154]  ? lockdep_hardirqs_on+0x77/0x100
>> [  890.756100]  ? syscall_enter_from_user_mode+0x8a/0x100
>> [  890.765126]  do_syscall_64+0x34/0x80
>> [  890.773795]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [  890.782630] RIP: 0033:0x453b29
>> [  890.791189] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 84 00 00 c3 66 2e 0f 1f 84 00 00 00 00
>> [  890.810866] RSP: 002b:00007ffcda44fb18 EFLAGS: 00000246 ORIG_RAX: 0000000000000013
>> [  890.820764] RAX: ffffffffffffffda RBX: 0000000000000013 RCX: 0000000000453b29
>> [  890.830792] RDX: 000000000000009a RSI: 0000000001de1c00 RDI: 00000000000000b9
>> [  890.840626] RBP: 00007ffcda44fbc0 R08: 722c279d69ffc468 R09: 0000000000000400
>> [  890.850366] R10: 0098d82a42c63c22 R11: 0000000000000246 R12: 0000000000000002
>> [  890.860001] R13: 00007f042ae6f058 R14: 00000000010a2830 R15: 00007f042ae6f000
>>
>>
>>
>> To reproduce:
>>
>>         # build kernel
>> 	cd linux
>> 	cp config-5.11.0-rc4-00008-g79991caf5202 .config
>> 	make HOSTCC=gcc-9 CC=gcc-9 ARCH=x86_64 olddefconfig prepare modules_prepare bzImage
>>
>>         git clone https://urldefense.com/v3/__https://github.com/intel/lkp-tests.git__;!!GqivPVa7Brio!LfgrgVVtPAjwjqTZX8yANgsix4f3cJmAA_CcMeCVymh5XYcamWdR9dnbIQA-Qkr9TyI$ 
>>         cd lkp-tests
>>         bin/lkp qemu -k <bzImage> job-script # job-script is attached in this email
>>
>>
>>
>> Thanks,
>> Oliver Sang
>>

