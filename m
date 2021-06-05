Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591A839C560
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 05:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhFEDKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 23:10:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19750 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230414AbhFEDKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 23:10:31 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15535Zdf003965;
        Fri, 4 Jun 2021 20:08:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VXbecStRg8+ye1aGHhWtdKme9RQggxBhU1L4OsCc4+E=;
 b=dTk3eFRCx5De+Yn44h8wHVf7K5rU3VeQ1GiWe5IHz4rrHEFWI3rvi8aE1Fy1P5j9RKHU
 Lb3EFamztWPGkLWNZg2u53yTJq8YQnhfwyrF5buq7yP+V0CIC+TKVZ2SGrZRoWCyZ+yo
 yY3X3SqIZCyfYqpYlFrQhbIWDBoZO6lo30M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38xtex4nxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Jun 2021 20:08:26 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 20:08:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyiIE3n+xCFUlX2VwugQE+ZDNCgzDvG+mzQoGJ7pIPkS3NzD4SF86rO6tXXWUSDTsWUCD6Moz1wW5cMHs88hmOZJeSSZkHI+jtV0eDFS8LTfHBdFlsa9YuLCeTdvVoztsyBYIsc0t5+D1SFGE4fn4bUHCHvN7nMmkM8rPwT0hLk/OVrcB/ka67YoY6sv9Q4GPTHdWLSNgFH2TJJVNoXp7UM8ilT8gDTQwNQWE7MWxmqMzaoRp1NvWE2KO+oP5xooWzfCBj91zcEZXP/9wfYhhI4586vLPKxE3I9ESYRPjhbg13gl6r8OwVyBHOf7XWkk6QiTMPiM2m5ql72c1nWi1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXbecStRg8+ye1aGHhWtdKme9RQggxBhU1L4OsCc4+E=;
 b=gWSnDyXJKTLMsaatuDdDiPSlTIE4ZDle2izvjWu+3Hl2K3mQNF+2W8KHRMMzwwkMzucuIGmsD5TbxHKUXWDmYEFb4JQbm3YFzx3wtslP49QqGdp3P9Tk7d9oj8db/4NBhBbkg5byEABx2da5CtKK/H2XjyhnVI+MrOCWkFd4W3k0SeDCz/A0o1MRKputz7Q1Vl4gViTEZBBL//4wCM5Dyrm/3fOnciXuoftHK6p5R77n9fK/UZoPEnc5KijGQYuadelAmY3oC09F6W6IqoGWpHYuDhtbBa7Eyfxa51Wjt0CKfhLiLLNe37mA5o6vCOT62glqbCvSRE4sspcL4GUu9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2127.namprd15.prod.outlook.com (2603:10b6:805:2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Sat, 5 Jun
 2021 03:08:23 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.026; Sat, 5 Jun 2021
 03:08:22 +0000
