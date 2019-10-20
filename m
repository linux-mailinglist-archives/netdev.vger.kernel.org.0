Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE69DDE2B
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 12:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfJTK6s convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 20 Oct 2019 06:58:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfJTK6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Oct 2019 06:58:48 -0400
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com [209.85.208.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34C4383F3E
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 10:58:47 +0000 (UTC)
Received: by mail-lj1-f199.google.com with SMTP id y28so1951530ljn.2
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 03:58:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+NpykUIW65eJ2c36TfeRLe5PwhhRNywnM93E7dMjYSk=;
        b=XBi4ld3yFf8Kyj3JXNYi3xtJHzGwDV+a9P/v8fF29xVhfJqDseU+7v6uamvTN9FlD5
         BVIogU90Q/C7vpYzlJ7yO2v+QobLIf59A6mSpzlsQ/rDuE9KVE7KxPzVh07CPlqsS7/k
         xR8MSNlb2AdQdP8u31cn0cQflGKXthVjGF2uc1mpgs2NkZ+Je8796DCHuf5G56ck+x7u
         QoPFV24XTQ93UjaGAagJrtLdN2t3zzuVXfsuZt0Zj39g/Qx8hDFwRK+Aml7JZWVWPS53
         HYdqXTGWWOaq6eIQeezzOBLqK8Hm5brDTK/rgTYG1t9L+YyKttZ+F4dNVl2n0ttI3OTB
         chWw==
X-Gm-Message-State: APjAAAUq8ylJ7D2tzF5wfEZwKQrlT7/sXqehhvQQuuiRwnqOBYQiURHB
        X8zvu8+CcOsI5wjuWs81BQO18FFuGx0heAdfwm8sEHjHfN9lioa3Aj603yPv6EEqtKKovfouhuU
        K0uOMAf4fnZ3HhSTf
X-Received: by 2002:ac2:5e9b:: with SMTP id b27mr11482655lfq.89.1571569123795;
        Sun, 20 Oct 2019 03:58:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwheJ5nZH8O2NBDsSwXhawLMJ4fCPt8GVo3AKxJc7SNEseycF42Xbi/TSEiLzxx97eRhCe+Yg==
X-Received: by 2002:ac2:5e9b:: with SMTP id b27mr11482640lfq.89.1571569123523;
        Sun, 20 Oct 2019 03:58:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id n5sm6167694ljh.54.2019.10.20.03.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 03:58:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BE7C51804C8; Sun, 20 Oct 2019 12:58:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: bpf indirect calls
In-Reply-To: <20191019200939.kiwuaj7c4bg25vqs@ast-mbp>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1> <157046883614.2092443.9861796174814370924.stgit@alrua-x1> <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com> <87sgo3lkx9.fsf@toke.dk> <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com> <87o8yqjqg0.fsf@toke.dk> <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com> <87v9srijxa.fsf@toke.dk> <20191016022849.weomgfdtep4aojpm@ast-mbp> <8736fshk7b.fsf@toke.dk> <20191019200939.kiwuaj7c4bg25vqs@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sun, 20 Oct 2019 12:58:40 +0200
Message-ID: <874l03d6ov.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Oct 16, 2019 at 03:51:52PM +0200, Toke Høiland-Jørgensen wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> 
>> > On Mon, Oct 14, 2019 at 02:35:45PM +0200, Toke Høiland-Jørgensen wrote:
>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >> 
>> >> > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:
>> >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >> >> 
>> >> >> > Please implement proper indirect calls and jumps.
>> >> >> 
>> >> >> I am still not convinced this will actually solve our problem; but OK, I
>> >> >> can give it a shot.
>> >> >
>> >> > If you're not convinced let's talk about it first.
>> >> >
>> >> > Indirect calls is a building block for debugpoints.
>> >> > Let's not call them tracepoints, because Linus banned any discusion
>> >> > that includes that name.
>> >> > The debugpoints is a way for BPF program to insert points in its
>> >> > code to let external facility to do tracing and debugging.
>> >> >
>> >> > void (*debugpoint1)(struct xdp_buff *, int code);
>> >> > void (*debugpoint2)(struct xdp_buff *);
>> >> > void (*debugpoint3)(int len);
>> >> 
>> >> So how would these work? Similar to global variables (i.e., the loader
>> >> creates a single-entry PROG_ARRAY map for each one)? Presumably with
>> >> some BTF to validate the argument types?
>> >> 
>> >> So what would it take to actually support this? It doesn't quite sound
>> >> trivial to add?
>> >
>> > Depends on definition of 'trivial' :)
>> 
>> Well, I don't know... :)
>> 
>> > The kernel has a luxury of waiting until clean solution is implemented
>> > instead of resorting to hacks.
>> 
>> It would be helpful if you could give an opinion on what specific
>> features are missing in the kernel to support these indirect calls. A
>> few high-level sentences is fine (e.g., "the verifier needs to be able
>> to do X, and llvm/libbpf needs to have support for Y")... I'm trying to
>> gauge whether this is something it would even make sense for me to poke
>> into, or if I'm better off waiting for someone who actually knows what
>> they are doing to work on this :)
>
> I have to reveal a secret first...
> llvm supports indirect calls since 2017 ;)
>
> It can compile the following:
> struct trace_kfree_skb {
> 	struct sk_buff *skb;
> 	void *location;
> };
>
> typedef void (*fn)(struct sk_buff *skb);
> static fn func;
>
> SEC("tp_btf/kfree_skb")
> int trace_kfree_skb(struct trace_kfree_skb *ctx)
> {
> 	struct sk_buff *skb = ctx->skb;
> 	fn f = *(volatile fn *)&func;
>
> 	if (f)
> 		f(skb);
> 	return 0;
> }
>
> into proper BPF assembly:
> ; 	struct sk_buff *skb = ctx->skb;
>        0:	79 11 00 00 00 00 00 00	r1 = *(u64 *)(r1 + 0)
> ; 	fn f = *(volatile fn *)&func;
>        1:	18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r2 = 0 ll
>        3:	79 22 00 00 00 00 00 00	r2 = *(u64 *)(r2 + 0)
> ; 	if (f)
>        4:	15 02 01 00 00 00 00 00	if r2 == 0 goto +1 <LBB0_2>
> ; 		f(skb);
>        5:	8d 00 00 00 02 00 00 00	callx 2
> 0000000000000030 LBB0_2:
> ; 	return 0;
>        6:	b7 00 00 00 00 00 00 00	r0 = 0
>        7:	95 00 00 00 00 00 00 00	exit
>
> Indirect call is encoded as JMP|CALL|X
> Normal call is JMP|CALL|K

