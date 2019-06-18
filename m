Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13234972E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 03:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFRBzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 21:55:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33342 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfFRBzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 21:55:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5I1s71a196012;
        Tue, 18 Jun 2019 01:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=eE542OKo6D9dJ8OdHYUoOzoLNeU+roC70rOF9ID3jus=;
 b=Uul2SZprobH89p7Kqpx0O/HDXfODfGzcZhaZpvjveLJ3MuF+dUiDV3TuWwHW4HccvqLZ
 uQEm0ReAKopnHtpdZhD+BXXXIkN1UymXLv5ZmPjD3JU7A8R/Oe2tbd35uKl3Y8ucUBx0
 9fzVz/EEVzE3OSIJYaWBMacOUHYLyQnMOUI3uzSIX1IugeaigQMjM19NLLtGv72hbf+1
 6h1I82z3zKDPP+nLFWoQdPtnBylmpcR/2UvjLMDjxc70lTVVNgeFDA3CUXjNcqFJ4KP+
 uMX1Mwtttp4ErPJ6LaZb8B5MRweyPR6GalEx38seavTlEMJprV6v6bf4oRHYEO23MkqD Qw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t4rmp1eak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 01:54:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5I1rLAF158501;
        Tue, 18 Jun 2019 01:54:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2t5cpds8em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Jun 2019 01:54:50 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x5I1soWg160304;
        Tue, 18 Jun 2019 01:54:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t5cpds8eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 01:54:50 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5I1skT4027573;
        Tue, 18 Jun 2019 01:54:47 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 Jun 2019 18:54:46 -0700
