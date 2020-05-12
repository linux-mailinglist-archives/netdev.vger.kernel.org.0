Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1A41CFAD0
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgELQem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:34:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725816AbgELQel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 12:34:41 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04CGYEQH029691;
        Tue, 12 May 2020 09:34:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=EY7+0GglFTsxooAW3ke8JVNYEKP1Jd6N95/gWkA5dVs=;
 b=rBF8vaI3JjZa80W7u2bJATtRcUYEX+8Q03P9zDEO6CoxjWoTHDeC/hZPuB8Y5xLOpSwS
 qR5PRz4PtFV83xQLdhlcPBKUaAfI69tDPYrNlGaazHndxbzLrMzCVXsidP9H3QVng5cp
 5xjbR1F41kHjXkhe1A63rKXWqim6+F8JMSU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30ws21h02p-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 09:34:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 09:34:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUFzE9y+ougVCxX3J4fdr2bXuuumrQV9nuhVdjCGdxuCgpOqCnMAgsrPlKVtMMs8t6SotFxLq4WYH/MN9D+hGMyO6Gg2eBMTApiYEpMB6jTSnA8DB2JbiR3m8iC+osVGmRT9LTNBihtohkNQqawZP2sNVXJrDB8fuhfLjiZFHp3mYEyaa5GG35WKIhsPvgowArsgH3zwmY5Id2YkkYz8y0b33ekq/zGE4KrLX5DN0qPfTR/V0QLoALAOushWWaBMTXz0adrEOE9wKT/R1HMPSSD3yIF/9mPptSFEA607slBZriKTIAhScMTuho8ti+CMX4I7qusSm2d8+nMn1EBcOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EY7+0GglFTsxooAW3ke8JVNYEKP1Jd6N95/gWkA5dVs=;
 b=ToLnp+/8sVzp2ZKlRV6JnKxHAufZZMVY3kqS4+bCVT3PWOwHBPtCusBsy9Wl2NEmaVk2bcCAwIvcxR0AjtLt6zTep8JFs6Vvfy6gWkr5wV408Mdi3bDQrNc0bXK0C4eFqsPhryjYYyWLhKOQzFWlF17zLjvzCmFdMss9RYvdaIabGxyzJzpFIhRkJGgvcjQ+/MFKmtVBgBay/hpKdkeo3MOui7k0cxzqJNt9W5AWizTkle7Rr/8QfD7Q6NO5uBUUKyrfuanOGkT44EeYZ1+RXEV38yuZYgfkTPItZAtpA+JafE1L6rodVpd5jMx/LrLDF+vvs7GqjQZRPEWs/jjg4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EY7+0GglFTsxooAW3ke8JVNYEKP1Jd6N95/gWkA5dVs=;
 b=BIiEN8inA8wfNlPMD3IXGpgA8foHsu9QVMm37Swgtj4WN767FVsjhKQ53zgFpTw9YPnfQH/rAZfMgLTbJT37OhiFqCf4T+YWSpDj4Mdos8379Y6cakYnf8P9gLdRIdNnnGr02rFWcKoShbPVLT99GUSsKiHm0bREokZjXI3FuMQ=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3834.namprd15.prod.outlook.com (2603:10b6:303:4e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 16:34:14 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 16:34:14 +0000
Date:   Tue, 12 May 2020 09:34:11 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <dccp@vger.kernel.org>, <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v2 00/17] Run a BPF program on socket lookup
Message-ID: <20200512163411.4ae2faoa6hwnrv3k@kafai-mbp.dhcp.thefacebook.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
 <20200511194520.pr5d74ao34jigvof@kafai-mbp.dhcp.thefacebook.com>
 <873685v006.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <873685v006.fsf@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:717f) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 12 May 2020 16:34:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:717f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b09569cd-4b4c-4aa0-03b9-08d7f6924e8e
