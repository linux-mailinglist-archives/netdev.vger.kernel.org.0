Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E7A4CE1D2
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 02:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiCEBO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 20:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiCEBO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 20:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A57222452A;
        Fri,  4 Mar 2022 17:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1478D61760;
        Sat,  5 Mar 2022 01:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6C9C340F3;
        Sat,  5 Mar 2022 01:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646442848;
        bh=vaBaHCp9DaFEapWiEZFao3YLd11lfyjPtyNq2m5VXs4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=c5/LqdcZfLOG1K7x4z+crxSvHxys5Zkw7f9QXyqpzs26ZTePy8t+0WwfcqMrN/+bL
         7OU3ZWZcPFSiJEdUWxHxUilezuEjcF4oQsSLWZDefw7RU7+yQf6JYFeBiiFwNpBL+5
         zheDWBqq8w34KXW1DeQAcMPyVzSlLEo/C5OUqeffQlUhhh+OQpkVI0aMAEyQVvGbcx
         090qHvUTuLVHE08zvSEF4KwMRunGPqFd4srcdIieMD2n5NJ9xHH/NMUk5w1fQb/HQ6
         9b+o7Dum29DB5legGE+aLzgcZ9HbFaFQmb4t6kAzbVMOL7UCGJcFGpDC4c8PC+k3jU
         14wIbWL4XQElw==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2dc28791ecbso96077867b3.4;
        Fri, 04 Mar 2022 17:14:08 -0800 (PST)
X-Gm-Message-State: AOAM530yzNX9zSgQtcryoFISWLCal/6lCu7vaUOsPUktTI/EPz/VN4+h
        aCZR/6uH6VpYMtFQ6xl3bUTbHHS7OYrGElk8Ud8=
X-Google-Smtp-Source: ABdhPJwbMS+4wemss6vJVt55VmA2cZt2K+EUmtlozCbIK6ZzqQVPdiXo3ZGnJj6Y4ZRvYCbj3HqANRXxoQbmZCW59R8=
X-Received: by 2002:a81:23ce:0:b0:2dc:b20:cc73 with SMTP id
 j197-20020a8123ce000000b002dc0b20cc73mr1211954ywj.130.1646442847422; Fri, 04
 Mar 2022 17:14:07 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 4 Mar 2022 17:13:56 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5APYjoZWKDkZ9CBZzaF0NfSQQ-OeZSJgDa=wB-5O+Wng@mail.gmail.com>
Message-ID: <CAPhsuW5APYjoZWKDkZ9CBZzaF0NfSQQ-OeZSJgDa=wB-5O+Wng@mail.gmail.com>
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
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 4, 2022 at 9:29 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi,
>
> This is a followup of my v1 at [0].
>
> The short summary of the previous cover letter and discussions is that
> HID could benefit from BPF for the following use cases:
>
> - simple fixup of report descriptor:
>   benefits are faster development time and testing, with the produced
>   bpf program being shipped in the kernel directly (the shipping part
>   is *not* addressed here).
>
> - Universal Stylus Interface:
>   allows a user-space program to define its own kernel interface
>
> - Surface Dial:
>   somehow similar to the previous one except that userspace can decide
>   to change the shape of the exported device
>
> - firewall:
>   still partly missing there, there is not yet interception of hidraw
>   calls, but it's coming in a followup series, I promise
>
> - tracing:
>   well, tracing.
>
>
> I tried to address as many comments as I could and here is the short log
> of changes:
>
> v2:
> ===
>
> - split the series by subsystem (bpf, HID, libbpf, selftests and
>   samples)
>
> - Added an extra patch at the beginning to not require CAP_NET_ADMIN for
>   BPF_PROG_TYPE_LIRC_MODE2 (please shout if this is wrong)
>
> - made the bpf context attached to HID program of dynamic size:
>   * the first 1 kB will be able to be addressed directly
>   * the rest can be retrieved through bpf_hid_{set|get}_data
>     (note that I am definitivey not happy with that API, because there
>     is part of it in bits and other in bytes. ouch)
>
> - added an extra patch to prevent non GPL HID bpf programs to be loaded
>   of type BPF_PROG_TYPE_HID
>   * same here, not really happy but I don't know where to put that check
>     in verifier.c
>
> - added a new flag BPF_F_INSERT_HEAD for BPF_LINK_CREATE syscall when in
>   used with HID program types.
>   * this flag is used for tracing, to be able to load a program before
>     any others that might already have been inserted and that might
>     change the data stream.
>
> Cheers,
> Benjamin
>

The set looks good so far. I will review the rest later.

[...]

A quick note about how we organize these patches. Maybe we can
merge some of these patches like:

>   bpf: introduce hid program type
>   bpf/hid: add a new attach type to change the report descriptor
>   bpf/hid: add new BPF type to trigger commands from userspace
I guess the three can merge into one.

>   HID: hook up with bpf
>   HID: allow to change the report descriptor from an eBPF program
>   HID: bpf: compute only the required buffer size for the device
>   HID: bpf: only call hid_bpf_raw_event() if a ctx is available
I haven't read through all of them, but I guess they can probably merge
as well.

>   libbpf: add HID program type and API
>   libbpf: add new attach type BPF_HID_RDESC_FIXUP
>   libbpf: add new attach type BPF_HID_USER_EVENT
There 3 can merge, and maybe also the one below
>   libbpf: add handling for BPF_F_INSERT_HEAD in HID programs

>   samples/bpf: add new hid_mouse example
>   samples/bpf: add a report descriptor fixup
>   samples/bpf: fix bpf_program__attach_hid() api change
Maybe it makes sense to merge these 3?

>   bpf/hid: add hid_{get|set}_data helpers
>   HID: bpf: implement hid_bpf_get|set_data
>   bpf/hid: add bpf_hid_raw_request helper function
>   HID: add implementation of bpf_hid_raw_request
We can have 1 or 2 patches for these helpers

>   selftests/bpf: add tests for the HID-bpf initial implementation
>   selftests/bpf: add report descriptor fixup tests
>   selftests/bpf: add tests for hid_{get|set}_data helpers
>   selftests/bpf: add test for user call of HID bpf programs
>   selftests/bpf: hid: rely on uhid event to know if a test device is
>     ready
>   selftests/bpf: add tests for bpf_hid_hw_request
>   selftests/bpf: Add a test for BPF_F_INSERT_HEAD
These selftests could also merge into 1 or 2 patches I guess.

I understand rearranging these patches may take quite some effort.
But I do feel that's a cleaner approach (from someone doesn't know
much about HID). If you really hate it that way, we can discuss...

Thanks,
Song