Subject: Re: [PATCH bpf-next v2 3/7] net: sched: add bpf_link API for bpf
 classifier
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, <bpf@vger.kernel.org>
CC:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <netdev@vger.kernel.org>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-4-memxor@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <3fca958b-dcf3-6363-5f23-a2e7c4d16f87@fb.com>
Date:   Fri, 4 Jun 2021 20:08:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210604063116.234316-4-memxor@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2620:10d:c090:400::5:7ab8]
X-ClientProxiedBy: MW4PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:303:b8::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1a79] (2620:10d:c090:400::5:7ab8) by MW4PR03CA0196.namprd03.prod.outlook.com (2603:10b6:303:b8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Sat, 5 Jun 2021 03:08:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8da9e145-bfc9-4e62-3a97-08d927cf2d62
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2127:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB2127A97CBD2BE65117B03C01D33A9@SN6PR1501MB2127.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgkJuWytRZGgHT6auZuiVpZGEciFtx9oCS0JFJqhuQmP/+iS9QhvxeCWfBi3oy4wB9TD0CmZSfESZaS6jC81VqLnmj2Ef9tUiFc6D4IT+XBMMTCTeJykR6pRPikaB7gEl6FaNCN8JXU2kuFB/KPLsMFsrldz/ez6F2SffGpl3yy6+EBzgL6JMVy8KR7U6ewYFBrI/0GYmzlJhvLFMT/U2GiCRFgP6pSAexfM1g1LIZUQ7EHA7awiyarI5/i3qBbWmFARIrIX+JtpIWBUrycAYDpe6Zo3UzMzRYwuS4xOUsjn/pQo5EwVsuIaoUW5ZcrFqzoDgoDgRY2PBd5a6jZlIbuvM1StO6mslKE93zTeLolhHZMJsHhb/cXKKCLSFHJc//RLehWm90X9Z/Pamexur7yD749n1wBhrFebiFPCX8++CG4jCAMcAMF9sV+wklurD1DGplduTReeitzJDDX9/vbLrMelsD9rVSQ+rkiqWJoBgtM3LfyX6spZVIhe1vISwR35cKjWdh1ltfAiojbYZefBq+KKNgI6NbqpoD2wC9Cy7pxGIPK5rqrsKEd6dnLDLaXsJcNYOOGctgluZkJat5Sy6H1yucHZ5gGejp+McXaJxIWkorZnS3+zG6s5JkebJHpEQAb9bnfp4dh4vg1ETPMGh1+NDcucPiJQYBwqdaWIumFZaQAXZOq/+LyYeNoL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(316002)(36756003)(2616005)(7416002)(6486002)(31696002)(8936002)(86362001)(6666004)(5660300002)(52116002)(66476007)(8676002)(38100700002)(66946007)(53546011)(83380400001)(66574015)(478600001)(66556008)(54906003)(31686004)(186003)(16526019)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c0xVUU9tK0huYWhTQjhJM1ZqRTd6RjdLN0ZEcEVnZVJOWmNxbkNqbkpXd09j?=
 =?utf-8?B?azJybzY4YXNjYjJ6UU5ZQTdaSURvNGJSNXFTeEhQQ3V5c3FUSVpXSjVHZkNW?=
 =?utf-8?B?TlA2a25Qa2ZuVE5zK25kWVFJNmF3azRrbXgrWHp5K1lzS2k3eXlYUmhiVE9L?=
 =?utf-8?B?ZC85RGVETFJyc2ptbVFHcUNvV3ozZzNmd0dWODhJRDNUZGliM0UwTGZwd3Bp?=
 =?utf-8?B?OTQyb201THorckJtOFNGRXNyQnd5SFJ5Y2V3UDN2eWtPVjJLWUNEN0V6OUhH?=
 =?utf-8?B?OU1WcWxDeGxnYTBWaUE2Z01MT1I2eGFFeklvVENKOTRvcmxub2EyVmx3VWdP?=
 =?utf-8?B?ZFA1TkkyNUlVMTlWN1paT1YwZmQrOGtiMFByamhNU3hkdnA5TmlGUFhhRndw?=
 =?utf-8?B?Sm9MeDZuWklqZUp4UVplckpYV245QStVZm84MEJrYnpsVTFRRVFVSi96c3lj?=
 =?utf-8?B?MGhTZ2Fla3FWRDIrQnJMUjJ1c1FxbG80ZDB4SFo0TDBCYTJURDBuMDZmTmNa?=
 =?utf-8?B?TUhsZWhFaFNrbmZWVWJaTVpjMnozeUt4WXF5dGFjUG85bGMzei9RT0xFQUV4?=
 =?utf-8?B?UFIzZ1NDOSszem83QUZjVTB2aWROY0ZvVHVmeFIyM0h2SS9NeDN0ZWtmSURz?=
 =?utf-8?B?SHN0a2hJWHdsbjJNSlZab3BuOHF3cEkzV1NrelVqZXNGOS9YZ1dtVFQvUU00?=
 =?utf-8?B?bEsrRDlBMTdXOS9qdmYrakVtNUw2WXBzcGJDZkk3NUxGNUpIT1hSOC82WVVS?=
 =?utf-8?B?a05WOXc2ZUUyb2NYTkNEUEh1dXVqMVc0QXZKVWF3ekZxdE11UlNBOXlWT25u?=
 =?utf-8?B?YXlYWWh0bUxJV2lqWlUrbCs3aitHOS9GdnlDNDh3WlRCaFRFQVBlSWtpWWdo?=
 =?utf-8?B?akZiM1NwMDkyNmJEQlpjenJPaHZ6YVM0dkFySE90cFJodnRyeFdRMjNqZTlY?=
 =?utf-8?B?QlFKRkRzN282L3lVcW00YmVtYVpva3dHM1BTZTNoaHQvTnJ3WjJrSUdJYXcy?=
 =?utf-8?B?YmJkejR0aXlReCs3cTUzQWlBZjFKTlh5T2tyT201bi8zQWQ2ZjVGYWpSbUgr?=
 =?utf-8?B?ZXl0UVUzNkcxempHKzFUdHI1OXEyZ256SmEzZWpkYmRHaUtlVFJMSEFJUFp4?=
 =?utf-8?B?eVBBQnEzbmtUc1Q4L3V6Ly9SbVlYVVZsYk5NVGxMTjhuRjgvQnk5b0NzQU85?=
 =?utf-8?B?TU1GVXB0NXBkeVZmc3k3TGt5SUlnYllDTjlZTTY3UmY3VlU4WUVxYWVEZ0d3?=
 =?utf-8?B?Zzl5dDlkUVU5Ylp3dUorSEQvNUtsTHZnTXdOWkxIUTJSY3BsektzdFpNMXhU?=
 =?utf-8?B?djVGaDdIcXNGa0FQZXFuRTZSVTNwamVBZFJNd1BraUw3Nnd3UjQwQmFHMzZ4?=
 =?utf-8?B?WVJxa2I2clREMFlWdzJQanZmMkN5UHQvYThMRi8vVXB6Rlh0dFZFM2U4Q1or?=
 =?utf-8?B?d2ovRFM3ZnhJVXN0U3JLcG9NZ2RtRllNQ2hYb3pOaVA1NkIrNk9vaUw4SkdI?=
 =?utf-8?B?RGlZS3Z1MkFyQjZMZFBmaFBEaXJyN0VrM0h5L2N2b28xbUJ5RS9ldEVRRWlZ?=
 =?utf-8?B?aCtDS01ONkQ3V2dselcySm9JSExIRE9yWm5SejVJcjJDRE1YTURHRW1FdnpQ?=
 =?utf-8?B?Uk9PNS9rbVE5VTd3d2ZFdU5QVERyVHN6MmorcFBneXdiNkVORnNvZC9ZSTJT?=
 =?utf-8?B?NmxOZnlqTmtiMExvY0FwTkh4b2dlV1ZJZERWbExPSi9oK0NDZ1NPVDJiQ3d4?=
 =?utf-8?B?aFRIY3cwbmVsWkpDeTZUcjZBcVNSamc3bVVPTW9sVmQ3TkdGSXlobFN5SU9x?=
 =?utf-8?Q?zGR89zB8ZuWwM462j5JaJXy4MPLj9xpFLI5Ec=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da9e145-bfc9-4e62-3a97-08d927cf2d62
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 03:08:22.5070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzkJCzX/fJO1vBkj3P4g0z+0b2RzXsXLJNy3RovfYiodcpkqJHroiSEEIX7ZAlRq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2127
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: sJy7HeYqm28ZsTe8IGIjv-qtZNRKzMpo
X-Proofpoint-GUID: sJy7HeYqm28ZsTe8IGIjv-qtZNRKzMpo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-05_01:2021-06-04,2021-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 adultscore=0 mlxlogscore=999 malwarescore=0 impostorscore=0 phishscore=0
 mlxscore=0 bulkscore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106050020
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/3/21 11:31 PM, Kumar Kartikeya Dwivedi wrote:
> This commit introduces a bpf_link based kernel API for creating tc
> filters and using the cls_bpf classifier. Only a subset of what netlink
> API offers is supported, things like TCA_BPF_POLICE, TCA_RATE and
> embedded actions are unsupported.
> 
> The kernel API and the libbpf wrapper added in a subsequent patch are
> more opinionated and mirror the semantics of low level netlink based
> TC-BPF API, i.e. always setting direct action mode, always setting
> protocol to ETH_P_ALL, and only exposing handle and priority as the
> variables the user can control. We add an additional gen_flags parameter
> though to allow for offloading use cases. It would be trivial to extend
> the current API to support specifying other attributes in the future,
> but for now I'm sticking how we want to push usage.
> 
> The semantics around bpf_link support are as follows:
> 
> A user can create a classifier attached to a filter using the bpf_link
> API, after which changing it and deleting it only happens through the
> bpf_link API. It is not possible to bind the bpf_link to existing
> filter, and any such attempt will fail with EEXIST. Hence EEXIST can be
> returned in two cases, when existing bpf_link owned filter exists, or
> existing netlink owned filter exists.
> 
> Removing bpf_link owned filter from netlink returns EPERM, denoting that
> netlink is locked out from filter manipulation when bpf_link is
> involved.
> 
> Whenever a filter is detached due to chain removal, or qdisc tear down,
> or net_device shutdown, the bpf_link becomes automatically detached.
> 
> In this way, the netlink API and bpf_link creation path are exclusive
> and don't stomp over one another. Filters created using bpf_link API
> cannot be replaced by netlink API, and filters created by netlink API are
> never replaced by bpf_link. Netfilter also cannot detach bpf_link filters.
> 
> We serialize all changes dover rtnl_lock as cls_bpf API doesn't support the

dover => over?

> unlocked classifier API.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   include/linux/bpf_types.h |   3 +
>   include/net/pkt_cls.h     |  13 ++
>   include/net/sch_generic.h |   6 +-
>   include/uapi/linux/bpf.h  |  15 +++
>   kernel/bpf/syscall.c      |  10 +-
>   net/sched/cls_api.c       | 139 ++++++++++++++++++++-
>   net/sched/cls_bpf.c       | 250 +++++++++++++++++++++++++++++++++++++-
>   7 files changed, 430 insertions(+), 6 deletions(-)
> 
[...]
>   subsys_initcall(tc_filter_init);
> +
> +#if IS_ENABLED(CONFIG_NET_CLS_BPF)
> +
> +int bpf_tc_link_attach(union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +	struct net *net = current->nsproxy->net_ns;
> +	struct tcf_chain_info chain_info;
> +	u32 chain_index, prio, parent;
> +	struct tcf_block *block;
> +	struct tcf_chain *chain;
> +	struct tcf_proto *tp;
> +	int err, tp_created;
> +	unsigned long cl;
> +	struct Qdisc *q;
> +	__be16 protocol;
> +	void *fh;
> +
> +	/* Caller already checks bpf_capable */
> +	if (!ns_capable(current->nsproxy->net_ns->user_ns, CAP_NET_ADMIN))

net->user_ns?

> +		return -EPERM;
> +
> +	if (attr->link_create.flags ||
> +	    !attr->link_create.target_ifindex ||
> +	    !tc_flags_valid(attr->link_create.tc.gen_flags))
> +		return -EINVAL;
> +
[...]
