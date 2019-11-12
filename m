Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F04F8702
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 03:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfKLCvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 21:51:20 -0500
Received: from mail-pg1-f171.google.com ([209.85.215.171]:38021 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLCvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 21:51:19 -0500
Received: by mail-pg1-f171.google.com with SMTP id 15so10837695pgh.5;
        Mon, 11 Nov 2019 18:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ILLFgVcuiNXnVViAV/icrFc+G7PzeU+NLlmbvw8UXnw=;
        b=jMNa4XI7sw51VqFZ7K1b+WbY5LVx4zHOLlZxqJWCd/1AUjPKlUV0dgF1zWHVrmZU/e
         TqzSRHF3v8iw2g6nJb0holzENTp/FDE/TSoFiHScQp4pxYiXk8h5x40FDkA9MDIdWmFR
         2pu7Gu6oO5XoBVpiynt5r8QqBFQkbbGlIb4SKpiHq5yN7i8h5gfJHURoTQxDiv0Ia9XA
         vldrMs4Z9igAApLoeGllBWYJqdQ8gHjFpcviqjq/YONfYj8biozdNnAHiCEuwGCR1Gkm
         swMa710Xm2v+kS1poqRn25ziuoB99w2d/45s42Go6cJbXcV6PaH1q3zzK+cIRvVDhvit
         NytA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ILLFgVcuiNXnVViAV/icrFc+G7PzeU+NLlmbvw8UXnw=;
        b=IHUXU0sWg0imSzEQ3xsvPiMEP5bUU4Ykdh6Tnw/38/nBN7diT1srxzHDIomxEQfYsv
         srWoGH50tkeLArHHedGHGNo9hSOpgFOgbnX3qgWYT1193EN34ZKUVH2Q2Zx+GqKeJdWh
         a5lpC18/RBEF3XcM/6wuHHb9Nq9L5KgkzXHyi9+W/WRerQolrzBJnBaE5OsDWNaAOBAG
         mGe647UphpyA1t+/4pYTqg2NQcymSaqP4+sGeW7ZKoXPEWi3C2mU8YzviuiIBpG1i5x+
         PsFyh1HQ+vXbzF4+OfEjjK/e0y2TY3Vmjr3f8jmhdokVhtszrSF/L6zZEJbWlKf6xiwP
         GXzQ==
X-Gm-Message-State: APjAAAWCvw+vlCU4H9suBQvtQs+PaB/kF7NLI6aYvGy+HXqxDskvji+h
        PwF0v0rLczl/gRG6km30lFA=
X-Google-Smtp-Source: APXvYqyBMPzhT3iFkstt+i+/7Xdga22lh99kBisUviEoDk3tu5t1AuQ4jBY5paip5+DPYwtsTWU4ig==
X-Received: by 2002:aa7:9157:: with SMTP id 23mr33868440pfi.73.1573527078013;
        Mon, 11 Nov 2019 18:51:18 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::a925])
        by smtp.gmail.com with ESMTPSA id s11sm14459252pgo.85.2019.11.11.18.51.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 18:51:16 -0800 (PST)
Date:   Mon, 11 Nov 2019 18:51:14 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Message-ID: <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
References: <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
 <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch>
 <87eezfi2og.fsf@toke.dk>
 <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eez4odqp.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 08:07:42PM +0200, Toke Høiland-Jørgensen wrote:
> 
> I believe this is what Alexei means by "indirect calls". That is
> different, though, because it implies that each program lives as a
> separate object in the kernel - and so it might actually work. What you
> were talking about (until this paragraph) was something that was
> entirely in userspace, and all the kernel sees is a blob of the eBPF
> equivalent of `cat *.so > my_composite_prog.so`.

So I've looked at indirect calls and realized that they're _indirect_ calls.
The retpoline overhead will be around, so a solution has to work without them.
I still think they're necessary for all sorts of things, but priority shifted.

