Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1F4BDE7B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379004AbiBUPWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 10:22:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiBUPWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 10:22:10 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C0BBCA3;
        Mon, 21 Feb 2022 07:21:45 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id q11so3342018pln.11;
        Mon, 21 Feb 2022 07:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=A4NrD48q9KOhijNPOkUx9pEnWJGMxbtOCpt4Iac/M28=;
        b=ofk2BYarXykhbwKOTsmfv0XwxfXxodnXWDd1AA0gVIcUEjLBzSOlKGlfI1BD8mAOah
         uI8hVZFFnQ2xhmjFDQTB+J9Tq2k7YaNxB6VTpTCgLFkagOZz4suLyuvBcfigepQJAT24
         Q6eYx2g4QQ5IfkUN+x3PKmyFrN6bdtyaudTLG4WHgX9DEExjAlf9Q2rSR2NTnQ2NnnJK
         HyjLSR4L8vUqAXFh3cMmEWh6APpfrtgGGGRDkZSyJJ+ndUo6bZIxq5Z0QexYyhtwFu+E
         P4vXJE0qD1v4UaWH9Fefjh8ODbpGFCjp3ElqkEW2D1QmTueEHoC36NLQAXCgdibcjPei
         MMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=A4NrD48q9KOhijNPOkUx9pEnWJGMxbtOCpt4Iac/M28=;
        b=tTeIfzOUk9R94kZzMBvjVBGFWBJrsDMnA+pmuYNJHkL7qAfuhAGvJBrjEXL+OKYsqP
         S87vbTRSjxjGWpKvNcB8hUSR6Bb3qou3A+FAB9h4RTcQJrD4zLVfkGlfB1E1eJNbkkj3
         kw4r0UFHeJNe+VNoCzaHBhyREYfYCj9kvBaWnww5GSgZSQ3wqRf7cxGhQZ/l8NmVVIvR
         JMUAxZdFuAJK2hD9Jjnnj/FpybqqUDLc0vl7UD9YXMsk9QWPtiiPPcT9eJxrV5Hmp8Ho
         uEp22E6pD5JnMPvZoVuP+K9CEF6Z4y4MASPzoZw60fKNDGsdHF7NlTGbjS4d+YBDPfOI
         EvDA==
X-Gm-Message-State: AOAM531nOYKDp1DNl6wasVOA01PaUh6vq2kObiQb1aRheV3Y4G5xHrpr
        F4j+QC/8bbF2+q2pPZZEyjxQa5FQefQ=
X-Google-Smtp-Source: ABdhPJxZlBSW8Tjroa/saKwIeIkybooY/9gR/FHRynVA2Y8lqwFAc7nl0OD25SYshf7kM6IRg9wkqg==
X-Received: by 2002:a17:902:dace:b0:14e:e471:a9c3 with SMTP id q14-20020a170902dace00b0014ee471a9c3mr19437458plx.49.1645456905174;
        Mon, 21 Feb 2022 07:21:45 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id d16sm13353965pfj.1.2022.02.21.07.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 07:21:44 -0800 (PST)
Date:   Mon, 21 Feb 2022 20:51:42 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        linux-kselftest@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: Add helpers to issue and check SYN
 cookies in XDP
Message-ID: <20220221152142.cm6fiag27g74bk6h@apollo.legion>
References: <20220124151340.376807-1-maximmi@nvidia.com>
 <20220124151340.376807-3-maximmi@nvidia.com>
 <61efacc6980f4_274ca2083e@john.notmuch>
 <8f5fecac-ce6e-adc8-305b-a2ee76328bce@nvidia.com>
 <61f850bdf1b23_8597208f8@john.notmuch>
 <61f852711e15a_92e0208ac@john.notmuch>
 <9cef58de-1f84-5988-92f8-fcdd3c61f689@nvidia.com>
 <61fc9483dfbe7_1d27c208e7@john.notmuch>
 <87a6f6bu6n.fsf@toke.dk>
 <6b6ce8a2-e409-0297-cb29-fe9493c9d637@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b6ce8a2-e409-0297-cb29-fe9493c9d637@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 07:56:28PM IST, Maxim Mikityanskiy wrote:
