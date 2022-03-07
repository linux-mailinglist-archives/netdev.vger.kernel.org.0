Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E9B4D0607
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244624AbiCGSM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiCGSM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA5265813;
        Mon,  7 Mar 2022 10:12:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B154612D8;
        Mon,  7 Mar 2022 18:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4755C340EF;
        Mon,  7 Mar 2022 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646676722;
        bh=7SnCPkdwsxJGwpkdFqlHuUuDSdeXpOUHPBz01VNaJaE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=uEGbH611keqViMtcvSDFfr04yicHxU+HboFesqdEiydQBak3alHEjkzuKTxpzPGla
         3pMmSIxsb3NxypO7rjoFWjjTNLHIX6nmFSkkH4wZXmF7ZB028kTBBdqOJ/rMbHu+X+
         BDbhxVhTw8AGyjKAR6vBiPFFfjjzfIMp5ULo9OY1abxANhVz9xryZY0QLs8zNnKN9V
         g4+k7MheWv5Mt6jQFMEG7lhWbTjj4OG/527rGF+IB1Ll7I+W7w9eaXRQg64lkN748R
         GXmM4mZyVp82jCm841EXGRBQrdm306+l67gXeZxnBMfLznjcwMshImBfm9vQ0HxsaL
         +a4fVodNPsHvA==
Received: by mail-yb1-f170.google.com with SMTP id l2so13190233ybe.8;
        Mon, 07 Mar 2022 10:12:02 -0800 (PST)
X-Gm-Message-State: AOAM532L66tU+k/9qKud/syfLhoVLo3D3RjqxA5KEFWSCh0nEWYtBDPV
        knhJ7ETIHq1kHbQhtaJpk204SoJI3BpcfSI+XoQ=
X-Google-Smtp-Source: ABdhPJwILUMoOgkBhUjC+vc910B4Xeebwa3HBZyw9YZNJbz9I1ydBkpMbaTWiwiyIzw/MiTvG/mOEQeCZrB2btDc64E=
X-Received: by 2002:a25:8b81:0:b0:629:17d5:68c1 with SMTP id
 j1-20020a258b81000000b0062917d568c1mr8199079ybl.449.1646676721862; Mon, 07
 Mar 2022 10:12:01 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <CAPhsuW5APYjoZWKDkZ9CBZzaF0NfSQQ-OeZSJgDa=wB-5O+Wng@mail.gmail.com> <CAO-hwJJkhxDAhT_cwo=Tkx8_=B-MuS=_enByj1t6GEuXD9Lj5Q@mail.gmail.com>
In-Reply-To: <CAO-hwJJkhxDAhT_cwo=Tkx8_=B-MuS=_enByj1t6GEuXD9Lj5Q@mail.gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Mar 2022 10:11:51 -0800
X-Gmail-Original-Message-ID: <CAPhsuW54ytOFrpW8+2kTuxNxu+-7JNmybCpbU=uG+un+-Xpw4A@mail.gmail.com>
Message-ID: <CAPhsuW54ytOFrpW8+2kTuxNxu+-7JNmybCpbU=uG+un+-Xpw4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/28] Introduce eBPF support for HID devices
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 5, 2022 at 2:23 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> > >
> >
> > The set looks good so far. I will review the rest later.
> >
> > [...]
> >
> > A quick note about how we organize these patches. Maybe we can
> > merge some of these patches like:
>
> Just to be sure we are talking about the same thing: you mean squash
> the patch together?

Right, squash some patches together.

>
> >
> > >   bpf: introduce hid program type
> > >   bpf/hid: add a new attach type to change the report descriptor
> > >   bpf/hid: add new BPF type to trigger commands from userspace
> > I guess the three can merge into one.
> >
> > >   HID: hook up with bpf
> > >   HID: allow to change the report descriptor from an eBPF program
> > >   HID: bpf: compute only the required buffer size for the device
> > >   HID: bpf: only call hid_bpf_raw_event() if a ctx is available
> > I haven't read through all of them, but I guess they can probably merge
> > as well.
>
> There are certainly patches that we could squash together (3 and 4
> from this list into the previous ones), but I'd like to keep some sort
> of granularity here to not have a patch bomb that gets harder to come
> back later.

