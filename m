Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D8A4D5523
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344210AbiCJXN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241967AbiCJXNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:13:23 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E988F19ABCB;
        Thu, 10 Mar 2022 15:12:21 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id q11so8304967iod.6;
        Thu, 10 Mar 2022 15:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dxCHAjsDCTNBJKyEwkL56V3bK7pD9RSNMgx9E8Iptqs=;
        b=VfHxDVJICHGUMwmhobHcWJ09/45B5rL0He6UelxYJp43oIKB9SB1VvGdbElWfEOqxJ
         439B0qQB+kj3+H2g+DA9X3qGw/AA72SiXQnzEuWgxGAlwHMiRxAiy4Vd7Lnp2YgebNh7
         58v4mvdiZ3J4MsXaQ5IVMjbiQIKjS644xmeJ7lrg0d0aVhvQLhdJr5WL1ob60lfLQOqL
         89qEuFPkVjpxIOBEVXC9raCSVi0XxfGbS3fv7pRmcSPWUxmmTFRVLfpvJ4DLy+T1olbG
         yl4qzmjE9jaMskn2SOQSEdB42HFeAHTFLKnZ48Pd671dtWQAIA2+hfK8CUhNtgKhb35T
         P07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dxCHAjsDCTNBJKyEwkL56V3bK7pD9RSNMgx9E8Iptqs=;
        b=iyz0Totao0oYm9TxlxnAneeBaL8m1EsaviamDRluUodqMyvI/GOiRBvoIGa3YjWyal
         O8bl4KI/V0lzV30hI0gpN8Iqlyv66Qjqc5vdDPZV6EsI6fODDWcOT53KgtOZaaXuYTgM
         8gD9Tq4JEmnapXc2SiVFhcPyrNV5bC6BkoTrSkPGX+mqg6YpVCpqxODEvKdt3fwoLE/H
         xufcqeSrssK+rF5ED7QJXosOI1nb0FTAmraU6e0OJISMkx0eJ8M4RxBWQi5N5S95S1/x
         FvjB356kHytKOGOWAjNW3Cn4H/cqRVsNR90b7hLFQdfM426erJG9tM6dMWXenDC8xlg2
         O7tQ==
X-Gm-Message-State: AOAM533ifRnsX42JdkTLkJLBgpI5zigJ8GEcYbVwwtfadoX1a/XBzko/
        Y7E4dRfaZq6+Rf2VqWDhbPtK2+Pk2GD0eqO0V2A=
X-Google-Smtp-Source: ABdhPJzj010mbCfGWOgXWrtCT/ERGcFxEkoCnXh09bDgXAuSfCqLSTCWZHTCMgDxTpxmlL02KCmIcl+5U2wEm2bmsL4=
X-Received: by 2002:a05:6638:33a8:b0:319:cb5c:f6d9 with SMTP id
 h40-20020a05663833a800b00319cb5cf6d9mr946015jav.93.1646953941324; Thu, 10 Mar
 2022 15:12:21 -0800 (PST)
MIME-Version: 1.0
References: <20220306234311.452206-1-memxor@gmail.com> <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion> <87lexky33s.fsf@toke.dk>
In-Reply-To: <87lexky33s.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Mar 2022 15:12:10 -0800
Message-ID: <CAEf4Bza6BhG7wtgmvWohEKpN5jSTyQwxm5-738oMoniz1v3uVw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Lorenz Bauer <linux@lmb.io>,
        Networking <netdev@vger.kernel.org>
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

On Tue, Mar 8, 2022 at 5:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
> >> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.c=
om> wrote:
> >> >
> >> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_=
pointer'
> >> > returning a packet pointer with a fixed immutable range. This can be=
 useful to
> >> > enable DPA without having to use memcpy (currently the case in
> >> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
> >> >
> >> > The intended usage to read and write data for multi-buff XDP is:
> >> >
> >> >         int err =3D 0;
> >> >         char buf[N];
> >> >
> >> >         off &=3D 0xffff;
> >> >         ptr =3D bpf_packet_pointer(ctx, off, sizeof(buf), &err);
> >> >         if (unlikely(!ptr)) {
> >> >                 if (err < 0)
> >> >                         return XDP_ABORTED;
> >> >                 err =3D bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf=
));
> >> >                 if (err < 0)
> >> >                         return XDP_ABORTED;
> >> >                 ptr =3D buf;
> >> >         }
> >> >         ...
> >> >         // Do some stores and loads in [ptr, ptr + N) region
> >> >         ...
> >> >         if (unlikely(ptr =3D=3D buf)) {
> >> >                 err =3D bpf_xdp_store_bytes(ctx, off, buf, sizeof(bu=
f));
> >> >                 if (err < 0)
> >> >                         return XDP_ABORTED;
> >> >         }
> >> >
> >> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM=
, because
> >> > these pointers need to be invalidated on clear_all_pkt_pointers invo=
cation, and
> >> > it is also more meaningful to the user to see return value as R0=3Dp=
kt.
> >> >
> >> > This series is meant to collect feedback on the approach, next versi=
on can
> >> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer help=
er for TC
> >> > hooks, and explore not resetting range to zero on r0 +=3D rX, instea=
d check access
> >> > like check_mem_region_access (var_off + off < range), since there wo=
uld be no
> >> > data_end to compare against and obtain a new range.
> >> >
> >> > The common name and func_id is supposed to allow writing generic cod=
e using
> >> > bpf_packet_pointer that works for both XDP and TC programs.
> >> >
> >> > Please see the individual patches for implementation details.
> >> >
> >>
> >> Joanne is working on a "bpf_dynptr" framework that will support
> >> exactly this feature, in addition to working with dynamically
> >> allocated memory, working with memory of statically unknown size (but
> >> safe and checked at runtime), etc. And all that within a generic
> >> common feature implemented uniformly within the verifier. E.g., it
> >> won't need any of the custom bits of logic added in patch #2 and #3.
> >> So I'm thinking that instead of custom-implementing a partial case of
> >> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynptr
> >> and do it only once there?
> >>
> >
> > Interesting stuff, looking forward to it.
> >
> >> See also my ARG_CONSTANT comment. It seems like a pretty common thing
> >> where input constant is used to characterize some pointer returned
> >> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
> >> that for bpf_dynptr for exactly this "give me direct access of N
> >> bytes, if possible" case. So improving/generalizing it now before
> >> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
> >> feature itself.
> >
> > No worries, we can continue the discussion in patch 1, I'll split out t=
he arg
> > changes into a separate patch, and wait for dynptr to be posted before =
reworking
> > this.
>
> This does raise the question of what we do in the meantime, though? Your
> patch includes a change to bpf_xdp_{load,store}_bytes() which, if we're
> making it, really has to go in before those hit a release and become
> UAPI.
>
> One option would be to still make the change to those other helpers;
> they'd become a bit slower, but if we have a solution for that coming,
> that may be OK for a single release? WDYT?

I must have missed important changes to bpf_xdp_{load,store}_bytes().
Does anything change about its behavior? If there are some fixes
specific to those helpers, we should fix them as well as a separate
patch. My main objection is adding a bpf_packet_pointer() special case
when we have a generic mechanism in the works that will come this use
case (among other use cases).

>
> -Toke
>