> On 2022-02-04 16:08, Toke Høiland-Jørgensen wrote:
> > John Fastabend <john.fastabend@gmail.com> writes:
> >
> > > Maxim Mikityanskiy wrote:
> > > > On 2022-01-31 23:19, John Fastabend wrote:
> > > > > John Fastabend wrote:
> > > > > > Maxim Mikityanskiy wrote:
> > > > > > > On 2022-01-25 09:54, John Fastabend wrote:
> > > > > > > > Maxim Mikityanskiy wrote:
> > > > > > > > > The new helpers bpf_tcp_raw_{gen,check}_syncookie allow an XDP program
> > > > > > > > > to generate SYN cookies in response to TCP SYN packets and to check
> > > > > > > > > those cookies upon receiving the first ACK packet (the final packet of
> > > > > > > > > the TCP handshake).
> > > > > > > > >
> > > > > > > > > Unlike bpf_tcp_{gen,check}_syncookie these new helpers don't need a
> > > > > > > > > listening socket on the local machine, which allows to use them together
> > > > > > > > > with synproxy to accelerate SYN cookie generation.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > > > > > > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > > > > > > > ---
> > > > > > > >
> > > > > > > > [...]
> > > > > > > >
> > > > > > > > > +
> > > > > > > > > +BPF_CALL_4(bpf_tcp_raw_check_syncookie, void *, iph, u32, iph_len,
> > > > > > > > > +	   struct tcphdr *, th, u32, th_len)
> > > > > > > > > +{
> > > > > > > > > +#ifdef CONFIG_SYN_COOKIES
> > > > > > > > > +	u32 cookie;
> > > > > > > > > +	int ret;
> > > > > > > > > +
> > > > > > > > > +	if (unlikely(th_len < sizeof(*th)))
> > > > > > > > > +		return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +	if (!th->ack || th->rst || th->syn)
> > > > > > > > > +		return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +	if (unlikely(iph_len < sizeof(struct iphdr)))
> > > > > > > > > +		return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +	cookie = ntohl(th->ack_seq) - 1;
> > > > > > > > > +
> > > > > > > > > +	/* Both struct iphdr and struct ipv6hdr have the version field at the
> > > > > > > > > +	 * same offset so we can cast to the shorter header (struct iphdr).
> > > > > > > > > +	 */
> > > > > > > > > +	switch (((struct iphdr *)iph)->version) {
> > > > > > > > > +	case 4:
> > > > > > > >
> > > > > > > > Did you consider just exposing __cookie_v4_check() and __cookie_v6_check()?
> > > > > > >
> > > > > > > No, I didn't, I just implemented it consistently with
> > > > > > > bpf_tcp_check_syncookie, but let's consider it.
> > > > > > >
> > > > > > > I can't just pass a pointer from BPF without passing the size, so I
> > > > > > > would need some wrappers around __cookie_v{4,6}_check anyway. The checks
> > > > > > > for th_len and iph_len would have to stay in the helpers. The check for
> > > > > > > TCP flags (ACK, !RST, !SYN) could be either in the helper or in BPF. The
> > > > > > > switch would obviously be gone.
> > > > > >
> > > > > > I'm not sure you would need the len checks in helper, they provide
> > > > > > some guarantees I guess, but the void * is just memory I don't see
> > > > > > any checks on its size. It could be the last byte of a value for
> > > > > > example?
> > > >
> > > > The verifier makes sure that the packet pointer and the size come
> > > > together in function parameters (see check_arg_pair_ok). It also makes
> > > > sure that the memory region defined by these two parameters is valid,
> > > > i.e. in our case it belongs to packet data.
> > > >
> > > > Now that the helper got a valid memory region, its length is still
> > > > arbitrary. The helper has to check it's big enough to contain a TCP
> > > > header, before trying to access its fields. Hence the checks in the helper.
> > > >
> > > > > I suspect we need to add verifier checks here anyways to ensure we don't
> > > > > walk off the end of a value unless something else is ensuring the iph
> > > > > is inside a valid memory block.
> > > >
> > > > The verifier ensures that the [iph; iph+iph_len) is valid memory, but
> > > > the helper still has to check that struct iphdr fits into this region.
> > > > Otherwise iph_len could be too small, and the helper would access memory
> > > > outside of the valid region.
> > >
> > > Thanks for the details this all makes sense. See response to
> > > other mail about adding new types. Replied to the wrong email
> > > but I think the context is not lost.
> >
> > Keeping my reply here in an attempt to de-fork :)
> >
> > > > > > >
> > > > > > > The bottom line is that it would be the same code, but without the
> > > > > > > switch, and repeated twice. What benefit do you see in this approach?
> > > > > >
> > > > > > The only benefit would be to shave some instructions off the program.
> > > > > > XDP is about performance so I figure we shouldn't be adding arbitrary
> > > > > > stuff here. OTOH you're already jumping into a helper so it might
> > > > > > not matter at all.
> > > > > >
> > > > > > >    From my side, I only see the ability to drop one branch at the expense
> > > > > > > of duplicating the code above the switch (th_len and iph_len checks).
> > > > > >
> > > > > > Just not sure you need the checks either, can you just assume the user
> > > > > > gives good data?
> > > >
> > > > No, since the BPF program would be able to trick the kernel into reading
> > > > from an invalid location (see the explanation above).
> > > >
> > > > > > >
> > > > > > > > My code at least has already run the code above before it would ever call
> > > > > > > > this helper so all the other bits are duplicate.
> > > > > > >
> > > > > > > Sorry, I didn't quite understand this part. What "your code" are you
> > > > > > > referring to?
> > > > > >
> > > > > > Just that the XDP code I maintain has a if ipv4 {...} else ipv6{...}
> > > > > > structure
> > > >
> > > > Same for my code (see the last patch in the series).
> > > >
> > > > Splitting into two helpers would allow to drop the extra switch in the
> > > > helper, however:
> > > >
> > > > 1. The code will be duplicated for the checks.
> > >
> > > See response wrt PTR_TO_IP, PTR_TO_TCP types.
> >
> > So about that (quoting some context from your other email):
> >
> > > We could have some new mem types, PTR_TO_IPV4, PTR_TO_IPv6, and PTR_TO_TCP.
> > > Then we simplify the helper signatures to just,
> > >
> > >    bpf_tcp_raw_check_syncookie_v4(iph, tcph);
> > >    bpf_tcp_raw_check_syncookie_v6(iph, tcph);
> > >
> > > And the verifier "knows" what a v4/v6 header is and does the mem
> > > check at verification time instead of run time.
> >
> > I think this could probably be achieved with PTR_TO_BTF arguments to the
> > helper (if we define appropriate struct types that the program can use
> > for each header type)?
>
> I get the following error when I try to pass the headers from packet data to
> a helper that accepts ARG_PTR_TO_BTF_ID:
>
> ; value = bpf_tcp_raw_gen_syncookie_ipv4(hdr->ipv4, hdr->tcp,
> 297: (79) r1 = *(u64 *)(r10 -80)      ; R1_w=pkt(id=0,off=14,r=74,imm=0)
> R10=fp0
> 298: (79) r2 = *(u64 *)(r10 -72)      ;
> R2_w=pkt(id=5,off=14,r=74,umax_value=60,var_off=(0x0; 0x3c)) R10=fp0
> 299: (bc) w3 = w9                     ;
> R3_w=invP(id=0,umin_value=20,umax_value=60,var_off=(0x0; 0x3c))
> R9=invP(id=0,umin_value=20,umax_value=60,var_off=(0x0; 0x3c))
> 300: (85) call bpf_tcp_raw_gen_syncookie_ipv4#192
> R1 type=pkt expected=ptr_
> processed 317 insns (limit 1000000) max_states_per_insn 0 total_states 23
> peak_states 23 mark_read 12
> -- END PROG LOAD LOG --
>
> It looks like the verifier doesn't currently support such type conversion.
> Could you give any clue what is needed to add this support? Is it enough to
> extend compatible_reg_types, or should more checks be added anywhere?
>

I think what he meant was getting the size hint from the function prototype. In
case of kfunc we do it by resolving type size from BTF, for the PTR_TO_MEM case
when a size argument is missing. For helper, you can add a field to indicate the
constant size hint in the bpf_func_proto, and then in check_func_arg directly do
the equivalent check_helper_mem_access for arg_type_is_mem_ptr block if such a
hint is set, instead of delaying it till check_mem_size_reg call when the next
arg_type_is_mem_size block is executed.

Then you can have two helpers with same argument types but different size hint
values for the header argument, so you wouldn't need an extra mem size parameter.

You may also want to disallow setting both the size hint and next argument as
ARG_CONST_SIZE.

> Alternatively, I can revert to ARG_PTR_TO_MEM and do size checks in runtime
> in the helper.
>
> [...]

--
Kartikeya
