Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24FA2EB582
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 23:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbhAEWpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 17:45:41 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47320 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbhAEWpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 17:45:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105MOr0A022106;
        Tue, 5 Jan 2021 22:44:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=EVuLtaEoqyVF8xI9Fk+aPgVK+nQKGqBw67gRTMEOd70=;
 b=0dlbbXl6u7/DpS6PcTRxA+F2SUcyX7kazCvwbWmflGJLlP4XOrhp/pkCNu579jTxJ3DF
 FbWthhLCqItmTvZQvOMYsKfPwlVnF///LgLEHHQaGYDzuFMaCdTuQRTsHm2y1PL702Yl
 cJTEsx2ynmpC9v4lWp4VUu5W4O+xffmwWPkT64PPUCN1/zR1aeOSz61jwBJ+y03TKoEa
 UBwYMQIdLuNGe4F1muPmQrQMGQcH+f+12HjN+zg3MNP9KE1vXWHrWLbkMqAmxtizYQ89
 Y/fHK1fbjVZsjurlCdgY4My5jmcLVBdXxMo6znt186TXFEwR5pVTcZwlIoc5pkhM/wxa ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35tgsku31g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 22:44:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105MPLL7186292;
        Tue, 5 Jan 2021 22:44:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35vct6funb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 22:44:40 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 105Micqj022028;
        Tue, 5 Jan 2021 22:44:39 GMT
Received: from dhcp-10-175-187-168.vpn.oracle.com (/10.175.187.168)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 22:44:38 +0000
Date:   Tue, 5 Jan 2021 22:44:29 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Cong Wang <xiyou.wangcong@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, yhs@fb.com,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        jean-philippe@linaro.org, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next] ksnoop: kernel argument/return value
 tracing/display using BTF
In-Reply-To: <CAM_iQpW5ajiTTW7HBZiK+n_F1MhGyzzD+OWExns1YbejHRsy5A@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2101052209360.30305@localhost>
References: <1609773991-10509-1-git-send-email-alan.maguire@oracle.com> <CAM_iQpW5ajiTTW7HBZiK+n_F1MhGyzzD+OWExns1YbejHRsy5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101050129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Tue, 5 Jan 2021, Cong Wang wrote:

> On Mon, Jan 4, 2021 at 7:29 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > BPF Type Format (BTF) provides a description of kernel data structures
> > and of the types kernel functions utilize as arguments and return values.
> >
> > A helper was recently added - bpf_snprintf_btf() - that uses that
> > description to create a string representation of the data provided,
> > using the BTF id of its type.  For example to create a string
> > representation of a "struct sk_buff", the pointer to the skb
> > is provided along with the type id of "struct sk_buff".
> >
> > Here that functionality is utilized to support tracing kernel
> > function entry and return using k[ret]probes.  The "struct pt_regs"
> > context can be used to derive arguments and return values, and
> > when the user supplies a function name we
> >
> > - look it up in /proc/kallsyms to find its address/module
> > - look it up in the BTF kernel data to get types of arguments
> >   and return value
> > - store a map representation of the trace information, keyed by
> >   instruction pointer
> > - on function entry/return we look up the map to retrieve the BTF
> >   ids of the arguments/return values and can call bpf_snprintf_btf()
> >   with these argument/return values along with the type ids to store
> >   a string representation in the map.
> > - this is then sent via perf event to userspace where it can be
> >   displayed.
> >
> > ksnoop can be used to show function signatures; for example:
> 
> This is definitely quite useful!
> 
> Is it possible to integrate this with bpftrace? That would save people
> from learning yet another tool. ;)
> 

I'd imagine (and hope!) other tracing tools will do this, but right 
now the aim is to make the task of tracing kernel data structures simpler, 
so having a tool dedicated to just that can hopefully help those 
discussions.  There's a bit more work to be done to simplify that task, for
example  implementing Alexei's suggestion to support pretty-printing of 
data structures using BTF in libbpf.

My hope is that we can evolve this tool - or something like it - to the 
point where we can solve that one problem easily, and that other more 
general tracers can then make use of that solution.  I probably should
have made all of this clearer in the patch submission, sorry about that.

Alan
