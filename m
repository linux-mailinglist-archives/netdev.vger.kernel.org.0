Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C377E4D558A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238451AbiCJXgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbiCJXgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:36:38 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694881587A6;
        Thu, 10 Mar 2022 15:35:36 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id e6so6010811pgn.2;
        Thu, 10 Mar 2022 15:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=R2UPqxeH2jOb5yVGm3qiaUhx7jWSpr0mj8g5fRIgwDI=;
        b=JI5mOmwqt36wM6tnjxtdB/aJlLVZ7EoZlPouGY6EuulE6TxgmcgQQSbb7RXGnScTRw
         eiq/5uIC4VkIZ4cpA24oI08SOukzhZeNEAL/C3Cb8SLH28/JSadvcA56PSAM38zgXwSY
         qbRvrRO1iu0995wni+S04B2t5sl1rHMlnf2gC16Bo/Nr4aLLW8SZd64adZUzc3XIqxzc
         n8C231yylqKDi3A9WNIaRfbfBllGY2EHfysdOT/WzTAPYyHoc5/e5gw7NhFo2R9zf1av
         T7c6vcZooyaRPX3VBzBaNgRMhOwWgkd3ylaSTORYrsgfL0PFa7+4+pPnER287pkLhV1H
         9qiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=R2UPqxeH2jOb5yVGm3qiaUhx7jWSpr0mj8g5fRIgwDI=;
        b=FYn4uww2gqumqlCITbiAUjXifVzBlVvDIT4fP/pW2jD8OxYx/kG5WTdCNVGK805lpU
         ZPLrluZIMiQiDp5Y9FXgNb9FJNuTwpkleQE76IRkMLs/WdPi8m/RUptrGA9CJ3caOXAQ
         hRUx8Mn34UomfyL018O8ApKWY7+pEsM0QpBiRXRywuo8BkV8nAkSP8dqsJmHXNPwyqiT
         i6WEGICmwtsqJUojNR2ye6nDz2PjIHAzzL2braxaASTltxYXPFNyQZXIaMjuV0+brFip
         6Mj7Smw+bTeTQ35gdzanvNIkV9FmTI+fQjThug9ikEAqIN1aFYqumSBO0k/TQP2v+hi6
         xlQw==
X-Gm-Message-State: AOAM533riUWbzXAZK29YBP7SLZzwnFrVVhscI6BFCaXaQm7PJ3n4BWti
        F36dxcnqnJRwcRfaa8TlEZLEZ1alg+jC7N7ZKw4=
X-Google-Smtp-Source: ABdhPJz2e3LYyu6RGUzSQ74c7e24FcGECgx9vr+rY6x25FtDA1OgDgd6w+XMILUTlJ6wZK5LhdxuuxRWfzdTgG2wgLc=
X-Received: by 2002:a62:bd0e:0:b0:4f6:e07f:d4ee with SMTP id
 a14-20020a62bd0e000000b004f6e07fd4eemr7559056pff.46.1646955335812; Thu, 10
 Mar 2022 15:35:35 -0800 (PST)
MIME-Version: 1.0
References: <20220306234311.452206-1-memxor@gmail.com> <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion> <87lexky33s.fsf@toke.dk>
 <CAEf4Bza6BhG7wtgmvWohEKpN5jSTyQwxm5-738oMoniz1v3uVw@mail.gmail.com> <87bkydxu59.fsf@toke.dk>
In-Reply-To: <87bkydxu59.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Mar 2022 15:35:24 -0800
Message-ID: <CAADnVQJPOCzyF-hBVOxCwqNj-vAk5=Dt6UvPdGok1b6s=Zdd7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 0/5] Introduce bpf_packet_pointer helper
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
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

On Thu, Mar 10, 2022 at 3:30 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Mar 8, 2022 at 5:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> >>
> >> > On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
> >> >> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmai=
l.com> wrote:
> >> >> >
> >> >> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_pack=
et_pointer'
> >> >> > returning a packet pointer with a fixed immutable range. This can=
 be useful to