Right, cool! So this would be handled like regular (data) global
variables, with libbpf populating a map to store the value behind the
scenes? 

> What's left to do is to teach the verifier to parse BTF of global data.
> Then teach it to recognize that r2 at insn 1 is PTR_TO_BTF_ID
> where btf_id is DATASEC '.bss'
> Then load r2+0 is also PTR_TO_BTF_ID where btf_id is VAR 'func'.
> New bool flag to reg_state is needed to tell whether if(rX==NULL) check
> was completed.
> Then at insn 5 the verifier will see that R2 is PTR_TO_BTF_ID and !NULL
> and it's a pointer to a function.
> Depending on function prototype the verifier would need to check that
> R1's type match to arg1 of func proto.
> For simplicity we don't need to deal with pointers to stack,
> pointers to map, etc. Only PTR_TO_BTF_ID where btf_id is a kernel
> data structure or scalar is enough to get a lot of mileage out of
> this indirect call feature.

OK, so this means that explicit map lookups could be added later? I.e.,
this:

int trace_kfree_skb(struct trace_kfree_skb *ctx)
{
	struct sk_buff *skb = ctx->skb;
        u32 key = 0;
	fn f;

        f = bpf_map_lookup_elem(&fpointer_map, &key);
        if (f)
          f(skb);
}

would need some more work, right?

> That's mostly it.
>
> Few other safety checks would be needed to make sure that writes
> into 'r2+0' are also of correct type.
> We also need partial map_update bpf_sys command to populate
> function pointer with another bpf program that has matching
> function proto.
>
> I think it's not trivial verifier work, but not hard either.
> I'm happy to do it as soon as I find time to work on it.

Great! I think it's probably more productive for everyone involved if I
just wait for you to get around to this, rather than try my own hand at
this. I'll go hash out the userspace management semantics of chain calls
in the meantime (using my kernel support patch), since that will surely
be needed anyway.

-Toke
