Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501903EA76F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237423AbhHLPV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 11:21:56 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:43201
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235728AbhHLPVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 11:21:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gd2DSywBEf8s3XzAX3l6sPOqfKfObk4/72K2jyGiIPHaLG4Dn1XL2H0R+vrroVLqLsUM7i5a3dVAwZuIKI1czswXd1kzcG142YLDhg7/59KdrdA8bC66TrrTtxekn5cJkM1f6urCZVtYbVPq591MyM+Jp1MuBg2KleOkhkHLeemcWu0FOn+AsoP35d/+MrbZ8dFQbcTgBNWNVHSL0LNpnzKYP6kQ4YjyMf3rE7vM4jvWN5KhvCyGS+B8+JJRGfWDkA/PS9CACofYqqQQR731nUYKXaDwYK2TZz3NI6In0syFD/3uGNiFVDBXn+RmVxxVCa1Nsd0N000UiMJuST9pcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx9GEx50wTkutt+H7Pq9dyV8as8N8dFEHOVR/Jvv+gk=;
 b=SqBKNyYWSzAubqGLdF5xCHT45CFG9taHyhFJUbLLwxLVmy60+4EuYzb2Jglthp6IunXTQ1eBv0ZsGZ5IssbM/VFMRMjsuICfSWO6WyjxUGuI8Q/qIecPqTe1SxFDnGRznJjCCTaFIO0pHhZEmynWaHDS6UKA9ADFJ1Ho0WNsckOy5rhNkne/TlRZuu5Q2NiI3VIZvMAE82WugTPz9z39yR14Hfz/IjT/vfiIRPhmtbSyrvr0GtWQVXxbw14gUuqK8cRsOD0BUvqbh2Du/EWu/YBDY+C6iJvaqQB+9Yr9yrRgJeLU9PxWwB8VYlVX5AdMpjQVswNTBKc8ALfLxYXL6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qx9GEx50wTkutt+H7Pq9dyV8as8N8dFEHOVR/Jvv+gk=;
 b=dJBXPlHCy+qKGi2+gVIwDpDpFC7IUTGhhvR5IUCElkWd2casPkPZHFrjJ5sKeMye61r2VStcdJAE+ytjw17/AmgxeSnNRv6X13d5uVYMp4N0aT79+ghhasgiW0HeQmUSc0OXW27FBU23N0m2npz4gIyR416Rk9yebCPmPhHUjWtAMO8tuJk88wNgWNzgaQiQ/ZNfUhaZmlcoKteoMTAGFWXifmMsc46EICgZhqxcwxuI3xz8z74Ynkoz+S7CGBsomG5ltkEgdYa4PpsSmZ/1wpXi2A58YOhkZ8odu7zfYaPP/VEdHKIwj0WIRLtxpqfId4Z+YaAK7BcQeEN82s1DFA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5518.namprd12.prod.outlook.com (2603:10b6:5:1b9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 12 Aug
 2021 15:21:29 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 15:21:29 +0000
Subject: Re: [PATCH net-next] net, bonding: Disallow vlan+srcmac with XDP
To:     Jussi Maki <joamaki@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>
References: <20210812145241.12449-1-joamaki@gmail.com>
 <d741b3f0-2c42-274a-21af-5bb55a1d9a1b@nvidia.com>
 <CAHn8xckhVO9NSAOghLbx9uu6MNdMGRJJ6HobZv_OV02FEB4_cw@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <d21c958f-95e7-1e3f-e5ac-a136121ae365@nvidia.com>
Date:   Thu, 12 Aug 2021 18:21:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAHn8xckhVO9NSAOghLbx9uu6MNdMGRJJ6HobZv_OV02FEB4_cw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.235] (213.179.129.39) by ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Thu, 12 Aug 2021 15:21:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a234a3de-e91a-483f-f53f-08d95da4dbab
X-MS-TrafficTypeDiagnostic: DM6PR12MB5518:
X-Microsoft-Antispam-PRVS: <DM6PR12MB551888AC4B87646971D2AB3DDFF99@DM6PR12MB5518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QoLvuSyGeYxEEQUmv5yzHYTUkqlkOLpMoG9bu+KAfQdjYAFv/n5QlWR8ftuWj+QKYBdI/IAN5If5nFMXYJ2zvPwnXSAOQYhYSRoat6r/0F+fsSEZYQEsyLbYVJ7BseCzukx6qYjM4yaE266KiYxf3ZfwEWE1OLhi4mVhEmM42sK09f31kcD8lqBcXOFbI5VepXkQ1pgS0RzGBoVdWMA+x1Kd+ll7KLkCt/HqJlxrRZqZzjzeNxzFKQ2S9JsJo8G1Blcdb6a2FXLgQQdnK+O82Ff9hDzSXqamVccs3M3XEmLpJi7EpT6z+muqDjSwKB+PjJtzA+wqHlbQ4uh0DiEeefthhQW884LGUio+eB5XTJBJBM+SQegtt7CTYWdpxiELXhPZolTjh8c4PC9aOv+U/wuC8eTtHi1jr4GPhTy6cgbTagOFtG91OWdn0d1Jg7zHY03Z+HPAtZo70rdcHhXupmXsN4q/51lctyG+8O0Xa71Ao0y7yOpQa+PmjzfBFd4lwE3an9DQWu+o2nTFZN6+9YsI8tt53x8BPHH5Aq4aTJ8fe4MWX/PpBqO3n+yqjCR/hFMT1D9WWuQgiglC4IXsjRZhRRN9WGQ2DE28IdkXhCKgOjCnqNhopbwjAuPaw1YkbXG38PHiXETj86OFDR4sXxTsqUugKSHDNIgjGBQcIbQz4N0/4wWUeCtR3rzWce8zLh0GwrvJ5XHELOgTT7mOF46quaGIY/NTmH8jXKQHebv9DYE3PejLj3+//WkpHudahb6MHUw+5p3zbdC0QgPVBZhCyq+X7P9cKnmDHmWqB/6YmqzsJZyCntygQF7WaNvA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(54906003)(26005)(38100700002)(6666004)(4326008)(5660300002)(956004)(966005)(316002)(36756003)(2906002)(66946007)(86362001)(66476007)(66556008)(16576012)(478600001)(31696002)(6486002)(31686004)(2616005)(8936002)(53546011)(186003)(6916009)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3ZTUWsxSHZyb1E1a0VmSm50Tmg4MWMvekpKY3ZaNW16WTBBeEFtSVJJU2pC?=
 =?utf-8?B?M2kvNzd1czhpK1RiZXU1bnptU200dDZENFA0QmJSQWZQQ0dyRzAyODJmSmZM?=
 =?utf-8?B?cklpT0N0dnZaQ0ZtbXFJSU52bmU0ZnFYS2xZanYzVDNBdzdKb1FhKytQelpj?=
 =?utf-8?B?WlM0VHdoaXhwdWNMWk5GUUpiWGQ0NDJ4TFphUTdwTHlMd2tkVHRlcFh1ZVlI?=
 =?utf-8?B?dUc3QlR5a0t3T1lKTmhvL0I5eGZ0YkEyN3RHUFpGM2dYcnRMbmo5TmdUS2d1?=
 =?utf-8?B?U0NVVEpyVjdlRTFQYVpsZEkyenNTWTFLVnNOTUtONkJZR3hjSW9QR0FhK1h6?=
 =?utf-8?B?c3RMUEJHYS9kYkgyRGJOQys3Tzl4b1kwL2Z2Z3lJRWEybHpDaDgyVmtYL2p4?=
 =?utf-8?B?RHN6TnhTbnYxZDVxRFFxQitkUHdvd3V6ZEUzV2ZaSCtwcko2ZEYxbndxUEVn?=
 =?utf-8?B?bDdDUjlhTTU2RitYdGhNVVVka3d5N203RW40dkVGTFhnNExzdEdJZ2xGN2l3?=
 =?utf-8?B?L1JMS0U3MEpCQ2N5ek94T3pkRmcrK2JlOHlhK01TMWdqRWpOYW1wc2tRVkFZ?=
 =?utf-8?B?cDArUVlGWUJBT25YNlVmUGMxaWlNcHJBR1E0eVVHYWZEUDNvcFAySGt4TXpk?=
 =?utf-8?B?MS9lTzJXSEdjV3ZmK1BGS2tNa1FxYy9PUkxndVYvNnZVSzdJMW54VTE5VkhO?=
 =?utf-8?B?YkhkSXA2QlUzU0Y1UFJPRHpURjQ5cEpxTWIydWlibWg5YUswZTluZEtDbDho?=
 =?utf-8?B?a2lteWNOcW5CTjVVejFKd2oweUJlMUZIUUpBdy9oZXdCQzczdGZTaFZobzRP?=
 =?utf-8?B?UDdKOFJ4Zkk1aHNVZE9VWHR6Zk80bTR3T3FySUxTTzZaVHRkWnliNXY4K0Iw?=
 =?utf-8?B?clU1YVo3a21xZ1dtWWNURnhFaWpaZ2o4NEFhYnpDTXk1NlJWRzN5a2ZGT2di?=
 =?utf-8?B?NFRuNnpvUTRUWDQ5TzJ1anVHWTdrd1pNOGVObm0rc2lxNVF2MGE5cm05OXpO?=
 =?utf-8?B?dW9nc0ZxNHBVY2hodWhGb0ZHRm4wbFRKZFh0Mld0Z3Zaa0NOWm9nd1ZsaWVZ?=
 =?utf-8?B?MG0ySWdMcDh1N09FSmI3Q1lxK3VCdWlBdzMzbDhvUmZ5QVRjeG52ZDhDQTdI?=
 =?utf-8?B?REtXZEFRMUhlSTYrWVhkUEZwRnJlTlpNZDg0dFNlTU9WZU9vdGYvY1I1emxE?=
 =?utf-8?B?UWV0cFFZcnNnQUtoenk2Y1VRUmNFZmZ1L2xYUXExem12bkV3TmtGNmdDVG5O?=
 =?utf-8?B?S2swVUNFbFhuNDNZNWVvUHE3ZzRFWm16anFWSGhpQ25LOW9zU3Vyam04VlB5?=
 =?utf-8?B?ZlRNRUw2bVZhMHV4SStyNzZISnlyWEQrbE9TOWRFK1pPTUZNL3ZSWExwQTdh?=
 =?utf-8?B?cDNkUU1Lc2s0bHpCaDZTU3U4L2R6U0cycWFuVG5QYzBSSGlMd3hvajdtSXVt?=
 =?utf-8?B?ZWJXcDNtRHJkdTU1M2tjc2luTmVtVURHaWJ1NEdiL2ZEQU90Q095UG1HNUND?=
 =?utf-8?B?dW9QVE9IZmIxK09ncUs1UnFOeStydmdvS3RnUTZCcHVRWksrcGx5K2dJdjRw?=
 =?utf-8?B?d2pXK2NjcVg4NmwxUWtOdmZ0a2VZQk5Zb2xndy9ZK3A1a3JxZjN4RGd4Zlpk?=
 =?utf-8?B?VEpBVFk0TGE4cXhHUTFFN0psQ05UM2Q0R25pOTRBVGZLbCt0RHN5ZmdFckxv?=
 =?utf-8?B?S0t5b1JJSDIxR2EwemZ3emhDU25nRSt4dGtXakE0eHdWR1NXb3FtcE9YWUtN?=
 =?utf-8?Q?qZLBNF7fDupF+P7yT8ahj0sF2xjKusyIGExUV/z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a234a3de-e91a-483f-f53f-08d95da4dbab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 15:21:29.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u4xBnhwhk4yP9jHF+Ma5AMEib2wY7yWaBuHUik89ACJs4Hb/1e8ezWy8ejwTHvNGxtzTwg8+PMIv/RvQD7OMdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5518
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/08/2021 18:12, Jussi Maki wrote:
> On Thu, Aug 12, 2021 at 5:01 PM Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>> Hi Jussi,
>> Could you please share the null ptr deref trace?
>> I'm curious how we can get a null skb at that point.
> 
> Hi Nik, this was reported by Jonathan here:
> https://lore.kernel.org/bpf/20210728234350.28796-1-joamaki@gmail.com/T/#m07a73b1886a9213feb7112ce2a0d6dfde84fd27a.
> I didn't reproduce the null ptr deref as it was fairly obvious how it
> can happen, e.g. by having a bond with xmit_policy=vlan+srcmac. The
> hashing functions were refactored to be used for both xdp_buff and
> skbuff uses and the skb pointer became optional (was meant to be used
> when packet was non-linear), but I missed fixing the vlan hashing
> function. Partially the reason leading to this was that the
> xmit_policy is very new and the bpf vmtest infra still uses an older
> iproute2 version which didn't support it, so this was untested. What
> is not tested is broken as usual.
> 
>> Also how are the xdp and null ptr deref changes related ?
> 
> They're related in that looking into the null ptr deref here I
> realized that vlan+srcmac didn't make sense with XDP since we have no
> guarantee that the vlan id is in the ethernet header. So this patch
> both fixes the deref by checking the skb pointer for NULL and it
> disallows the whole xmit policy for XDP for the aforementioned reason.
> 
> Hope this makes sense.
> 

Oh, I had totally missed the bond xdp patch-set, all makes sense now.

Thanks,
 Nik



