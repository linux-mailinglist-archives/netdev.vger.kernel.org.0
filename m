Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463434D5F93
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347961AbiCKKf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347792AbiCKKfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:35:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD4C2FFFAD
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646994859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AFpqd9XuKFh4SCv736RPdexKUxPNZgm3VWQxXXniTfY=;
        b=Rutny/z1nK+pHCZpJL6pCknpRPuv+xm/JVhJR4m1zsVCdjC0F1I3+qYQPlqhWyHGQ526vV
        8JzVRhU5p7Mcdhy0bgt/c0MiGXNK9uPxpdNUpUc2mvNsmqwPaGm8IlH0qRgWPaM+jNqgy+
        FYIWcirnkF0ZJp7CqQlCRB/9Vxn2CQQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-hZFK6AdRPvyWPJ7T0pjACA-1; Fri, 11 Mar 2022 05:34:18 -0500
X-MC-Unique: hZFK6AdRPvyWPJ7T0pjACA-1
Received: by mail-ej1-f70.google.com with SMTP id q22-20020a1709064cd600b006db14922f93so4722690ejt.7
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:34:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=AFpqd9XuKFh4SCv736RPdexKUxPNZgm3VWQxXXniTfY=;
        b=YpWM269by7kdcIVHQ3DjmtaZ1p0MoInToGeQEEE+rAtDaPyVdImygq5FDF9ISEv4d2
         W2uPrpFpZeA/FiZOr4VAJLuxpoAefqWBB4HjQBpVlRCg1FQhlhFZ2H9typYEJcvOHviP
         Vt+bLaSPY8jeNJR8XQvODeVqccXlFZivmzFS8vb/9gD9gWFQLg8X1K8uw7rN6HFGj5zd
         a2eD+r/iobkhDDk6MqtKrX9rMo+AOjRtpBFmmUkeMLL4MXr5H8INwXkKE6QAP9x0ncm8
         15l6UP9s8NyX7qlcRSm0tL+5LJ45KusXMLaC1O1OWoo039wg0ehcB1vEn0MC+PF1Jyzh
         3aJg==
X-Gm-Message-State: AOAM532KDTRTu9PrVvGPc9ULQ5zBdZ3EnWpTULHYqww6brAavZUSw+fJ
        +oA3RTHLX9APk0gp2RcE14ltuTeumHafWdg/CmP8rkSyzq9EEw3vVpyVWVH5bx4TKWhVTlf8k9Q
        IImOV5H0JQfp+aV3f
X-Received: by 2002:a05:6402:42c6:b0:416:541:4be1 with SMTP id i6-20020a05640242c600b0041605414be1mr8313347edc.238.1646994857271;
        Fri, 11 Mar 2022 02:34:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxZkfgsnpO3nJEej09NNnqUV5pMG7/Qs6i7uzpcD2BEtMQVnFa9fP8qaVFgLMxjG3rgi7pscw==
X-Received: by 2002:a05:6402:42c6:b0:416:541:4be1 with SMTP id i6-20020a05640242c600b0041605414be1mr8313309edc.238.1646994856746;
        Fri, 11 Mar 2022 02:34:16 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d4-20020a1709067a0400b006d6e3ca9f71sm2811070ejo.198.2022.03.11.02.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 02:34:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EFA1E1A8AE4; Fri, 11 Mar 2022 11:34:14 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
In-Reply-To: <20220311071935.6k24jzdv7izzifto@apollo>
References: <20220306234311.452206-1-memxor@gmail.com>
 <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion> <87lexky33s.fsf@toke.dk>
 <CAEf4Bza6BhG7wtgmvWohEKpN5jSTyQwxm5-738oMoniz1v3uVw@mail.gmail.com>
 <87bkydxu59.fsf@toke.dk> <20220311071935.6k24jzdv7izzifto@apollo>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 11 Mar 2022 11:34:14 +0100
