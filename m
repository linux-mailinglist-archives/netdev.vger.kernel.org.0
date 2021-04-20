Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CED365F39
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbhDTS37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:29:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233518AbhDTS3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:29:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13KIMe5H016015;
        Tue, 20 Apr 2021 11:28:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=xVB2vMB0WIHu6n0J7FfnBBG5B0RsePFB2Ah6hBLhcV8=;
 b=ZD71InqTV2KtV+d1+cx9p9ZuO80mAtuY2LVSsZAoKASTcfQqHqOlhvIQLo5/kk3ylToR
 PPU4CBrkqBYQqqmbIc0kf5p15ptQStvLdDIKjfODV5/OpAik2K64zp6HrVhReKN516Ep
 sljGwY9YvuUhchikamLTp8BIe1mVRsgpY6Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 38191g8cr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 20 Apr 2021 11:28:59 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 11:28:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lv+v90m7Po9I9Y0VfBqBWdxOaT0kR1qfghCCXmF9el0RFqDhRSvqGWfcu6zyyrBS13EzCvXky+i6r17ZrlPJQZKmEo7QfkvzJ2t0I6emM+zfqOvzZL7sWRqJbiT783GydYHPjU9CbC6hdV0wjjlG/mXhU5Z8V2ap4Yx6wlD2kipY1WgdVFZ+/RH19ohl88OxkZqDsHadGqph323H9SBDszc25vVt4GjllIdtWU8cCO69BZ8JdBs5/MuRLGhfIusebxPD73yi6RzJY2spWrhYQlJnhyBGZcfXtUc5nPB/ehO+EoGwQBrnJXKhA9xbQCxzJPymaIY9DKQTNlDM6L2XbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVB2vMB0WIHu6n0J7FfnBBG5B0RsePFB2Ah6hBLhcV8=;
 b=Is+P0W59w8vGh4GlZcjP6eaTJQYz8A1WDdHaxyfuHZ9AmOJJnU6tLUbeB1hj7/fnDpN0dHTAQnauKJJ4b9ar94Uk+r0ZQSKWrlqJ6tq3klwDVQCJspUntAhlMxUsI2UAloBViOUKBJajvCGyYGT1VXbRVCz44M46osz4nLNzm+kNtSSuYgE4hVkwxEuzxPRKz/s88kkGdyAg+yMcEjaj07qUtAuWKXvo5ts3swxx7QWF5yxwGUIt5GHqI7+TLMz/W96D0x6nj/cikqMXN1Xwni/2b5E/cCoP/CWgSIwW7BbjR07Nxj1INkm0CyVFN9s6aclGIqqMNEjXm/R5fi+xXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 20 Apr
 2021 18:28:57 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 18:28:57 +0000
Date:   Tue, 20 Apr 2021 11:28:54 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCHv8 bpf-next 1/4] bpf: run devmap xdp_prog on flush instead
 of bulk enqueue
Message-ID: <20210420182854.rsis4npditizm5pu@kafai-mbp.dhcp.thefacebook.com>
References: <20210415135320.4084595-1-liuhangbin@gmail.com>
 <20210415135320.4084595-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210415135320.4084595-2-liuhangbin@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:a3ad]