> >> >> > enable DPA without having to use memcpy (currently the case in
> >> >> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
> >> >> >
> >> >> > The intended usage to read and write data for multi-buff XDP is:
> >> >> >
> >> >> >         int err =3D 0;
> >> >> >         char buf[N];
> >> >> >
> >> >> >         off &=3D 0xffff;
> >> >> >         ptr =3D bpf_packet_pointer(ctx, off, sizeof(buf), &err);
> >> >> >         if (unlikely(!ptr)) {
> >> >> >                 if (err < 0)
> >> >> >                         return XDP_ABORTED;
> >> >> >                 err =3D bpf_xdp_load_bytes(ctx, off, buf, sizeof(=
buf));
> >> >> >                 if (err < 0)
> >> >> >                         return XDP_ABORTED;
> >> >> >                 ptr =3D buf;
> >> >> >         }
> >> >> >         ...
> >> >> >         // Do some stores and loads in [ptr, ptr + N) region
> >> >> >         ...
> >> >> >         if (unlikely(ptr =3D=3D buf)) {
> >> >> >                 err =3D bpf_xdp_store_bytes(ctx, off, buf, sizeof=
(buf));
> >> >> >                 if (err < 0)
> >> >> >                         return XDP_ABORTED;
> >> >> >         }
> >> >> >
> >> >> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_=
MEM, because
> >> >> > these pointers need to be invalidated on clear_all_pkt_pointers i=
nvocation, and
> >> >> > it is also more meaningful to the user to see return value as R0=
=3Dpkt.
> >> >> >
> >> >> > This series is meant to collect feedback on the approach, next ve=
rsion can
> >> >> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer h=
elper for TC
> >> >> > hooks, and explore not resetting range to zero on r0 +=3D rX, ins=
tead check access
> >> >> > like check_mem_region_access (var_off + off < range), since there=
 would be no
> >> >> > data_end to compare against and obtain a new range.
> >> >> >
> >> >> > The common name and func_id is supposed to allow writing generic =
code using
> >> >> > bpf_packet_pointer that works for both XDP and TC programs.
> >> >> >
> >> >> > Please see the individual patches for implementation details.
> >> >> >
> >> >>
> >> >> Joanne is working on a "bpf_dynptr" framework that will support
> >> >> exactly this feature, in addition to working with dynamically
> >> >> allocated memory, working with memory of statically unknown size (b=
ut
> >> >> safe and checked at runtime), etc. And all that within a generic
> >> >> common feature implemented uniformly within the verifier. E.g., it
> >> >> won't need any of the custom bits of logic added in patch #2 and #3=
.
> >> >> So I'm thinking that instead of custom-implementing a partial case =
of
> >> >> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynpt=
r
> >> >> and do it only once there?
> >> >>
> >> >
> >> > Interesting stuff, looking forward to it.
> >> >
> >> >> See also my ARG_CONSTANT comment. It seems like a pretty common thi=
ng
> >> >> where input constant is used to characterize some pointer returned
> >> >> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
> >> >> that for bpf_dynptr for exactly this "give me direct access of N
> >> >> bytes, if possible" case. So improving/generalizing it now before
> >> >> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
> >> >> feature itself.
> >> >
> >> > No worries, we can continue the discussion in patch 1, I'll split ou=
t the arg
> >> > changes into a separate patch, and wait for dynptr to be posted befo=
re reworking
> >> > this.
> >>
> >> This does raise the question of what we do in the meantime, though? Yo=
ur
> >> patch includes a change to bpf_xdp_{load,store}_bytes() which, if we'r=
e
> >> making it, really has to go in before those hit a release and become
> >> UAPI.
> >>
> >> One option would be to still make the change to those other helpers;
> >> they'd become a bit slower, but if we have a solution for that coming,
> >> that may be OK for a single release? WDYT?
> >
> > I must have missed important changes to bpf_xdp_{load,store}_bytes().
> > Does anything change about its behavior? If there are some fixes
> > specific to those helpers, we should fix them as well as a separate
> > patch. My main objection is adding a bpf_packet_pointer() special case
> > when we have a generic mechanism in the works that will come this use
> > case (among other use cases).
>
> Well it's not a functional change per se, but Kartikeya's patch is
> removing an optimisation from bpf_xdp_{load_store}_bytes() (i.e., the
> use of the bpf_xdp_pointer()) in favour of making it available directly
> to BPF. So if we don't do that change before those helpers are
> finalised, we will end up either introducing a performance regression
> for code using those helpers, or being stuck with the bpf_xdp_pointer()
> use inside them even though it makes more sense to move it out to BPF.
>
> So the "safe" thing to do would do the change to the store/load helpers
> now, and get rid of the bpf_xdp_pointer() entirely until it can be
> introduced as a BPF helper in a generic way. Of course this depends on
> whether you consider performance regressions to be something to avoid,
> but this being XDP IMO we should :)

I don't follow this logic.
Would you mean by "get rid of the bpf_xdp_pointer" ?
It's just an internal static function.

Also I don't believe that this patch set and exposing
bpf_xdp_pointer as a helper actually gives measurable performance wins.
It looks quirky to me and hard to use.
