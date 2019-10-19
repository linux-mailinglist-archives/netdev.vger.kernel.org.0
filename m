Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8750CDDAD0
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 22:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfJSUJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 16:09:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39652 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfJSUJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 16:09:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id v4so5889841pff.6;
        Sat, 19 Oct 2019 13:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=RGpeEjmXrpLF/nSFRykmHEmCGzm/5JwpkSxsppLiM3o=;
        b=faQfZLB3+rJiDK08/tK8CrigrE37qin60yhXLMIx3xgMRLE5YP3wzL0prr5YP9QVRt
         ysSIebmRvpNmMmVOBVykrR20a/xhUb+M+rk+fg2XhFpJoJx5S0CaVqnoOmDysIQkXRWn
         XF7wlqotBQKNR9FdW/LMQsO6pVpgBOmr8rpI8yYZtfsEyEPRlcvDmGcWNB/QEh7x4WY4
         y9V1FoGkHoZ47dHkeDbKjmYA3pogu2MzWLX+oqjTYJI7ZlFO1fj1Om3tyCoHkHFJoaYT
         Soc4ZviBzeePN7jPcFY6+z0oHdMP7JIwyrkKuOgEShlExAt0vMSFN8jWdDq7dbsXPhe4
         rOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=RGpeEjmXrpLF/nSFRykmHEmCGzm/5JwpkSxsppLiM3o=;
        b=I3+7/Zx/Mfr8EWU56bdp1GdKfa+kMBdxSEd+4phDOnsFFtn1NqteEgRlchd7It/+C9
         SVP4F5oXXft63XbsDFLNZj54Rj0ZphxVu8mMcxO4qiso32IrSCTVupA7mWOPlIYGIJQa
         M93533M4CXs71hTHhg1Y8d1vKm/Ee4y4y6lZkPrYkMMdmJW/RaKTnBW8rTF84YK3eYCG
         p0Aq+hIHAaWJ0VRpNHpuwxbk29lR2A71im/hU8XxBoBTNW9Mcy/qHFUXF3XzkekmDfbI
         T6OG0znJrOGVblTJZ566FU6qYNIiHHAsIPnCj1YZfFxdMsbKnGxosAI2Za57F67KqrNS
         iYRw==
X-Gm-Message-State: APjAAAURcLNYXPg2CeXSqqY9cIjIE1uV798KF/BI5w5aR0QoQvEKSdMb
        bcmghEY/8a6yRBwW+yTNakk=
X-Google-Smtp-Source: APXvYqw5G8DZcvs/qWELapIITX7VdH7h+/Zm3ouzs2hdtphMjQ43VPEK8FSsX0EpcGbxwCUHPh7KSA==
X-Received: by 2002:a62:1953:: with SMTP id 80mr14544267pfz.173.1571515785475;
        Sat, 19 Oct 2019 13:09:45 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:180::d820])
        by smtp.gmail.com with ESMTPSA id 22sm9244535pfj.139.2019.10.19.13.09.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Oct 2019 13:09:44 -0700 (PDT)
