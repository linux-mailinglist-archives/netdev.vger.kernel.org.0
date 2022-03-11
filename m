Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6684D5C5A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346926AbiCKHdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346390AbiCKHdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:33:38 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9593668B;
        Thu, 10 Mar 2022 23:32:34 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso7421786pjo.5;
        Thu, 10 Mar 2022 23:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=vSN1wn6WA/mrW3U+UgfiU1pGXuFwjJM68i7zH+ZYmAw=;
        b=Vl8f7MwA5C7eGkXP+NIWpW3iyV0mIdXW3J7nashMSnFETx0D0zcsIi7v/voHQTmS3O
         PEB6O6Uvh1e1MDMfsdqvMtA+tQzK9hfO8cjixclxaQ3s9yFv1hR+Q1Mh4LUmps0IKr5i
         WQy+nDMJA7WUx26wEH89eIl5Wmfbps8Y0ZZHG1h1Gg2+cSe7kSPVe2SXQaeVenvSNQta
         6iltRhyJkiWJZJdmrzXvdVhSlygQjJ+d7KELrD6culscMIVED0O7PcCLCQZ6vl+eVe+Z
         fKnxdHWLbeo38m6HrF3S8BU08RI8m96TzLUXw3+x0GBLRtmfXc2m4LhXnq+XwuIjarqF
         b83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=vSN1wn6WA/mrW3U+UgfiU1pGXuFwjJM68i7zH+ZYmAw=;
        b=h3qLXbIFrQo6AMjoUNdIdHc/9Zkknnl1Zl1qcEFngUYzzELy0as8oiYOkt7gPDRq9v
         npLARu40p4d5Xkda/lZfHdJYKeFeyuFfW94DJSdRCxjm+yxHSoxdVryWk+aZCS/uHTVx
         evsDovDMosi/6tWm/ndJF+4YhiAAw+ntxuJwzseb7hQAUB1gG01Fr44KFnpjiKaMN9G9
         5oAjLSefMTSCJ4oO16l96KKtWMAdsybk5Ii+80Kvov40ryvl+BZVIPIL92DsyYydRg6E
         o5xkPH+u32JyjyTErZ0dQyaWc9iCW2skhyO2Jr2ZTLjCQnbmlEaDLeAsjX4LVctecQaN
         6sWA==
X-Gm-Message-State: AOAM531KAy9+NSxmLk7mgv6gamoCJiz0mfPKfYcVekUoTa00dM/lW+AP
        StsNBP77qfLt/Zn5pEX2OIlEWzSXDpI=
X-Google-Smtp-Source: ABdhPJzVRinQVrDZmlgCJAqju9OVie6/AnYRsuJyZbv60KhRwIjQyk3Z0vDxFbJd2F0KbO/HUsMQWg==
X-Received: by 2002:a17:903:40c7:b0:151:a640:d69e with SMTP id t7-20020a17090340c700b00151a640d69emr8960134pld.121.1646983953607;
        Thu, 10 Mar 2022 23:32:33 -0800 (PST)
Received: from localhost ([112.79.142.206])
        by smtp.gmail.com with ESMTPSA id g20-20020a056a000b9400b004f705514955sm9169591pfj.107.2022.03.10.23.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 23:32:33 -0800 (PST)
Date:   Fri, 11 Mar 2022 13:02:24 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20220311073224.k66347mbotdpshm6@apollo>
References: <20220306234311.452206-1-memxor@gmail.com>
 <CAEf4BzaPhtUGhR1vTSNGVLAudA7fUDWqZZFDfFvHXi2MOdrN5w@mail.gmail.com>
 <20220308070828.4tjiuvvyqwmhru6a@apollo.legion>
 <87lexky33s.fsf@toke.dk>
 <CAEf4Bza6BhG7wtgmvWohEKpN5jSTyQwxm5-738oMoniz1v3uVw@mail.gmail.com>
 <87bkydxu59.fsf@toke.dk>
 <CAADnVQJPOCzyF-hBVOxCwqNj-vAk5=Dt6UvPdGok1b6s=Zdd7g@mail.gmail.com>
 <20220311072545.deeifraq4u74dagb@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220311072545.deeifraq4u74dagb@apollo>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 12:55:45PM IST, Kumar Kartikeya Dwivedi wrote:
> On Fri, Mar 11, 2022 at 05:05:24AM IST, Alexei Starovoitov wrote:
> > On Thu, Mar 10, 2022 at 3:30 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > >
> > > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> > >
> > > > On Tue, Mar 8, 2022 at 5:40 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > > >>
> > > >> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
> > > >>
> > > >> > On Tue, Mar 08, 2022 at 11:18:52AM IST, Andrii Nakryiko wrote:
> > > >> >> On Sun, Mar 6, 2022 at 3:43 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > >> >> >
> > > >> >> > Expose existing 'bpf_xdp_pointer' as a BPF helper named 'bpf_packet_pointer'
> > > >> >> > returning a packet pointer with a fixed immutable range. This can be useful to
> > > >> >> > enable DPA without having to use memcpy (currently the case in
> > > >> >> > bpf_xdp_load_bytes and bpf_xdp_store_bytes).
> > > >> >> >
> > > >> >> > The intended usage to read and write data for multi-buff XDP is:
> > > >> >> >
> > > >> >> >         int err = 0;
> > > >> >> >         char buf[N];
> > > >> >> >
> > > >> >> >         off &= 0xffff;
> > > >> >> >         ptr = bpf_packet_pointer(ctx, off, sizeof(buf), &err);
> > > >> >> >         if (unlikely(!ptr)) {
> > > >> >> >                 if (err < 0)
> > > >> >> >                         return XDP_ABORTED;
> > > >> >> >                 err = bpf_xdp_load_bytes(ctx, off, buf, sizeof(buf));
> > > >> >> >                 if (err < 0)
> > > >> >> >                         return XDP_ABORTED;
> > > >> >> >                 ptr = buf;
> > > >> >> >         }
> > > >> >> >         ...
> > > >> >> >         // Do some stores and loads in [ptr, ptr + N) region
> > > >> >> >         ...
> > > >> >> >         if (unlikely(ptr == buf)) {
> > > >> >> >                 err = bpf_xdp_store_bytes(ctx, off, buf, sizeof(buf));
> > > >> >> >                 if (err < 0)
> > > >> >> >                         return XDP_ABORTED;
> > > >> >> >         }
> > > >> >> >
> > > >> >> > Note that bpf_packet_pointer returns a PTR_TO_PACKET, not PTR_TO_MEM, because
> > > >> >> > these pointers need to be invalidated on clear_all_pkt_pointers invocation, and
> > > >> >> > it is also more meaningful to the user to see return value as R0=pkt.
> > > >> >> >
> > > >> >> > This series is meant to collect feedback on the approach, next version can
> > > >> >> > include a bpf_skb_pointer and exposing it as bpf_packet_pointer helper for TC
> > > >> >> > hooks, and explore not resetting range to zero on r0 += rX, instead check access
> > > >> >> > like check_mem_region_access (var_off + off < range), since there would be no
> > > >> >> > data_end to compare against and obtain a new range.
> > > >> >> >
> > > >> >> > The common name and func_id is supposed to allow writing generic code using
> > > >> >> > bpf_packet_pointer that works for both XDP and TC programs.
> > > >> >> >
> > > >> >> > Please see the individual patches for implementation details.
> > > >> >> >
> > > >> >>
> > > >> >> Joanne is working on a "bpf_dynptr" framework that will support
> > > >> >> exactly this feature, in addition to working with dynamically
> > > >> >> allocated memory, working with memory of statically unknown size (but
> > > >> >> safe and checked at runtime), etc. And all that within a generic
> > > >> >> common feature implemented uniformly within the verifier. E.g., it
> > > >> >> won't need any of the custom bits of logic added in patch #2 and #3.
> > > >> >> So I'm thinking that instead of custom-implementing a partial case of
> > > >> >> bpf_dynptr just for skb and xdp packets, let's maybe wait for dynptr
> > > >> >> and do it only once there?
> > > >> >>
> > > >> >
> > > >> > Interesting stuff, looking forward to it.
> > > >> >
> > > >> >> See also my ARG_CONSTANT comment. It seems like a pretty common thing
> > > >> >> where input constant is used to characterize some pointer returned
> > > >> >> from the helper (e.g., bpf_ringbuf_reserve() case), and we'll need
> > > >> >> that for bpf_dynptr for exactly this "give me direct access of N
> > > >> >> bytes, if possible" case. So improving/generalizing it now before
> > > >> >> dynptr lands makes a lot of sense, outside of bpf_packet_pointer()
> > > >> >> feature itself.
> > > >> >
> > > >> > No worries, we can continue the discussion in patch 1, I'll split out the arg
> > > >> > changes into a separate patch, and wait for dynptr to be posted before reworking
> > > >> > this.
> > > >>
> > > >> This does raise the question of what we do in the meantime, though? Your
> > > >> patch includes a change to bpf_xdp_{load,store}_bytes() which, if we're
> > > >> making it, really has to go in before those hit a release and become
> > > >> UAPI.
> > > >>
> > > >> One option would be to still make the change to those other helpers;
> > > >> they'd become a bit slower, but if we have a solution for that coming,
> > > >> that may be OK for a single release? WDYT?
> > > >
> > > > I must have missed important changes to bpf_xdp_{load,store}_bytes().
> > > > Does anything change about its behavior? If there are some fixes
> > > > specific to those helpers, we should fix them as well as a separate
> > > > patch. My main objection is adding a bpf_packet_pointer() special case
> > > > when we have a generic mechanism in the works that will come this use
> > > > case (among other use cases).
> > >
> > > Well it's not a functional change per se, but Kartikeya's patch is
> > > removing an optimisation from bpf_xdp_{load_store}_bytes() (i.e., the
> > > use of the bpf_xdp_pointer()) in favour of making it available directly
> > > to BPF. So if we don't do that change before those helpers are
> > > finalised, we will end up either introducing a performance regression
> > > for code using those helpers, or being stuck with the bpf_xdp_pointer()
> > > use inside them even though it makes more sense to move it out to BPF.
> > >
> > > So the "safe" thing to do would do the change to the store/load helpers
> > > now, and get rid of the bpf_xdp_pointer() entirely until it can be
> > > introduced as a BPF helper in a generic way. Of course this depends on
> > > whether you consider performance regressions to be something to avoid,
> > > but this being XDP IMO we should :)
> >
> > I don't follow this logic.
> > Would you mean by "get rid of the bpf_xdp_pointer" ?
> > It's just an internal static function.
> >
> > Also I don't believe that this patch set and exposing
> > bpf_xdp_pointer as a helper actually gives measurable performance wins.
> > It looks quirky to me and hard to use.
>
> This is actually inspired from your idea to avoid memcpy when reading and
> writing to multi-buff XDP [0]. But instead of passing in the stack or mem
> pointer (as discussed in that thread), I let the user set it and detect it
> themselves, which makes the implementation simpler.
>
> I am sure accessing a few bytes directly is going to be faster than first
> memcpy'ing it to a local buffer, reading, and then possibly writing things
> back again using a memcpy, but I will be happy to come with some numbers when
> I respin this later, when Joanne posts the dynptr series.
>
> Ofcourse, we could just make return value PTR_TO_MEM even for the 'pass buf
> pointer' idea, but then we have to conservatively invalidate the pointer even if
> it points to stack buffer on clear_all_pkt_pointers. The current approach looked
> better to me.
>
>   [0]: https://lore.kernel.org/bpf/CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com
>

This is probably the correct link:
https://lore.kernel.org/bpf/CAADnVQ+XXGUxzqMdbPMYf+t_ViDkqvGDdogrmv-wH-dckzujLw@mail.gmail.com

> --
> Kartikeya

--
Kartikeya
