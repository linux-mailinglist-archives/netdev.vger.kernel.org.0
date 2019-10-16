Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB2AD9D7C
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 23:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbfJPV2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 17:28:15 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35003 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbfJPV2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 17:28:14 -0400
Received: by mail-lf1-f66.google.com with SMTP id w6so139826lfl.2;
        Wed, 16 Oct 2019 14:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FHX56J4EpEA4GiE9AOF9jGW/bWYW43w8QEiCagtKGdE=;
        b=TKUSLqm6wSATzmq4qnQ1kJBaLJ116oUznszP/0502pPBef76+ZV3EElEZCxNuvu91v
         /flSs4S8H9+PVshXIAc5T2M3oWaLKRG1eqhufhNg6xLEE9aM9J7Vb+0h2OiVkWJcSWtq
         2HPIyKtLxJM1P8uF/25s6Lky+76lcaEhENlqK2HncdUdNYJ/Z/wEDXCej0yYpK3O+rWO
         w4T5itwPNFVfpoR1pT7kMY9ZL3PmsOk8KYuqiFfPNLcwCXF3aYw/VV/Vr4JYtX9HteVS
         1HMH47V4/Q/0jSQ1FFOlQ2Bx3eQfe/hgBArzcUeWTor7EKsjqLmJaV4zsC7KJLcWImPe
         dK4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FHX56J4EpEA4GiE9AOF9jGW/bWYW43w8QEiCagtKGdE=;
        b=BOtxLvYhN69OJEzf7mJinOFCPWz37owK7++K7CyAqfj6vCsbHaNDX0f2BB5bGbKj8J
         pgWcTro27WB0dCuKwfoclmcRNAonink+EdTQgwSTf3TN9/1E7BazosWAItyobgtT2v0O
         OJkJ1X2DqwKAJEUuOTY+vR/8WKeHN4EqsXrvs5FV3pSoqBxcKD3glQ9rLrbc5kbv8Shj
         3rUBmzrFlMqa1LUdNrgIzir41wfpxhLEhDnXkg7HU7lGn0x8SLxCmzzab1jbNputkwcL
         S/+ud5GSvBNPlNq1rV5ECOqHekVVwAcuZfBwwFZu4/57xbWNQ8ptgnEUDL4Gexi0S+nL
         1Elw==
X-Gm-Message-State: APjAAAWnu1QOP2Q7hbu6G13gsc7dpFj0GCk9ineGvIHy6azqK869MaOm
        XVIPkphrWc1rBjuVtg6bUu1jlcfOBB75q7nWYPQ=
X-Google-Smtp-Source: APXvYqx6Dh3vVAwZ/PBYiIO8XOBPShh5+d7va+wlQTuMM1HlkLqMNosg/v0MJDpMRdOpqr+hXYVt/+4/zayGSDtw3r8=
X-Received: by 2002:a19:f707:: with SMTP id z7mr25020975lfe.162.1571261292304;
 Wed, 16 Oct 2019 14:28:12 -0700 (PDT)
MIME-Version: 1.0
References: <20191016032505.2089704-1-ast@kernel.org> <20191016032505.2089704-7-ast@kernel.org>
 <04fab556-9eda-87ec-8f8c-defcab25a80e@iogearbox.net>
In-Reply-To: <04fab556-9eda-87ec-8f8c-defcab25a80e@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 16 Oct 2019 14:28:00 -0700
Message-ID: <CAADnVQLry-vV_nNUFNaWtO_iFPfvq5-vpqiONHq6r0_6pVt26g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 06/11] bpf: implement accurate raw_tp context
 access via BTF
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, X86 ML <x86@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 2:22 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/16/19 5:25 AM, Alexei Starovoitov wrote:
> > libbpf analyzes bpf C program, searches in-kernel BTF for given type name
> > and stores it into expected_attach_type.
> > The kernel verifier expects this btf_id to point to something like:
> > typedef void (*btf_trace_kfree_skb)(void *, struct sk_buff *skb, void *loc);
> > which represents signature of raw_tracepoint "kfree_skb".
> >
> > Then btf_ctx_access() matches ctx+0 access in bpf program with 'skb'
> > and 'ctx+8' access with 'loc' arguments of "kfree_skb" tracepoint.
> > In first case it passes btf_id of 'struct sk_buff *' back to the verifier core
> > and 'void *' in second case.
> >
> > Then the verifier tracks PTR_TO_BTF_ID as any other pointer type.
> > Like PTR_TO_SOCKET points to 'struct bpf_sock',
> > PTR_TO_TCP_SOCK points to 'struct bpf_tcp_sock', and so on.
> > PTR_TO_BTF_ID points to in-kernel structs.
> > If 1234 is btf_id of 'struct sk_buff' in vmlinux's BTF
> > then PTR_TO_BTF_ID#1234 points to one of in kernel skbs.
> >
> > When PTR_TO_BTF_ID#1234 is dereferenced (like r2 = *(u64 *)r1 + 32)
> > the btf_struct_access() checks which field of 'struct sk_buff' is
> > at offset 32. Checks that size of access matches type definition
> > of the field and continues to track the dereferenced type.
> > If that field was a pointer to 'struct net_device' the r2's type
> > will be PTR_TO_BTF_ID#456. Where 456 is btf_id of 'struct net_device'
> > in vmlinux's BTF.
> >
> > Such verifier analysis prevents "cheating" in BPF C program.
> > The program cannot cast arbitrary pointer to 'struct sk_buff *'
> > and access it. C compiler would allow type cast, of course,
> > but the verifier will notice type mismatch based on BPF assembly
> > and in-kernel BTF.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>
> Overall set looks great!
>
> [...]
> > +int btf_struct_access(struct bpf_verifier_log *log,
> > +                   const struct btf_type *t, int off, int size,
> > +                   enum bpf_access_type atype,
> > +                   u32 *next_btf_id)
> > +{
> > +     const struct btf_member *member;
> > +     const struct btf_type *mtype;
> > +     const char *tname, *mname;
> > +     int i, moff = 0, msize;
> > +
> > +again:
> > +     tname = __btf_name_by_offset(btf_vmlinux, t->name_off);
>
> More of a high-level question wrt btf_ctx_access(), is there a reason the ctx
> access is only done for raw_tp? I presume kprobes is still on todo (?), what
> about uprobes which also have pt_regs and could benefit from this work, but is
> not fixed to btf_vmlinux to search its ctx type.

Optimized kprobes via ftrace entry point are on immediate todo list
to follow up. I'm still debating on the best way to handle it.
uprobes - I haven't though about. Likely necessary as well.
Not sure what types to give to pt_regs yet.

>
> I presume BPF_LDX | BPF_PROBE_MEM | BPF_* would need no additional encoding,
> but JIT emission would have to differ depending on the prog type.

you mean for kprobes/uprobes? Why would it need to be different?
The idea was to keep LDX|PROBE_MEM as normal LDX|MEM load as much as possible.
The only difference vs normal load is to populate extable which is
arch dependent.
