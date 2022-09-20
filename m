Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C605B5BE76B
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbiITNoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiITNoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:44:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8038A3F1EC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663681448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vwW7t8MPa7zeKiTEgnAftOAZBeq2iD70Wyn142D/zRo=;
        b=SClir3dq9ieDg7GzdeVhk3z8wn69SXG5Za2e9Tpolj3w/M9cVkavVKQ/qBcXJuLLqDDlYs
        Zj4dMrCFUH1iSeE/su+Eijma+w6g5opW7yzC8v6IiRx51k/kSuAXuRyTGTAhyzGmpmPwb9
        UHoeh7OZmlABBKZZrmgnKeTdT5/gNqI=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-9-CLgvOX5HN-WdbeOh727qTw-1; Tue, 20 Sep 2022 09:44:07 -0400
X-MC-Unique: CLgvOX5HN-WdbeOh727qTw-1
Received: by mail-pf1-f197.google.com with SMTP id g15-20020aa7874f000000b0053e8b9630c7so1736599pfo.19
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=vwW7t8MPa7zeKiTEgnAftOAZBeq2iD70Wyn142D/zRo=;
        b=7/RmnZ38L595K4qbkYFnvvgzHKqQa3fVhPRQJRIxUDreYGUB/EZRh0Qubu5Rbj+3+M
         aStdWrl+EZ88eg2sUzSWPPmEt/KnGXtTMOzxcf5eCLEIXyNPnypG6UCixjUoBgJvL7Xy
         4UhUEpGa3Gat1qRbLTH/ckGhPFIOIU9/vtEgi+bStQN7VqwLiR2n+Zg4dzw7eKEP+3H8
         bupj1yES9S5hkqdpu4Hd/d0L97HNXWK+U0uRJraK/V5sH3fPraXo2bfqFA6VKl5tDyBh
         q3IAWXQ4IxpaWcFVUR2NzNzzjfUVGkN/5l8NpLTsyyzgP1yV9g3+U0vAAfe7SgWX6Cf5
         /pzg==
X-Gm-Message-State: ACrzQf38cGnkie9G9gB4L6LMtFdh9uIjSysMZ2FH41zzYEzYUs5e6llP
        ru1KtEgF3hhqGHam0DHVa8s8FaRHFf/ZVKaIRY9aVBFT7rHe3bhmPjLWT2ZjJjgAGsm4OPB4P5G
        bjMw1Et0uW+qjd8bCBjp/Vsz3EYanDYmM
X-Received: by 2002:a17:90a:f28b:b0:203:627c:7ba1 with SMTP id fs11-20020a17090af28b00b00203627c7ba1mr4063187pjb.191.1663681446406;
        Tue, 20 Sep 2022 06:44:06 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM61euhDYViIzDlUs4Ah/OZb3hFvXIlLEfl5ptqxt1gkv1vD4Ica+puVs5gjlf6riTd8NcMoul6d/R4nLAKpoCo=
X-Received: by 2002:a17:90a:f28b:b0:203:627c:7ba1 with SMTP id
 fs11-20020a17090af28b00b00203627c7ba1mr4063163pjb.191.1663681446067; Tue, 20
 Sep 2022 06:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 20 Sep 2022 15:43:55 +0200
Message-ID: <CAO-hwJ+GxSHKf-zCNg-WM_5+o2B94n4=AXGwz-tfipS_+YpK+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 00/23] Introduce eBPF support for HID devices
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 3:29 PM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi,
>
> here comes the v10 of the HID-BPF series.
>
> Again, for a full explanation of HID-BPF, please refer to the last patch
> in this series (23/23).
>
> Hopefully we are getting closer to merging the bpf-core changes that
> are pre-requesite of the HID work.
>
> This revision of the series focused on those bpf-core changes with
> a hopefully proper way of fixing access to ctx pointers, and a few more
> selftests to cover those changes.
>
> Once those bpf changes are in, the HID changes are pretty much self
> consistent, which is a good thing, but I still wonder how we are going
> to merge the selftests. I'd rather have the selftests in the bpf tree to
> prevent any regression on bpf-core changes, but that might require some
> coordination between the HID and bpf trees.
>
> Anyway, let's hope we are getting closer to the end of those revisions :)

FWIW, I have now applied the HID patches 8, 9, and 10 to hid.git. They
are independent of the bpf work and given how close we are to 6.1, we
can take them just now.
Patch 11 is having a conflict with the HID tree, so I'll need to
handle it in v11 for the HID part.

The first few patches have already been applied in the bpf-next tree,
as part of the v11 subset of those patches.

The plan is now to wait for all of these to land in 6.1-rc1, and then
submit only the HID changes as a followup series for 6.2.

Cheers,
Benjamin

