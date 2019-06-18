Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D19497C0
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 05:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfFRDVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 23:21:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34956 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRDVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 23:21:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5I399uk137012;
        Tue, 18 Jun 2019 03:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O/i7AMMkUKKosjfAFp+SY89OApm68MO3nGMJOcuM8UY=;
 b=FYOTl3p47yilQEAD2tOSXuRWh3gNFBayMh3bDKZ5lPjaRURvbbcEuz68TSWGsfFiXaUS
 SA84AqA7I21wkzycLfTRKuwFe//sh0OuzkV8khR9BIigtRJMtITTLUI4hbnFiLxRKl5h
 NPKtYuI/J2ovXQW97DEIYIqebwSfMg6SxLj7RUf1qRjsd3OWvpC7CiOs6G4kBqp4dbFS
 AzRvyVjId6RuLbufF3V9kR+PhvPRo4CcOgl2g2GgcJ+1W2AX7vuGdjjItKX4d6Xq9UJV
 lvHh4fVbZyL/omBrLiYv6/HOEN8toK/SlCH185oHS41f1Yn1fIW2ZSr5/uG9Mjc9hx04 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t4r3thqse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 03:20:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5I3JKFx046047;
        Tue, 18 Jun 2019 03:20:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2t5h5tg1qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Jun 2019 03:20:07 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x5I3K667047272;
        Tue, 18 Jun 2019 03:20:06 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2t5h5tg1qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 03:20:06 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5I3K5nB021569;
        Tue, 18 Jun 2019 03:20:05 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 20:20:05 -0700
Date:   Mon, 17 Jun 2019 23:19:59 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, dtrace-devel@oss.oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190618031959.GI8794@oracle.com>
References: <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com>
 <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
 <20190618012509.GF8794@oracle.com>
 <CAADnVQJoH4WOQ0t7ZhLgh4kh2obxkFs0UGDRas0y4QSqh1EMsg@mail.gmail.com>
 <20190618015442.GG8794@oracle.com>
 <CAADnVQ+zAwoH_mjJLhfEgXHHz+3WYkzhEm-mEObP0koLiSvknw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+zAwoH_mjJLhfEgXHHz+3WYkzhEm-mEObP0koLiSvknw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=875 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180024
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 08:01:52PM -0700, Alexei Starovoitov wrote:
> On Mon, Jun 17, 2019 at 6:54 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
> >
> > It is not hypothetical.  The folowing example works fine:
> >
> > static int noinline bpf_action(void *ctx, long fd, long buf, long count)
> > {
> >         int                     cpu = bpf_get_smp_processor_id();
> >         struct data {
> >                 u64     arg0;
> >                 u64     arg1;
> >                 u64     arg2;
> >         }                       rec;
> >
> >         memset(&rec, 0, sizeof(rec));
> >
> >         rec.arg0 = fd;
> >         rec.arg1 = buf;
> >         rec.arg2 = count;
> >
> >         bpf_perf_event_output(ctx, &buffers, cpu, &rec, sizeof(rec));
> >
> >         return 0;
> > }
> >
> > SEC("kprobe/ksys_write")
> > int bpf_kprobe(struct pt_regs *ctx)
> > {
> >         return bpf_action(ctx, ctx->di, ctx->si, ctx->dx);
> > }
> >
> > SEC("tracepoint/syscalls/sys_enter_write")
> > int bpf_tp(struct syscalls_enter_write_args *ctx)
> > {
> >         return bpf_action(ctx, ctx->fd, ctx->buf, ctx->count);
> > }
> >
> > char _license[] SEC("license") = "GPL";
> > u32 _version SEC("version") = LINUX_VERSION_CODE;
> 
> Great. Then you're all set to proceed with user space dtrace tooling, right?

I can indeed proceed with the initial basics, yes, and have started.  I hope
to have a first bare bones patch for review sometime next week.

> What you'll discover thought that it works only for simplest things
> like above. libbpf assumes that everything in single elf will be used
> and passes the whole thing to the kernel.
> The verifer removes dead code only from single program.
> It disallows unused functions. Hence libbpf needs to start doing
> more "linker work" than it does today.
> When it loads .o it needs to pass to the kernel only the functions
> that are used by the program.
> This work should be straightforward to implement.
> Unfortunately no one had time to do it.

Ah yes, I see what you mean.  I'll work on that next since I will definitely
be needing that.

> It's also going to be the first step to multi-elf support.
> libbpf would need to do the same "linker work" across .o-s.