X-MS-TrafficTypeDiagnostic: MW3PR15MB3834:
X-Microsoft-Antispam-PRVS: <MW3PR15MB38341829DA17D05FF80E937DD5BE0@MW3PR15MB3834.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: umM6p80gy0JE/cvohze9EbXrwHfSc/JD3NJlPhOTnsLpcPa/XjwPySf6Q2hTr0VVHNCZnYzP+stOsDXCRh5Hkxaf1i8AISRKm3Mil/ng0176eySVq5avkh0awWUsRRvqyldvUDf9ZOMFmKQa2E2ZDL/gCizxGJc+MxSOTHVMO6hRUyCXhENkFqHpkO9Rehs1pV5Zygu+ge3CotVkF46cxamO1CCfLXrxCyVwXogPa+MxAKZd0bgZn7oG4dqID5msxRrjRqp8WC4DhiC2DmEqou057m4GPiKq15FMrMxPed0i3vTWI7WfSqx3WCgzSuyEBbf1qLpFg65BZRjx+hUTFL36IdzbTmpwgegACYl8Jwc1Y/HwZmHv6oVRsSSTM5fVwTPdb+ZnkeHIV6deaf/lnUUY2ehu6JfGTBD35vN7lI6cVtptBw31wfgyFoZxZJd4Y8M7W+RqDd9MuQIbHJ0nAhHJA8CdrhEc7Mxd+NpwzAbnnIFroExvSEbu+nC4b5qC42Id0kGpjVA8Tx4rONNWD7CQrfHtCMHqLfYROjQXQPaseUHObDc1JikZnBwDNjwzywhbuf5wZjkJrAV1SaInS+wmZClak17gq718BJ4EzTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(346002)(39860400002)(136003)(396003)(33430700001)(186003)(7696005)(52116002)(8936002)(55016002)(7416002)(53546011)(8676002)(6916009)(6506007)(33440700001)(9686003)(16526019)(54906003)(478600001)(66556008)(966005)(66946007)(66476007)(316002)(5660300002)(86362001)(2906002)(4326008)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hT4jXGFFebcD0N7wECLB2D3/GBTzse6VvXxsXCMIy+sYYSPbRbRzqr6GUPwg10Rw0h/x8tDhj3QG07kt+8A0rizFpgYQJEqjaSpx2cyExYbC2lrJwFh3bhH6FDFtFb1I1mUWu3O4OGwotbK+OBsBqPUeMcRDk2wI70sHVeQ/s6vQoG+z7Jms6pDakb7QQkIFE3pknEdN5Rl873Hu4mhYRW9LIQt3PU4FRCKKYGN1aDMk594XsS0rNPdS+UeGAly67di/PaIiNccCryGXuoW5sRqQtKRga1m+XzmfpT14FBaQxrcYdDxEY1LyHOqU/AxoIYyE+gfcv3W0CTJx6iIiQYnCRG3DFTVAd3GRZYqoc/6SVcqAhFYig39KZW9aOe85nO0rgpmPvwbTFKqQl6LXMiQCcEnjJ9kd+QEme7zu1Wvd8StwbQIU7h2aFrCunKBjEs1UbGxLm1S1C0kuPuCD2Va6yGAfaPDeI3T++dvi7++StpoGc73EpAI50RBFiyJieiIEHV1BzuOE1bYsxRrhNg==
X-MS-Exchange-CrossTenant-Network-Message-Id: b09569cd-4b4c-4aa0-03b9-08d7f6924e8e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 16:34:14.2371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wn+Dr3/KC9UeyL1HfYdhghhY8g3MwB7dhuFyCxiTYE8QD5m5osTfhmrBTj9jfdPC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3834
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 01:57:45PM +0200, Jakub Sitnicki wrote:
> On Mon, May 11, 2020 at 09:45 PM CEST, Martin KaFai Lau wrote:
> > On Mon, May 11, 2020 at 08:52:01PM +0200, Jakub Sitnicki wrote:
> >
> > [ ... ]
> >
> >> Performance considerations
> >> ==========================
> >>
> >> Patch set adds new code on receive hot path. This comes with a cost,
> >> especially in a scenario of a SYN flood or small UDP packet flood.
> >>
> >> Measuring the performance penalty turned out to be harder than expected
> >> because socket lookup is fast. For CPUs to spend >= 1% of time in socket
> >> lookup we had to modify our setup by unloading iptables and reducing the
> >> number of routes.
> >>
> >> The receiver machine is a Cloudflare Gen 9 server covered in detail at [0].
> >> In short:
> >>
> >>  - 24 core Intel custom off-roadmap 1.9Ghz 150W (Skylake) CPU
> >>  - dual-port 25G Mellanox ConnectX-4 NIC
> >>  - 256G DDR4 2666Mhz RAM
> >>
> >> Flood traffic pattern:
> >>
> >>  - source: 1 IP, 10k ports
> >>  - destination: 1 IP, 1 port
> >>  - TCP - SYN packet
> >>  - UDP - Len=0 packet
> >>
> >> Receiver setup:
> >>
> >>  - ingress traffic spread over 4 RX queues,
> >>  - RX/TX pause and autoneg disabled,
> >>  - Intel Turbo Boost disabled,
> >>  - TCP SYN cookies always on.
> >>
> >> For TCP test there is a receiver process with single listening socket
> >> open. Receiver is not accept()'ing connections.
> >>
> >> For UDP the receiver process has a single UDP socket with a filter
> >> installed, dropping the packets.
> >>
> >> With such setup in place, we record RX pps and cpu-cycles events under
> >> flood for 60 seconds in 3 configurations:
> >>
> >>  1. 5.6.3 kernel w/o this patch series (baseline),
> >>  2. 5.6.3 kernel with patches applied, but no SK_LOOKUP program attached,
> >>  3. 5.6.3 kernel with patches applied, and SK_LOOKUP program attached;
> >>     BPF program [1] is doing a lookup LPM_TRIE map with 200 entries.
> > Is the link in [1] up-to-date?  I don't see it calling bpf_sk_assign().
> 
> Yes, it is, or rather was.
> 
> The reason why the inet-tool version you reviewed was not using
> bpf_sk_assign(), but the "old way" from RFCv2, is that the switch to
> map_lookup+sk_assign was done late in development, after changes to
> SOCKMAP landed in bpf-next.
> 
> By that time performance tests were already in progress, and since they
> take a bit of time to set up, and the change affected just the scenario
> with program attached, I tested without this bit.
> 
> Sorry, I should have explained that in the cover letter. The next round
> of benchmarks will be done against the now updated version of inet-tool
> that uses bpf_sk_assign:
> 
> https://github.com/majek/inet-tool/commit/6a619c3743aaae6d4882cbbf11b616e1e468b436
> 
> >
> >>
> >> RX pps measured with `ifpps -d <dev> -t 1000 --csv --loop` for 60 seconds.
> >>
> >> | tcp4 SYN flood               | rx pps (mean ± sstdev) | Δ rx pps |
> >> |------------------------------+------------------------+----------|
> >> | 5.6.3 vanilla (baseline)     | 939,616 ± 0.5%         |        - |
> >> | no SK_LOOKUP prog attached   | 929,275 ± 1.2%         |    -1.1% |
> >> | with SK_LOOKUP prog attached | 918,582 ± 0.4%         |    -2.2% |
> >>
> >> | tcp6 SYN flood               | rx pps (mean ± sstdev) | Δ rx pps |
> >> |------------------------------+------------------------+----------|
> >> | 5.6.3 vanilla (baseline)     | 875,838 ± 0.5%         |        - |
> >> | no SK_LOOKUP prog attached   | 872,005 ± 0.3%         |    -0.4% |
> >> | with SK_LOOKUP prog attached | 856,250 ± 0.5%         |    -2.2% |
> >>
> >> | udp4 0-len flood             | rx pps (mean ± sstdev) | Δ rx pps |
> >> |------------------------------+------------------------+----------|
> >> | 5.6.3 vanilla (baseline)     | 2,738,662 ± 1.5%       |        - |
> >> | no SK_LOOKUP prog attached   | 2,576,893 ± 1.0%       |    -5.9% |
> >> | with SK_LOOKUP prog attached | 2,530,698 ± 1.0%       |    -7.6% |
> >>
> >> | udp6 0-len flood             | rx pps (mean ± sstdev) | Δ rx pps |
> >> |------------------------------+------------------------+----------|
> >> | 5.6.3 vanilla (baseline)     | 2,867,885 ± 1.4%       |        - |
> >> | no SK_LOOKUP prog attached   | 2,646,875 ± 1.0%       |    -7.7% |
> > What is causing this regression?
> >
> 
> I need to go back to archived perf.data and see if perf-annotate or
> perf-diff provide any clues that will help me tell where CPU cycles are
> going. Will get back to you on that.
> 
> Wild guess is that for udp6 we're loading and coping more data to
> populate v6 addresses in program context. See inet6_lookup_run_bpf
> (patch 7).
If that is the case,
rcu_access_pointer(net->sk_lookup_prog) should be tested first before
doing ctx initialization.

