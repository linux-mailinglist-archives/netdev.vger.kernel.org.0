Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16743FE860
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKOXCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:02:36 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35124 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfKOXCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:02:36 -0500
Received: by mail-pl1-f193.google.com with SMTP id s10so5679740plp.2;
        Fri, 15 Nov 2019 15:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BLDM+Ly7G3DpFy7+OuzB3Zk6QfQCmvr9XjAeHx5UpgI=;
        b=BaAJDovnrZto37xC4I87ZxCdOAwILnm2yHqzguJiPg/QGOjZ5t3Z044/e9mJBjuetT
         4B1Db1pgr0+zyYIhjL54i1AG0PV93Qojyw3W3iTDQH+DjV3nlxv7wQ8AeJf6rXLYKDVM
         RhMZClD0Z02yTrrk0x7sZMvgnVl+WSi8YD8Hs46jP8tOVo6Xjlf28cAGXmB7iEOYezNh
         v2J3lbz+o4JpPV9zMbpRRn1elYyl1OkHY8xM5/+UZrbfw80b2POawUt5CyPcalTNMzrv
         TLJZiyui/pGOw9pbxPNr4LLB4Sn1/dslE1ex5qe5IBVurpwdNa6PyeFcxpytV0KuJGmv
         Zs/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BLDM+Ly7G3DpFy7+OuzB3Zk6QfQCmvr9XjAeHx5UpgI=;
        b=UWdRiHdtPUS0zil0NNXYXo3OgRjy4Md7WXzqnY+iXvxlWdmOpWBp23nYq9OexIL9Dq
         rGvmbG98QGUzOhTSocKCSdqZnomJ/J3J7V1Y3MOlCjx95+vvkGIOhOq67PlZ0trv/Kyj
         e2KaVohhC/RBTlRqkaH4O6vZoJv77e1SNyvZOkSjQ7ArTM817gYMPeT/hBoxC4bjKTot
         cMU2BZ7s8YWZDZ5SRpPorCRt0I5E39u/sfcSVKTyMp+xEK3JeSsapF6fmMiex17dAgDi
         VruGhVBkpGhqx5lxXjFZl5EPBbCUhICKVdew4z+yz0CquEMI+LKEdAC7R/neLSTACd2G
         G4pw==
X-Gm-Message-State: APjAAAWJ1DZ5vwfYq7r8dBW4ZbRujeaN17JwlvJa/5Lwo5Ke0owNx7d7
        jn/GeQV6bPLgwFGMgjOlqcQ=
X-Google-Smtp-Source: APXvYqxjjkep4Rt4uq/elNOJmmdC/2YTdiExq8/Rdzsii/6jOmkeiBCbm5zfuGOMt2O+P7DMRtTYbQ==
X-Received: by 2002:a17:90a:aa8c:: with SMTP id l12mr22530838pjq.92.1573858953831;
        Fri, 15 Nov 2019 15:02:33 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::8ac1])
        by smtp.gmail.com with ESMTPSA id 21sm13053597pfa.170.2019.11.15.15.02.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Nov 2019 15:02:32 -0800 (PST)
Date:   Fri, 15 Nov 2019 15:02:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Message-ID: <20191115230229.qd6plwnvrmcm4pfo@ast-mbp.dhcp.thefacebook.com>
References: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk>
 <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <CACAyw98dcpu1b2nUf7ize2SJGJGd=mhqRK+PYQTx96gSBtbkNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACAyw98dcpu1b2nUf7ize2SJGJGd=mhqRK+PYQTx96gSBtbkNQ@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 11:48:42AM +0000, Lorenz Bauer wrote:
