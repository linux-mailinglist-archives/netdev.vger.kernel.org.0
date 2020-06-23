Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB1C2066C1
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388761AbgFWV7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:59:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14164 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387558AbgFWV7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 17:59:20 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NLi2oq031722;
        Tue, 23 Jun 2020 14:59:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=szC+AB8as0sMRwBt/YtbrVDSjzCaLXzwBH9NgvoizQc=;
 b=Yupy1dzWowuTbACFBq++n38dMXAGuckQMr6S6LCPPOwFKbDMR201tAIopjUb8QA29zug
 pmY9qVbttYS1Ss0P1YGVpjZUAyc6roOEjWdd2fGxGqx7ddLOjQReKBbF6LhiYzxWuii9
 mu0NcvAOYTCM8KvWhr3FIgjUvJv+4PuETF4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk1qtex1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 14:59:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 14:59:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0wgcR9B2uED4y2cMP9ZTLZiuRuPIN4ZJHmQoOdeZAlhKEMRXWHY8ZJGi2s0GsRyBtk5RbSDIYMJPfSuqVjPTzF/5J/pHdsz+5scyrjnA9H8cY7E70c6Uyc+igzNbLfQEavr+K5Ljdepyyk9kMBG+K1OTQWKBZ9b6CITF+3VBGNCVGWK4sczO9JHsWU0MCFyIU6k3Rk0v8S02XRLza1fSaT2ZvnEljpkEP1LS176BaPHaM9PextAg2K0kMq4HkK1Dkc97vtW+dwtFYemWG94HlA2w8i9ujCCW7ficea6sS1Uo4fbFegmfeGjlsUZchtGH0c132FJoHCMq+EofpXHHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szC+AB8as0sMRwBt/YtbrVDSjzCaLXzwBH9NgvoizQc=;
 b=O5WRTHfq7p9sj4tJ610yEBz9pM6K7wMiT7OPVSqzaxqBmoxtp8C85T+n2cVPdwrW5xdj/cy0EwDxP6hXwOZeSpRARkbGN5R608mPP4McbcAuE+DokJLsYabOzNNT7Nqy6YQ+AckAcbuNPqBxuGBMmUS6yw881WTgNbDAVdo0U5I91sDrsYDs7NDw3jXsWoYyQFLYvdYiui2DjeG06Cjpo3KpxpX1SvFzS7nkUIiF4R5lzXwxhXDM7tePHNAZcaNKSUyZv256PWTYN3t3GLIE7LRxzAd7hzxj7hijESVm8a/ZLXdV0kKJZIk9mtk5bs3UU5ENp0jegXSDgUB85FEbUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szC+AB8as0sMRwBt/YtbrVDSjzCaLXzwBH9NgvoizQc=;
 b=kFxg25p3TV2o0RED0PubUOsz+3F9k5I5KTRAsfAETZNkSBu+8yZwLE37eeePtAjPNHATXei7v1UdJjgsS/KJcmnSGY991KEfEvUpht+EU3YbwDiJp49pIpj5lNKSIMzx6Kab2cPiS+q1F+DeKxM65rgmkJF8z8rH9ZHUxNecvDY=
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM5PR15MB1241.namprd15.prod.outlook.com (2603:10b6:3:b8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 21:59:02 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::88ab:3896:e702:55e4]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::88ab:3896:e702:55e4%6]) with mapi id 15.20.3109.025; Tue, 23 Jun 2020
 21:59:02 +0000
Date:   Tue, 23 Jun 2020 14:59:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v4 00/15] implement bpf iterator for tcp and udp
 sockets
