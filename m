Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D12B1A4CB6
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgDJXxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:53:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9732 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726646AbgDJXxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:53:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03ANo3eH013581;
        Fri, 10 Apr 2020 16:52:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=jgxmWd/GbDiGpsmhg2Mo/faudBOwAMkQX1VDAqQ23dc=;
 b=cV5fnia3dcatJCY34UWXJEOsJ/iwrdNpaXsnchAYUTxMgODZDnTUyEcuvQII3FUNdeNC
 VJP/yqBpoB9Gv9vJ1OJ/x8VwiCPOET1j+aqzxKIqr4ZDOCMbaaZKgfEY+sycVmVYINzR
 NxrHFS5vKnPMWOp+8t57/5TAVIceg2SwKnA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 30adrm5x5e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 16:52:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 16:52:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hNwsmylRxdk5YuPlo4w9VnSlHqXduBe1shOVSJfDm6gfpRp23HKg8598PWHs47OqctwP92gW1K1F2wXX3tNkR/7Dko65WjgTbPM8Z5uUPoI2wE3ys4mym5Bmpf+aCV98qb3Si1AvW0jyPl/DZ1iApvqbF5ZID24vHVrP/7sewongNRs86jbtVp72yGsJwMd7AgDulAT/gzrC+0OtMIjcAPj4yIZ1ONo9XFhIx6UTv5YRzkmrC94ia9V6Eb5+lQVQj91UC0hqt9jR5v7FXv49m5hvh6i7DUPpY1gLC7DLGAv13t0tL2W1rmZtSvzCK6Gicd4DE2Lkt+SJcBwgWpU0GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgxmWd/GbDiGpsmhg2Mo/faudBOwAMkQX1VDAqQ23dc=;
 b=hZBXgtf5fAoFj33L/RdXrZ7O0zVXHHvf3DRiK0D8KJyi4yM0anT1lJdMY+xSUvsHBx4SDHrCt3jN7yfXix1pkwPIqWHEEynELSlOJoMJ4lu9IMKt3Imu4zAkxC+pX4w7GVNe9BQKLHMtJOFkwQeivfJToivugkCYzBP0rfp/Tfu+/DgJ//34N1I2t0Wp1ULNJTRC6upeAk2s8ObrrT/IjYCQ+miueybq/IwXGVQ/sSlbfhdUcs+flP30axXaObFRptxScdKaS2BZEf7z4olwuBLWaLOHXY4/bJyCdl5fr5NX5k60nU/XA1XLYH4vgZHfdDy9CGjI7P3Q5cyThQrGXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jgxmWd/GbDiGpsmhg2Mo/faudBOwAMkQX1VDAqQ23dc=;
 b=he+Z627AygHVG6Js0OABpcdL1rwqRG2pihFSUyiHFqkiceVsMac/BLO81UIcKbUnorpaMfrQWfhUYYegzkCqqKZ41fE1ZghvxuQSN8RzJKFo4aVVW132vaXzvuVEaAXYODOuiw7ntGi2DK4iWYoZy3jk5Jogk85db7YB5fI39+o=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Fri, 10 Apr
 2020 23:52:53 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 23:52:52 +0000
Subject: Re: [RFC PATCH bpf-next 06/16] bpf: add netlink and ipv6_route
 targets
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232527.2675717-1-yhs@fb.com>
 <CAEf4BzaGrL0h1CC8XCngNnMBAAECSGPNbP6hVshByppVa2wbsg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fd3cd1c5-8807-037d-647f-efb2e9390079@fb.com>