> 
> This makes me realize the copy is unnecessary, I could just store the
> pointer to in6_addr{}. Will make this change in v3.
> 
> As to why udp6 is taking a bigger hit than udp4 - comparing top 10 in
> `perf report --no-children` shows that in our test setup, socket lookup
> contributes less to CPU cycles on receive for udp4 than for udp6.
> 
> * udp4 baseline (no children)
> 
> # Overhead       Samples  Symbol
> # ........  ............  ......................................
> #
>      8.11%         19429  [k] fib_table_lookup
>      4.31%         10333  [k] udp_queue_rcv_one_skb
>      3.75%          8991  [k] fib4_rule_action
>      3.66%          8763  [k] __netif_receive_skb_core
>      3.42%          8198  [k] fib_rules_lookup
>      3.05%          7314  [k] fib4_rule_match
>      2.71%          6507  [k] mlx5e_skb_from_cqe_linear
>      2.58%          6192  [k] inet_gro_receive
>      2.49%          5981  [k] __x86_indirect_thunk_rax
>      2.36%          5656  [k] udp4_lib_lookup2
> 
> * udp6 baseline (no children)
> 
> # Overhead       Samples  Symbol
> # ........  ............  ......................................
> #
>      4.63%         11100  [k] udpv6_queue_rcv_one_skb
>      3.88%          9308  [k] __netif_receive_skb_core
>      3.54%          8480  [k] udp6_lib_lookup2
>      2.69%          6442  [k] mlx5e_skb_from_cqe_linear
>      2.56%          6137  [k] ipv6_gro_receive
>      2.31%          5540  [k] dev_gro_receive
>      2.20%          5264  [k] do_csum
>      2.02%          4835  [k] ip6_pol_route
>      1.94%          4639  [k] __udp6_lib_lookup
>      1.89%          4540  [k] selinux_socket_sock_rcv_skb
> 
> Notice that __udp4_lib_lookup didn't even make the cut. That could
> explain why adding instructions to __udp6_lib_lookup has more effect on
> RX PPS.
> 
> Frankly, that is something that suprised us, but we didn't have time to
> investigate further, yet.
The perf report should be able to annotate bpf prog also.
e.g. may be part of it is because the bpf_prog itself is also dealing
with a longer address?  

> 
> >> | with SK_LOOKUP prog attached | 2,520,474 ± 0.7%       |   -12.1% |
> > This also looks very different from udp4.
> >
> 
> Thanks for the questions,
> Jakub