Message-ID: <20200623215900.2bcnpzzamdctj3dx@kafai-mbp.dhcp.thefacebook.com>
References: <20200623161749.2500196-1-yhs@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623161749.2500196-1-yhs@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::41) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:ddf5) by BY5PR16CA0028.namprd16.prod.outlook.com (2603:10b6:a03:1a0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 21:59:01 +0000
X-Originating-IP: [2620:10d:c090:400::5:ddf5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 632835f3-b556-457d-6dfe-08d817c0a3b3
X-MS-TrafficTypeDiagnostic: DM5PR15MB1241:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR15MB1241D14A66895C24D2CAD441D5940@DM5PR15MB1241.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VO4pAAGOhs+GWA/jeRNoOBC4ASHUb2ChFekUvCQ3Nvm7u8nBs4uMemXagjXSrJgro3Xkr4pI6aB++IARI1oUZmjfnoG9ZTVORXpwxNOy4l5CstRHhDtP/rAGpM/NdtQdeIQ8mXjKJJhNgPxPeoIHkNPYRQhu3IWBUcacKnONAJQ99Uq/vEZ5QDd1sreYjb8fMPPT8r3NCmxj8pZvOZnvfHy7ZIhcU4xKrNXnGUrtjFqnN17LZJWflUY9TxsRZa+7F85pu/u1UOk2c/q/wCm5tNk1taeWHRtP4aXKwlTmH9w1gllFSEHTo4Oxh1iZfNKboy911/YU6jop7x0y/K9B2h1dUmXmv++tHTWLeRCfRsMeEZ14ffDIZBKNcPD6BhTt/GV7CkJuAoFlMU4gDd/ySA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(66946007)(5660300002)(8936002)(54906003)(83380400001)(4326008)(2906002)(66476007)(66556008)(55016002)(9686003)(6862004)(1076003)(8676002)(16526019)(478600001)(86362001)(186003)(966005)(7696005)(52116002)(6636002)(6506007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: QxFoWwIe5q8Q1VrdhtjSupX2aNuLVHLh04wiIuKbY56YbdTO0VU3kmG49LvWxqOch7eviIPRphk80fcHA0mlK4xk8iYHBG/UluTzknGU1CoqUENgkYXsGv1NXOM8GD/6mVkgbxWkhO6vz3GRAZI/u1+GwjtfJl39VkDEYAKl9gr2H168nfYu4kuNetA1KkAuayXZ1r8U0zNxkfQFLz7Uaml3TjODk2EmpM3TzLNuM8eJpBGHIg+bg37UDVyTncKbMNQXvhfx0pGzZCByPuy7N4ZTkV0Vl2bfYSKG8gd8q/9l0thr/hMfn0P7saW/iPIvBzDEm71U5VJTrCfrOr/Rf4EdgnH8ovTa4k3nJRlpV4l4PmglKFRS3SfcQZebX2H60nNMWWZYDDFZMFPY0ew3NsCeckmhhlQhjD+USkRKLnF2jNzVkG1eETw5UQb/V98Pbr0Sh+dVO4zoGXe/wVaFRcuBFgpc3aGTniMnhx9LC0KQ/QwvQiWc/V/kIcTnGU4Xqd8g99NjBpJO7aBDUIhgmA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 632835f3-b556-457d-6dfe-08d817c0a3b3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 21:59:02.2618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lWoQCjrE6/eu2qo0u5YzkEDxkG1A8FKkwb3svOdJh/UQBGKzHUJE5LLr4umbIyaW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1241
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_14:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 adultscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006120000 definitions=main-2006230146
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 09:17:49AM -0700, Yonghong Song wrote:
> bpf iterator implments traversal of kernel data structures and these
> data structures are passed to a bpf program for processing.
> This gives great flexibility for users to examine kernel data
> structure without using e.g. /proc/net which has limited and
> fixed format.
> 
> Commit 138d0be35b14 ("net: bpf: Add netlink and ipv6_route bpf_iter targets")
> implemented bpf iterators for netlink and ipv6_route.
> This patch set intends to implement bpf iterators for tcp and udp.
> 
> Currently, /proc/net/tcp is used to print tcp4 stats and /proc/net/tcp6
> is used to print tcp6 stats. /proc/net/udp[6] have similar usage model.
> In contrast, only one tcp iterator is implemented and it is bpf program
> resposibility to filter based on socket family. The same is for udp.
> This will avoid another unnecessary traversal pass if users want
> to check both tcp4 and tcp6.
> 
> Several helpers are also implemented in this patch
>   bpf_skc_to_{tcp, tcp6, tcp_timewait, tcp_request, udp6}_sock
> The argument for these helpers is not a fixed btf_id. For example,
>   bpf_skc_to_tcp(struct sock_common *), or
>   bpf_skc_to_tcp(struct sock *), or
>   bpf_skc_to_tcp(struct inet_sock *), ...
> are all valid. At runtime, the helper will check whether pointer cast
> is legal or not. Please see Patch #5 for details.
> 
> Since btf_id's for both arguments and return value are known at
> build time, the btf_id's are pre-computed once vmlinux btf becomes
> valid. Jiri's "adding d_path helper" patch set
>   https://lore.kernel.org/bpf/20200616100512.2168860-1-jolsa@kernel.org/T/
> provides a way to pre-compute btf id during vmlinux build time.
> This can be applied here as well. A followup patch can convert
> to build time btf id computation after Jiri's patch landed.
> 
> Changelogs:
>   v3 -> v4:
>     - fix bpf_skc_to_{tcp_timewait, tcp_request} helper implementation
>       as just checking sk->sk_state is not enough (Martin)
>     - fix a few kernel test robot reported failures
>     - move bpf_tracing_net.h from libbpf to selftests (Andrii)
>     - remove __weak attribute from selftests CONFIG_HZ variables (Andrii)
>   v2 -> v3:
>     - change sock_cast*/SOCK_CAST* names to btf_sock* names for generality (Martin)
>     - change gpl_license to false (Martin)
>     - fix helper to cast to tcp timewait/request socket. (Martin)
>   v1 -> v2:
>     - guard init_sock_cast_types() defination properly with CONFIG_NET (Martin)
>     - reuse the btf_ids, computed for new helper argument, for return
>       values (Martin)
>     - using BTF_TYPE_EMIT to express intent of btf type generation (Andrii)
>     - abstract out common net macros into bpf_tracing_net.h (Andrii)
Acked-by: Martin KaFai Lau <kafai@fb.com>