Message-ID: <878rtgydzt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Fri, Mar 11, 2022 at 05:00:42AM IST, Toke H=C3=B8iland-J=C3=B8rgensen =
wrote:
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Tue, Mar 8, 2022 at 5:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >>
>> >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>> >>
>> >> > On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
>> >> >> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gma=
il.com> wrote:
>> >> >> >
>> >> >> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_pac=
ket_pointer'
>> >> >> > returning a packet pointer with a fixed immutable range. This ca=
n be useful to
>> >> >> > enable DPA without having to use memcpy (currently the case in
>> >> >> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
>> >> >> >
>> >> >> > The intended usage to read and write data for multi-buff XDP is:
>> >> >> >
>> >> >> >         int err =3D 0;
>> >> >> >         char buf[N];
>> >> >> >
>> >> >> >         off &=3D 0xffff;
>> >> >> >         ptr =3D bpf_packet_pointer(ctx, off, sizeof(buf), &err);
>> >> >> >         if (unlikely(!ptr)) {
>> >> >> >                 if (err < 0)
>> >> >> >                         return XDP_ABORTED;
>> >> >> >                 err =3D bpf_xdp_load_bytes(ctx, off, buf, sizeof=
(buf));
>> >> >> >                 if (err < 0)
>> >> >> >                         return XDP_ABORTED;
>> >> >> >                 ptr =3D buf;
>> >> >> >         }
>> >> >> >         ...
>> >> >> >         // Do some stores and loads in [ptr, ptr + N) region
>> >> >> >         ...
>> >> >> >         if (unlikely(ptr =3D=3D buf)) {
>> >> >> >                 err =3D bpf_xdp_store_bytes(ctx, off, buf, sizeo=
f(buf));
>> >> >> >                 if (err < 0)
>> >> >> >                         return XDP_ABORTED;
>> >> >> >         }
>> >> >> >
>> >> >> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO=
_MEM, because
>> >> >> > these pointers need to be invalidated on clear_all_pkt_pointers =
invocation, and
>> >> >> > it is also more meaningful to the user to see return value as R0=
=3Dpkt.
>> >> >> >
>> >> >> > This series is meant to collect feedback on the approach, next v=
ersion can
>> >> >> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer =
helper for TC
>> >> >> > hooks, and explore not resetting range to zero on r0 +=3D rX, in=
stead check access
>> >> >> > like check_mem_region_access (var_off + off < range), since ther=
e would be no
>> >> >> > data_end to compare against and obtain a new range.
>> >> >> >
>> >> >> > The common name and func_id is supposed to allow writing generic=
 code using
>> >> >> > bpf_packet_pointer that works for both XDP and TC programs.
>> >> >> >
>> >> >> > Please see the individual patches for implementation details.
>> >> >> >
>> >> >>
>> >> >> Joanne is working on a "bpf_dynptr" framework that will support
>> >> >> exactly this feature, in addition to working with dynamically
>> >> >> allocated memory, working with memory of statically unknown size (=
but
>> >> >> safe and checked at runtime), etc. And all that within a generic
>> >> >> common feature implemented uniformly within the verifier. E.g., it
>> >> >> won't need any of the custom bits of logic added in patch #2 and #=
3.
>> >> >> So I'm thinking that instead of custom-implementing a partial case=
 of
>> >> >> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynp=
tr
>> >> >> and do it only once there?
>> >> >>
>> >> >
>> >> > Interesting stuff, looking forward to it.
>> >> >
>> >> >> See also my ARG_CONSTANT comment. It seems like a pretty common th=
ing
>> >> >> where input constant is used to characterize some pointer returned
>> >> >> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
>> >> >> that for bpf_dynptr for exactly this "give me direct access of N
>> >> >> bytes, if possible" case. So improving/generalizing it now before
>> >> >> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
>> >> >> feature itself.
>> >> >
>> >> > No worries, we can continue the discussion in patch 1, I'll split o=
ut the arg
>> >> > changes into a separate patch, and wait for dynptr to be posted bef=
ore reworking
>> >> > this.
>> >>
>> >> This does raise the question of what we do in the meantime, though? Y=
our
>> >> patch includes a change to bpf_xdp_{load,store}_bytes() which, if we'=
re
>> >> making it, really has to go in before those hit a release and become
>> >> UAPI.
>> >>
>> >> One option would be to still make the change to those other helpers;
>> >> they'd become a bit slower, but if we have a solution for that coming,
>> >> that may be OK for a single release? WDYT?
>> >
>> > I must have missed important changes to bpf_xdp_{load,store}_bytes().
>> > Does anything change about its behavior? If there are some fixes
>> > specific to those helpers, we should fix them as well as a separate
>> > patch. My main objection is adding a bpf_packet_pointer() special case
>> > when we have a generic mechanism in the works that will come this use
>> > case (among other use cases).
>>
>> Well it's not a functional change per se, but Kartikeya's patch is
>> removing an optimisation from bpf_xdp_{load_store}_bytes() (i.e., the
>> use of the bpf_xdp_pointer()) in favour of making it available directly
>> to BPF. So if we don't do that change before those helpers are
>> finalised, we will end up either introducing a performance regression
>> for code using those helpers, or being stuck with the bpf_xdp_pointer()
>> use inside them even though it makes more sense to move it out to BPF.
>>
>
> So IIUC, the case we're worried about is when a linear region is in head =
or a
> frag and bpf_xdp_pointer can be used to do a direct memcpy for it. But in=
 my
> testing there doesn't seem to be any difference. With or without the call=
, the
> time taken e.g. for bpf_xdp_load_bytes lies in the 30-40ns range. It woul=
d make
> sense, because for this case the code in bpf_xdp_pointer and bpf_xdp_copy=
_buf
> are almost the same, just that the latter has a conditional jump out of t=
he loop
> based on len. bpf_xdp_copy_buf is still only doing a single memcpy, the c=
ost
> seems to be dominated by that.
>
> Otoh, removing it would improve the case for the other scenario (when reg=
ion
> touches two or more frags) because we wouldn't spend time in bpf_xdp_poin=
ter and
> returning NULL from it failing to find a linear region, but that shouldn'=
t be a
> regression.

Yeah, that was basically what I was worried about; thanks for testing!
So this implies that the current use of the bpf_xdp_pointer() helper
function is pretty pointless, right? But at least it's an internal
detail so there's no hurry in fixing it...

-Toke