Date:   Fri, 10 Apr 2020 16:52:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaGrL0h1CC8XCngNnMBAAECSGPNbP6hVshByppVa2wbsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR08CA0049.namprd08.prod.outlook.com
 (2603:10b6:300:c0::23) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR08CA0049.namprd08.prod.outlook.com (2603:10b6:300:c0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24 via Frontend Transport; Fri, 10 Apr 2020 23:52:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 311c39c7-1d26-45da-81df-08d7ddaa486a
X-MS-TrafficTypeDiagnostic: MW3PR15MB4044:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB4044F101CAEF7026C187B40ED3DE0@MW3PR15MB4044.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(376002)(136003)(396003)(346002)(39860400002)(31696002)(53546011)(6506007)(52116002)(316002)(2906002)(54906003)(2616005)(478600001)(86362001)(186003)(36756003)(16526019)(66556008)(6486002)(31686004)(66946007)(66476007)(81156014)(8936002)(8676002)(5660300002)(6512007)(4326008)(6916009);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gGtHuHfH8TtuaEl7KfybpTXC9oBPd9vXL74ijxu6IUBj3lPQiCSqgHWk5vJqFmM3/udt/R3vFlI3AXZ7XEzrkTyqtDmjPuE0RiSo13y5gqT0+iVwFTQXGDY4PHLRXcT2cpn9/UaCxGtqYvXQwfDqKaGeeHil0K+/2EgfrDFI5/WUKNO2IfspsjwhW/fZ+ww4xCrTbJkgR3z1tx3rdHbbDUmJWMYbcXVKPWx6U8ImU9fbmRKGvyR1Y82hEW1apWg72EPxWzM9CPJNNPQhJMdyE0K6owJxhWv8Re7gigPTntwvxkfVy2nnqbzzzYK4hD6ll1gTuhBvZ7Ewa3xEnh8WGnqmNYc5epehvBUMnU2hHrA34YASyA0T39PDZbunaSGHoWQDXclUrHP9tUJFotGhqgBNafe9QF+9dca680nhN7CvztGF7FPx+ARA6rYDiWTH
X-MS-Exchange-AntiSpam-MessageData: tf5I3rZxvmIiN8J8fJm3SP4VnExKQctvf51oWBkqc6EQBEAPo3vA7bK29vC/f8kyZMyR/jcz/F5gXdM2/vPQmx7i7WxcpVNGL4TJYiLrrUevO2jN9r49YcPcms1LRNoo0znj/Ee3Y8rvG0WVE6leB56mozKyOdLOTtETumcCbNQPhLv6LbBom9mhimYp+yev
X-MS-Exchange-CrossTenant-Network-Message-Id: 311c39c7-1d26-45da-81df-08d7ddaa486a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 23:52:52.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aayKemLds1J8fqbBQhaFkeubLm/ST0yvcluD1Lg9XANh4fpiVT771j/PCqndw4Mo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4044
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 clxscore=1015 spamscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004100168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 4:13 PM, Andrii Nakryiko wrote:
> On Wed, Apr 8, 2020 at 4:25 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> This patch added netlink and ipv6_route targets, using
>> the same seq_ops (except show()) for /proc/net/{netlink,ipv6_route}.
>>
>> Since module is not supported for now, ipv6_route is
>> supported only if the IPV6 is built-in, i.e., not compiled
>> as a module. The restriction can be lifted once module
>> is properly supported for bpfdump.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h      |  1 +
>>   kernel/bpf/dump.c        | 13 ++++++++++
>>   net/ipv6/ip6_fib.c       | 41 +++++++++++++++++++++++++++++-
>>   net/ipv6/route.c         | 22 ++++++++++++++++
>>   net/netlink/af_netlink.c | 54 +++++++++++++++++++++++++++++++++++++++-
>>   5 files changed, 129 insertions(+), 2 deletions(-)
>>
> 
> [...]
> 
>>
>> +#if IS_BUILTIN(CONFIG_IPV6)
>> +static int ipv6_route_prog_seq_show(struct bpf_prog *prog, struct seq_file *seq,
>> +                                   u64 seq_num, void *v)
>> +{
>> +       struct ipv6_route_iter *iter = seq->private;
>> +       struct {
>> +               struct fib6_info *rt;
>> +               struct seq_file *seq;
>> +               u64 seq_num;
>> +       } ctx = {
> 
> So this anonymous struct definition has to match bpfdump__ipv6_route
> function prototype, if I understand correctly. So this means that BTF
> will have a very useful struct, that can be used directly in BPF
> program, but it won't have a canonical name. This is very sad... Would
> it be possible to instead use a struct as a prototype for these
> dumpers? Here's why it matters. Instead of currently requiring BPF
> users to declare their dumpers as (just copy-pasted):
> 
> int BPF_PROG(some_name, struct fib6_info *rt, struct seq_file *seq,
> u64 seq_num) {
>     ...
> }
> 
> if bpfdump__ipv6_route was actually a struct definition:
> 
> 
> struct bpfdump__ipv6_route {
>      struct fib6_info *rt;
>      struct seq_file *seq;
>      u64 seq_num;
> };
> 
> Then with vmlinux.h, such program would be very nicely declared and used as:
> 
> int some_name(struct bpfdump__ipv6_route *ctx) {
>    /* here use ctx->rt, ctx->seq, ctx->seqnum */
> }

Thanks, I do not know this!
This definitely better and may make kernel code simpler.
Will experiment.

> 
> This is would would be nice to have for raw_tp and tp_btf as well.
> 
> 
> Of course we can also code-generate such types from func_protos in
> bpftool, and that's a plan B for this, IMO. But seem like in this case
> you already have two keep two separate entities in sync: func proto
> and struct for context, so I thought I'd bring it up.
> 
>> +               .rt = v,
>> +               .seq = seq,
>> +               .seq_num = seq_num,
>> +       };
>> +       int ret;
>> +
>> +       ret = bpf_dump_run_prog(prog, &ctx);
>> +       iter->w.leaf = NULL;
>> +       return ret == 0 ? 0 : -EINVAL;
>> +}
>> +