> On Tue, 12 Nov 2019 at 02:51, Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > This is static linking. The existing kernel infrastructure already supports
> > such model and I think it's enough for a lot of use cases. In particular fb's
> > firewall+katran XDP style will fit right in. But bpf_tail_calls are
> > incompatible with bpf2bpf calls that static linking will use and I think
> > cloudlfare folks expressed the interest to use them for some reason even within
> > single firewall ? so we need to improve the model a bit.
> 
> We several components that we'd like to keep (logically) separate. At a high
> level, our rootlet would look like this:
> 
>   sample_packets(ctx);
>   if (ddos_mitigate(ctx) != XDP_PASS) {
>      return XDP_DROP;
>   }
>   return l4lb(ctx);
> 
> I think we could statically link ddos_mitigate() together from
> multiple separate .o.
> It depends on how complicated our rules become. Maybe we'd use dynamic linking,
> to reduce the overhead of re-verification.
> 
> The rootlet would use dynamic linking, to be able to debug / inspect
> sampling, ddos
> mitigation and the l4lb separately. Combined with the ability to hook
> arbitrary BPF
> programs at entry / exit we could probably get rid of our tail_call
> use. I don't think
> you have to change the model for us to fit into it.
> 
> > We can introduce dynamic linking. The second part of 'BPF trampoline' patches
> > allows tracing programs to attach to other BPF programs. The idea of dynamic
> > linking is to replace a program or subprogram instead of attaching to it.
> 
> Reading the rest of the thread, I'm on board with type 2 of dynamic linking
> (load time linking?) However, type 1 (run time linking) I'm not so sure about.
> Specifically, the callee holding onto the caller instead of vice versa.
> 
> Picking up your rootlet and fw1 example: fw1 holds the refcount on rootlet.
> This means user space needs to hold the refcount on fw1 to make sure
> the override is kept. This in turn means either: hold on to the file descriptor
> or pin the program into a bpffs. The former implies a persistent process,
> which doesn't work for tc. 

Pinning the program alone is not enough.
The folks have requested a feature to pin raw_tp_fd into bpffs.
I'm very much in favor of that. imo all other 'link fd' should be pinnable.
Then auto-detach won't happen on close() of such 'link fd'.

> The latter makes  lifetime management of fw1 hard:
> there is no way to have the kernel automatically deallocate it when it no longer
> needed, aka when the rootlet refcount reaches zero. 

hmm. Not sure I follow. See below.

> It also overloads close()
> to automatically detach the replaced / overridden BPF, which is contrary to how
> other BPF hook points work.

imo all bpf attach api-s that are not FD-based are fragile and error prone
operationally. We've seen people adding a ton of TC ingress progs because of
bugs. Then there were issues with roolet being removed due to bugs. The issues
with overriding wrong entries in prog_array. When multiple teams working on
common infra having globally visible and unprotected state is dangerous. imo
XDP and TC have to move to FD based api. When application holds the 'link fd'
that attached program will not be detached by anything else accidentally.
The operation 'attach rootlet XDP prog to netdev eth0' should return FD.
While that FD is held by application (or pinned in bpffs) nothing should be
able to override XDP prog on that eth0. We don't have such api yet, but I think
it's necessary. Same thing with replacing rootlet's placeholder subprogram with
fw1. When fw1's application links fw1 prog into rootlet nothing should be able
to break that attachment. But if fw1 application crashes that fw1 prog will be
auto-detached from rootlet. The admin can ssh into the box and kill fw1. The
packets will flow into rootlet and will flow into dummy placeholder. No
cleanups to worry about.

In case of fentry/fexit that 'link fd' protects the connection between
tracer prog and tracee prog. Whether tracer has a link to tracee or vice
versa doesn't matter. That's kernel internal implementation. The
uni-directional link avoids circular issues.

> I'd much prefer if the API didn't require attach_prog_fd and id at
> load time, and
> rather have an explicit replace_sub_prog(prog_fd, btf_id, sub_prog_fd).

The verifier has to see the target prog and its full BTF at load time. The
fentry prog needs target prog's BTF. XDP replacement prog needs target prog's
BTF too. So prog_fd+btf_id has to be passed at load time. I think
tgt_prog->refcnt++ should be done at load time too. The ugly alternative would
be to do tgt_prog->refcnt++ before verification. Then after verification
duplicate tgt_prog BTF, store it somewhere, and do tgr_prog->refcnt--. Then
later during attach/replace compare saved BTF with tgt_prog's BTF. That's imo a
ton of unncessary work for the kernel.

> > [...] This rootlet.o
> > can be automatically generated by libxdp.so. If in the future we figure out how
> > to do two load-balancers libxdp.so will be able to accommodate that new policy.
> > This firewall1.o can be developed and tested independently of other xdp
> > programs. The key gotcha here is that the verifier needs to allow more than 512
> > stack usage for the rootlet.o. I think that's acceptable.
> 
> How would the verifier know which programs are allowed to have larger stacks?

Excellent question. I was thinking that every individually verified unit will
be under existing 512 limitation. The composition needs to check for cycles in
the attach graph and for maximum stack. The maximum stack will have some limit.
That's minor. More interesting problem to solve is how to check for cycles.

