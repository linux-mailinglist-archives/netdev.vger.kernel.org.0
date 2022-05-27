Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9420B535A52
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344774AbiE0H0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiE0H0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:26:10 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F04ED712;
        Fri, 27 May 2022 00:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653636369; x=1685172369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m9FnLkDwI5TzcSgqoWXZ2q0oPNaLPL+CBbjsM4Rg7Ew=;
  b=M0RUyGG0tEjDgD1EYBOB59FHKDtWf0vWya8YXIgw33vYDt4V84YEioc1
   3WfRIPtGGeGjLZQ4rR4Lf3rCxU5KfyTdCvFjE57tLEFxCsh3G9778g312
   FvvG9EJFs1So7QYJgu0FQ8Ws4a4k93G8V1kIy4WrQz3CUlfWfcZwcT4cR
   gymGWRvVf+PQ4gqzryk/ddugYsHcXHxcONClGlh8MP6IevF6XlMrBtql+
   ERSehEETe2+pISRONEeMUs25HZHsgPPC2C11O8Pl3KhytOFq15y4XnKAK
   pkPJMCCvm4dlC9I86fCD8/Oi7IGn1V75kMTEdancpCN99yX8ToJ6pMD6A
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="274134971"
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="274134971"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 00:26:08 -0700
X-IronPort-AV: E=Sophos;i="5.91,254,1647327600"; 
   d="scan'208";a="718734751"
Received: from rrubin1x-mobl.amr.corp.intel.com (HELO [10.252.55.90]) ([10.252.55.90])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 00:26:03 -0700
Message-ID: <799ae406-ce12-f0d4-d213-4dd455236e49@linux.intel.com>
Date:   Fri, 27 May 2022 10:26:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
From:   Tero Kristo <tero.kristo@linux.intel.com>
In-Reply-To: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Benjamin,

I noticed a couple of issues with this series, but was able to 
fix/workaround them locally and got my USI program working with it.

1) You seem to be missing tools/include/uapi/linux/hid_bpf.h from index, 
I wasn't able to compile the selftests (or my own program) without 
adding this. It is included from 
tools/testing/selftests/bpf/prog_tests/hid.c: #include <linux/hid_bpf.h>

2) The limitation of needing to hardcode the size for hid_bpf_get_data() 
seems somewhat worrying, especially as the kernel side limits this to 
the ctx->allocated_size. I used a sufficiently large number for my 
purposes for now (256) which seems to work, but how should I handle my 
case where I basically need to read the whole input report and parse 
certain portions of it? How does the HID subsystem select the size of 
the ctx->allocated_size?

-Tero

