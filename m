Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBDE4CE42C
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 11:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbiCEKY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 05:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiCEKY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 05:24:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF6F01C7EAF
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 02:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646475817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hvf1qgX47UJYQeYWAdFBUDBszqQVNdTtkeMXNOzeWN0=;
        b=SOlq9/wY2idMV3sDpkplXowNyaRsQG6bouMgMofvcQg+lkQ5JvvXOPOD/H3zusn8q9Hc4M
        muobeDQIJNxjk7vL9ZFeVm7+7P/9ytMst1vWSRsL3uIqyZQq8HgjNyi4K+02bwcZ+tFf3U
        y9cTdw++P3viapC/cr8skJcjlOpxbs4=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-jMS2jxVrOse03Z55IydDpg-1; Sat, 05 Mar 2022 05:23:36 -0500
X-MC-Unique: jMS2jxVrOse03Z55IydDpg-1
Received: by mail-pf1-f199.google.com with SMTP id y27-20020aa7943b000000b004f6decccdb5so244369pfo.1
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 02:23:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hvf1qgX47UJYQeYWAdFBUDBszqQVNdTtkeMXNOzeWN0=;
        b=2yPh/upalAw1IkZYCCfZhYWBYGFTwvZJloPpCv0mllMdBpeWfLVlttXWrHS6/UjZLV
         h50RFk/w89pYgVf+QAI5sje843Wzn+9adCYkr71JRdm6NSGF8vcirghP7/gohUPzg6Pd
         wrbuBFE310IRSKxBDMeXk7iewH7HGHK09Ry9AYwcd61pnanxCdplv0GKaKHnFzV1w/Wm
         t2EX4DaBlNwKR/A0hjZJc+dnX+hpjlRQJiDWW6vcNIUiTvxdbqfkchdD9gNJRD9lnTpt
         HRwtlYYVRz9L7dxHw3Y7lE19vgBBYYuAR9RrLSmSes127i16f8D1Kcm42IL1+wZtcXg3
         nByw==
X-Gm-Message-State: AOAM530Qzoncagt8mP4nJRQmSZZMJGglct9dy3ecso/1QtRyJnKc+cOW
        kgWnocJlP9zbVnfKwecdq/6ACixR7vbMtM5dDzHxFppsSEHplGHSjX5UgDAwV+qAFcJPdCsXnoA
        hmmdJfXC50a2nkHCAWeeOukMJCJLszP5g
X-Received: by 2002:a63:5110:0:b0:374:2312:1860 with SMTP id f16-20020a635110000000b0037423121860mr2273156pgb.146.1646475814775;
        Sat, 05 Mar 2022 02:23:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5ZMd0uYusP/CiqUmEnrtnVqF5GUNOPwSIzFTbtcHGF3xaobFFlMvqPEEOWLQmwDs9YoDqL5XyWqlpO7HeEtI=
X-Received: by 2002:a63:5110:0:b0:374:2312:1860 with SMTP id
 f16-20020a635110000000b0037423121860mr2273127pgb.146.1646475814245; Sat, 05
 Mar 2022 02:23:34 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <CAPhsuW5APYjoZWKDkZ9CBZzaF0NfSQQ-OeZSJgDa=wB-5O+Wng@mail.gmail.com>
In-Reply-To: <CAPhsuW5APYjoZWKDkZ9CBZzaF0NfSQQ-OeZSJgDa=wB-5O+Wng@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Sat, 5 Mar 2022 11:23:23 +0100
Message-ID: <CAO-hwJJkhxDAhT_cwo=Tkx8_=B-MuS=_enByj1t6GEuXD9Lj5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/28] Introduce eBPF support for HID devices
To:     Song Liu <song@kernel.org>
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
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Song,

Thanks a lot for the review.

I'll comment on the review in more details next week, but I have a
quick question here:

On Sat, Mar 5, 2022 at 2:14 AM Song Liu <song@kernel.org> wrote:
>
> On Fri, Mar 4, 2022 at 9:29 AM Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > Hi,
> >
> > This is a followup of my v1 at [0].
> >
> > The short summary of the previous cover letter and discussions is that
> > HID could benefit from BPF for the following use cases:
> >
> > - simple fixup of report descriptor:
> >   benefits are faster development time and testing, with the produced
> >   bpf program being shipped in the kernel directly (the shipping part
> >   is *not* addressed here).
> >
> > - Universal Stylus Interface:
> >   allows a user-space program to define its own kernel interface
> >
> > - Surface Dial:
> >   somehow similar to the previous one except that userspace can decide
> >   to change the shape of the exported device
> >
> > - firewall:
> >   still partly missing there, there is not yet interception of hidraw
> >   calls, but it's coming in a followup series, I promise
> >
> > - tracing:
> >   well, tracing.
> >
> >
> > I tried to address as many comments as I could and here is the short log
> > of changes:
> >
> > v2:
> > ===
> >
> > - split the series by subsystem (bpf, HID, libbpf, selftests and
> >   samples)
> >
> > - Added an extra patch at the beginning to not require CAP_NET_ADMIN for
> >   BPF_PROG_TYPE_LIRC_MODE2 (please shout if this is wrong)
> >
> > - made the bpf context attached to HID program of dynamic size:
> >   * the first 1 kB will be able to be addressed directly
> >   * the rest can be retrieved through bpf_hid_{set|get}_data
> >     (note that I am definitivey not happy with that API, because there
> >     is part of it in bits and other in bytes. ouch)
> >
> > - added an extra patch to prevent non GPL HID bpf programs to be loaded
> >   of type BPF_PROG_TYPE_HID
> >   * same here, not really happy but I don't know where to put that check
> >     in verifier.c
> >
> > - added a new flag BPF_F_INSERT_HEAD for BPF_LINK_CREATE syscall when in
> >   used with HID program types.
> >   * this flag is used for tracing, to be able to load a program before
> >     any others that might already have been inserted and that might
> >     change the data stream.
> >
> > Cheers,
> > Benjamin
> >
>
> The set looks good so far. I will review the rest later.
>
> [...]
>
> A quick note about how we organize these patches. Maybe we can
> merge some of these patches like:

Just to be sure we are talking about the same thing: you mean squash
the patch together?

>
> >   bpf: introduce hid program type
> >   bpf/hid: add a new attach type to change the report descriptor
> >   bpf/hid: add new BPF type to trigger commands from userspace
> I guess the three can merge into one.
>
> >   HID: hook up with bpf
> >   HID: allow to change the report descriptor from an eBPF program
> >   HID: bpf: compute only the required buffer size for the device
> >   HID: bpf: only call hid_bpf_raw_event() if a ctx is available
> I haven't read through all of them, but I guess they can probably merge
> as well.

There are certainly patches that we could squash together (3 and 4
from this list into the previous ones), but I'd like to keep some sort
of granularity here to not have a patch bomb that gets harder to come
back later.

>
> >   libbpf: add HID program type and API
> >   libbpf: add new attach type BPF_HID_RDESC_FIXUP
> >   libbpf: add new attach type BPF_HID_USER_EVENT
> There 3 can merge, and maybe also the one below
> >   libbpf: add handling for BPF_F_INSERT_HEAD in HID programs

Yeah, the libbpf changes are small enough to not really justify
separate patches.

>
> >   samples/bpf: add new hid_mouse example
> >   samples/bpf: add a report descriptor fixup
> >   samples/bpf: fix bpf_program__attach_hid() api change
> Maybe it makes sense to merge these 3?

Sure, why not.

>
> >   bpf/hid: add hid_{get|set}_data helpers
> >   HID: bpf: implement hid_bpf_get|set_data
> >   bpf/hid: add bpf_hid_raw_request helper function
> >   HID: add implementation of bpf_hid_raw_request
> We can have 1 or 2 patches for these helpers

OK, the patches should be self-contained enough.

>
> >   selftests/bpf: add tests for the HID-bpf initial implementation
> >   selftests/bpf: add report descriptor fixup tests
> >   selftests/bpf: add tests for hid_{get|set}_data helpers
> >   selftests/bpf: add test for user call of HID bpf programs
> >   selftests/bpf: hid: rely on uhid event to know if a test device is
> >     ready
> >   selftests/bpf: add tests for bpf_hid_hw_request
> >   selftests/bpf: Add a test for BPF_F_INSERT_HEAD
> These selftests could also merge into 1 or 2 patches I guess.

I'd still like to link them to the granularity of the bpf changes, so
I can refer a selftest change to a specific commit/functionality
added. But that's just my personal taste, and I can be convinced
otherwise. This should give us maybe 4 patches instead of 7.

>
> I understand rearranging these patches may take quite some effort.
> But I do feel that's a cleaner approach (from someone doesn't know
> much about HID). If you really hate it that way, we can discuss...
>

No worries. I don't mind iterating on the series. IIRC I already
rewrote it twice from scratch, and that's when the selftests I
introduced in the second rewrite were tremendously helpful :) And
honestly I don't think it'll be too much effort to reorder/squash the
patches given that the v2 is *very* granular.

Anyway, I prefer having the reviewers happy so we can have a solid
rock API from day 1 than keeping it obscure for everyone and having to
deal with design issues forever. So if it takes 10 or 20 revisions to
have everybody on the same page, that's fine with me (not that I want
to have that many revisions, just that I won't be afraid of the
bikeshedding we might have at some point).

Cheers,
Benjamin