Date:   Mon, 17 Jun 2019 21:54:42 -0400
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
Message-ID: <20190618015442.GG8794@oracle.com>
References: <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com>
 <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
 <20190618012509.GF8794@oracle.com>
 <CAADnVQJoH4WOQ0t7ZhLgh4kh2obxkFs0UGDRas0y4QSqh1EMsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJoH4WOQ0t7ZhLgh4kh2obxkFs0UGDRas0y4QSqh1EMsg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9291 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180013
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 06:32:22PM -0700, Alexei Starovoitov wrote:
> On Mon, Jun 17, 2019 at 6:25 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
> >
> > On Thu, May 23, 2019 at 01:28:44PM -0700, Alexei Starovoitov wrote:
> >
> > << stuff skipped because it is not relevant to the technical discussion... >>
> >
> > > > > In particular you brought up a good point that there is a use case
> > > > > for sharing a piece of bpf program between kprobe and tracepoint events.
> > > > > The better way to do that is via bpf2bpf call.
> > > > > Example:
> > > > > void bpf_subprog(arbitrary args)
> > > > > {
> > > > > }
> > > > >
> > > > > SEC("kprobe/__set_task_comm")
> > > > > int bpf_prog_kprobe(struct pt_regs *ctx)
> > > > > {
> > > > >   bpf_subprog(...);
> > > > > }
> > > > >
> > > > > SEC("tracepoint/sched/sched_switch")
> > > > > int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> > > > > {
> > > > >   bpf_subprog(...);
> > > > > }
> > > > >
> > > > > Such configuration is not supported by the verifier yet.
> > > > > We've been discussing it for some time, but no work has started,
> > > > > since there was no concrete use case.
> > > > > If you can work on adding support for it everyone will benefit.
> > > > >
> > > > > Could you please consider doing that as a step forward?
> > > >
> > > > This definitely looks to be an interesting addition and I am happy to look into
> > > > that further.  I have a few questions that I hope you can shed light on...
> > > >
> > > > 1. What context would bpf_subprog execute with?  If it can be called from
> > > >    multiple different prog types, would it see whichever context the caller
> > > >    is executing with?  Or would you envision bpf_subprog to not be allowed to
> > > >    access the execution context because it cannot know which one is in use?
> > >
> > > bpf_subprog() won't be able to access 'ctx' pointer _if_ it's ambiguous.
> > > The verifier already smart enough to track all the data flow, so it's fine to
> > > pass 'struct pt_regs *ctx' as long as it's accessed safely.
> > > For example:
> > > void bpf_subprog(int kind, struct pt_regs *ctx1, struct sched_switch_args *ctx2)
> > > {
> > >   if (kind == 1)
> > >      bpf_printk("%d", ctx1->pc);
> > >   if (kind == 2)
> > >      bpf_printk("%d", ctx2->next_pid);
> > > }
> > >
> > > SEC("kprobe/__set_task_comm")
> > > int bpf_prog_kprobe(struct pt_regs *ctx)
> > > {
> > >   bpf_subprog(1, ctx, NULL);
> > > }
> > >
> > > SEC("tracepoint/sched/sched_switch")
> > > int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> > > {
> > >   bpf_subprog(2, NULL, ctx);
> > > }
> > >
> > > The verifier should be able to prove that the above is correct.
> > > It can do so already if s/ctx1/map_value1/, s/ctx2/map_value2/
> > > What's missing is an ability to have more than one 'starting' or 'root caller'
> > > program.
> > >
> > > Now replace SEC("tracepoint/sched/sched_switch") with SEC("cgroup/ingress")
> > > and it's becoming clear that BPF_PROG_TYPE_PROBE approach is not good enough, right?
> > > Folks are already sharing the bpf progs between kprobe and networking.
> > > Currently it's done via code duplication and actual sharing happens via maps.
> > > That's not ideal, hence we've been discussing 'shared library' approach for
> > > quite some time. We need a way to support common bpf functions that can be called
> > > from networking and from tracing programs.
> > >
> > > > 2. Given that BPF programs are loaded with a specification of the prog type,
> > > >    how would one load a code construct as the one you outline above?  How can
> > > >    you load a BPF function and have it be used as subprog from programs that
> > > >    are loaded separately?  I.e. in the sample above, if bpf_subprog is loaded
> > > >    as part of loading bpf_prog_kprobe (prog type KPROBE), how can it be
> > > >    referenced from bpf_prog_tracepoint (prog type TRACEPOINT) which would be
> > > >    loaded separately?
> > >
> > > The api to support shared libraries was discussed, but not yet implemented.
> > > We've discussed 'FD + name' approach.
> > > FD identifies a loaded program (which is root program + a set of subprogs)
> > > and other programs can be loaded at any time later. The BPF_CALL instructions
> > > in such later program would refer to older subprogs via FD + name.
> > > Note that both tracing and networking progs can be part of single elf file.
> > > libbpf has to be smart to load progs into kernel step by step
> > > and reusing subprogs that are already loaded.
> > >
> > > Note that libbpf work for such feature can begin _without_ kernel changes.
> > > libbpf can pass bpf_prog_kprobe+bpf_subprog as a single program first,
> > > then pass bpf_prog_tracepoint+bpf_subprog second (as a separate program).
> > > The bpf_subprog will be duplicated and JITed twice, but sharing will happen
> > > because data structures (maps, global and static data) will be shared.
> > > This way the support for 'pseudo shared libraries' can begin.
> > > (later accompanied by FD+name kernel support)
> >
> > As far as I can determine, the current libbpd implementation is already able
> > to do the duplication of the called function, even when the ELF object contains
> > programs of differemt program types.  I.e. the example you give at the top
> > of the email actually seems to work already.  Right?
> 
> Have you tried it?

Yes, of course.  I wouldn't want to make an unfounded claim.

> > In that case, I am a bit unsure what more can be done on the side of libbpf
> > without needing kernel changes?
> 
> it's a bit weird to discuss hypothetical kernel changes when the first step
> of changing libbpf wasn't even attempted.

It is not hypothetical.  The folowing example works fine:

static int noinline bpf_action(void *ctx, long fd, long buf, long count)
{
        int                     cpu = bpf_get_smp_processor_id();
        struct data {
                u64     arg0;
                u64     arg1;
                u64     arg2;
        }                       rec;

        memset(&rec, 0, sizeof(rec));

        rec.arg0 = fd;
        rec.arg1 = buf;
        rec.arg2 = count;

        bpf_perf_event_output(ctx, &buffers, cpu, &rec, sizeof(rec));

        return 0;
}

SEC("kprobe/ksys_write")
int bpf_kprobe(struct pt_regs *ctx)
{
        return bpf_action(ctx, ctx->di, ctx->si, ctx->dx);
}

SEC("tracepoint/syscalls/sys_enter_write")
int bpf_tp(struct syscalls_enter_write_args *ctx)
{
        return bpf_action(ctx, ctx->fd, ctx->buf, ctx->count);
}

char _license[] SEC("license") = "GPL";
u32 _version SEC("version") = LINUX_VERSION_CODE;