Totally agreed with the granularity of patches. I am not a big fan of patch
bombs either. :)

I guess the problem I have with the current version is that I don't have a
big picture of the design while reading through relatively big patches. A
overview with the following information in the cover letter would be really
help here:
  1. How different types of programs are triggered (IRQ, user input, etc.);
  2. What are the operations and/or outcomes of these programs;
  3. How would programs of different types (or attach types) interact
   with each other (via bpf maps? chaining?)
  4. What's the new uapi;
  5. New helpers and other logistics

Sometimes, I find the changes to uapi are the key for me to understand the
patches, and I would like to see one or two patches with all the UAPI
changes (i.e. bpf_hid_attach_type). However, that may or may not apply to
this set due to granularity concerns.

Does this make sense?

Thanks,
Song




>
> >
> > >   libbpf: add HID program type and API
> > >   libbpf: add new attach type BPF_HID_RDESC_FIXUP
> > >   libbpf: add new attach type BPF_HID_USER_EVENT
> > There 3 can merge, and maybe also the one below
> > >   libbpf: add handling for BPF_F_INSERT_HEAD in HID programs
>
> Yeah, the libbpf changes are small enough to not really justify
> separate patches.
>
> >
> > >   samples/bpf: add new hid_mouse example
> > >   samples/bpf: add a report descriptor fixup
> > >   samples/bpf: fix bpf_program__attach_hid() api change
> > Maybe it makes sense to merge these 3?
>
> Sure, why not.
>
> >
> > >   bpf/hid: add hid_{get|set}_data helpers
> > >   HID: bpf: implement hid_bpf_get|set_data
> > >   bpf/hid: add bpf_hid_raw_request helper function
> > >   HID: add implementation of bpf_hid_raw_request
> > We can have 1 or 2 patches for these helpers
>
> OK, the patches should be self-contained enough.
>
> >
> > >   selftests/bpf: add tests for the HID-bpf initial implementation
> > >   selftests/bpf: add report descriptor fixup tests
> > >   selftests/bpf: add tests for hid_{get|set}_data helpers
> > >   selftests/bpf: add test for user call of HID bpf programs
> > >   selftests/bpf: hid: rely on uhid event to know if a test device is
> > >     ready
> > >   selftests/bpf: add tests for bpf_hid_hw_request
> > >   selftests/bpf: Add a test for BPF_F_INSERT_HEAD
> > These selftests could also merge into 1 or 2 patches I guess.
>
> I'd still like to link them to the granularity of the bpf changes, so
> I can refer a selftest change to a specific commit/functionality
> added. But that's just my personal taste, and I can be convinced
> otherwise. This should give us maybe 4 patches instead of 7.
>
> >
> > I understand rearranging these patches may take quite some effort.
> > But I do feel that's a cleaner approach (from someone doesn't know
> > much about HID). If you really hate it that way, we can discuss...
> >
>
> No worries. I don't mind iterating on the series. IIRC I already
> rewrote it twice from scratch, and that's when the selftests I
> introduced in the second rewrite were tremendously helpful :) And
> honestly I don't think it'll be too much effort to reorder/squash the
> patches given that the v2 is *very* granular.
>
> Anyway, I prefer having the reviewers happy so we can have a solid
> rock API from day 1 than keeping it obscure for everyone and having to
> deal with design issues forever. So if it takes 10 or 20 revisions to
> have everybody on the same page, that's fine with me (not that I want
> to have that many revisions, just that I won't be afraid of the
> bikeshedding we might have at some point).
>
> Cheers,
> Benjamin
>