X-ClientProxiedBy: MWHPR01CA0033.prod.exchangelabs.com (2603:10b6:300:101::19)
 To BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:a3ad) by MWHPR01CA0033.prod.exchangelabs.com (2603:10b6:300:101::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 20 Apr 2021 18:28:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0474d553-72a2-4cd0-5b91-08d9042a290f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2999:
X-Microsoft-Antispam-PRVS: <BYAPR15MB299955E21D670097EB597D0ED5489@BYAPR15MB2999.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /cicm8v0qq4cdmWfp7s7rUNUj2FgzWITUYMkQ7QSSYeg4Q4z9AaFzX0hbAuSyMnDrlZQd83CA82p9ya/utzaN8ncj42fwTKOhTNr/c8hL5LD5vq2vlZIgjLVQcz3YNizodwV07QrR2WZs4GbBcmLS7k1esplc6Ip/JZQQ2Q4EHztD1qlddd7xcCyAWLAbimpFSoqbjLgEYs8NSgpl2uVCdCQvNZhX+T49X4WU5Fy9GpvODdRxf3pFtoMXRvtFqHk018Tg3s2gmAhAwtsAfTtCSIoNvtzLSnRbNP7HBfYxO1r8qQH2AlTNsgyU2F60qyIIh62tA5mOI+1UwJQ7Ihc8zUXiU4vKjdEtwWJpYH+TngjvjzdXDHWXllkuHV7nMAecU2uSo31hCWmXsdTx6CzQ8c1HRHgZud6LfjNham3ryugrfj5FZUzlM1dUBIBblCtqVqOyOeDMLXc1/tjwLsw7dN7yz7tm0Bg1o3vDb04vBt8Ge4JVVm8WTBy4yiw3yf9DpCXRlzMwC45kTY++SrUeXN6wUWVlPsfDEEdpU8tROeIN15NOPo3l24wR8Jcspj6po0ZZHPC0BPo848cb8ovZ1rATOp5tUqfBn6EdQHaSe4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(136003)(396003)(346002)(16526019)(186003)(478600001)(1076003)(5660300002)(52116002)(7696005)(83380400001)(6506007)(316002)(66946007)(66556008)(6916009)(66476007)(7416002)(86362001)(9686003)(4326008)(8936002)(2906002)(8676002)(38100700002)(55016002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tJ5RKdp7js323OWupjgyc0TQXhHwa5ReOOFYSBPMbXYV+ENDoVoixTIFjVb4?=
 =?us-ascii?Q?4HI48RWev/a1ZSkH+b9WdKbaiVAesRmP0Y4CkIZa+jGlZG5DFxDEINGt2x/Z?=
 =?us-ascii?Q?54l/gjoXkeJOWq8ALjPEoxJCCCFDM4R/HFvxVrsEZ/1MB6pB02C6Z6U4DSwJ?=
 =?us-ascii?Q?VAO9w42upNPNHnTz6SjtFY/vFJym1WyOFlRRyzO4UboEjy+rbl+YjEd5Zgge?=
 =?us-ascii?Q?AB8vTI7v5mb97aClpDhs7RKuofCGdwir6N/mZwzxiV1yYe40g+48ViDwDGqK?=
 =?us-ascii?Q?pY7+Pd2Nc9ZxfUKyRnjpb4scTsdPcJ4wjoT+rikyjGXGK5QfnVwZMY1l8wY/?=
 =?us-ascii?Q?mK1d7niYWZPbDf9wt12Zd7lrl+hsWW2T/nlPsE2LP5sXExiTwpAT9h/pzXOJ?=
 =?us-ascii?Q?mHBa7nsc7gwIQINgmNnTdo5OdwZfFcC+NRK+XVEat8Ud8Xc1graJe+aoKBgn?=
 =?us-ascii?Q?r/w/6KHmJHvhgnXnSqOrEEHn7Rp//AOiqNCUc4QK7JvYdE5Gu1njK+BjS59w?=
 =?us-ascii?Q?aeqAxgyL6+RAhMm/16qIIk7QeM8i9O3fIbZrpnmB3dOrVedz47i3vurGP364?=
 =?us-ascii?Q?wjwOEDSz8JlY4XpMSGX6NAgeYJSNgbXG0OUXCOjfIR53kIA1RxyvGVqpX1e3?=
 =?us-ascii?Q?C8polKwqX2ALa4KsMCBSZTAL7KZ9/hp6O5tLjOUu6REd3/cC3fTN7sKsvLj4?=
 =?us-ascii?Q?nGAYa6o9d3oqOzwcgUffMYgbnU6NT4jEN97ao/ZAHs1tTXHKXbchgFYSqCmc?=
 =?us-ascii?Q?1vHgvalFLCpCusqKRu/lSjgge6Mc6AGb1p2ue8Y0+TaB28nlBV6DT0OQlKio?=
 =?us-ascii?Q?5TQ/WX9hW/KmF3xqQuePnjX2c2IYY+SejMxIahRZomGXhPJ3eyfF4bltaSWb?=
 =?us-ascii?Q?BZWBXsNQ62v9yjMfJDsp9mzEcDX4nlVvFDcpY28CJHvgT3ung81bJ7vTvKPu?=
 =?us-ascii?Q?OAI9ntaEYI7gy1eYWc5cc2a2AYLucD2MB94Q/dPYJUuf77u15O2cgm0YtHmk?=
 =?us-ascii?Q?1tXjxdCr36XmHnWnlKBmHmxtgAFODlaTKKdP6rlaDWRwWu0IiuktvZ0A5O7f?=
 =?us-ascii?Q?0LkMm2Upjr7RTqOotQV+mG6ih+lJZzEzGKZ4TaZUn/cMdCmZI0pdt+Xr6Rry?=
 =?us-ascii?Q?IyxwcdNrqDcx0sa/k23dtDkpyS7mr3EaTWsrmBTMpHeAd2O9WmEVycpOrdJS?=
 =?us-ascii?Q?KW2AU+lVZ3im0xt0QmwgRGn9XPuGK5D65puWsQqmrXsEcFq3jcUIYDCTzhRT?=
 =?us-ascii?Q?nHpr4aYkBYcgvW+o03/oG81eKwWnADodJ9TTBlqhdWhbI2TEqa7NpKAiltUv?=
 =?us-ascii?Q?VDJXwh222PIQe9EMOwUE1H/PTkxJ70HAvN/VqRm7fkjKMQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0474d553-72a2-4cd0-5b91-08d9042a290f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 18:28:57.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3JdOv4Q6zprmNeb2uftXYJdyJCidb7vUAvJRLHgPjnQAvHEn8vU8ctkdHsCVuiC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2999
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: zumgQH-hPJ5TBjV_os_QJ51UW5RcYcE0
X-Proofpoint-ORIG-GUID: zumgQH-hPJ5TBjV_os_QJ51UW5RcYcE0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-20_08:2021-04-20,2021-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 09:53:17PM +0800, Hangbin Liu wrote:
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> This changes the devmap XDP program support to run the program when the
> bulk queue is flushed instead of before the frame is enqueued. This has
> a couple of benefits:
> 
> - It "sorts" the packets by destination devmap entry, and then runs the
>   same BPF program on all the packets in sequence. This ensures that we
>   keep the XDP program and destination device properties hot in I-cache.
> 
> - It makes the multicast implementation simpler because it can just
>   enqueue packets using bq_enqueue() without having to deal with the
>   devmap program at all.
> 
> The drawback is that if the devmap program drops the packet, the enqueue
> step is redundant. However, arguably this is mostly visible in a
> micro-benchmark, and with more mixed traffic the I-cache benefit should
> win out. The performance impact of just this patch is as follows:
> 
> When bq_xmit_all() is called from bq_enqueue(), another packet will
> always be enqueued immediately after, so clearing dev_rx, xdp_prog and
> flush_node in bq_xmit_all() is redundant. Move the clear to __dev_flush(),
> and only check them once in bq_enqueue() since they are all modified
> together.
> 
> Using 10Gb i40e NIC, do XDP_DROP on veth peer, with xdp_redirect_map in
> sample/bpf, send pkts via pktgen cmd:
> ./pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -t 10 -s 64
> 
> There are about +/- 0.1M deviation for native testing, the performance
> improved for the base-case, but some drop back with xdp devmap prog attached.
> 
> Version          | Test                           | Generic | Native | Native + 2nd xdp_prog
> 5.12 rc4         | xdp_redirect_map   i40e->i40e  |    1.9M |   9.6M |  8.4M
> 5.12 rc4         | xdp_redirect_map   i40e->veth  |    1.7M |  11.7M |  9.8M
> 5.12 rc4 + patch | xdp_redirect_map   i40e->i40e  |    1.9M |   9.8M |  8.0M
> 5.12 rc4 + patch | xdp_redirect_map   i40e->veth  |    1.7M |  12.0M |  9.4M
Based on the discussion in v7, a summary of what still needs to be
addressed will be useful.