I think what Ed is proposing with static linking is the best generic solution.
The chaining policy doesn't belong in the kernel. A user space can express the
chaining logic in the form of BPF program. Static linking achieves that. There
could be a 'root' bpf program (let's call it rootlet.o) that looks like:
int xdp_firewall_placeholder1(struct xdp_md *ctx)
{
   return XDP_PASS;
}
int xdp_firewall_placeholder2(struct xdp_md *ctx)
{
   return XDP_PASS;
}
int xdp_load_balancer_placeholder1(struct xdp_md *ctx)
{
   return XDP_PASS;
}
int main_xdp_prog(struct xdp_md *ctx)
{
   int ret;

   ret = xdp_firewall_placeholder1(ctx);
   switch (ret) {
   case XDP_PASS: break;
   case XDP_PROP: return XDP_DROP;
   case XDP_TX: case XDP_REDIRECT:
      /* buggy firewall */
      bpf_perf_event_output(ctx,...);
   default: break; /* or whatever else */
   }
   
   ret = xdp_firewall_placeholder2(ctx);
   switch (ret) {
   case XDP_PASS: break;
   case XDP_PROP: return XDP_DROP;
   default: break;
   }

   ret = xdp_load_balancer_placeholder1(ctx);
   switch (ret) {
   case XDP_PASS: break;
   case XDP_PROP: return XDP_DROP;
   case XDP_TX: return XDP_TX;
   case XDP_REDIRECT: return XDP_REDIRECT;
   default: break; /* or whatever else */
   }
   return XDP_PASS;
}

When firewall1.rpm is installed it needs to use either a central daemon or
common library (let's call it libxdp.so) that takes care of orchestration. The
library would need to keep a state somewhere (like local file or a database).
The state will include rootlet.o and new firewall1.o that wants to be linked
into the existing program chain. When firewall2.rpm gets installed it calls the
same libxdp.so functions that operate on shared state. libxdp.so needs to link
firewall1.o + firewall2.o + rootlet.o into one program and attach it to netdev.
This is static linking. The existing kernel infrastructure already supports
such model and I think it's enough for a lot of use cases. In particular fb's
firewall+katran XDP style will fit right in. But bpf_tail_calls are
incompatible with bpf2bpf calls that static linking will use and I think
cloudlfare folks expressed the interest to use them for some reason even within
single firewall ? so we need to improve the model a bit.

We can introduce dynamic linking. The second part of 'BPF trampoline' patches
allows tracing programs to attach to other BPF programs. The idea of dynamic
linking is to replace a program or subprogram instead of attaching to it.
The firewall1.rpm application will still use libxdp.so, but instead of statically
linking it will ask kernel to replace a subprogram rootlet_fd +
btf_id_of_xdp_firewall_placeholder1 with new firewall1.o. The same interface is
used for attaching tracing prog to networking prog. Initially I plan to keep
the verifier job simple and allow replacing xdp-equivalent subprogram with xdp
program. Meaning that subprogram (in above case xdp_firewall_placeholder1)
needs to have exactly one argument and it has to be 'struct xdp_md *'. Then
during the loading of firewall1.o the verifier wouldn't need to re-verify the
whole thing. BTF type matching that the verifier is doing as part of 'BPF
trampoline' series will be reused for this purpose. Longer term I'd like to
allow more than one argument while preserving partial verification model.
The rootlet.o calls into firewall1.o directly. So no retpoline to worry about
and firewall1.o can use bpf_tail_call() if it wants so. That tail_call will
still return back to rootlet.o which will make policy decision. This rootlet.o
can be automatically generated by libxdp.so. If in the future we figure out how
to do two load-balancers libxdp.so will be able to accommodate that new policy.
This firewall1.o can be developed and tested independently of other xdp
programs. The key gotcha here is that the verifier needs to allow more than 512
stack usage for the rootlet.o. I think that's acceptable.

In the future indirect calls will allow rootlet.o to be cleaner:
typedef int (*ptr_to_xdp_prog)(struct xdp_md *ctx);
ptr_to_xdp_prog prog_array[100];
int main_xdp_prog(struct xdp_md *ctx)
{
   int ret, i;

   for (i = 0; i < 100; i++) {
       ret = prog_array[i](ctx);
       switch (ret) {
       case XDP_PASS: break;
       case XDP_PROP: return XDP_DROP;
       ..
   }
}
but they're indirect calls and retpoline. Hence lower priority atm.

Thoughts?