Date:   Sat, 19 Oct 2019 13:09:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
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
Subject: bpf indirect calls
Message-ID: <20191019200939.kiwuaj7c4bg25vqs@ast-mbp>
References: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
 <157046883614.2092443.9861796174814370924.stgit@alrua-x1>
 <20191007204234.p2bh6sul2uakpmnp@ast-mbp.dhcp.thefacebook.com>
 <87sgo3lkx9.fsf@toke.dk>
 <20191009015117.pldowv6n3k5p3ghr@ast-mbp.dhcp.thefacebook.com>
 <87o8yqjqg0.fsf@toke.dk>
 <20191010044156.2hno4sszysu3c35g@ast-mbp.dhcp.thefacebook.com>
 <87v9srijxa.fsf@toke.dk>
 <20191016022849.weomgfdtep4aojpm@ast-mbp>
 <8736fshk7b.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8736fshk7b.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 03:51:52PM +0200, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Mon, Oct 14, 2019 at 02:35:45PM +0200, Toke Høiland-Jørgensen wrote:
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >> 
> >> > On Wed, Oct 09, 2019 at 10:03:43AM +0200, Toke Høiland-Jørgensen wrote:
> >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >> >> 
> >> >> > Please implement proper indirect calls and jumps.
> >> >> 
> >> >> I am still not convinced this will actually solve our problem; but OK, I
> >> >> can give it a shot.
> >> >
> >> > If you're not convinced let's talk about it first.
> >> >
> >> > Indirect calls is a building block for debugpoints.
> >> > Let's not call them tracepoints, because Linus banned any discusion
> >> > that includes that name.
> >> > The debugpoints is a way for BPF program to insert points in its
> >> > code to let external facility to do tracing and debugging.
> >> >
> >> > void (*debugpoint1)(struct xdp_buff *, int code);
> >> > void (*debugpoint2)(struct xdp_buff *);
> >> > void (*debugpoint3)(int len);
> >> 
> >> So how would these work? Similar to global variables (i.e., the loader
> >> creates a single-entry PROG_ARRAY map for each one)? Presumably with
> >> some BTF to validate the argument types?
> >> 
> >> So what would it take to actually support this? It doesn't quite sound
> >> trivial to add?
> >
> > Depends on definition of 'trivial' :)
> 
> Well, I don't know... :)
> 
> > The kernel has a luxury of waiting until clean solution is implemented
> > instead of resorting to hacks.
> 
> It would be helpful if you could give an opinion on what specific
> features are missing in the kernel to support these indirect calls. A
> few high-level sentences is fine (e.g., "the verifier needs to be able
> to do X, and llvm/libbpf needs to have support for Y")... I'm trying to
> gauge whether this is something it would even make sense for me to poke
> into, or if I'm better off waiting for someone who actually knows what
> they are doing to work on this :)

I have to reveal a secret first...
llvm supports indirect calls since 2017 ;)

It can compile the following:
struct trace_kfree_skb {
	struct sk_buff *skb;
	void *location;
};

typedef void (*fn)(struct sk_buff *skb);
static fn func;

SEC("tp_btf/kfree_skb")
int trace_kfree_skb(struct trace_kfree_skb *ctx)
{
	struct sk_buff *skb = ctx->skb;
	fn f = *(volatile fn *)&func;

	if (f)
		f(skb);
	return 0;
}

into proper BPF assembly:
; 	struct sk_buff *skb = ctx->skb;
       0:	79 11 00 00 00 00 00 00	r1 = *(u64 *)(r1 + 0)
; 	fn f = *(volatile fn *)&func;
       1:	18 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00	r2 = 0 ll
       3:	79 22 00 00 00 00 00 00	r2 = *(u64 *)(r2 + 0)
; 	if (f)
       4:	15 02 01 00 00 00 00 00	if r2 == 0 goto +1 <LBB0_2>
; 		f(skb);
       5:	8d 00 00 00 02 00 00 00	callx 2
0000000000000030 LBB0_2:
; 	return 0;
       6:	b7 00 00 00 00 00 00 00	r0 = 0
       7:	95 00 00 00 00 00 00 00	exit

Indirect call is encoded as JMP|CALL|X
Normal call is JMP|CALL|K

What's left to do is to teach the verifier to parse BTF of global data.
Then teach it to recognize that r2 at insn 1 is PTR_TO_BTF_ID
where btf_id is DATASEC '.bss'
Then load r2+0 is also PTR_TO_BTF_ID where btf_id is VAR 'func'.
New bool flag to reg_state is needed to tell whether if(rX==NULL) check
was completed.
Then at insn 5 the verifier will see that R2 is PTR_TO_BTF_ID and !NULL
and it's a pointer to a function.
Depending on function prototype the verifier would need to check that
R1's type match to arg1 of func proto.
For simplicity we don't need to deal with pointers to stack,
pointers to map, etc. Only PTR_TO_BTF_ID where btf_id is a kernel
data structure or scalar is enough to get a lot of mileage out of
this indirect call feature.
That's mostly it.

Few other safety checks would be needed to make sure that writes
into 'r2+0' are also of correct type.
We also need partial map_update bpf_sys command to populate
function pointer with another bpf program that has matching
function proto.

I think it's not trivial verifier work, but not hard either.
I'm happy to do it as soon as I find time to work on it.