On 18/05/2022 23:59, Benjamin Tissoires wrote:
> Hi,
>
> And here comes the v5 of the HID-BPF series.
>
> I managed to achive the same functionalities than v3 this time.
> Handling per-device BPF program was "interesting" to say the least,
> but I don't know if we can have a generic BPF way of handling such
> situation.
>
> The interesting bits is that now the BPF core changes are rather small,
> and I am mostly using existing facilities.
> I didn't managed to write selftests for the RET_PTR_TO_MEM kfunc,
> because I can not call kmalloc while in a SEC("tc") program to match
> what the other kfunc tests are doing.
> And AFAICT, the most interesting bits would be to implement verifier
> selftests, which are way out of my league, given that they are
> implemented as plain bytecode.
>
> The logic is the following (see also the last patch for some more
> documentation):
> - hid-bpf first preloads a BPF program in the kernel that does a few
>    things:
>     * find out which attach_btf_id are associated with our trace points
>     * adds a bpf_tail_call() BPF program that I can use to "call" any
>       other BPF program stored into a jump table
>     * monitors the releases of struct bpf_prog, and when there are no
>       other users than us, detach the bpf progs from the HID devices
> - users then declare their tracepoints and then call
>    hid_bpf_attach_prog() in a SEC("syscall") program
> - hid-bpf then calls multiple time the bpf_tail_call() program with a
>    different index in the jump table whenever there is an event coming
>    from a matching HID device
>
> Note that I am tempted to pin an "attach_hid_program" in the bpffs so
> that users don't need to declare one, but I am afraid this will be one
> more API to handle, so maybe not.
>
> I am also wondering if I should not strip out hid_bpf_jmp_table of most
> of its features and implement everything as a BPF program. This might
> remove the need to add the kernel light skeleton implementations of map
> modifications, and might also possibly be more re-usable for other
> subsystems. But every plan I do in my head involves a lot of back and
> forth between the kernel and BPF to achieve the same, which doesn't feel
> right. The tricky part is the RCU list of programs that is stored in each
> device and also the global state of the jump table.
> Anyway, something to look for in a next version if there is a push for it.
>
> FWIW, patch 1 is something I'd like to get merged sooner. With 2
> colleagues, we are also working on supporting the "revoke" functionality
> of a fd for USB and for hidraw. While hidraw can be emulated with the
> current features, we need the syscall kfuncs for USB, because when we
> revoke a USB access, we also need to kick out the user, and for that, we
> need to actually execute code in the kernel from a userspace event.
>
> Anyway, happy reviewing.
>
> Cheers,
> Benjamin
>
> [Patch series based on commit 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
> in the bpf-next tree]
>
> Benjamin Tissoires (17):
>    bpf/btf: also allow kfunc in tracing and syscall programs
>    bpf/verifier: allow kfunc to return an allocated mem
>    bpf: prepare for more bpf syscall to be used from kernel and user
>      space.
>    libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
>    HID: core: store the unique system identifier in hid_device
>    HID: export hid_report_type to uapi
>    HID: initial BPF implementation
>    selftests/bpf: add tests for the HID-bpf initial implementation
>    HID: bpf: allocate data memory for device_event BPF programs
>    selftests/bpf/hid: add test to change the report size
>    HID: bpf: introduce hid_hw_request()
>    selftests/bpf: add tests for bpf_hid_hw_request
>    HID: bpf: allow to change the report descriptor
>    selftests/bpf: add report descriptor fixup tests
>    samples/bpf: add new hid_mouse example
>    selftests/bpf: Add a test for BPF_F_INSERT_HEAD
>    Documentation: add HID-BPF docs
>
>   Documentation/hid/hid-bpf.rst                 | 528 ++++++++++
>   Documentation/hid/index.rst                   |   1 +
>   drivers/hid/Kconfig                           |   2 +
>   drivers/hid/Makefile                          |   2 +
>   drivers/hid/bpf/Kconfig                       |  19 +
>   drivers/hid/bpf/Makefile                      |  11 +
>   drivers/hid/bpf/entrypoints/Makefile          |  88 ++
>   drivers/hid/bpf/entrypoints/README            |   4 +
>   drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  78 ++
>   .../hid/bpf/entrypoints/entrypoints.lskel.h   | 782 ++++++++++++++
>   drivers/hid/bpf/hid_bpf_dispatch.c            | 565 ++++++++++
>   drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
>   drivers/hid/bpf/hid_bpf_jmp_table.c           | 587 +++++++++++
>   drivers/hid/hid-core.c                        |  43 +-
>   include/linux/btf.h                           |   7 +
>   include/linux/hid.h                           |  29 +-
>   include/linux/hid_bpf.h                       | 144 +++
>   include/uapi/linux/hid.h                      |  12 +
>   include/uapi/linux/hid_bpf.h                  |  25 +
>   kernel/bpf/btf.c                              |  47 +-
>   kernel/bpf/syscall.c                          |  10 +-
>   kernel/bpf/verifier.c                         |  72 +-
>   samples/bpf/.gitignore                        |   1 +
>   samples/bpf/Makefile                          |  23 +
>   samples/bpf/hid_mouse.bpf.c                   | 134 +++
>   samples/bpf/hid_mouse.c                       | 157 +++
>   tools/lib/bpf/skel_internal.h                 |  23 +
>   tools/testing/selftests/bpf/config            |   3 +
>   tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
>   tools/testing/selftests/bpf/progs/hid.c       | 222 ++++
>   30 files changed, 4593 insertions(+), 44 deletions(-)
>   create mode 100644 Documentation/hid/hid-bpf.rst
>   create mode 100644 drivers/hid/bpf/Kconfig
>   create mode 100644 drivers/hid/bpf/Makefile
>   create mode 100644 drivers/hid/bpf/entrypoints/Makefile
>   create mode 100644 drivers/hid/bpf/entrypoints/README
>   create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
>   create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
>   create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
>   create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
>   create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
>   create mode 100644 include/linux/hid_bpf.h
>   create mode 100644 include/uapi/linux/hid_bpf.h
>   create mode 100644 samples/bpf/hid_mouse.bpf.c
>   create mode 100644 samples/bpf/hid_mouse.c
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
>   create mode 100644 tools/testing/selftests/bpf/progs/hid.c
>
