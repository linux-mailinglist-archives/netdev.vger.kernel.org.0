Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65D6EAEBA
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjDUQJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjDUQJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:09:20 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7719719B6;
        Fri, 21 Apr 2023 09:09:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-504eb1155d3so13575299a12.1;
        Fri, 21 Apr 2023 09:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682093358; x=1684685358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6nFZkGAQHDLDKXsLrnKLoGsBBd86+v29OZnbsaAUD4=;
        b=qS8C1doa/3nAAHuZjTCqd1z7m0xzFS9xmUFWkSISL6zGj4ub+0hkTzvvWobc4r6jCo
         77a4KH0OeTPeVuqaZ8hhkjGAQoLZ57jIKBHs2667eQPH7Ue0x7VAIEFlTFyjK5d/3LeX
         +A/UNPLO+1zdE85D6/lHV7DXgoXikVrM7pgXJXpU22fu5/5dHsxgqk625/CUML6fZA41
         hlRTJsrfA515dlXAsUJd5zAjFRCRvrdsddUBxEZ2HpLXYD33aHSF3lw+QSL0a5X4kuZT
         tK23I1TAh4KHt/3lNaMuhtSpal/fi7MxUT+PuFv2hEemck09krJ1dZA7jUQ3B8j6taJV
         PLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682093358; x=1684685358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6nFZkGAQHDLDKXsLrnKLoGsBBd86+v29OZnbsaAUD4=;
        b=S1HXjRw6o+sz5jyw+Z5564WUDoQRawH6oB7cL/Yx9TzJNszQzqrLYQeZIw8Bsdx1LH
         f4BpLla53tqGVvaTu2PFnIzEZD9Scyi92/a2vOG5L386anLBpkKqSLylVUThIh1n0PjL
         8IzQJL1fFeEyqjqht3rr2j4xfM8L7/PWz2Q3PQzDEKNNiS9cNjZyUtpnQkBEgM46d8lr
         YKzyhydSTh924U2sXO8cm9Lp7nLDMwsIVKyJi4xNU/aAtU7a8H8mVHRKaEcOiJKYICm/
         tD9J8pogoD7RlEAelv4pBoOW/M7fPIKc71HEgp+MR6Gdggtag8wWrgnt4/t8L6ZqU3uK
         WMWA==
X-Gm-Message-State: AAQBX9cbhFo5N9c0Jyw0fkIJsNKXdaoPcplt+dDjCnXP/O54N6P9KWiY
        PC5J1UPQs/GoR2+ECGTl12n+jvt152q3RjcGNoLSCoIBy0Y=
X-Google-Smtp-Source: AKy350aBgjE3PSnNXfAEWtlBdeoB+8SnjTBEB6yX1XMnulsiIf2kGx8pV6wpzyw+STDKadG2uRKecbBn67mF52TzeJM=
X-Received: by 2002:a05:6402:12c2:b0:506:a44c:e213 with SMTP id
 k2-20020a05640212c200b00506a44ce213mr4664284edx.20.1682093357789; Fri, 21 Apr
 2023 09:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230420124455.31099-1-fw@strlen.de> <20230420124455.31099-8-fw@strlen.de>
 <20230420201655.77kkgi3dh7fesoll@MacBook-Pro-6.local> <20230421155246.GD12121@breakpoint.cc>
In-Reply-To: <20230421155246.GD12121@breakpoint.cc>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Apr 2023 09:09:06 -0700
Message-ID: <CAADnVQLtKtrH-UhaJdn+5d+qObcuQ8TEuVDbpqx2Az=dN1DwWw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 7/7] selftests/bpf: add missing netfilter
 return value and ctx access tests
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>, Quentin Deslandes <qde@naccy.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 8:52=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > On Thu, Apr 20, 2023 at 02:44:55PM +0200, Florian Westphal wrote:
> > > +
> > > +SEC("netfilter")
> > > +__description("netfilter valid context access")
> > > +__success __failure_unpriv
> > > +__retval(1)
> > > +__naked void with_invalid_ctx_access_test5(void)
> > > +{
> > > +   asm volatile ("                                 \
> > > +   r2 =3D *(u64*)(r1 + %[__bpf_nf_ctx_state]);       \
> > > +   r1 =3D *(u64*)(r1 + %[__bpf_nf_ctx_skb]);         \
> > > +   r0 =3D 1;                                         \
> > > +   exit;                                           \
> > > +"  :
> > > +   : __imm_const(__bpf_nf_ctx_state, offsetof(struct bpf_nf_ctx, sta=
te)),
> > > +     __imm_const(__bpf_nf_ctx_skb, offsetof(struct bpf_nf_ctx, skb))
> > > +   : __clobber_all);
> >
> > Could you write this one in C instead?
> >
> > Also check that skb and state are dereferenceable after that.
>
> My bad. Added this and that:
>
> SEC("netfilter")
> __description("netfilter valid context read and invalid write")
> __failure __msg("only read is supported")
> int with_invalid_ctx_access_test5(struct bpf_nf_ctx *ctx)
> {
>   struct nf_hook_state *state =3D (void *)ctx->state;
>
>   state->sk =3D NULL;
>   return 1;
> }
>
> SEC("netfilter")
> __description("netfilter test prog with skb and state read access")
> __success __failure_unpriv
> __retval(0)
> int with_valid_ctx_access_test6(struct bpf_nf_ctx *ctx)
> {
>   const struct nf_hook_state *state =3D ctx->state;
>   struct sk_buff *skb =3D ctx->skb;
>   const struct iphdr *iph;
>   const struct tcphdr *th;
>   u8 buffer_iph[20] =3D {};
>   u8 buffer_th[40] =3D {};
>   struct bpf_dynptr ptr;
>   uint8_t ihl;
>
>   if (skb->len <=3D 20 || bpf_dynptr_from_skb(skb, 0, &ptr))
>         return 1;

Use NF_ACCEPT instead of 1 ?
Sadly it's not an enum yet, so it's not in vmlinux.h
The prog would need to manually #define it.

>
>   iph =3D bpf_dynptr_slice(&ptr, 0, buffer_iph, sizeof(buffer_iph));
>   if (!iph)
>     return 1;
>
>    if (state->pf !=3D 2)
>      return 1;
>
>    ihl =3D iph->ihl << 2;
>    th =3D bpf_dynptr_slice(&ptr, ihl, buffer_th, sizeof(buffer_th));
>    if (!th)
>         return 1;
>
>      return th->dest =3D=3D bpf_htons(22) ? 1 : 0;
> }

Perfect. That's what I wanted to see.
Without above example it's hard for people to see how ctx->skb
can be accessed to parse the packet.

> "Worksforme".  Is there anything else thats missing?
> If not I'll send v5 on Monday.

ship it any time. Don't delay.
