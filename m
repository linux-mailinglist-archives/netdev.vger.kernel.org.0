Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB8D50CD59
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 22:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236990AbiDWUIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 16:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiDWUIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 16:08:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4B37187446
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 13:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650744346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omqCTV7z0t9cAhQIWiyGEWe7yOix1dL5G0MldE6hRWE=;
        b=MKgz7uuKvNw3mwBqo7aFQhcszb2s/hMfWGZRALN8jaJgVx96W7l3LEKXM3eneH4C8bGkUM
        DEr8RYxwB+NnpXyw0JcdoXTzcJV0VGUPA/G84MP47aXVul+4sE0xJkCM9h2KpuTtkWszmg
        mdOaw8t+h3ColmFqTa17U5k2R23Up5M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-179-yqtl-5ZdPvygrnMox-a1Fw-1; Sat, 23 Apr 2022 16:05:44 -0400
X-MC-Unique: yqtl-5ZdPvygrnMox-a1Fw-1
Received: by mail-ej1-f70.google.com with SMTP id nc20-20020a1709071c1400b006f3726da7d3so720860ejc.15
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 13:05:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=omqCTV7z0t9cAhQIWiyGEWe7yOix1dL5G0MldE6hRWE=;
        b=rm75ZNLKj2iK89lRnfq6KnNcn85TMeubXc0Gr/3DEme2u234T4g3M8qSVjx3Dd82LH
         3A2fpP0Z4VX2fxDH/E6TQT/mAugDMm//0sdTG1YpVzVuK0NJCl+dygmFZYMtvC/khZ2z
         JaG50YnRESCfVSroCpYx/xFDar6gt7Gw5rt8F5nQ6dhHoRl1WOpp+pvh0pISNFmq3v7o
         nh/pPQSPnJT03DjcxBL6Q9Y4pBQ99RcCw8HNpHHVb5eWM2Z0RWkmVQCgUnqSDNRvcO/D
         TAJcuYo/dqJsNuIfGxohHauRSoOOxJpF9Xdwx38S6tvkSPpFWB9Jlnu+ecO7Hhz0HM0X
         pGxw==
X-Gm-Message-State: AOAM530MfBfpsK89IbQdsELe2//lmT064Uf13sssPwLN/u63jUOOgkAF
        JMu7TuOiCEu8NmTSS46Fhewy3xu20RvVSLcJeADblUWauCvNWrGbVRYEse/MK6UikKe+Upq4tsM
        +BNOh2SPc8HNWxpHY
X-Received: by 2002:aa7:c793:0:b0:408:4a69:90b4 with SMTP id n19-20020aa7c793000000b004084a6990b4mr11441733eds.58.1650744342332;
        Sat, 23 Apr 2022 13:05:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNATyw5D0bERdGDSDbR5cr0iO3FsZbehP/gW+psGoNThVAdHDplZOXPi3qHJP4nJhcVj+Z6w==
X-Received: by 2002:aa7:c793:0:b0:408:4a69:90b4 with SMTP id n19-20020aa7c793000000b004084a6990b4mr11441658eds.58.1650744341414;
        Sat, 23 Apr 2022 13:05:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e19-20020a056402105300b004162d0b4cbbsm2502266edu.93.2022.04.23.13.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 13:05:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DE7992D1FA3; Sat, 23 Apr 2022 22:05:39 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: Accessing XDP packet memory from the end
In-Reply-To: <20220422164137.875143-1-alexandr.lobakin@intel.com>
References: <20220421155620.81048-1-larysa.zaremba@intel.com>
 <87czhagxuw.fsf@toke.dk>
 <20220422164137.875143-1-alexandr.lobakin@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 23 Apr 2022 22:05:39 +0200
Message-ID: <87a6cbd0q4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <alexandr.lobakin@intel.com> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date: Thu, 21 Apr 2022 19:17:11 +0200
>
>> Larysa Zaremba <larysa.zaremba@intel.com> writes:
>>=20
>> > Dear all,
>> > Our team has encountered a need of accessing data_meta in a following =
way:
>> >
>> > int xdp_meta_prog(struct xdp_md *ctx)
>> > {
>> > 	void *data_meta_ptr =3D (void *)(long)ctx->data_meta;
>> > 	void *data_end =3D (void *)(long)ctx->data_end;
>> > 	void *data =3D (void *)(long)ctx->data;
>> > 	u64 data_size =3D sizeof(u32);
>> > 	u32 magic_meta;
>> > 	u8 offset;
>> >
>> > 	offset =3D (u8)((s64)data - (s64)data_meta_ptr);
>> > 	if (offset < data_size) {
>> > 		bpf_printk("invalid offset: %ld\n", offset);
>> > 		return XDP_DROP;
>> > 	}
>> >
>> > 	data_meta_ptr +=3D offset;
>> > 	data_meta_ptr -=3D data_size;
>> >
>> > 	if (data_meta_ptr + data_size > data) {
>> > 		return XDP_DROP;
>> > 	}
>> >=20=09=09
>> > 	magic_meta =3D *((u32 *)data);
>> > 	bpf_printk("Magic: %d\n", magic_meta);
>> > 	return XDP_PASS;
>> > }
>> >
>> > Unfortunately, verifier claims this code attempts to access packet with
>> > an offset of -2 (a constant part) and negative offset is generally for=
bidden.
>> >
>> > For now we have 2 solutions, one is using bpf_xdp_adjust_meta(),
>> > which is pretty good, but not ideal for the hot path.
>> > The second one is the patch at the end.
>> >
>> > Do you see any other way of accessing memory from the end of data_meta=
/data?
>> > What do you think about both suggested solutions?
>>=20
>> The problem is that the compiler is generating code that the verifier
>> doesn't understand. It's notoriously hard to get LLVM to produce code
>> that preserves the right bounds checks which is why projects like Cilium
>> use helpers with inline ASM to produce the right loads, like in [0].
>>=20
>> Adapting that cilium helper to load from the metadata area, your example
>> can be rewritten as follows (which works just fine with no verifier
>> changes):
>>=20
>> static __always_inline int
>> xdp_load_meta_bytes(const struct xdp_md *ctx, __u64 off, void *to, const=
 __u64 len)