>
> Cheers,
> Benjamin
>
>
> Benjamin Tissoires (23):
>   selftests/bpf: regroup and declare similar kfuncs selftests in an
>     array
>   bpf: split btf_check_subprog_arg_match in two
>   bpf/verifier: allow all functions to read user provided context
>   selftests/bpf: add test for accessing ctx from syscall program type
>   bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
>   bpf/verifier: allow kfunc to return an allocated mem
>   selftests/bpf: Add tests for kfunc returning a memory pointer
>   HID: core: store the unique system identifier in hid_device
>   HID: export hid_report_type to uapi
>   HID: convert defines of HID class requests into a proper enum
>   HID: Kconfig: split HID support and hid-core compilation
>   HID: initial BPF implementation
>   selftests/bpf: add tests for the HID-bpf initial implementation
>   HID: bpf: allocate data memory for device_event BPF programs
>   selftests/bpf/hid: add test to change the report size
>   HID: bpf: introduce hid_hw_request()
>   selftests/bpf: add tests for bpf_hid_hw_request
>   HID: bpf: allow to change the report descriptor
>   selftests/bpf: add report descriptor fixup tests
>   selftests/bpf: Add a test for BPF_F_INSERT_HEAD
>   samples/bpf: HID: add new hid_mouse example
>   samples/bpf: HID: add Surface Dial example
>   Documentation: add HID-BPF docs
>
>  Documentation/hid/hid-bpf.rst                 | 513 +++++++++
>  Documentation/hid/index.rst                   |   1 +
>  drivers/Makefile                              |   2 +-
>  drivers/hid/Kconfig                           |  20 +-
>  drivers/hid/Makefile                          |   2 +
>  drivers/hid/bpf/Kconfig                       |  17 +
>  drivers/hid/bpf/Makefile                      |  11 +
>  drivers/hid/bpf/entrypoints/Makefile          |  93 ++
>  drivers/hid/bpf/entrypoints/README            |   4 +
>  drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
>  .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++
>  drivers/hid/bpf/hid_bpf_dispatch.c            | 526 ++++++++++
>  drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
>  drivers/hid/bpf/hid_bpf_jmp_table.c           | 577 ++++++++++
>  drivers/hid/hid-core.c                        |  49 +-
>  include/linux/bpf.h                           |  11 +-
>  include/linux/bpf_verifier.h                  |   2 +
>  include/linux/btf.h                           |  10 +
>  include/linux/hid.h                           |  38 +-
>  include/linux/hid_bpf.h                       | 148 +++
>  include/uapi/linux/hid.h                      |  26 +-
>  include/uapi/linux/hid_bpf.h                  |  25 +
>  kernel/bpf/btf.c                              | 149 ++-
>  kernel/bpf/verifier.c                         |  66 +-
>  net/bpf/test_run.c                            |  37 +
>  samples/bpf/.gitignore                        |   2 +
>  samples/bpf/Makefile                          |  27 +
>  samples/bpf/hid_mouse.bpf.c                   | 134 +++
>  samples/bpf/hid_mouse.c                       | 161 +++
>  samples/bpf/hid_surface_dial.bpf.c            | 161 +++
>  samples/bpf/hid_surface_dial.c                | 232 ++++
>  tools/include/uapi/linux/hid.h                |  62 ++
>  tools/include/uapi/linux/hid_bpf.h            |  25 +
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  tools/testing/selftests/bpf/config            |   3 +
>  tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
>  .../selftests/bpf/prog_tests/kfunc_call.c     | 182 +++-
>  tools/testing/selftests/bpf/progs/hid.c       | 206 ++++
>  .../selftests/bpf/progs/kfunc_call_fail.c     | 160 +++
>  .../selftests/bpf/progs/kfunc_call_test.c     |  71 ++
>  40 files changed, 5416 insertions(+), 105 deletions(-)
>  create mode 100644 Documentation/hid/hid-bpf.rst
>  create mode 100644 drivers/hid/bpf/Kconfig
>  create mode 100644 drivers/hid/bpf/Makefile
>  create mode 100644 drivers/hid/bpf/entrypoints/Makefile
>  create mode 100644 drivers/hid/bpf/entrypoints/README
>  create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
>  create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
>  create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
>  create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
>  create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
>  create mode 100644 include/linux/hid_bpf.h
>  create mode 100644 include/uapi/linux/hid_bpf.h
>  create mode 100644 samples/bpf/hid_mouse.bpf.c
>  create mode 100644 samples/bpf/hid_mouse.c
>  create mode 100644 samples/bpf/hid_surface_dial.bpf.c
>  create mode 100644 samples/bpf/hid_surface_dial.c
>  create mode 100644 tools/include/uapi/linux/hid.h
>  create mode 100644 tools/include/uapi/linux/hid_bpf.h
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/hid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c
>
> --
> 2.36.1
>