>> {
>> 	void *from;
>> 	int ret;
>> 	/* LLVM tends to generate code that verifier doesn't understand,
>> 	 * so force it the way we want it in order to open up a range
>> 	 * on the reg.
>> 	 */
>> 	asm volatile("r1 =3D *(u32 *)(%[ctx] +8)\n\t"
>> 		     "r2 =3D *(u32 *)(%[ctx] +0)\n\t"
>> 		     "%[off] &=3D %[offmax]\n\t"
>> 		     "r1 +=3D %[off]\n\t"
>> 		     "%[from] =3D r1\n\t"
>> 		     "r1 +=3D %[len]\n\t"
>> 		     "if r1 > r2 goto +2\n\t"
>> 		     "%[ret] =3D 0\n\t"
>> 		     "goto +1\n\t"
>> 		     "%[ret] =3D %[errno]\n\t"
>> 		     : [ret]"=3Dr"(ret), [from]"=3Dr"(from)
>> 		     : [ctx]"r"(ctx), [off]"r"(off), [len]"ri"(len),
>> 		       [offmax]"i"(__CTX_OFF_MAX), [errno]"i"(-EINVAL)
>> 		     : "r1", "r2");
>> 	if (!ret)
>> 		__builtin_memcpy(to, from, len);
>> 	return ret;
>> }
>>=20
>>=20
>> SEC("xdp")
>> int xdp_meta_prog(struct xdp_md *ctx)
>> {
>>         void *data_meta_ptr =3D (void *)(long)ctx->data_meta;
>>         void *data =3D (void *)(long)ctx->data;
>>         __u32 magic_meta;
>>         __u8 offset;
>> 	int ret;
>>=20
>>         offset =3D (__u8)((__s64)data - (__s64)data_meta_ptr);
>> 	ret =3D xdp_load_meta_bytes(ctx, offset - 4, &magic_meta, sizeof(magic_=
meta));
>> 	if (ret) {
>> 		bpf_printk("load bytes failed: %d\n", ret);
>>                 return XDP_DROP;
>> 	}
>>=20
>>         bpf_printk("Magic: %d\n", magic_meta);
>>         return XDP_PASS;
>> }
>
> At the moment, we use this (based on Cilium's and your), it works
> just like we want C code to work previously:
>
> #define __CTX_OFF_MAX 0xff
>
> static __always_inline void *
> can_i_access_meta_please(const struct xdp_md *ctx, __u64 off, const __u64=
 len)
> {
> 	void *ret;
>
> 	/* LLVM tends to generate code that verifier doesn't understand,
> 	 * so force it the way we want it in order to open up a range
> 	 * on the reg.
> 	 */
> 	asm volatile("r1 =3D *(u32 *)(%[ctx] +8)\n\t"
> 		     "r2 =3D *(u32 *)(%[ctx] +0)\n\t"
> 		     "%[off] &=3D %[offmax]\n\t"
> 		     "r1 +=3D %[off]\n\t"
> 		     "%[ret] =3D r1\n\t"
> 		     "r1 +=3D %[len]\n\t"
> 		     "if r1 > r2 goto +1\n\t"
> 		     "goto +1\n\t"
> 		     "%[ret] =3D %[null]\n\t"
> 		     : [ret]"=3Dr"(ret)
> 		     : [ctx]"r"(ctx), [off]"r"(off), [len]"ri"(len),
> 		       [offmax]"i"(__CTX_OFF_MAX), [null]"i"(NULL)
> 		     : "r1", "r2");
>
> 	return ret;
> }
>
> SEC("xdp")
> int xdp_prognum_n0_meta(struct xdp_md *ctx)
> {
> 	void *data_meta =3D (void *)(__s64)ctx->data_meta;
> 	void *data =3D (void *)(__s64)ctx->data;
> 	struct xdp_meta_generic *md;
> 	__u64 offset;
>
> 	offset =3D (__u64)((__s64)data - (__s64)data_meta);
>
> 	md =3D can_i_access_meta_please(ctx, offset, sizeof(*md));
> 	if (__builtin_expect(!md, 0)) {
> 		bpf_printk("No you can't\n");
> 		return XDP_DROP;
> 	}
>
> 	bpf_printk("Magic: 0x%04x\n", md->magic_id);
> 	return XDP_PASS;
> }
>
> Thanks for the help!

Great! You're welcome! :)

> It's a shame LLVM still suck on generating correct object code from C.
> I guess we'll define a helper above in one of the headers to not
> copy-paste it back and forth between each program wanting to access
> only the generic part of the metadata (which is always being placed at
> the end).

Yeah, it would be nice if LLVM could just generate code that works, but
in the meantime we'll just have to define a helper. I suspect we'll need
to define some helper functions to work with xdp-hints style metadata
field anyway, so wrapping the reader into that somewhere would probably
make sense, no?

-Toke

